# LANG spike — tick benchmark (C# vs GDScript)

One-day roadmap item 12 spike. Two equivalent implementations of one in-game
day-tick; the measured ratio feeds `docs/language-decision-v0.1.md`.

## What one "tick" does

One tick = one in-game day per `time-scale-decision-v0.1.md`
(day = daily macro tick + 5 sub-daily beats):

1. **Firms (daily):** profitability margin from 5 inputs (county wage index ×
   sector multiplier, corporate rate, logistics factor from roads condition
   45, seeded demand noise, policy constant), then the coupling-spec §1.5
   threshold chain: margin > +8% → openings, −5%..+2% → freeze,
   < −5% (2-day streak, compressed quarters) → layoffs, < −15% → close.
   Aggregate deltas convert to 0–1 lens slots via the §1.4 entitlement
   accumulator (E ±2.0 clamp, S = 1,000). Spawn pass: 2 attempts/day
   reactivate closed firms (M stays fixed).
2. **Placement pass:** exactly K churn events per tick (firm queue first,
   synthetic top-up to hold K constant). Openings scan the unemployed pool
   for the best in-shed candidate (longest unemployed, neediest, id tiebreak);
   layoffs pop strict LIFO off the firm roster; closes lay off whole rosters.
3. **Citizens:** per-day pseudo-commute (coupling §3.2 shape), then 5 beats.
   Each beat decays all 6 needs (appendix §3 rates ÷ 5), applies the beat
   restore (sleep/commute/work/leisure/home), clamps 0–100, and runs the 6
   threshold branches (job-hunt, hunger, fatigue, sickness, loneliness,
   aimlessness + nested critical flags). Daily close: weekly payday into the
   shared household budget, then the household-budget Money derivation
   (appendix §3 + coupling §2.3 ramp), then needs-driven quits.
4. **Macro (daily):** county employment aggregation over all N citizens,
   county wage-index update (coupling §2.1, ±3% clamp), one-line
   revenue/expense ledger.

Seeded RNG (xorshift32, hand-rolled identically in both languages — Godot has
no matching stream), fixed seed 12345. Determinism: each run builds the sim
twice from the seed and compares FNV-1a checksums over all citizen needs,
household funds, firm margins/headcounts/accumulators, wage indices, and
every counter. Exit code is 1 on mismatch.

## Reproduce

```sh
# C# (.NET 8 SDK, user-local install per the decision doc)
cd spikes/lang-tick-benchmark/csharp
export DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1 PATH="$HOME/.dotnet:$PATH"
dotnet run -c Release -- --n=5000 --m=500 --k=20 --ticks=10 --reps=5 --warmup=1 --seed=12345
dotnet run -c Release -- --n=20000 --m=3000 --k=130 --ticks=3 --reps=3 --warmup=1 --seed=12345

# GDScript (Godot 4.3 headless)
cd spikes/lang-tick-benchmark/gdscript
~/workspace/tools/godot/Godot_v4.3-stable_linux.x86_64 --headless --script benchmark.gd -- --n=5000 --m=500 --k=20 --ticks=10 --reps=5 --warmup=1 --seed=12345
~/workspace/tools/godot/Godot_v4.3-stable_linux.x86_64 --headless --script benchmark.gd -- --n=20000 --m=3000 --k=130 --ticks=3 --reps=3 --warmup=1 --seed=12345
```

Flags: `--n` citizens (must be even), `--m` firms, `--k` events/tick,
`--ticks` ticks/rep, `--reps` measured reps, `--warmup` uncounted reps,
`--seed`. Methodology: 1 warmup rep (JIT / caches), then N measured reps of
fresh-sim tick loops; reported metric is median ms/tick across reps
(C# Stopwatch, GDScript `Time.get_ticks_msec()`).

## Raw numbers (2026-10-08)

Hardware: 2× AMD EPYC 9D25 (~1.5 GHz slice of a shared VM), 8 GB RAM.
Toolchain: `dotnet --version` 8.0.425, Release via `dotnet run -c Release`;
Godot 4.3.stable.official.77dcf97d8 (`--headless --script`, `extends SceneTree`).

| Config | Warmup ms/tick | Rep ms/tick | Median | Checksum |
|---|---|---|---|---|
| C# 5k/500/K=20 | 1.653 | 0.812, 0.821, 0.937, 1.422, 2.224 | **0.937** | 6939B926 |
| GDScript 5k/500/K=20 | 22.500 | 22.900, 23.900, 24.100, 22.600, 22.300 | **22.900** | 6939B926 |
| C# 20k/3k/K=130 | 5.881 | 5.511, 2.316, 2.306 | **2.316** | D761495B |
| GDScript 20k/3k/K=130 | 82.000 | 81.333, 82.333, 85.000 | **82.333** | D761495B |

Ratios (same-hardware GDScript/C# medians): **~24x at 5k, ~36x at 20k/3k.**
Determinism: run1 = run2 in all four runs; cross-language checksums agree at
both configs (identical simulated trajectories, not just identical op counts).

> **HARD CAVEAT:** this VM is an AMD EPYC server CPU, not a Deck APU —
> absolute numbers are best-case; only the same-hardware ratio is
> decision-relevant. The C# rep spread (0.8→2.2 ms at 5k) is shared-VM jitter
> (GDScript reps on the same box hold ±5%); the median absorbs it, and ±2 ms
> of C# noise cannot move a ~24–36x ratio. The Phase 1 perf harness on
> Deck-class hardware remains the real gate (P11).

## Deliberate non-equivalences (shared by both benchmarks)

Vs the specs (same in both languages, so the ratio is unaffected):

- Entitlement accumulator is per-firm, not per-(county, sector) (same
  arithmetic and clamps, coarser grain).
- Firms decide daily, not weekly-staggered (roadmap item 12 prescribes daily
  firm updates; conservative = strictly more work than the shipped cadence).
- Households are fixed size 2 (spec: 1–4, mean ~2.4).
- Commute shed is a pseudo-geography parity test (`(a−b) % 9 < 6`), and
  commute distance is a pseudo-distance hash — not real geo coordinates.
- Closed firms are reactivated in-slot by the spawn pass (M fixed) instead of
  true spawns growing M.
- Layoff streak is 2 days (compressed quarters), not 2 quarters.
- Synthetic top-up events (1 slot each) hold K constant when the firm queue
  runs dry, so tick cost is comparable across ticks and configs.
- NOT in the tick (named unmeasured growth, all shared): attribution logging
  / cause-id records, demand + event machines, policy effect ticks, save/load
  serialization, amenity/sector matching, retirement/death processing.

Between languages (same ops, idiomatic containers):

- C#: struct arrays for citizens/households/firms, `List<int>` (pre-sized)
  for rosters + unemployed pool, `Stopwatch` timing, local functions.
- GDScript: packed struct-of-arrays (`PackedFloat64Array` / `PackedInt32Array`
  / `PackedByteArray`) with typed locals for hot state, plain `Array` for the
  growable queues (by-reference mutation semantics), `Time.get_ticks_msec()`.
- Both use `double` (64-bit) floats throughout with identical statement
  order, no libm calls — hence the bit-identical checksums.

## Files

- `csharp/csharp.csproj`, `csharp/Program.cs` — `dotnet new console` app.
- `gdscript/benchmark.gd` — headless script (`extends SceneTree`).

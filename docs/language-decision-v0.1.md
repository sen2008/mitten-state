# Language Decision v0.1 (Phase 0, LANG spike)

**DRAFT-NEEDS-LUCAS-REVIEW — paper only. No game code, no engine change, no GDD edit, no roadmap edit. Closes the GDD §18 / §22 "C# vs GDScript" open question, for Lucas to apply at lock.**

**Flags:** `[G]` = measured in this spike or taken from GDD / roadmap / a sibling v0.1 doc, with source named. `[NEEDS-P1]` = assumes the undecided win condition — appears nowhere as fact in this doc. `[NEEDS-LANG]` = language sub-decision this spike does NOT settle (C# hosting shape); Phase 1 entry work, flagged here only.

**Sources:** GDD §18 (the open question) + §22; ROADMAP Phase 0 item 12 + Decisions log (LANG, MAC) + Phase 1 item 9 + Phase 1/2 exits; review 3.3, 3.4.3, P11; all ten sibling v0.1 docs.

**Adopted (not decided):** 5k lens / 500 firms M0 scale, 20k/3k ceiling; day = daily macro tick + 5 sub-daily beats; six needs + household-budget Money rule; firm margin bands + entitlement accumulator; county wage index; straight-line commute; quarterly PC settlement; abstracted legislature; spawn-time faction membership; ≥2x headroom on Deck-class; measured-not-paper; Windows + Linux only.

---

## 1. The decision — DRAFT-NEEDS-LUCAS-REVIEW

The roadmap-approved one-day spike CONFIRMS the going-in lean — it does not overturn it: ship a **C# sim core** (tick loop, agents, placement pass, macro layer, determinism + state hashing, save/load serialization, Phase 1 perf harness) with **GDScript for UI, tools, and content glue** (all attribution surfaces, diorama staging, demand/event/policy authoring, data-file loading), behind the boundary rule that the sim exposes tick + query APIs and UI code never reaches into agent arrays per-frame `[G measured below; roadmap item 12 "the spike result wins"]`. On identical tick workloads — same N citizens, M firms, K churn events, same operation counts per agent, bit-identical FNV-1a state checksums across languages — C# (.NET 8 SDK, Release) ran the 5k-agent day-tick ~24x faster than idiomatic GDScript (typed, packed-array struct-of-arrays) and the 20k/3k ceiling day-tick ~36x faster; GDScript's absolute 82 ms/tick at ceiling cannot pass or fail P11 because it was measured on a server CPU, but the ratio is the decision — R4 (20k-agent perf on Deck) is a project-killing risk, and spending a ~30x performance factor on the sim core before M0 adds attribution logging, demand/event machines, policy ticks, and save serialization would trade the project's hardest constraint for single-language convenience, while the split keeps GDScript iteration speed exactly where iteration pays (UI/content) and the spike proves the C# toolchain cost is one-time and small (user-local SDK install, `dotnet run -c Release` just works).

| Config (seed 12345 `[G]`) | C# median ms/tick | GDScript median ms/tick | Ratio (GD/C#) | Checksums (run1 = run2, C# = GD) |
|---|---|---|---|---|
| 5k citizens / 500 firms / K=20, 10 ticks × (5 reps + 1 warmup) | 0.937 | 22.900 | ~24x | 6939B926 |
| 20k citizens / 3k firms / K=130, 3 ticks × (3 reps + 1 warmup) | 2.316 | 82.333 | ~36x | D761495B |

Toolchain `[G]`: `dotnet --version` = 8.0.425, build config Release via `dotnet run -c Release`; Godot = 4.3.stable.official.77dcf97d8 headless `--script`. CPU: 2× AMD EPYC 9D25. Full rep tables, exact commands, and the deliberate simplifications shared by both benchmarks live in `spikes/lang-tick-benchmark/README.md`.

> **HARD CAVEAT `[G]`:** this VM is an AMD EPYC server CPU, not a Deck APU — absolute milliseconds are best-case and certify nothing about Deck. The decision-relevant number is the same-hardware C#-vs-GDScript ratio (~24–36x). The Phase 1 perf harness on Deck-class hardware (perf-bar §1, roadmap Phase 1 item 9) remains the real gate — including for C#, which this spike shows is ~30x cheaper than the alternative, not that it passes P11.

## 2. Consistency checklist vs all eleven siblings — DRAFT-NEEDS-LUCAS-REVIEW

| Sibling | Took | Breaks if it changes |
|---|---|---|
| numbers-appendix | Six needs + per-game-day decays/restores + behavior threshold table (§3); household-budget Money derivation + the 30/60-day timers (§3); $900/wk pay + $400/wk-per-capita CoL via coupling §2.3 — the per-beat op mix the ratio is measured on | need count or decay units change (a 7th need, or per-second/per-frame rates instead of per-game-day); the Money rule flips from household derivation to per-citizen wallets (the daily money check — the benchmark's most expensive per-citizen line after beats — must be re-costed in both languages) |
| coupling-spec | Firm margin bands + hire/freeze/layoff/close triggers (§1.5); entitlement accumulator E ±2.0 at S = 1,000 (§1.4, per-firm grain — see benchmark README); county wage-index update (§2.1); commute + logistics functions (§3.2); hire-scan / LIFO / close semantics (§1.2); counts 5k/500 + 20k/3k and K = 20/130 event volumes (§5) | bands/thresholds move (branch mix changes — re-run, the ratio usually survives but the floor moves); LIFO/pool-matching replaced by an O(lens × firms) join (review 3.4.3's naive matching — placement stops being cheap and the K-event methodology must be redesigned); firm cadence moves weekly→per-frame (firm work ×7–100, re-measure) |
| time-scale | The tick under test: day = daily macro tick + 5 sub-daily beats; 45-s days at 1x, pause/1x/2x/4x with 2x cruise, as the wall-clock denominators behind the headroom framing | beats/day changes (per-tick citizen work scales linearly — the ratio survives, every absolute number moves); day length or the speed set changes (every tick-budget denominator in the P11 framing moves with it) |
| political-capital | PC as quarterly-settled state (base +10/qtr, four fixed-cost spends, no trickle) as the justification for EXCLUDING it from the benchmark tick — negligible cost by construction | PC gains per-beat/per-frame accrual or a fifth spend on the tick path (new unmeasured per-tick work — extend the benchmark before trusting the floor) |
| legislature | (a) abstraction = zero legislature object in the tick, as the justification for excluding it; campaign ×2 confined to approval deltas (ledger multiplier, not new work) | flip to (b) override-vote adds a per-tax-hike/per-reallocation gate to the tick path (small but unmeasured — extend the benchmark) |
| north-fix | (a) RECOMMENDED spawn-time membership rules (N1–N3) = zero per-tick cost, as the justification for excluding faction routing from the tick | flip to (b) rotation-aware demands adds a per-demand identity check on the tick-adjacent event machine (name it in the harness scenario; re-measure if it lands per-beat) |
| m1-rescope | 5k SE lens / ≤3k firms scaled to MEASURED headroom (never below ~500 SE-anchored) as the baseline config's authority; "counts follow measurement, not schedule" — this doc is a measurement input to that rule | slice counts raised without a harness re-run (headroom-gated scaling is the rule); cut #7 (firms → sector stats) taken silently (the measured tick would no longer be the shipped game) |
| attribution-ui | The sim logging contract (cause ids on every claim, headless precursor logging from M0, orphan-zero validation) as NAMED UNMEASURED GROWTH on top of the floor — the benchmark tick carries no log records, so every absolute number here is a lower bound | logging moves from event-append to per-beat/per-citizen scans (e.g., per-beat top-3-drivers recompute — the tick's logging line must be benchmarked, and the language ratio re-checked under string/record pressure, before M0 exit) |
| perf-bar | The bar this spike measures against: Deck is the minimum spec, fixed-cadence ticks decoupled from 60fps render, ≥2x headroom at 20k/3k, M0 measured-not-paper (§1); the LANG hook (§3: "the spike result decides") as this doc's authority | the headroom rule moves off ≥2x, Deck-class is redefined, or render fps re-enters the M0 gate (the pass/fail context around the ratio changes — the ratio itself stands, its sufficiency must be re-argued) |
| deletions | Language-independence of the deletions: internal JSON data files stay a file-format choice under any LANG outcome (this doc's §1 split changes the reader, never the format); ironman checkbox and the multiplayer deletion need no language | a public JSON modding schema is promised (adds a C#/GDScript API-surface decision this spike does not make); any multiplayer/compare mode re-admitted (tick gains a netcode line neither benchmark measures) |
| design-review-muse-code (background) | The question itself (GDD §18 open: C# vs GDScript) + the R4/3.3 framing (decouple tick from render, Deck is the bar) + the roadmap item 12 spike prescription (5k-agent tick in each language, spike result wins) | frozen background — no break condition; if a later review reframes R4 or the tick structure, this row's successors carry the delta |

`[NEEDS-P1]` hooks: none active. This decision holds under ANY win condition — sim-core speed and UI iteration speed do not depend on what winning means — and the unconfirmed "Midwest crown" proposal is assumed nowhere in this doc; it appears in this sentence only as the pending proposal, never as fact.

`[NEEDS-LANG]` follow-up (the one language question this spike does NOT settle): the C# hosting shape — a .NET-enabled Godot build (GodotSharp, same editor, standard export templates) vs a standalone .NET sim library driven headless with Godot as the renderer. The spike measured C# as a `dotnet console` app, which prices the language/runtime, not the interop; either hosting keeps the ~30x core-loop factor, and the pick is Phase 1 entry work (see §4 Q2).

## 3. Verify test — DRAFT-NEEDS-LUCAS-REVIEW

A fresh agent with the Godot 4.3 headless binary and a user-local .NET 8 SDK re-runs the two commands in `spikes/lang-tick-benchmark/README.md` (5k/500/K=20, 10 ticks × 5 reps + warmup; then 20k/3k/K=130, 3 ticks × 3 reps + warmup, seed 12345) and passes if and only if both binaries exit 0, the printed checksums reproduce EXACTLY (6939B926 at 5k, D761495B at 20k — in BOTH languages, proving the workloads are still equivalent), and C# median ms/tick beats GDScript median by more than 10x on the same box (the measured 24–36x has margin for noisy hardware); a checksum mismatch in either language fails equivalence first — do not trust the ratio until the checksums agree — and a sub-10x ratio on quiet hardware fails the decision's evidence, not the decision, so re-measure before re-arguing.

## 4. Direct questions for Lucas — DRAFT-NEEDS-LUCAS-REVIEW

1. Confirm the C# sim core / GDScript UI split as the LANG lock?
2. `[NEEDS-LANG]` C# hosting shape: .NET-enabled Godot build (GodotSharp) vs standalone .NET sim + Godot renderer — pick now, or leave to Phase 1 entry?
3. Phase 1 harness hardware: an actual Steam Deck, or a named Deck-equivalent APU box — which will you bless as Deck-class?
4. If the Phase 1 harness shows even C# missing the ≥2x rule at ceiling, which re-scope first: fewer agents, simpler tick, or diorama-concentrated peeps?
5. Internal JSON content files stay byte-identical under C# (new reader, same files) — confirm no format change rides with LANG?

Locked scope (recited once): Windows + Linux only (macOS cut), Steam Deck is the perf bar, $24.99 premium, mouse-first.

**DRAFT-NEEDS-LUCAS-REVIEW — end of v0.1.**

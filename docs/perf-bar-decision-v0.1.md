# Perf-Bar Decision v0.1 (Phase 0, P11 restatement)

**DRAFT-NEEDS-LUCAS-REVIEW — paper only. No game code, no engine change, no GDD edit, no roadmap edit. Verbatim-ready replacement text for GDD §18's perf wording, for Lucas to apply at lock.**

**Flags:** `[G]` = taken directly from GDD / roadmap / a sibling v0.1 doc, with source named. `[NEEDS-P1]` = assumes the undecided win condition — appears nowhere as fact in this doc. `[NEEDS-LANG]` = language-dependent note; the LANG spike decides, this doc does not.

**Sources:** review 1.11, 3.3, 3.4.3, 3.5, P11; ROADMAP Phase 0 item 10 + Phase 1 item 9 + Phase 1/2 exits + Decisions log (MAC, LANG) + cut list; GDD §18–§19; all eight sibling v0.1 docs.

**Adopted (not decided):** 45-s days, pause/1x/2x/4x, 2x cruise; daily macro tick + sub-daily beats; 5k SE lens / ≤3k firms to measured headroom; S_SE ≈ 1,000; placement pass ~0.1–0.2M ops/day; quarterly cadence + poll rhythm; PC 0–100; headless precursor logging; Windows + Linux only.

---

## 1. Verbatim-ready GDD §18 replacement text — DRAFT-NEEDS-LUCAS-REVIEW

Apply at lock by replacing the **Architecture** and **Perf budget** bullets of GDD §18 with the block below. The **Engine** bullet is untouched (its language question belongs to item 12, the LANG spike — §3). The **Saves** bullet (ironman toggle) and the **Modding** bullet are **intentionally untouched** — both are owned by P12, Phase 0 item 11, a later run; this doc restates the perf bar only and makes no claim on either.

> - **Performance bar — ONE RULE: the game ships if and only if it holds on Steam Deck-class hardware.** Steam Deck IS the minimum spec — there is no separate, softer "mid-range PC" bar. Deck-class means a Steam Deck APU or a Deck-equivalent APU driving 1280×800. Any "mid-range PC" language elsewhere in this doc is superseded by this rule.
> - **Fixed-cadence sim ticks, independent of frame rate.** The sim advances on its own clock — a daily macro tick plus sub-daily citizen beats (five beats per 45-second day at 1x) — and the renderer draws on its own clock. Render never waits on sim; sim never waits on render. Tick cadence is wall-clock fixed per speed (pause/1x/2x/4x, 8x cut); a slow frame drops a drawn frame, never a sim beat.
> - **60fps render target on Deck in the heaviest diorama view**, proven in Phase 2 (M1 vertical slice): full peep life in Southeast dioramas, per-beat lighting tint, max-N thought-bubble culling, with the sim tick decoupled and never blocking render. M0's headless proof measures sim-ms-per-tick ONLY — render fps is out of scope until there is something to render.
> - **The ≥2x headroom rule.** At the Phase 1 ceiling — 20,000 lens citizens × 3,000 firms — the full-tick budget (daily macro tick + all sub-daily beats + placement pass + logging) must fit inside the frame-independent tick cadence with at least 2× headroom on Deck-class hardware: measured tick cost ≤ 50% of the tick's wall-clock budget. If it does not fit: reduce agent count, simplify the tick, or re-scope — do not proceed hoping optimization saves it later. M1 ships the 5,000-lens / ≤3,000-firm Southeast slice scaled to MEASURED headroom, never to a schedule number.
> - **M0's gate is measured, not paper.** "Hit the perf budget on paper" is withdrawn. The M0 exit is measured headroom on a Deck or Deck-equivalent APU box, via the Phase 1 perf harness: headless tick-time benchmark at 5k/10k/20k citizens × 500/3k firms, hardware named, numbers recorded in `docs/perf-budget.md`. No numbers, no exit.
> - **Platform:** PC via Steam, Windows + Linux only (macOS cut 2026-10-06). Steam Deck Verified is the release-path check: text legible at 720p/800p, trackpads usable for the mouse-first UI, per the current Deck requirements at submission time.

Why this shape `[G per review 3.3 + roadmap Phase 1 exit]`: the review's over-constraint warning (20k agents × 60fps × Deck) is resolved by decoupling, not by weakening any one term — the sim gets its own cadence, the renderer gets its own fps target, and the 2x headroom rule is the single number the harness reads pass/fail from.

## 2. Consistency checklist vs all eight siblings — DRAFT-NEEDS-LUCAS-REVIEW

| Sibling | Took | Breaks if it changes |
|---|---|---|
| numbers-appendix | Tick-relevant constants: quarterly revenue recompute + 50%/100% lag schedule (§1); 12-policy delays of 1–8 qtrs with P8 staged precursors (§2); six needs with per-game-day decay rates + the 30/60-day behavior timers (§3); quarterly poll cadence (§6) — all game-day/quarter-denominated, hence speed-invariant | appendix moves any rate to wall-clock units (per-second costs, per-frame restores) — the fixed-cadence contract assumes game-time rates only; new policy delays beyond 8 qtrs stretch the precursor logging window the M0 tick must carry |
| coupling-spec | Agent counts at both scales (5k/500 M0, 20k/3k ceiling) + the placement pass as a daily deterministic drain of weekly firm events; placement cost implication: ~0.1–0.2M simple ops/day M0, ~2.6M at full scale, <1 ms / <10 ms — the pass is NOT the perf risk, so the tick budget's binding term is sub-daily beats × citizens × six needs | firm decision cadence moves from weekly-staggered to per-frame or per-beat (placement cost multiplies ~100× and the §1 tick budget must be recomputed); LIFO/pool-matching replaced by an O(lens × firms) join (review 3.4.3's naive matching — the R1 containment this bar assumes collapses) |
| time-scale | Tick cadence numbers: 45-s days at 1x, pause/1x/2x/4x with 2x cruise and 8x cut, five beats/day readable at 1–2x, per-beat tint instead of a sun cycle; the tick's wall-clock budget at each speed derives from these | day length changes (every tick-budget denominator moves: 30-s days halve the wall clock per game-day); a restored 8x or a per-frame sim coupling reintroduces the strobe/over-constraint this bar exists to forbid |
| political-capital | PC as quarterly-settled state (income at the quarterly poll, four fixed-cost spends, no passive trickle): PC adds one quarterly ledger tick + four event-rate verbs, negligible tick cost by construction | PC gains per-beat/per-frame accrual (trickle/decay per tick would add 20k-adjacent per-tick work and a new budget line); a fifth vote-buying spend (already answered no by the legislature doc) would add a per-policy gate to the tick path |
| legislature | (a) abstraction = zero legislature object in the tick: no vote roll, no passage gate, no per-policy friction check; campaign-season ×2 applies to approval deltas only (a multiplier on existing ledger writes, not new work); October surprise is one authored draw | flip to (b) override-vote adds a per-tax-hike/per-reallocation gate to the tick path (small but must be budgeted); doubling extended to money/jobs/condition effects multiplies per-tick ledger writes and needs re-measurement |
| north-fix | (a) RECOMMENDED membership redraw is spawn/sampling-time only (three top-down rules at citizen creation) — zero per-tick cost; demand/event routing is content addressing, not sim work | flip to (b) rotation-aware demands adds a per-demand identity check on the demand path (trivial alone, but it lands in the tick-adjacent event machine and must be named in the harness scenario); a seventh faction would widen every per-faction ledger loop 6→7 |
| m1-rescope | 5k SE lens / ≤3k firms scaled to measured headroom (never below ~500 SE-anchored); M1 = one region watchable, five simulated; heaviest-diorama view as the named 60fps proof scene; cut #7 (firms → sector stats) as stop-and-replan tripwire, never silent | slice counts raised without a new harness run (headroom-gated scaling is the rule — counts follow measurement, not schedule); cut #7 taken silently (the tick being measured would no longer be the game being sold) |
| attribution-ui | Sim logging contract: every UI claim carries a cause id (firm events, approval ledger, policy lifecycle, moment queue, lens transition tags); precursor logging is headless from M0 — cheap by design (append-only records on events that already fired, no per-frame UI work in the tick) | logging moves from event-append to per-beat/per-citizen scans (e.g., recomputing top-3-drivers per beat per faction instead of on-delta + quarterly — the tick budget's logging line must be re-measured); any UI claim allowed without a cause id breaks the orphan-zero audit the harness log checks rely on |

`[NEEDS-P1]` hooks: none active. If the eventual win condition ever needs per-tick scoring (e.g., a live "crown progress" meter recomputed per beat rather than per quarter), that scoring lands in the tick budget and this bar's §1 numbers must be re-measured — flagged now so the dependency is visible, assumed nowhere.

## 3. Language-spike hookup (LANG is OPEN) — DRAFT-NEEDS-LUCAS-REVIEW

This bar is **language-agnostic**: every rule in §1 is stated in measured milliseconds, frames per second, and headroom ratios — none of them names C#, GDScript, or any runtime. The Phase 0 item 12 one-day spike (C# vs GDScript, 5k-agent tick benchmark in each) measures **against THIS bar**: the spike runs the 5k-agent tick on Deck-class hardware and reports sim-ms-per-tick and implied headroom at the Phase 1 ceiling the same way the Phase 1 harness will. The spike result decides the language — `[NEEDS-LANG]` the lean going in (C# sim core for R4 headroom, GDScript UI for iteration speed) is a lean only, and this doc pre-decides nothing. If the spike shows GDScript holding the 2x rule with margin, GDScript wins; if neither holds at 20k/3k, the re-scope clause in §1 (fewer agents, simpler tick) triggers before any language mandate does.

## 4. Verify test — DRAFT-NEEDS-LUCAS-REVIEW

A fresh agent asked "what is the perf bar?" must answer in one sentence — *"it holds 60fps render with a decoupled fixed-cadence sim tick on Steam Deck-class hardware, with ≥2x tick headroom measured at 20k citizens × 3k firms"* — citing §1's one rule; and the Phase 1 harness author must be able to lift the pass/fail rule straight out of §1 (configurations 5k/10k/20k × 500/3k, metric sim-ms-per-tick on a named Deck-class box, pass = full tick ≤ 50% of tick wall-clock budget at ceiling, numbers in `docs/perf-budget.md`) without inventing a threshold, a configuration, or a measurement method.

## 5. Direct questions for Lucas — DRAFT-NEEDS-LUCAS-REVIEW

1. Is Steam-Deck-or-equivalent-APU at 1280×800 the right crisp definition of Deck-class, or do you want a named desktop floor too?
2. Confirm the ≥2x headroom rule at 20k/3k — or is 2x too strict (ship at 1.5x) or too lax (demand 3x)?
3. Confirm M0 render-fps-out-of-scope (sim-ms-per-tick only until Phase 2) — or do you want an early render smoke target?
4. If the LANG spike shows neither language holding 2x at ceiling, which re-scope do you prefer first: fewer agents, simpler tick, or diorama-concentrated peeps?
5. Confirm the modding + ironman bullets stay untouched here for the P12 item-11 run — or fold them into this lock?

Locked scope (recited once): Windows + Linux only, Steam Deck is the perf bar, $24.99 premium, mouse-first.

**DRAFT-NEEDS-LUCAS-REVIEW — end of v0.1.**

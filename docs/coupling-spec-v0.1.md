# Mitten State — Firm↔Citizen Coupling Spec v0.1 (Phase 0, P3 spec half)

**DRAFT-NEEDS-LUCAS-REVIEW** — the entire document below is draft. No M0 code may treat any value or rule here as final until Lucas reviews it alongside the numbers appendix.

## 0. Status, scope, and conventions

**What this is.** The paper spec for ROADMAP Phase 0 work item 3 (P3, spec half): "Firm↔citizen coupling + movement on paper." It de-risks Phase 1 work item 4 (lens citizens + placement pass, the R1 core) and item 6 (movement/commute) by writing the placement pass, wage rule, commute abstraction, and lens-vs-aggregate scaling law before any sim code exists. It also feeds items 3 (firm agents), 5 (needs engine), 8 (determinism), and 9 (perf harness) — see Traceability at the end.

**Sources read.** `docs/ROADMAP-1.0.md`, `docs/numbers-appendix-v0.1.md`, `docs/design-review-muse-code.md`, `docs/MITTEN-STATE-GDD-v0.1.md` (§5 factions, §7 time-scale, §8 sim, §9 budget, §13 goals), plus `maps/README.md` for the geo inventory.

**Number-flag legend.** Every simulation number below carries a flag: `[G]` = gameplay estimate (defensible default, tunable in Phase 3–4 balance); `[R?]` = real-data-anchored but unverified in this draft (same convention as the appendix). Values recited from the appendix are marked `[G per appendix §N]` / `[R? per appendix §N]`. Section numbers, phase/work-item numbers, document versions, and dates are document labels, not sim numbers, and carry no flag.

**Locked scope (recited, not decided here).** PC via Steam, Windows + Linux only; Steam Deck is the minimum-spec perf bar; no macOS (roadmap decision MAC, 2026-10-06). Demographics: age/retire/die + job changes only — no marriage/kids/generations (cut list item 3). This spec therefore fixes household size at spawn and never forms or dissolves households.

**P1 (campaign win condition) is PENDING Lucas's decision.** This spec assumes nothing about it. No rule below depends on the win condition; the one place a future win choice could interact is marked `[NEEDS-P1]` in §4.4.

**Appendix cross-reference (normative).** This spec takes as given: the needs engine (§3 of the appendix: six needs `[G per appendix §3]`, decay/restore rates, behavior threshold table, household-budget Money rule); demand cadence (§4); thresholds — bond ladder, exodus, faction floor (§5); the election formula incl. faction population shares (§6); the M0 policy table (§2); and the dollar-scale intuitions (§7). **Gap, stated plainly:** appendix v0.1 contains **no firm/firm-agent parameter table** (no profitability function, no hire/freeze/layoff/close thresholds, no spawn rule) even though roadmap Phase 1 item 3 needs one. §1.6 below proposes `[G]` defaults for that missing table. These are additive proposals for appendix v0.2, not conflicts — there is nothing to conflict with yet. The Phase 0 exit check "every M0 work item traces to a number or rule written in Phase 0" fails for firm behavior until either this proposal is adopted into the appendix or Lucas writes replacements.

---

## 1. The placement pass

### 1.1 Event flow and cadence

Firms never touch lens citizens directly. Firms post aggregate employment events; a single deterministic placement pass converts the lens-representable fraction of those events into individual lens-citizen job transitions; everything else stays statistical (§1.4). This is the data flow the design review prescribes (§3.4.3) and the mechanism R1 containment depends on.

**Cadence (paper choice for M0).** Firms evaluate profitability and post events once per game-week `[G]` (staggered: roughly one-seventh of firms decide each game-day `[G]`, in `firm_id` order, so daily load is flat). The placement pass runs once per game-day tick `[G]`, draining the week's queued events in `(day, firm_id)` order. Freeze is a standing state, not an event. Wall-clock mapping of game-days is owned by the pending P4 time-scale decision, not this spec — this spec only requires that a daily tick exists (GDD §18 already promises daily macro ticks).

**The one hard containment rule (R1).** Firm agents are the sole producers of `FirmEvent`s, and the placement pass is the sole writer of lens employment transitions with cause `LAYOFF`. Any lens employment record with cause `LAYOFF` and a null `firm_event_id` is an **orphan**; the Phase 1 item 4 exit criterion is that the orphan count is exactly zero (`[G]` threshold: `0` — no tolerance) after the scripted 1-game-year run `[G per roadmap Phase 1 exit]`. Quits (citizen-initiated, needs-driven), retirements, and deaths are separate causes (§1.5) and are never counted as layoffs.

**Firm event data shape.** Every firm decision that changes headcount (or freeze state) emits exactly one record with these fields:

| Field | Type | Meaning |
|---|---|---|
| `event_id` | `u64`, deterministic sequence `(day << 32) \| firm_id` `[G]` | Unique, reproducible under the same seed (Phase 1 item 8) |
| `firm_id` | `u32` | Producing firm |
| `county_id` | per `maps/mitten-state-geo.json` county list | Authoritative geography for aggregates |
| `sector` | enum of the six GDD §9 industries `[G]` | Auto/mfg, mining/timber, agriculture, tourism/leisure, knowledge/health, logistics |
| `kind` | enum | `OPENINGS`, `LAYOFFS`, `FREEZE_ON`, `FREEZE_OFF`, `CLOSE`, `SPAWN` (spawn is posted by the spawner on the new firm's behalf) |
| `aggregate_delta` | signed int, real-equivalent jobs | Authoritative macro quantity; positive for openings/spawn, negative for layoffs/close, `0` for freeze flips |
| `wage_offer_idx` | wage-index units (§2) | What the firm offers new hires; ignored for layoffs/close |
| `cause_code` | enum | Profitability band, policy effect, or authored-event id (feeds Phase 2 "because" lines) |
| `day` | game-day index | Tick the event posts on |

Example (illustrative values, all `[G]`): a Flint auto supplier posts `{kind: LAYOFFS, aggregate_delta: -200, county_id: <Genesee>, sector: auto, cause_code: MARGIN_BELOW_MINUS5_TWO_QUARTERS, day: 412}`. The placement pass decides how many (usually zero — §1.4) lens citizens that `-200` moves.

### 1.2 Which lens citizens are affected — rules and priorities

**Hire matching (kind = `OPENINGS`, incl. post-`SPAWN` openings).** Build the candidate pool: unemployed lens citizens whose home county is within the firm's commute shed (commute ≤ `60` one-way minutes `[G]` under current infra condition, per the §3 function), excluding retirees and citizens already starting a job this tick. Sort deterministically by (1) same-county-as-firm first, (2) longest unemployment duration in days (descending), (3) Money need ascending (neediest first — this is the appendix §3 `Money < 25` job-hunt behavior `[G per appendix §3]` made mechanical), (4) `citizen_id` ascending as final tiebreak. Take the first `N = lens_slots` (§1.4). **M0 simplification:** no skills or sector-affinity matching — any unemployed candidate can take any opening `[G]`. Sector matching is deferred (see Open ambiguities).

Employed citizens do not compete for openings in M0 except through the quit path: a citizen whose needs cross the appendix §3 thresholds quits first (cause `QUIT`), spends at least `7` days unemployed `[G]`, then re-enters the pool. No direct employed→employed poaching in M0 `[G]`.

**Layoff selection (kind = `LAYOFFS`).** The affected set is drawn **only** from lens citizens currently employed by that firm (its lens roster). Sort by (1) hire day descending (strict LIFO — most recent hire goes first) `[G]`, (2) `citizen_id` ascending. Take the first `N = lens_slots`. Strict LIFO is chosen over weighted-random because it is deterministic without consuming RNG and is trivially auditable in logs.

**Close (kind = `CLOSE`).** All lens citizens on the firm's roster are laid off, each record carrying the same `firm_event_id`. There is no selection ordering problem; the wave rule (§1.5) governs visibility.

**Freeze (`FREEZE_ON`/`FREEZE_OFF`).** No placement action. A frozen firm is skipped as a hire destination while frozen; its existing employees are unaffected. Freeze flips carry `aggregate_delta = 0`.

**The reverse direction is not required.** Many small firms employ zero lens citizens (design review §1.5). A layoff/close at such a firm is a pure statistical event plus non-peep representation (headline, smoke-stops — per review §1.5). The containment rule is one-way: every lens layoff traces to a firm event, not every firm event must touch the lens.

### 1.3 Fallback when no candidate exists

**Hire fallback chain** (applied in order, per event): (1) widen geography from the commute shed to the whole home region; (2) drop the `7`-day post-quit waiting rule `[G]`; (3) leave remaining `lens_slots` unfilled and convert them to statistical-only hires (§1.4), returning unfilled entitlement to the accumulator up to a cap of `+2.0` lens-equivalents `[G]`, with overflow discarded to statistics. **Never teleport or relocate a citizen's home to fill a slot** — M0 jobs do not move homes; migration is a separate needs-driven system (appendix §3: `2+` needs `< 15` for `60` days `[G per appendix §3]`), and conflating the two would corrupt both.

**Layoff fallback.** If the firm's lens roster is smaller than `lens_slots`, lay off the entire roster and book the remainder statistically. If the roster is empty, the event is statistical-only. Unused layoff entitlement carries forward in the accumulator down to a floor of `-2.0` `[G]`. No substitute victims are ever selected from other firms — that would manufacture orphans-by-proxy and break R1 containment.

All fallback decisions are deterministic (sorted scans + accumulator arithmetic, no RNG on the fallback path), satisfying Phase 1 item 8.

### 1.4 Statistical churn and reconciliation (how totals agree)

**What stays statistical.** All real-equivalent job change minus the lens-represented fraction: hires/layoffs at firms with no lens presence, fractional remainders below one lens-equivalent, unfilled slots from §1.3, and all churn implied by quits/retirements/deaths between firm decision ticks. At M0 Southeast scale (`S ≈ 1,000` real per lens `[G]` — §4), a `-200`-job layoff `[G]` is *expected* to move zero lens citizens most of the time; that is the design working, not the design failing.

**Lens-slot sizing with entitlement carry.** Each `(county, sector)` pair holds a fractional entitlement accumulator `E` (init `0.0` `[G]`). On each event: `E += aggregate_delta / S_r` (with `S_r` the home-region scale factor from §4); `lens_slots = trunc(E)` toward zero; `E -= lens_slots`. Hire slots are then capped by available candidates, layoff slots by roster size (§§1.2–1.3); capped-away quantity stays in `E` within the `±2.0` `[G]` clamp. This guarantees long-run proportionality (no systematic over/under-representation of the lens) while keeping every single tick exactly reconciled.

**Reconciliation identity (checked every tick in debug builds).** For each event: `aggregate_delta == lens_delta × S_r + statistical_delta`, where `statistical_delta` is computed as the residual (`aggregate_delta − lens_delta × S_r`), never independently estimated. County-sector employment aggregates are then updated by `aggregate_delta` (authoritative), and `statistical_delta` is booked to the county-sector statistical pool. **Totals agree by construction every tick**, not by convergence. A debug assertion fires if any county aggregate drifts from `lens_employed × S_r + statistical_pool` by more than rounding (`±1` job `[G]`).

**Worked example** (all `[G]`): M0 Southeast, `S = 1,000`. Event: `-200` layoffs, accumulator `E = -0.1` → new `E = -0.3` → `lens_slots = 0` → `lens_delta = 0`, `statistical_delta = -200`. County aggregate falls by `200`; no peep is touched; a headline hook fires (§1.5). Five such events later `E` crosses `-1.0` and the next layoff at a firm *with* a lens roster moves one lens citizen — who then carries the `firm_event_id`, appears in peep filters, and can narrate the downturn.

### 1.5 Hire / freeze / layoff / close / spawn wave semantics

| Kind | Firm-side trigger (proposed `[G]` — see §1.6) | Lens effect | Statistical effect | M0 visibility (headless-logged; Phase 2 renders) |
|---|---|---|---|---|
| `OPENINGS` | Margin `> +8%` `[G]`, or post-spawn staffing | §1.2 hire matching | Residual hires | Hiring-notice log; peep thought bubble on first day |
| `FREEZE_ON` | Margin in `-5%..+2%` `[G]`, or authored event | None | None (`delta 0`) | Flag on firm record; skipped in matching |
| `LAYOFFS` | Margin `< -5%` for `2` consecutive quarters `[G]` | §1.2 LIFO layoffs, each tagged | Residual layoffs | Log + affected-peep bubbles; approval-delta hook |
| `CLOSE` | Margin `< -15%`, or cash-out, or authored chain `[G]` | Whole lens roster laid off | Balance of headcount | Closure log + headline hook + smoke-stops flag for Phase 2 |
| `SPAWN` | County-sector avg margin `> +10%` for `2` quarters `[G]` + policy modifiers (e.g., appendix §2 policy 5: spawns `+10%` `[G per appendix §2]`) | None directly; new firm posts `OPENINGS` next decision tick | Spawn headcount (typically `5–50` jobs `[G]`) | "Opened in <town>" log + grand-opening hook |

**Waves.** A wave is `≥ 10` same-kind events in one region within one game-week `[G]`. Waves need no special placement logic — the queue absorbs them in deterministic order — but they trigger a wave-summary log line and one headline hook instead of per-event spam (this is the headless precursor of the Phase 2 attribution feed). The Ohio-poach chain (GDD §11–12) and plant-closing scenario (GDD §13) arrive as authored `LAYOFFS`/`CLOSE` waves with `cause_code` set to the event id, so every resulting lens layoff still traces to a firm event and the orphan count stays `0`.

**Non-layoff separations (never orphans, never firm events).** `QUIT` (citizen-initiated when appendix §3 thresholds bite: `Money < 25` job-hunts, `Purpose < 20` job-hunts/retrains `[G per appendix §3]`): citizen → unemployed, old firm's aggregate headcount `-1` booked to its county-sector statistical pool, firm may re-hire next decision tick. `RETIRE`/`DIE` (cut-list-allowed demography): same booking as quits, plus sample-maintenance replacement per Phase 3 work item 9 (out of M0 scope; M0 does not replace — lens shrinks slowly, recorded in Open ambiguities).

### 1.6 Proposed firm-parameter defaults (appendix gap fill — all `[G]`, for appendix v0.2)

Because appendix v0.1 has no firm table, M0 implementation is blocked on these six values. Proposed: profitability margin bands as in §1.5 (`+8%` hire / `+2%` hold / `-5%` layoff-after-`2`-quarters / `-15%` close); layoff size per event `10–30%` of firm headcount `[G]`; spawn size `5–50` jobs `[G]`; spawn site = weighted-random county in a qualifying region by population `[G]`; firm size distribution at setup: `80%` small (`1–19` jobs), `15%` mid (`20–199`), `5%` large (`200+`) `[G]`; M0 firm count `~500` in one region `[G per roadmap Phase 1 item 3]`, full scale `~3,000` `[G per GDD §9]`. Lucas should confirm, replace, or strike each line; until then these are this spec's proposal, not appendix truth.

## 2. Wage rule (one rule for M0)

**The rule, in one sentence:** the **county-sector wage index sets local wages**; firms take it as a profitability input and post small bounded deviations on new offers; policy sets a floor that truncates offers from below. Firms do not set the level, policy does not set the level — the county-sector aggregate does.

### 2.1 The index

Each `(county, sector)` pair holds a wage index `W(c,s)`, starting at `100` everywhere `[G]`. Starting cross-sectional differences come **only** from fixed sector multipliers `[G]`: manufacturing `1.10`, mining/timber `1.15`, agriculture `0.85`, tourism/leisure `0.80`, knowledge/health `1.25`, logistics `0.95`. There are **no** starting county differences in M0 `[G]` — county wage gaps emerge endogenously from tightness dynamics below, which keeps setup honest and makes "watch wages diverge" a legible consequence of play rather than a confound baked into t0.

**Quarterly update (tightness-driven).** Each game-quarter, per county: `W(c,s) ← W(c,s) × (1 + 0.5 × (5 − u_c) / 100)` `[G]`, where `u_c` is the county unemployment rate in percent and `5` is the natural rate `[G per appendix §6]` (the same `5%` the election formula and GDD §13 goals anchor on). Quarterly change is clamped to `±3%` `[G]`. Tight counties (`u < 5`) drift up; slack counties drift down. Sector multipliers stay fixed; the county component carries all dynamics.

### 2.2 Firm offers and the policy floor

A firm's posted offer on an `OPENINGS` event is `offer = W(c,s) × sector_mult × (1 + d_f)` `[G]`, with the firm deviation `d_f` set by its profitability band: hiring firms `+5%` `[G]`, holding firms `0%`, frozen firms `-2%` on new offers only `[G]`. **Incumbents never take pay cuts in M0** `[G]` — wage flexibility acts on new offers and hiring volume, not on existing paychecks. This is a deliberate simplification: it keeps the household-budget derivation (appendix §3) monotonic and avoids a second layoff-equivalent transition type the orphan audit would have to cover.

The state minimum-wage floor `F` (a policy-settable level, GDD §10) defaults to `60` index units `[G]` and truncates offers from below: `offer_final = max(offer, F)`. A firm whose profitability is negative at `F` does not underpay — it sheds openings (reducing or zeroing its next `OPENINGS` post) and, if losses persist, enters the layoff band (§1.5). Minimum-wage hikes therefore act on employment volume with the appendix's `4–8` quarter base-response lag `[G per appendix §1]`, never as an instant wage theft or instant boom.

### 2.3 Paychecks, household dollars, and cost of living

Wage-index units map to household dollars once, globally: `$9` per index point per week `[G]`, so an index-`100` job pays `$900`/week `[G]` (about `$46,800`/year `[G]`). All M0 jobs are full-time `[G]`; shift patterns (including night shift) affect Rest decay (`-45` vs `-35`/day `[G per appendix §3]`), not pay — shift differentials are deferred. Payday is weekly `[G]`; each payday adds earners' pay to the household budget, and cost of living drains it continuously. M0 cost of living is a single statewide `$400`/week per capita `[G]` (about `$20,800`/year `[G]`); county-varying CoL is deferred (see Open ambiguities). A single-earner index-`100` household at the mean size of `2.4` `[G]` (§4.3) thus roughly breaks even — comfortable with two earners, precarious with one — which is the intended M0 texture.

The Money-need mapping itself stays owned by appendix §3 (`> 3` months CoL ≈ `90+`; `< 1` month CoL ≈ `< 30` `[G per appendix §3]`); this spec only supplies the dollar flows. One interpolation the appendix leaves silent: between `1` and `3` months of CoL in reserve, Money need is linear, `30 + 30 × (months − 1)` `[G]` (proposal for appendix v0.2). Non-earners mirror the household value dampened `±10` `[G per appendix §3]` — unchanged.

### 2.4 How county/sector differences are handled (summary)

Sector differences: fixed multipliers at setup (§2.1). County differences: emergent quarterly drift from a uniform start, driven by county unemployment. Cross-county commuters earn the **firm county's** wage and spend at the statewide CoL. Policy (minimum wage, and appendix §2 policies that shift hiring such as policies 2–4) moves volumes and the floor, never the index level directly.

---

## 3. Commute / pathing abstraction — M0 pick

### 3.1 Pick: straight-line distance + time penalty (Option B)

**M0 uses straight-line distance with an infrastructure-conditioned time penalty. No road-graph pathing in M0.** (If a name helps downstream discussion: "as-the-crow-flies-plus-potholes." The M1+ upgrade path in §3.4 has its own name.)

**Justification on cost (M0 is headless).** Road-graph pathing would need a routable graph the repo does not have: `maps/mitten-state-geo.json` holds `30` city points, `9` highway polylines, the bridge, and `5` region shells (per `maps/README.md`) — enough to *draw* highways, not to route town-to-plant commutes. Building a solver over that skeleton for a headless milestone whose output nobody sees would spend Phase 1 budget on fake precision: every route would still be straight-line with extra steps. Straight-line is `O(1)` per citizen per day, trivially deterministic, testable without fixtures, and honest about what M0 can know. The expensive question M0 must answer is "how does infra condition move commute times and firm costs" — a multiplier question, not a routing question — and §3.2 answers it with one shared condition input.

**Justification on infra dependence.** Both candidate options need the same infrastructure input (county roads condition, `0–100`, starting at `45` `"rough"` `[G per appendix §0]`); the graph option additionally needs per-segment condition the sim does not model. Straight-line consumes exactly the condition granularity the budget system produces (county-level repair via the Roads & bridges department, `$7.0B` `[R?-adjacent per appendix §0]`), so no new state is introduced.

### 3.2 Function shape (paper spec — the contract Phase 1 item 6 implements)

```text
commute_minutes(home_xy, firm_xy, mode, roads_c, season) -> minutes : float
logistics_factor(roads_c) -> factor : float
```

**Inputs.** `home_xy`, `firm_xy`: lon/lat pairs from the geo file's city/town points (commutes resolve to town granularity in M0 `[G]` — no street addresses). `mode`: `DRIVE` always available; `TRANSIT` only for home+firm both in Southeast while Detroit regional transit funding (GDD §10) is active, at `0.7×` the drive time `[G]` where available. `roads_c`: home county's roads condition `0–100` (M0: county-level `[G]`; region-level fallback if county repair targeting is deferred). `season`: winter flag per GDD §7 (conditional — see cut-list note below).

**Outputs.** `commute_minutes`: one-way minutes, `= dist_km / 50 × 60 × road_mult × season_mult` `[G]`, where `dist_km` is equirectangular straight-line distance, `50` km/h is the M0 effective speed `[G]`, `road_mult = 1 + 0.8 × (100 − roads_c) / 100` `[G]` (at the starting condition of `45`, `road_mult = 1.44` `[G]`), and `season_mult = 1.2` in winter, `1.0` otherwise `[G]` — **unless** seasons' gameplay effects are cut (cut list item 6), in which case `season_mult = 1.0` always and winter is visual-only. `logistics_factor`: the firm-side effect of the same condition, `= 1 + 0.3 × (100 − roads_c) / 100` `[G]`, multiplying firm costs in the profitability function. Appendix §2 policy 1's direct `−5%` firm-logistics effect `[G per appendix §2]` applies **multiplicatively on top** (`factor × 0.95` while the blitz is active) — the formula and the appendix row compose rather than conflict. Policy 1's `+8`/yr condition repair `[G per appendix §2]` flows through both multipliers automatically.

**Consumers.** `commute_minutes` gates hire matching (the `60`-minute shed, §1.2), trims Rest restore for long commutes (`−1` Rest per `15` minutes over `45` `[G]` — proposal, appendix §3 silent on commute/Rest coupling), and feeds the Phase 2 map layer later. `logistics_factor` feeds firm profitability (Phase 1 item 3) alongside wages (§2), taxes (appendix §1, incl. corporate `−6%`/pp base elasticity `[G per appendix §1]`), demand, and policy.

### 3.3 What road-graph pathing would have needed (recorded so the rejection is auditable)

A routable graph (town-level nodes, segment-level condition, an updater for construction/closures), a path solver in the tick, and per-citizen route caching with invalidation — all to produce numbers M0 cannot display and whose inputs (segment conditions) no budget verb sets. Revisit only if Phase 2 dioramas need visible routes (§3.4).

### 3.4 Named upgrade path (not M0 scope)

**Corridor-snapped straight-line** (candidate M1+ hybrid): snap each commute endpoint to the nearest highway polyline, price the middle leg at corridor speed and the two stubs at local speed, keep the §3.2 multipliers. It reuses the geo file's `9` polylines as drawn corridors without pretending they are a graph, and it degrades to §3.2 wherever no corridor is near. Adopting it requires no change to §§1–2 — only the distance term changes.

---

## 4. Lens-vs-aggregate scaling law

### 4.1 What one lens mover counts as

**The law:** each region `r` has a fixed scale factor `S_r = aggregate_population_r / lens_population_r`, computed once at scenario setup and held constant for the milestone. Every lens↔aggregate conversion for a citizen uses the `S_r` of their **home region**. The factor is per-region (not statewide), because regions have different lens densities once UP oversampling (§4.3) applies.

**M0 values.** M0 runs `5,000` lens citizens `[G per roadmap Phase 1 item 4]` in one region (Southeast). Southeast holds roughly half the state's `~10M` people (`~10M` `[R?]`; "roughly half" `[G per GDD §4]`, so `~5.0M` `[G]`): `S_SE ≈ 1,000` `[G]` (one lens citizen ≈ `1,000` real-equivalent). **Full-game values.** `20,000` lens `[G per GDD §8 upper planning figure]` across `~10M` `[R?]`: statewide-average `S ≈ 500` `[G]` — identical to the appendix §5 placeholder (`1` lens mover ≈ `500` real `[G per appendix §5]`), which this spec now confirms as the full-scale law rather than a placeholder. If Phase 1 perf work re-scopes agent counts (roadmap Phase 1 honest note), `S_r` is recomputed from the new counts — the law is the formula, not the constants.

### 4.2 How the aggregate layer mirrors lens changes (it doesn't sum them — it books them)

County-sector employment aggregates, county populations, and the interstate-migration ledger are **authoritative**; the lens is a traceable sample, never the sum (this resolves design review §1.4 in favor of "aggregates are truth, lens is illustration-with-teeth": every lens change is exactly booked, but macro scores never depend on scaling up a noisy sample).

- **Employment:** per the §1.4 identity — each event books `lens_delta × S_r` against the county-sector aggregate and takes the residual statistically. Totals agree every tick by construction.
- **In-state moves:** a lens household moving counties books `−S_r` at origin and `+S_r` at destination (net `0` statewide). Destination choice and its distribution rule are Open ambiguities below; the booking identity is not.
- **Interstate exits:** one lens household exit decrements its home county by `S_r` and increments the cumulative interstate-loss ledger by `S_r` toward the `250,000` real-equivalent per-term exodus threshold `[G per appendix §5]` (with the `25k`/quarter headline warning `[G per appendix §5]` evaluated on the ledger, never on lens counts). Entries (in-migration) book symmetrically.
- **Faces, not scores:** the lens's job is to supply *who* — named citizens, thought bubbles, peep-filter hits ("affected by my last `3` policies" `[G per review §4.3]`), moving-truck vignettes — for changes the aggregates score. A factory-recruitment win of `1,500–3,000` jobs `[G per appendix §2 policy 4]` moves `2–3` lens citizens at M0 scale `[G]` and thousands statistically; the dashboard shows the thousands, the map shows the two families.

### 4.3 The UP small-sample rule (design review §1.4)

The problem, recited: the UP holds `~3%` of state population `[R?-adjacent per review §1.4]`, so proportional sampling gives it `~600` of `20,000` lens citizens `[G]` — yet GDD §13's example goal is "`2,000` new jobs in the UP" `[G]`, a change of about `4` lens citizens `[G]` at `S ≈ 500`: pure noise. M0 (one Southeast region) does not instantiate the UP at all; this rule activates in Phase 3 when all regions go live, and is written now so sampling code is built to it once. Three parts:

1. **Stratified floor with weights.** The UP gets a lens floor of `800` citizens at full `20k` scale `[G]` (oversampled `~1.33×` vs proportional `[G]`), with per-citizen weight `w_UP = proportional_share / actual_share < 1` `[G]` applied whenever UP lens deltas scale (`effective_S_UP = S × w_UP`). Other small strata may use the same mechanism; the UP is the only mandatory one.
2. **Aggregate-authoritative goals.** Regional job goals ("`2,000` new jobs in the UP") are scored **only** from county aggregates, never from scaled lens counts. This is a hard rule, not guidance: no goal-check function may take a scaled lens count as input.
3. **Noise guard on lens-derived UP rates.** UP unemployment, approval splits, or any other rate computed from the lens sample is reported as a trailing `4`-quarter average `[G]`, and any cell with `n < 50` lens citizens `[G]` shows "too few to report" with the aggregate proxy beside it. Headlines and faction "top `3` drivers" panels `[G per review §4.4]` (Phase 2 P10) cite the aggregate proxy for small cells, with lens faces attached via event ids.

### 4.4 Demographic bounds this law must respect (from the appendix)

Stratification and sample maintenance must preserve, per quarterly audit within `±2` percentage points `[G]` unless the appendix says otherwise: faction population shares Main Street `38%` / Motor `18%` / Campus `12%` / Lakeshore `11%` / Growers `11%` / Yoopers `10%` `[G per appendix §6]` (with Main Street's `×1.3` turnout weight `[G per appendix §6]` applied at election time, **not** by oversampling Main Street in the lens — sampling follows population, weighting follows the formula); the household-budget Money derivation and non-earner mirroring (appendix §3); the exodus ledger semantics (§4.2 / appendix §5); and household sizes fixed at spawn in `1–4` `[G]` with mean `~2.4` `[G]` (no marriage/kids per the cut list, so size never changes except by death — deaths shrink the household in place). `[NEEDS-P1]` **conditional:** if Lucas's win condition is ever scored from lens-visible micro-stats (e.g., a hypothetical "lift N followed citizens out of poverty"), §4.2's aggregate-authoritative scoring would need a named lens-scored exception. Nothing in the current Midwest-crown default requires this; the tag exists so the Phase 0 verify reader can confirm the dependency was considered and found absent.

---

## 5. Complexity budget (paper math at M0 scale)

**Scale recited:** `5,000` lens citizens `[G per roadmap Phase 1 item 4]`, `~500` firms `[G per roadmap Phase 1 item 3]`, one region. Tick structure per §1.1: firm decisions weekly (staggered daily), placement pass daily, all decoupled from render at a fixed cadence (P11; Steam Deck is the bar).

- **Firm decisions (amortized daily).** `~500 / 7 ≈ 70` firms decide per game-day `[G]`; each profitability evaluation is a handful of multiplies over cached county/sector inputs, generously `~50` simple ops `[G]` → `~3,500` ops/day `[G]`. Negligible.
- **Placement pass (daily).** Of the `~70` deciding firms, generously `~30%` post non-zero events `[G]` → `~20` events/day `[G]`. Each `OPENINGS` event scans the unemployed same-shed candidate pool: worst case the whole unemployed stock, `~500` citizens at `10%` unemployment `[G]`; each candidacy check is `~10` integer/float ops `[G]` (shed test cached per county-pair, then comparisons) → `20 × 500 × 10 = 100,000` ops/day `[G]` worst case, typically far less (most events are small; the shed test prunes to one county). `LAYOFFS`/`CLOSE` events walk firm lens rosters (`≤ 50` `[G]` even for large M0 firms) → `~20 × 50 = 1,000` ops/day `[G]`. Accumulator updates and reconciliation are `O(events)` → trivial.
- **Total placement: `~100k–200k` simple ops per game-day tick `[G]`** (upper envelope; expected case an order of magnitude lower).

**Fit.** Even under the GDD §7 wall clock the P4 decision starts from (a game-day = `30` real seconds at `1×`, `~4` seconds at `8×` `[G per GDD §7]`), a daily tick owns whole seconds of wall clock; `~0.1–0.2M` simple ops `[G]` execute in well under `1` ms `[G]` on any modern CPU including the Deck APU — a headroom factor in the thousands. Projected full scale (`20,000` lens `[G]`, `3,000` firms `[G]`): `~130` events/day `[G]` over pools of `~2,000` `[G]` → `~2.6M` ops/day `[G]`, still under `10` ms `[G]`. **Conclusion: the placement pass is not the perf risk.** R4 risk lives where the review says it does — sub-daily beats × `20k` citizens × six needs `[G per appendix §3]` plus render (§3.3 of the review) — which Phase 1 item 9 measures. If the P4 time-scale decision shortens game-days, placement still fits: the pass could run `100×` per game-day `[G]` before approaching `100` ms `[G]`.

**Memory (sanity check).** Lens employment record `~64` bytes `[G]` × `5,000` = `~320` KB `[G]`; firm roster indices `~500 × ~10` refs `[G]`; event queue `~20` records/day `[G]`. Trivial at every planned scale.

---

## Open ambiguities (for the Phase 0 verify reader — honest list)

1. **Firm parameter table missing from appendix v0.1.** §1.5/§1.6 profitability bands (`+8%`/`+2%`/`-5%`/`-15%`), layoff size (`10–30%`), spawn size (`5–50` jobs), spawn siting, and the `80/15/5` firm-size split are this spec's `[G]` proposals only. If Lucas replaces them, §§1.2–1.5 mechanics stand but every trigger value changes.
2. **In-state destination choice.** §4.2 books the move; nothing here says *where* the truck goes (cheapest housing? most openings? nearest city?). Review §2.7 asks for this rule. M0 needs at least a null model (e.g., weighted-random by county openings `[G]`-to-decide).
3. **Interstate destination split.** Ohio vs other states for the ledger and the leaderboard gag (GDD §12). No share specified anywhere; M0 can book "out of state" undifferentiated, but the "Ohio gap" ticker (appendix §5) needs an Ohio fraction by Phase 2.
4. **Sector/skill matching.** M0 hires any unemployed citizen into any opening (§1.2). If Phase 1 playtesting shows miners becoming nurses too often to stay readable, a light affinity rule will be needed — costed against the §5 budget.
5. **Quit-then-rehire ping-pong.** A `QUIT` books `-1` statistically and the firm may re-hire next tick (§1.5). At tight labor markets this could churn the same lens citizen repeatedly. No rehire-damping specified; candidate: rehires prefer longest-unemployed (already the sort), which self-damps, but unproven.
6. **M0 sample shrinkage.** Retirements/deaths shrink the `5,000` lens with no M0 replacement rule (replacement is Phase 3 item 9). Over a 1-game-year `[G per roadmap Phase 1 exit]` M0 run the drift is small (death rate TBD — not in appendix v0.1), but the run must *report* closing lens count so perf extrapolations use the right `n`.
7. **County-varying cost of living.** M0 uses statewide `$400`/week `[G]` (§2.3). Traverse City vs Flint rents genuinely differ; deferring is safe for M0, wrong forever. Needs an appendix row by Phase 3.
8. **Part-time and shift pay.** All jobs full-time, no shift differentials (§2.3), yet appendix §3 implies night shifts exist. If scenarios need underemployment texture (part-time miners), the wage rule needs an hours dimension.
9. **Commute-mode reality.** `TRANSIT` exists only as a `0.7×` Southeast flag (§3.2). No transit coverage map, no car-ownership stat, no congestion (review §2.3 asks; this spec answers "no congestion in M0" — condition-gated speed only). Congestion stays cut unless Phase 2 dioramas demand visible traffic.
10. **Region-level fallback for roads condition.** §3.2 assumes county-level `roads_c`; if the budget system repairs only region-wide in M0, the function takes the region value for every county in it. Either input shape works — but Phase 1 items 1 and 6 must agree on one before coding.
11. **`season_mult` vs cut list item 6.** §3.2 carries the winter `1.2×` `[G]` with a kill-switch. If seasons go visual-only, delete the term; commute code must not keep reading a flag nothing sets.
12. **UP floor exact size.** `800` `[G]` (§4.3) is a judgment call balancing noise against lens budget (`4%` of `20k` for `~3%` of people — arithmetic on `[G]` inputs). Anything in `700–1,200` `[G]` serves; Lucas should pick by feel for "how many Yoopers must the map show."
13. **Money-need interpolation.** The `30 + 30 × (months − 1)` line (§2.3) is proposed, not appendix text. If Lucas wants cliff-edges instead of a ramp (poorer = sudden crisis), replace it — placement priorities that sort on Money need (§1.2) inherit whatever shape wins.
14. **M0 policy count mismatch (not coupling, flagged in passing).** Roadmap Phase 1 item 7 and GDD §21 say `10` policies; appendix §2 provides `12` rows. Somebody must pick the M0 `10` (or bless all `12`) before item 7 starts.
15. **Event-id width vs save/load.** `(day << 32) | firm_id` assumes `firm_id < 2^32` and day fits `32` bits (`4M+` game-years at daily ticks — safe `[G]`-by-arithmetic, but the save format in Phase 1 item 8 must preserve the counter across sessions or post-load ids collide with pre-save ones).

## Traceability (spec section → Phase 1 work item it de-risks)

| Spec section | De-risks Phase 1 item(s) | How the exit/verify step uses it |
|---|---|---|
| §1 placement pass (flow, priorities, fallback, waves) | **4** (lens citizens + placement, R1 core); **3** (firm hire/freeze/layoff/close/spawn triggers); **8** (deterministic order, event ids) | Item 4 exit: orphan query (`LAYOFF` with null `firm_event_id` = `0`); scripted-year log must show policy → firm event → lens change → macro move |
| §1.4 reconciliation identity + accumulator | **4**; **1** (county aggregates stay authoritative for the budget/tax base) | Debug assertion `aggregate == lens×S + statistical` every tick; totals-agree check in the 1-year run |
| §1.6 firm-parameter proposals | **3** (profitability bands, spawn rule) | Feeds appendix v0.2; item 3 cannot start without either this proposal or Lucas's replacement |
| §2 wage rule | **4** (offers, paychecks); **3** (wages as profitability input); **5** (household-$ flows into Money need) | Needs-engine test: single- vs dual-earner households diverge per §2.3; minimum-wage hike moves volumes with lag, never instant |
| §3 commute/pathing pick + function shape | **6** (movement/commute abstraction); **3** (`logistics_factor` into profitability); **5** (commute→Rest coupling) | Item 6 delivers exactly the two §3.2 functions; roads-blitz test: condition `+8`/yr → `road_mult`/`logistics_factor` move by formula |
| §3.4 corridor-snapped upgrade | Phase 2 diorama routing (out of Phase 1) | Recorded so Phase 2 does not re-litigate the M0 pick; no Phase 1 work |
| §4 scaling law + booking rules | **4** (what a lens transition books); **5** (migration booking); Phase 3 item 9 (sample maintenance bounds) | Exodus-ledger test: `N` lens exits book `N×S_r`; goal-scoring audit: no goal reads scaled lens counts (§4.3 rule 2) |
| §4.3 UP small-sample rule | Phase 3 full-region sampling (specified now, built later) | Sampling code reviewed against the floor/weight/noise-guard trio before Phase 3 starts |
| §5 complexity budget | **9** (perf harness tick budget); P11/R4 headroom argument | Harness asserts placement wall-time ≪ tick cadence at `5k/500` and `20k/3k`; §5 numbers are the paper prediction the measurements check |

*End of v0.1.*



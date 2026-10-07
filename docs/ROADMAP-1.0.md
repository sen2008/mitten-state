# Mitten State — 1.0 Roadmap

**Target:** shippable 1.0 on Steam for PC (Windows/Linux), $24.99 premium, Steam Deck as minimum spec.
**Team:** Lucas (solo dev, Godot 4 experienced) + AI coding agents doing heavy implementation.
**Sources:** GDD v0.1 (`docs/MITTEN-STATE-GDD-v0.1.md`), design review (`docs/design-review-muse-code.md`).
**Status:** draft — P1 win-condition decision still pending (see Phase 0 and Decisions log).

## How to use this document

Each phase has **Entry** (must be true before starting), **Work** (agentic-sized items, each one agent session with a verifiable artifact), **Exit** (must be true before moving on), and **Verify** (how Lucas confirms exit — run these, don't trust agent summaries).

Rule: no phase starts until the previous phase's exit criteria are checked off. The design review's core warning is that this GDD describes a 30–60 person studio's 3-year project; the only way solo+agents ships it is small phases with hard gates.

P1–P12 below refer to the design review's prioritized revisions (§5). A placement map is in the appendix.

---

## Risk register (read first — this is what's actually hard)

Front-loaded risks are marked with the phase that kills or contains them. If any of these fail, stop and re-scope before continuing; do not push through hoping later phases fix them.

| # | Risk | Why it's hard | Killed/contained by |
|---|---|---|---|
| R1 | Firm↔citizen coupling is unspecified and is the entire game (review 2.2, 1.5) | 3k firms × 20k citizens naive matching explodes; most small firms employ zero lens citizens, so "every layoff is visible" fails silently | Phase 0 spec (P3) + Phase 1 headless proof |
| R2 | Time-scale package is unsolved (review 1.2, 1.3) | Session length, day length, beat readability, and day/night cycle contradict each other; tuning them separately guarantees rework | Phase 0 single decision (P4), validated in Phase 2 |
| R3 | Illegible causality — "did I do that?" (review 4.2) | The #1 quit moment in this genre; if attribution UI slips to beta, the M1 playtest question can't be answered | Phase 0 spec + Phase 2 build (P10) |
| R4 | 20k-agent perf on Steam Deck (review 3.3) | Deck APU is the hard bar, not "mid-range PC"; paper estimates prove nothing | Phase 1 measured headroom (P11) |
| R5 | Zoom scope is the largest unacknowledged cost (review 1.11, 3.1) | Street-level statewide art + procedural towns rivals the sim in cost | Phase 0 re-scope to dioramas (P9) |
| R6 | Screensaver problem — nothing to do between slow verbs (review 4.1) | Annual budgets and 4-year terms vs. a 2–4 hour session; idle minutes kill the game | Phase 2 pacing instrumentation + fast-loop verbs |
| R7 | Economy balanced on invented numbers (review 2.1) | No starting values exist anywhere; every agent invents its own economy without the appendix | Phase 0 numbers appendix (P2) |
| R8 | Life-sim scope creep (review 3.2) | Marriage/kids/generations is a second game that can't pay off in a one-term slice | Phase 0 cut, enforced every phase |

---

## Phase 0 — Design lock (paper, no code except spikes)

**Goal:** every paper decision the review demands, made and written down, before agents write sim code.
**Estimate:** 1–2 weeks. Mostly Lucas + short agent drafting passes. This phase is cheap; skipping it is expensive.

### Entry
- GDD v0.1 and design review read and accepted as the working baseline (done).

### Work
1. **P1 — Win condition (⚠️ DECISION PENDING).** Default proposal: **Midwest crown** — campaign win = Michigan ranked #1 in GDP *among Midwest states* (BEA East North Central + West North Central: OH, IN, IL, WI, IA, MN, MO, MI, etc.) AND Top 10 nationally by GDP, within the campaign arc. Tiered legacy ranks below that (Top 15 → Top 10 → Top 5 nationally, #1 per-capita stretch) so partial progress feels like winning. Why this default: achievable in multi-term compounding, keeps the Ohio rivalry load-bearing (Ohio is a Midwest state — beating them is literally the win), preserves "epic" framing. The #1-national-GDP goal is arithmetically dead (6x gap vs California, review 1.1) and must not survive this phase in any form. **Lucas must explicitly confirm or replace this before Phase 3 campaign-balance work begins; nothing downstream may assume it until then.** Artifact: one paragraph in the GDD + updated README line.
2. **P2 — Numbers appendix.** Starting budget ($ size, department splits), tax defaults/ranges, 10–15 M0 policy costs + effect magnitudes, need decay rates, demand cadence (arrival rate, max concurrent), thresholds (bond cut, exodus count, faction-floor timer — "under 25 for how long"), election formula, dollar scale ($200M means what vs. the budget). 1–2 pages. Artifact: `docs/numbers-appendix-v0.1.md`. Agents may draft; Lucas sanity-checks every number.
3. **P3 (spec half) — Firm↔citizen coupling + movement on paper.** The placement pass: firms post aggregate openings/layoffs → a placement pass assigns lens citizens → most churn stays statistical. Wage rule (who sets "local wages"). Commute/pathing abstraction (road-graph pathing vs. straight-line + time penalty — pick one for M0). Lens-vs-aggregate scaling law (what one lens mover "counts" as; UP small-sample rule per review 1.4). Artifact: added to numbers appendix or `docs/coupling-spec-v0.1.md`.
4. **P4 — Time-scale package, one decision.** Day length, speeds offered, term/session length at intended speeds, beat readability budget (seconds per beat per speed), day/night resolution (recommendation: per-beat lighting tint, not a sun cycle). Output is one equation: "a term is X hours at intended speeds because day=A, speeds=B." Artifact: GDD §7 rewritten.
5. **P5 — Political capital: define or delete.** If kept: income source, spend options (fast-track, emergency powers, demand buyouts), cap. If cut: remove from GDD §5 and name the fast-loop verbs that replace it (review 4.1 needs 2–3). Artifact: half page.
6. **P6 — Legislature call + election formula.** One paragraph: "the legislature is abstracted as…" (or minimal friction layer spec). Exact election rule: blend weights, noise/margin of error, narrow-vs-landslide outcomes (campaign-end vs. continue), Main Street's electoral weight (review 1.11). Artifact: half page each.
7. **P7 — Fix the north.** Split Traverse City tourism orbit into Lakeshore vs. rural-identity-first Up North/Yoopers with demand rotation — pick one. Fix Appendix A Detroit-transit row. Artifact: GDD §4/§5/Appendix A edits.
8. **P9 (scope half) — M1 re-scope paragraph.** "Statewide sim numbers + Southeast dioramas; N agents for the slice; demographic cuts (age/retire/die + job changes only, no marriage/kids); 50-state leaderboard faked with scripted curves + noise; interstate deals as authored event chains." Plus re-ordered cut list (see below). Artifact: GDD §21 rewritten.
9. **P10 (spec half) — Attribution UI spec.** "Watch this" lists, "because" lines, approval-delta feed, vignette button, peep filters, faction "top 3 drivers" panels. Specified now, built in Phase 2. Artifact: `docs/attribution-ui-spec-v0.1.md` (wireframe-level, even ASCII).
10. **P11 (restatement) — Perf bar.** "60fps render; fixed-cadence sim ticks independent of frame rate; Steam Deck is *the* minimum spec." M0's "on paper" becomes "measured headroom on Deck or Deck-equivalent APU." Artifact: GDD §18 edit.
11. **P12 — Deletions.** Delete multiplayer tease; publicly defer JSON modding (ship data-driven internals, promise no public schema); ironman is a checkbox, ship the toggle, no deliberation. Artifact: GDD edits.
12. **Language decision (GDD §18 open question).** C# vs GDScript vs both (C# sim core, GDScript UI). Decide with a one-day spike if needed: 5k-agent tick benchmark in each. Recommendation going in: C# sim core for R4 headroom, GDScript UI for iteration speed — but the spike result wins, not the recommendation. Artifact: one paragraph + benchmark numbers.

### Exit
- [x] Numbers appendix exists with every P2 field filled (no TBDs in M0-scoped rows).
- [ ] Coupling spec + time-scale equation + election formula exist on paper.
- [ ] P1 default (Midwest crown) confirmed or replaced by Lucas — recorded in Decisions log either way.
- [ ] Cut list re-ordered; multiplayer deleted; modding deferred in writing.
- [ ] Language decision recorded with benchmark evidence.

### Verify
- Hand the numbers appendix + coupling spec to a fresh agent and ask it to list the ambiguities. If it finds blocking ones, Phase 0 isn't done.
- Check: every M0 work item in Phase 1 traces to a number or rule written in Phase 0. Orphans mean Phase 0 gaps.

---

## Phase 1 — M0: headless sim prototype

**Goal:** prove the macro→micro→macro loop and perf headroom with zero art. Kills R1 and R4 or stops the project honestly.
**Estimate:** 4–6 weeks (GDD §21). Agents build; Lucas reviews sim behavior against the appendix.

### Entry
- Phase 0 exit criteria all checked.

### Work (each item = one agent task, headless, tested without rendering)
1. County-aggregate macro layer: budget (revenue from tax model, 7 departments of expense), debt + bond-rating thresholds from appendix.
2. Tax model per appendix (ranges, base, elasticity, response lag).
3. Firm agents (start ~500 in one region, scale test to 3k): profitability function from appendix inputs, hire/freeze/layoff/close thresholds, spawn rule.
4. **Lens citizens (5k, one region) + coupling placement pass (R1 core).** Firms post openings/layoffs; placement assigns lens citizens; statistical churn for the rest. Includes wage rule and scaling law from Phase 0 spec.
5. Needs engine (six needs, decay/restore rates, behavior threshold table) with the Money-vs-household-budget contradiction resolved per appendix.
6. Movement/commute abstraction per Phase 0 pick; infrastructure condition → commute/logistics effect functions.
7. 10 policies from the catalog with costs, effects, delays + leading-indicator events (P8 rule starts here: no delayed policy without staged precursors, even headless-logged).
8. Determinism + save/load of full sim state (seeded RNG; same seed + same inputs = same outputs).
9. **Perf harness (R4 core, P11):** headless tick-time benchmark at 5k/10k/20k citizens × 500/3k firms, run on Deck or Deck-equivalent APU. Render fps is out of scope; sim-ms-per-tick is the metric.

### Exit
- [ ] A scripted 1-game-year run produces a legible cause chain in logs: policy → firm response → lens citizen behavior change → macro number move (the loop exists).
- [ ] Placement pass handles hire/layoff/close/spawn waves without orphans (every lens layoff traces to a firm event; every firm event has its statistical + lens representation defined).
- [ ] Perf: full-tick budget (daily macro + sub-daily beats) fits inside the frame-independent tick cadence with ≥2x headroom at 20k/3k on Deck-class hardware. If not: reduce agent count, simplify the tick, or re-scope — do not proceed hoping optimization saves it later.
- [ ] Determinism check passes (same seed twice = identical state hash).

### Verify
- Lucas runs the 1-year script and reads the log: can he narrate what happened and why? If not, readability (GDD §22 risk #1) already fails headless — fix the model, not the UI.
- Perf numbers recorded in `docs/perf-budget.md` with hardware named. No numbers, no exit.

**Honest note:** this is the phase most likely to force re-scoping. If the coupling spec doesn't survive contact with code, or Deck headroom isn't there at 20k, the correct outcome is a smaller agent count, a simpler tick, or diorama-concentrated peeps — decided here, not in beta.

---

## Phase 2 — M1: vertical slice (Southeast dioramas + statewide numbers)

**Goal:** answer *"is it fun to watch?"* with attribution UI as scope, not polish. Kills R3 and R6; validates R2 and R5.
**Estimate:** 8–12 weeks (GDD §21). Largest art cost in the project; guard it.

### Entry
- Phase 1 exit criteria all checked, perf numbers on file.

### Work
1. Map render: equirectangular projection of `maps/mitten-state-geo.json` (loader + projection per `maps/README.md`), stylized statewide view.
2. **Southeast dioramas (P9, R5 core):** curated set for the slice (auto town, suburb, Detroit-street vignette, farm edge) — peep life concentrated here, rest of state stylized. Per-beat lighting tint, seasonal palette/weather overlays. No sun cycle, no procedural statewide towns.
3. Lens citizen rendering + LOD: full beats for on-screen diorama citizens, reduced rate off-screen; thought-bubble priority/culling rules (spec the rule: max N bubbles, priority = followed > event-affected > need-critical).
4. Peep cam: click-to-follow any visible citizen, live thought bubbles, text log of recent life events (no scrubable timeline — cut per review 3.4.6).
5. **Attribution UI (R3 core, P10):** policy "watch this" lists, "because" lines on map events, approval-delta feed, per-policy quarterly report card, faction "top 3 drivers" panels, vignette button (jump to curated moment + auto-pause), peep browser with filters ("affected by my last 3 policies").
6. One term goal set (directive goals per GDD §13, slice-sized) + lose conditions (bankruptcy spiral stages, exodus counter) with staged early warnings (review 4.6) and visible "Ohio gap" ticker from day one.
7. Faction demands (Southeast-relevant subset) with enforced stakes + deadlines in data validation (no demand ships without both — review 4.4).
8. Events deck, slice-sized: draw-rate machine + cooldowns + repeat rules (review 2.10) with ~10 authored events.
9. **Pacing instrumentation (R6 core, review 4.1):** log time-between-player-actions; target a decision every 2–3 minutes via demands + events + quarterly check-ins; 2–3 fast-loop verbs live (per P5 outcome). Treat >4 idle minutes as a bug in playtests.
10. Quarterly polls with teeth (review 4.5): staged consequences, visible primary-challenger meter, monthly headline summaries with faces attached.
11. Deck check: slice runs at 60fps render with sim tick decoupled; first Deck or Deck-equivalent playtest.

### Exit
- [ ] A fresh player (Lucas counts if honest; one outsider is better) plays 60 minutes and can narrate what happened in the last 5 minutes and *why* (causation test — review 4.3).
- [ ] Attribution UI complete per Phase 0 spec: every approval change has a clickable reason; every delayed policy shows leading indicators.
- [ ] Pacing: median time-between-actions ≤3 min; no >4-min idle stretch without a demand/event/check-in firing.
- [ ] 60fps render on Deck-class hardware in the heaviest diorama view; sim tick never blocks render.
- [ ] Playtest question answered in writing: "is it fun to watch?" with what specifically worked/failed.

### Verify
- Record the 60-minute playtest (even phone video of the screen + Lucas narrating). Watch it back muted: is the map telling the story? If the story needs the dashboards, pillar 4 fails.
- Review the action-gap log: list every >4-min gap and what fired to break it. Gaps with no breaker are exit blockers.

**Honest note:** the diorama art pipeline is the likeliest schedule blowup in this phase. If dioramas cost more than ~30% of phase effort, cut diorama count (fewer venues, denser life) before cutting attribution UI — readable causation is the game, extra streets are not.

---

## Phase 3 — M2: alpha (all regions, full systems)

**Goal:** the whole state, all six factions, full policy catalog, elections. Breadth phase — no new engine work unless a system proves broken.
**Estimate:** 8–12 weeks.

### Entry
- Phase 2 exit criteria checked; "fun to watch" answered yes (or the specific no fixed and re-tested).

### Work
1. Remaining four regions: diorama sets per region (West/Lakeshore, Central, North, UP — 2–4 venues each, archetype-templated per review 3.1 option b where it saves art).
2. All six factions live with full demand decks, cadence per appendix, Superior-secession chain staged.
3. Full policy catalog (~40–60 cards) with P8 leading-indicator checklists enforced in data validation.
4. Full events deck (~40+ events) incl. Ohio poaching chains, federal grants, secession petition, October surprise.
5. Elections: formula per Phase 0, campaign season (final 6 months: approval-double rule implemented as specified, event-rate shift), narrow-vs-landslide outcomes, multi-term continuation.
6. Interstate layer, faked per P9: scripted rival growth curves + noise, real Michigan numbers, migration leaderboard, border report; deals as authored event chains only.
7. Statewide sim at full agent count (per Phase 1 perf ceiling — scale to measured headroom, not to 20k-by-schedule).
8. Amenity/leisure generator (review 2.13): procedural venues per town archetype so leisure beats have stages.
9. Sample maintenance (review 2.14): dead/moved lens replacement preserving distribution; demographic bounds enforced.
10. Full save/load + ironman toggle (P12: just ship it).
11. Balance pass 1: appendix numbers tuned from alpha playthroughs; update the appendix (it stays the source of truth).

### Exit
- [ ] Full 4-year term playable start → re-election with all systems live; both lose conditions reachable and observed in testing.
- [ ] All six factions' demand rotations fire at appendix cadence with zero validation errors (stakes + deadlines present).
- [ ] Campaign continuation works: post-election state carries correctly into term 2 (debt, approval baselines, leaderboard position).
- [ ] Perf still holds at full-region agent count on Deck-class hardware.
- [ ] Ironman + saves survive a full term without corruption (save/load round-trip test each game-year).

### Verify
- Two full-term playthroughs (different strategies: e.g., roads blitz vs. university surge) with outcome notes: did the strategies feel different on the map and in peep lives? If both terms play the same, balance or faction differentiation failed.
- Automated: demand/event data validation passes; save round-trip test green.

---

## Phase 4 — M3: beta (scenarios, leaderboard, balance, polish)

**Goal:** content completion, campaign-win tuning, and the polish that makes the Steam page honest.
**Estimate:** 6–8 weeks + external playtester time.

### Entry
- Phase 3 exit criteria checked.

### Work
1. Scenarios: The Plant Closing, The Big Snow, Brain Drain (Plant Closing doubles as the demo — build it first).
2. Campaign layer: Midwest-crown progress tracking (or P1 replacement), tiered legacy ranks, epilogue screen (legacy stats, notable followed citizens, headlines caused).
3. Balance pass 2 (campaign-scale): multi-term economy tuning so the P1 win is achievable-but-earned in N terms (define N: recommend 3–5 terms); rival curve tuning; exodus/bankruptcy pacing so danger is felt by mid-term-1.
4. Seasons' gameplay effects (if surviving cut pressure): winter commute/school effects, summer tourism surge, fall bump — else visual-only per cut list.
5. Audio: ambient beds, seasonal soundscapes, UI sounds, score, event stingers (review: light but present; no voice acting).
6. Accessibility: colorblind-safe faction colors, full pause audit, scalable UI text.
7. Closed beta: 10–20 external players, full terms, feedback survey keyed to the fun risks (attribution? pacing? Ohio gag still working?).
8. Bugfix + perf: Deck verification prep (see launch checklist), load-time audit, crash triage to zero known crashes.

### Exit
- [ ] All three scenarios completable with win/loss paths tested.
- [ ] Campaign win achieved in internal testing within the designed term count by at least two distinct strategies.
- [ ] Beta survey: ≥70% "could tell why things happened" (attribution), ≥70% "always had something to do" (pacing). Below that, fix and re-survey — do not launch deaf.
- [ ] Zero known crash bugs; Deck holds 60fps render in all regions.

### Verify
- Beta survey numbers on file with n ≥ 10 full-term completions.
- Campaign-win playthrough recorded with strategy notes (proves the win exists and isn't one degenerate path).

---

## Phase 5 — M4: launch

**Goal:** 1.0 on Steam. No new features after Phase 4 exit except launch-blocker fixes.

### Entry
- Phase 4 exit criteria checked, including survey bars.

### Launch checklist
- [ ] **Steam page (do this EARLY — ideally during Phase 3):** Coming Soon page live with capsule art, 5+ screenshots (real dioramas, no mockups), short trailer (map zoom → peep vignette → policy → payoff, ≤90s), description with the one-sentence pitch, system requirements naming Steam Deck support. Needs Steamworks partner setup + page review lead time (weeks).
- [ ] **Steam Deck Verified:** submit for Deck compatibility review; fix any failures (text legibility at 720p/800p, controller-glyph issues even for mouse-first — Deck trackpads count, check the current requirements).
- [ ] **Demo:** The Plant Closing as free demo (per GDD §19); demo branch cut from beta-stable build; demo→wishlist/full-game funnel wired (end card links).
- [ ] **Steam Next Fest:** check the current schedule and apply the edition BEFORE the one you want (acceptance + build deadlines close months out); demo build frozen ≥2 weeks before Fest; Fest-week plan (Lucas streams/plays the demo, patch window reserved, feedback form live).
- [ ] **Steamworks integration:** achievements (small set: first re-election, Midwest crown, survive the Big Snow…), cloud saves, stats if cheap. Cut Rich Presence and anything else that isn't checklist-grade.
- [ ] **Build hygiene:** Windows + Linux builds from clean checkout (macOS cut — decided 2026-10-06, signing/notarization not worth solo-dev time); version stamp; crash reporting or at minimum a log-file path players can paste.
- [ ] **Store compliance:** age rating questionnaire, content disclosure (no surprises — it's a cozy gov sim, but fill the forms), tax/banking in Steamworks, $24.99 price + regional pricing review.
- [ ] **Press/influencers:** 20–50 keys to management-sim YouTubers/streamers + Michigan-angle press (local hook is real: "govern Michigan" plays in Detroit/Grand Rapids media) 1–2 weeks pre-launch; one-page press kit (pitch, facts, screenshots, trailer link).
- [ ] **Launch-day ops:** release build staged, rollback build kept, Lucas available for 48h hotfix window, known-issues thread template ready, review-response plan (read everything week one, patch fast).
- [ ] **Post-launch stub (not 1.0 scope):** "Your State" DLC pipeline stays an idea; JSON modding stays deferred; generational life-sim stays parked. Write these on the post-1.0 list so they stop bidding for 1.0 attention.

### Exit
- [ ] 1.0 live on Steam, Deck status resolved (Verified or documented reason why not), demo live, Next Fest entered or scheduled.

---

## Cut list (re-ordered per review 3.5 — cut top-down as needed)

1. ~~Multiplayer tease~~ — deleted in Phase 0, not parked.
2. JSON modding public schema — deferred post-1.0 (internals stay data-driven).
3. Demographic depth — ship age/retire/die + job changes only; marriage/kids/generations parked.
4. Follow-mode scrubable timeline — cut; follow + live bubbles + text event log only.
5. 50-state fidelity — spirited fake (scripted curves + noise + real Michigan); never a real 50-agent sim for 1.0.
6. Seasons' gameplay effects — visual + audio only if balance/time pressure demands.
7. Firm agents → sector-level stats — **last resort.** Losing firms guts pillar 1; cutting here means redesigning the game's core promise, not trimming scope.

Rule: cuts 1–4 are pre-decided. Only 5–7 require a decision at the time, and 7 requires stopping to re-plan, not silently shipping.

---

## Decisions log

| ID | Decision | Status | Default / outcome |
|---|---|---|---|
| P1 | Campaign win condition | ⚠️ PENDING (Lucas) — must resolve in Phase 0 | Midwest crown: #1 Midwest GDP + Top 10 national, tiered legacy ranks |
| LANG | C# vs GDScript | Open → Phase 0 spike decides | Lean C# sim / GDScript UI |
| P5 | Political capital | Open → Phase 0 | Define (preferred — feeds fast loop) or delete |
| LEG | Legislature abstraction | Open → Phase 0 | One-paragraph abstraction (simplest shippable) |
| NORTH | Faction/region fix | Open → Phase 0 | TBD in Phase 0 work item 7 |
| TIME | Time-scale equation | Open → Phase 0 | Longer readable days + per-beat tint + honest term-hours |
| N | Campaign length (terms to win) | Open → Phase 4 balance | 3–5 terms |
| MAC | macOS at launch | **Decided 2026-10-06: cut** | Windows + Linux only |

---

## Appendix: P1–P12 placement map

| Rev | Title | Specified | Built/validated |
|---|---|---|---|
| P1 | Replace #1-GDP win | Phase 0 (⚠️ pending Lucas) | Phase 4 campaign tuning |
| P2 | Numbers appendix | Phase 0 | Used Phase 1+, tuned Phase 3–4 |
| P3 | Firm↔citizen coupling + movement | Phase 0 (paper) | Phase 1 (headless proof) |
| P4 | Time-scale package | Phase 0 (one decision) | Phase 2 (playtest validation) |
| P5 | Political capital or delete | Phase 0 | Phase 2 (fast-loop verbs) |
| P6 | Legislature + election formula | Phase 0 | Phase 3 (elections) |
| P7 | Fix the north | Phase 0 | Phase 3 (all factions live) |
| P8 | Leading-indicator rule | Phase 0 (checklist on card template) | Phase 1 (headless) → 2–3 (visible) |
| P9 | Re-scope M1 + cut list | Phase 0 | Phase 2 |
| P10 | Attribution UI as scope | Phase 0 (spec) | Phase 2 (build) |
| P11 | Decouple tick; Deck is the bar | Phase 0 (restatement) | Phase 1 (measured) → every phase after |
| P12 | Delete multiplayer; defer modding | Phase 0 | — |

## Appendix: source traceability

- Milestones M0–M4: GDD §21 → Phases 1–5 (Phase 0 is new: the review's pre-production demand).
- Factions, policies, events, scenarios: GDD §5, §10, §11, §13 → Phases 2–4 as staged above.
- Risks R1–R8: design review §§1–4; each phase's honest note names its likeliest failure.
- Geo data: `maps/mitten-state-geo.json` + `maps/README.md` → Phase 2 work item 1.

# M1 Vertical-Slice Re-scope Decision v0.1 (Phase 0, P9 scope half)

**DRAFT-NEEDS-LUCAS-REVIEW — paper only. No game code, no GDD edit, no other file touched. Every value below is draft until Lucas locks it.**

**Locked scope (recited, not decided here):** PC via Steam, Windows + Linux only; macOS cut (decided 2026-10-06); Steam Deck is THE minimum-spec perf bar (60fps render, fixed-cadence sim tick decoupled from frame rate); $24.99 premium, no microtransactions; mouse-first information-dense UI; no multiplayer (deleted, not parked); no public JSON modding schema (internals stay data-driven, schema deferred post-1.0); ironman is a checkbox, ship the toggle.

**Flag legend:** `[G]` = gameplay figure invented in a Phase 0 draft, tunable in Phase 3–4 balance. `[R?]` = real-data-anchored but unverified here. `[NEEDS-P1]` = depends on the undecided campaign win condition — assumed nowhere; the Midwest-crown default is NOT assumed in this doc.

**Sources read:** review P9 + §§1.11, 2.14, 3.1, 3.4.6, 3.5, 4.1; GDD §§4, 5, 18, 21; numbers appendix v0.1; coupling/time-scale/PC/legislature/north-fix decisions; ROADMAP-1.0 (Phase 0 item 8, cut list, Decisions log, P9 row); `maps/mitten-state-geo.json` + README (30 cities, 9 highways, 83 counties, 5 regions, all coords verified).

**Agent-count provenance (read before §1):** appendix v0.1 contains NO agent-count table (lens/firms/macro rows do not exist there — same class of gap as the coupling spec's flagged missing firm table). Per the no-invention rule, slice counts below are adopted exactly from the roadmap + coupling spec + GDD, flagged to source: 5,000 lens citizens in-region `[G per roadmap Phase 1 item 4; coupling §4.1]`; ~500 firms M0 in-region → up to ~3,000 statewide `[G per roadmap Phase 1 item 3; coupling §1.6]`; macro = county-aggregate layer over all 83 counties (geo file). Proposed appendix v0.2 addition: a §8 agent-count table reciting these. **DRAFT-NEEDS-LUCAS-REVIEW.**

---

## 1. Proposed GDD §21 replacement text (quoted verbatim-ready)

> **M1 — Vertical slice (8–12 wks): statewide sim numbers + Southeast dioramas.** The simulation runs statewide from day one (83-county aggregate macro layer: $70B budget, 7 departments, tax model, bond/exodus/faction-floor timers per the numbers appendix), but cameras live in the Southeast: 5,000 lens citizens `[G]` concentrated in four curated SE dioramas (auto town, suburb, Detroit-street vignette, farm edge), with the rest of the state rendered as stylized map. Firms simulate statewide (up to ~3,000 `[G]`, scaled to measured Deck headroom — never below ~500 SE-anchored). Demographics are age/retire/die + job changes only; marriage/kids/generations are parked post-1.0 (cut #3). The 50-state leaderboard is a spirited fake for all of 1.0 — scripted rival growth curves + noise against real Michigan numbers, never a 50-agent sim (cut #5). Interstate deals exist only as authored event chains (bidding wars, compacts, Ohio-poach attempts), never as negotiation systems. Day/night is per-beat lighting tint, never a sun cycle; seasons are visual/audio-only unless Lucas defends gameplay seasons in Phase 0 (cut #6). Follow-cam ships with live bubbles + text life-event log; the scrubable timeline is cut (cut #4). Playtest question: *"Is it fun to watch?"* — judged by the 60-minute causation test (player narrates the last 5 minutes and why), median action gap ≤3 min, and 60fps render on Deck-class hardware with the sim tick decoupled.

**DRAFT-NEEDS-LUCAS-REVIEW** — Lucas applies to GDD §21 at lock; this file does not edit the GDD.

---

## 2. Diorama scope (curated SE set)

**M1 ships (roadmap Phase 2 item 2, `Southeast/Motor` = Genesee→Wayne, 12 counties, geo file):** (a) auto town (Flint/Dearborn orbit — Motor faces: shifts, layoffs, hiring waves); (b) suburb (Royal Oak/Southfield orbit — Main Street faces: schools, roads, move-ins); (c) Detroit-street vignette (one readable street, not the metro — commute access, transit flashpoint, plant-gate crowds); (d) farm edge (SE fringe counties — Growers faces: harvest, labor, water). Peep life is concentrated here: full beats + thought-bubble priority (followed > event-affected > need-critical `[G]`), max-N bubble cap owned by Phase 2 build. Rest of state: stylized map (equirectangular projection per `maps/README.md`), aggregates + headlines only, no peeps. Lighting: per-beat tint cross-fades (sleep = night-dark → commute = dawn → work = day → leisure = dusk → home = evening `[G]`); NO sun cycle (rejected: 11 s strobe at 4x). No procedural statewide towns, ever in 1.0.

**M1 does NOT ship (Phase 3 / M2 alpha adds):** remaining four region diorama sets (2–4 venues each, archetype-templated); UP lens floor + noise guard (800 `[G]`, trailing-4-quarter rates, n<50 suppression); amenity/leisure generator; sample maintenance (dead/moved lens replacement — M0/M1 lens shrinks slowly, closing count reported); full 6-faction demand decks + secession chain; full events deck (~40+) + October surprise staging; elections + campaign season + multi-term continuation; faked interstate layer UI (leaderboard, border report). **Crisp line: M1 = one region watchable, five regions simulated; M2 = five regions watchable.**

**DRAFT-NEEDS-LUCAS-REVIEW.**

---

## 3. Re-ordered cut list (reconciled with roadmap — identical order, M1 status added)

| # | Cut | Status | Rule at decision time |
|---|---|---|---|
| 1 | Multiplayer tease | DELETED Phase 0, not parked | None — gone. |
| 2 | JSON modding public schema | DEFERRED post-1.0 (internals data-driven) | None — promise stays unmade. |
| 3 | Demographic depth → age/retire/die + job changes only | PRE-DECIDED, enforced M1 | Households fixed at spawn; any marriage/kids PR is rejected in review. |
| 4 | Follow scrubable timeline → follow + live bubbles + text log | PRE-DECIDED, enforced M1 | Timeline branch never opens; Phase 2 item 4 is the spec. |
| 5 | 50-state fidelity → scripted curves + noise | FAKE locked for M1; re-confirm at M2 | If fake reads as dead in M1 playtests: add authored texture (poach events, border headlines), never a real sim. Lucas call. |
| 6 | Seasons' gameplay effects → visual/audio-only | RECOMMENDED default for 1.0; Lucas confirms in Phase 0 | `season_mult` kill-switch stays specified (=1.0); flipping to gameplay seasons costs a balance-surface quadrupling — Phase 0 decision only, never mid-alpha drift. |
| 7 | Firm agents → sector-level stats | LAST RESORT, never silently | **STOP AND RE-PLAN.** Trigger: Deck headroom fails at minimum firm count with simplified tick. Action: halt milestone, Lucas + agents redesign the core promise (pillar 1 cannot survive this cut as a trim). No agent may ship it as a quiet optimization. |

Cuts 1–4 are pre-decided. Only 5–7 require a decision at the time, and 7 is a project-stop, not a trim. **DRAFT-NEEDS-LUCAS-REVIEW.**

---

## 4. Consistency checklist vs sibling Phase 0 docs

| Doc | Rule adopted | M1 impact |
|---|---|---|
| Appendix (P2) | $70B budget, 7 depts, tax ranges/lags, 12 policies w/ P8 precursors, 6 needs + thresholds, demand cadence ~6/yr max-3 (M0: 2), bond/exodus/faction-floor timers, election formula, dollar scale | M1 sim numbers statewide; SE demand subset only (below); M0-10-of-12 policy pick still open (coupling amb. 14) |
| Coupling (P3) | Firms post aggregate events → daily deterministic placement pass → lens transitions; orphan count = 0; wage index; straight-line commute + `road_mult`/`logistics_factor`; S_SE ≈ 1,000 `[G]`; aggregates are truth, lens is faces | M1 lens = 5k SE at S≈1,000: a −200 layoff usually moves zero peeps BY DESIGN; −200s surface as headlines + smoke-stops |
| Time-scale (P4) | Day = 45 s at 1x `[G]`; pause/1x/2x/4x, 2x cruise default, 8x cut; honest term ~6–8 h; beats readable 1–2x, mitigated 4x (auto-pause, vignette button, culling); per-beat tint; quarterly autosave | M1 pacing tuned + measured at 2x; vignette button + auto-pause hooks are M1 scope (P10), not polish |
| PC (P5) | Pool 0–100, start 30; quarterly income base +10 `[G]` + approval + demand bonuses; spends: visit 5 / buyout-extend 15 / fast-track 20 / emergency 30; no trickle, cap 100 | M1 ships ≥2 fast-loop verbs (visit + buyout minimum `[G]`); heartbeat math: ~90% of 2–3-min cadence from events + check-ins + PC verbs |
| Legislature (P6) | (a) abstracted — zero M0/Phase-1 surface; B1 weights (Main St 44.3% `[G]`); campaign season = final 182.5 days, approval deltas ×2, PC income flat; October surprise ±3–5 final, 25–35 days out `[G]`; tiers incl. 47% sandbox line | M1: no legislature object; campaign-season + surprise rules built in M2 (M1 is slice pacing, not elections); mandate clause void (no friction target) |
| North-fix (P7) | (a) RECOMMENDED: N. Michigan tourism → Lakeshore sub-identity; Yoopers = UP-only; "Traverse City bartenders root for Lakeshore"; Detroit-transit row → Main St (SE) + Motor; Lakeshore ~14% / Yoopers ~7% re-split `[G]` | **SE framing:** M1 demand subset = Main Street + Motor + Campus (Ann Arbor is SE) + Growers (farm edge); Lakeshore cameo at most (riverfront tourism); Yoopers/secession absent until M2. A North visit targets Lakeshore, never Yoopers. |

[NEEDS-P1] anywhere a campaign win could touch scoring: sandbox-continue eligibility, mandate interactions, leaderboard-as-win-progress — none assumed; M1 needs none of it. **DRAFT-NEEDS-LUCAS-REVIEW.**

---

## 5. Verify test: what does the M1 player actually see and do?

The M1 player governs Michigan from a stylized statewide map with real numbers (budget, taxes, faction meters, Ohio-gap ticker) and watches life happen in four Southeast dioramas: they set taxes and the annual budget, play policy cards with visible staged precursors (barrels → work zones → open road), answer a faction demand or event every few minutes, and spend political capital on visits, buyouts, and fast-tracks between quarters — while auto workers clock in, suburban families react in thought bubbles, every approval change carries a clickable "because" reason, and quarterly polls with teeth judge them, all at a 2x cruise they can pause, follow any peep through, or skip at 4x with auto-pause catching every life event. If a 60-minute playtest can't narrate the last 5 minutes from the map alone, M1 fails.

---

## 6. Direct questions for Lucas (one-line answers unblock lock)

1. Lock M1 at 5,000 SE lens + statewide firms ≤3,000 `[G]` scaled to measured Deck headroom — or name other counts?
2. Confirm the 50-state fake + deals-as-events stands for ALL of 1.0, not just M1?
3. Confirm seasons visual-only for 1.0 (kill-switch stays), or defend gameplay seasons now?
4. Confirm M1 demand subset excludes Yoopers/Lakeshore-as-faction (cameo only) until M2?
5. Confirm cut #7 = stop-and-replan tripwire as written — no silent fallback to sector stats?

**DRAFT-NEEDS-LUCAS-REVIEW — end of v0.1.**

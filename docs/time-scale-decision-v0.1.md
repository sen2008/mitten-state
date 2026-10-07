# Mitten State — Time-Scale Decision v0.1 (Phase 0, P4)

**DRAFT-NEEDS-LUCAS-REVIEW** — the entire document below is draft. No Phase 1+ work may treat any value here as final until Lucas reviews it.

## 0. What this is

Decision record + draft rewrite of GDD §7 (Time, pacing & scale). Resolves review §§1.2, 1.3 and P4 as one package: day length, speeds, term/session length, beat readability, day/night — one equation, not five tunables.

**Sources read:** GDD §7 (plus §§6, 8, 15, 16, 18, 21 for dependents), review §§1.2, 1.3, P4 (plus 2.10, 2.15, 3.4, 4.1–4.3 for dependents), numbers appendix v0.1, coupling spec v0.1, roadmap (risk R2, Phase 2 validations, cut list, decisions log).

**Flag legend:** `[G]` = gameplay figure invented in this draft (tunable in Phase 3–4). `[R?]` = real-data-anchored but unverified here (confirm against Michigan docs). `[NEEDS-P1]` = depends on the pending win-condition decision; assumed nowhere.

**P1 interaction:** none. This decision sets wall-clock mapping only. Campaign-total hours are marked `[NEEDS-P1]` in §7 and left uncomputed as a commitment.

---

## 1. THE EQUATION

A term is **4 game-years × 365 days = 1,460 game-days** (365-day years, no leap years `[G]`; calendar detail in §10.6). A day is **45 real seconds at 1x** `[G]` (§2). Speeds offered are **pause + 1x/2x/4x** (§3).

**Per-speed term-length table (sustained speed, zero pauses — the trade Lucas is buying):**

| Speed | Sec / game-day | Full 4-year term | Status |
|---|---|---|---|
| 1x | 45.0 | 65,700 s = **18.25 h** | designed-for (watch) |
| 2x | 22.5 | 32,850 s = **9.13 h** | designed-for (cruise, default) |
| 4x | 11.25 | 16,425 s = **4.56 h** | allowed, peep layer degraded |
| 8x | 5.6 | 8,213 s = **2.28 h** | **CUT (proposed)** — row shown so the cut's cost is visible |

**Intended play mix `[G]` and honest term length:**

| Mix | Paused | 1x | 2x | 4x | Effective speed | Honest term |
|---|---|---|---|---|---|---|
| A — reference (watchable) | 10% | 15% | 45% | 30% | 2.25x | 65,700/2.25 = 29,200 s ≈ **8.1 h** |
| B — brisk | 5% | 10% | 40% | 45% | 2.70x | ≈ **6.8 h** |
| C — skip-heavy | 5% | 5% | 30% | 60% | 3.05x | ≈ **6.0 h** |

> **THE EQUATION: a term is ~6–8 hours at intended speeds (≈7 h at the reference mix) because day = 45 real seconds, speeds offered = pause/1x/2x/4x, intended play mix ≈ 2.25x effective (2x cruise, 1x for watching, 4x for skips, pauses for decisions).**

The old "2–4 hours" claim (GDD §6) is **withdrawn**: it required sustained ~4–8x (review §1.2), at which beats are wallpaper (§4). The math does not support it under any readable mix.

---

## 2. Day length: 45 real seconds at 1x `[G]`

**Choice:** one game-day = 45 real seconds at 1x.

**Justification:**

1. **Beat readability drives it, not tradition.** Five daily beats (sleep→commute→work→leisure→home) over 45 s give 9.0 s/beat at 1x and 4.5 s/beat at 2x (§4). A thought bubble needs ≥4 s on screen to be read at Steam Deck distance (720p/800p, scalable UI text per GDD §15) `[G]` — so the *default cruise speed stays watchable*. This is pillar 4 ("watchable systems") made arithmetic.
2. **30 s (GDD status quo) fails exactly there:** 6.0 s/beat at 1x (review: already borderline) and **3.0 s/beat at 2x cruise** — a pillar-4 violation at the default speed. Rejected despite its shorter honest term (~5.4 h at mix A).
3. **60 s fails on the other side:** readable (12/6 s beats) but the honest term becomes ~10.8 h at mix A — a multi-term campaign turns into 30–50 h [NEEDS-P1 on term count], too long for the genre slot. Rejected.
4. **Sim-side, the change is free.** Appendix rates are per *game*-day and quarterly ticks — speed-invariant. Coupling §5's headroom analysis assumed 30 s days; 45 s days give each tick *more* wall-clock — the fit conclusion only strengthens. This decision binds Phase 2+ rendering/pacing, not M0 tick math (the headless 1-year run is CPU-bound).

---

## 3. Speeds offered

**Set: pause + 1x / 2x / 4x.** Default speed on load and after unpause: **2x** `[G]`.

| Speed | Role | Peep layer |
|---|---|---|
| Pause | decisions, inspection, accessibility (GDD §15 full pause) | frozen, fully inspectable |
| 1x | **designed-for:** watching vignettes, follow-cam, learning | full bubbles + beats |
| 2x | **designed-for:** governing cruise — the speed the game is balanced around | watchable (short bubbles) |
| 4x | **allowed:** skip-forward over quiet stretches, quarter-ends | degraded: culled bubbles + auto-pause armed (§4) |
| 8x | **CUT (proposed)** | — |

**8x cut rationale:** 1.1 s beats (unreadable by 4x over), luminance flicker even with tints (§5), and QA surface a solo dev cannot afford. Nothing requires it once the heartbeat exists: demands (~6/yr, ×1.5 in campaign season, appendix §4) + events deck + quarterly check-ins + P5 fast-loop verbs mean idle time is content, not waiting. 4x + auto-pause covers every legitimate skip ("nothing left to do before the election" is answered by campaign-season event rate, not a faster clock). **Lucas may restore 8x** — the table shows it buys ~2–4 h off a term at the cost of all readability.

**Playtest balance assumes 2x cruise.** Every Phase 2 pacing target (action gaps, demand/event cadence feel, poll rhythm) is tuned and measured at 2x. 1x must feel calm-complete (a full vignette watchable); 4x must feel skippy-but-safe (auto-pause catches everything important).

---

## 4. Beat readability budget

Five beats per citizen-day (GDD §§7–8; coupling spec consumes beats, does not time them). Even-split budget below is the **readability floor**; actual beat wall-clock weighting is owned by Phase 1 items 5–6 (needs, movement) under one constraint: watchable beats (commute + work + leisure) get **≥60% of day wall-clock** `[G]` — sleep may compress, life may not.

| Speed | Sec / beat (45 s day ÷ 5) | Verdict vs 4 s threshold `[G]` |
|---|---|---|
| 1x | 9.0 s | readable — full bubbles + action |
| 2x | 4.5 s | watchable — short bubbles, follow-cam viable |
| 4x | 2.3 s | **UNREADABLE** — mitigations engage |
| 8x (cut) | 1.1 s | wallpaper |

**Beats become unreadable at 4x.** What the game does about it (referenced, not re-specified — owning specs in parentheses):

- **Auto-pause hooks** on followed-citizen life events + demand arrivals + event draws (review §4.3; P10 attribution spec).
- **Vignette button:** jump to a curated moment (layoff day, first shift, moving-truck morning) with auto-pause (review §§4.2–4.3; roadmap Phase 2 item 5).
- **Thought-bubble culling**, priority followed > event-affected > need-critical (roadmap Phase 2 item 3; review §2.15).
- **Wave-summary headlines** instead of per-event spam (coupling §1.5).

Net contract: at 1–2x the player *watches* the story; at 4x the player *is interrupted by* the story. Both are designed states.

---

## 5. Day/night resolution: per-beat lighting tint (adopt review recommendation)

**Adopted:** global lighting tint shifts per beat — sleep = night-dark, commute = dawn/gold, work = full day, leisure = dusk/gold, home = evening `[G]` (palette owned by Phase 2 art). Tints cross-fade (no hard cuts, no full-screen strobing — exact easing owned by Phase 2; photosensitivity-safe by construction). Roadmap Phase 2 item 2 already scopes this; this decision locks it.

**Literal sun cycle rejected.** At a 45 s day it is a 45 s full cycle at 1x (absurd against any real clock) and an **11 s strobe at 4x** — headache-inducing, unreadable, and (per review §§1.3, 3.4.1) an art-pipeline cost with zero gameplay return. There is no day length at which both a sun cycle and a sub-10-hour term survive; the tint keeps the cozy readable-day feel (GDD §16) without the physics.

*Known artifact:* tint follows the global beat clock, so night-shift sleepers are tinted "wrong" — see §10.7.

---

## 6. Seasons vs the cut list: recommendation (FLAG FOR LUCAS)

**Conflict:** GDD §7 says "seasons are real" (winter slows commutes, closes schools; summer drains cities up north, spikes tourism). Roadmap cut #6 says seasons' *gameplay* effects go visual/audio-only if balance or time pressure demands — and Phase 4 item 4 already stages that call.

**Recommendation `[G]` — lock visual + audio-only as the 1.0 default:** seasonal palettes, weather overlays, soundscapes (GDD §§16–17), tourism *crowd visuals* — but no sim multipliers. Rationale: R7 (economy balanced on invented numbers) — seasonal multipliers on commute × schools × tourism × agriculture quadruple the balance surface for a solo dev, and the tourism "summer surge" reads fine through crowds + the marketing policy without touching revenue formulas.

**Keep the hooks live so Phase 4 can switch gameplay seasons on without rework:** coupling §3.2's `season_mult` kill-switch stays specified (default 1.0); appendix policy 6's "in season" window stays defined. If Lucas wants gameplay seasons, decide in Phase 0 (flip the coupling default + appendix rows) — do not drift into it mid-alpha.

> ⚠️ **LUCAS: confirm visual-only default, or defend gameplay seasons now. This is the cheapest moment to choose.**

---

## 7. Term/session honesty

- **Honest term: ~6–8 h** (mix-dependent, §1). The 2–4 h claim is dead and stays dead.
- **Session shape: 5–7 sittings of 60–90 min per term.** At 2x cruise a game-quarter (91.25 days) is ~34 min + pauses, so one sitting ≈ **~2 quarters**. The final-6-months campaign season (GDD §7; 182.5 days ≈ 68 min at cruise + pauses) ≈ **one finale sitting** — quarters and the campaign are the natural episode breaks.
- **Heartbeat check:** demands supply ~1 per 23 min at cruise (6/yr over ~137 min/yr at 2x) — so ~90% of the review §4.1 "decision every 2–3 min" cadence must come from the events deck (draw-rate machine, Phase 2 item 8) + quarterly check-ins + P5 fast-loop verbs. That tuning load is real and is now quantified.
- **Save/load:** quarterly autosave + save-on-quit + manual saves; quarter boundaries (polls land then, appendix §6) are the designed exit points. **Ironman** (P12: a checkbox, no deliberation): same cadence, single autosave slot, no manual saves — ironman restricts *saves*, never *pause*.
- **M0 note:** the headless scripted-year run is CPU-bound; this decision does not affect it.
- **Campaign total: N terms × ~7 h [NEEDS-P1]** — uncomputed as a commitment until P1 (win) and N (roadmap: 3–5 terms) resolve. A 1-game-year scenario at cruise ≈ 1.5–2 h wall-clock, which suits the Plant Closing demo *if* scenario spans stay ~1 year (scenario spans undecided — §10.8).

---

## 8. Locked scope (recited, not decided here)

Windows/Linux only; **Steam Deck is the perf bar** (it sets the 4 s bubble threshold and 720p/800p legibility bar); no macOS (MAC decided 2026-10-06). Beats are commute/work/leisure only — no marriage/kids life-sim depth (cut list #3; coupling §4.4: households fixed at spawn). Governor serves **4-year terms** `[R?]` (Michigan Constitution — verify article/section before lock).

---

## 9. Traceability: Phase 2 validations that judge this decision

| This decision's claim | Phase 2 validation (roadmap) | Pass signal |
|---|---|---|
| 2x cruise sustains the heartbeat; 8x-cut is safe | Item 9 pacing instrumentation: median action gap ≤3 min, >4 min idle = bug | gap log clean at 2x |
| Beats + tints are watchable at 1–2x | Exit: 60-min playtest + "narrate the last 5 min" + muted-map test; "fun to watch" answered in writing | causation narratable sight-only |
| 4x mitigations (auto-pause, vignette, culling) catch the story | Item 5 attribution UI + exit: every approval change has a clickable reason; delays show leading indicators (review §4.3) | no silent causation at any speed |
| 4 s bubble threshold `[G]` holds on hardware | Item 11 Deck check: 60 fps decoupled render; bubble legibility at 720p/800p | readable at 1–2x on Deck |
|Heartbeat survives content scale | Phase 4 beta bars: ≥70% "could tell why", ≥70% "always had something to do" | survey on file, n ≥ 10 |

---

## 10. Open ambiguities (listed, not papered over)

1. **45 s vs 30 s** — the feel pick is Lucas's; §1 tables show the trade (readable cruise vs shorter term). Default: 45 s.
2. **8x cut** — confirm. Cost of keeping: QA surface + strobe review + readability disclaimers.
3. **4 s bubble threshold `[G]`** — unvalidated until the Phase 2 Deck playtest; slower readers × scalable-text interaction unknown.
4. **Uneven beat weighting** (compress sleep, stretch leisure?) — owned by Phase 1 items 5–6 under the §4 60% constraint; this doc sets the floor, not the edit.
5. **Events draw rate** for the 2–3-min heartbeat at cruise — Phase 2 item 8 tuning; depends on pending **P5** fast-loop verbs.
6. **Calendar model:** quarter boundaries on a 365-day year (91/91/91/92?) `[G]` — Phase 1 to fix; visual seasons need month names by Phase 2 at latest.
7. **Night-shift tint mismatch** (§5): accept wrongly-tinted sleepers (most citizens are day-shift) vs diorama-local tint — Phase 2 art call.
8. **[NEEDS-P1]** campaign total hours; scenario game-spans → demo wall-length (see §7).
9. **4x follow-cam policy:** allowed with a "dropping frames of their life" hint, or force drop-to-2x? — P10 spec call.
10. **Auto-pause defaults at 4x** (which hooks ship on vs opt-in toggles) — P10 spec call.

---

## Summary

**THE EQUATION: a term is ~6–8 hours at intended speeds (≈7 h at the reference mix) because day = 45 real seconds, speeds offered = pause/1x/2x/4x (8x cut), and intended play mix ≈ 2.25x effective — 2x cruise the game is balanced around, 1x for watching, 4x for skips, pauses for decisions — with beats readable at 1–2x (9.0/4.5 s), unreadable-but-mitigated at 4x (auto-pause, vignette button, bubble culling by reference), day/night as per-beat tint, and seasons recommended visual-only per cut #6.** The biggest remaining open question for Lucas is whether he accepts the honest multi-sitting term (~6–8 h across 5–7 sittings with quarterly save/exit points) that readable days require — because if he instead demands a shorter term, the only arithmetic fallback is 30 s days with watchability restricted to 1x, which breaks governing-while-watching at cruise and should be chosen explicitly, not drifted into.

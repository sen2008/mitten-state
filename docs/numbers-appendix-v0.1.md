# Mitten State — Numbers Appendix v0.1 (Phase 0 paper artifact)

**DRAFT-NEEDS-LUCAS-REVIEW** — every number below needs Lucas's sanity check before lock. No M0 code may treat these as final.

**Flag legend (every number carries one):** `[R?]` = grounded in real public data but **unverified in this draft** (live web lookup failed in this session; figures come from the task brief and general knowledge — confirm against Michigan budget docs before lock). `[G]` = gameplay estimate: a defensible default picked for fun/legibility, tunable in Phase 3–4 balance passes.

**Scope note:** P1 (campaign win condition) is **pending Lucas's decision**. The Midwest-crown default in the roadmap is **unconfirmed** and assumed nowhere below.

---

## 0. Budget scale choice (explicit)

**GAME CHOICE: a simplified $70B player-facing budget** `[G structure on R? scale]`.

Real FY2025 enacted is ~$82–83B total with a ~$13.5B general fund `[R?]`. The game abstracts ~$12B of restricted federal pass-through (highway aid, nutrition programs, etc.) that a governor never discretionarily allocates, and keeps the remaining federal dollars ($32B) as visible but formula-locked revenue. Why not $82B exact: pass-through lines would be dead UI. Why not $13.5B GF-only: it hides K-12 and HHS, where most voter-felt spending lives.

### Revenue baseline, $70.0B (balanced at start)

| Line | $B | Flag | Note |
|---|---|---|---|
| Federal grants (formula-locked) | 32.0 | `[R?]` scale, `[G]` lock rule | Mostly Medicaid match + education/highway aid; moves only via events/grants |
| Income tax @ 4.25% | 12.0 | `[R?]` | Rate and yield approx. real |
| Sales tax @ 6% | 11.0 | `[R?]` | |
| Fuel & vehicle taxes (roads-locked) | 4.0 | `[R?]` | Gas tax + registration; locked to Roads |
| Property / State Education Tax (6 mills) | 2.5 | `[R?]` | State levy only; local property tax out of scope |
| Corporate income tax @ 6% | 1.5 | `[R?]` | |
| Lottery + marijuana + fees + tolls + misc | 7.0 | `[G]` aggregate | Lottery ~$1.2B `[R?]`; Mackinac tolls ~$0.02B `[R?]`; rest fees/licenses/interest/settlements |
| **Total** | **70.0** | | |

### Expense departments (the GDD §9 seven), $70.0B

| Dept | $B | % | Flag | Real anchor |
|---|---|---|---|---|
| Health & human services | 35.0 | 50.0 | `[R?]`-adjacent | Largest dept. IRL, mostly Medicaid w/ federal match |
| K-12 education | 19.0 | 27.1 | `[R?]`-adjacent | Cf. School Aid Fund ~$20B+ |
| Roads & bridges | 7.0 | 10.0 | `[R?]`-adjacent | Cf. transportation ~$7B |
| Public safety | 3.0 | 4.3 | `[R?]`-adjacent | Corrections + state police |
| Universities | 2.5 | 3.6 | `[R?]`-adjacent | Cf. higher-ed state ~$2–2.5B |
| Debt service | 2.5 | 3.6 | `[G]` | Sized so deficit spirals bite; real bonded service is lower |
| Environment & parks | 1.0 | 1.4 | `[R?]`-adjacent | Cf. DNR+EGLE ≈ $1B combined |
| **Total** | **70.0** | | | |

### Starting position

| Item | Value | Flag |
|---|---|---|
| Budget balance | $0 (balanced) | `[G]` — start clean, let the player break it |
| Rainy-day fund balance / cap | $2B / $7B (10% of budget) | `[R?]` balance (BSF ~$2B); `[G]` cap |
| Outstanding debt | $8B | `[G]` |
| Bond rating | AA | `[R?]`-adjacent (MI GO ≈ AA/AA+) |
| Roads condition | 45/100 ("rough") | `[G]` — bad from day one, per GDD |
| Unspent funds | Roll to rainy-day up to cap; excess = surplus (debt paydown or approval bump) | `[G]` |
| Mid-year reallocation | One/quarter, no penalty in M0 | `[G]` default; may gain P5 political-capital cost |

---

## 1. Tax model

Revenue = rate × base, recomputed quarterly. Rate changes take effect next quarter: 50% of projected revenue impact in Q+1, 100% from Q+2 `[G]`. Base/migration responses lag 4–8 quarters `[G]`. UI always shows projected vs. actual.

| Tax | Default | Allowed range | ±1pt ≈ $/yr | Base elasticity `[G]` | Extreme triggers `[G]` |
|---|---|---|---|---|---|
| Income | 4.25% `[R?]` | 0–9% | $2.8B | −3%/pp above default; +1.5%/pp below | >7%: outmigration headline events; 0%: in-migration + service-collapse pressure |
| Sales | 6% `[R?]` | 0–10% | $1.8B | −2%/pp above; +1%/pp below | Hits Main Street approval directly; tourism spending sensitive |
| Property (SET) | 6 mills `[R?]` | 0–12 mills | $0.42B/mill | −1.5%/mill above; +0.75%/mill below | Cut pleases Main Street; hikes anger faster than other taxes (×1.5 approval weight) |
| Corporate | 6% `[R?]` | 0–12% | $0.25B | −6%/pp above (highest — firm flight); +2%/pp below | >9%: HQ-move / Ohio-poach event chain |

No Laffer curve inside the allowed range (linear is fine for M0) `[G]`; extremes are handled by authored events, not formula inversion.

---

## 2. M0 policies (12 of catalog; P8 rule: every delay ships staged precursors)

Costs in $M/yr unless noted. Approval effects are points on 0–100 faction meters. Job counts are real-equivalent (lens scaling per pending P3 spec).

| # | Policy | Cost | Effects (magnitude) | Full-effect delay | Staged precursors (map + headline + peep) |
|---|---|---|---|---|---|
| 1 | Fix the Damn Roads blitz | 1,500 | Roads condition +8/yr; Main Street +6/yr while active; firm logistics cost −5% | 2 qtrs | Q+0 announcement + orange barrels; Q+1 work zones + hiring notices; Q+2 resurfaced segments open |
| 2 | Trades apprenticeships | 120 | Motor +8; manufacturing hiring +3%/yr | 4 qtrs | Enrollment headlines → academy construction → first graduation event |
| 3 | Graduate retention credits | 200 | Campus +8; grad outflow −25% | 6 qtrs | Applications spike → first cohort hired → retention-stat headlines |
| 4 | Factory recruitment package | 200 one-time/deal | Motor +5; 1,500–3,000 jobs if won; bidding-war risk | 2 qtrs | Announcement → site prep → hiring wave (or "lost to Ohio" headline) |
| 5 | Small-business grants | 150 | Main Street +4; firm spawns +10% | 2 qtrs | Applications → award feed → grand openings |
| 6 | Tourism marketing | 80 | Lakeshore +5; tourism revenue +8% in season | 1 qtr | Ad blitz → bookings up → summer surge crowds |
| 7 | Rural broadband (3-yr build) | 300 | Yoopers +6, rural Main St +3; remote-worker in-migration | 6 qtrs | Survey crews → fiber trenches → first towns lit |
| 8 | School funding boost (+$500/pupil) | 700 | Main Street +7; long-run workforce quality | 8 qtrs | Teacher hiring → new programs → test-score headlines |
| 9 | Medicaid scope expansion | 900 state (+~1,800 federal draw) | Main St +4, Campus +4; Health-need restore up | 2 qtrs | Enrollment opens → clinic volumes rise → coverage stats |
| 10 | Starter-home program | 250 | Main Street +5; rent pressure −10% in target towns | 4 qtrs | Lots permitted → framing → move-in day vignettes |
| 11 | PFAS cleanup | 180 | Lakeshore +7; Health-need restore up in affected towns | 6 qtrs | Testing crews → filtration plants → all-clear headlines |
| 12 | Shoreline protection grants | 90 | Lakeshore +6; tourism resilience (storm-loss −30%) | 3 qtrs | Grants awarded → seawall work → protected-beach reopenings |

All magnitudes `[G]`. Policy 8 pupil math: ~1.4M pupils × $500 `[R?]`-adjacent.

---

## 3. Needs engine (per game-day, 0–100 scale)

**Money-vs-household resolution** (review 1.7 / roadmap Phase 1.5) `[G]`: the household holds one budget ($). Each adult's Money need derives from household per-capita funds vs. cost of living: >3 months CoL ≈ 90+; <1 month CoL ≈ <30. Paydays restore household $; spending drains it; Money need follows. Non-earners and kids mirror the household value (dampened ±10). No separate per-citizen Money wallet.

| Need | Decay/day | Restore | Notes |
|---|---|---|---|
| Money | derived (no flat decay) | payday; −drain on expenses | See rule above |
| Rest | −35 (−45 night shift) | sleep +60; nap +20 | Beats must include a real sleep beat |
| Health | −4 (−15 sick untreated) | care +8/day when sick; funding scales restore rate | Healthcare funding maps to restore multiplier 0.5×–1.5× |
| Food | −30 | home meal +35; cheap eat-out +25 | Skips meals if Money <20 |
| Social | −12 | group leisure +25; solo leisure +8 | Bars/parks/churches are the stage (amenity generator, Phase 3) |
| Purpose | −6 employed; −15 unemployed | satisfying work beat +10; layoff −30 instant | Retraining/education restores over time |

All rates `[G]`.

### Behavior threshold table `[G]`

| Condition | Behavior |
|---|---|
| Money <25 | job-hunt; <15 for 30+ days → consider move |
| Food <20 | skip meals (Health −5/day); <10 → food-bank event + thought bubble |
| Rest <15 | sick risk up; work performance down (firm productivity −) |
| Health <25 | clinic visit; <10 → ER event, can't work |
| Social <20 | seeks group leisure; <10 → unrest susceptibility ×2 |
| Purpose <20 | job-hunt/retrain; <10 → protest susceptibility ×2 |
| 2+ needs <15 for 60 days | household packs truck: in-state move or interstate exit (destination + scaling per pending P3) |

---

## 4. Demand cadence `[G]`

| Knob | Value |
|---|---|
| Arrival rate | ~1 demand per faction per game-year → ~6/yr statewide ≈ 1 per 2 game-months; ×1.5 in campaign season |
| Max concurrent | 3 statewide (M0: 2, one region) |
| Deadline window | 2–4 quarters from issue; exact date always shown |
| Stakes | Meet: +5–10 approval + goal credit. Refuse/expire: −10–15 approval; 2nd consecutive refuse escalates (press + protest risk) |
| Repeats/chains | No repeat within a term; crisis chains (e.g., secession stages) authored separately |

---

## 5. Thresholds `[G]` (all tunable; staged warnings per review 4.6)

**Bond rating.** Ladder: AAA / AA+ / **AA (start)** / AA− / A / BBB / junk. Cut rule: deficit >3% of budget ($2.1B) for 2 consecutive quarters → outlook negative (news + warning UI); 4 consecutive quarters → downgrade one notch + borrowing cost +0.5pp + Main Street −3. Upgrade: balanced/surplus 4 straight quarters → +1 notch (cap AAA). Below BBB (junk): emergency-manager countdown → **bankruptcy lose** after 4 more quarters unless balanced.

**Exodus.** Cumulative net interstate loss >250,000 real-equivalent (~2.5% of 10M) within a term → **exodus lose**. Early warnings: visible "Ohio gap" ticker from day one; any quarter with net loss >25k → headline + Main Street −2. Lens scaling placeholder: 1 lens mover ≈ 500 real (20k lens ↔ 10M; exact law pending P3).

**Faction floor.** Any faction <25 for 2 consecutive quarters → protests + hostile press + −5 statewide-approval drag. <25 for 4 consecutive quarters (one game-year) → primary-challenger meter +25% and that faction's crisis chain unlocks (e.g., secession petition stage 1 for Yoopers). Cleared by 2 quarters above 30.

---

## 6. Election formula `[G]` (P6 legislature interaction still pending)

- **Statewide approval** = Σ faction approval × population share. Shares: Main Street 38%, Motor 18%, Campus 12%, Lakeshore 11%, Growers 11%, Yoopers 10%.
- **Main Street decides** via turnout weight: Main Street share ×1.3, renormalized (effective ~45%) — this is the exact electoral role (review 1.11).
- **Vote share** = statewide approval + incumbency +2 − (unemployment% − 5%)×1.5, clamped to 35–65, plus noise N(0, 2).
- **Polls:** quarterly, MoE ±3; monthly in campaign season. "Approval matters double" (GDD §7) = approval *changes* ×2 in the final 2 quarters.
- **Outcomes:** ≥50% = win (GDD §14). 52–57% solid; >57% landslide → mandate honeymoon (+5 approval, decaying over 1 yr; P6 friction halved once P6 exists). <50%: ≥47% narrow loss → player choice: concede (legacy scored, campaign ends) or continue in sandbox; <47% losing badly → campaign ends (sandbox optional).

---

## 7. Dollar scale (intuition lines) `[G]`

| Amount | Means |
|---|---|
| $1M | Rounding error — press-release money |
| $100M | A real line item (0.14% of budget) |
| $200M | One factory deal / one mid-policy year (0.29%) — the Ohio-gag unit |
| $1B | 1.4% of budget; moves a department's outcomes; voters notice |
| $5B | 7%; reshapes a department or funds a blitz; must be paid for (tax, deficit, or raid) |
| $2.1B deficit (3%) | The tripwire: 2 quarters here = bond-outlook warning |

---

*End of v0.1. Roadmap exit check: every P2 field above is filled with no TBDs in M0-scoped rows; items explicitly deferred to sibling Phase 0 specs (P3 scaling law, P5 capital costs, P6 legislature) are named, not blank.*

# Attribution UI Spec v0.1 (Phase 0, P10 spec half)

**DRAFT-NEEDS-Lucas-REVIEW — paper only. No game code, no engine detail beyond wireframe needs. UI behavior + sim logging contract (what the sim must log for the UI to work). Specified now, BUILT in Phase 2 — exactly roadmap Phase 2 item 5, no more. M0 ships headless logs only.**

**Flags:** `[G]` = this spec's judgment call + source. `[NEEDS-NUMBER]` = no sibling fixed it — Lucas or Phase 2/3 tuning sets it, not invented here. `[NEEDS-P1]` = shaped by the undecided win; Midwest-crown default assumed nowhere.

**Sources:** review §§4.2–4.4, P10, 1.5, 1.8/P8, 4.6–4.7; ROADMAP Phase 2 item 5 + exits; all seven sibling v0.1 docs.

**Adopted (not decided):** $70B / $0 balance / 7 depts; 5k SE lens; firms ≤3k to measured headroom (min ~500 SE); 45-s days, pause/1x/2x/4x, 2x cruise; PC 0–100, start 30, +10/qtr base; six factions, Main St 44.3%; four SE dioramas; per-beat tint; faked leaderboard; deals as event chains.

---

## 1. 'Watch this' lists on policy cards — DRAFT-NEEDS-Lucas-REVIEW

**Rule:** every policy card shows a "Watch this" list at enact time: 2–4 places + 2–4 stats, each bound to its P8 staged precursor (announcement → construction/hiring → effects). Places resolve to clickable map targets (county pin, diorama venue, leaderboard row); stats to dashboard series; each precursor row ticks when the sim fires that stage.

**Honesty rule** `[G per coupling §4.2]`: face promises capped by S_SE ≈ 1,000 — a 2,000-job win promises "2–3 new hires you'll meet," never "watch 2,000 peeps." Zero-lens events promise the headline, not faces.

**Worked example — appendix §2 policy 4, Factory recruitment package** ($200M one-time, Motor +5, 1,500–3,000 jobs if won, 2-quarter delay; picked because it exercises the Ohio-loss branch):

```text
+- POLICY ENACTED: Factory recruitment package ------+
| Cost: $200M one-time  |  Full effect: 2 quarters  |
| WATCH THIS:                                       |
| [ ] Q+0 Announcement - headline + target-county   |
|     pin  |  stat: Treasury -$200M                 |
| [ ] Q+1 Site prep - work-zone flag in <county>    |
|     map/diorama  |  stat: county openings posted  |
| [ ] Q+2 Hiring wave - 1,500-3,000 jobs IF won     |
|     (2-3 lens hires you'll meet)  |  Motor -> +5   |
|     RISK: "lost to Ohio" headline branch          |
| Report card at quarter end, quotes this list >    |
+---------------------------------------------------+
```

The card persists until resolution, then links to its final report card (§7). Fast-track (PC 20) shifts all quarters −1 and the card notes it.

## 2. 'Because' lines on map events — DRAFT-NEEDS-Lucas-REVIEW

**Format:** every major map event (firm wave, opening/closure, approval move ≥ [NEEDS-NUMBER] pts, Ohio loss, demand/event outcome) renders headline (place + day) + one Because clause (≤140 chars [NEEDS-NUMBER]) + clickable cause chip (⌁ policy/demand/event/firm-event id).

**Data-source rule:** the clause may claim ONLY what the sim traces — entities in the event's causal record (coupling `cause_code`/`firm_event_id` chain, policy/demand/event ids); magnitudes equal aggregate books; faces cited via event ids only, with the coupling §4.3 noise guard for small cells (aggregate proxy + faces, never scaled sample counts).

**Tone rule** (review §§4.7/22): pain with humanity — name families and places, never punch down; the Ohio gag aims at rivalry (their governor, their bid, the score), never at Michigander suffering. Every Ohio loss attaches a face + a place.

1. Layoff wave: "200 supply-chain jobs end Friday in Flint." / Because: Genesee supplier margins ran below −5% for 2 straight quarters. [⌁ firm-event]
2. Plant opening: "Flint axle plant opens its gates — 2,400 jobs." / Because: your factory recruitment package won the bid; site prep finished last quarter. [⌁ policy]
3. Faction approval: "Motor +5: first hires walked the line today." / Because: recruitment-package hires posted in Genesee this quarter. [⌁ feed]
4. Ohio loss: "We lost the battery plant to Ohio." / Because: their bid beat ours (margin [NEEDS-NUMBER]) — their governor is dancing; our rematch starts now. Face: Mara J., applicant, Flint. [⌁ event-chain]
5. PC visit: "Campus +3: you cut the ribbon at the Ann Arbor lab." / Because: county visit, 5 PC. [⌁ PC]
6. Roads precursor: "Main Street +2: barrels on I-75, work started." / Because: roads blitz Q+1 precursor fired in Wayne. [⌁ policy]

## 3. Approval-delta feed — DRAFT-NEEDS-Lucas-REVIEW

**Entry:** `[Day 412 · Q2 Y1] [Motor +5] First hires walked the line → Factory recruitment package [⌁]` — timestamp, faction chip + signed points, one-line cause, cause link. Campaign season: deltas render post-×2 with a ×2 badge under the persistent banner (legislature B4).

**Aggregation:** same-(faction, cause) deltas within a quarter roll up ("Motor +8 · 3 events [⌁]"); waves (coupling §1.5) collapse to one wave entry. Feed keeps the full quarter plus trailing [NEEDS-NUMBER] entries minimum.

**Click-through:** every delta MUST resolve to its cause card or ledger. Null cause id = ORPHAN, a Phase 2 build bug; orphan count = 0, mirroring coupling §1.1 `[G per coupling §1.1]`. No orphaned deltas, ever.

## 4. Vignette button + pause-on-life-event — DRAFT-NEEDS-Lucas-REVIEW

**Button:** "Vignette ▶" in the map toolbar — jumps to the highest-scoring queued moment + auto-pauses, at any speed incl. 4x. M1 moments are SE-set: layoff day (plant gate), first shift (battery plant), moving-truck morning, move-in day (starter homes), trades-academy graduation, ribbon-cutting (PC visit).

**Sim selection** `[G per review §4.3]`: candidates score recency × faction-relevance × novelty (never-shown beats repeats); highest plays. Queue depth [NEEDS-NUMBER]; unviewed moments expire after [NEEDS-NUMBER] days.

**Pause-on-life-event toggles** (per followed citizen, persisted): job lost / gained / move started / retired / died / need-critical (any need <15). Defaults: job-lost + move + died ON, rest opt-in `[G per time-scale §10.10, owned by P10]`; at 4x all armed toggles fire (time-scale §4: at 1–2x the player watches; at 4x the story interrupts).

**4x follow-cam** `[G per time-scale §10.9, owned by P10]`: allowed at 4x with a "dropping frames of their life — drop to 2x to watch" hint chip; never force-drop.

## 5. Peep browser filters + text log — DRAFT-NEEDS-Lucas-REVIEW

**Filter chips** (multi-select; sort = most-recent tagged event; rows show name, town, cause tag → feed): "Affected by my last 3 policies" (transitions tagged to last 3 enacted policy ids, trailing [NEEDS-NUMBER] days) · "Need-critical" (any need <15) · "Event-affected" (firm/event ids, trailing window) · "Followed".

**Honesty rule** `[G per coupling §1.4]`: at S_SE ≈ 1,000 a −200 layoff usually lists zero peeps BY DESIGN — the browser shows the wave headline + firm rows instead of inventing faces.

**Text log per citizen:** reverse-chron cause-tagged lines ("Day 388: laid off — Genesee supplier wave [⌁]"). No scrubable timeline — cut #4: follow + live bubbles + text log only.

## 6. Faction 'top 3 drivers' panels — DRAFT-NEEDS-Lucas-REVIEW

**Format:** each faction panel shows "Top 3 drivers right now": `(±pts, trailing quarter) <cause label> [⌁]`, ranked by |magnitude|. Magnitudes = summed feed deltas per cause, in approval points (post-×2 in campaign season, badged). Small cells (n<50) cite the aggregate proxy + event-id faces (coupling §4.3).

**Refresh:** recompute on every delta + quarter tick — 6 factions × small cause set is trivial `[G per legislature B4 + appendix §6]`. **Feed tie:** each row expands to the feed filtered by that cause (§3↔§6 = two views of one ledger).

**M1 subset** `[G per m1-rescope §2]`: Main Street, Motor, Campus, Growers live; Lakeshore cameo at most; Yoopers hidden until M2 — their deltas still book headless so M2 panels open with history.

## 7. Per-policy quarterly report card — DRAFT-NEEDS-Lucas-REVIEW

**Fires** at quarter end with polls (appendix §6 / legislature B3); monthly campaign polls stay headlines-only — no monthly cards `[G per legislature B3]`. One card per active + resolved-this-quarter policy:

```text
+- Q2 REPORT: Factory recruitment package ----------+
| PROMISED (watch-this, quoted back):               |
|  [x] Q+0 announcement  [x] Q+1 site prep          |
|  [ ] Q+2 hiring wave - lands next quarter         |
| OBSERVED: Treasury -$200M | Motor +2 so far [~]   |
|  Faces: 2 site-prep hires you'll meet >           |
| NEXT: hiring wave or Ohio-loss branch.            |
+---------------------------------------------------+
```

(a) promised — the §1 list verbatim, precursors ticked/missed; (b) observed — stat deltas with cause tags, faces (N lens citizens + links), spend vs. budget; (c) next — pending precursor or "effects landed." Missed precursors are flagged, never silently dropped: this is the P8 enforcement surface, closing the loop the player asked to see. Fast-tracked cards note "−1 quarter."

## 8. Sim logging contract (what the sim must log) — DRAFT-NEEDS-Lucas-REVIEW

| UI need | Log record | Key fields | Owner |
|---|---|---|---|
| Because-lines | FirmEvent + causal record | event_id, cause_code, delta, day | coupling §1.1 |
| Feed + drivers | approval ledger (new) | day, faction, ±pts, cause id+type | §3/§6 |
| Watch-this + cards | policy lifecycle log | policy id, enacted day, precursor states, fast-track | appendix §2 + P8 |
| Vignette queue | moment queue | citizen/event ids, score, expiry | §4 |
| Peep filters | lens transition tags | citizen id, cause ids, day | coupling §§1–2 |
| Drivers panels | derived from approval ledger | no new log | §6 |

Validation: any UI claim without a cause id fails Phase 2 data validation (mirrors the coupling orphan audit). Log retention window: [NEEDS-NUMBER].

## 9. Consistency checklist vs sibling docs — DRAFT-NEEDS-Lucas-REVIEW

| Sibling | Took | Breaks if it changes |
|---|---|---|
| numbers-appendix | 12 policies + precursors (worked ex. #4), demand cadence, <15 thresholds, quarterly cadence, $200M gag unit, $70B/$0/7-dept scale | renumbering or new delays shift every watch-this quarter; threshold changes redefine need-critical filters |
| coupling-spec | cause_code/firm_event_id, orphan = 0, wave rule, S_SE ≈ 1,000, n<50 guard, lens tagging | event-id shape change breaks every ⌁ link; scale change breaks face counts; band changes rewrite because-vocabulary |
| time-scale | 45-s days, pause/1x/2x/4x + 2x cruise, beat budget, 4x mitigations, tint, autosave; Q9/Q10 answered §4 | new speeds void the mitigation contract; new day length voids expiries; tint change restages vignettes |
| political-capital | 0–100/start 30/+10 base, visit 5 / buyout 15 / fast-track 20 / emergency 30 as attributable causes | new spend = new cause type; income change alters visit rate → feed volume |
| legislature | abstracted (no legislature cause type), Main St 44.3%, ×2 + banner, surprise ±3–5 final, poll cadence | restoring friction adds cause type + panel; B1 recompute under north-fix (a) reframes driver weights |
| north-fix | (a) RECOMMENDED: Lakeshore tourism sub-identity, Yoopers UP-only, 14/7 split, visit targeting | flip to (b) forces rotation-aware driver labels; share answers re-split B1; Q4 retargets UP visits |
| m1-rescope | SE diorama set, 5k SE lens, firms ≤3k to headroom, M1 panel subset, cuts #3–#6 | diorama change restages vignettes; count change redoes queue math; M2 unhides Yoopers |

[NEEDS-P1] hooks: "Ohio gap" ticker as campaign progress, report-card legacy lines, sandbox-continue feed behavior — the ticker may show as a stat from day one (review 4.6), but win-progress framing waits on Lucas.

## 10. Verify test — DRAFT-NEEDS-Lucas-REVIEW

Phase 2 must build: watch-this lists with P8 precursor checkboxes on every policy card; because-line + cause chip on every major map event with zero orphan deltas; the approval-delta feed with aggregation and click-through; the vignette button with auto-pause plus per-followed pause toggles; the peep browser with all four filters and cause-tagged text logs (no timeline); per-faction top-3-drivers panels expanding into the feed; and quarterly report cards quoting each watch-this list back with ticked/missed precursors — then a fresh player plays 60 minutes at 2x cruise and narrates the last 5 minutes and why from the map alone (muted-dashboard check), median action gap ≤3 min, no >4-min idle stretch unexplained.

## 11. Direct questions for Lucas — DRAFT-NEEDS-Lucas-REVIEW

1. Ohio-gag heat: is "their governor is dancing; our rematch starts now" the right punch, or keep rivalry copy press-release dry?
2. Auto-pause defaults: ship job-lost + move + died ON as specced, or all-opt-in to protect flow?
3. Report cards: quarterly only, or also fire immediately when a policy resolves mid-quarter?
4. Vignette queue: pure sim-curated scoring as specced, or let players thumb moments up/down?
5. Feed retention: full-term scrollback, or trailing quarter plus archive?

Locked scope (recited once): Windows + Linux only; Steam Deck is the perf bar; $24.99 premium; mouse-first.

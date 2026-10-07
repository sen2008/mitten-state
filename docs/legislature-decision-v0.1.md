# P6 — Legislature Call + Election Formula v0.1 (Phase 0)

**DRAFT-NEEDS-LUCAS-REVIEW — the entire document below is draft. No Phase 1+ work may treat any value here as final until Lucas reviews it.**

Paper only. No game code. GDD, roadmap, and all other files untouched.

**Sources read:** review 1.9 (dictator problem), P6/item 154, 2.8 (election gaps), 1.11 (Main Street weight); GDD §§5, 7, 12, 14 (confirmed: legislature currently absent — this doc makes the call); ROADMAP-1.0 Phase 0 item 6 + Decisions row LEG (default: one-paragraph abstraction); numbers appendix §6 (adopted as baseline, not contradicted); political-capital-decision-v0.1 (open Q5 answered here); time-scale-decision-v0.1 (campaign season = final 6 months ≈ 68 min at cruise).

**Flag legend (appendix/time-scale usage):** `[G]` = gameplay figure invented here, tunable in Phase 3–4. `[R?]` = risky or unverified — needs Lucas's call and/or playtest validation. `[NEEDS-P1]` = depends on the pending win-condition decision; assumed nowhere.

---

## PART A — The legislature call: (a) ABSTRACTED

> **DRAFT-NEEDS-LUCAS-REVIEW**

**Decision: (a). The legislature is abstracted as follows** — Michigan's House and Senate exist in the fiction but not in the sim: the governor's budget passes every year with modifications already reflected in costs and faction reactions, tax changes take effect on the appendix schedule without a separate vote roll, and policy cards resolve through their own delays and precursors rather than a passage gate. This is an honest simplification, not an oversight: the game's load-bearing constraint fantasy is *faction management under time pressure* (six rival meters, timed demands, staged fiscal timers), and a vote-counting layer would tax a solo-dev budget to simulate a second veto player that the demand deck already plays — every demand with approval stakes *is* the legislature, the press, and the interest groups wearing one hat. Review 1.9 permits exactly this paragraph in place of a friction layer, and the roadmap LEG default agrees.

**What replaces mid-term stakes, and why it is enough:** (1) faction demands at ~6/yr statewide, ×1.5 in campaign season, each with exact stakes and deadlines (appendix §4); (2) the bond-outlook/downgrade timer and faction-floor/protest/primary-challenger timers (appendix §5), which judge the player quarterly, not quadrennially; (3) quarterly polls with teeth and monthly headlines (roadmap Phase 2 item 10); (4) the events deck plus P5 fast-loop verbs filling the 2–3-minute heartbeat (time-scale §7). Together these put a staged consequence between the player and every verb — spend, delay, defy, or pay approval — which is the function a minimal legislature would serve, without a second chamber to build, balance, and teach.

**P6–PC interaction (answers PC-doc Q5): no, P6 consumes zero PC.** There is no vote-buying fifth spend option. The four PC spends stand unchanged — county visit 5, demand buyout/extend 15, fast-track 20, emergency powers 30 — and fast-track remains the only "make it go faster" purchase, so the player is never double-charged (once in PC to pass a bill, once in PC to hurry it). Related (PC-doc Q4): recommend PC income stays **flat** in campaign season — the approval-linked income component already floats as doubled approval changes move levels, so doubling the base too would double-dip `[G]`.

**M0/Phase-1 implementation surface:** zero. No legislature object, no vote roll, no budget-approval gate, no passage stat. "The legislature" appears only as nouns inside authored demand/event text ("the House will make you pay for this"). M0 implements nothing; Phase 3 may add ≤3 authored "legislature balks" events through the normal event deck, never as a system. If post-1.0 ever wants friction, the named hook is a single `passage_check(policy)` gate on big-ticket cards — specified nowhere, built never, until Lucas asks.

**Rejected (b), kept visible so Lucas can flip with one sentence:** single override-vote event on tax hikes and >$1B reallocations, passed by spending 10 PC or riding ≥55 statewide approval, failed = one-quarter delay. Rejected as scope without a distinct fantasy — it re-prices fast-track rather than adding a new decision.

---

## PART B — The election formula (adopts appendix §6, refines per review 2.8)

> **DRAFT-NEEDS-LUCAS-REVIEW**

**B1 — Blend weights.** Statewide approval = Σ faction approval × renormalized weight. Base shares (appendix): Main Street 38, Motor 18, Campus 12, Lakeshore 11, Growers 11, Yoopers 10. Main Street ×1.3 turnout weight → total 111.4, divisor 1.114. Exact weights `[G]`: Main Street **44.3%**, Motor **16.2%**, Campus **10.8%**, Lakeshore **9.9%**, Growers **9.9%**, Yoopers **9.0%**. This is Main Street's exact electoral role per review 1.11.

**B2 — Vote-share formula.** All inputs sampled on election night. Projected share = clamp(A + 2 − (U − 5) × 1.5, 35, 65), where A = blended approval 0–100 mapped 1:1 to vote points, +2 = incumbency (player is always the incumbent in a campaign; scenarios may waive) `[G]`, U = statewide unemployment % (macro stat; coefficient 1.5) `[G, R? — strongest unelected lever in the formula; confirm it can't swamp a well-liked governor]`. Final share = projected + ε, ε ∼ N(0,2) drawn once at resolution `[G]`. Clamp-then-noise order is intentional (appendix): landslides stay possible but rare.

**B3 — Polls vs. reality (noise/MoE).** Displayed poll = current projected share (live A and U, no election-day ε) + uniform(−3,+3) resampled per poll, display-only, never accumulated `[G]`. Quarterly all term; monthly in campaign season (6 polls over ~68 min at cruise ≈ one per ~11 min — the finale-sitting heartbeat; time-scale §7). Polls never reveal ε or future drift; election night reveals the true final. MoE is honest: ±3 uniform ≈ ±3 MoE as drafted.

**B4 — "Approval matters double," stated mechanically.** During campaign season (final 182.5 game-days = term quarters 15–16; trigger ≈ day 1278/1460 `[G]`, calendar pending time-scale §10.6), every faction-approval **delta** from every source is multiplied by ×2.0: policy ticks, demand stakes, event choices, PC visits (+3→+6), threshold penalties. Not doubled: PC income (flat per Part A), money/jobs/condition effects, October-surprise magnitudes (authored final, §B5). Meters still clamp 0–100. UI shows a persistent "CAMPAIGN SEASON — approval gains and losses count double" banner `[G]`. `[R? — doubling penalties as well as gains can death-spiral a struggling incumbent; confirm intended, or cap doubled losses per quarter.]`

**B5 — October-surprise mechanic.** Exactly one guaranteed draw per campaign, 25–35 game-days before election day (≈ the final ~10 min of the finale sitting) `[G]`; drawn from an authored pool of ≥4 (mix of player-fault-adjacent scandal, exogenous good, exogenous bad) `[G]`, no repeat within a campaign, pool cycles across terms. Each offers 2–3 responses with stakes stated as **final** statewide-equivalent points (±3–5) `[G]` — applied after the ×2 multiplier so authors control magnitude exactly. One post-surprise poll always fires so the player sees the damage. M0: stub as a headless log line; Phase 3: full event with map + headline + peep representation per the P8 rule.

**B6 — Narrow-vs-landslide outcomes.** Tiers `[G]` except where appendix-fixed: <47% decisive loss → campaign ends to epilogue, sandbox-continue offered as explicit opt-in ("govern on as caretaker"); 47–49.9% narrow loss → results-screen **choice**: concede (legacy scored `[NEEDS-P1]`, campaign ends) or continue in sandbox; 50–51.9% bare win → no honeymoon, primary-challenger pressure opens higher next term; 52–57% solid win → +2 approval decaying over 2 quarters; >57% landslide → mandate honeymoon +5 decaying over 1 game-year (appendix). Sandbox-continue (either loss tier): campaign-win tracking frozen off `[NEEDS-P1]`, bankruptcy/exodus lose conditions stay live. Refinement, not contradiction: the appendix's "P6 friction halved" mandate clause is **void** — P6 resolved as no-friction in Part A, so the clause has no target and the mandate is approval-only.

**B7 — Multi-term continuation.** A winner opens the next term with: faction meters carried with 25% regression toward 50 `[G]`; treasury, debt, bond rating, and infrastructure condition carried unchanged; PC reset to 30; active demands cleared and rotation restarted; bond/faction timers reset; mandate honeymoon applied if earned. Narrow-loss sandbox-continue carries identically minus any honeymoon. Whether sandbox-continue can still earn the campaign win: recommend no (holding office required) `[NEEDS-P1]`.

---

## Open ambiguities — direct questions for Lucas

1. Confirm (a) abstraction over the (b) override-vote sketch — or say "do (b)" and it becomes the spec?
2. Confirm P6 consumes zero PC (no fifth vote-buying spend) and PC income stays flat in campaign season?
3. Is doubling approval *penalties* as well as gains in campaign season intended, or should doubled losses be capped per quarter?
4. October surprise at ±3–5 final points in the last ~10 minutes of a term: right weight, or harsher/kinder?
5. Bare-win (50–52%) opening the next term with higher primary-challenger pressure: keep, or should any win start clean?
6. Sandbox-continue after a loss: confirm it can never earn the campaign win (holding office required) — answerable together with P1 if you want: what IS the campaign win, and does losing office end eligibility for it?
7. Do you want any "legislature balks" flavor events in the Phase 3 deck, or should the legislature stay entirely off-screen, even as fiction?

---

*Locked scope (recited, not decided): Windows + Linux only; Steam Deck is the perf bar; $24.99 premium; mouse-first PC. One term = 4 game-years ≈ 6–8 real hours at intended speeds (time-scale v0.1).*

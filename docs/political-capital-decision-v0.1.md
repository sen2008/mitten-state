# P5 — Political Capital: Define or Delete v0.1 (Phase 0)

**DRAFT-NEEDS-Lucas-REVIEW — paper only. No game code, no GDD edit, no roadmap edit.**

Flags in this doc: `[G]` = consistent with GDD/review as written · `[R?]` = revises or goes beyond a review point · `[NEEDS-P1]` = touches the undecided campaign win condition (assumed nowhere).

## Recommendation: DEFINE (keep as a second spendable resource)

Keep political capital (PC). DELETE was weighed honestly — one fewer currency, less tutorial — but the fast loop still needs 2–3 attention-gated verbs either way (review 4.1 `[G]`), and cooldown-only verbs cost the same design work with less legibility than a visible pool. A small capped pool turns idle stretches into visible tradeoffs (spend now on a visit vs. save for an emergency) and directly fixes the screensaver problem `[G]`.

## Definition (all numbers tied to appendix scale)

**Pool:** 0–100, mirroring the 0–100 faction meters (GDD §5 `[G]`). Starts each term at 30.

**Income (quarterly, paid at the quarterly poll/check-in, appendix §6):** base +10/quarter `[R?]` (review P5 asked "per quarter? per approval? per demand?" — answer: all three, combined); +0–6 scaled from statewide approval vs. 50 (approval formula appendix §6 `[G]`); +5 per faction demand met on time (cadence ~6/yr statewide, appendix §4 `[G]`). Expected ~50–70/yr: at 2x cruise a quarter ≈ 34 min (time-scale §7), so ≈ 1 PC per 2–3 min — one cheap verb roughly every 10–15 min plus saving for big spends, slotted into the 2–3-min heartbeat alongside events/demands/check-ins `[G]`.

**Spend options:** (1) County visit / ribbon-cutting — 5 PC, +3 approval to one faction in the visited region, cooldown 1 game-month (anti-spam; effect sized below small-policy +4–8, appendix §2 `[G]`). The dedicated between-cycles verb. (2) Demand buyout/extend — 15 PC: satisfy a demand's approval stakes without its budget cost, or +1 quarter deadline; stakes (±, escalation) per appendix §4 unchanged `[R?]`. (3) Fast-track — 20 PC: cut one active policy's remaining delay by 1 quarter (min 1; delays are 1–8 qtrs, appendix §2 `[G]`). (4) Emergency powers — 30 PC (≈ half a year of saving): immediate event response (e.g., blizzard/school effects halved) OR pause one bond-outlook/faction-floor timer for 1 quarter (timers appendix §5 `[R?]` — pausing a lose-condition timer is the strongest effect and needs Lucas's call).

**Cap/regen:** hard cap 100, overflow lost; regen is quarterly income only — no passive trickle, no decay `[R?]` (cap pressure replaces decay; simpler to teach). PC confers no campaign-win points directly `[NEEDS-P1]`; any landslide-mandate interaction waits on P1/P6 `[NEEDS-P1]`.

**UI surface:** one paragraph — PC lives in the top bar next to the treasury as a small "Capital 42/100" pill with a quarterly "+16 next poll" tooltip breaking down base/approval/demand sources; spend buttons sit where they are used (visit on the map region panel, buyout on the demand card, fast-track on the policy card, emergency on the event card), each showing cost and grey-out at insufficiency — the player reads income in one place and spends in context, never in a separate currency screen.

## Proposed GDD section 5 patch

Exact replacement paragraph for the sentence "Meeting them costs money or political capital…" (GDD not edited — Lucas to apply):

> Faction demands arrive as timed directive goals: *"Fund the trades academy by Q3 or Motor & Makers approval −15."* Meeting a demand costs budget dollars; a governor short on cash may instead spend political capital (a 0–100 pool earned quarterly from approval and demands met) to buy out, extend, or fast-track it — or spend capital on visits, fast-tracks, and emergency responses between budget cycles. Ignoring a demand costs approval.

## Open ambiguities (for Lucas)

1. Confirm DEFINE over DELETE?
2. Is pausing a bond/faction timer via emergency powers too strong, or the right "save" fantasy?
3. Visit cooldown (1 month) and +3 effect — spam-safe enough, or gate by PC income alone?
4. Should PC income double in campaign season like approval-changes (appendix §6), or stay flat?
5. Will P6 legislature consume PC (buying votes)? If yes, this spec needs a fifth spend option.

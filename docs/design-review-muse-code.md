# Mitten State GDD v0.1 — Design Review (Muse Code)

Date: 2026-10-06. Reviewing `MITTEN-STATE-GDD-v0.1.md` as a management-sim design draft. Direct, no filler.

What's good, briefly: the five pillars are strong and testable; headless M0 before art is the right order; the cut list existing at v0.1 is mature; the tone guidance (§22) shows good judgment.

---

## 1. Holes and contradictions

**1.1. The #1 GDP goal is unachievable as written — the campaign promise fails on arithmetic.**
Michigan GDP (~$600B) vs California (~$3.9T) is roughly a 6x gap, and Texas sits in between. No plausible multi-term compounding closes that while rivals also grow; even sustained 8–10% annual outperformance takes decades. Either the sim uses cartoon growth rates (breaking the "honest starting conditions" framing) or the player can never win. This is the single most load-bearing number in the doc and it doesn't work. See revision P1.

**1.2. Session length contradicts the stated speeds.**
One game-year = 365 × 30s ≈ 3 hrs at 1x, ≈ 23 min at 8x (doc says ≈25, fine). A 4-year term is therefore ≈3 hrs at sustained 4x, ≈6 hrs at 2x. The doc claims "one 4-year term ≈ 2–4 hours" while also claiming "most play happens at 2–4x." At 2x a term is ~6 hours, not 2–4. The 2–4 hour figure requires averaging ~4–8x, at which point nothing is watchable (see 1.3). Pick one: shorter terms/years, or admit a term is 4–6+ hours.

**1.3. Day length vs. watchability vs. day/night cycle — three-way collision.**
At 1x, a 30-second day holds 5 beats (~6s each) plus thought bubbles: already borderline unreadable. At the 4–8x speeds the session math requires, beats last 1–4 seconds and bubbles are wallpaper. Meanwhile §16 promises "a real day/night cycle": at 8x that's a full day/night strobe every ~4 seconds. A literal day/night cycle is incompatible with the time scale. Either days get much longer (wrecking session length further), or day/night must be decorative/abstracted (e.g., tint shifts per beat, not a sun cycle).

**1.4. "The lens sample IS the distribution" contradicts LOD and small-region goals.**
§8 claims the 15–25k sample is truthful; §18 says off-screen citizens update at reduced rate. If macro truth comes from the lens, LOD makes it stale and untruthful; if macro truth comes from county aggregates, the lens is illustration, not truth — and pillar 1 ("what you watch is truthful") needs rewording. Separately, sampling breaks small regions: the UP holds ~3% of state population, so ~600 of 20k lens citizens live there — yet §13's example goal is "create 2,000 new jobs in the UP," a change nearly invisible in a 600-person sample. Lens counts and aggregate counts will visibly disagree unless the scaling rule is designed now.

**1.5. Firms-to-citizens ratio breaks "every layoff is visible."**
3,000 firms vs 20k lens citizens ≈ 7 lens citizens per firm on average, unevenly distributed — many small firms will employ zero lens citizens. A closure or layoff at such a firm produces no peep-level event, contradicting §9 ("every step visible in the towns they anchor") and pillar 1. Either lens citizens must be preferentially attached to volatile/visible firms (breaking pure statistical sampling — see 1.4), or firm events need non-peep representation (headlines, smoke-stops, protests), which should be stated.

**1.6. Political capital is spent but never defined.**
§5: "Meeting them costs money or political capital." No other mention: no income, no pool, no UI, no regeneration. Either there is a second currency with a full loop, or that sentence is wrong. It also matters enormously for pacing (a second spendable resource is how you give the player something to do between budget cycles).

**1.7. Money-need vs. household budget — the needs model contradicts itself.**
Needs are per-citizen (Money 0–100), but "households share one budget." Is Money individual or household? What depletes/regenerates a 0–100 Money score (payday fills it? spending drains it?)? A miner's unemployed spouse and working miner can't both have coherent Money values under both rules. Needs re-specification (see §2).

**1.8. Policy delays vs. pillar 1.**
Pillar 1 demands macro decisions become visible "within minutes of play." §10 cards carry "the delay before effects land" — realistic delays (a trades academy takes years) directly violate the pillar. The doc never resolves this except by assertion. Resolution exists (visible leading indicators during delays: construction, hiring notices, headlines), but it must be a stated rule, not hoped for.

**1.9. The governor is a dictator with an approval meter — no legislature, no institutional friction.**
The player unilaterally sets all taxes, the whole budget, and all policy. Suzerain (a named touchstone) gets its weight from institutional constraint; Tropico has edict costs and faction veto pressure. Here nothing between terms can block, dilute, or delay the player except approval numbers. That may be a valid simplification, but it hollows the "political" half of "political management" and removes a whole class of mid-term stakes. Decide explicitly: add a minimal legislature/court friction layer, or write one honest paragraph justifying its absence.

**1.10. Region↔faction mapping is muddled in the north.**
Region 4 ("North / Up North": Traverse City tourism, cherries, cabins) and the UP (mining, timber) are distinct regions, but one faction — Up North/Yoopers — spans both, while Lakeshore faction claims "Traverse City and the coasts" as its turf. So Traverse City tourism workers belong to a pro-mining faction whose flagship demand (loosen permits) angers Lakeshore — the faction that actually represents their industry. Either split the faction (Yoopers vs. Up-North tourism) or define Up North/Yoopers as explicitly rural-identity-first with internal tension handled by demands rotation. As written, "who do Traverse City bartenders root for?" has no answer.

**1.11. Minor contradictions.**
- §12 makes Texas and California "distant economic benchmarks" but §14 requires passing them — they're the final bosses, not scenery.
- §15 promises Street/Peep zoom statewide; §21's M1 is one region. Fine as staging, but the art-scope implication of street-level statewide (every town modeled to peep resolution) is the doc's largest unacknowledged cost. See §3.
- "60fps on a mid-range PC" + "Steam Deck is the minimum spec target" are two different bars; Deck (Linux handheld APU) is the harder one and should be stated as *the* bar, with render fps decoupled from sim tick.
- Detroit transit pleases "Campus & Clinic" per Appendix A — odd; Ann Arbor/East Lansing researchers are not the natural constituency for Detroit buses. Probably Main Street (SE) + Motor (commute access), opposed as listed.
- "Win (term): re-election with approval ≥ 50%" sits next to "Main Street… decides elections." If the election is just statewide-blend ≥ 50, no faction especially decides anything; if Main Street has extra electoral weight, the election formula must say so.

---

## 2. Under-specified systems

An agentic coding tool could build *structure* from this doc but would invent every behavior. Ranked by how blocking each gap is:

**2.1. Zero numerical calibration anywhere.** No starting budget size or tax defaults/ranges, no policy costs, no effect magnitudes, no decay rates, no thresholds (deficit→bond cut, exodus count, "faction under 25 for long" — how long?), no election formula, no $200M-in-context scale. This is the biggest single gap: the doc needs a tuning appendix with starting values and units before M0, or every agent invents its own economy.

**2.2. Firm↔citizen coupling — the core loop's missing link.** Nothing specifies how 3k firms and 20k lens citizens connect: hiring (which citizens get jobs at expanding firms?), layoffs (which ones lose them — random? LIFO? lens-first?), wages (who sets "local wages," the profitability input?), or firm founding/closure thresholds. "Profitability driven by wages, taxes, infrastructure, demand, policy" is a word list, not a function. The entire macro→micro→macro promise rests on this mechanism and it is absent.

**2.3. Movement and commute model.** Citizens commute; roads affect commute times; winter slows them. But do citizens path along the road graph, or move straight-line with a time penalty? Is there congestion, or only condition-gated speed? Without this, "Fix the Damn Roads" has no implementable effect on peeps, and the traffic/commute showpiece can't be built.

**2.4. Tax and revenue model.** Slider ranges? Revenue = rate × base with what base, what elasticity (linear? Laffer-curve? migration response at extremes)? How fast does revenue respond — instant, quarterly? The player's #1 verb has no mechanics.

**2.5. Budget mechanics.** Annual allocation with what granularity (7 departments × $?), can the player reallocate mid-year, what happens to unspent funds, what do department funding *levels* map to (condition repair rates? approval? service quality stats?) — effect chains for K-12, health, public safety spending are entirely missing. Also: safety/crime (Main Street wants "safe streets," public safety is a budget line) has no stat, no source, no display.

**2.6. Needs engine.** Six needs, 0–100 — with what decay rates, what restores each, how needs map to behaviors (threshold table: at what Food value do they skip meals? at what Money value do they job-hunt? move?), and how the Money contradiction (1.7) resolves. Housing/rent is referenced ("Rent went up again…", starter-home program) with no housing market, no rent formula, no landlord — either specify a minimal rent model or cut rent references.

**2.7. Migration mechanics.** Individual trigger (which need/threshold packs the truck?), destination choice (in-state town selection? which rival state?), aggregate scaling (one lens mover = ~500 real people?), Ohio-poaching rules (event-driven? continuous drain modified by policy?), exodus threshold count. "Net interstate migration is a headline stat" needs a formula.

**2.8. Election and approval model.** Statewide blend weighted by what (population? turnout?). What polls show vs. what's real (noise? margin of error?). "Approval matters double" in campaign season — double what, applied where? What does the October surprise do mechanically? Narrow loss vs. "losing badly" — exact rule for campaign-end vs. continue. Primary challenges, protests, hostile press — flavor text or mechanics with effects?

**2.9. Faction demand cadence.** Arrival rate, max concurrent demands, how cost/penalty scale, whether demands can repeat or chain, what "Superior secession" stages are. Without cadence numbers, pacing (the #1 fun risk) can't be tuned or tested.

**2.10. Events deck mechanics.** Draw rate ("event frequency rises" in campaign season — from what to what?), scheduled vs. conditional vs. random mix, cooldowns, repeat rules, choice-effect schema. The examples are good; the machine dealing them doesn't exist.

**2.11. Infrastructure condition model.** Decay rate per network, funding→repair function, condition→effect functions (commute time multiplier? logistics cost %? approval breakpoints — "Fix the damn roads is a literal approval modifier": what formula?).

**2.12. 50-state abstract sim.** What each state tracks (GDP, growth, QoL — updated how?), Michigan's starting rank, rival growth rates, and the exact win check (passing California's live number? a fixed target?). Unbuildable as "simulated abstractly" — and load-bearing for P1 in §5.

**2.13. Amenity/leisure supply.** Peeps visit bars, parks, churches, games — what places these on the map? If firms don't include services and the governor places nothing, amenities need a generator (procedural per town? tied to Main Street approval? to income?). Otherwise leisure beats have no stage.

**2.14. Demographic engine bounds.** Aging, marriage, kids, retirement, death over multi-term campaigns: rates? Do dead/moved lens citizens get replaced (sample maintenance — how, preserving "truthful distribution")? Kids aging into workers over 18 game-years will almost never pay off inside one term — state the intended timescale or cut the generational promise for M1.

**2.15. Peep-finding UX.** "Click any citizen" works for visible ones; finding *interesting* ones (laid-off miners, new Ohio-bound families) needs a citizen browser with filters/alerts. Thought-bubble culling rules (which of 20k bubbles render, priority scheme) are also missing — without them, implementation produces spam or silence at random.

**2.16. JSON modding effect schema.** "Policies and events in JSON" requires a full effect-expression language (conditions, targets, magnitudes, delays) plus the sim hooks it can touch. That's a real subsystem to design, not a file-format choice. Defer past 1.0 or spec the schema early — don't assume it falls out of the implementation.

---

## 3. Scope reality check (solo + AI agents)

Brutal version: this GDD describes a 30–60 person studio's 3-year project. The cuts below aim at a shippable 1.0, not at killing the vision.

**3.1. Street-level statewide is the budget-killer — decide what zoom really means.**
"State → Region → Town → Street/Peep, smooth zoom" over real Michigan geography with distinct towns, growing buildings, mines, plants, farms, and readable tiny people is an art + procedural-generation project comparable to the sim itself. Cheaper readings that preserve the fantasy: (a) a curated set of ~12–20 diorama towns/venues (one copper town, one auto town, one cherry town…) with peep life concentrated there, rest of state as stylized map; (b) one zoomable "main street" template per town archetype, reskinned. Recommend (a): it focuses art, guarantees readable vignettes, and makes "every policy has a face" stageable instead of emergent-everywhere.

**3.2. The life sim is a second game — shrink it for M1.**
Marriage, kids, aging, retirement, death, generations ("a miner's daughter becoming a nurse") is a Crusader-Kings-lite demographic engine riding on a 30-second-day clock where a term is 1,460 days and a generation is ~6,500. It will not pay off inside M1's one-term slice and will consume sim-brain time better spent on firm↔citizen coupling. Cut to: age/retire/die + household budgets + job changes only; park marriage/kids/generations for post-launch. Keep the *aspiration* out of the M1 backlog or it will schedule itself.

**3.3. 20k agents × 60fps × Steam Deck is an over-constraint — decouple render from sim.**
60fps render is nice; the sim does not need to tick 20k agents per frame. Specify now: sim ticks at fixed daily/sub-daily cadence independent of frame rate; render interpolates. Also question 20k for M1: 5k (per M0) concentrated in the Southeast dioramas will look *more* alive than 20k spread statewide. Scale agent count only when perf headroom is measured, not scheduled.

**3.4. Likely blowups, ranked.**
1. Procedural towns + growth + seasons + day/night art pipeline (see 3.1). *Cut to dioramas + seasonal palette/weather overlays; day/night becomes per-beat tint, not a cycle.*
2. Demographic life sim (see 3.2). *Cut to job/retire/die.*
3. Firm↔citizen coupling done naively (20k × 3k matching). *Design the data flow first (firms post aggregate openings/layoffs; a placement pass assigns lens citizens; most churn stays statistical).*
4. 50-state sim + interstate deal/compact negotiation systems. *Cut deals to the event deck for 1.0 (bidding wars and compacts as authored event chains, not systems); the leaderboard can be a spirited fake — scripted rival growth curves with noise plus real Michigan numbers.*
5. JSON modding pipeline (see 2.16). *Defer; ship data-driven internals without promising a public schema.*
6. Follow-mode scrubable timeline (history buffers × 20k). *Already on the cut list — agree, and cut it now rather than later: keep follow + live bubbles + a text log of recent life events (cheap) instead of scrubbing (expensive).*

**3.5. The existing cut list is ordered wrong.**
"Scenarios → firm agents → timeline → seasons' effects" sacrifices the vision's load-bearing pieces (firm agents *are* pillar 1's engine; scenarios are cheap authored content by comparison). Suggested order instead: multiplayer tease (delete, don't park) → JSON modding promise → demographic depth → follow-timeline → 50-state fidelity (fake it) → seasons' *gameplay* effects → firm agents (last resort — losing these guts the game).

**3.6. M1 needs a stated budget-scope answer.**
M1 is "one full region (Southeast)" but the budget, taxes, factions, and lose conditions are statewide systems. Either M1 plays statewide-numbers/one-rendered-region (recommended: sim is state-wide, cameras live in SE dioramas) or M1 is a genuinely regional scenario (then bankruptcy/exodus/rules all need regional reskins — wasteful). One sentence in the GDD resolves weeks of confusion.

---

## 4. Fun-factor risks (and M1 de-risks)

**4.1. Risk: long stretches with nothing to do — the screensaver problem.**
Governor verbs are slow (annual budget, delayed policies, 4-year terms) while the fantasy is watching. If a session is "set taxes, wait 20 minutes, answer two events," it's a screensaver with homework. *M1 de-risk:* tune to a decision every 2–3 minutes (faction demands + events + quarterly check-ins as the heartbeat); add 2–3 fast-loop verbs that cost political capital or attention (declare emergency, fast-track repairs, ribbon-cutting visits with local approval effects); instrument "time between player actions" in playtests and treat >4 idle minutes as a bug.

**4.2. Risk: illegible causality — "did I do that?"**
In every sim of this family, the #1 quit moment is watching change you can't attribute. If hiring booms two (game-)months after a policy, no player connects them. *M1 de-risk:* every policy card gets a "watch this" list (places + stats to observe); every major map event gets a "because" line ("…because you cut industrial energy rates"); ship an approval-delta feed ("Campus +5: retention credits passed") and a per-policy outcome report card at quarter end. Attribution UI is not polish — it's the game.

**4.3. Risk: peep layer is wallpaper above 1x.**
At required play speeds (1.2–1.3), thought bubbles are unreadable and follow-cam fights with governing (you can't watch a miner's day and run a state simultaneously). *M1 de-risk:* pause-on-life-event toggles for followed citizens; a "vignette" button that jumps to a curated interesting moment (layoff day, first day at the battery plant, moving-truck morning) with auto-pause; peep browser filters ("show me: affected by my last 3 policies"). Test the question "can a player narrate what happened in the last 5 minutes?" — if not, the peep layer failed regardless of sim quality.

**4.4. Risk: faction approval feels arbitrary.**
Six meters moving on hidden math reads as moodiness, not politics. *M1 de-risk:* every approval change must have a visible, clickable reason; faction panels show "top 3 drivers right now" with magnitudes; demands state exact stakes and deadlines (already planned — enforce it in data validation so no demand ships without both).

**4.5. Risk: feedback cadence too sparse — elections every ~4 hours.**
Quarterly polls are the only mid-term scoreboard, and "approval matters double" is vague. *M1 de-risk:* give polls teeth — staged consequences (bad Q2 poll year → hostile press events, donor/agenda penalties, primary-challenger meter that is visible and defusable); monthly "headlines" summarizing trend arrows with faces attached. The player should feel judged quarterly, not quadrennially.

**4.6. Risk: failure states are too slow and remote to create tension.**
Bankruptcy spirals and exodus take terms to develop; a new player never feels danger in M1. *M1 de-risk:* staged early-warning meters with bite at each stage (deficit → bond outlook negative → borrowing costs up → emergency manager warnings, each with news + approval effects); a visible "Ohio gap" ticker from day one so interstate loss is felt monthly, not discovered at term end.

**4.7. Risk: the Ohio gag wears thin.**
Funny twice, then it's UI. *M1 de-risk:* keep the leaderboard but rotate the teeth (poached-plant events, talent-drain headlines naming real lens citizens, an end-of-year "border report"); never let Ohio be only a joke on a screen the player stops opening — attach each Ohio loss to a face and a place.

---

## 5. Prioritized revisions (highest value first)

**P1. Replace the #1-GDP win condition.** Options, best first: (a) "#1 in GDP *growth* over a term" or "Top 10 + #1 in the Midwest" — achievable, still epic; (b) tiered legacy ranks (Top 15 → Top 10 → Top 5 → #1 per-capita) so partial progress feels like winning; (c) keep #1 GDP but start Michigan much closer via acknowledged alt-history (weakest — breaks "honest" framing). Do this before any campaign-balance work or that work is wasted.

**P2. Write the numbers appendix.** Starting budget, tax defaults/ranges, 10–15 M0 policy costs and effect magnitudes, need decay rates, demand cadence, thresholds (bonds, exodus, faction floor timers), election formula, dollar scale. One or two pages unlocks M0 implementation; without it every agent invents a different game.

**P3. Specify the firm↔citizen coupling + movement model.** The placement pass (firms post openings/layoffs → lens assignment), wage rule, commute/pathing abstraction, and the lens-vs-aggregate scaling law (what one lens mover "counts" as). This is the macro→micro→macro loop on paper — M0's actual deliverable.

**P4. Resolve the time-scale package as one decision.** Day length, speeds, term/session length, beat readability, and day/night (recommend: longer readable days + fewer required high-speed stretches + per-beat lighting tint instead of a sun cycle + explicit "a term is X hours at intended speeds"). Don't tune these separately — they're one equation, and 1.2–1.3 show it's currently unsolved.

**P5. Define political capital or delete it.** If kept: income (per quarter? per approval level?), spend options (fast-track, emergency powers, demand buyouts), cap. A second resource also fixes the idle-hands problem (4.1). If cut: remove from §5 and design fast-loop verbs another way.

**P6. Make the legislature call (1.9) and the election formula (2.8) explicit.** Minimal viable: a one-paragraph "the legislature is abstracted as…" plus the exact election rule (blend weights, noise, narrow-vs-landslide outcomes). Both are half-page decisions blocking all mid-term stakes design.

**P7. Fix the north (1.10).** Either split Up North/Yoopers from northern-lower tourism into Lakeshore's orbit, or define the faction's internal tension and demand rotation explicitly. While there: fix Appendix A's Detroit-transit row and state Main Street's exact electoral role (1.11).

**P8. Adopt the leading-indicator rule for policy delays (1.8).** Every policy with delay > N days ships with staged visible precursors (announcement → construction/hiring → effects), each with map + headline + peep representation. Make it a checklist item on the policy-card template so content can't violate pillar 1.

**P9. Re-scope M1 in one paragraph (3.1, 3.6).** State: statewide sim numbers + Southeast dioramas; agent count for the slice; demographic cuts (3.2); 50-state leaderboard faked with curves; deals-as-events. Then re-order the cut list per 3.5.

**P10. Specify attribution UI as M1 scope, not polish (4.2–4.4).** "Watch this" lists, "because" lines, approval-delta feed, vignette button, peep filters. If these slip to beta, the M1 playtest question ("is it fun to watch?") can't be answered — unwatched causation reads as randomness.

**P11. Decouple sim tick from frame rate; restate the perf bar (1.11, 3.3).** "60fps render; fixed-cadence sim ticks; Steam Deck is *the* minimum spec." And change M0's "hit the perf budget on paper" to measured headroom on target hardware — paper proves nothing.

**P12. Delete the multiplayer tease; defer JSON modding publicly (3.4–3.5).** Both cost design attention every milestone while contributing nothing to 1.0. Cut ironman-vs-not deliberation too — it's a checkbox, not a design question; just ship the toggle.

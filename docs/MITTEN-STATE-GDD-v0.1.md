# MITTEN STATE — Game Design Document

**Version 0.1 — 2026-10-05 — Concept draft (for discussion, not locked)**

---

## 1. High concept

A peaceful stewardship sim: you are the Governor of Michigan. No armies, no conquest — the map ends at the state line. You govern ~10 million people through policy, budgets, and edicts, and you can zoom from the statehouse all the way down to watch any single citizen live their day: the night-shift copper miner grabbing a pasty on the way home, the line worker commuting to the plant, the retiree heading up north to the cabin. **Every policy has a face.** Win re-election, keep the state solvent, balance six rival factions, and chase the ultimate prize: making Michigan the #1 economy in America — before everyone moves to Ohio.

**Genre:** society sim / political management. **Touchstones:** Tropico (faction balancing, directive goals, tongue-in-cheek tone), Cities: Skylines (watchable agents), Democracy 4 (policy webs), Suzerain (political narrative weight), RollerCoaster Tycoon (peep cam).

**The one-sentence pitch:** *Tropico meets RollerCoaster Tycoon, set in real Michigan, with no war — just 10 million people counting on you.*

---

## 2. Design pillars

1. **Every policy has a face.** Any macro decision must become visible in individual lives within minutes of play. If the player can't see it happen on the map or in a thought bubble, it doesn't exist.
2. **Stewardship, not conquest.** The fantasy is care and competence, not domination. Other states are rivals and trading partners, never targets.
3. **Real Michigan.** Real geography, real cities, real tensions, fictional firm names. Real soul, no legal headaches.
4. **Watchable systems.** The sim is a show first and a spreadsheet second. Dashboards support what the map already told you.
5. **Tradeoffs, not solutions.** Every policy pleases a faction and angers one. There is no "fix everything" button — that's the game.

---

## 3. Player role: the Governor

You do not place buildings. There is no bulldozer, no zoning brush, no road tool. Your verbs:

- Set tax rates (income, sales, property, corporate).
- Allocate the annual budget across departments.
- Issue policies and edicts from the policy catalog (§10).
- Fund, defund, or repair infrastructure networks.
- Negotiate interstate deals and compacts.
- Respond to events and crises as they arise.
- Accept or reject faction demands (Tropico-style, with timed stakes).

What you explicitly do NOT do: place individual buildings, control citizens directly, manage firms, or command anything outside the state line.

---

## 4. Setting: Michigan, today

The game starts with Michigan as it actually is — real cities in real places, the real highway network (I-75, I-94, I-96, US-131), and the Mackinac Bridge joining two peninsulas. Starting infrastructure condition, industry mix, and demographics mirror the modern state (tuned for fun, not a census replica).

**Regions:**

- **Southeast / Motor** — Detroit metro, Flint, Lansing, Ann Arbor. Auto plants, suburbs, universities. Roughly half the population and the economic engine.
- **West / Lakeshore** — Grand Rapids, Holland, Muskegon. Manufacturing, medical, Lake Michigan coast, tourism.
- **Central / Growers** — Saginaw, Bay City, the farm belt. Agriculture plus legacy manufacturing towns.
- **North / Up North** — Traverse City, Petoskey, Alpena. Tourism, cherries, cabins, the second-home economy.
- **Upper Peninsula** — Marquette, Houghton, Ironwood. Iron and copper mining, timber, Michigan Tech, rugged independence.

**Starting conditions (modern, honest):**

- Roads are famously bad. Deferred maintenance is a visible, voter-noticed stat from day one.
- The auto industry is mid-transition: EV and battery plants are both an opportunity and a disruption.
- The UP is slowly losing people; graduates drain to Chicago and the coasts ("brain drain" is a real, named mechanic).
- Assets to play with: Great Lakes freshwater, world-class research universities, strong agriculture, and the "up north" tourism brand.

---

## 5. Factions

Six factions, each with an approval meter (0–100), a set of demands, and rivals. Statewide approval is a weighted blend. Keep any faction under ~25 for long and you get protests, hostile press, and primary challenges.

1. **Motor & Makers** — Manufacturing and auto workers, SE Michigan. Wants: factory incentives, skilled-trades apprenticeships, affordable industrial energy, right-to-work kept as-is. Rivals: Lakeshore (emissions, runoff), Campus & Clinic (budget fights).
2. **Up North/Yoopers** — UP and northern lower; mining, timber, tourism. Wants: mining permits, resource revenue sharing, Mackinac Bridge toll relief, rural broadband, a little respect. Has a genuine independence streak — ignore them long enough and the "Superior secession" jokes stop being jokes (a real event chain).
3. **Growers** — The agricultural belt. Wants: water rights, seasonal labor policy, crop supports, ethanol mandates. Rivals: Lakeshore (fertilizer runoff into the lakes).
4. **Lakeshore** — Tourism and coastal towns (Traverse City and the coasts). Wants: clean water, shoreline protection, tourism marketing money, sane short-term rental rules. Rivals: Up North/Yoopers (mining), Growers (runoff).
5. **Campus & Clinic** — Knowledge and medical economy (Ann Arbor, East Lansing, Grand Rapids' Medical Mile). Wants: university funding, research grants, graduate retention programs. Rivals: Motor & Makers (every budget season).
6. **Main Street** — Suburban and small-town families. The biggest faction, the mildest, and the one that decides elections. Wants: good schools, safe streets, low property taxes, and fixed roads.

Faction demands arrive as timed directive goals: *"Fund the trades academy by Q3 or Motor & Makers approval −15."* Meeting them costs money or political capital; ignoring them costs approval.

---

## 6. Core loop & session structure

1. **Observe** — Watch the state breathe: peep cams, dashboards, faction moods, the news ticker.
2. **Decide** — Adjust taxes and budget, issue policies, answer events, take or refuse faction demands.
3. **Watch** — Effects propagate visibly: hiring booms, moving trucks, thought bubbles, headlines.
4. **Answer for it** — Quarterly polls, the annual budget review, and re-election every four years.

**Session arc:** one 4-year term ≈ 2–4 hours of play. **Campaign arc:** multiple terms chasing the #1 economy ranking (§12, §14).

---

## 7. Time, pacing & scale

- Pausable real-time with 1x / 2x / 4x / 8x speeds.
- At 1x, one game-day = 30 real seconds. A game-year ≈ 3 hours at 1x, ≈ 25 minutes at 8x. Most play happens at 2–4x with pauses for decisions.
- Citizen daily routines are compressed into readable beats (sleep → commute → work → leisure → home) synced to the calendar day. Thought bubbles mark each beat. You watch vignettes of a day, not a literal day.
- Terms last 4 game-years. The final 6 months are campaign season: approval matters double, event frequency rises.
- **Seasons are real:** lake-effect snow events slow commutes and close schools in winter; summer drains the cities "up north" and spikes tourism revenue. Fall colors up north are a tourism bump and an art showcase.

---

## 8. Citizen simulation (the peep layer)

**Lens citizens:** 15,000–25,000 fully simulated individuals, statistically sampled from county demographics. The remaining ~10M Michiganders exist as county-level statistical aggregates that produce the macro numbers. The lens sample IS the distribution, so what you watch through it is truthful.

Each lens citizen has:

- **Identity:** name, age, household, hometown, employer, job role, shift pattern.
- **Six needs (0–100):** Money, Rest, Health, Food, Social, Purpose. Low needs drive visible behavior — skipping meals, bar visits after bad shifts, job hunting, and eventually packing a moving truck.
- **Daily beats:** sleep → commute → work → leisure (bar, park, church, kids' game, fishing) → home. Leisure choices reflect needs, income, and local amenities.
- **Thought bubbles** narrating beats: *"Night shift at the copper mine," "Pasty run after work," "Rent went up again…"*
- **A life:** citizens age, marry, have kids, change jobs, get laid off, retire, and die. Households share one budget. Kids become students become workers — the generational payoff (a miner's daughter becoming a nurse) is the emotional core.
- **Follow mode:** attach the camera to any citizen; scrub a timeline of their recent days.
- **Life-event notifications** (clickable, zoom-to): birthdays, weddings, graduations, layoffs, retirements, funerals — and *"The Millers moved to Ohio,"* complete with a tiny moving truck on the map. The fail state, made visible and personal.

**Migration:** citizens move between towns for jobs and housing; net interstate migration is a headline stat. Ohio poaching is a running gag with real teeth (§12).

---

## 9. State simulation (the macro layer)

**Budget.** Revenue: income tax, sales tax, property tax, corporate tax, bridge tolls, federal grants, tourism-related revenue. Expenses: K-12 education, universities, roads & bridges, health & human services, public safety, environment & parks, debt service. Deficits add debt; debt service eats future budgets; sustained deficits trigger bond-rating cuts and then the bankruptcy spiral (a lose condition, §14).

**Infrastructure condition** (starts as-is: roads rough). Each network — highways, the Mackinac Bridge, rural roads, broadband, water systems — has a condition meter that decays over time and improves with funding. Visible effects: commute times, firm logistics costs, and voter anger. "Fix the damn roads" is a literal approval modifier.

**Industries** (simplified chains, emergent-feeling, never academic):

- Auto & advanced manufacturing (SE) — sensitive to incentives, energy costs, trade conditions.
- Mining & timber (UP/North) — sensitive to permit strictness, environmental rules.
- Agriculture (Central/West) — sensitive to water policy, labor rules, supports.
- Tourism & leisure (Lakeshore/North) — sensitive to marketing, water quality, seasons.
- Knowledge & health (campus towns) — sensitive to university funding, retention programs.
- Logistics & ports (Great Lakes shipping, border crossings) — sensitive to infrastructure condition.

**Firms as lightweight agents (~3,000):** each firm has profitability driven by local wages, taxes, infrastructure, demand, and policy. Profitable firms hire and expand; struggling firms freeze hiring, then lay off, then close — every step visible in the towns they anchor. New firms spawn where conditions turn good: *"A battery startup just opened in Lansing!"*

**Readability rule:** every macro number must be explainable in one sentence and visible in peep behavior. No econ degree required — fun first, feeling effective.

---

## 10. Policy catalog (the player's verbs)

Each policy card shows cost, affected factions (+/−), and the delay before effects land. Examples by domain:

- **Taxation:** income / sales / property / corporate sliders; rainy-day fund rule.
- **Roads & bridges:** "Fix the Damn Roads" blitz (big cost, Main Street +, every firm's logistics improve); Mackinac Bridge toll policy.
- **Labor & workforce:** trades apprenticeship funding (Motor +), minimum wage level (Main Street +, firm costs up), graduate retention credits (Campus +).
- **Business:** factory recruitment packages (can trigger interstate bidding wars, §12), small-business grants, tourism marketing, film incentives.
- **Environment & water:** mining permit strictness (Up North/Yoopers − / Lakeshore +), shoreline protections, PFAS cleanup program, renewable portfolio standard, Great Lakes compact stance.
- **Social & health:** school funding formula, Medicaid scope, starter-home housing program, marijuana tax allocation (it's legal; the revenue is real).
- **Infrastructure:** rural broadband buildout, Detroit regional transit funding (a perennial Michigan debate — include it as a faction flashpoint).
- **Governance:** transparency initiatives, local-control vs. state-preemption choices.

---

## 11. Events system

A deck of events, some scheduled, some conditional, some random — each with 2–4 response choices carrying faction and budget consequences:

- Lake-effect blizzard (close schools? declare emergency? plow budget?)
- Major plant closure announcement (the scenario version is playable, §13)
- Cherry crop failure — or record harvest
- PFAS discovered in a town's water
- Ohio offers a firm $200M in tax breaks (match it or lose the plant)
- Federal infrastructure grant (with strings attached)
- "Superior secession" petition drive (if Up North/Yoopers are ignored)
- Record summer tourism surge up north
- Election-year October surprise

---

## 12. Other states: rivals, not targets

- **Event and deal sources:** federal grants, interstate compacts (the Great Lakes water compact is a real negotiation), factory bidding wars, poaching attempts.
- **The Ohio gag:** an interstate migration leaderboard where losing citizens to Ohio stings because it's funny. Texas and California serve as distant economic benchmarks.
- **The 50-state leaderboard:** all states ranked by GDP, growth, and quality of life, simulated abstractly. **Ultimate campaign goal: take Michigan to #1 in GDP.** It takes multiple terms of compounding wins — the spine of the long game.
- Neighbors poach: ignore Motor & Makers and the plant announcement goes to Indiana instead.

---

## 13. Goals, progression & scenarios

**Tropico-style directive goals** — 3–5 per term, partly chosen by the player, partly dealt:

- "Get unemployment under 5% by end of term."
- "Keep every faction above 30 approval."
- "Balance the budget without raising income tax."
- "Create 2,000 new jobs in the UP."
- Faction demands as timed side-goals with approval stakes (§5).

**Scenarios** (post-vertical-slice content):

- **The Plant Closing** — a major auto plant announces shutdown in year one. Save the town.
- **The Big Snow** — a record winter tests infrastructure and the budget.
- **Brain Drain** — reverse a decade of graduate outflow in one term.

**Sandbox:** free play with the leaderboard chase and no scripted goals.

---

## 14. Win / lose

- **Lose:** **bankruptcy** (debt spiral → state financial takeover, game over) or **exodus** (net population loss past a threshold — "everyone moved to Ohio," shown as a map full of moving trucks). Losing re-election badly also ends the campaign (sandbox may continue).
- **Win (term):** re-election with approval ≥ 50%.
- **Win (campaign):** Michigan ranked #1 in state GDP. Epilogue screen: legacy stats, notable citizens you followed, and the headlines you caused.

---

## 15. UI/UX

- **Map layers:** State → Region → Town → Street/Peep, with smooth zoom. The mitten is the home view.
- **Dashboards:** budget, factions, industries, polls — one click from the map, readable in ten seconds.
- **News ticker + notification feed:** every item clickable, zooming to its location.
- **Peep cam:** click any citizen to follow; thought bubbles; a "day in the life" timeline.
- **Policy screen:** card-based; each card shows cost, faction effects, and delay. Mouse-first, information-dense PC UI.
- **Accessibility:** colorblind-safe faction colors, full pause, scalable UI text.

---

## 16. Art direction

Cozy isometric 2D — a deliberate contrast with the genre's usual cold dashboards. Readable tiny people with distinct silhouettes (hard hats at the mine, scrubs at the clinic). A real day/night cycle and four seasons: fall colors up north, lake-effect snow burying the UP. Towns grow visibly: new houses, factories with smoke — and the smoke going out when they close. Warm, storybook Michigan.

---

## 17. Audio

Light but present: ambient town beds, seasonal soundscapes (crickets in summer, wind in winter), gentle UI sounds, a cozy acoustic score. Event stingers: a factory whistle, a snowstorm hush, election-night swells. No voice acting required.

---

## 18. Tech architecture

- **Engine:** Godot 4. Language decision (C# vs GDScript) in pre-production — lean C# for sim performance, GDScript for iteration speed; possibly both (C# sim core, GDScript UI).
- **Architecture:** strict sim/render split; fixed-timestep sim ticks (daily tick for macro, sub-daily beats for citizens); spatial partitioning for agent updates; LOD — off-screen citizens update at reduced rate.
- **Perf budget:** 20k lens citizens + 3k firms at 60fps on a mid-range PC. **Steam Deck is the minimum spec target** — a real constraint that keeps the sim honest.
- **Saves:** full state serialization; optional ironman mode.
- **Modding:** policies and events defined in data files (JSON) so the community can add their own state — and the "your state" DLC concept (§19) shares the pipeline.

---

## 19. Platform & release

**Decision: PC via Steam (Windows/Linux/macOS), mouse-first.**

- The genre's audience buys on PC: the Tropico series has topped 4.5M sales lifetime; Cities: Skylines hit #1 on Steam's top-seller list at launch; the management/political-sim audience (Tropico, Democracy, Suzerain) is concentrated on Steam.
- The UI this game needs — dense dashboards, precise map zooming, peep-picking — wants a mouse. Touch/phone is out (agreed).
- Consoles are a post-launch consideration, not a launch target (Tropico 6 shipped PC first, then PS/Xbox/Switch).
- **Price:** $24.99 premium. **Demo:** one free scenario (The Plant Closing) + Steam Next Fest participation.
- **Post-launch:** "Your State" DLC concept — Ohio, Texas, etc. on the same engine. (The joke writes itself.)

---

## 20. Monetization

Single premium purchase, no microtransactions, no ads — the genre's audience rejects them and the fantasy (public stewardship) makes them tonally absurd. DLC states later. That's the whole plan.

---

## 21. Scope & milestones

- **M0 — Paper & headless prototype (4–6 wks):** sim core with no art. 5k citizens, one region, budget + 10 policies. Prove the macro→micro→macro loop and hit the perf budget on paper.
- **M1 — Vertical slice (8–12 wks):** one full region (Southeast), peep cam, one term goal set, lose conditions. Playtest question: *"Is it fun to watch?"*
- **M2 — Alpha:** all five regions, six factions, full policy catalog, events system, elections.
- **M3 — Beta:** scenarios, abstracted 50-state leaderboard, balance, polish.
- **M4 — Launch:** demo, Next Fest, 1.0.

**Cut list (if needed, in order):** scenarios → ship with one; firm agents → sector-level stats; follow-mode timeline → thought bubbles only; seasons' gameplay effects → visual only.

---

## 22. Risks & open questions

- **Sim readability is the #1 risk.** A sim can be correct and illegible. Mitigation: every number must have a map or thought-bubble representation; playtest the vertical slice early and specifically for this.
- **20k-agent performance in Godot** — M0 answers this before any art exists.
- **Tone:** cozy art vs. the real pain of plant closings and layoffs. Handle economic pain with humanity, never as a joke. (The Ohio gag is aimed at the rivalry, not at suffering.)
- **Real-data accuracy vs. fun:** real geography, tuned numbers. Never let a census table override a good game.
- **Open:** C# vs GDScript; exact day-length tuning; whether "compare your state with a friend's" multiplayer has any legs (post-launch thought only).

---

## Appendix A — Faction conflict matrix (who angers whom)

| Policy direction | Pleases | Angers |
|---|---|---|
| Loosen mining permits | Up North/Yoopers, Motor & Makers | Lakeshore |
| Strict water/shoreline rules | Lakeshore | Growers, Up North/Yoopers |
| Factory tax incentives | Motor & Makers | Campus & Clinic, Main Street (if taxes rise to pay) |
| University funding surge | Campus & Clinic | Motor & Makers |
| Property tax cut | Main Street | Everyone who likes the programs it funded |
| "Fix the Damn Roads" blitz | Main Street, all firms | Whoever's budget got raided |
| Rural broadband | Up North/Yoopers, Main Street | (cheap goodwill — use sparingly) |
| Detroit transit funding | Campus & Clinic, Main Street (SE) | Up North/Yoopers, Growers ("downstate gets everything") |

## Appendix B — Glossary

- **Lens citizen:** a fully simulated individual; the player's window into the population.
- **Beat:** one compressed phase of a citizen's day (commute, work, leisure…).
- **Directive goal:** a Tropico-style timed objective with approval stakes.
- **Term:** 4 game-years ending in a re-election vote.
- **Exodus:** the population-loss fail state. Nobody wants the moving trucks.

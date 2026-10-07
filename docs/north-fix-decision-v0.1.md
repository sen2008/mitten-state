# P7 — Fix the North v0.1 (Phase 0)

**DRAFT-NEEDS-Lucas-REVIEW — the entire document below is draft. No Phase 1+ work may treat any value here as final until Lucas reviews it.**

Paper only. No game code. GDD, roadmap, and all other files untouched.

**Sources read:** review 1.10 (muddled north mapping), 1.11 (Detroit-transit row, Main Street electoral role), P7; GDD §§4 (regions), 5 (factions), 10 (policy catalog), 11 (events), Appendix A (conflict matrix); legislature-decision-v0.1.md Part B (Main Street electoral role — adopted, not re-decided); numbers-appendix-v0.1.md (rows referencing Yoopers/Lakeshore: §2 policies 6, 7, 11, 12; §5 faction floor; §6 shares); coupling-spec-v0.1.md (§4.3 UP rule, §4.4 shares audit, open ambiguities 7, 12); political-capital-decision-v0.1.md (visit verb).

**Flag legend:** `[G]` = gameplay figure invented here, tunable in Phase 3–4. `[NEEDS-P1]` = depends on the pending win-condition decision; assumed nowhere.

**The review's test, answered up front:** *Who do Traverse City bartenders root for?* **Lakeshore.** If that sentence is the only thing you remember from this doc, the doc worked.

---

## Part A — The north decision: RECOMMEND (a) split tourism into Lakeshore's orbit

> **DRAFT-NEEDS-Lucas-REVIEW**

**Recommendation: option (a).** Northern-lower tourism (the Traverse City orbit: tourism, cherries, cabins, second-home economy) moves into Lakeshore's orbit as a named tourism sub-identity. Up North/Yoopers becomes UP-only and rural-identity-first (mining, timber, bridge tolls, broadband, the independence streak). Faction count stays six — this is a membership redraw, not a new faction.

**Honest reasoning (gameplay clarity vs. faction count):** neither option changes the faction count, so the real tradeoff is clarity now vs. churn later. Option (b) preserves today's appendix shares and avoids re-weighting, but it permanently bakes a self-contradicting faction into the game: every "loosen mining permits" tick would please the faction's UP half while narratively betraying its Traverse City half, and the demand-rotation rule is a patch the player must learn ("this faction's demands alternate identities — check which half is speaking") before any demand from it is legible. That violates pillars 4 and 5: factions must be readable at a glance, and tradeoffs must be between factions, not inside one. Option (a) costs a small one-time re-weight of two appendix shares plus a handful of lock-time text edits (checklist below), and in return every faction becomes teachable in one sentence — including the answer above. Clarity wins; the re-weight is cheap paper math.

**Rejected (b), kept visible so Lucas can flip with one sentence:** keep one Up North/Yoopers faction spanning the UP + northern lower, defined rural-identity-first, with a demand-rotation rule (tourism demands and mining/timber demands strictly alternate in the demand deck so Traverse City workers know which demands speak for them). Rejected because rotation does not fix identity — a faction whose flagship demand angers half its own members is unteachable no matter how fairly the demands alternate.

### Precise faction membership rule (for Traverse City-orbit citizens)

Evaluated top-down, first match wins, at citizen spawn/sampling time (normative for appendix v0.2 §6 and Phase 3 sampling code; M0 is Southeast-only and unaffected):

1. **N1 — Lakeshore tourism sub-identity:** any citizen whose employer sector is tourism/leisure AND whose home county is in the North region (Traverse City, Petoskey, Alpena orbit) or the UP → **Lakeshore**, flagged tourism sub-identity. This covers Traverse City bartenders, servers, hotel staff, marina hands, and UP tourism workers (Pictured Rocks guides, ski staff). Tourism workers vote their industry, not their peninsula.
2. **N2 — Yoopers:** any citizen with a UP home county not captured by N1 → **Up North/Yoopers** (miners, timber crews, Michigan Tech staff/students stay Campus per existing rule, Main Street families in Marquette stay Main Street — N2 takes the rural-identity remainder, not the whole peninsula).
3. **N3 — Northern-lower remainder:** North-region citizens not captured by N1 fall through to the existing assignment (cherry/agriculture workers → Growers; suburban and small-town families → Main Street; default weights per appendix §6 as re-split below). Nothing in the northern lower peninsula defaults to Yoopers anymore.

Result: Traverse City tourism workers belong to Lakeshore, full stop. UP miners and timber crews belong to Yoopers, full stop. No citizen's faction membership contradicts their livelihood.

### Demand/event routing under (a)

- **Routes to Lakeshore:** tourism marketing money, shoreline protection, short-term rental rules, clean-water demands, cherry harvest/crop-failure events, summer-tourism-surge events, "up north" cabin/second-home economy events. Northern-lower tourism employment effects (hiring waves, seasonal layoffs) tick Lakeshore approval.
- **Routes to Yoopers:** mining permits, timber rules, resource revenue sharing, Mackinac Bridge toll relief, rural broadband in the UP, and the full "Superior secession" crisis chain (now UP-pure — secession reads correctly as a Yooper threat, never a Traverse City one).
- **Shared/secondary:** PFAS cleanup stays Lakeshore-primary (already is, appendix §2 policy 11); rural broadband in northern-lower counties ticks Lakeshore tourism secondarily alongside rural Main Street, not Yoopers. No demand under (a) pleases and angers the same faction.

### Quoted GDD replacement text blocks (Lucas to apply at lock — GDD not edited here)

**GDD §4 region bullet — REPLACE the North bullet (adds the faction-routing pointer; region geography unchanged):**

> - **North / Up North** — Traverse City, Petoskey, Alpena. Tourism, cherries, cabins, the second-home economy. (Faction routing per P7: tourism workers here belong to Lakeshore's tourism sub-identity; the farm remainder belongs to Growers/Main Street — not to Up North/Yoopers.)

**GDD §5 faction entry 2 — REPLACE in full:**

> 2. **Up North/Yoopers** — The Upper Peninsula only: mining, timber, and rugged rural independence. Wants: mining permits, resource revenue sharing, Mackinac Bridge toll relief, rural broadband, a little respect. Has a genuine independence streak — ignore them long enough and the "Superior secession" jokes stop being jokes (a real event chain). (P7: northern-lower tourism workers belong to Lakeshore, not here.)

**GDD §5 faction entry 4 — REPLACE in full:**

> 4. **Lakeshore** — Tourism and coastal towns (Traverse City and the coasts), plus the northern-lower tourism orbit as a tourism sub-identity. Wants: clean water, shoreline protection, tourism marketing money, sane short-term rental rules. Rivals: Up North/Yoopers (mining), Growers (runoff).

---

## Part B — Detroit-transit Appendix A row fix

> **DRAFT-NEEDS-Lucas-REVIEW**

**Corrected row (quoted; Lucas to apply at lock — GDD not edited here):**

| Detroit transit funding | Main Street (SE), Motor & Makers | Up North/Yoopers, Growers ("downstate gets everything") |

**Rationale in one line:** Detroit buses are ridden by Southeast commuter families (Main Street) and plant/office workers who need commute access (Motor), not by Ann Arbor/East Lansing researchers — Campus & Clinic was the wrong constituency.

---

## Part C — Main Street's electoral role: RESOLVED BY REFERENCE

> **DRAFT-NEEDS-Lucas-REVIEW**

This P7 sub-item (review 1.11: "if Main Street has extra electoral weight, the election formula must say so") is **satisfied by [legislature-decision-v0.1.md Part B](/home/hatch/workspace/mitten-state/docs/legislature-decision-v0.1.md), not re-decided here**: Main Street carries a ×1.3 turnout weight for an exact **44.3%** electoral share (Motor 16.2%, Campus 10.8%, Lakeshore 9.9%, Growers 9.9%, Yoopers 9.0% `[G]`). No new numbers in this file; if Lucas flips the legislature doc, that flip propagates here automatically. (Note: under Part A option (a), the Lakeshore/Yoopers base shares re-split per the checklist below, and the legislature doc's B1 weights must be recomputed at lock — the ×1.3 Main Street mechanism itself is unchanged.)

---

## Consistency checklist — every file referencing the old mapping, and what changes at lock under each option

> **DRAFT-NEEDS-Lucas-REVIEW**

| File | Reference to old mapping | Under (a) RECOMMENDED | Under (b) if Lucas flips |
|---|---|---|---|
| GDD §4 | "North / Up North" region bullet (no faction pointer) | Apply Part A region-bullet replacement above | No change |
| GDD §5 entries 2, 4 | Yoopers "UP and northern lower; mining, timber, tourism"; Lakeshore "(Traverse City and the coasts)" with no sub-identity | Apply both Part A entry replacements above | Rewrite entry 2 as rural-identity-first + demand-rotation rule; entry 4 unchanged |
| GDD §10 Environment row | "mining permit strictness (Up North/Yoopers − / Lakeshore +)" — wait, that row is already correct in shape | No change (row already splits the two factions; under (a) it reads cleanly) | No change, but the row's Yoopers "−" now bites Traverse City tourism workers inside the faction — flag as known awkwardness |
| GDD §11 secession event | "Superior secession petition drive (if Up North/Yoopers are ignored)" | No text change needed; chain is now UP-pure by membership rule (verify at content lock that no northern-lower triggers remain) | Rewrite trigger so only UP-identity demands feed the chain; tourism demands must never advance secession |
| GDD Appendix A mining/water rows | "Loosen mining permits" pleases Yoopers/angers Lakeshore; "Strict water rules" pleases Lakeshore/angers Yoopers | No change (rows already correct; membership fix makes them true) | No change (but same inside-faction awkwardness as §10) |
| GDD Appendix A transit row | "Detroit transit funding pleases Campus & Clinic, Main Street (SE)" | Apply Part B corrected row | Apply Part B corrected row (same under both) |
| numbers-appendix §2 policy 6 (Tourism marketing: Lakeshore +5) | Already Lakeshore | No change; effect now also covers northern-lower tourism employment | No change, but half the "pleased" tourism workers sit in Yoopers — split the +5 or accept the mismatch (Lucas call) |
| numbers-appendix §2 policy 7 (Rural broadband: Yoopers +6, rural Main St +3) | "Yoopers +6" assumed UP + northern lower | Scope to UP: "Yoopers +6 (UP counties); northern-lower build ticks Lakeshore tourism +3 instead" `[G]` | No change |
| numbers-appendix §2 policies 11, 12 (PFAS, shoreline: Lakeshore +7/+6) | Already Lakeshore | No change | No change |
| numbers-appendix §5 faction floor | Secession-chain example cites "Yoopers" | No change (chain stays Yoopers) | Rewrite example: chain unlocks on UP-identity demand neglect specifically |
| numbers-appendix §6 shares | Lakeshore 11%, Yoopers 10% (Yoopers includes northern lower) | Re-split: Lakeshore ~14%, Yoopers ~7% `[G]` (northern-lower tourism moves; total still 100; exact split for Lucas — see Q1) | No change |
| legislature-decision Part B (B1 weights) | Weights computed from 11/10 split | Recompute B1 from new base shares at lock (mechanism unchanged; Main Street stays ×1.3) | No change |
| coupling-spec §4.4 shares audit | Recites 11/10 split for sampling audit | Update recited shares to match new appendix §6 | No change |
| coupling-spec §4.3 UP floor (800 lens, noise guard) | UP small-stratum rule | No change to the rule; revisit the 800 figure vs. the smaller Yoopers share (open ambiguity 12 already asks Lucas — add the (a)-adjusted lens count to that question) | No change |
| coupling-spec open ambiguity 7 (Traverse vs Flint rents) | Mentions Traverse City only as a CoL example | No change (orthogonal) | No change |
| political-capital visit verb | "+3 approval to one faction in the visited region" | Clarify: a North-region visit targets Lakeshore (tourism), not Yoopers; Yoopers visits only in the UP | No change (North-region visit may target Yoopers; specify which half the +3 lands on — rotation-aware) |
| ROADMAP-1.0.md Phase 3 item | "Remaining four regions: (West/Lakeshore, Central, North, UP…)" venue sets | No change (regions ≠ factions; North dioramas now stage Lakeshore tourism faces — note for Phase 3, not a roadmap edit) | No change |

---

## Direct questions for Lucas (one sentence each)

> **DRAFT-NEEDS-Lucas-REVIEW**

1. Confirm (a) the Lakeshore-orbit split over (b) demand rotation — or say "do (b)" and the rotation rule becomes the spec?
2. Under (a), approve the re-split Lakeshore ~14% / Yoopers ~7% `[G]`, or name your own two numbers?
3. Keep the faction name "Up North/Yoopers" for a UP-only faction, or shorten it to "Yoopers"?
4. Under (a), should UP tourism workers (Pictured Rocks guides, ski staff) stay Lakeshore per rule N1, or stay Yoopers with their neighbors?
5. Rural broadband in northern-lower counties: Lakeshore tourism +3 per this doc, or keep some Yoopers approval there?

---

*Locked scope (recited, not decided): Windows + Linux only (macOS cut); Steam Deck is the perf bar; $24.99 premium; mouse-first PC. P1 win condition undecided — nothing above assumes any win shape. Verify test re-checked: Traverse City bartenders root for Lakeshore — crisp.*

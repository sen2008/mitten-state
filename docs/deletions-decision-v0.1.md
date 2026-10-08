# Deletions Decision v0.1 (Phase 0, P12)

**DRAFT-NEEDS-LUCAS-REVIEW — paper only. No game code, no engine change, no GDD edit, no roadmap edit. Verbatim-ready GDD §18 + §22 edits for Lucas to apply at lock.**

**Flags:** `[G]` = taken directly from GDD / roadmap / a sibling v0.1 doc, with source named. `[NEEDS-P1]` = assumes the undecided win condition — appears nowhere as fact in this doc. `[NEEDS-LANG]` = language-dependent note; the LANG spike decides, this doc does not.

**Sources:** review P12, 2.16, 3.4.5–3.4.6, 3.5; ROADMAP Phase 0 item 11 + Phase 3 item 10 + Phase 5 post-launch stub + cut list + Decisions log (MAC, LANG — no P12 row; P12 lives in the placement map) + P12 placement-map row; GDD §18–§19, §22; all nine sibling v0.1 docs.

**Adopted (not decided):** cut #1 DELETED / cut #2 DEFERRED post-1.0 (roadmap + m1-rescope); ironman = single autosave slot, no manual saves, restricts saves never pause (time-scale §7); quarterly autosave + save-on-quit + manual saves as the cadence the checkbox restricts; perf-bar ownership handoff of both bullets; Windows + Linux only.

---

## 1. GDD hit inventory — every mention, exact locations — DRAFT-NEEDS-LUCAS-REVIEW

Full-text search of `docs/MITTEN-STATE-GDD-v0.1.md` for multiplayer/co-op/netcode, JSON modding / public modding schema / data-driven internals, and ironman returns exactly THREE hits — quoted verbatim below with section and bullet. Negative results (zero hits): `co-op`, `coop`, `netcode`, `multi-player`, `network` (only highway/infrastructure networks, §§3–4, §9 — not netcode), `online`, `public schema`, `data-driven`, `mod` outside the Modding bullet. Adjacent but NOT modding promises (examined, excluded): §19 "Your State" DLC concept and §20 "DLC states later" — first-party DLC sharing the internal pipeline, not a public schema.

**Hit 1 — multiplayer tease, GDD §22 (Risks & open questions), final bullet, the `Open:` line:**

> `- **Open:** C# vs GDScript; exact day-length tuning; whether "compare your state with a friend's" multiplayer has any legs (post-launch thought only).`

The tease is the trailing clause after the second semicolon. The `C# vs GDScript` open belongs to the LANG spike (Phase 0 item 12) and `exact day-length tuning` to P4 — both live opens, untouched by this doc. Only the multiplayer clause is deleted (§2a).

**Hit 2 — modding, GDD §18 (Tech architecture), Modding bullet:**

> `- **Modding:** policies and events defined in data files (JSON) so the community can add their own state — and the "your state" DLC concept (§19) shares the pipeline.`

This is the only JSON/data-files sentence in the GDD. It promises community authoring via an implied public schema — the promise review 2.16 (full effect-expression language + sim hooks, a real subsystem) and 3.4.5 (defer; ship data-driven internals without promising a public schema) say 1.0 must not make. Replaced by the deferral text (§2b).

**Hit 3 — ironman, GDD §18 (Tech architecture), Saves bullet:**

> `- **Saves:** full state serialization; optional ironman mode.`

The only ironman mention in the GDD. `full state serialization` is the full-save/load wording Phase 3 work item 10 builds against — it stays verbatim (§2c). `optional ironman mode` becomes the no-deliberation checkbox shape per review P12 ("it's a checkbox, not a design question; just ship the toggle").

## 2. Verbatim-ready GDD edit blocks — DRAFT-NEEDS-LUCAS-REVIEW

Apply at lock by string match against the Hit 1–3 quotes above. Three edits, no other GDD line touched.

**(a) Multiplayer deletion — REMOVE the tease clause from the §22 `Open:` bullet.** Delete exactly `; whether "compare your state with a friend's" multiplayer has any legs (post-launch thought only)` (leading semicolon included), leaving a bullet with the two live opens intact:

> - **Open:** C# vs GDScript; exact day-length tuning.

Deleted, not parked `[G per review 3.5 + roadmap cut #1]` — no "post-launch thought" pointer survives anywhere in the GDD. Netcode/multiplayer/co-op count in the GDD after this edit: zero.

**(b) Modding deferral — REPLACE the §18 Modding bullet in full with:**

> - **Modding:** policies, events, and faction demands ship as internal data files (JSON) so content stays data-driven — but NO public modding schema is promised for 1.0. Community modding and any public effect schema are publicly deferred to post-1.0 (cut #2); the "your state" DLC concept (§19) shares the internal pipeline only.

Internals data-driven, promise unmade `[G per review 2.16 + 3.4.5 + roadmap cut #2 + Phase 5 post-launch stub ("JSON modding stays deferred")]`. The JSON format stays an internal implementation choice, never a documented community contract.

**(c) Ironman checkbox — REPLACE the §18 Saves bullet in full with:**

> - **Saves:** full state serialization; ironman mode as a plain checkbox — a new-game option plus a settings-screen toggle (single autosave slot, no manual saves; restricts saves only, never pause). No deliberation, no design debate; built in Phase 3 work item 10.

Shape notes (not GDD text): the `full state serialization` clause is UNCHANGED from v0.1 and stays as-is as the wording Phase 3 builds full save/load against. The parenthesized behavior is `[G per time-scale §7]` (same quarterly-autosave cadence, single slot, saves-never-pause) — adopted, not invented. This doc specifies ONLY the no-deliberation shape (checkbox surface + stated behavior); all implementation is Phase 3 work item 10 ("Full save/load + ironman toggle (P12: just ship it)") with its exit test (ironman + saves survive a full term, round-trip test each game-year).

Why this shape `[G per review P12 + roadmap Phase 0 item 11]`: the tease and the schema promise cost design attention every milestone while contributing nothing to 1.0, and ironman deliberation is a checkbox, not a design question.

## 3. Consistency checklist vs all nine siblings — DRAFT-NEEDS-LUCAS-REVIEW

| Sibling | Took | Breaks if it changes |
|---|---|---|
| numbers-appendix | The data-driven content inventory — 12 M0 policies with P8 precursors (§2), demand cadence/stakes (§4), thresholds (§5), election formula (§6) — as internals that ship as data files; dollar-scale lines (§7) stay internal tuning, never a public schema | appendix promises a public JSON effect schema (review 2.16's expression language) or adds multiplayer-synced numbers (shared pools, cross-game comparison) — either re-opens the deferral/deletion this doc locks |
| coupling-spec | Single-player deterministic placement (firms post aggregate events, daily pass drains, orphan count = 0, §1.1); event_id/cause_code chain as an internal log shape, never a public modding API; open ambiguity 15 (save format preserves the id counter) as the save-law constraint Phase 3 item 10 builds against | placement gains a netcode/multiplayer sync requirement (§5 tick budget recomputed, orphan audit redefined across peers); event/cause shape promoted to a public modding contract |
| time-scale | Ironman save-cadence shape — quarterly autosave + save-on-quit + manual saves, ironman = same cadence, single autosave slot, no manual saves — plus the hard rule ironman restricts saves, never pause (§7); adopted verbatim into §2c | save cadence changes (new autosave rhythm redefines what the single slot means); ironman gains a pause restriction or any non-save effect (re-opens the deliberation P12 forbids) |
| political-capital | Four PC spends (visit 5 / buyout-extend 15 / fast-track 20 / emergency 30) as data-file content, not code constants — part of the data-driven internals; quarterly income with no trickle as single-player pacing, no shared pool | a fifth vote-buying spend or any multiplayer-shared PC pool (PC becomes cross-game state, §2a collapses); PC effects promoted to a public modding expression language |
| legislature | (a) abstraction = zero legislature object, no passage gate, no legislature cause type; B6–B7 narrow-loss/sandbox-continue + multi-term carry rules (treasury/debt/condition carried, PC reset to 30, timers reset) as the single-player continuation ironman must preserve | flip to (b) override-vote adds a passage gate the checkbox spec must cover; sandbox-continue eligibility tied to a compare-with-friends leaderboard (multiplayer by another name) |
| north-fix | (a) RECOMMENDED membership redraw (N1–N3 spawn-time rules) + demand/event routing (Lakeshore vs Yoopers) as data-file content — faction routing addressed internally, never a public membership API; Detroit-transit row fix as authored content | flip to (b) rotation-aware demands changes the internal data shape (still not public); faction membership opened as a moddable public schema (voids §2b) |
| m1-rescope | Locked-scope recital lines (multiplayer deleted-not-parked; no public JSON schema with data-driven internals; ironman checkbox) + re-ordered cut list #1–#2 (DELETED / DEFERRED post-1.0); this doc is the GDD-edit execution of that cut list | cut #1 un-deleted (any multiplayer/co-op/compare mode re-admitted for 1.0 voids §2a); cut #2 promise made (any public schema commitment voids §2b); slice-count/diorama changes do NOT break this doc |
| attribution-ui | Sim logging contract as internal-only (FirmEvent + causal record, approval ledger, policy lifecycle, moment queue, lens tags, §8) with orphan-zero validation; honesty rules (S_SE face caps) assume a local single-player sim | logging promoted to a public modding surface (external consumers freeze the internal shape); any multiplayer-shared ledger/feed (every cause link + the orphan audit go cross-peer) |
| perf-bar | Ownership handoff — perf-bar §1 intentionally left the Saves (ironman) + Modding bullets untouched as owned by P12 item 11; this doc accepts both; single-player tick budget (decoupled fixed-cadence sim, ≥2x headroom) with no netcode line | perf-bar claims either bullet (ownership collision — two verbatim texts for one bullet); a multiplayer tick-cost line added to the budget (voids §2a) |

## 4. Hooks: P1-open + language-independent — DRAFT-NEEDS-LUCAS-REVIEW

`[NEEDS-P1]` — this doc assumes nothing about the undecided win condition and holds under ANY P1 outcome: no win shape needs multiplayer, a public modding schema, or a debated ironman, so no P1 resolution can re-open §2. Win-progress framing (leaderboard-as-progress, legacy lines, sandbox-continue eligibility) waits on Lucas; the Midwest-crown default proposal is unconfirmed and assumed nowhere in this doc — it appears in this sentence only as a pending proposal, never as fact.

`[NEEDS-LANG]` — this doc is language-independent: a deleted clause, a deferral paragraph, and a checkbox toggle need no language choice. The Phase 0 item 12 spike (C# vs GDScript, 5k-agent tick benchmark) decides the language; this doc pre-decides nothing. JSON data files stay an internal file-format choice under any LANG outcome — a format, not a runtime pick.

## 5. Verify test — DRAFT-NEEDS-LUCAS-REVIEW

A fresh agent with no prior context must be able to lift the three §2 edit blocks by string match against the §1 quotes and apply them to GDD §§18/22 without inventing a word — checking that the multiplayer clause is gone with both live opens intact, the Modding bullet carries the no-public-schema deferral, and the Saves bullet keeps `full state serialization` verbatim beside the checkbox shape — and then confirm zero new promises (no schema, no netcode, no ironman design) by re-running the §1 search and finding only the two surviving bullets plus the shortened `Open:` line.

## 6. Direct questions for Lucas — DRAFT-NEEDS-LUCAS-REVIEW

1. Confirm the multiplayer clause deletion as written — or keep a "post-launch thought" pointer somewhere outside the GDD?
2. Confirm the Modding-bullet deferral wording — or soften/harden the public "no schema for 1.0" line?
3. Confirm ironman = new-game checkbox + settings toggle with time-scale §7 behavior — or settings-only?
4. Should the Steam page / Phase 5 post-launch stub carry the "modding deferred" line verbatim from §2b?
5. Apply all three §2 blocks at lock as written — or does any of them overstep paper-only?

Locked scope (recited once): Windows + Linux only, Steam Deck is the perf bar, $24.99 premium, mouse-first.

**DRAFT-NEEDS-LUCAS-REVIEW — end of v0.1.**

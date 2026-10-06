# Mitten State

**Mitten State** — a peaceful stewardship sim where you govern Michigan. Every policy has a face.

You are the Governor. No armies, no conquest — the map ends at the state line.
You govern ~10 million people through policy, budgets, and edicts, and you can
zoom from the statehouse all the way down to watch any single citizen live
their day. Win re-election, keep the state solvent, balance six rival factions,
and chase the ultimate prize: the Midwest crown — before everyone moves to
Ohio. (Campaign win condition under review: see design review §5, P1.)

*Tropico meets RollerCoaster Tycoon, set in real Michigan, with no war —
just 10 million people counting on you.*

- **Engine:** Godot 4 (C# vs GDScript decision still open — see GDD §18)
- **Platform:** PC via Steam, mouse-first, $24.99 premium
- **Stage:** pre-production — GDD v0.1 (concept draft, not locked)

## Repo layout

```text
mitten-state/
├── README.md
├── .gitignore
├── docs/
│   ├── MITTEN-STATE-GDD-v0.1.md      # Game design document, v0.1 concept draft
│   └── design-review-muse-code.md  # Design review: holes, gaps, scope check
└── maps/
    ├── mi-highways.svg               # Public-domain MI highway map (FHWA/Census GIS via Wikimedia Commons)
    ├── mi-highways-preview.png       # Rendered preview
    ├── mitten-state-geo.json         # Machine-readable geo pack: 30 cities, 9 highways, bridge, 5 regions
    └── README.md                     # Provenance + Godot usage notes
```

## Current status

- [x] GDD v0.1 — high concept, pillars, factions, sim layers, policy catalog,
      milestones M0–M4 (`docs/MITTEN-STATE-GDD-v0.1.md`)
- [x] Design review — 11 contradictions, 16 under-specified systems,
      scope reality check, 12 prioritized revisions (`docs/design-review-muse-code.md`)
- [x] Geography reference pack — Michigan highway map (`maps/`)
- [ ] P1: replace the #1-GDP win condition (unachievable as written)
- [ ] P2: numbers appendix (starting budget, costs, rates, thresholds)
- [ ] M0: headless sim prototype — 5k citizens, one region, budget + 10 policies

See the GDD (§21) for the full milestone plan and the design review (§5)
for the prioritized revision list.

## License

TBD.

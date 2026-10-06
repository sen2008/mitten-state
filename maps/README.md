# Mitten State geography pack

`mitten-state-geo.json` is the map-data source of truth for the Michigan
state-simulation game. One file, four sections: `cities` (30),
`highways` (9 polylines), `mackinac_bridge`, `regions` (5).

## Provenance

- Every latitude/longitude was read from the English Wikipedia
  coordinates API (`en.wikipedia.org/w/api.php`, `prop=coordinates`)
  on 2026-10-06 and rounded to 4 decimals. No coordinate was guessed.
- Each coordinate carries `coord_status`: `verified` (Wikipedia-backed)
  or `verify` (untrusted, needs a check). **Current file: all entries
  are `verified`; there are zero `verify` flags.**
- Populations are approximate 2020-census-rounded gameplay values, not
  Wikipedia-verified. Tune freely for balance.
- Region county lists use real Michigan county names and partition all
  83 counties with no overlaps. Bounding boxes are rough gameplay
  guides and may overlap at edges; the county list is authoritative
  for region membership.
- Mackinac Bridge landings reuse the verified Mackinaw City / St. Ignace
  city centers (true anchorages are ~1-3 km toward mid-bridge, negligible
  at game scale). Bridge center is the verified Mackinac Bridge article
  coordinate.

## How a Godot 4 coding agent should use it

1. Load once at startup:
   `JSON.parse_string(FileAccess.get_file_as_string("res://maps/mitten-state-geo.json"))`.
2. Project lon/lat to map space with a simple equirectangular projection:
   pick a map rect, map lon linearly to X and lat linearly to Y (flip Y).
   Relative positions are accurate; decimal precision beyond 4 places was
   intentionally discarded.
3. Cities: spawn one Node2D marker per entry. Use `region` for coloring /
   grouping, `population` for city size tiers, `economy` for flavor text
   and industry bonuses (auto plants, mining, tourism, ports, chemicals).
4. Highways: draw each `waypoints` array as a Line2D polyline through the
   projected points. I-75 is the main north-south spine and the only road
   crossing the straits (via the bridge waypoints). Out-of-state anchors
   (Toledo OH, Indiana/Ohio-line towns) exist only to position state-line
   ends; label or fade them as off-map.
5. Bridge: draw `south_endpoint -> center -> north_endpoint` as a distinct
   toll link. Gameplay suggestion: it is the only North/Up North <->
   Upper Peninsula road connection; closing or tolling it should split
   the freight graph.
6. Regions: use `regions[].counties` for county-to-region lookup and
   `bbox` only for camera framing / minimap labels, never for membership.
7. If you ever see `coord_status: "verify"` with null coordinates (none
   today), do not place that feature from this file; look up and patch the
   coordinate first.

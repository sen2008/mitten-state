# Mitten State — County Disaggregation Table v0.1 (B1 resolution)

**DRAFT-NEEDS-Lucas-REVIEW** — paper only. No game code may treat any value here as final.

Resolves audit v0.2 item **B1** per its §3 resolution proposal: an 83-county table with census populations, labor force, county-sector employment, and uniform starting conditions. Basis is the v0.2 proposal (uniform statewide sector mix, uniform starts); no different scheme invented.

> **Census values need Lucas's confirm.** Every population below is a realistic 2020-census-magnitude **game input**, NOT a claimed-as-verified figure. Labor force and sector employment are derived, not observed.

**Flag legend:** `[R?]` = realistic 2020 magnitude, unverified in this draft — confirm against census tables before lock. `[G]` = gameplay placeholder: uniform default, tunable in Phase 3–4 balance.

---

## 0. Derivation rules (applied identically to all 83 counties)

1. `census_pop` `[R?]` — realistic 2020-census-magnitude game input per county (see header warning).
2. `labor_force = round(census_pop × 0.62)` `[G]` — 62% participation rule per v0.2 B1 proposal.
3. `unemployment_rate = 5.0%` `[G]` — uniform placeholder (natural rate per appendix §6 / coupling §2.1).
4. `wage_index = 100` `[G]` — uniform start per coupling §2.1 (county gaps emerge endogenously).
5. `roads_c = 45` `[G]` — uniform 'rough' start per appendix §0 / coupling §3.2.
6. Sector list = the six coupling §1.1 industries `[G]` with fixed statewide shares summing to 100%: auto/mfg 22%, knowledge/health 32%, tourism/leisure 14%, logistics 18%, agriculture 12%, mining/timber 2%.
7. `employment(sector) = round(labor_force × share × (1 − 0.05))` — employed = 95% of labor force at the 5.0% placeholder rate, split by the §6 shares. Row sums may differ from labor_force × 0.95 by ±3 from rounding.
8. M0 is SE-only, but this table is the Phase 1 input for **all** counties: every county gets its own row (SE fully expanded; other regions one compact row each with identical fields).

Region grouping: Southeast/Motor = the 12 counties named in `maps/mitten-state-geo.json`. Coupling §4.1/§4.2 state only the SE aggregate and the UP sampling rule, so the four beyond-SE groupings follow the geo file's region scheme as a **draft proposal** (needs-Lucas #3). Region geography itself is unchanged by the north-fix decision (faction routing ≠ geography).

---

## 1. Southeast/Motor — individually specified (M0 scope)

| County | Census pop `[R?]` | Labor force | Unemp. | Wage idx | Roads_c | Auto/mfg | Know/health | Tour/leis | Logistics | Agric | Min/timb |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Wayne | 1,793,561 | 1,112,008 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 232,410 | 338,050 | 147,897 | 190,153 | 126,769 | 21,128 |
| Oakland | 1,274,395 | 790,125 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 165,136 | 240,198 | 105,087 | 135,111 | 90,074 | 15,012 |
| Macomb | 881,217 | 546,355 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 114,188 | 166,092 | 72,665 | 93,427 | 62,284 | 10,381 |
| Genesee | 406,211 | 251,851 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 52,637 | 76,563 | 33,496 | 43,067 | 28,711 | 4,785 |
| Washtenaw | 372,258 | 230,800 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 48,237 | 70,163 | 30,696 | 39,467 | 26,311 | 4,385 |
| Livingston | 193,866 | 120,197 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 25,121 | 36,540 | 15,986 | 20,554 | 13,702 | 2,284 |
| St. Clair | 160,927 | 99,775 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 20,853 | 30,332 | 13,270 | 17,062 | 11,374 | 1,896 |
| Jackson | 160,005 | 99,203 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 20,733 | 30,158 | 13,194 | 16,964 | 11,309 | 1,885 |
| Monroe | 154,270 | 95,647 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 19,990 | 29,077 | 12,721 | 16,356 | 10,904 | 1,817 |
| Lenawee | 98,571 | 61,114 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 12,773 | 18,579 | 8,128 | 10,450 | 6,967 | 1,161 |
| Lapeer | 88,319 | 54,758 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 11,444 | 16,646 | 7,283 | 9,364 | 6,242 | 1,040 |
| Hillsdale | 45,849 | 28,426 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 5,941 | 8,642 | 3,781 | 4,861 | 3,241 | 540 |

SE subtotal: pop 5,629,449 `[R?]`, labor force 3,490,259 (derived).

---

## 2. Rest of state — compact per-county rows (Phase 1 input, identical fields)

Sector-employment column order (fixed): auto/mfg / know-health / tour-leis / logistics / agric / min-timb (rule §7).

| Region | County | Census pop `[R?]` | Labor force | Unemp. | Wage idx | Roads_c | Sector employment (6 values, rule §7) |
|---|---|---|---|---|---|---|---|
| W/Lakeshore | Kent | 657,974 | 407,944 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 85,260 / 124,015 / 54,257 / 69,758 / 46,506 / 7,751 |
| W/Lakeshore | Ottawa | 296,200 | 183,644 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 38,382 / 55,828 / 24,425 / 31,403 / 20,935 / 3,489 |
| W/Lakeshore | Kalamazoo | 265,066 | 164,341 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 34,347 / 49,960 / 21,857 / 28,102 / 18,735 / 3,122 |
| W/Lakeshore | Muskegon | 175,824 | 109,011 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 22,783 / 33,139 / 14,498 / 18,641 / 12,427 / 2,071 |
| W/Lakeshore | Berrien | 154,316 | 95,676 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 19,996 / 29,086 / 12,725 / 16,361 / 10,907 / 1,818 |
| W/Lakeshore | Calhoun | 134,310 | 83,272 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 17,404 / 25,315 / 11,075 / 14,240 / 9,493 / 1,582 |
| W/Lakeshore | Allegan | 120,502 | 74,711 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 15,615 / 22,712 / 9,937 / 12,776 / 8,517 / 1,420 |
| W/Lakeshore | Van Buren | 75,587 | 46,864 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 9,795 / 14,247 / 6,233 / 8,014 / 5,342 / 890 |
| W/Lakeshore | Ionia | 66,804 | 41,418 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 8,656 / 12,591 / 5,509 / 7,082 / 4,722 / 787 |
| W/Lakeshore | Barry | 62,423 | 38,702 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 8,089 / 11,765 / 5,147 / 6,618 / 4,412 / 735 |
| W/Lakeshore | St. Joseph | 60,939 | 37,782 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 7,896 / 11,486 / 5,025 / 6,461 / 4,307 / 718 |
| W/Lakeshore | Cass | 51,589 | 31,985 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 6,685 / 9,723 / 4,254 / 5,469 / 3,646 / 608 |
| W/Lakeshore | Newaygo | 49,978 | 30,986 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 6,476 / 9,420 / 4,121 / 5,299 / 3,532 / 589 |
| W/Lakeshore | Branch | 44,862 | 27,814 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 5,813 / 8,455 / 3,699 / 4,756 / 3,171 / 528 |
| W/Lakeshore | Oceana | 26,659 | 16,529 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,455 / 5,025 / 2,198 / 2,826 / 1,884 / 314 |
| Central | Ingham | 284,400 | 176,328 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 36,853 / 53,604 / 23,452 / 30,152 / 20,101 / 3,350 |
| Central | Saginaw | 190,124 | 117,877 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 24,636 / 35,835 / 15,678 / 20,157 / 13,438 / 2,240 |
| Central | Eaton | 109,297 | 67,764 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 14,163 / 20,600 / 9,013 / 11,588 / 7,725 / 1,288 |
| Central | Bay | 103,856 | 64,391 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 13,458 / 19,575 / 8,564 / 11,011 / 7,341 / 1,223 |
| Central | Midland | 83,874 | 52,002 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 10,868 / 15,809 / 6,916 / 8,892 / 5,928 / 988 |
| Central | Clinton | 79,128 | 49,059 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 10,253 / 14,914 / 6,525 / 8,389 / 5,593 / 932 |
| Central | Shiawassee | 68,094 | 42,218 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 8,824 / 12,834 / 5,615 / 7,219 / 4,813 / 802 |
| Central | Montcalm | 66,614 | 41,301 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 8,632 / 12,556 / 5,493 / 7,062 / 4,708 / 785 |
| Central | Isabella | 64,394 | 39,924 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 8,344 / 12,137 / 5,310 / 6,827 / 4,551 / 759 |
| Central | Gratiot | 41,761 | 25,892 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 5,411 / 7,871 / 3,444 / 4,428 / 2,952 / 492 |
| Central | Mecosta | 39,714 | 24,623 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 5,146 / 7,485 / 3,275 / 4,211 / 2,807 / 468 |
| Central | Tuscola | 53,323 | 33,060 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 6,910 / 10,050 / 4,397 / 5,653 / 3,769 / 628 |
| Central | Sanilac | 40,611 | 25,179 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 5,262 / 7,654 / 3,349 / 4,306 / 2,870 / 478 |
| Central | Huron | 31,407 | 19,472 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 4,070 / 5,919 / 2,590 / 3,330 / 2,220 / 370 |
| North | Grand Traverse | 95,238 | 59,048 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 12,341 / 17,951 / 7,853 / 10,097 / 6,731 / 1,122 |
| North | Emmet | 35,552 | 22,042 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 4,607 / 6,701 / 2,932 / 3,769 / 2,513 / 419 |
| North | Wexford | 33,673 | 20,877 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 4,363 / 6,347 / 2,777 / 3,570 / 2,380 / 397 |
| North | Clare | 30,856 | 19,131 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,998 / 5,816 / 2,544 / 3,271 / 2,181 / 363 |
| North | Mason | 29,052 | 18,012 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,765 / 5,476 / 2,396 / 3,080 / 2,053 / 342 |
| North | Alpena | 28,749 | 17,824 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,725 / 5,418 / 2,371 / 3,048 / 2,032 / 339 |
| North | Charlevoix | 26,090 | 16,176 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,381 / 4,918 / 2,151 / 2,766 / 1,844 / 307 |
| North | Cheboygan | 25,579 | 15,859 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,315 / 4,821 / 2,109 / 2,712 / 1,808 / 301 |
| North | Gladwin | 25,386 | 15,739 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,289 / 4,785 / 2,093 / 2,691 / 1,794 / 299 |
| North | Iosco | 25,237 | 15,647 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,270 / 4,757 / 2,081 / 2,676 / 1,784 / 297 |
| North | Otsego | 25,091 | 15,556 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,251 / 4,729 / 2,069 / 2,660 / 1,773 / 296 |
| North | Manistee | 25,032 | 15,520 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,244 / 4,718 / 2,064 / 2,654 / 1,769 / 295 |
| North | Antrim | 23,431 | 14,527 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,036 / 4,416 / 1,932 / 2,484 / 1,656 / 276 |
| North | Roscommon | 23,459 | 14,545 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,040 / 4,422 / 1,934 / 2,487 / 1,658 / 276 |
| North | Osceola | 23,556 | 14,605 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,052 / 4,440 / 1,942 / 2,497 / 1,665 / 277 |
| North | Leelanau | 22,301 | 13,827 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 2,890 / 4,203 / 1,839 / 2,364 / 1,576 / 263 |
| North | Ogemaw | 20,770 | 12,877 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 2,691 / 3,915 / 1,713 / 2,202 / 1,468 / 245 |
| North | Benzie | 17,970 | 11,141 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 2,328 / 3,387 / 1,482 / 1,905 / 1,270 / 212 |
| North | Kalkaska | 17,939 | 11,122 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 2,324 / 3,381 / 1,479 / 1,902 / 1,268 / 211 |
| North | Arenac | 15,002 | 9,301 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,944 / 2,828 / 1,237 / 1,590 / 1,060 / 177 |
| North | Missaukee | 15,052 | 9,332 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,950 / 2,837 / 1,241 / 1,596 / 1,064 / 177 |
| North | Presque Isle | 12,982 | 8,049 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,682 / 2,447 / 1,071 / 1,376 / 918 / 153 |
| North | Crawford | 12,988 | 8,053 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,683 / 2,448 / 1,071 / 1,377 / 918 / 153 |
| North | Lake | 12,096 | 7,500 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,568 / 2,280 / 998 / 1,282 / 855 / 142 |
| North | Alcona | 10,167 | 6,304 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,318 / 1,916 / 838 / 1,078 / 719 / 120 |
| North | Montmorency | 9,153 | 5,675 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,186 / 1,725 / 755 / 970 / 647 / 108 |
| North | Oscoda | 8,219 | 5,096 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,065 / 1,549 / 678 / 871 / 581 / 97 |
| UP | Marquette | 66,017 | 40,931 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 8,555 / 12,443 / 5,444 / 6,999 / 4,666 / 778 |
| UP | Houghton | 37,361 | 23,164 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 4,841 / 7,042 / 3,081 / 3,961 / 2,641 / 440 |
| UP | Delta | 36,903 | 22,880 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 4,782 / 6,956 / 3,043 / 3,912 / 2,608 / 435 |
| UP | Chippewa | 36,785 | 22,807 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 4,767 / 6,933 / 3,033 / 3,900 / 2,600 / 433 |
| UP | Dickinson | 28,763 | 17,833 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,727 / 5,421 / 2,372 / 3,049 / 2,033 / 339 |
| UP | Menominee | 23,502 | 14,571 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 3,045 / 4,430 / 1,938 / 2,492 / 1,661 / 277 |
| UP | Gogebic | 14,380 | 8,916 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,863 / 2,710 / 1,186 / 1,525 / 1,016 / 169 |
| UP | Iron | 11,631 | 7,211 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,507 / 2,192 / 959 / 1,233 / 822 / 137 |
| UP | Mackinac | 10,834 | 6,717 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,404 / 2,042 / 893 / 1,149 / 766 / 128 |
| UP | Alger | 8,842 | 5,482 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,146 / 1,667 / 729 / 937 / 625 / 104 |
| UP | Baraga | 8,158 | 5,058 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,057 / 1,538 / 673 / 865 / 577 / 96 |
| UP | Schoolcraft | 8,047 | 4,989 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 1,043 / 1,517 / 664 / 853 / 569 / 95 |
| UP | Ontonagon | 5,816 | 3,606 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 754 / 1,096 / 480 / 617 / 411 / 69 |
| UP | Luce | 5,339 | 3,310 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 692 / 1,006 / 440 / 566 / 377 / 63 |
| UP | Keweenaw | 2,046 | 1,269 | 5.0% `[G]` | 100 `[G]` | 45 `[G]` | 265 / 386 / 169 / 217 / 145 / 24 |

---

## 3. Checksum

| Check | Value | Verdict |
|---|---|---|
| Counties listed | 83 (12 + 15 + 14 + 27 + 15) | ✓ matches Michigan's 83 counties |
| Southeast/Motor: pop / labor | 5,629,449 / 3,490,259 | — |
| West/Lakeshore: pop / labor | 2,243,033 / 1,390,679 | — |
| Central/Growers: pop / labor | 1,256,597 / 779,090 | — |
| North/Up North: pop / labor | 650,620 / 403,385 | — |
| Upper Peninsula: pop / labor | 304,424 / 188,744 | — |
| **State total pop** | **10,084,123** | vs 2020 census 10,077,331: +6,792 (+0.07%) — rounding-level, honest fit |
| **SE total pop** | **5,629,449** | vs coupling §4.1 ~5.0M: +629,449 (+12.6%) — **MISMATCH, not forced** (see below) |
| State labor force (derived) | 6,252,157 | = round per-county, not round(state × 0.62) |

**SE mismatch, stated plainly:** realistic 2020 magnitudes for the 12 geo-file SE counties sum to 5,629,449 (≈5.63M), about 13% above coupling §4.1's ~5.0M Southeast ('roughly half of ~10M'). This draft does NOT force the sum to 5.0M. Lucas call at lock: (a) keep real magnitudes and restate §4.1 (~5.6M SE, S_SE recomputed), or (b) stamp 5.0M as a game abstraction and scale SE counties down ~11%. Until he picks, S_SE ≈ 1,000 is inconsistent with these pops by the same ~11%.

---

## 4. Needs-Lucas list (decisions only he can make)

1. **Census confirm:** verify/replace all 83 `[R?]` populations against census tables; the state total and SE subtotal above recompute automatically.
2. **Sector shares:** the uniform 22/32/14/18/12/2 mix is `[G]` and deliberately flat — approve, or set region-differentiated mixes (e.g. more mining/timber in the UP, more auto/mfg in SE).
3. **Region grouping beyond SE:** only SE membership is authoritative (geo file); the four other groupings are a draft proposal carried over from the geo file — confirm or redraw.
4. **SE-vs-5.0M call:** keep real magnitudes (restate coupling §4.1) or stamp 5.0M as abstraction (scale SE down).
5. Uniform starts are placeholders: unemployment 5.0%, wage index 100, roads_c 45, 62% participation — confirm each or supply county-varying values for Phase 3+.

*End of v0.1. Out of scope by design: B2–B14, the P1 win condition, and all other Lucas-pending items are untouched.*

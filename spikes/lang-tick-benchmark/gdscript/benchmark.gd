# Mitten State LANG spike — GDScript tick benchmark (idiomatic perf style).
#
# Same workload as ../csharp/Program.cs, same statement order, same seeded RNG
# (xorshift32 reimplemented — Godot has no matching stream), same FNV-1a
# checksum over the same quantized state. Hot state is struct-of-arrays in
# Packed*Array with typed locals; growable queues (firm rosters, unemployed
# pool) are plain Arrays for by-reference mutation semantics.
#
# One "tick" = one in-game day (time-scale-decision-v0.1): daily macro
# aggregation + citizens x 5 beats + daily firm updates + one K-event
# placement pass. See ../README.md for methodology.
#
# Usage:
#   godot --headless --script benchmark.gd -- --n=5000 --m=500 --k=20 --ticks=10 --reps=5 --warmup=1 --seed=12345
extends SceneTree

const COUNTIES: int = 83
const BEATS: int = 5
const SECTOR_MULT: PackedFloat64Array = [1.10, 1.15, 0.85, 0.80, 1.25, 0.95]
const ROAD_MULT: float = 1.44
const LOGISTICS: float = 1.165
const WEEKLY_PAY: float = 900.0
const COL_PER_MONTH: float = 1714.0
const CORP_RATE: float = 0.06
const QUEUE_CAP: int = 4096

var N: int = 5000
var M: int = 500
var K: int = 20

var _rng: int = 12345

var c_money := PackedFloat64Array()
var c_rest := PackedFloat64Array()
var c_health := PackedFloat64Array()
var c_food := PackedFloat64Array()
var c_social := PackedFloat64Array()
var c_purpose := PackedFloat64Array()
var c_commute := PackedFloat64Array()
var c_home := PackedInt32Array()
var c_hh := PackedInt32Array()
var c_employer := PackedInt32Array()
var c_roster_slot := PackedInt32Array()
var c_unemp_slot := PackedInt32Array()
var c_days_unemp := PackedInt32Array()
var c_employed := PackedByteArray()

var h_funds := PackedFloat64Array()

var f_margin := PackedFloat64Array()
var f_headcount := PackedInt32Array()
var f_county := PackedInt32Array()
var f_sector := PackedInt32Array()
var f_streak := PackedInt32Array()
var f_wagedev := PackedFloat64Array()
var f_ent := PackedFloat64Array()
var f_frozen := PackedByteArray()
var f_closed := PackedByteArray()

var wages := PackedFloat64Array()
var county_emp := PackedInt32Array()
var county_pop := PackedInt32Array()

var rosters: Array = []
var unemp: Array = []

var q_kind := PackedInt32Array()
var q_firm := PackedInt32Array()
var q_slots := PackedInt32Array()
var q_head: int = 0
var q_tail: int = 0
var q_count: int = 0

var hires: int = 0
var layoffs: int = 0
var quits: int = 0
var closes: int = 0
var spawns: int = 0
var unfilled: int = 0
var empty_roster: int = 0
var dropped: int = 0
var jobhunt: int = 0
var hungry: int = 0
var tired: int = 0
var sick: int = 0
var lonely: int = 0
var aimless: int = 0
var unrest: int = 0
var protest: int = 0
var cantwork: int = 0
var ledger_debt: float = 8.0e9


func _init() -> void:
	var args: PackedStringArray = OS.get_cmdline_args()
	args.append_array(OS.get_cmdline_user_args())
	N = _arg(args, "n", 5000)
	M = _arg(args, "m", 500)
	K = _arg(args, "k", 20)
	var ticks: int = _arg(args, "ticks", 10)
	var reps: int = _arg(args, "reps", 5)
	var warmup: int = _arg(args, "warmup", 1)
	var seed: int = _arg(args, "seed", 12345)
	if N % 2 != 0:
		print("n must be even")
		quit(2)
		return
	print("lang=gdscript n=%d m=%d k=%d ticks=%d reps=%d warmup=%d seed=%d" % [N, M, K, ticks, reps, warmup, seed])
	print("godot=" + Engine.get_version_info()["string"])
	for w in range(warmup):
		_reset(seed)
		var t0: int = Time.get_ticks_msec()
		for t in range(ticks):
			_tick(t)
		var per: float = float(Time.get_ticks_msec() - t0) / float(ticks)
		print("warmup %d: %.3f ms/tick" % [w, per])
	var times: Array = []
	var last_sum: int = 0
	for r in range(reps):
		_reset(seed)
		var t0: int = Time.get_ticks_msec()
		for t in range(ticks):
			_tick(t)
		var per: float = float(Time.get_ticks_msec() - t0) / float(ticks)
		last_sum = _checksum()
		times.append(per)
		print("rep %d: %.3f ms/tick checksum=%08X" % [r, per, last_sum])
	times.sort()
	var median: float = times[times.size() / 2]
	print("median_ms_per_tick=%.3f" % median)
	_reset(seed)
	for t in range(ticks):
		_tick(t)
	var ca: int = _checksum()
	_reset(seed)
	for t in range(ticks):
		_tick(t)
	var cb: int = _checksum()
	print("determinism: run1=%08X run2=%08X match=%s" % [ca, cb, str(ca == cb)])
	quit(0 if ca == cb else 1)


func _arg(args: PackedStringArray, name: String, dflt: int) -> int:
	var prefix: String = "--" + name + "="
	for a in args:
		if a.begins_with(prefix):
			return int(a.substr(prefix.length()))
	return dflt


func _next_u32() -> int:
	var x: int = _rng
	x = (x ^ ((x << 13) & 0xFFFFFFFF)) & 0xFFFFFFFF
	x = (x ^ (x >> 17)) & 0xFFFFFFFF
	x = (x ^ ((x << 5) & 0xFFFFFFFF)) & 0xFFFFFFFF
	_rng = x
	return x


func _next_float() -> float:
	return float(_next_u32() >> 8) / 16777216.0


func _next_int(n: int) -> int:
	return _next_u32() % n


func _in_shed(a: int, b: int) -> bool:
	var d: int = a - b
	if d < 0:
		d = -d
	return (d % 9) < 6


func _enqueue(kind: int, firm: int, slots: int) -> void:
	if q_count == QUEUE_CAP:
		dropped += 1
		return
	q_kind[q_tail] = kind
	q_firm[q_tail] = firm
	q_slots[q_tail] = slots
	q_tail += 1
	if q_tail == QUEUE_CAP:
		q_tail = 0
	q_count += 1


func _hire(c: int, f: int) -> void:
	var slot: int = c_unemp_slot[c]
	var last: int = unemp[unemp.size() - 1]
	unemp[slot] = last
	c_unemp_slot[last] = slot
	unemp.resize(unemp.size() - 1)
	c_employed[c] = 1
	c_employer[c] = f
	c_days_unemp[c] = 0
	var r: Array = rosters[f]
	c_roster_slot[c] = r.size()
	r.append(c)
	hires += 1


func _layoff(c: int) -> void:
	var f: int = c_employer[c]
	var slot: int = c_roster_slot[c]
	var r: Array = rosters[f]
	var last: int = r[r.size() - 1]
	r[slot] = last
	c_roster_slot[last] = slot
	r.resize(r.size() - 1)
	c_employed[c] = 0
	c_employer[c] = -1
	c_days_unemp[c] = 0
	c_unemp_slot[c] = unemp.size()
	unemp.append(c)
	layoffs += 1


func _reset(seed: int) -> void:
	_rng = seed
	c_money.resize(N)
	c_rest.resize(N)
	c_health.resize(N)
	c_food.resize(N)
	c_social.resize(N)
	c_purpose.resize(N)
	c_commute.resize(N)
	c_home.resize(N)
	c_hh.resize(N)
	c_employer.resize(N)
	c_roster_slot.resize(N)
	c_unemp_slot.resize(N)
	c_days_unemp.resize(N)
	c_employed.resize(N)
	h_funds.resize(N / 2)
	f_margin.resize(M)
	f_headcount.resize(M)
	f_county.resize(M)
	f_sector.resize(M)
	f_streak.resize(M)
	f_wagedev.resize(M)
	f_ent.resize(M)
	f_frozen.resize(M)
	f_closed.resize(M)
	wages.resize(COUNTIES)
	county_emp.resize(COUNTIES)
	county_pop.resize(COUNTIES)
	rosters.clear()
	for j in range(M):
		rosters.append([])
	unemp.clear()
	q_kind.resize(QUEUE_CAP)
	q_firm.resize(QUEUE_CAP)
	q_slots.resize(QUEUE_CAP)
	q_head = 0
	q_tail = 0
	q_count = 0
	hires = 0
	layoffs = 0
	quits = 0
	closes = 0
	spawns = 0
	unfilled = 0
	empty_roster = 0
	dropped = 0
	jobhunt = 0
	hungry = 0
	tired = 0
	sick = 0
	lonely = 0
	aimless = 0
	unrest = 0
	protest = 0
	cantwork = 0
	ledger_debt = 8.0e9
	for c in range(COUNTIES):
		wages[c] = 100.0
	# Same RNG draw order as the C# Init.
	for i in range(N):
		var emp: bool = _next_float() < 0.9
		c_money[i] = 40.0 + _next_float() * 50.0
		c_rest[i] = 40.0 + _next_float() * 50.0
		c_health[i] = 40.0 + _next_float() * 50.0
		c_food[i] = 40.0 + _next_float() * 50.0
		c_social[i] = 40.0 + _next_float() * 50.0
		c_purpose[i] = 40.0 + _next_float() * 50.0
		c_home[i] = i % COUNTIES
		c_hh[i] = i / 2
		c_employer[i] = -1
		c_days_unemp[i] = 0
		c_unemp_slot[i] = -1
		c_roster_slot[i] = -1
		if emp:
			c_employed[i] = 1
			var f: int = _next_int(M)
			c_employer[i] = f
			var r: Array = rosters[f]
			c_roster_slot[i] = r.size()
			r.append(i)
		else:
			c_employed[i] = 0
			c_days_unemp[i] = _next_int(60)
			c_unemp_slot[i] = unemp.size()
			unemp.append(i)
	for h in range(N / 2):
		h_funds[h] = 2.0 * COL_PER_MONTH * (1.0 + _next_float() * 3.0)
	for j in range(M):
		var rr: float = _next_float()
		var size: int = 0
		if rr < 0.8:
			size = 1 + int(_next_float() * 18.0)
		elif rr < 0.95:
			size = 20 + int(_next_float() * 179.0)
		else:
			size = 200 + int(_next_float() * 800.0)
		f_margin[j] = 0.05
		f_headcount[j] = size
		f_county[j] = j % COUNTIES
		f_sector[j] = j % 6
		f_streak[j] = 0
		f_wagedev[j] = 0.0
		f_ent[j] = 0.0
		f_frozen[j] = 0
		f_closed[j] = 0


func _tick(day: int) -> void:
	# ---- Firms (daily profitability + threshold checks, coupling 1.5) ----
	for j in range(M):
		if f_closed[j] == 1:
			continue
		var demand: float = (_next_float() - 0.5) * 0.2
		var wage_ratio: float = wages[f_county[j]] * SECTOR_MULT[f_sector[j]] / 100.0
		var margin: float = 0.12 - 0.5 * (LOGISTICS - 1.0) - 0.3 * (wage_ratio - 1.0) - 2.0 * (CORP_RATE - 0.06) + demand + 0.02
		f_margin[j] = margin
		if margin > 0.08:
			f_frozen[j] = 0
			f_streak[j] = 0
			f_wagedev[j] = 0.05
			var agg: int = f_headcount[j] / 10 + 1
			f_headcount[j] = f_headcount[j] + agg
			f_ent[j] = f_ent[j] + float(agg) / 1000.0
			if f_ent[j] > 2.0:
				f_ent[j] = 2.0
			elif f_ent[j] < -2.0:
				f_ent[j] = -2.0
			var slots: int = int(f_ent[j])
			f_ent[j] = f_ent[j] - float(slots)
			_enqueue(0, j, slots)
		elif margin < -0.15:
			f_closed[j] = 1
			f_frozen[j] = 0
			_enqueue(2, j, 0)
			closes += 1
		elif margin < -0.05:
			f_frozen[j] = 0
			f_wagedev[j] = 0.0
			f_streak[j] = f_streak[j] + 1
			if f_streak[j] >= 2:
				var lagg: int = f_headcount[j] / 5 + 1
				f_headcount[j] = f_headcount[j] - lagg
				if f_headcount[j] < 0:
					f_headcount[j] = 0
				f_ent[j] = f_ent[j] - float(lagg) / 1000.0
				if f_ent[j] > 2.0:
					f_ent[j] = 2.0
				elif f_ent[j] < -2.0:
					f_ent[j] = -2.0
				var lslots: int = -int(f_ent[j])
				f_ent[j] = f_ent[j] + float(lslots)
				_enqueue(1, j, lslots)
		elif margin <= 0.02:
			f_frozen[j] = 1
			f_streak[j] = 0
			f_wagedev[j] = -0.02
		else:
			f_frozen[j] = 0
			f_streak[j] = 0
			f_wagedev[j] = 0.0
	# Spawn pass: 2 attempts/day reactivate closed firms (fixed M).
	for s in range(2):
		if _next_float() < 0.10:
			var f: int = _next_int(M)
			var probe: int = 0
			while probe < 8 and f_closed[f] == 0:
				f = (f + 1) % M
				probe += 1
			if f_closed[f] == 1:
				f_closed[f] = 0
				f_streak[f] = 0
				f_headcount[f] = 5 + _next_int(46)
				f_margin[f] = 0.05
				_enqueue(0, f, f_headcount[f] / 10 + 1)
				spawns += 1

	# ---- Placement pass: exactly K churn events ----
	for e in range(K):
		var kind: int = 0
		var firm: int = 0
		var slots: int = 0
		if q_count == 0:
			kind = 0 if ((_next_u32() & 1) == 0) else 1
			firm = _next_int(M)
			var probe2: int = 0
			while probe2 < 8 and f_closed[firm] == 1:
				firm = (firm + 1) % M
				probe2 += 1
			if f_closed[firm] == 1:
				dropped += 1
				continue
			slots = 1
		else:
			kind = q_kind[q_head]
			firm = q_firm[q_head]
			slots = q_slots[q_head]
			q_head += 1
			if q_head == QUEUE_CAP:
				q_head = 0
			q_count -= 1
		if kind == 2:
			var rc: Array = rosters[firm]
			while rc.size() > 0:
				_layoff(rc[rc.size() - 1])
			continue
		if kind == 0:
			if f_closed[firm] == 1 or f_frozen[firm] == 1:
				unfilled += slots
				continue
			for t in range(slots):
				var best: int = -1
				var best_score: float = -1.0
				var fc: int = f_county[firm]
				for u in range(unemp.size()):
					var c: int = unemp[u]
					if not _in_shed(c_home[c], fc):
						continue
					var score: float = float(c_days_unemp[c]) * 1000.0 + (100.0 - c_money[c])
					if score > best_score:
						best_score = score
						best = c
				if best < 0:
					unfilled += 1
					break
				_hire(best, firm)
		else:
			var rl: Array = rosters[firm]
			for t in range(slots):
				if rl.size() == 0:
					empty_roster += 1
					break
				_layoff(rl[rl.size() - 1])

	# ---- Citizens: commute + 5 beats + daily money check ----
	for i in range(N):
		var f: int = c_employer[i]
		var fterm: int = 0 if f < 0 else f
		var dist: float = 5.0 + float((i * 7 + fterm * 13) % 40)
		var commute: float = dist / 50.0 * 60.0 * ROAD_MULT
		c_commute[i] = commute
		var money: float = c_money[i]
		var rest: float = c_rest[i]
		var health: float = c_health[i]
		var food: float = c_food[i]
		var social: float = c_social[i]
		var purpose: float = c_purpose[i]
		var emp: bool = c_employed[i] == 1
		var pdec: float = 1.2 if emp else 3.0
		for b in range(BEATS):
			money -= 1.0
			rest -= 7.0
			health -= 0.8
			food -= 6.0
			social -= 2.4
			purpose -= pdec
			if b == 0:
				rest += 12.0
			elif b == 1:
				if commute > 45.0:
					rest -= (commute - 45.0) / 15.0
			elif b == 2:
				if emp:
					purpose += 2.0
			elif b == 3:
				social += 5.0
				food += 7.0
			else:
				food += 7.0
				rest += 2.0
			if money < 0.0:
				money = 0.0
			elif money > 100.0:
				money = 100.0
			if rest < 0.0:
				rest = 0.0
			elif rest > 100.0:
				rest = 100.0
			if health < 0.0:
				health = 0.0
			elif health > 100.0:
				health = 100.0
			if food < 0.0:
				food = 0.0
			elif food > 100.0:
				food = 100.0
			if social < 0.0:
				social = 0.0
			elif social > 100.0:
				social = 100.0
			if purpose < 0.0:
				purpose = 0.0
			elif purpose > 100.0:
				purpose = 100.0
			if money < 25.0:
				jobhunt += 1
			if food < 20.0:
				hungry += 1
				if food < 10.0:
					health -= 1.0
			if rest < 15.0:
				tired += 1
			if health < 25.0:
				sick += 1
				if health < 10.0:
					cantwork += 1
			if social < 20.0:
				lonely += 1
				if social < 10.0:
					unrest += 1
			if purpose < 20.0:
				aimless += 1
				if purpose < 10.0:
					protest += 1
		c_money[i] = money
		c_rest[i] = rest
		c_health[i] = health
		c_food[i] = food
		c_social[i] = social
		c_purpose[i] = purpose
		if not emp:
			c_days_unemp[i] = c_days_unemp[i] + 1
		var hh: int = c_hh[i]
		if emp and day % 7 == 3 and f >= 0:
			h_funds[hh] = h_funds[hh] + WEEKLY_PAY * (1.0 + f_wagedev[f])
		var months: float = h_funds[hh] / (2.0 * COL_PER_MONTH)
		var mneed: float = 0.0
		if months >= 3.0:
			var over: float = months - 3.0
			if over > 10.0:
				over = 10.0
			mneed = 90.0 + over
		elif months < 1.0:
			mneed = months * 30.0
		else:
			mneed = 30.0 + 30.0 * (months - 1.0)
		if mneed < 0.0:
			mneed = 0.0
		elif mneed > 100.0:
			mneed = 100.0
		c_money[i] = mneed
		if emp and (mneed < 25.0 or purpose < 20.0):
			var ef: int = c_employer[i]
			var slot: int = c_roster_slot[i]
			var rq: Array = rosters[ef]
			var last: int = rq[rq.size() - 1]
			rq[slot] = last
			c_roster_slot[last] = slot
			rq.resize(rq.size() - 1)
			c_employed[i] = 0
			c_employer[i] = -1
			c_days_unemp[i] = 0
			c_unemp_slot[i] = unemp.size()
			unemp.append(i)
			quits += 1

	# ---- Daily macro aggregation (county truth + wage index, coupling 2.1) ----
	for c in range(COUNTIES):
		county_emp[c] = 0
		county_pop[c] = 0
	var emp_total: int = 0
	for i in range(N):
		county_pop[c_home[i]] = county_pop[c_home[i]] + 1
		if c_employed[i] == 1:
			county_emp[c_home[i]] = county_emp[c_home[i]] + 1
			emp_total += 1
	for c in range(COUNTIES):
		if county_pop[c] == 0:
			continue
		var u: float = 100.0 * (1.0 - float(county_emp[c]) / float(county_pop[c]))
		var delta: float = 0.5 * (5.0 - u) / 100.0
		if delta < -0.03:
			delta = -0.03
		elif delta > 0.03:
			delta = 0.03
		wages[c] = wages[c] * (1.0 + delta)
	var revenue: float = float(emp_total) * WEEKLY_PAY * 0.0425 / 7.0
	var expense: float = 70.0e9 / 365.0
	ledger_debt = ledger_debt + expense - revenue


func _mix(h: int, v: int) -> int:
	var u: int = v & 0xFFFFFFFF
	h = ((h ^ (u & 0xFF)) * 16777619) & 0xFFFFFFFF
	h = ((h ^ ((u >> 8) & 0xFF)) * 16777619) & 0xFFFFFFFF
	h = ((h ^ ((u >> 16) & 0xFF)) * 16777619) & 0xFFFFFFFF
	h = ((h ^ ((u >> 24) & 0xFF)) * 16777619) & 0xFFFFFFFF
	return h


func _checksum() -> int:
	var h: int = 2166136261 & 0xFFFFFFFF
	for i in range(N):
		h = _mix(h, int(c_money[i] * 1000.0))
		h = _mix(h, int(c_rest[i] * 1000.0))
		h = _mix(h, int(c_health[i] * 1000.0))
		h = _mix(h, int(c_food[i] * 1000.0))
		h = _mix(h, int(c_social[i] * 1000.0))
		h = _mix(h, int(c_purpose[i] * 1000.0))
		h = _mix(h, 1 if c_employed[i] == 1 else 0)
		h = _mix(h, c_days_unemp[i])
	for hh in range(N / 2):
		h = _mix(h, int(h_funds[hh] * 100.0))
	for j in range(M):
		h = _mix(h, int(f_margin[j] * 100000.0))
		h = _mix(h, f_headcount[j])
		h = _mix(h, int(f_ent[j] * 1000000.0))
		h = _mix(h, 1 if f_closed[j] == 1 else 0)
	for c in range(COUNTIES):
		h = _mix(h, int(wages[c] * 1000.0))
	h = _mix(h, hires)
	h = _mix(h, layoffs)
	h = _mix(h, quits)
	h = _mix(h, closes)
	h = _mix(h, spawns)
	h = _mix(h, unfilled)
	h = _mix(h, empty_roster)
	h = _mix(h, dropped)
	h = _mix(h, jobhunt)
	h = _mix(h, hungry)
	h = _mix(h, tired)
	h = _mix(h, sick)
	h = _mix(h, lonely)
	h = _mix(h, aimless)
	h = _mix(h, unrest)
	h = _mix(h, protest)
	h = _mix(h, cantwork)
	return h

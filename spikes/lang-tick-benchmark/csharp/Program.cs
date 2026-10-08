// Mitten State LANG spike — C# tick benchmark (idiomatic perf style).
//
// One "tick" = one in-game day (time-scale-decision-v0.1: day = macro tick +
// sub-daily beats): daily macro aggregation + citizens x 5 beats (6 needs
// decayed per beat, threshold branches, household-budget money check) + firms
// updated daily (profitability from 5 inputs, hire/freeze/layoff/close
// thresholds per coupling-spec-v0.1 section 1.5) + one placement pass over
// exactly K churn events (hire scan over the unemployed pool, LIFO layoffs).
//
// Workload constants mirror numbers-appendix-v0.1 section 3 (need decays),
// coupling-spec-v0.1 sections 1.5 (firm bands), 2.1 (wage index), 3.2
// (commute/logistics), 4.1 (S_SE ~ 1000). See ../README.md for the full
// methodology and the deliberate simplifications shared with benchmark.gd.
//
// Usage:
//   dotnet run -c Release -- --n 5000 --m 500 --k 20 --ticks 10 --reps 5 --warmup 1 --seed 12345

using System.Diagnostics;

static class Args
{
    public static int Get(string[] args, string name, int dflt)
    {
        string p = "--" + name + "=";
        foreach (string a in args)
            if (a.StartsWith(p, StringComparison.Ordinal) && int.TryParse(a.Substring(p.Length), out int v))
                return v;
        return dflt;
    }
}

struct Citizen
{
    public double Money, Rest, Health, Food, Social, Purpose;
    public double Commute; // minutes, recomputed daily
    public int Home, Hh, Employer, RosterSlot, UnempSlot, DaysUnemp;
    public bool Employed;
}

struct Household
{
    public double Funds;
    public int Size; // always 2 in this spike (see README)
}

struct Firm
{
    public double Margin;
    public int Headcount, County, Sector, Streak;
    public double WageDev; // offer deviation for new hires (+5/0/-2%)
    public double Ent;     // lens-entitlement accumulator (coupling 1.4, S=1000)
    public bool Frozen, Closed;
}

sealed class Sim
{
    const int Counties = 83;
    const int Beats = 5;
    static readonly double[] SectorMult = { 1.10, 1.15, 0.85, 0.80, 1.25, 0.95 };
    const double RoadsCond = 45.0;      // appendix section 0: "rough"
    const double RoadMult = 1.44;       // 1 + 0.8*(100-45)/100
    const double Logistics = 1.165;     // 1 + 0.3*(100-45)/100
    const double WeeklyPay = 900.0;     // coupling section 2.3: index-100 job
    const double ColPerMonth = 1714.0;  // ~$400/wk per capita x 30/7
    const double CorpRate = 0.06;

    readonly int N, M, K;
    uint rng;
    Citizen[] citizens;
    Household[] households;
    Firm[] firms;
    double[] wages = new double[Counties];
    int[] countyEmp = new int[Counties];
    int[] countyPop = new int[Counties];
    List<int>[] rosters;      // per-firm lens roster (citizen ids, LIFO layoffs)
    List<int> unemp = new();  // unemployed citizen ids (swap-remove pool)
    // Firm-event queue (ring): kind 0 = openings, 1 = layoffs, 2 = close.
    readonly int[] qKind, qFirm, qSlots;
    int qHead, qTail, qCount, qCap;
    // Whole-run counters (also folded into the checksum).
    long hires, layoffs, quits, closes, spawns, unfilled, emptyRoster, dropped;
    long jobhunt, hungry, tired, sick, lonely, aimless, unrest, protest, cantwork;
    double ledgerDebt = 8.0e9;

    public Sim(int n, int m, int k, int seed)
    {
        N = n; M = m; K = k;
        rng = (uint)seed;
        citizens = new Citizen[N];
        households = new Household[N / 2];
        firms = new Firm[M];
        rosters = new List<int>[M];
        qCap = 4 * 1024;
        qKind = new int[qCap]; qFirm = new int[qCap]; qSlots = new int[qCap];
        for (int j = 0; j < M; j++) rosters[j] = new List<int>(32);
        unemp = new List<int>(N / 4 + 16);
        Init();
    }

    uint NextU32()
    {
        uint x = rng;
        x ^= x << 13;
        x ^= x >> 17;
        x ^= x << 5;
        rng = x;
        return x;
    }
    double NextFloat() => (NextU32() >> 8) / 16777216.0;
    int NextInt(int n) => (int)(NextU32() % (uint)n);

    static bool InShed(int a, int b)
    {
        int d = a - b;
        if (d < 0) d = -d;
        return (d % 9) < 6;
    }

    void Enqueue(int kind, int firm, int slots)
    {
        if (qCount == qCap) { dropped++; return; }
        qKind[qTail] = kind; qFirm[qTail] = firm; qSlots[qTail] = slots;
        qTail++;
        if (qTail == qCap) qTail = 0;
        qCount++;
    }

    bool Dequeue(out int kind, out int firm, out int slots)
    {
        if (qCount == 0) { kind = firm = slots = 0; return false; }
        kind = qKind[qHead]; firm = qFirm[qHead]; slots = qSlots[qHead];
        qHead++;
        if (qHead == qCap) qHead = 0;
        qCount--;
        return true;
    }

    void Hire(int c, int f)
    {
        // Remove from unemployed pool (swap-remove via stored slot).
        int slot = citizens[c].UnempSlot;
        int last = unemp[unemp.Count - 1];
        unemp[slot] = last;
        citizens[last].UnempSlot = slot;
        unemp.RemoveAt(unemp.Count - 1);
        // Employ + append to firm roster.
        citizens[c].Employed = true;
        citizens[c].Employer = f;
        citizens[c].DaysUnemp = 0;
        citizens[c].RosterSlot = rosters[f].Count;
        rosters[f].Add(c);
        hires++;
    }

    void Layoff(int c)
    {
        int f = citizens[c].Employer;
        // Swap-remove from firm roster via stored slot.
        int slot = citizens[c].RosterSlot;
        var r = rosters[f];
        int last = r[r.Count - 1];
        r[slot] = last;
        citizens[last].RosterSlot = slot;
        r.RemoveAt(r.Count - 1);
        // To unemployed pool.
        citizens[c].Employed = false;
        citizens[c].Employer = -1;
        citizens[c].DaysUnemp = 0;
        citizens[c].UnempSlot = unemp.Count;
        unemp.Add(c);
        layoffs++;
    }

    void Init()
    {
        for (int c = 0; c < Counties; c++) wages[c] = 100.0;
        for (int i = 0; i < N; i++)
        {
            bool emp = NextFloat() < 0.9;
            citizens[i] = new Citizen
            {
                Money = 40.0 + NextFloat() * 50.0,
                Rest = 40.0 + NextFloat() * 50.0,
                Health = 40.0 + NextFloat() * 50.0,
                Food = 40.0 + NextFloat() * 50.0,
                Social = 40.0 + NextFloat() * 50.0,
                Purpose = 40.0 + NextFloat() * 50.0,
                Home = i % Counties,
                Hh = i / 2,
                Employed = emp,
                Employer = -1,
                DaysUnemp = 0,
                UnempSlot = -1,
                RosterSlot = -1,
            };
            if (emp)
            {
                int f = NextInt(M);
                citizens[i].Employer = f;
                citizens[i].RosterSlot = rosters[f].Count;
                rosters[f].Add(i);
            }
            else
            {
                citizens[i].DaysUnemp = NextInt(60);
                citizens[i].UnempSlot = unemp.Count;
                unemp.Add(i);
            }
        }
        for (int h = 0; h < households.Length; h++)
            households[h] = new Household { Funds = 2.0 * ColPerMonth * (1.0 + NextFloat() * 3.0), Size = 2 };
        for (int j = 0; j < M; j++)
        {
            double r = NextFloat();
            int size = r < 0.8 ? 1 + (int)(NextFloat() * 18.0)
                     : r < 0.95 ? 20 + (int)(NextFloat() * 179.0)
                     : 200 + (int)(NextFloat() * 800.0);
            firms[j] = new Firm
            {
                Margin = 0.05, Headcount = size, County = j % Counties,
                Sector = j % 6, Streak = 0, WageDev = 0.0, Frozen = false, Closed = false,
            };
        }
    }

    // One tick = one in-game day.
    public void Tick(int day)
    {
        // ---- Firms (daily profitability + threshold checks, coupling 1.5) ----
        for (int j = 0; j < M; j++)
        {
            if (firms[j].Closed) continue;
            double demand = (NextFloat() - 0.5) * 0.2;
            double wageRatio = wages[firms[j].County] * SectorMult[firms[j].Sector] / 100.0;
            double margin = 0.12 - 0.5 * (Logistics - 1.0) - 0.3 * (wageRatio - 1.0)
                            - 2.0 * (CorpRate - 0.06) + demand + 0.02;
            firms[j].Margin = margin;
            if (margin > 0.08)
            {
                firms[j].Frozen = false; firms[j].Streak = 0; firms[j].WageDev = 0.05;
                int agg = firms[j].Headcount / 10 + 1;
                firms[j].Headcount += agg;
                // Entitlement carry (coupling 1.4): aggregate jobs -> 0-1 lens slots.
                firms[j].Ent += (double)agg / 1000.0;
                if (firms[j].Ent > 2.0) firms[j].Ent = 2.0; else if (firms[j].Ent < -2.0) firms[j].Ent = -2.0;
                int slots = (int)firms[j].Ent;
                firms[j].Ent -= slots;
                Enqueue(0, j, slots);
            }
            else if (margin < -0.15)
            {
                firms[j].Closed = true; firms[j].Frozen = false;
                Enqueue(2, j, 0);
                closes++;
            }
            else if (margin < -0.05)
            {
                firms[j].Frozen = false; firms[j].WageDev = 0.0;
                firms[j].Streak++;
                if (firms[j].Streak >= 2)
                {
                    int agg = firms[j].Headcount / 5 + 1;
                    firms[j].Headcount -= agg;
                    if (firms[j].Headcount < 0) firms[j].Headcount = 0;
                    firms[j].Ent -= (double)agg / 1000.0;
                    if (firms[j].Ent > 2.0) firms[j].Ent = 2.0; else if (firms[j].Ent < -2.0) firms[j].Ent = -2.0;
                    int slots = -(int)firms[j].Ent;
                    firms[j].Ent += slots;
                    Enqueue(1, j, slots);
                }
            }
            else if (margin <= 0.02)
            {
                firms[j].Frozen = true; firms[j].Streak = 0; firms[j].WageDev = -0.02;
            }
            else
            {
                firms[j].Frozen = false; firms[j].Streak = 0; firms[j].WageDev = 0.0;
            }
        }
        // Spawn pass: 2 attempts/day reactivate closed firms (fixed M).
        for (int s = 0; s < 2; s++)
        {
            if (NextFloat() < 0.10)
            {
                int f = NextInt(M);
                for (int probe = 0; probe < 8 && !firms[f].Closed; probe++) f = (f + 1) % M;
                if (firms[f].Closed)
                {
                    firms[f].Closed = false; firms[f].Streak = 0;
                    firms[f].Headcount = 5 + NextInt(46);
                    firms[f].Margin = 0.05;
                    Enqueue(0, f, firms[f].Headcount / 10 + 1);
                    spawns++;
                }
            }
        }

        // ---- Placement pass: exactly K churn events ----
        for (int e = 0; e < K; e++)
        {
            int kind, firm, slots;
            if (!Dequeue(out kind, out firm, out slots))
            {
                // Synthetic top-up keeps K constant across ticks/configs.
                kind = (NextU32() & 1) == 0 ? 0 : 1;
                firm = NextInt(M);
                for (int probe = 0; probe < 8 && firms[firm].Closed; probe++) firm = (firm + 1) % M;
                if (firms[firm].Closed) { dropped++; continue; }
                slots = 1; // synthetic events carry the typical lens outcome (0-1 slots)
            }
            if (kind == 2) // CLOSE: whole roster laid off
            {
                var r = rosters[firm];
                while (r.Count > 0) Layoff(r[r.Count - 1]);
                continue;
            }
            if (kind == 0) // OPENINGS: scan unemployed pool, hire best
            {
                if (firms[firm].Closed || firms[firm].Frozen) { unfilled += slots; continue; }
                for (int t = 0; t < slots; t++)
                {
                    int best = -1;
                    double bestScore = -1.0;
                    int fc = firms[firm].County;
                    for (int u = 0; u < unemp.Count; u++)
                    {
                        int c = unemp[u];
                        if (!InShed(citizens[c].Home, fc)) continue;
                        double score = citizens[c].DaysUnemp * 1000.0 + (100.0 - citizens[c].Money);
                        if (score > bestScore) { bestScore = score; best = c; }
                    }
                    if (best < 0) { unfilled++; break; }
                    Hire(best, firm);
                }
            }
            else // LAYOFFS: strict LIFO off the roster
            {
                var r = rosters[firm];
                for (int t = 0; t < slots; t++)
                {
                    if (r.Count == 0) { emptyRoster++; break; }
                    Layoff(r[r.Count - 1]);
                }
            }
        }

        // ---- Citizens: commute + 5 beats + daily money check ----
        for (int i = 0; i < N; i++)
        {
            // Commute (coupling 3.2 shape, pseudo-distance; see README).
            int f = citizens[i].Employer;
            double dist = 5.0 + ((i * 7 + (f < 0 ? 0 : f) * 13) % 40);
            double commute = dist / 50.0 * 60.0 * RoadMult;
            citizens[i].Commute = commute;

            double money = citizens[i].Money, rest = citizens[i].Rest, health = citizens[i].Health;
            double food = citizens[i].Food, social = citizens[i].Social, purpose = citizens[i].Purpose;
            bool emp = citizens[i].Employed;
            double pdec = emp ? 1.2 : 3.0;

            for (int b = 0; b < Beats; b++)
            {
                money -= 1.0; rest -= 7.0; health -= 0.8;
                food -= 6.0; social -= 2.4; purpose -= pdec;
                if (b == 0) rest += 12.0;
                else if (b == 1) { if (commute > 45.0) rest -= (commute - 45.0) / 15.0; }
                else if (b == 2) { if (emp) purpose += 2.0; }
                else if (b == 3) { social += 5.0; food += 7.0; }
                else { food += 7.0; rest += 2.0; }
                if (money < 0.0) money = 0.0; else if (money > 100.0) money = 100.0;
                if (rest < 0.0) rest = 0.0; else if (rest > 100.0) rest = 100.0;
                if (health < 0.0) health = 0.0; else if (health > 100.0) health = 100.0;
                if (food < 0.0) food = 0.0; else if (food > 100.0) food = 100.0;
                if (social < 0.0) social = 0.0; else if (social > 100.0) social = 100.0;
                if (purpose < 0.0) purpose = 0.0; else if (purpose > 100.0) purpose = 100.0;
                // Threshold branches (appendix section 3 behavior table).
                if (money < 25.0) jobhunt++;
                if (food < 20.0) { hungry++; if (food < 10.0) health -= 1.0; }
                if (rest < 15.0) tired++;
                if (health < 25.0) { sick++; if (health < 10.0) cantwork++; }
                if (social < 20.0) { lonely++; if (social < 10.0) unrest++; }
                if (purpose < 20.0) { aimless++; if (purpose < 10.0) protest++; }
            }

            citizens[i].Money = money; citizens[i].Rest = rest; citizens[i].Health = health;
            citizens[i].Food = food; citizens[i].Social = social; citizens[i].Purpose = purpose;

            if (!emp) citizens[i].DaysUnemp++;
            int hh = citizens[i].Hh;
            // Weekly payday adds earners' pay to the shared household budget.
            if (emp && day % 7 == 3 && f >= 0)
                households[hh].Funds += WeeklyPay * (1.0 + firms[f].WageDev);
            // Household-budget money check (appendix 3 + coupling 2.3 ramp).
            double months = households[hh].Funds / (households[hh].Size * ColPerMonth);
            double mneed;
            if (months >= 3.0) { double over = months - 3.0; if (over > 10.0) over = 10.0; mneed = 90.0 + over; }
            else if (months < 1.0) mneed = months * 30.0;
            else mneed = 30.0 + 30.0 * (months - 1.0);
            if (mneed < 0.0) mneed = 0.0; else if (mneed > 100.0) mneed = 100.0;
            citizens[i].Money = mneed;

            // Needs-driven quits (citizen-initiated, never firm events).
            if (emp && (mneed < 25.0 || purpose < 20.0))
            {
                int c = i;
                int ef = citizens[c].Employer;
                int slot = citizens[c].RosterSlot;
                var r = rosters[ef];
                int last = r[r.Count - 1];
                r[slot] = last;
                citizens[last].RosterSlot = slot;
                r.RemoveAt(r.Count - 1);
                citizens[c].Employed = false;
                citizens[c].Employer = -1;
                citizens[c].DaysUnemp = 0;
                citizens[c].UnempSlot = unemp.Count;
                unemp.Add(c);
                quits++;
            }
        }

        // ---- Daily macro aggregation (county truth + wage index, coupling 2.1) ----
        Array.Clear(countyEmp);
        Array.Clear(countyPop);
        long empTotal = 0;
        for (int i = 0; i < N; i++)
        {
            countyPop[citizens[i].Home]++;
            if (citizens[i].Employed) { countyEmp[citizens[i].Home]++; empTotal++; }
        }
        for (int c = 0; c < Counties; c++)
        {
            if (countyPop[c] == 0) continue;
            double u = 100.0 * (1.0 - (double)countyEmp[c] / countyPop[c]);
            double delta = 0.5 * (5.0 - u) / 100.0;
            if (delta < -0.03) delta = -0.03; else if (delta > 0.03) delta = 0.03;
            wages[c] *= 1.0 + delta;
        }
        double revenue = empTotal * WeeklyPay * 0.0425 / 7.0;
        double expense = 70.0e9 / 365.0;
        ledgerDebt += expense - revenue;
    }

    public uint Checksum()
    {
        uint h = 2166136261u;
        void Mix(int v)
        {
            uint u = (uint)v;
            h = (h ^ (u & 0xFF)) * 16777619u;
            h = (h ^ ((u >> 8) & 0xFF)) * 16777619u;
            h = (h ^ ((u >> 16) & 0xFF)) * 16777619u;
            h = (h ^ ((u >> 24) & 0xFF)) * 16777619u;
        }
        for (int i = 0; i < N; i++)
        {
            Mix((int)(citizens[i].Money * 1000.0));
            Mix((int)(citizens[i].Rest * 1000.0));
            Mix((int)(citizens[i].Health * 1000.0));
            Mix((int)(citizens[i].Food * 1000.0));
            Mix((int)(citizens[i].Social * 1000.0));
            Mix((int)(citizens[i].Purpose * 1000.0));
            Mix(citizens[i].Employed ? 1 : 0);
            Mix(citizens[i].DaysUnemp);
        }
        for (int hidx = 0; hidx < households.Length; hidx++)
            Mix((int)(households[hidx].Funds * 100.0));
        for (int j = 0; j < M; j++)
        {
            Mix((int)(firms[j].Margin * 100000.0));
            Mix(firms[j].Headcount);
            Mix((int)(firms[j].Ent * 1000000.0));
            Mix(firms[j].Closed ? 1 : 0);
        }
        for (int c = 0; c < Counties; c++) Mix((int)(wages[c] * 1000.0));
        Mix((int)hires); Mix((int)layoffs); Mix((int)quits); Mix((int)closes);
        Mix((int)spawns); Mix((int)unfilled); Mix((int)emptyRoster); Mix((int)dropped);
        Mix((int)jobhunt); Mix((int)hungry); Mix((int)tired); Mix((int)sick);
        Mix((int)lonely); Mix((int)aimless); Mix((int)unrest); Mix((int)protest);
        Mix((int)cantwork);
        return h;
    }
}

class Program
{
    static int Main(string[] args)
    {
        int n = Args.Get(args, "n", 5000);
        int m = Args.Get(args, "m", 500);
        int k = Args.Get(args, "k", 20);
        int ticks = Args.Get(args, "ticks", 10);
        int reps = Args.Get(args, "reps", 5);
        int warmup = Args.Get(args, "warmup", 1);
        int seed = Args.Get(args, "seed", 12345);
        if (n % 2 != 0) { Console.WriteLine("n must be even"); return 2; }

        Console.WriteLine($"lang=csharp n={n} m={m} k={k} ticks={ticks} reps={reps} warmup={warmup} seed={seed}");
#if DEBUG
        Console.WriteLine("build=Debug");
#else
        Console.WriteLine("build=Release");
#endif
        for (int w = 0; w < warmup; w++)
        {
            var s = new Sim(n, m, k, seed);
            var sw = Stopwatch.StartNew();
            for (int t = 0; t < ticks; t++) s.Tick(t);
            sw.Stop();
            Console.WriteLine($"warmup {w}: {sw.Elapsed.TotalMilliseconds / ticks:F3} ms/tick");
        }
        var times = new List<double>();
        for (int r = 0; r < reps; r++)
        {
            var s = new Sim(n, m, k, seed);
            var sw = Stopwatch.StartNew();
            for (int t = 0; t < ticks; t++) s.Tick(t);
            sw.Stop();
            double per = sw.Elapsed.TotalMilliseconds / ticks;
            times.Add(per);
            Console.WriteLine($"rep {r}: {per:F3} ms/tick checksum={s.Checksum():X8}");
        }
        times.Sort();
        double median = times[times.Count / 2];
        Console.WriteLine($"median_ms_per_tick={median:F3}");

        // Determinism: same seed twice must give the same checksum.
        var a = new Sim(n, m, k, seed);
        for (int t = 0; t < ticks; t++) a.Tick(t);
        var b = new Sim(n, m, k, seed);
        for (int t = 0; t < ticks; t++) b.Tick(t);
        uint ca = a.Checksum(), cb = b.Checksum();
        Console.WriteLine($"determinism: run1={ca:X8} run2={cb:X8} match={ca == cb}");
        return ca == cb ? 0 : 1;
    }
}

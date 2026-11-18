# What Works Today: PRAYAAN System Maturity & Execution Guide

> **Honest Engineering Disclosure for Competition Evaluators & Technical Reviewers**  
> *PRAYAAN (Tech4Bharat 2026 / GAVS Hackathon, Theme 5: Rural Freight, Team Kernal500)*

---

## 1. Transparency Manifesto

In competitive technology hackathons, systems are frequently presented as fully operational end-to-end platforms when only presentation prototypes exist. PRAYAAN rejects this practice. This document delineates with absolute precision **what code runs today**, **what components are working prototypes**, and **what aspects are architectural designs scheduled for production rollout**.

### Explicit Reality Check
- **Algorithmic Solvers**: The Normalized Multi-Resource Sharing (NMRS) cost allocation engine and the corridor pooling dispatch algorithms (Deterministic Stage 1 and Metaheuristic Stage 4 ALNS) are **100% executable and mathematically verified**.
- **Data Ingestion**: The benchmark suite runs on a **synthetic testbed of 50 agricultural consignments** calibrated to the actual geography, commodity densities, and vehicle capacities of the **Nashik–Mumbai NH-160 freight corridor (165 km)**. It does **not** yet ingest live automated APMC AGMARKNET WebSocket feeds.
- **Field Interviews & User Pilots**: **No field surveys or physical trials have been conducted to date.** All farmer workflows, driver interactions, and cooperative savings are modeled based on verified government reports (NITI Aayog, Central Road Research Institute, NSSO 77th Round) and stated assumptions. Physical pilot validation is scheduled for Phase 1 (`PLANNED — NOT YET CONDUCTED`).

---

## 2. Feature Maturity Matrix

| System Component | Implementation Status | Implementation Artifact / Verification Command | Operational Reality & Code Capabilities |
| :--- | :--- | :--- | :--- |
| **Normalized Multi-Resource Sharing (NMRS)** | **WORKING** | `scripts/verify_cost_allocation.py`<br>`make verify` | Dynamically solves dual-bottleneck cost sharing across weight, volume, and slots. Tested across 1,000 Monte Carlo trials. Provably satisfies Budget Balance, Symmetry, and Zero-Paisa Invariants. Includes production IR-capped fallback ($A_i = \min(A_i^{\text{NMRS}}, c(\{i\}))$). |
| **Exact Shapley Value Engine** | **WORKING** | `scripts/verify_cost_allocation.py`<br>(Test Case 4) | Computes exact coalitional Shapley values $\phi_i(v)$ for $n=2..5$ using characteristic cost function $c(S)$ over right-sized vehicles (SCV/LCV/ICV/MHCV). Benchmarks NMRS deviation ($\le 11.7\%$ max). |
| **Stage 1 Deterministic Dispatch Engine** | **WORKING** | `scripts/benchmark_simulation.py`<br>`make benchmark` | Real-time corridor pooling heuristic with spatial buffer gate ($\delta_{\text{buffer}} = 10.0\text{ km}$) and time-window windowing ($\le 2.5\text{ hr}$). Constructs legitimate multi-stop routes in **0.2 ms** with 0 delivery deadline violations. |
| **Stage 4 ALNS Optimization Engine** | **WORKING** | `scripts/benchmark_simulation.py`<br>`make benchmark` | Simulated Annealing metaheuristic with Shaw Removal (spatiotemporal relatedness) and Regret-2 Insertion. Packs 50 consignments into 17.3 trucks (~79.1% utilization) in **~56 ms** with 0 violations. |
| **Multi-Seed Benchmark Comparison** | **WORKING** | `scripts/benchmark_simulation.py --seeds 42,1337,2026`<br>`make benchmark` | Evaluates 5 dispatch paradigms across multiple random seeds, reporting mean $\pm$ standard deviation for truck counts, route km, empty deadhead km, freight outlay, and runtime. Supports `--json` export. |
| **Audited Unit Economics Engine** | **WORKING** | `scripts/unit_economics.py`<br>`make unit-economics` | Models 18% statutory GST (₹161.82 on ₹899), ₹3.00 Lakhs/mo fixed OpEx (2 devs, support, insurance, recovery reserve), unit gross margin (₹783/mo, 87.1%), operational break-even (**384 subscribers**), and 3-year multi-corridor projections. |
| **PostgreSQL 16 + PostGIS Schema & RLS** | **WORKING** | `schema.sql`<br>`tests/schema_tests.sql`<br>`docker-compose.yml` | Complete DDL with PostGIS geometry, masked Aadhaar (14 chars), trip row concurrency locking (`FOR UPDATE`), SECURITY DEFINER RLS helpers, split CRUD policies, and anti-tampering triggers protecting `allocated_freight_paise`. |
| **Automated Schema Test Suite** | **WORKING** | `tests/schema_tests.sql`<br>`make test-db` | Standalone SQL regression suite covering Aadhaar format constraints, multi-axis capacity overflows, stop precedence violations, RLS tenant isolation between sellers, and driver tampering blocks. |
| **Contiguous Leg Capacity Trigger** | **WORKING** | `schema.sql`<br>(Lines 330–428) | PL/pgSQL trigger `validate_consignment_stops_and_capacity()` actively loops across route stops to verify weight, volume, and slot limits on every contiguous transit leg. |
| **Driver Geofenced OTP Custody Verification** | **PARTIAL (Schema & Logic Complete, Mobile UI Designed)** | `04_SYSTEM_ARCHITECTURE_AND_SPECIFICATIONS.md` (Section 4 & 5)<br>`schema.sql` (`custody_events`) | Database tables, idempotency keys, and 500m geofence validation state machine designed. Mobile GPS integration simulated via test events. Flutter UI screens defined in architecture specifications. |
| **Statutory E-Way Bill Dispatch Integration** | **PARTIAL (Payload Schema & Exception Logic Designed)** | `04_SYSTEM_ARCHITECTURE_AND_SPECIFICATIONS.md` (Section 8) | JSON schema for NIC GSP multi-consignment Part-B consolidated trip generation modeled. Direct production sandbox credentials pending GSTN CA certification. |
| **Payment Gateway 50/50 Split Settlement** | **PARTIAL (State Machine Designed, Gateway Sandbox Ready)** | `04_SYSTEM_ARCHITECTURE_AND_SPECIFICATIONS.md` (Section 8)<br>`05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md` | Deterministic escrow state machine designed (50% origin fuel advance on pickup OTP, 50% delivery balance). Razorpay Route / Cashfree Split Escrow API contracts specified. |
| **Mobile Applications (Farmer PWA, Driver Flutter)** | **DESIGNED-ONLY** | `04_SYSTEM_ARCHITECTURE_AND_SPECIFICATIONS.md` (Section 1) | Wireframes, localized Hindi/Marathi UX flows, and state machines documented. Production mobile binary compilation scheduled for Phase 2. |
| **Field Logistics & Mandi Pilots** | **DESIGNED-ONLY (Field Protocol Ready)** | `05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md` (Section 6)<br>`07_IMPLEMENTATION_ROADMAP_AND_MILESTONES.md` | Rigorous 3-phase pilot protocol established. **Status: PLANNED — NOT YET CONDUCTED.** |

---

## 3. How to Run and Verify the System Locally

The entire technical verification pipeline requires only standard **Python 3.10+** (zero external pip dependencies) and **Docker** for database integration tests.

### Step 1: Run All Mathematical, Economic, and Benchmark Suites
```bash
# Clone the repository
git clone https://github.com/kernal500/prayaan.git
cd prayaan

# Execute the complete automated verification pipeline
make all
```

Expected Output:
1. `scripts/verify_cost_allocation.py`:
   - Validates Test Cases 1, 2, 3 (Slide 5 Nashik-Mumbai consignment, dual-bottleneck split, symmetry).
   - Audits NMRS against exact Shapley values ($n=2..5$).
   - Passes 1,000 Monte Carlo stress trials with 0 budget balance failures and 100% individual rationality under IR-capped fallback.
2. `scripts/benchmark_simulation.py`:
   - Runs Baselines 1, 2, 3 and PRAYAAN Stages 1 and 4 across seeds 42, 1337, and 2026.
   - Outputs comprehensive metric table with 0 time-window violations and measured execution times.
3. `scripts/unit_economics.py`:
   - Computes statutory GST breakdowns, variable unit costs, fixed monthly OpEx (₹3.00 Lakhs), and 384-subscriber break-even threshold.

### Step 2: Run the PostgreSQL 16 + PostGIS Security Test Suite
```bash
# Spin up isolated PostGIS container and execute schema_tests.sql
make test-db
```

Expected Output:
```text
>>> TEST A: Aadhaar Masking Format Validation
  [PASS] A.1: Valid Aadhaar format (XXXX-XXXX-1234) inserted successfully.
  [PASS] A.2: Raw 12-digit Aadhaar correctly rejected by CHECK constraint.
  [PASS] A.3: Non-numeric suffix masked Aadhaar correctly rejected.
>>> TEST B: Multi-Axis Capacity Trigger & Stop Sequence Precedence
  [PASS] B.1: Baseline consignment (6,000 kg / 18 m3) inserted within capacity.
  [PASS] B.2: Weight capacity overflow correctly aborted by trigger: CAPACITY_EXCEEDED (Weight)
  [PASS] B.3: Reversed stop sequence correctly aborted by trigger.
>>> TEST C: Trip-Level Concurrency Locking (FOR UPDATE)
  [PASS] C.1: Exclusive FOR UPDATE row lock successfully acquired on trip row without block.
>>> TEST D: Row-Level Security (RLS) Tenant Isolation
  [PASS] D.1: Seller 1 can view their own order.
  [PASS] D.2: Seller 2 is strictly blocked from viewing Seller 1 order (count=0).
  [PASS] D.3: Platform ADMIN has global oversight access.
>>> TEST E: Transporter Anti-Tampering Shield & Payout Limits
  [PASS] E.1: Driver successfully updated operational status to PICKED_UP.
  [PASS] E.2: Unauthorized driver freight modification blocked: FINANCIAL_INTEGRITY_VIOLATION
  [PASS] E.3: Excessive advance freight disbursement blocked by invariant check.
ALL PRAYAAN SCHEMA INVARIANT & SECURITY TESTS PASSED SUCCESSFULLY!
```

---

## 4. Key Differentiators of the Prototype

1. **Deterministic Execution First**: Before invoking any complex metaheuristic or machine learning model, PRAYAAN's Stage 1 Deterministic Engine provides immediate, guaranteed feasible routing in **0.2 milliseconds**.
2. **Dual-Bottleneck Fair Division**: Where standard logistics platforms allocate freight solely on weight (disadvantaging dense produce) or volume (disadvantaging bulky crops), PRAYAAN's NMRS mathematical model harmonizes both alongside floor space constraints.
3. **Database-Level Enforced Invariants**: Multi-leg vehicle capacity limits and driver financial anti-tampering guards are enforced at the database kernel level via PL/pgSQL triggers, guaranteeing data integrity even if application services encounter transient faults.

# 07. Implementation Roadmap & Milestones

> **Tech4Bharat 2026** — _Theme 5: Retail, FMCG & Logistics_  
> **Problem Statement 5.3**: Rural Freight  
> **Team**: Kernal500  
> **Last Updated**: November 2026

---

## 1. Guiding Execution Philosophy

> _"Validate locally. Measure rigorously. Scale responsibly."_ — **Slide 7**

Rural freight in Bharat operates in an unforgiving physical environment characterized by unpaved feeder roads, intermittent cellular connectivity, extreme produce perishability, and tight operating margins. **PRAYAAN** follows a disciplined, staged execution methodology moving from an audited architectural prototype to controlled field trials, verified empirical data collection, and regional expansion.

```
+---------------------------------------------------------------------------------------------------+
|                                 FOUR-STAGE DELIVERY ROADMAP                                       |
+---------------------------------------------------------------------------------------------------+
  STAGE 1: WORKING PLATFORM (Current Milestone: Working Prototype Completed)
  - Unified Commerce, Fleet Portal, and Driver Mobile Client architecture
  - Deterministic 3-axis physical capacity audit & integer NMRS fair-share cost mathematics
  - Low-bandwidth loading bay OTP verification & decoupled multi-buyer delivery
  - Status: VERIFIED PROTOTYPE — CODEBASE & DOCUMENTATION COMPLETE
                                 |
                                 v
  STAGE 2: CONTROLLED PILOT & FIELD VALIDATION (Target: Months 1–6)
  - Deployment on single high-density agricultural corridor (Nashik <-> Mumbai, ~165 km)
  - Execution of 120 primary field interviews (Producers, Transporters, Mandi Traders)
  - Cohort: 10 FPOs / Village Aggregators, 25 Commercial Fleets (50 trucks), 20 APMC Buyers
  - Live testing of 6-digit loading OTPs, photo evidence, and offline SQLite synchronization
  - Status: PLANNED — PROTOCOL READY (STATUS: NOT YET CONDUCTED — VALIDATION REQUIRED)
                                 |
                                 v
  STAGE 3: OPERATIONAL HARVESTING & EVIDENCE GATHERING (Target: Months 6–12)
  - Empirical measurement of truck capacity utilization (Target: Elevate from <45% to >=70%)
  - Quantification of actual farmgate freight savings (Target: 30% to 45% reduction)
  - Measurement of deadhead kilometer reduction along the test corridor
  - Software hardening and offline synchronization tuning based on field telemetry
  - Status: PLANNED
                                 |
                                 v
  STAGE 4: SCALABLE RURAL NETWORK & ADVANCED ALGORITHMS (Target: Months 12–24)
  - Integration of ALNS meta-heuristic and 3D Bin Packing engine (as specified in Doc 06)
  - Multi-corridor expansion across 10 major rural agricultural transit belts in Western/Central India
  - Integration with national digital public infrastructure (ULIP / VAHAN / ONDC)
  - Status: PLANNED
+---------------------------------------------------------------------------------------------------+
```

---

## 2. Stage Breakdown & Deliverables

### Stage 1: Working Platform (Current Milestone — Complete)

- **Objective**: Deliver a fully auditable software platform demonstrating the complete commercial transaction, multi-attribute capacity validation, and verifiable physical custody lifecycle.
- **Core Technical Deliverables**:
  1. **Vendor Web Client**: Commodity listing management, AGMARKNET daily modal reference price display, and bilateral RFQ negotiation workflows.
  2. **Fleet Management Portal**: Vehicle compliance registry (RC, fitness, body type), corridor load discovery, 3-axis pooling planner, and driver dispatch.
  3. **Driver Mobile App**: Offline-tolerant execution, local SQLite transaction journal, 6-digit loading bay OTP handshake, load photo evidence capture, and stop-by-stop checklist.
  4. **Core Application API**: Non-floating-point financial calculations (integer paise), PostgreSQL Row-Level Security (RLS), and transactional event outbox.
- **Exit Milestone Gate**: Completed end-to-end multi-stop demonstration verifying that two independent shipments are physically validated, pooled, allocated freight proportionally down to the single paisa, and decoupled at delivery.

---

### Stage 2: Controlled Field Pilot & Field Validation

- **Objective**: Test the platform in live agricultural transport operations along a single arterial corridor and collect empirical baseline field data.
- **Target Corridor**: **Nashik District (Niphad, Yeola, Sinnar) $\leftrightarrow$ Mumbai Metropolitan Region (Vashi APMC, Kalyan Mandi)** (~165 km).
- **Participant Cohort**:
  - **10 Farmer Producer Organizations (FPOs)** representing approximately 1,500 member smallholder farmers.
  - **25 Regional Fleet Operators** representing 50 commercial vehicles (mix of SCVs, LCVs, and 10t ICVs).
  - **20 Wholesale APMC Buyers** operating out of Vashi Terminal Market.
- **Key Focus Areas**:
  - Execute the **120-interview field validation protocol** detailed in [`05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md`](05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md) to replace synthetic assumptions with primary empirical data.
  - Validate mobile client usability in low-literacy rural settings using Hindi and Marathi vernacular interfaces.
  - Test OTP and photo capture reliability in remote farmgate loading docks under spotty 2G/3G connectivity.
- **Exit Milestone Gate**: Successful execution of **100 live pooled commercial trips** with zero lost-custody disputes and verified farmer cost savings.

---

### Stage 3: Operational Hardening & Evidence Gathering

- **Objective**: Quantify real-world operational savings, verify asset utilization improvements, and harden software architecture against field telemetry.
- **Pilot Success Metrics & Verification Standards**:
  1. **Truck Capacity Utilization**: Elevate average payload and cubic volume utilization from the baseline of $< 45\%$ to $\ge 70\%$.
  2. **Measured Freight Cost Savings**: Validate a measurable $30\%\text{ to }45\%$ reduction in per-quintal freight expenses for participating FPO members compared to prevailing dedicated charter rates.
  3. **Empty Running Reduction**: Decrease return deadhead kilometers along the test corridor from $40\%$ to $< 25\%$ through backhaul matching.
  4. **Loading Bay Turnaround Time**: Reduce farmgate loading delays by $\ge 40\%$ through automated pre-arrival cargo readiness gates.
- **Exit Milestone Gate**: Publication of an audited pilot impact report signed by participating FPO leaders and transport union executives.

---

### Stage 4: Scalable Network & Advanced Optimization Layer

- **Objective**: Transition from deterministic corridor matching to dynamic, automated multi-stop optimization across regional transport grids.
- **Key Strategic Initiatives**:
  1. **ALNS & 3D Packing Deployment**: Production rollout of the Adaptive Large Neighborhood Search and 3D Bin Packing heuristics formalized in [`06_AI_ASSISTED_FREIGHT_POOLING_ROADMAP.md`](06_AI_ASSISTED_FREIGHT_POOLING_ROADMAP.md).
  2. **Corridor Grid Expansion**: Replicating the corridor model to 10 high-density rural agricultural corridors:
     - Kolhapur $\leftrightarrow$ Pune (Sugarcane, vegetables, jaggery)
     - Nagpur $\leftrightarrow$ Hyderabad (Oranges, cotton, pulses)
     - Indore $\leftrightarrow$ Ahmedabad (Soybean, wheat, spices)
     - Belagavi $\leftrightarrow$ Bengaluru (Vegetables, maize, commercial crops)
  3. **National Logistics Integration**: Establishing formal API interoperability with India's **Unified Logistics Interface Platform (ULIP)** for automated VAHAN vehicle fitness verification, and the **Open Network for Digital Commerce (ONDC)** for open buyer discovery.
- **Exit Milestone Gate**: A self-sustaining, multi-corridor freight pooling network supporting over 1,000 daily rural shipments with operating profitability.

---

## 3. Milestones & Risk Gate Management

```
+---------------------------------------------------------------------------------------------------+
|                                 MILESTONE GATES & RISK CONTROLS                                   |
+------------------------------------+------------------+------------------+------------------------+
| Milestone Gate                     | Planned Target   | Primary Risk     | Embedded Mitigation    |
+------------------------------------+------------------+------------------+------------------------+
| **Gate 1: Prototype Code Freeze**  | Current Milestone| Architecture     | Deterministic capacity |
|                                    | (Tech4Bharat)    | complexity.      | & integer paise math.  |
|                                    |                  |                  |                        |
| **Gate 2: Field Validation Audit** | Month 3          | Low farmer       | Partner directly with  |
| (120 Primary Interviews)           |                  | digital trust.   | established FPOs/KVKs. |
|                                    |                  |                  |                        |
| **Gate 3: Pilot 100-Trip Run**     | Month 6          | Loading dock     | 60-min wait timeout &  |
| (Nashik <-> Mumbai Corridor)       |                  | delays.          | detention compensation.|
|                                    |                  |                  |                        |
| **Gate 4: Multi-Corridor Scaling** | Month 18         | Driver churn &   | Transparent ₹899 SaaS; |
| (10 Regional Arteries)             |                  | broker pushback. | zero transaction cuts. |
+------------------------------------+------------------+------------------+------------------------+
```

# 05. Business Model, Unit Economics & Risk Controls

> **Tech4Bharat 2026** — *Problem Statement 5.3: Rural Freight*  
> **Team**: Kernal500  

---

## 1. Overview & Commercial Philosophy

A technology solution for rural Bharat cannot succeed if it relies on predatory intermediary commissions or complex transaction cuts that discourage adoption. **PRAYAAN** adopts an ultra-low-friction, predictable SaaS subscription model designed to empower rural micro-enterprises and regional transporters while ensuring financial sustainability and scalability, directly backing **Slide 4** and **Slide 5** of the project pitch deck.

---

## 2. Subscription Pricing Structure

PRAYAAN replaces opaque brokerage fees with straightforward, affordable monthly subscriptions:

```
+---------------------------------------------------------------------------------+
|                       PRAYAAN SaaS Pricing Structure                            |
+---------------------------------------------------------------------------------+
| Stakeholder Tier     | Pricing Structure          | Included Capabilities       |
+----------------------+----------------------------+-----------------------------+
| SELLER SUBSCRIPTION  | ₹149 / month               | - Product listing & catalog |
| (Farmer / Producer)  | (Flat rate)                | - Mandi price benchmarks    |
|                      |                            | - Direct buyer negotiations |
|                      |                            | - Verified loading bay OTP  |
+----------------------+----------------------------+-----------------------------+
| FLEET OWNER          | ₹149 / active vehicle / mo | - Corridor load discovery   |
| SUBSCRIPTION         | (e.g., 10 trucks =         | - Multi-consignment pooling |
|                      |  ₹1,490 / month)           | - Capacity audit planner    |
|                      |                            | - Driver execution tracking |
+----------------------+----------------------------+-----------------------------+
```

*Note: Proposed baseline figures represent market entry models subject to regional pilot validation and stakeholder feedback.*

### Why Per-Active-Vehicle Pricing Matters for Rural Fleets
Small rural fleet owners operate in highly cyclical environments (peak harvest seasons vs. lean summer periods). Charging strictly per *active* listed vehicle ensures operators are never penalized with software overhead for vehicles undergoing seasonal maintenance or idle off-peak phases.

---

## 3. Corridor Unit Economics: Nashik to Mumbai Case Study

To quantify the commercial impact, consider a high-density agricultural transit corridor: **Nashik (Major Onion/Vegetable Hub) $\rightarrow$ Mumbai (Metropolitan Terminal Market)** (~165 km).

### Baseline (Status Quo Without Pooling):
* Two smallholder farmers in Niphad (Nashik) need to move 3 tonnes and 4 tonnes of produce to Vashi APMC (Mumbai).
* Since neither farmer can fill a 10-tonne truck alone and informal brokers charge exorbitant LTL rates, each charters a vehicle independently at the prevailing corridor rate of ₹7,000 per trip.
* **Total Cost to Farmers**: $₹7,000 + ₹7,000 = \mathbf{₹14,000}$
* **Transporter Utilization**: Two 10-tonne trucks travel at 30% and 40% payload capacity, burning double the fuel and producing double the carbon emissions.

### PRAYAAN Shared Pooling Model:
* A fleet owner discovers both requests along the Nashik $\rightarrow$ Mumbai corridor and pools them into a single 10-tonne vehicle.
* **Consolidated Utilization**: Combined 7 tonnes payload (70% weight utilization) and 21 $\text{m}^3$ volume (70% volume utilization).
* **Freight Charge**: Total shared leg freight of ₹7,000.
* **Proportional Fair Allocation**:
  * Farmer A (3t onion load, 30% occupancy): Pays $\mathbf{₹3,000}$ *(₹4,000 direct savings)*
  * Farmer B (4t potato load, 40% occupancy): Pays $\mathbf{₹4,000}$ *(₹3,000 direct savings)*
* **Net Value Creation**:
  * **Farmers**: Realize an immediate **43% to 57% freight cost reduction**, directly increasing farmgate profitability.
  * **Fleet Owner**: Realizes high asset utilization with minimal extra loading stops, while freeing up the second vehicle for a separate profitable haul.
  * **Ecosystem**: 50% reduction in corridor fuel burn, congestion, and vehicle emissions.

---

## 4. Multi-Stakeholder Value Proposition

```
+-----------------------------------------------------------------------------------+
|                        PRAYAAN Value Distribution Matrix                          |
+--------------------+--------------------------------------------------------------+
| Stakeholder        | Measurable Operational & Financial Impact                    |
+--------------------+--------------------------------------------------------------+
| Farmers &          | - Direct access to wholesale buyers without broker cuts      |
| Producers          | - Benchmark mandi prices prevent distressed below-market sales|
|                    | - 40%+ reduction in per-quintal freight transportation costs |
+--------------------+--------------------------------------------------------------+
| Commercial         | - Transparent landed cost estimation with guaranteed slots   |
| Wholesale Buyers   | - Verifiable photo evidence eliminates shipment disputes     |
|                    | - Decoupled multi-drop confirmations prevent delivery gridlock|
+--------------------+--------------------------------------------------------------+
| Fleet              | - Significant reduction in idle truck capacity and dead-head |
| Operators          | - Automated capacity compliance eliminates roadside penalties|
|                    | - Predictable recurring monthly software overhead (₹149/truck)|
+--------------------+--------------------------------------------------------------+
| Drivers            | - Single-screen stop checklist with unambiguous directions   |
|                    | - Verifiable digital OTP handover ends blame for cargo loss  |
|                    | - Offline-first design works in remote zero-network zones    |
+--------------------+--------------------------------------------------------------+
```

---

## 5. Comprehensive Risk Mitigation Matrix

Operational freight deployment in rural environments faces distinct edge cases. PRAYAAN embeds structural risk controls at each layer:

| Operational Risk | Potential Failure Mode | PRAYAAN Embedded Risk Control |
| :--- | :--- | :--- |
| **Cargo Overloading** | Over-weight or over-cube loading causes vehicle damage and fines. | Deterministic 3-axis capacity validation enforces strict caps across all planned route legs. |
| **Cargo Contamination** | Perishable food co-loaded with chemicals or odor-emitting goods. | Automated compatibility predicates reject invalid cargo combinations (e.g., hazmat flags). |
| **Origin Dock Delays** | Farmer delay at loading bay holds up truck and other consignments. | Seller-ready gate: Transporters are only dispatched to pickup points after physical cargo readiness is confirmed. |
| **Remote Connectivity** | Driver cannot access server to confirm loading in village blind spots. | Local SQLite queue stores action records; replayed automatically via idempotent sync upon network return. |
| **Regulatory Ambiguity** | Simulated demo records confused with official GST tax filings. | Explicit `SIMULATED` metadata flags isolate prototype verification records from statutory compliance filings. |

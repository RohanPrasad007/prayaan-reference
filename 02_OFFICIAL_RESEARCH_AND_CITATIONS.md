# 02. Official Research, Policy Benchmarks & Citations

> **Tech4Bharat 2026** — *Problem Statement 5.3: Rural Freight*  
> **Team**: Kernal500  

---

## 1. Overview & Research Basis

The design, economic assumptions, and operational workflows of **PRAYAAN** are grounded in public policy benchmarks, government reports, and statutory regulatory frameworks. This document compiles the research citations, empirical findings, and statutory baselines that inform our architectural decisions, directly supporting **Slide 8** of the project presentation.

---

## 2. Policy & Industry Sources

### A. NITI Aayog & Rocky Mountain Institute (RMI)
* **Report Reference**: *Fast Tracking Freight in India: A Roadmap for Clean and Cost-Effective Goods Transport* (Published June 2021 by NITI Aayog, RMI, and RMI India).
* **Companion Literature**: *Goods on the Move* (NITI Aayog & RMI).
* **Key Empirical Insights**:
  1. **Disproportionate Logistics Costs**: Logistics expenditure in India represents approximately 13% to 14% of Gross Domestic Product (GDP), compared to a benchmark of 8% in mature industrialized economies.
  2. **Dominance of Road Freight**: Road transport carries over 70% of total domestic freight volume in India, driven by flexibility, direct accessibility, and last-mile connectivity into rural regions.
  3. **High Vehicle Underutilization**: Commercial vehicles operating in regional distribution frequently travel with sub-optimal load factors (often below 50% capacity utilization) and experience substantial dead-heading (empty return legs).
  4. **Systemic Economic Impact**: Improving freight transport efficiency, optimizing load aggregation, and reducing empty transit can save the national economy trillions of rupees over the coming decades while mitigating carbon emissions and particulate air pollution.
* **PRAYAAN Design Response**:
  * PRAYAAN directly implements multi-consignment pooling algorithms that consolidate Less-Than-Truckload (LTL) agricultural shipments into high-occupancy single-truck movements along shared arterial corridors, directly targeting the dead-heading and under-utilization inefficiencies cited in the report.

---

### B. Ministry of Agriculture and Farmers Welfare (AGMARKNET & data.gov.in)
* **Institutional Authority**: Agricultural Marketing Information Network (AGMARKNET), Directorate of Marketing & Inspection (DMI), Ministry of Agriculture and Farmers Welfare, Government of India.
* **Platform Reference**: [agmarknet.gov.in](https://agmarknet.gov.in) and Open Government Data Platform India ([data.gov.in](https://data.gov.in)).
* **Key Regulatory & Informational Role**:
  * AGMARKNET aggregates daily wholesale price observations (minimum, maximum, and modal modal prices in ₹/quintal) across registered agricultural produce market committee (APMC) mandis across all Indian states and Union Territories.
* **PRAYAAN Design Response**:
  * **Attributed Market Reference Only**: Mandi observation records are integrated into PRAYAAN strictly as an attributed, timestamped informational baseline for farmers and buyers.
  * **Seller Autonomy**: In strict compliance with fair trade principles, external mandi rates inform users but *never* programmatically override or lock the price set by the rural producer.
  * **Stale Data Disclosure**: Market reference feeds are explicitly flagged with publication dates and freshness indicators to prevent outdated market feeds from distorting real-time negotiations.

---

### C. Goods and Services Tax Network (GSTN) & E-Way Bill System
* **Regulatory Authority**: National Informatics Centre (NIC) and Goods and Services Tax Network (GSTN), Ministry of Finance, Government of India.
* **Statutory Baseline**: Rule 138 of the Central Goods and Services Tax (CGST) Rules, 2017.
* **Core Compliance Rules**:
  1. **Threshold for Issuance**: Generation of an Electronic Way (E-Way) Bill is statutorily mandatory for inter-state and intra-state movement of goods consignments with a consignment value exceeding ₹50,000.
  2. **Two-Part Structure**:
     * **Part A**: Captures supplier and recipient GSTINs, dispatch location, delivery pin code, invoice/document number, value, and HSN code.
     * **Part B (Conveyance Details)**: Captures the vehicle registration number, transporter document number, and driver details for transit validity.
* **PRAYAAN Design Response**:
  * **Clear Simulation Isolation**: In the prototype demonstration environment, demo e-way documentation is explicitly marked as simulated (`DEMO_VERIFIED` / `SIMULATED`), ensuring clear architectural boundaries between operational prototype logic and official government tax infrastructure.
  * **Dual-Stage Handoff Modeling**: Mirroring Part A and Part B conveyance handoffs, PRAYAAN separates cargo preparation from driver vehicle assignment, allowing consignments to be booked and pooled prior to physical truck docking.

---

### D. Geospatial Infrastructure & Address Resolution
* **Services Reference**: OpenRouteService (ORS API) and Department of Posts (India Post National Pincode Directory).
* **Operational Parameters**:
  * Rural postal codes and spatial coordinates provide distance estimations along verified national and state highway networks.
  * Great-circle and road network detour factor modeling ($\approx 1.25\times$ great-circle distance) serves as a planning reference for estimated transit schedules, while preserving negotiated flat or per-kilometer rate contracts between fleet operators and shippers.

---

## 3. Summary of Applied Citations

```
+-------------------------------------------------------------------------------+
|                        PRAYAAN Citation Architecture                          |
+-------------------------------------------------------------------------------+
| Source                        | Core Insight Applied in PRAYAAN               |
+-------------------------------+-----------------------------------------------+
| NITI Aayog / RMI (June 2021)  | Multi-consignment pooling to combat sub-50%   |
|                               | truck load factors and dead-heading.          |
+-------------------------------+-----------------------------------------------+
| AGMARKNET / data.gov.in       | Attributed daily mandi reference prices       |
|                               | providing transparent price discovery.        |
+-------------------------------+-----------------------------------------------+
| GST E-Way System (Rule 138)   | Decoupled booking vs conveyance workflows     |
|                               | with strict simulation labeling in prototype. |
+-------------------------------+-----------------------------------------------+
| OpenRouteService & India Post | Corridor-based distance estimation and postal |
|                               | geocoding without truck-routing assumptions.  |
+-------------------------------+-----------------------------------------------+
```

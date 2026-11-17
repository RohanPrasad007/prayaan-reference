# PRAYAAN: Rural Freight Pooling & Digital Logistics Architecture

> **Tech4Bharat 2026** — *Theme 5: Retail, FMCG & Logistics*  
> **Problem Statement 5.3**: Rural Freight  
> **Team**: Kernal500  

---

## 1. Executive Summary

**PRAYAAN** ("Journey" in Sanskrit) is an open logistics coordination architecture and shared freight pooling framework designed specifically for rural India (*Bharat*). It addresses the structural inefficiencies of agricultural and small-enterprise freight movement: chronic underutilization of commercial vehicles, high logistics expenditures relative to landed goods value, uncoordinated Less-Than-Truckload (LTL) shipments, and lack of verifiable transit custody.

By digitally uniting rural producers, commercial buyers, and regional fleet owners, PRAYAAN converts isolated agricultural shipments into optimized, multi-stop pooled truckloads along shared rural corridors. Every transaction is underpinned by mathematical capacity validation, transparent proportional cost-sharing, and verifiable loading-bay to doorstep chain-of-custody protocols.

```
+-------------------------------------------------------------------------------+
|                                    PRAYAAN                                    |
|                       One Corridor. Shared Truckloads.                        |
+-----------------------+-------------------------------+-----------------------+
|  Producers & Sellers  |     Regional Fleet Owners     |   Wholesale Buyers    |
|   - Crop listing      |    - Corridor discovery       |    - Direct discovery |
|   - Mandi references  |    - Multi-stop pooling       |    - Transparent cost |
|   - Loading bay OTP   |    - Dynamic capacity audit   |    - Proof of handoff |
+-----------------------+-------------------------------+-----------------------+
```

---

## 2. Key Problem & Solution Synthesis

| Domain Challenge | Ground Reality in Bharat | PRAYAAN Architectural Solution |
| :--- | :--- | :--- |
| **High Logistics Cost** | Logistics costs consume 13–14% of GDP due to fragmented freight runs. | Fair-share cost allocation splits shared transit legs proportionally by cargo occupancy. |
| **Empty Backhauls & Underloading** | Rural trucks frequently operate at under 50% capacity or return empty. | Corridor-based open pooling aggregates complementary shipments into single vehicle runs. |
| **Cargo Incompatibilities** | Accidental co-loading of conflicting cargo causes spoilage and claims. | Automated multi-constraint vehicle fit validation (refrigeration, hazmat, body type). |
| **Custody & Handoff Disputes** | Informal paper slips lead to cargo loss, disputes, and delayed payments. | 6-digit loading bay OTP verification and tamper-evident photo proof before departure. |
| **Multi-Buyer Settlement** | Multi-drop deliveries stall when one buyer is unavailable. | Decoupled delivery confirmation allows each buyer to acknowledge only their consignment. |

---

## 3. Submission Documentation Index

This repository contains the complete reference dossier, technical specifications, mathematical models, and operational designs for the PRAYAAN platform:

1. [**Problem Statement & Ground Reality**](01_PROBLEM_STATEMENT_AND_GROUND_REALITY.md): Deep-dive into rural MSME supply chains, agricultural freight bottlenecks, and problem statement 5.3 alignment.
2. [**Official Research & Citations**](02_OFFICIAL_RESEARCH_AND_CITATIONS.md): Synthesis and bibliography of public policy benchmarks, NITI Aayog/RMI logistics studies, AGMARKNET market observations, and statutory GST e-way guidelines.
3. [**Mathematical Model & Pooling Algorithms**](03_MATHEMATICAL_MODEL_AND_POOLING_ALGORITHMS.md): Mathematical formulations of the 3-axis capacity space, multi-attribute occupancy factor, integer-safe proportional cost distribution, and leg contiguity rules.
4. [**System Architecture & Technical Specifications**](04_SYSTEM_ARCHITECTURE_AND_SPECIFICATIONS.md): Tri-client topology, REST API contracts, database authorization models (RLS), and end-to-end custody workflows.
5. [**Business Model & Unit Economics**](05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md): Transparent subscription pricing, corridor economic simulations, stakeholder value propositions, and operational risk mitigation matrix.
6. [**AI-Assisted Freight Pooling Roadmap**](06_AI_ASSISTED_FREIGHT_POOLING_ROADMAP.md): Mathematical formalization of the Multi-Pickup Multi-Delivery Vehicle Routing Problem with Time Windows ($m$-PDVRPTW) and 3D bin packing optimization for future autonomous dispatch.
7. [**Implementation Roadmap & Milestones**](07_IMPLEMENTATION_ROADMAP_AND_MILESTONES.md): Four-stage delivery roadmap from validated prototype to scalable national rural corridor network.

---

## 4. Pitch Deck Cross-Reference

This reference dossier directly supports and elaborates on the claims presented in the accompanying presentation deck (`PRAYAAN-Rural-Freight.pptx`):

| Deck Slide | Topic | Primary Reference Document |
| :---: | :--- | :--- |
| **Slide 1** | Title & Problem Statement | [`01_PROBLEM_STATEMENT_AND_GROUND_REALITY.md`](01_PROBLEM_STATEMENT_AND_GROUND_REALITY.md) |
| **Slide 2** | Proposed Solution & Pooling Rules | [`03_MATHEMATICAL_MODEL_AND_POOLING_ALGORITHMS.md`](03_MATHEMATICAL_MODEL_AND_POOLING_ALGORITHMS.md) |
| **Slide 3** | Technical Approach & Tri-Client Sync | [`04_SYSTEM_ARCHITECTURE_AND_SPECIFICATIONS.md`](04_SYSTEM_ARCHITECTURE_AND_SPECIFICATIONS.md) |
| **Slide 4** | Business Model & Risk Controls | [`05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md`](05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md) |
| **Slide 5** | Impact, Two-Load Plan & Metrics | [`03_MATHEMATICAL_MODEL_AND_POOLING_ALGORITHMS.md`](03_MATHEMATICAL_MODEL_AND_POOLING_ALGORITHMS.md) & [`05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md`](05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md) |
| **Slide 6** | AI-Assisted Freight Pooling | [`06_AI_ASSISTED_FREIGHT_POOLING_ROADMAP.md`](06_AI_ASSISTED_FREIGHT_POOLING_ROADMAP.md) |
| **Slide 7** | Implementation Roadmap | [`07_IMPLEMENTATION_ROADMAP_AND_MILESTONES.md`](07_IMPLEMENTATION_ROADMAP_AND_MILESTONES.md) |
| **Slide 8** | Published Documentation & Sources | [`02_OFFICIAL_RESEARCH_AND_CITATIONS.md`](02_OFFICIAL_RESEARCH_AND_CITATIONS.md) |
| **Slide 9** | Conclusion & Corridors | [`README.md`](README.md) & [`07_IMPLEMENTATION_ROADMAP_AND_MILESTONES.md`](07_IMPLEMENTATION_ROADMAP_AND_MILESTONES.md) |

---

## 5. Repository License & Team Acknowledgement

Developed for **Tech4Bharat 2026** by **Team Kernal500**.  
Distributed under the [MIT License](LICENSE).

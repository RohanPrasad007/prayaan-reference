# Changelog & Technical Audit Register

All notable technical and architectural changes to the **PRAYAAN** repository are documented in this file.

---

## [2026-11-21] — KaTeX Math Mode Fixes & Full Mermaid Architecture Diagrams

### Fixed: KaTeX Math Parse Errors
- **Root Cause**: In markdown renderers, escaped underscores (`\_`) within `\text{...}` blocks in inline LaTeX (`$...$`) decode to literal underscores before reaching KaTeX. In text mode, unescaped `_` causes `KaTeX parse error: '_' allowed only in math mode` (as captured in the user audit screenshot).
- **Files Fixed**:
  - `03_MATHEMATICAL_MODEL_AND_POOLING_ALGORITHMS.md`:
    - Replaced `\text{req\_body}`, `\text{body\_type}`, `\text{req\_refrigeration}`, `\text{is\_hazmat}`, `\text{hazmat\_certified}` with standard mathematical camelCase identifiers: `\text{reqBody}(c)`, `\text{bodyType}(V)`, `\text{reqRefrigeration}(c)`, `\text{isHazmat}(c)`, `\text{hazmatCertified}(V)`.
  - `06_AI_ASSISTED_FREIGHT_POOLING_ROADMAP.md`:
    - Replaced `x_{\text{min\_axle}}, x_{\text{max\_axle}}` with `x_{\text{minAxle}}, x_{\text{maxAxle}}`.
    - Replaced `\text{ORS\_NetworkDistance}` with `\text{ORSNetworkDistance}`.
- **Verification**: Python automated KaTeX regex audit passed across all markdown files with zero errors.

### Upgraded: Complete Elimination of ASCII Art in Favor of Mermaid Diagrams & Native Markdown Tables
- **`01_PROBLEM_STATEMENT_AND_GROUND_REALITY.md`**:
  - Replaced ASCII Indian Rural Freight Ecosystem with a 4-tier Mermaid diagram (`flowchart LR`: Origin Tier $\rightarrow$ Intermediate Consolidation $\rightarrow$ Transit Corridor $\rightarrow$ Terminal Tier).
  - Replaced ASCII Root Causes of Rural Freight Breakdown with a structured Mermaid diagram (`flowchart TD`: Trade Imbalance, Temporal Concentration, Informational Asymmetry, Physical Incompatibility).
  - Replaced ASCII Evidence vs. Assumptions Audit with a 5-tier Mermaid flowchart (`flowchart TD`).
  - Converted ASCII Competitor Differentiation Matrix into a clean, responsive GitHub-flavored Markdown table.
- **`02_OFFICIAL_RESEARCH_AND_CITATIONS.md`**:
  - Added a Mermaid diagram (`flowchart TD`) for the **Statutory & Institutional Source Hierarchy** (Tier 1 Central Statutes $\rightarrow$ Tier 2 Ministerial Surveys $\rightarrow$ Tier 3 Sectoral Baselines $\rightarrow$ Tier 4 Ground Rate Cards).
  - Replaced ASCII Macro vs. Micro Logistics Cost Reconciliation with a Mermaid flowchart (`flowchart TD` comparing 7.97% GDP macro vs. 16.9% MSME micro).
- **`03_MATHEMATICAL_MODEL_AND_POOLING_ALGORITHMS.md`**:
  - Replaced ASCII 3D box with a Mermaid diagram (`flowchart TD`) for the **3-Axis Physical Feasibility Enclosure** ($W_V, U_V, S_V$).
  - Converted ASCII Cost Allocation Mechanism Comparison into a clean Markdown table.
  - Replaced ASCII Freight Rate Inconsistency resolution with a Mermaid diagram (`flowchart TD` comparing ₹3.78/veh-km vs ₹3.78/t-km vs ₹42.42/veh-km).
  - Replaced ASCII Decoupled Cost Flow with a Mermaid diagram (`flowchart LR`).
  - Replaced ASCII Four-Leg Truck Movement Topology with a Mermaid diagram (`flowchart LR`).
- **`04_SYSTEM_ARCHITECTURE_AND_SPECIFICATIONS.md`**:
  - Replaced ASCII 6-Stage Operational State Machine with a Mermaid diagram (`flowchart LR`).
  - Replaced ASCII Offline Synchronization Transaction Flow with a comprehensive Mermaid `sequenceDiagram` (Driver Mobile App, SQLite, Background Sync Worker, API Gateway, PostgreSQL 16 Backend with Idempotency Replay).
  - Replaced ASCII Statutory E-Way Bill & Split-Milestone Payment Architecture with a dual-subgraph Mermaid flowchart (`flowchart TD` with Rule 138 exemption check and 50/50 split-milestone UPI settlement).
- **`05_BUSINESS_MODEL_AND_UNIT_ECONOMICS.md`**:
  - Replaced ASCII SaaS Pricing Philosophy with a Mermaid diagram (`flowchart TD`).
  - Converted ASCII Three-Year Financial Projections into a native Markdown table.
  - Replaced ASCII Field Data to Parameter Mapping with a Mermaid diagram (`flowchart LR`) and Markdown mapping table.
- **`06_AI_ASSISTED_FREIGHT_POOLING_ROADMAP.md`**:
  - Converted ASCII System Boundary Disclosure into a high-visibility GitHub Alert callout box (`> [!IMPORTANT]`).
- **`07_IMPLEMENTATION_ROADMAP_AND_MILESTONES.md`**:
  - Replaced ASCII Four-Stage Delivery Roadmap with a Mermaid diagram (`flowchart TD`).
  - Converted ASCII Milestone Gates & Risk Controls into a clean Markdown table.
- **`README.md`**:
  - Replaced ASCII 3-Sided Coordination Table with a central-orchestration Mermaid diagram (`flowchart TD`).
- **`docs/LIMITATIONS_AND_THREATS.md`**:
  - Replaced ASCII Threat Spectrum with a 3-category Mermaid flowchart (`flowchart TD`: Behavioral & Market Dynamics, Operational & Infrastructure, Legal & Regulatory).

### Validation & Regression Testing
- Ran `make all`:
  - `python3 scripts/verify_cost_allocation.py`: Passed (1,000/1,000 stress tests, 100% core stable).
  - `python3 scripts/benchmark_simulation.py --seeds 42,1337,2026`: Passed (Multi-seed synthetic benchmark).
  - `python3 scripts/unit_economics.py`: Passed (384-subscriber break-even, 87.1% gross margin).
- All 20 Mermaid diagrams verified syntax-valid.

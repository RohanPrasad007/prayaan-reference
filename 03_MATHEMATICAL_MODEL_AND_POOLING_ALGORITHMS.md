# 03. Mathematical Model & Pooling Algorithms

> **Tech4Bharat 2026** — *Problem Statement 5.3: Rural Freight*  
> **Team**: Kernal500  

---

## 1. Overview

At the heart of **PRAYAAN** is a deterministic mathematical framework designed to evaluate vehicle compatibility, verify physical capacity across multi-leg journeys, and allocate transportation costs fairly across pooled shipments. This document details the mathematical formulations and algorithms backing **Slide 2** and **Slide 5** of the project presentation.

---

## 2. Multi-Dimensional Capacity Model

In commercial freight, capacity is rarely constrained by weight alone; volumetric limits ("cubing out") or packaging geometry frequently create bottlenecks before maximum gross vehicle weight is reached.

Let a transport vehicle $V$ possess a capacity profile defined as a 3-tuple:

$$\vec{C}_V = \begin{pmatrix} W_V \\ U_V \\ S_V \end{pmatrix}$$

Where:
* $W_V \in \mathbb{R}^+$ represents maximum rated cargo payload (in kilograms).
* $U_V \in \mathbb{R}^+$ represents usable internal cargo volume (in cubic meters, $\text{m}^3$).
* $S_V \in \mathbb{N}^+$ represents standardized physical planning slots (where 1 slot corresponds to 1% of the vehicle's standard cargo bed footprint, $S_V = 100$).

Each cargo consignment $c \in \mathcal{C}$ is characterized by its physical demands:

$$\vec{d}_c = \begin{pmatrix} w_c \\ u_c \\ s_c \end{pmatrix}$$

Where $w_c$ is cargo weight (kg), $u_c$ is volume ($\text{m}^3$), and $s_c$ is the package slot equivalent.

---

## 3. Multi-Attribute Occupancy Factor

To determine the true consumption of vehicle capacity by an individual consignment $c$ loaded on vehicle $V$, PRAYAAN defines the **Occupancy Factor** $\text{Occ}(c, V)$ as the maximum demand ratio across all three resource dimensions:

$$\text{Occ}(c, V) = \max \left( \frac{w_c}{W_V}, \frac{u_c}{U_V}, \frac{s_c}{S_V} \right)$$

### Properties:
1. **Dimension Neutrality**: If a bulky consignment consumes 60% of the volume but only 20% of the weight, its occupancy factor evaluates to $0.60$.
2. **Resource Monotonicity**: Adding any cargo dimension strictly increases or maintains the occupancy factor: $\vec{d}_a \le \vec{d}_b \implies \text{Occ}(a, V) \le \text{Occ}(b, V)$.
3. **Safety Bound**: A single consignment is physically admissible only if $\text{Occ}(c, V) \le 1.0$.

---

## 4. Leg-Wise Admissibility & Capacity Verification

A pooled trip $\mathcal{T}$ comprises an ordered sequence of $M$ route stops $\langle \sigma_0, \sigma_1, \dots, \sigma_M \rangle$, creating $M-1$ contiguous legs $\mathcal{L} = \{ \ell_1, \ell_2, \dots, \ell_{M-1} \}$.

Let $\mathcal{C}_{\ell_k} \subseteq \mathcal{C}$ denote the set of active consignments on board the vehicle during transit along leg $\ell_k = (\sigma_{k-1}, \sigma_k)$.

### Feasibility Conditions
For each leg $\ell_k \in \mathcal{L}$, the aggregate cargo must simultaneously satisfy three linear inequalities:

$$\sum_{c \in \mathcal{C}_{\ell_k}} w_c \le W_V$$

$$\sum_{c \in \mathcal{C}_{\ell_k}} u_c \le U_V$$

$$\sum_{c \in \mathcal{C}_{\ell_k}} s_c \le S_V$$

If any condition is violated on any leg, the pooled route candidate is rejected with an explicit `CAPACITY_EXCEEDED` violation.

---

## 5. Vehicle Compatibility Predicates

Physical capacity alone is insufficient for agricultural and rural goods; environmental and regulatory constraints must be strictly enforced. A vehicle $V$ is deemed compatible with cargo $c$ if and only if:

$$\text{Fits}(V, c) = \text{MatchBody}(V, c) \land \text{MatchCool}(V, c) \land \text{MatchHaz}(V, c) \land \text{MatchDim}(V, c)$$

Where:
* $\text{MatchBody}(V, c) \iff (\text{req\_body}(c) = \emptyset) \lor (\text{body\_type}(V) = \text{req\_body}(c))$
* $\text{MatchCool}(V, c) \iff \text{req\_refrigeration}(c) \implies \text{refrigerated}(V)$
* $\text{MatchHaz}(V, c) \iff \text{is\_hazmat}(c) \implies \text{hazmat\_permitted}(V)$
* $\text{MatchDim}(V, c) \iff \text{max\_package\_length}(c) \le \text{max\_cargo\_length}(V)$

---

## 6. Proportional Fair-Share Cost Allocation Algorithm

When multiple consignments share a transit leg $\ell_k$ incurring a total freight cost $K_{\ell_k}$ (calculated in integer minor units, i.e., paise):

$$K_{\ell_k} = \left\lfloor \frac{\text{Distance}(\ell_k) \cdot \text{RatePerKm} \cdot \text{Multiplier}_{\text{body}}}{10^7} \right\rfloor + \text{Tolls}_{\ell_k}$$

The cost is distributed among active consignments according to their relative occupancy shares:

$$\alpha_i = \text{Occ}(c_i, V) \quad \text{for } c_i \in \mathcal{C}_{\ell_k}$$

$$\text{Normalized Weight: } \omega_i = \frac{\alpha_i}{\sum_{j} \alpha_j}$$

### Integer Arithmetic Precision & Remainder Preservation
To prevent financial discrepancies caused by floating-point rounding errors, the allocation uses high-precision integer scaling ($10^9$ scaling factor):

1. Compute integer weight: $\Omega_i = \text{round}\left( \frac{\alpha_i}{\sum_j \alpha_j} \times 10^9 \right)$
2. Compute allocated share: $A_i = \left\lfloor \frac{K_{\ell_k} \cdot \Omega_i}{\sum_j \Omega_j} \right\rfloor$
3. Compute residual difference: $\Delta = K_{\ell_k} - \sum_j A_j$
4. Allocate residual $\Delta$ to the final consignment: $A_{\text{last}} \leftarrow A_{\text{last}} + \Delta$

$$\sum_{i} A_i \equiv K_{\ell_k} \quad (\text{Exact balance to the last paisa})$$

---

## 7. Numerical Walkthrough: The Two-Load Illustrative Case

The following example formalizes the scenario presented on **Slide 5** of the project pitch deck:

### Vehicle Profile
* **Vehicle Type**: Standard 10-Tonne Intermediate Commercial Vehicle (ICV).
* **Rated Payload ($W_V$)**: $10\text{ tonnes} = 10,000\text{ kg}$.
* **Usable Volume ($U_V$)**: $30\text{ m}^3$.
* **Standard Planning Slots ($S_V$)**: $100\text{ slots}$.

### Consignment Profiles
* **Load A (Farmer A — e.g., Onions)**:
  * Weight ($w_A$): $3,000\text{ kg}$ ($3\text{ t}$)
  * Volume ($u_A$): $9\text{ m}^3$
  * Slots ($s_A$): $30\text{ slots}$
  * Individual Occupancy: $\text{Occ}(A) = \max\left(\frac{3}{10}, \frac{9}{30}, \frac{30}{100}\right) = \max(0.30, 0.30, 0.30) = 0.30$

* **Load B (Farmer B — e.g., Potatoes)**:
  * Weight ($w_B$): $4,000\text{ kg}$ ($4\text{ t}$)
  * Volume ($u_B$): $12\text{ m}^3$
  * Slots ($s_B$): $20\text{ slots}$
  * Individual Occupancy: $\text{Occ}(B) = \max\left(\frac{4}{10}, \frac{12}{30}, \frac{20}{100}\right) = \max(0.40, 0.40, 0.20) = 0.40$

### Combined Trip Utilization
* **Total Weight**: $3\text{ t} + 4\text{ t} = 7\text{ t} \le 10\text{ t}$ $\rightarrow$ **70% Utilization**
* **Total Volume**: $9\text{ m}^3 + 12\text{ m}^3 = 21\text{ m}^3 \le 30\text{ m}^3$ $\rightarrow$ **70% Utilization**
* **Total Slots**: $30 + 20 = 50\text{ slots} \le 100\text{ slots}$ $\rightarrow$ **50% Utilization**

### Economic Comparison
* **Separate Dispatch Model (Status Quo)**:
  * Load A charters dedicated truck: $₹7,000$
  * Load B charters dedicated truck: $₹7,000$
  * **Total Shippers' Outlay**: $₹14,000$ (with two trucks running half-empty)
* **PRAYAAN Shared Pooling Model**:
  * Total Shared Leg Freight: $₹7,000$
  * Aggregate Occupancy: $\alpha_A + \alpha_B = 0.30 + 0.40 = 0.70$
  * Share of Load A: $\frac{0.30}{0.70} \times ₹7,000 = \mathbf{₹3,000}$ *(57% savings)*
  * Share of Load B: $\frac{0.40}{0.70} \times ₹7,000 = \mathbf{₹4,000}$ *(43% savings)*
  * **Total Shippers' Outlay**: $\mathbf{₹7,000}$ *(Overall 50% systemic cost reduction)*

---

## 8. Route Leg Contiguity Theorem

In a multi-stop pooled freight corridor, consignments cannot disappear and reappear across non-adjacent legs. 

For every consignment $c \in \mathcal{C}$, let $\text{Legs}(c) \subseteq \mathcal{L}$ be the indices of legs where $c$ is present. PRAYAAN validates that:

$$\max(\text{Legs}(c)) - \min(\text{Legs}(c)) + 1 = |\text{Legs}(c)|$$

This guarantees continuous custody from the pickup stop to the destination drop stop, rejecting disjointed route sequences at the planning gate.

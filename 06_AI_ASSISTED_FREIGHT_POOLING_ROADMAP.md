# 06. AI-Assisted Freight Pooling: Mathematical Formulation & Roadmap

> **Tech4Bharat 2026** — *Problem Statement 5.3: Rural Freight*  
> **Team**: Kernal500  

---

## 1. System Boundary & Integrity Disclosure

> **Integrity Notice (Directly backing Slide 6)**:  
> PRAYAAN’s current operational prototype implements deterministic rule-based verification, capacity auditing, and fair-share cost mathematics. The advanced AI-driven pooling optimization outlined in this document represents our **Stage 4 Planned Enhancement Layer**. In strict adherence to academic honesty and hackathon integrity guidelines, no unverified benchmark percentages or black-box model claims are made.

---

## 2. The Algorithmic Challenge

In manual dispatch, finding compatible shared shipments across dozens of independent rural farmers and buyers is computationally intractable. A scalable system must solve a joint combinatorial optimization problem combining **Multi-Pickup Multi-Delivery Vehicle Routing with Time Windows ($m$-PDVRPTW)** and the **3D Bin Packing Problem (3D-BPP)** under dynamic agricultural constraints.

```
+-------------------------------------------------------------------------------+
|                    AI-Assisted Freight Pooling Pipeline                       |
+-------------------------------------------------------------------------------+
  [Step 1: Ingestion]      Collect pickup, destination, weight, volume, deadlines
           |
           v
  [Step 2: Clustering]     Filter compatible shipments along shared road corridors
           |
           v
  [Step 3: Audit]          Verify 3-axis truck capacity and cargo compatibility
           |
           v
  [Step 4: Routing]        Evaluate detour bounds, road topologies & time windows
           |
           v
  [Step 5: Optimization]   Recommend optimal shared combinations (ALNS / Heuristics)
           |
           v
  [Step 6: Allocation]     Generate transparent, fair-share freight cost splits
+-------------------------------------------------------------------------------+
```

---

## 3. Mathematical Optimization Formulation

Let $\mathcal{K}$ be the set of available commercial vehicles, each with capacity vector $\vec{C}_k = (W_k, U_k, S_k)^T$.  
Let $\mathcal{R}$ be the set of pending shipment requests. Each request $r \in \mathcal{R}$ consists of:
* Pickup node $p_r \in \mathcal{V}^+$ with time window $[e_{p_r}, l_{p_r}]$ and service duration $s_{p_r}$.
* Delivery node $d_r \in \mathcal{V}^-$ with time window $[e_{d_r}, l_{d_r}]$ and service duration $s_{d_r}$.
* Cargo demand vector $\vec{d}_r = (w_r, u_r, s_r)^T$.
* Compatibility profile $\gamma_r$ (refrigeration, hazmat, body type).

Let $x_{ij}^k \in \{0, 1\}$ be a decision variable indicating whether vehicle $k$ travels directly from node $i$ to node $j$.  
Let $y_r^k \in \{0, 1\}$ indicate whether request $r$ is served by vehicle $k$.  
Let $T_i^k \ge 0$ denote the arrival time of vehicle $k$ at node $i$.

### Objective Function
Minimize total system travel cost, detour overhead, and unserviced shipment penalties:

$$\min \sum_{k \in \mathcal{K}} \sum_{i \in \mathcal{V}} \sum_{j \in \mathcal{V}} c_{ij}^k x_{ij}^k + \lambda \sum_{r \in \mathcal{R}} \left( 1 - \sum_{k \in \mathcal{K}} y_r^k \right) \cdot \text{Penalty}_r$$

Where:
* $c_{ij}^k$ is the fuel and road toll cost for vehicle $k$ traversing edge $(i, j)$.
* $\lambda \gg 1$ is a heavy penalty multiplier discouraging unassigned shipments.

### Primary Operational Constraints:
1. **Flow Conservation**:
   $$\sum_{j \in \mathcal{V}} x_{oj}^k = 1, \quad \sum_{i \in \mathcal{V}} x_{ie}^k = 1 \quad \forall k \in \mathcal{K}$$
2. **Precedence Constraint** (Pickup must precede delivery on the same vehicle):
   $$T_{p_r}^k + s_{p_r} + t_{p_r, d_r} \le T_{d_r}^k \quad \forall r \in \mathcal{R}, \forall k \in \mathcal{K} \text{ where } y_r^k = 1$$
3. **Time Window Adherence**:
   $$e_i \le T_i^k \le l_i \quad \forall i \in \mathcal{V}, \forall k \in \mathcal{K}$$
4. **Cumulative Capacity Envelope**:
   $$\sum_{r \in \mathcal{R} \text{ on board at } i} \vec{d}_r \le \vec{C}_k \quad \forall i \in \mathcal{V}, \forall k \in \mathcal{K}$$
5. **Physical Cargo Compatibility**:
   $$\text{Fits}(k, r) = \text{True} \quad \forall r \in \mathcal{R} \text{ where } y_r^k = 1$$

---

## 4. Algorithmic Roadmap for AI Layer

To achieve real-time response times without requiring supercomputing infrastructure, the AI pooling system will deploy a tiered heuristic pipeline:

### Tier 1: Spatial-Temporal Corridor Clustering
* High-dimensional DBSCAN / HDBSCAN clustering applied to origin-destination spatial coordinates and allowable departure windows.
* Restricts pairing candidates strictly to shipments sharing identical arterial highway corridors, pruning 95% of infeasible combinatorial pairings.

### Tier 2: Adaptive Large Neighborhood Search (ALNS)
* Deploying destroy and repair heuristics:
  * **Shaw Removal**: Selectively unassigns shipments with high spatial-temporal correlation to re-pool them into denser clusters.
  * **Regret-k Insertion**: Reassigns shipments based on the difference in cost between best and second-best insertion positions.

### Tier 3: 3D Bin Packing & Axle Weight Heuristics
* Ensures physical stability of mixed agricultural produce inside the cargo bed:
  * Heavier bags (e.g., grain sacks, potatoes) positioned on floor slots over axles.
  * Fragile, perishable produce (e.g., tomatoes, leafy vegetables) positioned on upper layers.
  * First-Off, Last-On (FILO) stacking order matching the stop delivery sequence.

---

## 5. Agentic Coordination Layer

For future scalable deployments, multi-agent coordination will automate multi-party negotiations:
* **Shipper Agent**: Represents farmer's time constraints and reserve price bounds.
* **Transporter Agent**: Represents fleet operator's schedule, fuel economy, and corridor preference.
* **Corridor Coordinator Agent**: Resolves multi-party pooling matches, ensuring pareto-optimal allocation where every participant realizes lower cost or higher profit compared to independent runs.

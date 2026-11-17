# 04. System Architecture & Technical Specifications

> **Tech4Bharat 2026** — *Problem Statement 5.3: Rural Freight*  
> **Team**: Kernal500  

---

## 1. Architectural Philosophy

The **PRAYAAN** system architecture is designed around three fundamental principles:
1. **Unified Transactional Record**: One shared PostgreSQL database and REST API power the commercial marketplace, fleet dispatch, and driver execution layers, eliminating discrepancies between order contracts and physical transport manifests.
2. **Offline Resilience for Rural Infrastructure**: Recognizing erratic cellular connectivity in rural farming belts, client workflows utilize idempotent commands and asynchronous queueing.
3. **Defense-in-Depth Tenant Security**: All data access is strictly bounded by PostgreSQL Row-Level Security (RLS) and cryptographic business role verification.

---

## 2. System Topology

```
+-----------------------------------------------------------------------------------+
|                                  CLIENT LAYER                                     |
+--------------------------+------------------------------+-------------------------+
|     Vendor Web App       |     Fleet Management Web     |   Driver Mobile Client  |
| (Buyers & Sellers)       | (Operators & Dispatchers)    | (Android / Low-Bandwidth|
| - Crop catalogue         | - Fleet vehicle management   | - Offline queueing      |
| - Mandi price references | - Open-pool load discovery   | - Loading OTP handoff   |
| - Order & RFQ lifecycle  | - Multi-consignment routing  | - Media photo evidence  |
+--------------------------+------------------------------+-------------------------+
                                        | (HTTPS / REST / WSS)
                                        v
+-----------------------------------------------------------------------------------+
|                             API & APPLICATION SERVICES                            |
| - Authentication & RBAC Service (Session OTP & Business Capability Tokens)        |
| - Commerce Engine (Catalogs, Orders, RFQs, Non-floating-point Paise Billing)      |
| - Dispatch & Pooling Engine (Multi-Constraint Capacity Audit & Proportional Split)|
| - Chain-of-Custody Service (OTP Verification, Storage Intents, Delivery Proof)   |
| - Outbox Event Processor (Asynchronous Domain Event Notification Dispatch)        |
+-----------------------------------------------------------------------------------+
                                        | (SQL / RLS / Connection Pool)
                                        v
+-----------------------------------------------------------------------------------+
|                                PERSISTENCE LAYER                                  |
| - PostgreSQL 16+ Database with Granular Row-Level Security (RLS) Policies         |
| - Transactional Outbox Queue for Reliable Event Dissemination                     |
| - Private Media Storage with Signed Temporary Access Credentials                  |
+-----------------------------------------------------------------------------------+
```

---

## 3. End-to-End Operational Lifecycle

The platform coordinates a six-stage transition from initial crop harvest to final buyer acceptance, directly supporting **Slide 3** of the presentation:

```
[01 LIST]  --->  [02 AGREE]  --->  [03 CONFIRM]  --->  [04 CLAIM]  --->  [05 PICKUP]  --->  [06 DELIVER]
 Farmer posts     Buyer agrees       Order advance      Fleet owner        Driver verifies    Buyer verifies
 crop with        on terms or        opens unassigned   pools compatible   6-digit loading    delivery OTP &
 pickup origin    negotiates         request in pool    loads to trip      OTP & evidence     confirms order
```

### Stage 01: Crop Listing (`LIST`)
* The farmer or seller lists produce specifying commodity classification, unit price (in integer paise), available quantity, and geographic pickup origin location.
* Mandi benchmark prices from AGMARKNET are displayed side-by-side as market context, preserving seller pricing autonomy.

### Stage 02: Commercial Negotiation (`AGREE`)
* Buyers browse listings or submit Requests for Quotations (RFQs).
* Bilateral negotiations converge into an agreed commercial contract with specified delivery destination city and target delivery dates.

### Stage 03: Order Advance & Request Creation (`CONFIRM`)
* Buyer commits an initial order deposit.
* The system snapshots order specifications and creates an unassigned **Transport Request** broadcast immediately to the open fleet pool for that corridor.

### Stage 04: Corridor Pooling & Assignment (`CLAIM`)
* A fleet operator reviews open requests along their active service corridors.
* The pooling engine tests multiple consignments against a chosen vehicle profile for capacity, weight, volume, slots, and body-type compatibility.
* Once validated, the trip is generated, freight costs are allocated, and a driver is assigned.

### Stage 05: Loading Bay Custody Verification (`PICKUP`)
* At the village origin dock, the seller generates a time-bounded, 6-digit cryptographic verification code.
* The assigned driver enters the code on their mobile app and attaches mandatory loading-bay photo evidence before vehicle departure.
* The backend strictly forbids the driver from initiating the trip until all pooled consignments on that leg have been verified.

### Stage 06: Decoupled Multi-Buyer Delivery (`DELIVER`)
* Upon arrival at respective drop-off stops, each buyer receives their specific delivery verification code.
* When Buyer A enters their delivery confirmation code, Consignment A marks as `DELIVERED` and releases funds to Seller A, while Consignment B remains active on the vehicle until verified at the subsequent stop.
* The trip automatically closes to `COMPLETED` once all consignments are finalized.

---

## 4. Security & Data Isolation Specifications

### A. Row-Level Security (RLS) Matrix
PostgreSQL RLS policies are strictly applied at the database engine level, ensuring that even if an application route check were compromised, data isolation remains impenetrable:

| Entity Table | Buyer Access | Seller Access | Fleet Owner Access | Driver Access |
| :--- | :--- | :--- | :--- | :--- |
| `app.listings` | Read (Published) | Full CRUD (Own) | Read (Published) | Read (Published) |
| `app.orders` | Read/Update (Own) | Read/Update (Own) | None | None |
| `app.consignments` | Read (Own order) | Read (Own order) | Read (Assigned) | Read (Assigned) |
| `app.trips` | None | None | Full CRUD (Own) | Read/Action (Assigned)|
| `app.media_assets` | Read (Own cargo) | Read (Own cargo) | Read (Own trip) | Create/Read (Assigned)|

### B. Integer Financial Guarantee
To eliminate catastrophic floating-point rounding errors common in monetary systems, all financial calculations (goods value, freight allocations, toll levies, platform subscriptions) are executed exclusively in **integer minor units** (paise):

```typescript
// Authorization Rule: Floating-point rupees are strictly prohibited in core domains
type CurrencyMinor = bigint; // 1 INR = 100 Paise
```

---

## 5. Offline Fault Tolerance Protocol

In rural environments with zero or intermittent mobile network reception:
1. **Local Action Journal**: The driver application writes critical state transitions (e.g., GPS timestamp, custody status, photo metadata) to an encrypted on-device SQLite transaction journal.
2. **Idempotency Envelope**: Every network request carries a UUID-v4 idempotency key.
3. **Atomic Catch-Up Sync**: When mobile connectivity is re-established, the journal replays pending events in strict causal order. Replayed requests that were already processed return the cached server confirmation without duplicating database mutations.

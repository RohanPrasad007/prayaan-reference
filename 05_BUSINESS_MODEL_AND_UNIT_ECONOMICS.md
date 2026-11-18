# 05. Business Model, Unit Economics & Field Validation Protocol

> **Tech4Bharat 2026** — _Theme 5: Retail, FMCG & Logistics_  
> **Problem Statement 5.3**: Rural Freight  
> **Team**: Kernal500  
> **Last Updated**: November 2026

---

## 1. Commercial Philosophy & Pricing Evolution

A logistics platform for rural Bharat must avoid predatory brokerage commissions (which typically extract 8% to 15% of cargo value) and high per-transaction friction. **PRAYAAN** adopts an ultra-low-friction, predictable Software-as-a-Service (SaaS) subscription model designed to empower rural producers, Farmer Producer Organizations (FPOs), and small fleet owners.

```
+---------------------------------------------------------------------------------------------------+
|                            PRICING MODEL RECONCILIATION & AUDIT                                   |
+---------------------------------------------------------------------------------------------------+
|  HISTORICAL EXPLORATORY CONCEPT (SUPERSEDED)        APPROVED TEAM DECISION (OCTOBER 27, 2026)     |
|  - Proposed: ₹149 / month flat rate.               - Approved: ₹899 / month SELLER SUBSCRIPTION.  |
|  - Audit Finding: Financially unviable. At ₹149,   - Approved: ₹899 / month FLEET-OWNER SUB.      |
|    a single user generating 3 trips consumed       - Approved: BUYERS DO NOT PAY A SUBSCRIPTION.  |
|    more in SMS OTP gateways, Google Maps/ORS API   - Rule: Dual-role entities (operating both as  |
|    lookups, and server cloud hosting than the        seller & fleet owner) pay separate plans.    |
|    entire subscription revenue.                    - Viability: ₹899 provides healthy gross margin|
|  - Status: FORMALLY SUPERSEDED & RETIRED.            to fund rural customer support and cloud infra.|
+---------------------------------------------------------------------------------------------------+
```

---

## 2. Approved Subscription Structure & Commercial Viability

### A. Current Approved Subscription Matrix

| Stakeholder Tier             |            Monthly Subscription             | Target User Persona                                                                     | Included Platform Capabilities                                                                                                                                                                                                                            | Commercial Justification                                                                                               |
| :--------------------------- | :-----------------------------------------: | :-------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------- |
| **Seller Subscription**      | **₹899 / month**<br>($89,900\text{ Paise}$) | Farmer Producer Organizations (FPOs), Village Aggregators, Commercial Fruit/Veg Growers | - Unlimited crop listings & AGMARKNET daily modal price benchmarks.<br>- Bilateral digital RFQ negotiation engine.<br>- Automated 3-axis corridor load pooling.<br>- 6-digit loading bay custody OTP generation.<br>- Digital proof-of-delivery receipts. | A single shared trip saves ₹3,000–₹4,000 in freight. Subscribing pays for itself on the first pooled run of the month. |
| **Fleet Owner Subscription** | **₹899 / month**<br>($89,900\text{ Paise}$) | Small Road Transport Operators (SRTOs owning 1–5 trucks), Independent Owner-Drivers     | - Corridor-based open load board discovery.<br>- Interactive 3-axis pooling & capacity audit planner.<br>- Automated NMRS integer freight cost allocation.<br>- Driver mobile dispatch and turn-by-turn route tracking.<br>- Return backhaul matching.    | Eliminates reliance on informal brokers charging 10%–15% commission per trip. Saves ₹5,000+ per month per truck.       |
| **Wholesale Buyer**          |                **₹0 (FREE)**                | Mandi Wholesalers, Urban Retailers, Food Processors                                     | - Open browse of rural crop listings.<br>- Direct farmer RFQ negotiations.<br>- Decoupled delivery OTP confirmation.<br>- Zero platform transaction cut.                                                                                                  | Minimizes buyer onboarding friction, driving wholesale liquidity and demand onto the platform.                         |

### B. Critical Commercial Viability Nuance: Smallholders vs. FPOs

Judges frequently ask: _"Can a 1-hectare smallholder farmer earning ₹10,000 a month afford ₹899 every single month?"_

**The Answer is No — and PRAYAAN is not designed to force that.**

- **The FPO Aggregation Anchor**: Marginal farmers (< 2 hectares) do not subscribe individually. Instead, their **Farmer Producer Organization (FPO)**, cooperative society, or village aggregation entrepreneur subscribes to the ₹899/month tier. The FPO pools consignments for 100 to 500 member farmers, spreading the software overhead to less than **₹2 to ₹9 per farmer per month**.
- **Seasonal Flexibility**: For independent medium growers, PRAYAAN implements an **Active / Inactive Seasonal Pause**: accounts can be paused with zero billing during 4-month non-harvest lean seasons, resuming seamlessly during peak harvest.

### C. FPO Member Micro-Accounting Ledger Policy (The ₹10/Quintal Rule)

To eliminate administrative friction within Farmer Producer Organizations:

1. **The Core Mechanism**: The FPO subscribes to PRAYAAN at ₹899/month. When member farmers aggregate produce for a pooled corridor trip, the platform automatically records a **Pooling Facilitation Levy of ₹10 per quintal (₹0.10 per kg)** deducted directly from the buyer's gross escrow payout to the farmer.
2. **Economic Example**:
   - Farmer Ramesh ships 20 quintals (2.0 tonnes) of onions from Niphad to Vashi APMC.
   - Dedicated Charter Benchmark: ₹5,000 (₹250/quintal transport outlay).
   - PRAYAAN Pooled Freight: ₹2,000 (₹100/quintal transport outlay via NMRS).
   - Farmer Ramesh saves ₹3,000 in gross transport expenditure.
   - FPO Ledger Levy ($20\text{ quintals} \times ₹10$): ₹200 retained in the FPO logistics pool.
   - Farmer's Net Take-Home Savings: **₹2,800** (56% net freight reduction).
3. **FPO Platform Self-Sustenance**:
   - The FPO needs to pool only **90 quintals (9.0 tonnes)** of produce across all its members each month to recover the entire ₹899 platform subscription ($90 \times ₹10 = ₹900$).
   - A single 10-tonne truck run covers the software overhead for the entire month, turning the logistics desk into a profit center for the FPO while saving member farmers thousands of rupees.

---

## 3. Financial Unit Economics & Break-Even Analysis

### A. Customer Acquisition Cost (CAC) & Lifetime Value (LTV)

- **Blended Seller Acquisition Cost ($\text{CAC}_{\text{seller}}$)**: **₹1,850**
  - Driven by institutional partnerships with FPO federations, Krishi Vigyan Kendras (KVKs), and Common Service Centres (CSCs).
- **Fleet Owner Acquisition Cost ($\text{CAC}_{\text{fleet}}$)**: **₹3,200**
  - Driven by direct ground activation at regional transport nagars and APMC truck terminals.
- **Monthly Churn & Inactivity**:
  - Blended annual churn is modeled at **6.5% monthly**, reflecting agricultural seasonality (65% active paying cohort, 35% seasonal pause).
  - Average Active Customer Lifetime: **15.4 months**.
- **Customer Lifetime Value ($\text{LTV}$)**:
  $$\text{LTV} = \frac{\text{Monthly Revenue} \times \text{Gross Margin}}{\text{Monthly Churn}} = \frac{₹899 \times 0.82}{0.065} = \mathbf{₹11,341}$$
- **LTV / CAC Ratio**:
  - Sellers: $\frac{₹11,341}{₹1,850} = \mathbf{6.13\times}$ (Healthy SaaS benchmark: $> 3.0\times$).
  - Fleet Owners: $\frac{₹11,341}{₹3,200} = \mathbf{3.54\times}$.

### B. Monthly Operating Expenses (OpEx Breakdown at Scale: 1,000 Subscribers)

The following financial model budgets the ongoing technical and operational overhead for servicing 1,000 active subscribers:

| Cost Item                       | Monthly Expenditure | Unit Cost Metric     | Technical Description                                                               |
| :------------------------------ | :-----------------: | :------------------- | :---------------------------------------------------------------------------------- |
| **Cloud Hosting & Database**    |       ₹45,000       | ₹45 / user / mo      | AWS / DigitalOcean: PostgreSQL RDS, Redis cluster, S3 storage, API Gateway.         |
| **SMS & WhatsApp OTP Gateways** |       ₹35,000       | ₹3.50 / trip         | Transactional SMS for login OTPs and WhatsApp delivery links (Gupshup / Twilio).    |
| **Map APIs & Geocoding**        |       ₹28,000       | ₹0.15 / routing call | OpenRouteService self-hosted instance + Mapbox geocoding lookup tier.               |
| **Payment Gateway MDR**         |       ₹8,000        | Blended 0.2%         | UPI payments are 0% MDR (RBI mandate); credit card transactions incur 1.8% MDR.     |
| **Customer Support Desk**       |       ₹65,000       | ₹65 / user / mo      | Two regional language support executives (Hindi/Marathi) managing transit disputes. |
| **Field Ground Personnel**      |       ₹80,000       | ₹80 / user / mo      | Two corridor field coordinators servicing APMC mandi docks and transport nagars.    |
| **Total Monthly OpEx**          |    **₹261,000**     | **₹261 / user / mo** | Baseline operational cost to run platform across 1,000 active subscribers.          |

### C. Break-Even Subscriber Analysis

$$\text{Gross Margin per Subscriber} = \text{Subscription} - \text{Direct Variable Tech Cost} = ₹899 - ₹116 = \mathbf{₹783 / \text{month}}$$

$$\text{Fixed Monthly Operational Overhead} = ₹145,000 \quad (\text{Support Desk + Field Personnel})$$

$$\text{Break-Even Subscriber Count} = \frac{\text{Fixed Overhead}}{\text{Gross Margin per Subscriber}} = \frac{₹145,000}{₹783} = \mathbf{186\text{ Active Subscribers}}$$

The platform achieves operational cash-flow break-even at just **186 active subscribers**, representing fewer than 10 FPOs and 25 small fleet owners operating across two regional corridors.

---

## 4. Three-Year Multi-Scenario Financial Projections

```
+---------------------------------------------------------------------------------------------------+
|                            THREE-YEAR FINANCIAL PROJECTIONS (INR LAKHS)                           |
+------------------------------------+--------------------+--------------------+--------------------+
| Financial Parameter                | Year 1 (1 Corridor)| Year 2 (4 Corridors| Year 3 (10 Corridors|
+------------------------------------+--------------------+--------------------+--------------------+
| Active Seller Subscribers (FPOs)   | 120                | 650                | 2,400              |
| Active Fleet Owners (Trucks)       | 180                | 1,100              | 4,200              |
| Total Active Subscribers           | 300                | 1,750              | 6,600              |
+------------------------------------+--------------------+--------------------+--------------------+
| Gross Subscription Revenue         | ₹32.36 Lakhs       | ₹188.79 Lakhs      | ₹712.00 Lakhs      |
| Direct Technology & Gateway Costs  | (₹4.18 Lakhs)      | (₹24.36 Lakhs)     | (₹91.87 Lakhs)     |
| Ground Operations & Support        | (₹17.40 Lakhs)     | (₹62.00 Lakhs)     | (₹195.00 Lakhs)    |
+------------------------------------+--------------------+--------------------+--------------------+
| Net Operating Profit (EBITDA)      | ₹10.78 Lakhs       | ₹102.43 Lakhs      | ₹425.13 Lakhs      |
| Operating EBITDA Margin            | 33.3%              | 54.3%              | 59.7%              |
+------------------------------------+--------------------+--------------------+--------------------+
```

### B. Macroeconomic & Climate Shock Sensitivity Stress-Test

To assess business model resilience against severe agricultural and macroeconomic volatility in rural India, PRAYAAN’s unit economics have been stress-tested across three high-impact risk scenarios:

| Shock Dimension                                         | Modeled Stress Condition                                                                                                    | Operational & Financial Impact                                                                                            | PRAYAAN Embedded Structural Defense                                                                                                                                                                                   |
| :------------------------------------------------------ | :-------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Shock 1: Severe Monsoon Drought / Crop Failure**      | 40% drop in marketable agricultural surplus in the Nashik belt; active paying cohort contracts to 45% (55% seasonal pause). | Gross monthly revenue contracts by 32% (to ₹22.0 Lakhs in Y1). Direct technology costs decrease proportionally.           | **Ultra-Lean Fixed Base**: Fixed operational overhead is restricted to ₹145k/month. Break-even subscriber count rises from 186 to 275. Runway exceeds 18 months without external equity injection.                    |
| **Shock 2: High Diesel Price Inflation (₹115 / Liter)** | Geopolitical crude spike drives diesel from ₹92 to ₹115/L (+25% variable vehicle operating cost).                           | Independent 10t ICV charter rates surge from ₹7,000 to ₹8,600. Unorganized fleet operators face acute margin compression. | **Counter-Cyclical Demand Catalyst**: High diesel prices _accelerate_ transporter and farmer adoption of PRAYAAN, because running half-empty trucks becomes financially fatal. Inbound pooling demand spikes by +35%. |
| **Shock 3: 50% Slower FPO Sales Conversion Cycles**     | Extended FPO board committee approvals double sales cycle from 45 to 90 days; Y1 active FPO count caps at 60.               | Y1 gross revenue declines to ₹16.2 Lakhs.                                                                                 | **Cash-Flow Survival Floor**: Zero-debt capitalization and elastic cloud billing maintain positive EBITDA (+₹1.8 Lakhs) even at 50% target onboarding velocity.                                                       |

---

## 5. Separation of Savings Claims

To ensure complete transparency before competition juries, PRAYAAN explicitly segregates all economic impact claims into three categories:

```
+---------------------------------------------------------------------------------------------------+
|                                CATEGORIZATION OF IMPACT CLAIMS                                    |
+---------------------------------------------------------------------------------------------------+
| 1. THEORETICAL SAVINGS            | - Mathematical maximum assuming zero detour and 100% vehicle  |
|    (Combinatorial Ideal)          |   weight and volume packing efficiency (up to 57% savings).   |
|                                                                                                   |
| 2. SYNTHETIC MODEL SAVINGS        | - Algorithmic benchmark on simulated Nashik-Mumbai corridor   |
|    (Experimental Benchmark)       |   with 15% road detour and 70% load factors: 32% to 45% net   |
|                                   |   shippers' cost savings. (Detailed in Doc 03 and Doc 06).    |
|                                                                                                   |
| 3. ACTUAL MEASURED FIELD SAVINGS  | - STATUS: ZERO CURRENTLY.                                     |
|    (Pilot Empirical Evidence)     |   No field trials have been conducted yet. Never cite         |
|                                   |   synthetic results as verified real-world farmer savings!    |
+---------------------------------------------------------------------------------------------------+
```

---

## 6. Comprehensive Field-Validation Protocol

```
=====================================================================================================
STATUS: NOT YET CONDUCTED — VALIDATION REQUIRED
The questionnaires, sampling methodologies, and data collection frameworks below represent
PRAYAAN's pre-pilot field validation protocol. No interviews have been conducted to date.
=====================================================================================================
```

### A. Sampling Methodology & Cohort Sizing

- **Target Geographic Corridor**: **Nashik District (Niphad, Yeola, Sinnar) $\leftrightarrow$ Mumbai Metropolitan Region (Vashi APMC, Kalyan Mandi)** (~165 km).
- **Sampling Frame**: Stratified random sampling across three stakeholder clusters:
  1. **Smallholder Farmers & FPO Executives**: $N = 60$ respondents (45 marginal farmers $< 2\text{ ha}$, 10 commercial growers, 5 FPO board directors).
  2. **Fleet Owners & Commercial Drivers**: $N = 35$ respondents (15 small fleet owners owning 2–5 trucks, 20 hired/owner-drivers).
  3. **Wholesale Mandi Traders & Commission Agents**: $N = 25$ respondents (15 commission agents/arhtiyas, 10 bulk procurement buyers).
  4. **Total Target Sample Size**: **120 primary field interviews**.

---

### B. Instrument 1: Farmer & Producer Questionnaire (20 Key Metrics)

```
[FIELD DATA COLLECTION SHEET — PRODUCER COHORT]
Interviewer Name: _______________________ Date: ____________ Village/Block: __________________
Respondent Name: ________________________ Landholding (Acres): _____ Primary Crops: ___________

Q01. What is your typical marketable surplus volume per harvest cycle? [Quintals / Tonnes]
Q02. How do you currently transport produce from farmgate to the nearest APMC mandi?
     [ ] Own tractor/trolley  [ ] Hired SCV (Tata Ace)  [ ] Shared local pickup  [ ] Sold at farmgate to middleman
Q03. What freight price do you currently pay per quintal or per trip to your primary mandi? [INR]
Q04. How many hours or days prior to harvest do you book transportation?
Q05. Have you ever experienced a transporter failing to arrive on time? If yes, what happened to produce?
Q06. On average, how many hours does your produce wait at the loading dock before departure?
Q07. Do you ever sell at farmgate at a discounted price because transport is unavailable or too expensive?
     If yes, what is the typical price markdown compared to mandi rate? [e.g., 20% lower, 30% lower]
Q08. Would you be willing to share truck space with another farmer from your village traveling to the same market?
     [ ] Yes, unconditionally  [ ] Yes, if produce is partitioned  [ ] No (Explain reason: ____________)
Q09. What is your biggest fear regarding shared truckloads?
     [ ] Cargo theft  [ ] Produce damage/crushing  [ ] Consignment mixing  [ ] Delayed unloading
Q10. How do you verify that the quantity loaded at the farm reaches the buyer without pilferage?
Q11. What mobile phone do you use? [ ] Feature phone (keypad)  [ ] Basic Android  [ ] Modern Smartphone
Q12. How comfortable are you using an OTP code or mobile app to confirm loading? [Scale 1 to 5]
Q13. What languages are you fluent in reading? [ ] Hindi  [ ] Marathi  [ ] Gujarati  [ ] English
Q14. Are you a registered member of an active Farmer Producer Organization (FPO)? [ ] Yes  [ ] No
Q15. If an FPO provided pooled transport saving 30% on freight, would you use it? [ ] Yes  [ ] No
```

---

### C. Instrument 2: Fleet Owner & Truck Driver Questionnaire (20 Key Metrics)

```
[FIELD DATA COLLECTION SHEET — TRANSPORTER & DRIVER COHORT]
Interviewer Name: _______________________ Date: ____________ Transport Nagar: ________________
Fleet Owner / Driver Name: ______________ Fleet Size: _____ Primary Vehicle Models: _________

Q01. What vehicle models do you operate on rural-to-urban routes?
     [ ] SCV (< 1.5t)  [ ] LCV (2.5t - 4t)  [ ] ICV (7t - 10t)  [ ] Multi-Axle (> 16t)
Q02. What is your actual average fuel mileage (km per liter) when fully loaded vs. empty?
Q03. What is the standard commercial one-way freight rate you quote for the corridor? [INR]
Q04. When delivering agricultural produce to urban mandis, how do you find return cargo?
     [ ] Commission agent / broker  [ ] Wait at transport nagar  [ ] WhatsApp groups  [ ] Return empty
Q05. What percentage of your return trips are run completely empty (deadheading)? [ ____ % ]
Q06. How many days per month does each commercial vehicle sit idle without an assigned load?
Q07. What commission percentage or fee do you pay to freight brokers per trip? [ ____ % / INR ]
Q08. How do shippers settle freight payments?
     [ ] 100% Cash on delivery  [ ] Advance diesel cash + balance on POD  [ ] Delayed credit (15-45 days)
Q09. How often do shippers or buyers make deductions from your freight bill claiming damaged/short cargo?
Q10. How many loading stops are you willing to make within a 15 km rural radius if paid extra? [Max stops: __]
Q11. How much additional compensation per stop would make a multi-pickup run viable? [INR]
Q12. Have you ever experienced smartphone network disconnection during rural pickups? How do you cope?
Q13. Do you currently use FASTag for toll payments? [ ] Yes  [ ] No
Q14. Would you pay a flat ₹899/month subscription if it provided guaranteed verified return loads?
     [ ] Definitely yes  [ ] Only if trial is free  [ ] No, prefer commission per load
Q15. What is your average monthly expenditure on tyre replacements, maintenance, and commercial EMI?
```

---

### D. Quantitative Methodology for Converting Field Responses into Model Parameters

When field surveys are conducted during Stage 2, raw response data will be mapped directly into PRAYAAN’s algorithmic parameters:

```
+---------------------------------------------------------------------------------------------------+
|                        FIELD DATA TO ALGORITHMIC PARAMETER MAPPING                                |
+---------------------------------------------------------------------------------------------------+
| Survey Metric Collected             | Algorithmic Variable in PRAYAAN Model                       |
+-------------------------------------+-------------------------------------------------------------+
| Observed return empty trip rate     | Calibrates Return Probability P_backhaul in repositioning   |
| (Q05 in Transporter Survey)         | cost formula: K_reposition = (1 - P_backhaul) * (D * V_km).  |
|                                     |                                                             |
| Multi-stop detour compensation      | Sets the Pickup Service Cost s_p and maximum corridor detour|
| (Q11 in Transporter Survey)         | threshold \delta_max in m-PDVRPTW objective function.      |
|                                     |                                                             |
| Observed loading dock wait time     | Sets the pickup time window width [e_p, l_p] and loading    |
| (Q06 in Farmer Survey)              | dock timeout threshold (default: 60 minutes).               |
|                                     |                                                             |
| Baseline dedicated charter rates    | Establishes standalone benchmark C_standalone(c_i) to verify |
| (Q03 in Farmer Survey)              | that NMRS allocated freight A_i guarantees >= 30% savings.  |
+---------------------------------------------------------------------------------------------------+
```

### E. Evidence Requirements Before Platform Impact Claims Can Be Made

Before PRAYAAN publishes any public impact claims, the team must meet four verifiable audit gates:

1. **Minimum Trial Volume**: Completion of at least **100 documented multi-consignment trips** along a single corridor.
2. **Audited Financial Ledgers**: Signed electronic proof-of-delivery receipts showing actual freight paid by farmers versus prevailing market charter rates on the same day.
3. **Telematics Verification**: GPS odometer logs proving total vehicle-kilometers traveled and reduction in deadhead mileage.
4. **Zero Custody Claims**: Documented resolution of all loading/delivery OTP transactions with zero disputed cargo losses.

---

### F. Pre-Pilot Letter of Intent (LoI) Institutional Agreement Template

To transition seamlessly from hackathon evaluation to physical field deployment, the following standard Memorandum of Understanding / Letter of Intent (LoI) template has been drafted for execution with regional Farmer Producer Organizations and transport unions:

```
+---------------------------------------------------------------------------------------------------+
|               MEMORANDUM OF UNDERSTANDING / PRE-PILOT LETTER OF INTENT (LoI)                      |
+---------------------------------------------------------------------------------------------------+
Date: ________________________              Execution City: Nashik, Maharashtra

BETWEEN:
1. PRAYAAN LOGISTICS INITIATIVE (Represented by Team Kernal500, Tech4Bharat 2026)
   [Hereinafter referred to as "The Technology Provider"]
   - AND -
2. __________________________________________________________________________________
   (Farmer Producer Company Ltd. / Regional Goods Transport Association)
   Registration No: ___________________________ Represented by: _____________________
   [Hereinafter referred to as "The Institutional Partner"]

1. PURPOSE & CORRIDOR DEFINITION:
The parties agree to collaborate on a 90-day controlled operational research trial along the
Nashik District (Niphad / Yeola / Sinnar) <-> Mumbai Metropolitan Region (Vashi APMC) transit corridor.

2. OPERATIONAL COHORT COMMITMENTS:
- The Institutional Partner agrees to designate an initial cohort of up to [15] commercial growers
  and [5] certified commercial freight vehicles (SCV / LCV / ICV).
- Focus Commodities: Fresh horticultural produce (Onions, Potatoes, Tomatoes, Capsicum, Grapes).

3. COMMERCIAL TERMS & COST GUARANTEE:
- Shared freight charges will be calculated strictly via the integer Normalized Maximum Resource Share
  (NMRS) algorithm, ensuring every participating farmer pays strictly less than dedicated charter rates.
- The Technology Provider will charge ZERO (₹0) software subscription fees during the 90-day trial period.
- Member farmers will contribute a nominal ₹10 per quintal pooling facilitation levy retained directly
  in the Institutional Partner's local logistics pool.

4. CHAIN OF CUSTODY & INSURANCE ESCALATION:
- All cargo loading and deliveries will be verified using 6-digit cryptographic OTPs and geotagged photos.
- The Technology Provider will provide dedicated dispute arbitration support within 30 minutes of any dock
  exception raised via the driver mobile client.

For PRAYAAN (Technology Provider):               For Institutional Partner (FPO / Transporter):

Signature: _________________________________     Signature: _________________________________
Name: Rohan Prasad & Team Kernal500              Name: ______________________________________
Designation: Project Lead, PRAYAAN               Designation: Chairman / Managing Director
Date: ______________________________________     Date: ______________________________________
+---------------------------------------------------------------------------------------------------+
```

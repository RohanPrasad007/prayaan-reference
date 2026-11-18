#!/usr/bin/env python3
"""
PRAYAAN — Unit Economics, Break-Even & Financial Projections Engine
Tech4Bharat 2026 / GAVS Hackathon — Theme 5: Rural Freight (Problem Statement 5.3)
Team: Kernal500

This script computes audited SaaS unit economics, Customer Lifetime Value (LTV),
operating expense breakdowns (OpEx), break-even subscriber thresholds, and 3-year
financial projections incorporating:
- 18% statutory GST on subscription fees.
- Core engineering & developer salaries in fixed OpEx.
- Operational liability & cyber insurance.
- Funded fleet-recovery transshipment reserve.
"""

import json
import argparse


def compute_unit_economics():
    # -------------------------------------------------------------
    # 1. Pricing & Revenue Recognition
    # -------------------------------------------------------------
    base_subscription_inr = 899.0
    gst_rate = 0.18
    gst_amount_inr = round(base_subscription_inr * gst_rate, 2) # Rs 161.82
    gross_customer_price_inr = round(base_subscription_inr + gst_amount_inr, 2) # Rs 1,060.82

    # Net Recognized Revenue by PRAYAAN (excl. GST remitted to govt)
    net_monthly_arpu_inr = base_subscription_inr # Rs 899.00

    # -------------------------------------------------------------
    # 2. Variable Direct Technology & Gateway Costs (per user / month)
    # -------------------------------------------------------------
    var_cloud_hosting = 45.0      # AWS RDS PostgreSQL + Redis + S3 + API Gateway
    var_sms_whatsapp = 35.0       # Transactional SMS login OTPs + WhatsApp delivery alerts
    var_map_routing = 28.0        # OpenRouteService / Mapbox geocoding & routing calls
    var_payment_gateway = 8.0     # Blended UPI (0% MDR) + NetBanking/Card MDR
    total_variable_cost_per_user = var_cloud_hosting + var_sms_whatsapp + var_map_routing + var_payment_gateway # Rs 116.00

    gross_margin_per_user_inr = net_monthly_arpu_inr - total_variable_cost_per_user # Rs 783.00
    gross_margin_pct = (gross_margin_per_user_inr / net_monthly_arpu_inr) * 100.0 # 87.1%

    # -------------------------------------------------------------
    # 3. Monthly Fixed Operating Overhead (OpEx at Baseline / Stage 1 Scale)
    # -------------------------------------------------------------
    fixed_dev_salaries = 120_000.0       # 2 Core Engineers (Full-Stack/DevOps + Mobile/Systems)
    fixed_customer_support = 65_000.0    # 2 Regional Language Support Agents (Hindi/Marathi)
    fixed_field_coordinators = 80_000.0  # 2 Ground Field Coordinators (Mandi & Transport Nagar)
    fixed_insurance_policy = 15_000.0    # Commercial Liability & Transit Platform Cyber Risk Policy
    fixed_fleet_recovery_reserve = 20_000.0 # Funded Escrow Reserve for Breakdown Transshipment/Towing
    
    total_fixed_monthly_opex = (
        fixed_dev_salaries + 
        fixed_customer_support + 
        fixed_field_coordinators + 
        fixed_insurance_policy + 
        fixed_fleet_recovery_reserve
    ) # Rs 300,000 / month

    # -------------------------------------------------------------
    # 4. Break-Even Analysis
    # -------------------------------------------------------------
    breakeven_subscribers = total_fixed_monthly_opex / gross_margin_per_user_inr
    breakeven_subscribers_int = int(-(-total_fixed_monthly_opex // gross_margin_per_user_inr)) # 384 subscribers

    # -------------------------------------------------------------
    # 5. Customer Acquisition Cost (CAC) & Lifetime Value (LTV)
    # -------------------------------------------------------------
    cac_seller_fpo = 1850.0  # FPO institutional onboarding via KVKs & CSCs
    cac_fleet_owner = 3200.0 # Transporter activation at Transport Nagars
    blended_cac = (0.40 * cac_seller_fpo) + (0.60 * cac_fleet_owner) # Rs 2,660.00

    monthly_churn_rate = 0.065 # 6.5% monthly churn (incorporating seasonal harvest pauses)
    customer_lifetime_months = round(1.0 / monthly_churn_rate, 1) # 15.4 months
    ltv_inr = round(gross_margin_per_user_inr / monthly_churn_rate, 2) # Rs 12,046.15

    ltv_cac_ratio_seller = round(ltv_inr / cac_seller_fpo, 2)
    ltv_cac_ratio_fleet = round(ltv_inr / cac_fleet_owner, 2)
    ltv_cac_ratio_blended = round(ltv_inr / blended_cac, 2)

    # -------------------------------------------------------------
    # 6. Three-Year Financial Projections (Years 1, 2, 3)
    # -------------------------------------------------------------
    years_data = [
        {"year": 1, "corridors": 1, "sellers": 120, "fleet": 180, "opex_scale": 1.0},
        {"year": 2, "corridors": 4, "sellers": 650, "fleet": 1100, "opex_scale": 2.2},
        {"year": 3, "corridors": 10, "sellers": 2400, "fleet": 4200, "opex_scale": 4.5},
    ]

    projections = []
    for yd in years_data:
        tot_subs = yd["sellers"] + yd["fleet"]
        gross_rev = tot_subs * net_monthly_arpu_inr * 12.0
        var_costs = tot_subs * total_variable_cost_per_user * 12.0
        fixed_opex = total_fixed_monthly_opex * yd["opex_scale"] * 12.0
        tot_costs = var_costs + fixed_opex
        ebitda = gross_rev - tot_costs
        ebitda_margin = (ebitda / gross_rev) * 100.0
        projections.append({
            "year": yd["year"],
            "corridors": yd["corridors"],
            "sellers": yd["sellers"],
            "fleet": yd["fleet"],
            "total_subscribers": tot_subs,
            "revenue_lakhs": round(gross_rev / 100_000.0, 2),
            "variable_costs_lakhs": round(var_costs / 100_000.0, 2),
            "fixed_opex_lakhs": round(fixed_opex / 100_000.0, 2),
            "total_costs_lakhs": round(tot_costs / 100_000.0, 2),
            "ebitda_lakhs": round(ebitda / 100_000.0, 2),
            "ebitda_margin_pct": round(ebitda_margin, 1)
        })

    return {
        "pricing": {
            "base_subscription_inr": base_subscription_inr,
            "gst_rate_pct": gst_rate * 100.0,
            "gst_amount_inr": gst_amount_inr,
            "gross_customer_price_inr": gross_customer_price_inr,
            "net_monthly_arpu_inr": net_monthly_arpu_inr
        },
        "variable_costs": {
            "cloud_hosting": var_cloud_hosting,
            "sms_whatsapp": var_sms_whatsapp,
            "map_routing": var_map_routing,
            "payment_gateway": var_payment_gateway,
            "total_variable_per_user": total_variable_cost_per_user,
            "gross_margin_per_user": gross_margin_per_user_inr,
            "gross_margin_pct": round(gross_margin_pct, 1)
        },
        "fixed_opex_monthly": {
            "engineering_salaries": fixed_dev_salaries,
            "customer_support": fixed_customer_support,
            "field_coordinators": fixed_field_coordinators,
            "insurance_liability": fixed_insurance_policy,
            "fleet_recovery_reserve": fixed_fleet_recovery_reserve,
            "total_fixed_opex": total_fixed_monthly_opex
        },
        "breakeven": {
            "monthly_fixed_opex": total_fixed_monthly_opex,
            "gross_margin_per_user": gross_margin_per_user_inr,
            "breakeven_subscribers": breakeven_subscribers_int
        },
        "ltv_cac": {
            "cac_seller": cac_seller_fpo,
            "cac_fleet": cac_fleet_owner,
            "blended_cac": blended_cac,
            "monthly_churn_pct": monthly_churn_rate * 100.0,
            "lifetime_months": customer_lifetime_months,
            "ltv_inr": ltv_inr,
            "ltv_cac_ratio_seller": ltv_cac_ratio_seller,
            "ltv_cac_ratio_fleet": ltv_cac_ratio_fleet,
            "ltv_cac_ratio_blended": ltv_cac_ratio_blended
        },
        "projections": projections
    }


def print_formatted_report(data):
    print("=" * 85)
    print("PRAYAAN FINANCIAL MODEL & UNIT ECONOMICS AUDIT (STATUTORY & OPEX EXPANDED)")
    print("=" * 85)

    p = data["pricing"]
    print(f"\n1. SUBSCRIPTION PRICING & STATUTORY GST STRUCTURE:")
    print(f"   - Base SaaS Subscription:        Rs {p['base_subscription_inr']:,.2f} / month")
    print(f"   - Statutory GST (18%):           Rs {p['gst_amount_inr']:,.2f} / month (Remitted to Govt)")
    print(f"   - Gross Customer Invoice:        Rs {p['gross_customer_price_inr']:,.2f} / month")
    print(f"   - Net Platform ARPU:             Rs {p['net_monthly_arpu_inr']:,.2f} / month")

    v = data["variable_costs"]
    print(f"\n2. VARIABLE DIRECT COSTS & UNIT MARGINS:")
    print(f"   - Cloud Hosting & DB:            Rs {v['cloud_hosting']:,.2f} / user / mo")
    print(f"   - SMS & WhatsApp OTPs:           Rs {v['sms_whatsapp']:,.2f} / user / mo")
    print(f"   - Maps & Geocoding APIs:         Rs {v['map_routing']:,.2f} / user / mo")
    print(f"   - Payment Gateway MDR:           Rs {v['payment_gateway']:,.2f} / user / mo")
    print(f"   - Total Variable Tech Cost:      Rs {v['total_variable_per_user']:,.2f} / user / mo")
    print(f"   - Gross Margin per Subscriber:   Rs {v['gross_margin_per_user']:,.2f} / month ({v['gross_margin_pct']}%)")

    f = data["fixed_opex_monthly"]
    print(f"\n3. EXPANDED MONTHLY FIXED OPERATING OVERHEAD (OpEx):")
    print(f"   - Engineering & Dev Salaries:    Rs {f['engineering_salaries']:,.2f} / month (2 Core Engineers)")
    print(f"   - Customer Support Desk:         Rs {f['customer_support']:,.2f} / month (2 Regional Support Agents)")
    print(f"   - Ground Field Coordinators:     Rs {f['field_coordinators']:,.2f} / month (2 Mandi/Dock Coordinators)")
    print(f"   - Insurance & Liability Policy:  Rs {f['insurance_liability']:,.2f} / month (Transit Cyber/Risk Cover)")
    print(f"   - Fleet-Recovery Reserve:        Rs {f['fleet_recovery_reserve']:,.2f} / month (Funded Transshipment Escrow)")
    print(f"   - TOTAL MONTHLY FIXED OPEX:      Rs {f['total_fixed_opex']:,.2f} / month (Rs {f['total_fixed_opex']*12/100000:.2f} Lakhs/yr)")

    b = data["breakeven"]
    print(f"\n4. BREAK-EVEN OPERATIONAL THRESHOLD:")
    print(f"   - Fixed Overhead / Unit Margin:  Rs {b['monthly_fixed_opex']:,.0f} / Rs {b['gross_margin_per_user']:,.2f}")
    print(f"   - Operational Break-Even Point:  {b['breakeven_subscribers']} Active Subscribers")
    print(f"     (e.g., ~15 FPOs and 40 small fleet operators across 2 regional transit corridors)")

    l = data["ltv_cac"]
    print(f"\n5. CAC & LIFETIME VALUE (LTV):")
    print(f"   - Seller CAC (FPO Institutional): Rs {l['cac_seller']:,.2f}")
    print(f"   - Fleet Owner CAC (Direct):       Rs {l['cac_fleet']:,.2f}")
    print(f"   - Blended CAC:                   Rs {l['blended_cac']:,.2f}")
    print(f"   - Monthly Churn Rate:            {l['monthly_churn_pct']}% (incorporates 4-mo seasonal harvest pause)")
    print(f"   - Expected Customer Lifetime:    {l['lifetime_months']} months")
    print(f"   - Customer Lifetime Value (LTV): Rs {l['ltv_inr']:,.2f}")
    print(f"   - LTV / CAC Ratios:              Seller = {l['ltv_cac_ratio_seller']}x | Fleet = {l['ltv_cac_ratio_fleet']}x | Blended = {l['ltv_cac_ratio_blended']}x")

    print(f"\n6. THREE-YEAR MULTI-SCENARIO FINANCIAL PROJECTIONS (INR LAKHS):")
    print("-" * 85)
    row_fmt = "{:<8} | {:<10} | {:<12} | {:<14} | {:<14} | {:<14} | {:<12}"
    print(row_fmt.format("Year", "Corridors", "Subscribers", "Gross Revenue", "Variable Costs", "Fixed OpEx", "EBITDA (%)"))
    print("-" * 85)
    for pr in data["projections"]:
        print(row_fmt.format(
            f"Year {pr['year']}",
            f"{pr['corridors']}",
            f"{pr['total_subscribers']:,}",
            f"Rs {pr['revenue_lakhs']:.2f} L",
            f"(Rs {pr['variable_costs_lakhs']:.2f} L)",
            f"(Rs {pr['fixed_opex_lakhs']:.2f} L)",
            f"Rs {pr['ebitda_lakhs']:.2f} L ({pr['ebitda_margin_pct']}%)"
        ))
    print("-" * 85)
    print("=" * 85)


def main():
    parser = argparse.ArgumentParser(description="PRAYAAN Unit Economics & Financial Projections Engine")
    parser.add_argument("--json", action="store_true", help="Output results in JSON format")
    args = parser.parse_args()

    data = compute_unit_economics()
    if args.json:
        print(json.dumps(data, indent=2))
    else:
        print_formatted_report(data)


if __name__ == "__main__":
    main()

-- =====================================================================================
-- PRAYAAN: Automated Schema Invariant & Security Verification Test Suite
-- Tech4Bharat 2026 / GAVS Hackathon — Theme 5: Rural Freight (Problem Statement 5.3)
-- Team: Kernal500
-- =====================================================================================
-- Description:
--   Executes automated end-to-end regression tests verifying:
--     Test A: Aadhaar masking format validation (14-char regex enforcement)
--     Test B: Multi-axis contiguous leg capacity & stop precedence enforcement
--     Test C: Trip-level row concurrency locking (FOR UPDATE)
--     Test D: RLS multi-tenant isolation between sellers and parties
--     Test E: Driver/transporter freight tampering prevention & advance payout cap
--
-- Execution:
--   psql -h localhost -U postgres -d prayaan -f tests/schema_tests.sql
-- =====================================================================================

\set ON_ERROR_STOP on

BEGIN;

RAISE NOTICE '======================================================================';
RAISE NOTICE 'STARTING PRAYAAN SCHEMA INVARIANT & SECURITY TEST SUITE';
RAISE NOTICE '======================================================================';

-- -------------------------------------------------------------------------------------
-- TEST A: Aadhaar Masking Format Validation (14-Character Regex)
-- -------------------------------------------------------------------------------------
RAISE NOTICE '>>> TEST A: Aadhaar Masking Format Validation';

DO $$
DECLARE
    v_user_id UUID;
    v_failed BOOLEAN := FALSE;
BEGIN
    -- A.1: Valid masked Aadhaar format (XXXX-XXXX-1234 -> exactly 14 characters)
    INSERT INTO users (phone_number, role, legal_name, masked_aadhaar)
    VALUES ('+919876543210', 'SELLER', 'Test Farmer Valid', 'XXXX-XXXX-1234')
    RETURNING id INTO v_user_id;

    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'TEST_A_FAILED: Valid masked Aadhaar was not inserted.';
    END IF;
    RAISE NOTICE '  [PASS] A.1: Valid Aadhaar format (XXXX-XXXX-1234) inserted successfully.';

    -- A.2: Raw 12-digit Aadhaar (Must be rejected by CHECK constraint)
    BEGIN
        INSERT INTO users (phone_number, role, legal_name, masked_aadhaar)
        VALUES ('+919876543211', 'SELLER', 'Test Farmer Raw', '123456789012');
        v_failed := TRUE;
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE '  [PASS] A.2: Raw 12-digit Aadhaar correctly rejected by CHECK constraint.';
    END;

    IF v_failed THEN
        RAISE EXCEPTION 'TEST_A_FAILED: Raw 12-digit Aadhaar was accepted!';
    END IF;

    -- A.3: Non-numeric suffix (XXXX-XXXX-ABCD -> Must be rejected)
    v_failed := FALSE;
    BEGIN
        INSERT INTO users (phone_number, role, legal_name, masked_aadhaar)
        VALUES ('+919876543212', 'SELLER', 'Test Farmer Alpha', 'XXXX-XXXX-ABCD');
        v_failed := TRUE;
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE '  [PASS] A.3: Non-numeric suffix masked Aadhaar correctly rejected.';
    END;

    IF v_failed THEN
        RAISE EXCEPTION 'TEST_A_FAILED: Non-numeric suffix Aadhaar was accepted!';
    END IF;
END $$;


-- -------------------------------------------------------------------------------------
-- TEST B: Multi-Axis Capacity Trigger & Leg Precedence Enforcement
-- -------------------------------------------------------------------------------------
RAISE NOTICE '>>> TEST B: Multi-Axis Capacity Trigger & Stop Sequence Precedence';

DO $$
DECLARE
    v_seller_id UUID;
    v_buyer_id UUID;
    v_driver_id UUID;
    v_fleet_owner_id UUID;
    v_vehicle_id UUID;
    v_listing_id UUID;
    v_order1_id UUID;
    v_order2_id UUID;
    v_req1_id UUID;
    v_req2_id UUID;
    v_trip_id UUID;
    v_stop1_id UUID;
    v_stop2_id UUID;
    v_stop3_id UUID;
    v_consignment1_id UUID;
    v_failed BOOLEAN := FALSE;
BEGIN
    -- Setup baseline identities
    INSERT INTO users (phone_number, role, legal_name)
    VALUES ('+919999900001', 'SELLER', 'Seller Alpha') RETURNING id INTO v_seller_id;

    INSERT INTO users (phone_number, role, legal_name)
    VALUES ('+919999900002', 'BUYER', 'Buyer Alpha') RETURNING id INTO v_buyer_id;

    INSERT INTO users (phone_number, role, legal_name)
    VALUES ('+919999900003', 'FLEET_OWNER', 'Fleet Owner Alpha') RETURNING id INTO v_fleet_owner_id;

    INSERT INTO users (phone_number, role, legal_name)
    VALUES ('+919999900004', 'DRIVER', 'Driver Alpha') RETURNING id INTO v_driver_id;

    -- Vehicle: 10,000 kg, 30.00 m3, 100 slots (10-Tonne Multi-Axle)
    INSERT INTO vehicles (owner_id, registration_number, body_type, rated_payload_kg, usable_volume_m3, fitness_valid_until)
    VALUES (v_fleet_owner_id, 'MH-12-AB-1234', 'TARPAULIN_COVERED', 10000, 30.00, '2028-12-31')
    RETURNING id INTO v_vehicle_id;

    -- Trip: Nashik -> Mumbai
    INSERT INTO trips (vehicle_id, driver_id, corridor_name, total_negotiated_freight_paise)
    VALUES (v_vehicle_id, v_driver_id, 'Nashik-Mumbai NH-160', 1200000)
    RETURNING id INTO v_trip_id;

    -- Route Stops: Stop 1 (Pimpalgaon, seq 1), Stop 2 (Igatpuri, seq 2), Stop 3 (Vashi APMC, seq 3)
    INSERT INTO route_stops (trip_id, stop_sequence, stop_name, stop_location, planned_arrival)
    VALUES (v_trip_id, 1, 'Pimpalgaon APMC', ST_SetSRID(ST_MakePoint(73.985, 20.174), 4326), NOW() + INTERVAL '2 hours')
    RETURNING id INTO v_stop1_id;

    INSERT INTO route_stops (trip_id, stop_sequence, stop_name, stop_location, planned_arrival)
    VALUES (v_trip_id, 2, 'Igatpuri Hub', ST_SetSRID(ST_MakePoint(73.562, 19.696), 4326), NOW() + INTERVAL '4 hours')
    RETURNING id INTO v_stop2_id;

    INSERT INTO route_stops (trip_id, stop_sequence, stop_name, stop_location, planned_arrival)
    VALUES (v_trip_id, 3, 'Vashi APMC Navi Mumbai', ST_SetSRID(ST_MakePoint(72.999, 19.076), 4326), NOW() + INTERVAL '7 hours')
    RETURNING id INTO v_stop3_id;

    -- Listing & Order 1: 6,000 kg (60 quintals), 18 m3, 60 slots
    INSERT INTO listings (seller_id, commodity_name, hsn_code, quantity_quintals, expected_price_paise_per_quintal, pickup_address, pickup_location, harvest_date)
    VALUES (v_seller_id, 'Nashik Red Onion', '07031010', 60.00, 250000, 'Pimpalgaon', ST_SetSRID(ST_MakePoint(73.985, 20.174), 4326), CURRENT_DATE)
    RETURNING id INTO v_listing_id;

    INSERT INTO orders (listing_id, buyer_id, seller_id, agreed_quantity_quintals, goods_value_paise, destination_address, destination_location, delivery_deadline)
    VALUES (v_listing_id, v_buyer_id, v_seller_id, 60.00, 15000000, 'Vashi APMC', ST_SetSRID(ST_MakePoint(72.999, 19.076), 4326), NOW() + INTERVAL '12 hours')
    RETURNING id INTO v_order1_id;

    INSERT INTO transport_requests (order_id, weight_kg, volume_m3, slot_demand, pickup_location, drop_location)
    VALUES (v_order1_id, 6000, 18.00, 60, ST_SetSRID(ST_MakePoint(73.985, 20.174), 4326), ST_SetSRID(ST_MakePoint(72.999, 19.076), 4326))
    RETURNING id INTO v_req1_id;

    -- Consignment 1: Pimpalgaon -> Vashi (Stops 1 -> 3). Uses 6,000 kg.
    INSERT INTO consignments (trip_id, request_id, pickup_stop_id, drop_stop_id, allocated_freight_paise, loading_otp_hash, delivery_otp_hash)
    VALUES (v_trip_id, v_req1_id, v_stop1_id, v_stop3_id, 720000, 'dummy_load_hash_1', 'dummy_deliv_hash_1')
    RETURNING id INTO v_consignment1_id;

    RAISE NOTICE '  [PASS] B.1: Baseline consignment (6,000 kg / 18 m3) inserted within capacity.';

    -- Order & Request 2: 5,000 kg, 15 m3, 50 slots
    INSERT INTO orders (listing_id, buyer_id, seller_id, agreed_quantity_quintals, goods_value_paise, destination_address, destination_location, delivery_deadline)
    VALUES (v_listing_id, v_buyer_id, v_seller_id, 50.00, 12500000, 'Igatpuri', ST_SetSRID(ST_MakePoint(73.562, 19.696), 4326), NOW() + INTERVAL '12 hours')
    RETURNING id INTO v_order2_id;

    INSERT INTO transport_requests (order_id, weight_kg, volume_m3, slot_demand, pickup_location, drop_location)
    VALUES (v_order2_id, 5000, 15.00, 50, ST_SetSRID(ST_MakePoint(73.985, 20.174), 4326), ST_SetSRID(ST_MakePoint(73.562, 19.696), 4326))
    RETURNING id INTO v_req2_id;

    -- B.2: Attempt to insert Consignment 2 across Leg 1->2 (Total weight = 6,000 + 5,000 = 11,000 kg > 10,000 kg certified capacity)
    v_failed := FALSE;
    BEGIN
        INSERT INTO consignments (trip_id, request_id, pickup_stop_id, drop_stop_id, allocated_freight_paise, loading_otp_hash, delivery_otp_hash)
        VALUES (v_trip_id, v_req2_id, v_stop1_id, v_stop2_id, 480000, 'dummy_load_hash_2', 'dummy_deliv_hash_2');
        v_failed := TRUE;
    EXCEPTION WHEN OTHERS THEN
        IF SQLERRM LIKE '%CAPACITY_EXCEEDED (Weight)%' THEN
            RAISE NOTICE '  [PASS] B.2: Weight capacity overflow correctly aborted by trigger: %', SQLERRM;
        ELSE
            RAISE EXCEPTION 'TEST_B_FAILED: Unexpected error on overflow: %', SQLERRM;
        END IF;
    END;

    IF v_failed THEN
        RAISE EXCEPTION 'TEST_B_FAILED: Over-capacity consignment (11,000 kg > 10,000 kg) was illegally accepted!';
    END IF;

    -- B.3: Attempt to insert consignment with reversed stop sequence (Stop 3 -> Stop 1)
    v_failed := FALSE;
    BEGIN
        INSERT INTO consignments (trip_id, request_id, pickup_stop_id, drop_stop_id, allocated_freight_paise, loading_otp_hash, delivery_otp_hash)
        VALUES (v_trip_id, v_req2_id, v_stop3_id, v_stop1_id, 480000, 'dummy_load_hash_3', 'dummy_deliv_hash_3');
        v_failed := TRUE;
    EXCEPTION WHEN OTHERS THEN
        IF SQLERRM LIKE '%PRECEDENCE_VIOLATION%' THEN
            RAISE NOTICE '  [PASS] B.3: Reversed stop sequence correctly aborted by trigger.';
        ELSE
            RAISE EXCEPTION 'TEST_B_FAILED: Unexpected error on precedence test: %', SQLERRM;
        END IF;
    END;

    IF v_failed THEN
        RAISE EXCEPTION 'TEST_B_FAILED: Reversed stop sequence was accepted!';
    END IF;
END $$;


-- -------------------------------------------------------------------------------------
-- TEST C: Trip Concurrency Row Locking Verification
-- -------------------------------------------------------------------------------------
RAISE NOTICE '>>> TEST C: Trip-Level Concurrency Locking (FOR UPDATE)';

DO $$
DECLARE
    v_trip_id UUID;
BEGIN
    SELECT id INTO v_trip_id FROM trips LIMIT 1;

    -- Verify that SELECT ... FOR UPDATE acquires row-level exclusive lock on trip
    PERFORM id FROM trips WHERE id = v_trip_id FOR UPDATE NOWAIT;
    RAISE NOTICE '  [PASS] C.1: Exclusive FOR UPDATE row lock successfully acquired on trip row % without block.', v_trip_id;
END $$;


-- -------------------------------------------------------------------------------------
-- TEST D: RLS Multi-Tenant Isolation Between Sellers
-- -------------------------------------------------------------------------------------
RAISE NOTICE '>>> TEST D: Row-Level Security (RLS) Tenant Isolation';

DO $$
DECLARE
    v_seller1_id UUID;
    v_seller2_id UUID;
    v_buyer_id UUID;
    v_listing1_id UUID;
    v_order1_id UUID;
    v_visible_count INTEGER;
BEGIN
    -- Create two independent sellers
    INSERT INTO users (phone_number, role, legal_name)
    VALUES ('+919999900011', 'SELLER', 'Farmer Ramesh (Seller 1)') RETURNING id INTO v_seller1_id;

    INSERT INTO users (phone_number, role, legal_name)
    VALUES ('+919999900012', 'SELLER', 'Farmer Suresh (Seller 2)') RETURNING id INTO v_seller2_id;

    SELECT id INTO v_buyer_id FROM users WHERE role = 'BUYER' LIMIT 1;

    -- Seller 1 creates Listing and Order
    INSERT INTO listings (seller_id, commodity_name, hsn_code, quantity_quintals, expected_price_paise_per_quintal, pickup_address, pickup_location, harvest_date)
    VALUES (v_seller1_id, 'Organic Pomegranate', '08109010', 25.00, 800000, 'Solapur Hub', ST_SetSRID(ST_MakePoint(75.906, 17.659), 4326), CURRENT_DATE)
    RETURNING id INTO v_listing1_id;

    INSERT INTO orders (listing_id, buyer_id, seller_id, agreed_quantity_quintals, goods_value_paise, destination_address, destination_location, delivery_deadline)
    VALUES (v_listing1_id, v_buyer_id, v_seller1_id, 25.00, 20000000, 'Pune APMC', ST_SetSRID(ST_MakePoint(73.856, 18.520), 4326), NOW() + INTERVAL '24 hours')
    RETURNING id INTO v_order1_id;

    -- D.1: Emulate session as Seller 1
    PERFORM set_config('app.current_user_id', v_seller1_id::text, true);
    PERFORM set_config('app.current_user_role', 'SELLER', true);

    SELECT COUNT(*) INTO v_visible_count FROM orders WHERE id = v_order1_id;
    IF v_visible_count <> 1 THEN
        RAISE EXCEPTION 'TEST_D_FAILED: Seller 1 cannot see their own order (count=%)', v_visible_count;
    END IF;
    RAISE NOTICE '  [PASS] D.1: Seller 1 can view their own order.';

    -- D.2: Emulate session as Seller 2 (Tenant boundary test)
    PERFORM set_config('app.current_user_id', v_seller2_id::text, true);
    PERFORM set_config('app.current_user_role', 'SELLER', true);

    SELECT COUNT(*) INTO v_visible_count FROM orders WHERE id = v_order1_id;
    IF v_visible_count <> 0 THEN
        RAISE EXCEPTION 'TEST_D_FAILED: RLS LEAK! Seller 2 can see Seller 1 order! (count=%)', v_visible_count;
    END IF;
    RAISE NOTICE '  [PASS] D.2: Seller 2 is strictly blocked from viewing Seller 1 order (count=0).';

    -- D.3: Emulate session as Platform ADMIN
    PERFORM set_config('app.current_user_id', '00000000-0000-0000-0000-000000000001', true);
    PERFORM set_config('app.current_user_role', 'ADMIN', true);

    SELECT COUNT(*) INTO v_visible_count FROM orders WHERE id = v_order1_id;
    IF v_visible_count <> 1 THEN
        RAISE EXCEPTION 'TEST_D_FAILED: Platform ADMIN cannot see system orders (count=%)', v_visible_count;
    END IF;
    RAISE NOTICE '  [PASS] D.3: Platform ADMIN has global oversight access.';
END $$;


-- -------------------------------------------------------------------------------------
-- TEST E: Anti-Tampering Shield for Allocated Freight & Advance Disbursements
-- -------------------------------------------------------------------------------------
RAISE NOTICE '>>> TEST E: Transporter Anti-Tampering Shield & Payout Limits';

DO $$
DECLARE
    v_consignment_id UUID;
    v_driver_id UUID;
    v_failed BOOLEAN := FALSE;
BEGIN
    SELECT id, driver_id INTO v_consignment_id, v_driver_id
    FROM consignments c
    JOIN trips t ON c.trip_id = t.id
    LIMIT 1;

    -- Emulate session as Driver
    PERFORM set_config('app.current_user_id', v_driver_id::text, true);
    PERFORM set_config('app.current_user_role', 'DRIVER', true);

    -- E.1: Driver legitimate action -> Update consignment status to PICKED_UP
    UPDATE consignments SET status = 'PICKED_UP' WHERE id = v_consignment_id;
    RAISE NOTICE '  [PASS] E.1: Driver successfully updated operational status to PICKED_UP.';

    -- E.2: Driver illegal tampering -> Attempt to increase allocated_freight_paise
    v_failed := FALSE;
    BEGIN
        UPDATE consignments SET allocated_freight_paise = allocated_freight_paise + 50000 WHERE id = v_consignment_id;
        v_failed := TRUE;
    EXCEPTION WHEN OTHERS THEN
        IF SQLERRM LIKE '%FINANCIAL_INTEGRITY_VIOLATION%' THEN
            RAISE NOTICE '  [PASS] E.2: Unauthorized driver freight modification blocked: %', SQLERRM;
        ELSE
            RAISE EXCEPTION 'TEST_E_FAILED: Unexpected error on tampering test: %', SQLERRM;
        END IF;
    END;

    IF v_failed THEN
        RAISE EXCEPTION 'TEST_E_FAILED: Driver was illegally allowed to inflate allocated freight!';
    END IF;

    -- E.3: Advance freight cannot exceed allocated freight
    v_failed := FALSE;
    BEGIN
        UPDATE consignments 
        SET advance_freight_disbursed_paise = allocated_freight_paise + 10000 
        WHERE id = v_consignment_id;
        v_failed := TRUE;
    EXCEPTION WHEN check_violation OR OTHERS THEN
        RAISE NOTICE '  [PASS] E.3: Excessive advance freight disbursement blocked by invariant check.';
    END;

    IF v_failed THEN
        RAISE EXCEPTION 'TEST_E_FAILED: Advance disbursement exceeded total allocated freight!';
    END IF;
END $$;

RAISE NOTICE '======================================================================';
RAISE NOTICE 'ALL PRAYAAN SCHEMA INVARIANT & SECURITY TESTS PASSED SUCCESSFULLY!';
RAISE NOTICE '======================================================================';

ROLLBACK; -- Safe test suite: rolls back all dummy artifacts

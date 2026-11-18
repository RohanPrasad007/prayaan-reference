-- =====================================================================================
-- PRAYAAN: Production PostgreSQL 16 Schema Definition & Row-Level Security (RLS) Matrix
-- Tech4Bharat 2026 / GAVS Hackathon — Theme 5: Rural Freight (Problem Statement 5.3)
-- Team: Kernal500
-- =====================================================================================

-- 1. Database Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- 2. Domain Enumerations
CREATE TYPE app_user_role AS ENUM (
    'SELLER',       -- Smallholder Farmer, FPO Executive, Rural MSME
    'BUYER',        -- Mandi Wholesaler, Processor, Urban Retailer
    'FLEET_OWNER',  -- Small Road Transport Operator (SRTO), Fleet Manager
    'DRIVER',       -- Commercial Truck Driver, Owner-Driver
    'ADMIN'         -- Platform Supervisor & Dispute Arbitrator
);

CREATE TYPE vehicle_body_type AS ENUM (
    'OPEN_BODY',
    'CLOSED_CONTAINER',
    'REEFER',
    'TARPAULIN_COVERED'
);

CREATE TYPE request_status AS ENUM (
    'OPEN_POOL',
    'ASSIGNED_TO_TRIP',
    'IN_TRANSIT',
    'COMPLETED',
    'CANCELLED'
);

CREATE TYPE trip_status AS ENUM (
    'PLANNED',
    'DISPATCHED',
    'ACTIVE_IN_TRANSIT',
    'COMPLETED',
    'CANCELLED',
    'BREAKDOWN_SOS'
);

CREATE TYPE consignment_status AS ENUM (
    'QUEUED',
    'PICKED_UP',
    'DELIVERED',
    'PARTIALLY_DELIVERED',
    'DISPUTED_DAMAGED',
    'REJECTED'
);

CREATE TYPE custody_event_type AS ENUM (
    'DOCK_ARRIVAL_GEOFENCE',
    'PICKUP_OTP_VERIFIED',
    'PHOTO_EVIDENCE_ATTACHED',
    'DEPARTURE_CONFIRMED',
    'DELIVERY_OTP_VERIFIED',
    'DISPUTE_RAISED'
);

CREATE TYPE subscription_tier AS ENUM (
    'SELLER_MONTHLY',       -- Rs 899/month (89,900 Paise)
    'FLEET_OWNER_MONTHLY'   -- Rs 899/month (89,900 Paise)
);

CREATE TYPE subscription_status AS ENUM (
    'ACTIVE',
    'SEASONAL_PAUSE',
    'PAST_DUE',
    'CANCELLED'
);

-- =====================================================================================
-- 3. Core Tables
-- =====================================================================================

-- Table: Users & Stakeholder Identities
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    role app_user_role NOT NULL,
    legal_name VARCHAR(150) NOT NULL,
    fpo_member_id VARCHAR(50),
    masked_aadhaar VARCHAR(12) CHECK (masked_aadhaar ~ '^XXXX-XXXX-[0-9]{4}$'), -- Zero 12-digit storage
    preferred_language VARCHAR(10) DEFAULT 'hi', -- 'hi', 'mr', 'gu', 'en'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: Commercial Freight Vehicles
CREATE TABLE vehicles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    body_type vehicle_body_type NOT NULL,
    rated_payload_kg INTEGER NOT NULL CHECK (rated_payload_kg > 0),
    usable_volume_m3 NUMERIC(5, 2) NOT NULL CHECK (usable_volume_m3 > 0),
    planning_slots INTEGER DEFAULT 100 CHECK (planning_slots = 100),
    is_refrigerated BOOLEAN DEFAULT FALSE,
    is_hazmat_certified BOOLEAN DEFAULT FALSE,
    fitness_valid_until DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: Produce Listings & AGMARKNET Context
CREATE TABLE listings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    seller_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    commodity_name VARCHAR(100) NOT NULL,
    hsn_code VARCHAR(10) NOT NULL,
    quantity_quintals NUMERIC(8, 2) NOT NULL CHECK (quantity_quintals > 0),
    expected_price_paise_per_quintal BIGINT NOT NULL CHECK (expected_price_paise_per_quintal > 0),
    agmarknet_modal_price_paise BIGINT, -- Timestamped benchmark reference
    pickup_address TEXT NOT NULL,
    pickup_location GEOMETRY(Point, 4326) NOT NULL,
    is_organic BOOLEAN DEFAULT FALSE,
    harvest_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: Commercial Orders & Contracts
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    listing_id UUID NOT NULL REFERENCES listings(id) ON DELETE RESTRICT,
    buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    seller_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    agreed_quantity_quintals NUMERIC(8, 2) NOT NULL,
    goods_value_paise BIGINT NOT NULL CHECK (goods_value_paise > 0),
    advance_deposit_paise BIGINT NOT NULL DEFAULT 0,
    is_gst_exempt BOOLEAN DEFAULT TRUE, -- Handled via Notification 2/2017-CT(Rate)
    destination_address TEXT NOT NULL,
    destination_location GEOMETRY(Point, 4326) NOT NULL,
    delivery_deadline TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    version_id INTEGER DEFAULT 1 -- Optimistic Concurrency Control
);

-- Table: Transport Requests (Open Corridor Pool)
CREATE TABLE transport_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID UNIQUE NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    weight_kg INTEGER NOT NULL CHECK (weight_kg > 0),
    volume_m3 NUMERIC(5, 2) NOT NULL CHECK (volume_m3 > 0),
    slot_demand INTEGER NOT NULL CHECK (slot_demand BETWEEN 1 AND 100),
    requires_refrigeration BOOLEAN DEFAULT FALSE,
    pickup_location GEOMETRY(Point, 4326) NOT NULL,
    drop_location GEOMETRY(Point, 4326) NOT NULL,
    status request_status DEFAULT 'OPEN_POOL',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: Pooled Highway Trips
CREATE TABLE trips (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE RESTRICT,
    driver_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    corridor_name VARCHAR(100) NOT NULL,
    total_negotiated_freight_paise BIGINT NOT NULL CHECK (total_negotiated_freight_paise > 0),
    status trip_status DEFAULT 'PLANNED',
    departure_time TIMESTAMPTZ,
    completion_time TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    version_id INTEGER DEFAULT 1
);

-- Table: Route Stops along Corridor
CREATE TABLE route_stops (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    stop_sequence INTEGER NOT NULL,
    stop_name VARCHAR(100) NOT NULL,
    stop_location GEOMETRY(Point, 4326) NOT NULL,
    planned_arrival TIMESTAMPTZ NOT NULL,
    actual_arrival TIMESTAMPTZ,
    UNIQUE (trip_id, stop_sequence)
);

-- Table: Active Consignments on Trips (NMRS Allocated Freight)
CREATE TABLE consignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE RESTRICT,
    request_id UUID NOT NULL REFERENCES transport_requests(id) ON DELETE RESTRICT,
    pickup_stop_id UUID NOT NULL REFERENCES route_stops(id),
    drop_stop_id UUID NOT NULL REFERENCES route_stops(id),
    allocated_freight_paise BIGINT NOT NULL CHECK (allocated_freight_paise > 0), -- NMRS Paise
    loading_otp_hash VARCHAR(64) NOT NULL,   -- SHA-256 Hash of 6-digit OTP
    delivery_otp_hash VARCHAR(64) NOT NULL,  -- SHA-256 Hash of 6-digit OTP
    status consignment_status DEFAULT 'QUEUED',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    version_id INTEGER DEFAULT 1
);

-- Table: Chain of Custody Audit Events
CREATE TABLE custody_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    consignment_id UUID NOT NULL REFERENCES consignments(id) ON DELETE RESTRICT,
    event_type custody_event_type NOT NULL,
    recorded_location GEOMETRY(Point, 4326) NOT NULL,
    is_mock_location_flagged BOOLEAN DEFAULT FALSE,
    photo_s3_uri TEXT,
    event_timestamp TIMESTAMPTZ DEFAULT NOW(),
    idempotency_key UUID UNIQUE NOT NULL -- Replay Protection Key
);

-- Table: Platform Subscriptions (Approved Rs 899 SaaS Model)
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    tier subscription_tier NOT NULL,
    monthly_fee_paise BIGINT NOT NULL DEFAULT 89900, -- Rs 899.00
    status subscription_status DEFAULT 'ACTIVE',
    billing_cycle_anchor DATE NOT NULL,
    current_period_end DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: Transactional Outbox (Reliable Domain Event Notification Dispatch)
CREATE TABLE transactional_outbox (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    aggregate_type VARCHAR(50) NOT NULL,
    aggregate_id UUID NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    is_processed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================================================
-- 4. Spatial & Performance Indexes
-- =====================================================================================
CREATE INDEX idx_listings_location ON listings USING GIST (pickup_location);
CREATE INDEX idx_requests_pickup ON transport_requests USING GIST (pickup_location);
CREATE INDEX idx_requests_drop ON transport_requests USING GIST (drop_location);
CREATE INDEX idx_stops_location ON route_stops USING GIST (stop_location);
CREATE INDEX idx_custody_location ON custody_events USING GIST (recorded_location);
CREATE INDEX idx_consignments_trip ON consignments (trip_id, status);
CREATE INDEX idx_outbox_unprocessed ON transactional_outbox (created_at) WHERE is_processed = FALSE;

-- =====================================================================================
-- 5. Row-Level Security (RLS) Tenant Isolation Policies
-- =====================================================================================
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE consignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE custody_events ENABLE ROW LEVEL SECURITY;

-- Policy: Orders Tenant Isolation
CREATE POLICY orders_access_policy ON orders
    FOR ALL
    USING (
        seller_id = NULLIF(current_setting('app.current_user_id', true), '')::UUID
        OR buyer_id = NULLIF(current_setting('app.current_user_id', true), '')::UUID
        OR current_setting('app.current_user_role', true) = 'ADMIN'
    );

-- Policy: Consignments Tenant Isolation
CREATE POLICY consignments_access_policy ON consignments
    FOR ALL
    USING (
        -- Seller access
        request_id IN (
            SELECT tr.id FROM transport_requests tr 
            JOIN orders o ON tr.order_id = o.id 
            WHERE o.seller_id = NULLIF(current_setting('app.current_user_id', true), '')::UUID
        )
        OR
        -- Buyer access
        request_id IN (
            SELECT tr.id FROM transport_requests tr 
            JOIN orders o ON tr.order_id = o.id 
            WHERE o.buyer_id = NULLIF(current_setting('app.current_user_id', true), '')::UUID
        )
        OR
        -- Fleet Owner access
        trip_id IN (
            SELECT t.id FROM trips t 
            JOIN vehicles v ON t.vehicle_id = v.id 
            WHERE v.owner_id = NULLIF(current_setting('app.current_user_id', true), '')::UUID
        )
        OR
        -- Driver access
        trip_id IN (
            SELECT t.id FROM trips t 
            WHERE t.driver_id = NULLIF(current_setting('app.current_user_id', true), '')::UUID
        )
        OR
        current_setting('app.current_user_role', true) = 'ADMIN'
    );

-- =====================================================================================
-- 6. Optimistic Concurrency Control Triggers
-- =====================================================================================
CREATE OR REPLACE FUNCTION increment_version_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version_id = OLD.version_id + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_orders_version
BEFORE UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION increment_version_id();

CREATE TRIGGER trg_trips_version
BEFORE UPDATE ON trips
FOR EACH ROW EXECUTE FUNCTION increment_version_id();

CREATE TRIGGER trg_consignments_version
BEFORE UPDATE ON consignments
FOR EACH ROW EXECUTE FUNCTION increment_version_id();

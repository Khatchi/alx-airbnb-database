-- database_index.sql
-- File containing CREATE INDEX commands to optimize query performance for the Airbnb Backend System.
-- Generated on: May 16, 2025, 10:18 AM WAT

-- Indexes for User Table
-- Index on role for filtering by role (e.g., WHERE role = 'admin')
-- yeah
CREATE INDEX idx_user_role ON User (role);

-- Index on created_at for sorting or filtering by date (e.g., ORDER BY created_at DESC)
CREATE INDEX idx_user_created_at ON User (created_at);

-- Indexes for Booking Table
-- Index on user_id (foreign key) for joins and filtering (e.g., JOIN with User, GROUP BY user_id)
CREATE INDEX idx_booking_user_id ON Booking (user_id);

-- Index on property_id (foreign key) for joins and grouping (e.g., JOIN with Property, GROUP BY property_id)
CREATE INDEX idx_booking_property_id ON Booking (property_id);

-- Composite index on start_date and end_date for range queries (e.g., availability checks)
CREATE INDEX idx_booking_date_range ON Booking (start_date, end_date);

-- Index on status for filtering (e.g., WHERE status = 'confirmed')
CREATE INDEX idx_booking_status ON Booking (status);

-- Index on created_at for sorting or filtering by date (e.g., ORDER BY created_at DESC)
CREATE INDEX idx_booking_created_at ON Booking (created_at);

-- Indexes for Property Table
-- Index on host_id (foreign key) for joins and filtering (e.g., JOIN with User, WHERE host_id = 'UUID')
CREATE INDEX idx_property_host_id ON Property (host_id);

-- Index on location for filtering (e.g., WHERE location = 'Miami, FL')
CREATE INDEX idx_property_location ON Property (location);

-- Index on pricepernight for filtering or sorting (e.g., WHERE pricepernight <= 200.00, ORDER BY pricepernight)
CREATE INDEX idx_property_pricepernight ON Property (pricepernight);

-- Index on created_at for sorting or filtering by date (e.g., ORDER BY created_at DESC)
CREATE INDEX idx_property_created_at ON Property (created_at);

-- Index on updated_at for sorting or filtering by date (e.g., ORDER BY updated_at DESC)
CREATE INDEX idx_property_updated_at ON Property (updated_at);

-- Optional: Full-text index on location for partial match searches (PostgreSQL-specific)
-- Uncomment the following if partial match searches (e.g., WHERE location LIKE '%Miami%') are common
-- CREATE INDEX idx_property_location_fts ON Property USING GIN (to_tsvector('english', location));
-- database_index.sql
-- File containing CREATE INDEX commands to optimize query performance for the Airbnb Backend System.
-- Generated on: May 16, 2025, 10:18 AM WAT

-- Indexes for User Table
-- Index on role for filtering by role (e.g., WHERE role = 'admin')
--
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


-- database.sql
-- Consolidated SQL commands for the Airbnb Backend System.
-- Includes queries, index creation, and performance analysis commands.
-- Generated on: May 16, 2025, 10:46 AM WAT

-- ---------------------------------------
-- Section 1: Query to Retrieve Bookings and Users (INNER JOIN)
-- ---------------------------------------
SELECT 
    b.booking_id,
    b.property_id,
    b.user_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role
FROM 
    Booking b
INNER JOIN 
    User u
ON 
    b.user_id = u.user_id;

-- ---------------------------------------
-- Section 2: Query to Retrieve Properties and Reviews (LEFT JOIN)
-- ---------------------------------------
SELECT 
    p.property_id,
    p.host_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at,
    r.review_id,
    r.user_id AS reviewer_id,
    r.rating,
    r.comment,
    r.created_at AS review_created_at
FROM 
    Property p
LEFT JOIN 
    Review r
ON 
    p.property_id = r.property_id;

-- ---------------------------------------
-- Section 3: Query to Retrieve Users and Bookings (FULL OUTER JOIN)
-- ---------------------------------------
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at
FROM 
    User u
FULL OUTER JOIN 
    Booking b
ON 
    u.user_id = b.user_id;

-- ---------------------------------------
-- Section 4: Query to Find Properties with Average Rating > 4.0 (Subquery)
-- ---------------------------------------
SELECT 
    p.property_id,
    p.host_id,
    p.name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at,
    p.updated_at
FROM 
    Property p
WHERE 
    p.property_id IN (
        SELECT 
            r.property_id
        FROM 
            Review r
        GROUP BY 
            r.property_id
        HAVING 
            AVG(r.rating) > 4.0
    );

-- ---------------------------------------
-- Section 5: Correlated Subquery to Find Users with More Than 3 Bookings
-- ---------------------------------------
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at
FROM 
    User u
WHERE (
    SELECT 
        COUNT(*)
    FROM 
        Booking b
    WHERE 
        b.user_id = u.user_id
) > 3;

-- ---------------------------------------
-- Section 6: Query to Find Total Bookings per User (COUNT and GROUP BY)
-- ---------------------------------------
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    COUNT(b.booking_id) AS total_bookings
FROM 
    User u
LEFT JOIN 
    Booking b
ON 
    u.user_id = b.user_id
GROUP BY 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role;

-- ---------------------------------------
-- Section 7: Query to Rank Properties by Total Bookings (ROW_NUMBER)
-- ---------------------------------------
WITH BookingCounts AS (
    SELECT 
        p.property_id,
        p.host_id,
        p.name,
        p.description,
        p.location,
        p.pricepernight,
        p.created_at,
        p.updated_at,
        COUNT(b.booking_id) AS total_bookings
    FROM 
        Property p
    LEFT JOIN 
        Booking b
    ON 
        p.property_id = b.property_id
    GROUP BY 
        p.property_id,
        p.host_id,
        p.name,
        p.description,
        p.location,
        p.pricepernight,
        p.created_at,
        p.updated_at
)
SELECT 
    property_id,
    host_id,
    name,
    description,
    location,
    pricepernight,
    created_at,
    updated_at,
    total_bookings,
    ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM 
    BookingCounts;

-- ---------------------------------------
-- Section 8: CREATE INDEX Commands for High-Usage Columns
-- ---------------------------------------
-- Indexes for User Table
CREATE INDEX idx_user_role ON User (role);
CREATE INDEX idx_user_created_at ON User (created_at);

-- Indexes for Booking Table
CREATE INDEX idx_booking_user_id ON Booking (user_id);
CREATE INDEX idx_booking_property_id ON Booking (property_id);
CREATE INDEX idx_booking_date_range ON Booking (start_date, end_date);
CREATE INDEX idx_booking_status ON Booking (status);
CREATE INDEX idx_booking_created_at ON Booking (created_at);

-- Indexes for Property Table
CREATE INDEX idx_property_host_id ON Property (host_id);
CREATE INDEX idx_property_location ON Property (location);
CREATE INDEX idx_property_pricepernight ON Property (pricepernight);
CREATE INDEX idx_property_created_at ON Property (created_at);
CREATE INDEX idx_property_updated_at ON Property (updated_at);

-- Optional: Full-text index on location (PostgreSQL-specific)
-- CREATE INDEX idx_property_location_fts ON Property USING GIN (to_tsvector('english', location));

-- ---------------------------------------
-- Section 9: Performance Analysis Queries (For Reference)
-- ---------------------------------------
/*
 * These commands were used to analyze query performance before and after indexing.
 * They are included here for reference but are typically run interactively.
 */

-- Query 1: Total Bookings per User (Analyzed with idx_booking_user_id)
-- EXPLAIN ANALYZE
-- SELECT 
--     u.user_id,
--     u.first_name,
--     u.last_name,
--     u.email,
--     u.phone_number,
--     u.role,
--     COUNT(b.booking_id) AS total_bookings
-- FROM 
--     User u
-- LEFT JOIN 
--     Booking b
-- ON 
--     u.user_id = b.user_id
-- GROUP BY 
--     u.user_id,
--     u.first_name,
--     u.last_name,
--     u.email,
--     u.phone_number,
--     u.role
-- ORDER BY 
--     total_bookings DESC;

-- Query 2: Date Range Query on Bookings (Analyzed with idx_booking_date_range)
-- EXPLAIN ANALYZE
-- SELECT 
--     b.booking_id,
--     b.property_id,
--     b.user_id,
--     b.start_date,
--     b.end_date,
--     b.total_price,
--     b.status
-- FROM 
--     Booking b
-- WHERE 
--     b.start_date <= '2025-06-05'
--     AND b.end_date >= '2025-06-01';

-- Query 3: Property Search Query (Analyzed with idx_property_location and idx_property_pricepernight)
-- EXPLAIN ANALYZE
-- SELECT 
--     p.property_id,
--     p.host_id,
--     p.name,
--     p.description,
--     p.location,
--     p.pricepernight,
--     p.created_at,
--     p.updated_at
-- FROM 
--     Property p
-- WHERE 
--     p.location = 'Miami, FL'
-- ORDER BY 
--     p.pricepernight DESC;

-- Optional Composite Index for Query 3 (Not executed but suggested for further optimization)
-- CREATE INDEX idx_property_location_pricepernight ON Property (location, pricepernight DESC);
-- performance.sql
-- Initial query to retrieve all bookings with user,
-- property, and payment details,
-- along with performance analysis commands.


-- Main Query
SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.status AS payment_status,
    pay.created_at AS payment_created_at
FROM 
    Booking b
INNER JOIN 
    User u
ON 
    b.user_id = u.user_id
INNER JOIN 
    Property p
ON 
    b.property_id = p.property_id
INNER JOIN 
    Payment pay
ON 
    b.booking_id = pay.booking_id;

-- Performance Analysis Commands 

EXPLAIN
SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.status AS payment_status,
    pay.created_at AS payment_created_at
FROM 
    Booking b
INNER JOIN 
    User u
ON 
    b.user_id = u.user_id
INNER JOIN 
    Property p
ON 
    b.property_id = p.property_id
INNER JOIN 
    Payment pay
ON 
    b.booking_id = pay.booking_id;

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.status AS payment_status,
    pay.created_at AS payment_created_at
FROM 
    Booking b
INNER JOIN 
    User u
ON 
    b.user_id = u.user_id
INNER JOIN 
    Property p
ON 
    b.property_id = p.property_id
INNER JOIN 
    Payment pay
ON 
    b.booking_id = pay.booking_id;

-- This is the refactored query

SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total_price,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.status AS payment_status
FROM 
    Booking b
INNER JOIN 
    User u
ON 
    b.user_id = u.user_id
INNER JOIN 
    Property p
ON 
    b.property_id = p.property_id
INNER JOIN 
    Payment pay
ON 
    b.booking_id = pay.booking_id
WHERE 
    b.status = 'confirmed'
    AND pay.status = 'completed'
    AND b.created_at >= '2025-01-01'
ORDER BY 
    b.created_at DESC
LIMIT 100 OFFSET 0;
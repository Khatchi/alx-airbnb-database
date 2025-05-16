-- Aggregate function using COUNT and GROUP BY 
-- to find total number of bookings made by each user
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

-- Using window function (ROW_NUMBER, RANK) to rank properties based 
-- on the total number of bookings they have received.

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
    RANK() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM 
    BookingCounts;
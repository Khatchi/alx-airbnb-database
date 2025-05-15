-- This query returns a result set
-- with booking details alongside 
-- the user’s information for each booking.

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


-- This query uses LEFT JOIN to retrieve all the 
-- propert and review attr including those without reviews

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


-- query using a FULL OUTER JOIN to retrieve all users and all bookings, even
-- if the user has no booking or a booking is not linked to a user

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
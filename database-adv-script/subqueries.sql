-- Subquery that finds all properties where 
-- the average rating is greater than 4.0 .
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

-- Correlated subquery that finds users who made more than three bookings

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
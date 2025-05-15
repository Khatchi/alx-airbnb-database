### Writing Complex Queries with Joins

### For The FULL OUTER JOIN
**Edge Case:**
    In a well-designed database, every booking should have a user_id due to the NOT NULL foreign key constraint on Booking.user_id. Therefore, in practice, you’re unlikely to see bookings with NULL user details (as shown in the last row of the example output). However, the FULL OUTER JOIN is written to theoretically allow for such cases, as requested.

    If your database enforces the foreign key constraint (which it should), the query will effectively behave like a LEFT JOIN from User to Booking, showing all users and their bookings (if any), with no rows having NULL user details.

- **So, in Practise, the query should be:**
```sql
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
    LEFT JOIN 
        Booking b
    ON 
        u.user_id = b.user_id;
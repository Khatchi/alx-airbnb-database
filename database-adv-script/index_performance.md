## 📊 Database Optimization: High-Usage Columns Summary

This section identifies high-usage columns in the `User`, `Booking`, and `Property` tables of the Airbnb Backend System. High-usage columns are those frequently involved in `WHERE`, `JOIN`, and `ORDER BY` clauses, as these operations benefit from indexing to improve query performance. The analysis is based on common query patterns and the provided schema.

### 🧑 User Table
- **Schema**:
  - `user_id`: Primary Key, UUID, Indexed
  - `first_name`: VARCHAR, NOT NULL
  - `last_name`: VARCHAR, NOT NULL
  - `email`: VARCHAR, UNIQUE, NOT NULL
  - `password_hash`: VARCHAR, NOT NULL
  - `phone_number`: VARCHAR, NULL
  - `role`: ENUM (guest, host, admin), NOT NULL
  - `created_at`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

- **High-Usage Columns**:
  - **`user_id`**:
    - **Usage**: Used in `JOIN` (e.g., with `Booking`, `Property`), `WHERE` (e.g., correlated subqueries to count bookings).
    - **Status**: Already indexed (primary key).
  - **`email`**:
    - **Usage**: Used in `WHERE` (e.g., for login, password reset: `WHERE email = 'user@example.com'`).
    - **Status**: Likely indexed (`UNIQUE` constraint); confirm with database.
  - **`role`**:
    - **Usage**: Used in `WHERE` (e.g., `WHERE role = 'admin'` for role-based access).
    - **Recommendation**: Consider indexing if filtering by role is frequent.
  - **`created_at`**:
    - **Usage**: Potential use in `WHERE` (e.g., `WHERE created_at > '2025-01-01'`) or `ORDER BY` (e.g., `ORDER BY created_at DESC`).
    - **Recommendation**: Consider indexing if sorting or filtering by date is common.

### 📅 Booking Table
- **Schema**:
  - `booking_id`: Primary Key, UUID, Indexed
  - `property_id`: Foreign Key, references Property(property_id)
  - `user_id`: Foreign Key, references User(user_id)
  - `start_date`: DATE, NOT NULL
  - `end_date`: DATE, NOT NULL
  - `total_price`: DECIMAL, NOT NULL
  - `status`: ENUM (pending, confirmed, canceled), NOT NULL
  - `created_at`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

- **High-Usage Columns**:
  - **`user_id`**:
    - **Usage**: Used in `JOIN` (e.g., with `User`), `WHERE` (e.g., correlated subqueries), `GROUP BY` (e.g., to count bookings per user).
    - **Recommendation**: Should be indexed (foreign key).
  - **`property_id`**:
    - **Usage**: Used in `JOIN` (e.g., with `Property`), `GROUP BY` (e.g., to rank properties by booking count).
    - **Recommendation**: Should be indexed (foreign key).
  - **`start_date` and `end_date`**:
    - **Usage**: Used in `WHERE` (e.g., for availability checks: `WHERE start_date <= '2025-06-05' AND end_date >= '2025-06-01'`).
    - **Recommendation**: Consider a composite index on `(start_date, end_date)` for range queries.
  - **`status`**:
    - **Usage**: Used in `WHERE` (e.g., `WHERE status = 'confirmed'` to filter confirmed bookings).
    - **Recommendation**: Consider indexing if filtering by status is frequent.
  - **`created_at`**:
    - **Usage**: Potential use in `WHERE` (e.g., `WHERE created_at >= '2025-01-01'`) or `ORDER BY` (e.g., `ORDER BY created_at DESC`).
    - **Recommendation**: Consider indexing if sorting or filtering by date is common.

### 🏠 Property Table
- **Schema**:
  - `property_id`: Primary Key, UUID, Indexed
  - `host_id`: Foreign Key, references User(user_id)
  - `name`: VARCHAR, NOT NULL
  - `description`: TEXT, NOT NULL
  - `location`: VARCHAR, NOT NULL
  - `pricepernight`: DECIMAL, NOT NULL
  - `created_at`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
  - `updated_at`: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

- **High-Usage Columns**:
  - **`property_id`**:
    - **Usage**: Used in `JOIN` (e.g., with `Booking`, `Review`), `WHERE` (e.g., subqueries for high-rated properties), `GROUP BY`.
    - **Status**: Already indexed (primary key).
  - **`host_id`**:
    - **Usage**: Used in `JOIN` (e.g., with `User`), `WHERE` (e.g., `WHERE host_id = 'UUID'` to filter by host).
    - **Recommendation**: Should be indexed (foreign key).
  - **`location`**:
    - **Usage**: Used in `WHERE` (e.g., `WHERE location = 'Miami, FL'` or `WHERE location LIKE '%Miami%'` for search).
    - **Recommendation**: Consider indexing for exact matches; use a full-text index for partial matches (e.g., `LIKE`).
  - **`pricepernight`**:
    - **Usage**: Used in `WHERE` (e.g., `WHERE pricepernight <= 200.00`), `ORDER BY` (e.g., tie-breaker in rankings).
    - **Recommendation**: Consider indexing if sorting or filtering by price is frequent.
  - **`created_at` and `updated_at`**:
    - **Usage**: Potential use in `WHERE` (e.g., `WHERE updated_at > '2025-01-01'`) or `ORDER BY` (e.g., `ORDER BY updated_at DESC`).
    - **Recommendation**: Consider indexing if sorting or filtering by date is common.

### 📝 Indexing Recommendations
- **Already Indexed**:
  - `User.user_id`, `Booking.booking_id`, `Property.property_id` (primary keys).
  - `User.email` (likely indexed due to `UNIQUE`; confirm with database).
- **Should Be Indexed**:
  - `Booking.user_id`, `Booking.property_id`, `Property.host_id` (foreign keys; critical for joins).
- **Consider Indexing** (Based on Usage Patterns):
  - `User.role`, `Booking.status`, `Property.location` (for frequent filtering).
  - `Booking.start_date` and `end_date` (composite index for range queries).
  - `User.created_at`, `Booking.created_at`, `Property.created_at`, `Property.updated_at` (for date-based sorting/filtering).
  - `Property.pricepernight` (for price-based sorting/filtering).

### ⚠️ Notes
- Indexes improve read performance but can slow down writes. Only add indexes for columns used in performance-critical queries.
- For `Property.location` or `Property.description`, if partial matching (`LIKE '%search%'`) is common, consider a full-text index (e.g., in PostgreSQL with `tsvector`).


## 📈 Query Performance Analysis: Date Range Query Before and After Indexing

This section summarizes the performance analysis of a date range query in the Airbnb Backend System, evaluating the impact of adding a composite index on `Booking.start_date` and `Booking.end_date`. The analysis was conducted using PostgreSQL's `EXPLAIN` and `EXPLAIN ANALYZE` commands to measure query execution plans and runtime performance before and after applying the index from `database_index.sql`.

*Analysis conducted on: May 16, 2025, 10:41 AM WAT*

### 📋 Query Analyzed
The following query was analyzed, as it involves a range filter on `Booking.start_date` and `Booking.end_date`, common for availability checks:

```sql
SELECT 
    b.booking_id,
    b.property_id,
    b.user_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM 
    Booking b
WHERE 
    b.start_date <= '2025-06-05'
    AND b.end_date >= '2025-06-01';
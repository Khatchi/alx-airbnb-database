-- partitioning.sql
-- Implements range partitioning on the Booking table based on the start_date column.

-- Step 1: Rename the existing Booking table to avoid conflicts
ALTER TABLE Booking RENAME TO Booking_old;

-- Step 2: Create the new partitioned Booking table
CREATE TABLE Booking (
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'canceled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT booking_pk PRIMARY KEY (booking_id, start_date),
    CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES Property (property_id),
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES User (user_id)
) PARTITION BY RANGE (start_date);

-- Step 3: Create partitions for specific years
-- Partition for 2023
CREATE TABLE booking_2023 PARTITION OF Booking
    FOR VALUES FROM ('2023-01-01') TO ('2023-12-31');

-- Partition for 2024
CREATE TABLE booking_2024 PARTITION OF Booking
    FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');

-- Partition for 2025
CREATE TABLE booking_2025 PARTITION OF Booking
    FOR VALUES FROM ('2025-01-01') TO ('2025-12-31');

-- Partition for 2026 and beyond (future bookings)
CREATE TABLE booking_future PARTITION OF Booking
    FOR VALUES FROM ('2026-01-01') TO (MAXVALUE);

-- Partition for older dates (before 2023)
CREATE TABLE booking_old_dates PARTITION OF Booking
    FOR VALUES FROM (MINVALUE) TO ('2022-12-31');

-- Step 4: Create indexes on each partition
-- Index on user_id
CREATE INDEX idx_booking_user_id_2023 ON booking_2023 (user_id);
CREATE INDEX idx_booking_user_id_2024 ON booking_2024 (user_id);
CREATE INDEX idx_booking_user_id_2025 ON booking_2025 (user_id);
CREATE INDEX idx_booking_user_id_future ON booking_future (user_id);
CREATE INDEX idx_booking_user_id_old ON booking_old_dates (user_id);

-- Index on property_id
CREATE INDEX idx_booking_property_id_2023 ON booking_2023 (property_id);
CREATE INDEX idx_booking_property_id_2024 ON booking_2024 (property_id);
CREATE INDEX idx_booking_property_id_2025 ON booking_2025 (property_id);
CREATE INDEX idx_booking_property_id_future ON booking_future (property_id);
CREATE INDEX idx_booking_property_id_old ON booking_old_dates (property_id);

-- Composite index on (start_date, end_date)
CREATE INDEX idx_booking_date_range_2023 ON booking_2023 (start_date, end_date);
CREATE INDEX idx_booking_date_range_2024 ON booking_2024 (start_date, end_date);
CREATE INDEX idx_booking_date_range_2025 ON booking_2025 (start_date, end_date);
CREATE INDEX idx_booking_date_range_future ON booking_future (start_date, end_date);
CREATE INDEX idx_booking_date_range_old ON booking_old_dates (start_date, end_date);

-- Index on status
CREATE INDEX idx_booking_status_2023 ON booking_2023 (status);
CREATE INDEX idx_booking_status_2024 ON booking_2024 (status);
CREATE INDEX idx_booking_status_2025 ON booking_2025 (status);
CREATE INDEX idx_booking_status_future ON booking_future (status);
CREATE INDEX idx_booking_status_old ON booking_old_dates (status);

-- Index on created_at
CREATE INDEX idx_booking_created_at_2023 ON booking_2023 (created_at);
CREATE INDEX idx_booking_created_at_2024 ON booking_2024 (created_at);
CREATE INDEX idx_booking_created_at_2025 ON booking_2025 (created_at);
CREATE INDEX idx_booking_created_at_future ON booking_future (created_at);
CREATE INDEX idx_booking_created_at_old ON booking_old_dates (created_at);

-- Composite index on (status, created_at)
CREATE INDEX idx_booking_status_created_at_2023 ON booking_2023 (status, created_at);
CREATE INDEX idx_booking_status_created_at_2024 ON booking_2024 (status, created_at);
CREATE INDEX idx_booking_status_created_at_2025 ON booking_2025 (status, created_at);
CREATE INDEX idx_booking_status_created_at_future ON booking_future (status, created_at);
CREATE INDEX idx_booking_status_created_at_old ON booking_old_dates (status, created_at);

-- Step 5: Migrate data from the old table to the new partitioned table
INSERT INTO Booking
SELECT * FROM Booking_old;

-- Step 6: Drop the old table after successful migration
DROP TABLE Booking_old;

-- Step 7: Analyze the table to update statistics for the query planner
ANALYZE Booking;
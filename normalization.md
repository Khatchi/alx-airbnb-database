# Database Normalization Report: AirBnB Clone

## Overview
This document details the normalization process for the AirBnB clone database schema to achieve Third Normal Form (3NF), eliminating redundancies and ensuring data integrity.

## Current Schema Assessment

### Identified Issues
| Table | Problem | Normalization Violation |
|-------|---------|-------------------------|
| Booking | `total_price` can be derived | 2NF (partial dependency) |
| Payment | `payment_method` depends on User | 3NF (transitive dependency) |

## Normalization Process

### 1NF Compliance ✅
All tables satisfy First Normal Form:
- Atomic values in all columns
- Proper primary keys (UUID)
- No repeating groups

### 2NF Compliance 🔧
**Improvements made:**
- Removed derived `total_price` from Booking table
- Price now calculated dynamically:
  ```sql
  SELECT (end_date - start_date) * pricepernight 
  FROM bookings JOIN properties USING (property_id)

### 3NF Compliance 🔍
***Key changes:**

- Created new user_payment_methods table:
  ```sql
  CREATE TABLE user_payment_methods (
    method_id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(user_id),
    payment_type ENUM('credit_card','paypal','stripe') NOT NULL,
    last_four_digits CHAR(4),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

- Modified Payment table:
  ```sql
    ALTER TABLE payments
    ADD COLUMN method_id UUID REFERENCES user_payment_methods(method_id),
    DROP COLUMN payment_method;


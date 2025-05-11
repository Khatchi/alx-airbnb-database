# AirBnB Database Schema

| Entity    | Attributes (Type)                                                                 | Constraints                                                                 |
|-----------|----------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| **User**  | `user_id` (UUID, PK) <br> `email` (VARCHAR) <br> `role` (ENUM) <br> `created_at` (TIMESTAMP) | `email` UNIQUE <br> `role IN ('guest','host','admin')` <br> NOT NULL: email, password_hash |
| **Property** | `property_id` (UUID, PK) <br> `host_id` (UUID, FK→User) <br> `pricepernight` (DECIMAL) <br> `updated_at` (TIMESTAMP) | `host_id` REFERENCES User <br> NOT NULL: name, location <br> `pricepernight > 0` |
| **Booking** | `booking_id` (UUID, PK) <br> `property_id` (UUID, FK→Property) <br> `status` (ENUM) <br> `total_price` (DECIMAL) | `status IN ('pending','confirmed','canceled')` <br> `total_price > 0` <br> `end_date > start_date` |
| **Payment** | `payment_id` (UUID, PK) <br> `booking_id` (UUID, FK→Booking) <br> `payment_method` (ENUM) | `payment_method IN ('credit_card','paypal','stripe')` <br> `amount > 0` |
| **Review** | `review_id` (UUID, PK) <br> `property_id` (UUID, FK→Property) <br> `rating` (INT) <br> `comment` (TEXT) | `rating BETWEEN 1 AND 5` <br> NOT NULL: rating, comment |
| **Message** | `message_id` (UUID, PK) <br> `sender_id` (UUID, FK→User) <br> `recipient_id` (UUID, FK→User) | `sender_id ≠ recipient_id` <br> NOT NULL: message_body |

### Key Symbols:
- **PK**: Primary Key
- **FK→X**: Foreign Key references X entity
- **ENUM**: Predefined list of values
- **NOT NULL**: Field is required


# AirBnB Database Relationships

| Relationship                          | Type          | Description                                                                 | Foreign Key Mapping                     |
|---------------------------------------|---------------|-----------------------------------------------------------------------------|-----------------------------------------|
| **User → Property**                   | One-to-Many   | A user (host) can list multiple properties                                  | `Property.host_id` → `User.user_id`     |
| **User → Booking**                    | One-to-Many   | A user (guest) can make multiple bookings                                   | `Booking.user_id` → `User.user_id`      |
| **Property → Booking**                | One-to-Many   | A property can have multiple bookings                                       | `Booking.property_id` → `Property.property_id` |
| **Booking → Payment**                 | One-to-One    | Each booking has exactly one payment record                                 | `Payment.booking_id` → `Booking.booking_id` |
| **Property → Review**                 | One-to-Many   | A property can receive multiple reviews                                    | `Review.property_id` → `Property.property_id` |
| **User → Review**                     | One-to-Many   | A user can write multiple reviews                                          | `Review.user_id` → `User.user_id`       |
| **User → Message (as Sender)**        | One-to-Many   | A user can send multiple messages                                          | `Message.sender_id` → `User.user_id`    |
| **User → Message (as Recipient)**     | One-to-Many   | A user can receive multiple messages                                       | `Message.recipient_id` → `User.user_id` |

### Relationship Symbols:
- **→** : "References" (foreign key direction)
- **One-to-Many (1:N)**: Single parent, multiple children (e.g., one host → many properties)
- **One-to-One (1:1)**: Strict 1:1 correspondence (e.g., booking:payment)
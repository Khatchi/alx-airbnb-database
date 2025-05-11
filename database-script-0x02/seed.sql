-- Insert sample data into User table
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Alice', 'Smith', 'alice.smith@email.com', 'hash123', '555-0101', 'guest', '2025-01-01 10:00:00'),
('550e8400-e29b-41d4-a716-446655440001', 'Bob', 'Johnson', 'bob.johnson@email.com', 'hash456', '555-0102', 'host', '2025-01-02 12:00:00'),
('550e8400-e29b-41d4-a716-446655440002', 'Carol', 'Williams', 'carol.williams@email.com', 'hash789', '555-0103', 'guest', '2025-01-03 14:00:00'),
('550e8400-e29b-41d4-a716-446655440003', 'David', 'Brown', 'david.brown@email.com', 'hash012', '555-0104', 'host', '2025-01-04 16:00:00'),
('550e8400-e29b-41d4-a716-446655440004', 'Emma', 'Davis', 'emma.davis@email.com', 'hash345', '555-0105', 'admin', '2025-01-05 18:00:00');

-- Insert sample data into Property table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
('660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 'Cozy Downtown Loft', 'A modern loft in the heart of the city.', '123 Main St, Springfield', 100.00, '2025-02-01 09:00:00', '2025-02-01 09:00:00'),
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Beachfront Cottage', 'A charming cottage with ocean views.', '456 Beach Rd, Coastal Town', 150.00, '2025-02-02 11:00:00', '2025-02-02 11:00:00'),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', 'Mountain Cabin', 'A rustic cabin in the mountains.', '789 Hilltop Ln, Mountain Village', 120.00, '2025-02-03 13:00:00', '2025-02-03 13:00:00');

-- Insert sample data into Booking table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
('770e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', '2025-06-01', '2025-06-04', 300.00, 'confirmed', '2025-05-01 10:00:00'), -- 3 nights * $100
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '2025-07-10', '2025-07-15', 750.00, 'confirmed', '2025-06-01 12:00:00'), -- 5 nights * $150
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000', '2025-08-01', '2025-08-03', 240.00, 'pending', '2025-07-01 14:00:00'), -- 2 nights * $120
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '2025-09-01', '2025-09-05', 600.00, 'canceled', '2025-08-01 16:00:00'); -- 4 nights * $150

-- Insert sample data into Payment table
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('880e8400-e29b-41d4-a716-446655440000', '770e8400-e29b-41d4-a716-446655440000', 300.00, '2025-05-02 10:30:00', 'credit_card'), -- Full payment for booking 1
('880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 400.00, '2025-06-02 12:30:00', 'paypal'), -- Partial payment for booking 2
('880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', 350.00, '2025-06-03 12:45:00', 'stripe'); -- Remaining payment for booking 2

-- Insert sample data into Review table
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
('990e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', 5, 'Amazing stay! The loft was clean and centrally located.', '2025-06-05 09:00:00'),
('990e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 4, 'Beautiful cottage, but the Wi-Fi was spotty.', '2025-07-16 11:00:00');

-- Insert sample data into Message table
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
('aa0e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 'Is the loft available for June 1-4?', '2025-04-25 10:00:00'),
('aa0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Yes, it’s available! Would you like to book?', '2025-04-25 10:30:00'),
('aa0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440004', 'I need help with my booking cancellation.', '2025-08-02 14:00:00'),
('aa0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'Your cancellation has been processed.', '2025-08-02 14:30:00');
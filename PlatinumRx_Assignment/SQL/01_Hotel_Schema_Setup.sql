-- ============================================================
-- PlatinumRx Assignment | Phase 1 - Part A
-- File: 01_Hotel_Schema_Setup.sql
-- Description: Table creation + sample data for Hotel System
-- ============================================================
USE platinumrx_hotel;
-- Drop tables if they exist (for re-runs)
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

-- ─────────────────────────────────────────
-- TABLE: users
-- ─────────────────────────────────────────
CREATE TABLE users (
    user_id         VARCHAR(50)  PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    phone_number    VARCHAR(15),
    mail_id         VARCHAR(100),
    billing_address TEXT
);

-- ─────────────────────────────────────────
-- TABLE: bookings
-- ─────────────────────────────────────────
CREATE TABLE bookings (
    booking_id   VARCHAR(50)  PRIMARY KEY,
    booking_date DATETIME     NOT NULL,
    room_no      VARCHAR(50)  NOT NULL,
    user_id      VARCHAR(50)  NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ─────────────────────────────────────────
-- TABLE: items
-- ─────────────────────────────────────────
CREATE TABLE items (
    item_id   VARCHAR(50)    PRIMARY KEY,
    item_name VARCHAR(100)   NOT NULL,
    item_rate DECIMAL(10, 2) NOT NULL
);

-- ─────────────────────────────────────────
-- TABLE: booking_commercials
-- ─────────────────────────────────────────
CREATE TABLE booking_commercials (
    id            VARCHAR(50)    PRIMARY KEY,
    booking_id    VARCHAR(50)    NOT NULL,
    bill_id       VARCHAR(50)    NOT NULL,
    bill_date     DATETIME       NOT NULL,
    item_id       VARCHAR(50)    NOT NULL,
    item_quantity DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- ─────────────────────────────────────────
-- SEED DATA: users
-- ─────────────────────────────────────────
INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('usr-001', 'John Doe',    '9700000001', 'john.doe@example.com',    '12, MG Road, Hyderabad'),
('usr-002', 'Jane Smith',  '9700000002', 'jane.smith@example.com',  '45, Park Street, Mumbai'),
('usr-003', 'Ravi Kumar',  '9700000003', 'ravi.kumar@example.com',  '8, Anna Nagar, Chennai'),
('usr-004', 'Priya Nair',  '9700000004', 'priya.nair@example.com',  '3, Brigade Road, Bangalore'),
('usr-005', 'Arun Das',    '9700000005', 'arun.das@example.com',    '22, Salt Lake, Kolkata');

-- ─────────────────────────────────────────
-- SEED DATA: items
-- ─────────────────────────────────────────
INSERT INTO items (item_id, item_name, item_rate) VALUES
('itm-001', 'Tawa Paratha',    18.00),
('itm-002', 'Mix Veg',         89.00),
('itm-003', 'Paneer Butter Masala', 150.00),
('itm-004', 'Dal Fry',         75.00),
('itm-005', 'Gulab Jamun',     40.00),
('itm-006', 'Masala Chai',     25.00),
('itm-007', 'Veg Biryani',    120.00),
('itm-008', 'Lassi',           35.00);

-- ─────────────────────────────────────────
-- SEED DATA: bookings
-- ─────────────────────────────────────────
INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
-- September 2021
('bk-001', '2021-09-05 10:00:00', 'rm-101', 'usr-001'),
('bk-002', '2021-09-12 14:30:00', 'rm-102', 'usr-002'),
('bk-003', '2021-09-20 09:00:00', 'rm-103', 'usr-003'),
-- October 2021
('bk-004', '2021-10-03 11:00:00', 'rm-201', 'usr-001'),
('bk-005', '2021-10-15 16:00:00', 'rm-202', 'usr-004'),
('bk-006', '2021-10-28 08:30:00', 'rm-203', 'usr-005'),
-- November 2021
('bk-007', '2021-11-02 12:00:00', 'rm-301', 'usr-002'),
('bk-008', '2021-11-10 13:00:00', 'rm-302', 'usr-003'),
('bk-009', '2021-11-25 07:45:00', 'rm-303', 'usr-001'),
-- December 2021
('bk-010', '2021-12-01 10:00:00', 'rm-401', 'usr-004'),
('bk-011', '2021-12-20 15:30:00', 'rm-402', 'usr-005'),
-- January 2021 (early year)
('bk-012', '2021-01-10 09:00:00', 'rm-104', 'usr-002'),
('bk-013', '2021-02-14 11:30:00', 'rm-105', 'usr-003');

-- ─────────────────────────────────────────
-- SEED DATA: booking_commercials
-- ─────────────────────────────────────────
INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
-- bk-001 (Sep)
('bc-001', 'bk-001', 'bl-001', '2021-09-06 08:00:00', 'itm-001', 5),
('bc-002', 'bk-001', 'bl-001', '2021-09-06 08:00:00', 'itm-002', 2),
-- bk-002 (Sep)
('bc-003', 'bk-002', 'bl-002', '2021-09-13 09:00:00', 'itm-003', 3),
('bc-004', 'bk-002', 'bl-002', '2021-09-13 09:00:00', 'itm-006', 4),
-- bk-003 (Sep)
('bc-005', 'bk-003', 'bl-003', '2021-09-21 10:00:00', 'itm-004', 2),
('bc-006', 'bk-003', 'bl-003', '2021-09-21 10:00:00', 'itm-007', 3),
-- bk-004 (Oct)
('bc-007', 'bk-004', 'bl-004', '2021-10-05 12:00:00', 'itm-003', 5),
('bc-008', 'bk-004', 'bl-004', '2021-10-05 12:00:00', 'itm-005', 10),
-- bk-005 (Oct) – bill > 1000
('bc-009', 'bk-005', 'bl-005', '2021-10-16 11:00:00', 'itm-003', 5),
('bc-010', 'bk-005', 'bl-005', '2021-10-16 11:00:00', 'itm-007', 5),
('bc-011', 'bk-005', 'bl-005', '2021-10-16 11:00:00', 'itm-002', 3),
-- bk-006 (Oct)
('bc-012', 'bk-006', 'bl-006', '2021-10-29 08:00:00', 'itm-001', 6),
('bc-013', 'bk-006', 'bl-006', '2021-10-29 08:00:00', 'itm-008', 4),
-- bk-007 (Nov)
('bc-014', 'bk-007', 'bl-007', '2021-11-03 10:00:00', 'itm-003', 2),
('bc-015', 'bk-007', 'bl-007', '2021-11-03 10:00:00', 'itm-004', 3),
-- bk-008 (Nov)
('bc-016', 'bk-008', 'bl-008', '2021-11-11 11:00:00', 'itm-007', 4),
('bc-017', 'bk-008', 'bl-008', '2021-11-11 11:00:00', 'itm-006', 6),
-- bk-009 (Nov) – large bill
('bc-018', 'bk-009', 'bl-009', '2021-11-26 09:00:00', 'itm-003', 6),
('bc-019', 'bk-009', 'bl-009', '2021-11-26 09:00:00', 'itm-007', 5),
('bc-020', 'bk-009', 'bl-009', '2021-11-26 09:00:00', 'itm-002', 4),
-- bk-010 (Dec)
('bc-021', 'bk-010', 'bl-010', '2021-12-02 10:00:00', 'itm-001', 8),
('bc-022', 'bk-010', 'bl-010', '2021-12-02 10:00:00', 'itm-005', 5),
-- bk-011 (Dec) – large bill
('bc-023', 'bk-011', 'bl-011', '2021-12-21 14:00:00', 'itm-003', 7),
('bc-024', 'bk-011', 'bl-011', '2021-12-21 14:00:00', 'itm-007', 6),
('bc-025', 'bk-011', 'bl-011', '2021-12-21 14:00:00', 'itm-002', 5),
-- bk-012 (Jan)
('bc-026', 'bk-012', 'bl-012', '2021-01-11 08:00:00', 'itm-006', 3),
('bc-027', 'bk-012', 'bl-012', '2021-01-11 08:00:00', 'itm-004', 2),
-- bk-013 (Feb)
('bc-028', 'bk-013', 'bl-013', '2021-02-15 09:00:00', 'itm-008', 4),
('bc-029', 'bk-013', 'bl-013', '2021-02-15 09:00:00', 'itm-001', 5);

-- Active: 1775717269200@@127.0.0.1@3306@platinumrx_hotel
-- ============================================================
-- PlatinumRx Assignment | Phase 1 - Part B
-- File: 03_Clinic_Schema_Setup.sql
-- Description: Table creation + sample data for Clinic System
-- ============================================================
USE platinumrx_hotel;

DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinics;
DROP TABLE IF EXISTS customer;

-- ─────────────────────────────────────────
-- TABLE: clinics
-- ─────────────────────────────────────────
CREATE TABLE clinics (
    cid         VARCHAR(50)  PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    city        VARCHAR(100) NOT NULL,
    state       VARCHAR(100) NOT NULL,
    country     VARCHAR(100) NOT NULL DEFAULT 'India'
);

-- ─────────────────────────────────────────
-- TABLE: customer
-- ─────────────────────────────────────────
CREATE TABLE customer (
    uid    VARCHAR(50)  PRIMARY KEY,
    name   VARCHAR(100) NOT NULL,
    mobile VARCHAR(15)
);

-- ─────────────────────────────────────────
-- TABLE: clinic_sales
-- ─────────────────────────────────────────
CREATE TABLE clinic_sales (
    oid          VARCHAR(50)    PRIMARY KEY,
    uid          VARCHAR(50)    NOT NULL,
    cid          VARCHAR(50)    NOT NULL,
    amount       DECIMAL(12, 2) NOT NULL,
    datetime     DATETIME       NOT NULL,
    sales_channel VARCHAR(50)   NOT NULL,
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ─────────────────────────────────────────
-- TABLE: expenses
-- ─────────────────────────────────────────
CREATE TABLE expenses (
    eid         VARCHAR(50)    PRIMARY KEY,
    cid         VARCHAR(50)    NOT NULL,
    description VARCHAR(200),
    amount      DECIMAL(12, 2) NOT NULL,
    datetime    DATETIME       NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ─────────────────────────────────────────
-- SEED DATA: clinics
-- ─────────────────────────────────────────
INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-001', 'HealthFirst Clinic',   'Hyderabad',  'Telangana',       'India'),
('cnc-002', 'CurePoint Centre',     'Hyderabad',  'Telangana',       'India'),
('cnc-003', 'MediCare Clinic',      'Mumbai',     'Maharashtra',     'India'),
('cnc-004', 'WellBeing Hub',        'Mumbai',     'Maharashtra',     'India'),
('cnc-005', 'ApolloCare',           'Chennai',    'Tamil Nadu',      'India'),
('cnc-006', 'CityCure',             'Bangalore',  'Karnataka',       'India'),
('cnc-007', 'LifeLine Clinic',      'Bangalore',  'Karnataka',       'India'),
('cnc-008', 'FitHealth',            'Delhi',      'Delhi',           'India');

-- ─────────────────────────────────────────
-- SEED DATA: customer
-- ─────────────────────────────────────────
INSERT INTO customer (uid, name, mobile) VALUES
('cus-001', 'Ananya Sharma',  '9811000001'),
('cus-002', 'Rohit Verma',    '9811000002'),
('cus-003', 'Sunita Rao',     '9811000003'),
('cus-004', 'Kiran Patel',    '9811000004'),
('cus-005', 'Meena Iyer',     '9811000005'),
('cus-006', 'Suresh Nair',    '9811000006'),
('cus-007', 'Deepa Gupta',    '9811000007'),
('cus-008', 'Anil Joshi',     '9811000008'),
('cus-009', 'Pooja Singh',    '9811000009'),
('cus-010', 'Vikram Reddy',   '9811000010');

-- ─────────────────────────────────────────
-- SEED DATA: clinic_sales
-- ─────────────────────────────────────────
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
-- Jan 2021
('ord-001', 'cus-001', 'cnc-001', 2500.00, '2021-01-05 10:00:00', 'online'),
('ord-002', 'cus-002', 'cnc-001', 3800.00, '2021-01-12 11:00:00', 'walk-in'),
('ord-003', 'cus-003', 'cnc-002', 1500.00, '2021-01-15 09:30:00', 'online'),
('ord-004', 'cus-004', 'cnc-003', 4200.00, '2021-01-20 14:00:00', 'referral'),
('ord-005', 'cus-005', 'cnc-005', 2800.00, '2021-01-25 16:00:00', 'walk-in'),
-- Feb 2021
('ord-006', 'cus-001', 'cnc-001', 5000.00, '2021-02-03 10:30:00', 'online'),
('ord-007', 'cus-006', 'cnc-002', 3200.00, '2021-02-10 13:00:00', 'referral'),
('ord-008', 'cus-007', 'cnc-004', 2100.00, '2021-02-18 11:00:00', 'walk-in'),
('ord-009', 'cus-002', 'cnc-001', 4500.00, '2021-02-22 15:00:00', 'online'),
-- Mar 2021
('ord-010', 'cus-008', 'cnc-006', 3700.00, '2021-03-05 09:00:00', 'online'),
('ord-011', 'cus-003', 'cnc-001', 2900.00, '2021-03-12 10:00:00', 'walk-in'),
('ord-012', 'cus-009', 'cnc-007', 5500.00, '2021-03-20 14:30:00', 'referral'),
-- Apr-Jun (high revenue months)
('ord-013', 'cus-010', 'cnc-001', 6000.00, '2021-04-08 10:00:00', 'online'),
('ord-014', 'cus-001', 'cnc-003', 4800.00, '2021-04-15 11:30:00', 'walk-in'),
('ord-015', 'cus-002', 'cnc-005', 3500.00, '2021-05-05 09:00:00', 'referral'),
('ord-016', 'cus-004', 'cnc-006', 7200.00, '2021-05-18 12:00:00', 'online'),
('ord-017', 'cus-005', 'cnc-001', 5800.00, '2021-06-03 10:30:00', 'walk-in'),
('ord-018', 'cus-006', 'cnc-002', 4100.00, '2021-06-20 15:00:00', 'online'),
-- Jul-Sep
('ord-019', 'cus-007', 'cnc-007', 3300.00, '2021-07-10 11:00:00', 'referral'),
('ord-020', 'cus-008', 'cnc-008', 2700.00, '2021-07-22 14:00:00', 'walk-in'),
('ord-021', 'cus-009', 'cnc-001', 4900.00, '2021-08-05 09:30:00', 'online'),
('ord-022', 'cus-010', 'cnc-004', 6200.00, '2021-08-18 13:00:00', 'referral'),
('ord-023', 'cus-001', 'cnc-006', 3800.00, '2021-09-08 10:00:00', 'online'),
('ord-024', 'cus-003', 'cnc-001', 5100.00, '2021-09-25 12:30:00', 'walk-in'),
-- Oct-Dec
('ord-025', 'cus-002', 'cnc-003', 4300.00, '2021-10-07 11:00:00', 'online'),
('ord-026', 'cus-004', 'cnc-005', 3600.00, '2021-10-19 14:00:00', 'referral'),
('ord-027', 'cus-005', 'cnc-001', 5500.00, '2021-11-05 09:00:00', 'walk-in'),
('ord-028', 'cus-006', 'cnc-007', 4700.00, '2021-11-20 13:30:00', 'online'),
('ord-029', 'cus-007', 'cnc-002', 6800.00, '2021-12-10 10:00:00', 'referral'),
('ord-030', 'cus-008', 'cnc-001', 7500.00, '2021-12-28 15:00:00', 'online');

-- ─────────────────────────────────────────
-- SEED DATA: expenses
-- ─────────────────────────────────────────
INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
-- Jan 2021
('exp-001', 'cnc-001', 'Medical Supplies',     1200.00, '2021-01-10 08:00:00'),
('exp-002', 'cnc-002', 'Rent',                  800.00, '2021-01-01 08:00:00'),
('exp-003', 'cnc-003', 'Staff Salary',          2000.00, '2021-01-31 08:00:00'),
('exp-004', 'cnc-005', 'Utilities',              500.00, '2021-01-15 08:00:00'),
-- Feb 2021
('exp-005', 'cnc-001', 'Staff Salary',          2200.00, '2021-02-28 08:00:00'),
('exp-006', 'cnc-002', 'Medical Supplies',       700.00, '2021-02-10 08:00:00'),
('exp-007', 'cnc-004', 'Rent',                   900.00, '2021-02-01 08:00:00'),
-- Mar 2021
('exp-008', 'cnc-006', 'Equipment',             1500.00, '2021-03-05 08:00:00'),
('exp-009', 'cnc-001', 'Utilities',              600.00, '2021-03-15 08:00:00'),
('exp-010', 'cnc-007', 'Staff Salary',           1800.00, '2021-03-31 08:00:00'),
-- Apr-Jun
('exp-011', 'cnc-001', 'Staff Salary',          2300.00, '2021-04-30 08:00:00'),
('exp-012', 'cnc-003', 'Medical Supplies',       1100.00, '2021-04-15 08:00:00'),
('exp-013', 'cnc-005', 'Rent',                   1000.00, '2021-05-01 08:00:00'),
('exp-014', 'cnc-006', 'Staff Salary',           2000.00, '2021-05-31 08:00:00'),
('exp-015', 'cnc-001', 'Equipment Maintenance',   900.00, '2021-06-10 08:00:00'),
('exp-016', 'cnc-002', 'Utilities',               650.00, '2021-06-15 08:00:00'),
-- Jul-Sep
('exp-017', 'cnc-007', 'Rent',                    850.00, '2021-07-01 08:00:00'),
('exp-018', 'cnc-008', 'Medical Supplies',         700.00, '2021-07-20 08:00:00'),
('exp-019', 'cnc-001', 'Staff Salary',            2400.00, '2021-08-31 08:00:00'),
('exp-020', 'cnc-004', 'Utilities',                550.00, '2021-08-15 08:00:00'),
('exp-021', 'cnc-006', 'Rent',                     950.00, '2021-09-01 08:00:00'),
('exp-022', 'cnc-001', 'Medical Supplies',        1300.00, '2021-09-20 08:00:00'),
-- Oct-Dec
('exp-023', 'cnc-003', 'Staff Salary',            2100.00, '2021-10-31 08:00:00'),
('exp-024', 'cnc-005', 'Medical Supplies',         900.00, '2021-10-10 08:00:00'),
('exp-025', 'cnc-001', 'Staff Salary',            2500.00, '2021-11-30 08:00:00'),
('exp-026', 'cnc-007', 'Utilities',                600.00, '2021-11-15 08:00:00'),
('exp-027', 'cnc-002', 'Equipment',              1400.00, '2021-12-05 08:00:00'),
('exp-028', 'cnc-001', 'Year-end Supplies',       1600.00, '2021-12-28 08:00:00');

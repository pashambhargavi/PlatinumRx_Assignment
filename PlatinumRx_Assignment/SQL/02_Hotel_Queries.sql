-- ============================================================
-- PlatinumRx Assignment | Phase 1 - Part A
-- File: 02_Hotel_Queries.sql
-- Description: Analytical queries for Hotel Management System
-- ============================================================

-- ─────────────────────────────────────────────────────────────────────
-- Q1. For every user in the system, get the user_id and last booked room_no
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Join users → bookings
--   • Use MAX(booking_date) to find the latest booking per user
--   • Then join back to bookings to retrieve the room_no for that latest booking
--   • DISTINCT ON (PostgreSQL) or subquery pattern (MySQL/SQLite) is used

-- ── MySQL / SQLite compatible ──
USE platinumrx_hotel;
SELECT
    u.user_id,
    u.name,
    b.room_no                           AS last_booked_room_no,
    b.booking_date                      AS last_booking_date
FROM users u
JOIN bookings b
    ON b.booking_id = (
        SELECT booking_id
        FROM   bookings
        WHERE  user_id = u.user_id
        ORDER  BY booking_date DESC
        LIMIT  1
    );

-- ── Alternative: PostgreSQL DISTINCT ON ──
/*
SELECT DISTINCT ON (u.user_id)
    u.user_id,
    u.name,
    b.room_no        AS last_booked_room_no,
    b.booking_date   AS last_booking_date
FROM users u
JOIN bookings b USING (user_id)
ORDER BY u.user_id, b.booking_date DESC;
*/


-- ─────────────────────────────────────────────────────────────────────
-- Q2. Get booking_id and total billing amount of every booking created
--     in November, 2021
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Filter bookings WHERE booking_date is in November 2021
--   • JOIN booking_commercials to get item_quantity
--   • JOIN items to get item_rate
--   • Compute bill_amount = SUM(item_quantity * item_rate) per booking_id

SELECT
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate)  AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON bc.booking_id = b.booking_id
JOIN items               i  ON i.item_id     = bc.item_id
WHERE  YEAR(b.booking_date)  = 2021
  AND  MONTH(b.booking_date) = 11          -- November
GROUP BY b.booking_id
ORDER BY total_billing_amount DESC;

-- ── SQLite alternative (no YEAR/MONTH functions) ──
/*
WHERE strftime('%Y-%m', b.booking_date) = '2021-11'
*/


-- ─────────────────────────────────────────────────────────────────────
-- Q3. Get bill_id and bill amount of all bills raised in October, 2021
--     having bill amount > 1000
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Filter booking_commercials WHERE bill_date is in October 2021
--   • Compute SUM(item_quantity * item_rate) per bill_id
--   • HAVING clause filters only those sums > 1000

SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate)  AS bill_amount
FROM booking_commercials bc
JOIN items i ON i.item_id = bc.item_id
WHERE  YEAR(bc.bill_date)  = 2021
  AND  MONTH(bc.bill_date) = 10          -- October
GROUP BY bc.bill_id
HAVING bill_amount > 1000
ORDER BY bill_amount DESC;


-- ─────────────────────────────────────────────────────────────────────
-- Q4. Determine the most ordered and least ordered item of each month
--     of year 2021
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Compute total quantity ordered per (month, item) in 2021
--   • Use RANK() window function partitioned by month:
--       - rank_asc  = 1  → least ordered (smallest quantity)
--       - rank_desc = 1  → most ordered  (largest quantity)
--   • Filter WHERE either rank = 1

WITH monthly_item_qty AS (
    SELECT
        MONTH(bc.bill_date)              AS bill_month,
        i.item_name,
        SUM(bc.item_quantity)            AS total_qty
    FROM booking_commercials bc
    JOIN items i ON i.item_id = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
),
ranked AS (
    SELECT
        bill_month,
        item_name,
        total_qty,
        RANK() OVER (PARTITION BY bill_month ORDER BY total_qty DESC) AS rank_most,
        RANK() OVER (PARTITION BY bill_month ORDER BY total_qty ASC)  AS rank_least
    FROM monthly_item_qty
)
SELECT
    bill_month,
    MAX(CASE WHEN rank_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_most  = 1 THEN total_qty END)  AS most_ordered_qty,
    MAX(CASE WHEN rank_least = 1 THEN item_name END) AS least_ordered_item,
    MAX(CASE WHEN rank_least = 1 THEN total_qty END)  AS least_ordered_qty
FROM ranked
WHERE rank_most = 1 OR rank_least = 1
GROUP BY bill_month
ORDER BY bill_month;


-- ─────────────────────────────────────────────────────────────────────
-- Q5. Find the customers with the second highest bill value of each
--     month of year 2021
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Compute total bill per (month, user/customer) in 2021
--   • Use DENSE_RANK() so ties don't skip ranks
--   • Filter WHERE rank = 2 to get second-highest payers per month

WITH customer_monthly_bill AS (
    SELECT
        MONTH(bc.bill_date)              AS bill_month,
        b.user_id,
        u.name                           AS customer_name,
        SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN bookings b ON b.booking_id = bc.booking_id
    JOIN users    u ON u.user_id    = b.user_id
    JOIN items    i ON i.item_id    = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id, u.name
),
ranked AS (
    SELECT
        bill_month,
        user_id,
        customer_name,
        total_bill,
        DENSE_RANK() OVER (
            PARTITION BY bill_month
            ORDER BY total_bill DESC
        ) AS bill_rank
    FROM customer_monthly_bill
)
SELECT
    bill_month,
    user_id,
    customer_name,
    total_bill   AS second_highest_bill
FROM ranked
WHERE bill_rank = 2
ORDER BY bill_month;

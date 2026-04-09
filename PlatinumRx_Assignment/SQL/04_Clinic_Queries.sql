-- ============================================================
-- PlatinumRx Assignment | Phase 1 - Part B
-- File: 04_Clinic_Queries.sql
-- Description: Analytical queries for Clinic Management System
-- Note: Replace @TARGET_YEAR / @TARGET_MONTH with actual values
--       e.g., SET @TARGET_YEAR = 2021; SET @TARGET_MONTH = 11;
-- ============================================================
USE platinumrx_hotel;

SET @TARGET_YEAR  = 2021;
SET @TARGET_MONTH = 11;    -- used for Q4 and Q5


-- ─────────────────────────────────────────────────────────────────────
-- Q1. Find the revenue we got from each sales channel in a given year
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Filter clinic_sales WHERE YEAR(datetime) = target year
--   • GROUP BY sales_channel
--   • SUM(amount) = total revenue per channel

SELECT
    sales_channel,
    COUNT(oid)          AS total_orders,
    SUM(amount)         AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = @TARGET_YEAR
GROUP BY sales_channel
ORDER BY total_revenue DESC;


-- ─────────────────────────────────────────────────────────────────────
-- Q2. Find top 10 most valuable customers for a given year
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Filter clinic_sales by year
--   • JOIN customer to get names
--   • GROUP BY uid → SUM(amount) = customer lifetime value for that year
--   • ORDER DESC, LIMIT 10

SELECT
    cs.uid,
    c.name,
    c.mobile,
    COUNT(cs.oid)          AS total_orders,
    SUM(cs.amount)         AS total_revenue_generated
FROM clinic_sales cs
JOIN customer c ON c.uid = cs.uid
WHERE YEAR(cs.datetime) = @TARGET_YEAR
GROUP BY cs.uid, c.name, c.mobile
ORDER BY total_revenue_generated DESC
LIMIT 10;


-- ─────────────────────────────────────────────────────────────────────
-- Q3. Month-wise revenue, expense, profit, status for a given year
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Aggregate revenue by month from clinic_sales
--   • Aggregate expenses by month from expenses table
--   • LEFT JOIN on month (so months with no expenses still show)
--   • Profit = Revenue - Expense
--   • Status = 'Profitable' if Profit >= 0 else 'Not-Profitable'

WITH monthly_revenue AS (
    SELECT
        MONTH(datetime)    AS bill_month,
        SUM(amount)        AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = @TARGET_YEAR
    GROUP BY MONTH(datetime)
),
monthly_expense AS (
    SELECT
        MONTH(datetime)    AS bill_month,
        SUM(amount)        AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = @TARGET_YEAR
    GROUP BY MONTH(datetime)
)
SELECT
    r.bill_month,
    r.total_revenue,
    COALESCE(e.total_expense, 0)                         AS total_expense,
    (r.total_revenue - COALESCE(e.total_expense, 0))     AS profit,
    CASE
        WHEN (r.total_revenue - COALESCE(e.total_expense, 0)) >= 0
        THEN 'Profitable'
        ELSE 'Not-Profitable'
    END                                                  AS status
FROM monthly_revenue r
LEFT JOIN monthly_expense e ON e.bill_month = r.bill_month
ORDER BY r.bill_month;


-- ─────────────────────────────────────────────────────────────────────
-- Q4. For each city, find the most profitable clinic for a given month
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Calculate profit per clinic for the target month
--   •   Profit = SUM(sales.amount) - SUM(expenses.amount)
--   • Partition by city, rank by profit DESC
--   • Return rank = 1 per city

WITH clinic_revenue AS (
    SELECT
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = @TARGET_YEAR
      AND MONTH(datetime) = @TARGET_MONTH
    GROUP BY cid
),
clinic_expense AS (
    SELECT
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = @TARGET_YEAR
      AND MONTH(datetime) = @TARGET_MONTH
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        cl.state,
        COALESCE(r.revenue, 0)                              AS revenue,
        COALESCE(e.expense, 0)                              AS expense,
        (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0))  AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue r ON r.cid = cl.cid
    LEFT JOIN clinic_expense e ON e.cid = cl.cid
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS profit_rank
    FROM clinic_profit
)
SELECT
    city,
    cid,
    clinic_name,
    revenue,
    expense,
    profit      AS highest_profit
FROM ranked
WHERE profit_rank = 1
ORDER BY city;


-- ─────────────────────────────────────────────────────────────────────
-- Q5. For each state, find the second least profitable clinic
--     for a given month
-- ─────────────────────────────────────────────────────────────────────
-- Logic:
--   • Same profit calculation as Q4
--   • Rank by profit ASC (ascending = least profitable first)
--   • Return rank = 2 per state

WITH clinic_revenue AS (
    SELECT
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = @TARGET_YEAR
      AND MONTH(datetime) = @TARGET_MONTH
    GROUP BY cid
),
clinic_expense AS (
    SELECT
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = @TARGET_YEAR
      AND MONTH(datetime) = @TARGET_MONTH
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        cl.state,
        COALESCE(r.revenue, 0)                              AS revenue,
        COALESCE(e.expense, 0)                              AS expense,
        (COALESCE(r.revenue, 0) - COALESCE(e.expense, 0))  AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue r ON r.cid = cl.cid
    LEFT JOIN clinic_expense e ON e.cid = cl.cid
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS profit_rank
    FROM clinic_profit
)
SELECT
    state,
    cid,
    clinic_name,
    city,
    revenue,
    expense,
    profit      AS second_least_profit
FROM ranked
WHERE profit_rank = 2
ORDER BY state;

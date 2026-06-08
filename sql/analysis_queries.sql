-- =====================================================
-- 05_analysis_queries.sql
-- Project: Banking Customer Transaction Analytics
-- Description: Main analysis queries
-- =====================================================

USE banking_analytics;

-- Global KPIs
SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(transaction_amount_inr), 2) AS total_amount_inr,
    ROUND(AVG(transaction_amount_inr), 2) AS avg_transaction_amount_inr,
    ROUND(AVG(customer_account_balance), 2) AS avg_account_balance_inr
FROM bank_transactions_powerbi;

-- Transactions by month
SELECT
    transaction_year,
    transaction_month,
    transaction_month_name,
    COUNT(*) AS nb_transactions,
    ROUND(SUM(transaction_amount_inr), 2) AS total_amount_inr,
    ROUND(AVG(transaction_amount_inr), 2) AS avg_amount_inr
FROM bank_transactions_powerbi
GROUP BY transaction_year, transaction_month, transaction_month_name
ORDER BY transaction_year, transaction_month;

-- Top 10 cities by transaction volume
SELECT
    customer_location,
    COUNT(*) AS nb_transactions,
    COUNT(DISTINCT customer_id) AS nb_customers,
    ROUND(SUM(transaction_amount_inr), 2) AS total_amount_inr
FROM bank_transactions_powerbi
WHERE customer_location IS NOT NULL
  AND customer_location <> ''
GROUP BY customer_location
ORDER BY total_amount_inr DESC
LIMIT 10;

-- Customer segments summary
SELECT
    customer_segment,
    COUNT(*) AS nb_customers,
    ROUND(SUM(total_amount_inr), 2) AS total_amount_inr,
    ROUND(AVG(avg_amount_inr), 2) AS avg_transaction_amount,
    ROUND(AVG(avg_account_balance), 2) AS avg_account_balance
FROM customer_segments
GROUP BY customer_segment
ORDER BY total_amount_inr DESC;

-- Unusual transactions summary
SELECT
    is_unusual_transaction,
    COUNT(*) AS nb_transactions,
    ROUND(SUM(transaction_amount_inr), 2) AS total_amount_inr,
    ROUND(AVG(transaction_amount_inr), 2) AS avg_amount_inr
FROM bank_transactions_powerbi
GROUP BY is_unusual_transaction;

-- Top cities by unusual transactions
SELECT
    customer_location,
    COUNT(*) AS nb_unusual_transactions,
    ROUND(SUM(transaction_amount_inr), 2) AS unusual_amount_inr
FROM bank_transactions_powerbi
WHERE is_unusual_transaction = 1
  AND customer_location IS NOT NULL
  AND customer_location <> ''
GROUP BY customer_location
ORDER BY nb_unusual_transactions DESC
LIMIT 10;

-- Highest unusual transactions
SELECT
    transaction_id,
    customer_id,
    customer_location,
    transaction_date,
    transaction_amount_inr,
    ROUND(avg_transaction_amount_client, 2) AS avg_customer_transaction,
    ROUND(transaction_amount_inr / avg_transaction_amount_client, 2) AS ratio_vs_customer_avg
FROM bank_transactions_powerbi
WHERE is_unusual_transaction = 1
ORDER BY transaction_amount_inr DESC
LIMIT 20;
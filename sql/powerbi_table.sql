-- =====================================================
-- 03_powerbi_table.sql
-- Project: Banking Customer Transaction Analytics
-- Description: Create customer statistics and Power BI table
-- =====================================================

USE banking_analytics;

-- Customer-level transaction statistics
DROP TABLE IF EXISTS customer_transaction_stats;

CREATE TABLE customer_transaction_stats AS
SELECT
    customer_id,
    COUNT(*) AS nb_transactions_client,
    AVG(transaction_amount_inr) AS avg_transaction_amount_client,
    SUM(transaction_amount_inr) AS total_transaction_amount_client,
    MAX(transaction_amount_inr) AS max_transaction_amount_client
FROM bank_transactions_clean
WHERE customer_id IS NOT NULL
  AND transaction_amount_inr IS NOT NULL
GROUP BY customer_id;

-- Convert customer_id from TEXT to VARCHAR for indexing
ALTER TABLE customer_transaction_stats
MODIFY customer_id VARCHAR(50);

-- Create index to improve join performance
CREATE INDEX idx_customer_stats_id
ON customer_transaction_stats(customer_id);

-- Final table used in Power BI
DROP TABLE IF EXISTS bank_transactions_powerbi;

CREATE TABLE bank_transactions_powerbi AS
SELECT
    t.transaction_id,
    t.customer_id,
    t.customer_dob,
    t.customer_gender,
    t.customer_location,
    t.customer_account_balance,
    t.transaction_date,
    t.transaction_year,
    t.transaction_month,
    t.transaction_month_name,
    t.transaction_time,
    t.transaction_amount_inr,

    s.nb_transactions_client,
    s.avg_transaction_amount_client,
    s.total_transaction_amount_client,
    s.max_transaction_amount_client,

    CASE
        WHEN t.transaction_amount_inr > 3 * s.avg_transaction_amount_client
        THEN 1
        ELSE 0
    END AS is_unusual_transaction,

    CASE
        WHEN t.transaction_amount_inr > 50000
        THEN 1
        ELSE 0
    END AS is_high_value_transaction

FROM bank_transactions_clean t
JOIN customer_transaction_stats s
    ON t.customer_id = s.customer_id;
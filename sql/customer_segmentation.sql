-- =====================================================
-- 04_customer_segmentation.sql
-- Project: Banking Customer Transaction Analytics
-- Description: Create customer segmentation table
-- =====================================================

USE banking_analytics;

DROP TABLE IF EXISTS customer_segments;

CREATE TABLE customer_segments AS
SELECT
    customer_id,
    MAX(customer_gender) AS customer_gender,
    MAX(customer_location) AS customer_location,
    COUNT(*) AS nb_transactions,
    ROUND(SUM(transaction_amount_inr), 2) AS total_amount_inr,
    ROUND(AVG(transaction_amount_inr), 2) AS avg_amount_inr,
    ROUND(AVG(customer_account_balance), 2) AS avg_account_balance,

    CASE
        WHEN COUNT(*) >= 5 AND SUM(transaction_amount_inr) >= 100000 THEN 'Very Active High Value'
        WHEN SUM(transaction_amount_inr) >= 100000 THEN 'High Value'
        WHEN COUNT(*) >= 5 THEN 'Very Active'
        WHEN COUNT(*) BETWEEN 2 AND 4 THEN 'Active'
        ELSE 'Low Activity'
    END AS customer_segment

FROM bank_transactions_clean
WHERE customer_id IS NOT NULL
GROUP BY customer_id;
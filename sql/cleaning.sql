-- =====================================================
-- 02_cleaning.sql
-- Project: Banking Customer Transaction Analytics
-- Description: Clean raw transaction data
-- =====================================================

USE banking_analytics;

DROP TABLE IF EXISTS bank_transactions_clean;

CREATE TABLE bank_transactions_clean AS
SELECT
    TransactionID AS transaction_id,
    CustomerID AS customer_id,

    CASE
        WHEN CustomerDOB IS NULL 
             OR TRIM(CustomerDOB) = ''
             OR LOWER(TRIM(CustomerDOB)) = 'nan'
             OR TRIM(CustomerDOB) = '1/1/1800'
        THEN NULL
        ELSE STR_TO_DATE(CustomerDOB, '%d/%m/%y')
    END AS customer_dob,

    CustGender AS customer_gender,
    CustLocation AS customer_location,
    CustAccountBalance AS customer_account_balance,

    CASE
        WHEN TransactionDate IS NULL
             OR TRIM(TransactionDate) = ''
             OR LOWER(TRIM(TransactionDate)) = 'nan'
        THEN NULL
        ELSE STR_TO_DATE(TransactionDate, '%d/%m/%y')
    END AS transaction_date,

    TransactionTime AS transaction_time,
    `TransactionAmount (INR)` AS transaction_amount_inr

FROM bank_transactions;

-- Add date columns for Power BI
ALTER TABLE bank_transactions_clean
ADD COLUMN transaction_year INT,
ADD COLUMN transaction_month INT,
ADD COLUMN transaction_month_name VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE bank_transactions_clean
SET
    transaction_year = YEAR(transaction_date),
    transaction_month = MONTH(transaction_date),
    transaction_month_name = MONTHNAME(transaction_date);

SET SQL_SAFE_UPDATES = 1;

-- Convert customer_id from TEXT to VARCHAR for indexing
ALTER TABLE bank_transactions_clean
MODIFY customer_id VARCHAR(50);

-- Create index to improve joins and aggregations
CREATE INDEX idx_transactions_clean_customer
ON bank_transactions_clean(customer_id);
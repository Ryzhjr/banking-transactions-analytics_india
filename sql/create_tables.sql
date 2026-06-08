-- =====================================================
-- 01_create_database_and_raw_table.sql
-- Project: Banking Customer Transaction Analytics
-- Description: Create database and raw import table
-- =====================================================

DROP DATABASE IF EXISTS banking_analytics;
CREATE DATABASE banking_analytics;
USE banking_analytics;

-- Raw table used to import the CSV file
CREATE TABLE bank_transactions_raw (
    TransactionID VARCHAR(50),
    CustomerID VARCHAR(50),
    CustomerDOB VARCHAR(20),
    CustGender VARCHAR(10),
    CustLocation VARCHAR(100),
    CustAccountBalance DECIMAL(18,2),
    TransactionDate VARCHAR(20),
    TransactionTime INT,
    TransactionAmount_INR DECIMAL(18,2)
);

-- Note:
-- In the original CSV file, the last column may be named:
-- TransactionAmount (INR)
-- If needed, rename it to TransactionAmount_INR before import.
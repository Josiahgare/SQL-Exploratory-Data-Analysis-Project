-- ==============================
-- Database Exploration
-- ==============================

-- Explore All Objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO

-- Explore All Columns in the Database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
GO

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';
GO

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';
GO

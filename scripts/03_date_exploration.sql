-- =====================================================
-- Date Exploration
-- =====================================================
-- Identify the earliest and lastest dates (boundaries)
-- Understand the scope of data and the timespan.
-- Formula: MIN/MAX[Date Dimension]
-- =====================================================

-- -----------------------------------------------------------------------------------------------
-- Find the date of the first and last order
-- How many years of sales are available
-- -----------------------------------------------------------------------------------------------

SELECT
	MIN(order_date) first_order_date,
	MAX(order_date) last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- -----------------------------------------------------------------------------------------------
-- Find the youngest and the oldest customer
-- -----------------------------------------------------------------------------------------------

SELECT
	MIN(birthdate) oldest_customer,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) oldest_age,
	MAX(birthdate) youngest_customer,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) oldest_age
FROM gold.dim_customers;

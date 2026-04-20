/*
=====================================================
Changes Over Time Analysis
=====================================================
Technique to analyze how a measure evolves over time
It helps track trends and identify seasonality in the data
Formula: Agg[Measure] By [Date Dimension]
=====================================================
*/

-- -----------------------------------------------------------------
-- Analyzing sales performance over time
-- -----------------------------------------------------------------

SELECT 
	YEAR(order_date) AS order_year,
	SUM(sales_amount) AS total_sales,
	AVG(sales_amount) AS avg_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);
GO

-- Using DATETRUNC()
SELECT 
	DATETRUNC(month, order_date) AS order_year,	-- year & month
	SUM(sales_amount) AS total_sales,
	AVG(sales_amount) AS avg_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);
GO

-- -----------------------------------------------------------------
-- How many new customers were added each year
-- -----------------------------------------------------------------

SELECT 
	DATETRUNC(year, order_date) AS order_year,
	COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE DATETRUNC(year, order_date) IS NOT NULL
GROUP BY DATETRUNC(year, order_date)
ORDER BY DATETRUNC(year, order_date);
GO

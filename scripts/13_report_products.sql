/*
==================================================================================================
Building Product Report
==================================================================================================
Purpose:
	- This report consolidates key Product metrics and behaviors and stores it as a VIEW table
	  in the previous database 'DataWarehouse' and current database 'DataWarehouseAnalytics'

Highlights:
	1.	Gathers essential fields such as Product names, category, subcategory, and cost.
	2.	Segments Products by revenue to identify High-performers, Mid-Range, or Low-performers
	3.	Aggregates Product level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4.	Calculates valuable KPIs:
		- recency (month since last sale)
		- average order revenue
		- average monthly revenue
==================================================================================================
*/

CREATE OR ALTER VIEW gold.report_products AS 
  
WITH base_query AS (  --1st CTE
-- -----------------------------------------------------------------------------------------------
-- 1) Base Query: Retrieves core columns from tables, including transformations but no aggregrations
-- -----------------------------------------------------------------------------------------------

SELECT 
	f.order_number,
	f.customer_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost,
	f.sales_amount - p.cost AS revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
)

, product_aggregration AS (   --2nd CTE
-- -----------------------------------------------------------------------------------------------
-- 2) Product Aggregation: Summarizes key metrics at the customer level
-- -----------------------------------------------------------------------------------------------

SELECT 
	product_key,
	product_name,
	COUNT(DISTINCT order_number) AS total_orders,
	MAX(order_date) AS last_sales_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS totaL_quantity,
	COUNT(DISTINCT customer_key) AS total_customers,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 2) AS avg_selling_price,
	category,
	subcategory,
	cost
FROM base_query
GROUP BY
	product_key,
	product_name,
	category,
	subcategory,
	cost
)

-- -----------------------------------------------------------------------------------------------
-- 3) Final Query: Combines all product results into one output
-- -----------------------------------------------------------------------------------------------
SELECT 
	product_key, 
	product_name,
	total_orders,
	last_sales_date,
	DATEDIFF(month, last_sales_date, GETDATE()) AS recency_in_months,
	lifespan,
	total_sales,
	totaL_quantity,
	total_customers,
	avg_selling_price,
	category,
	subcategory,
	cost,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
  
	-- compute average order revenue
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders
	END AS avg_order_revenue,
  
	-- compute average monthly revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales/lifespan
	END AS avg_monthly_revenue
FROM product_aggregration;
GO

SELECT * FROM gold.report_products;
GO

	

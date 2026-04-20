/*
================================================================
Data Segmentation Analysis
================================================================
Group the data based on a specific range
Helps understand the correlation betwen two measures
Formala: [Measure] By [Measure] using CASE WHEN statement
================================================================
*/

-- -----------------------------------------------------------------
-- Segment products into cost ranges and count how many products fall into each segment
-- -----------------------------------------------------------------

-- Using Subquery

SELECT
	cost_range,
	COUNT(product_name) AS count_product
FROM 
  (
	SELECT 
		product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 THEN 'Below 100'
			 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			 ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
)K
GROUP BY cost_range;

-- -----------------------------------------------------------------
-- Using CTE
-- -----------------------------------------------------------------

WITH product_segments AS 
(
	SELECT 
		product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 THEN 'Below 100'
			 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			 ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
)

SELECT
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;
GO

/* 
Group customers into three segments based on their spending behavior:
	- VIP: customers with at least 12 months of history and spending more than $5,000
	- Regular: customers with at least 12 months of history but spending $5,000 or less
	- New: customers with a lifespan less than 12 months
And find the total number of customers by each group
*/

WITH customer_spend_category AS 
(
SELECT 
	c.customer_key AS customer_key,
	SUM(f.sales_amount) AS customer_spending,
	MIN(order_date) AS first_date,
	MAX(order_date) AS last_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM 
  (
	SELECT 
		customer_key,
		customer_spending,
		lifespan,
		CASE WHEN lifespan >= 12 AND customer_spending > 5000 THEN 'VIP'
			 WHEN lifespan >= 12 AND customer_spending <= 5000 THEN 'Regular'
			 ELSE 'New'
		END AS customer_segment
	FROM customer_spend_category
)h
GROUP BY customer_segment 
ORDER BY total_customers DESC;
GO

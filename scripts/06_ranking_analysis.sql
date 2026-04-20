 /*
=====================================================
Ranking Analysis (Top-N, Bottom-N)
=====================================================
Order the values of dimensions by measure in other to 
identify Top-N performers | Bottom-N performers.
Formula: RANK [Dimension] By Agg[Measure]
=====================================================
*/

-- -----------------------------------------------------------------
-- Which 5 products generate the highest revenue
-- -----------------------------------------------------------------

SELECT TOP 5 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;
GO

-- Using Subquery
SELECT *
FROM (
	SELECT
		p.product_name,
		SUM(f.sales_amount) AS total_revenue,
		RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS product_rank
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	GROUP BY p.product_name) T
WHERE product_rank <=5;
GO


-- -----------------------------------------------------------------
-- What are the 5 worst-performing products in terms of sales
-- -----------------------------------------------------------------

SELECT TOP 5 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue;
GO
  
-- Using Subquery
SELECT *
FROM (
	SELECT
		p.product_name,
		SUM(f.sales_amount) AS total_revenue,
		RANK() OVER (ORDER BY SUM(f.sales_amount)) AS product_rank
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	GROUP BY p.product_name) T
WHERE product_rank <=5;
GO

-- -----------------------------------------------------------------
-- Which 5 subcategories generate the highest revenue
-- -----------------------------------------------------------------

SELECT TOP 5 
	p.subcategory,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC;
GO

-- -----------------------------------------------------------------
-- What are the 5 worst-performing subcategories in terms of sales
-- -----------------------------------------------------------------

SELECT TOP 5 
	p.subcategory,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_revenue;
GO

-- -----------------------------------------------------------------
-- Find the top 10 customers who generated the highest revenue
-- -----------------------------------------------------------------

SELECT TOP 10
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(s.sales_amount) total_revenue_by_customer 
FROM gold.fact_sales s 
LEFT JOIN gold.dim_customers c
ON c.customer_key = s.product_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_revenue_by_customer DESC;
GO

-- -----------------------------------------------------------------
-- Find the 3 customers with the fewest orders placed
-- -----------------------------------------------------------------

SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_orders;
GO

/*
================================================================
Performance Analysis
================================================================
-- comparing the current value to a target value
-- Helps measure success and compare performance
-- Formula: current[Measure] - Target[Measure]
================================================================
*/

/* 
--------------------------------------------------------------------------
Analyze the yearly performance of products by comparing each product's 
sales to both its average sales performance and the previous year's sales 
--------------------------------------------------------------------------
*/

-- -----------------------------------------------------------------
-- Using Subquery
-- -----------------------------------------------------------------

SELECT
	order_date,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END AS avg_change,
  -- ------------------------
	-- year over year analysis
  -- ------------------------
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS previous_year_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date)
		AS diff_yearly_sales,
	CASE 
      WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) > 0 
        THEN 'Increase'
		  WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) < 0 
        THEN 'Decrease'
		 ELSE 'No Change'
	END AS yearly_change
FROM 
  (
SELECT 
	DATETRUNC(year, f.order_date) AS order_date,
	p.product_name AS product_name,
	SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY p.product_name, DATETRUNC(year, f.order_date)
)T;
GO

-- -----------------------------------------------------------------
-- Using CTE
-- -----------------------------------------------------------------

WITH yearly_product_sales AS 
  (
	SELECT 
		YEAR(f.order_date) AS order_date,
		p.product_name AS product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY p.product_name, YEAR(f.order_date)
)

SELECT
	order_date,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END AS avg_change,
  -- ------------------------
	-- year over year analysis
  -- ------------------------
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS previous_year_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date)
		AS diff_yearly_sales,
	CASE 
      WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) > 0 
        THEN 'Increase'
	    WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) < 0 
        THEN 'Decrease'
		 ELSE 'No Change'
	END AS yearly_change
FROM yearly_product_sales;
GO

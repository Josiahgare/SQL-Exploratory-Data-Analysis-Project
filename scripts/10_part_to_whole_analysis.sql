/*
================================================================
Part-to-Whole Analysis
================================================================
Analyze how an individual part is performing compared to the overall, 
allowing us to understand which category has the greatest impact 
on the business
Formula: ([Measure]/Total[Measure]) *100 By [Dimension] 
================================================================
*/

-- -----------------------------------------------------------------
-- Finding which category contribute the most to the overall sales?
-- -----------------------------------------------------------------

WITH sales_by_category AS (
SELECT 
	p.category,
	SUM(f.sales_amount) AS category_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY P.category
)

SELECT
	category,
	category_sales,
	SUM(category_sales) OVER () AS overall_sales,
	CONCAT(ROUND((CAST(category_sales AS FLOAT) / SUM(category_sales) OVER ())*100, 2), '%') AS percentage_of_total
FROM sales_by_category
ORDER BY category_sales DESC;
GO

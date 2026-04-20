/*
================================================================
Cumulative Analysis
================================================================
Aggregate the data progressively over time
Helps to understand whether our business is growing or declining
Formula: Agg[Cumulative Measure] By [Date Dimension]
================================================================
*/

-- -----------------------------------------------------------------
-- Calculate the total sales per month and the running total of sales over time
-- -----------------------------------------------------------------

SELECT
	order_date,
	total_sales,
	-- partition by year and default frame in unbounded preceding and current row
	SUM(total_sales) OVER (PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total,
	avg_price,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average,
	LAG(total_sales) OVER (ORDER BY order_date) AS previous_monthly_sales,	--*****************
	total_sales - LAG(total_sales) OVER (ORDER BY order_date) AS monthly_sales_difference
FROM(
	SELECT 
		DATETRUNC(month, order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE DATETRUNC(month, order_date) IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
)t;
GO

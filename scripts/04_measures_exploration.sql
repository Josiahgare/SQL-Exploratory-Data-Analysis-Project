/*
=====================================================
Measures Exploration
=====================================================
Calculate the key metric of the business (Big Numbers)
Highest level of Aggregation | Lowest level of details
Formula: SUM/AVG/COUNT [Measure]
=====================================================
*/

-- Finding the Total sales
SELECT SUM(sales_amount) total_sales FROM gold.fact_sales;

-- Finding the average selling price
SELECT AVG(price) average_price FROM gold.fact_sales;
GO

-- Finding the total number of orders
SELECT COUNT(order_number) total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) total_orders FROM gold.fact_sales;
GO

-- Finding the total number of product
SELECT COUNT(product_key) total_product FROM gold.dim_products;
SELECT COUNT(DISTINCT product_key) total_product FROM gold.dim_products;
SELECT COUNT(product_name) total_product FROM gold.dim_products;
SELECT COUNT(DISTINCT product_name) total_product FROM gold.dim_products;
GO

-- Finding the total number of customers
SELECT COUNT(customer_key) total_customers FROM gold.dim_customers;
SELECT COUNT(DISTINCT customer_key) total_customers FROM gold.dim_customers;
GO

-- Finding the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) total_customers FROM gold.fact_sales;
GO

-- Generating a report that shows all key metrics of the business

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Product', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers;
GO

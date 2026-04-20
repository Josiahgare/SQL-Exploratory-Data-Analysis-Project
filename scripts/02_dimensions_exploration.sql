/* 
================================================================
Dimension Exploration
================================================================
Identifying the unique values (or categories) in each dimension. 
Helps to recognze how the data might be 
-- grouped or segmented,which is useful for later analysis. 
Formula: DISTINCT[dimension]
================================================================
*/

-- Explore all the Countries our customers come from
SELECT DISTINCT country FROM gold.dim_customers;

-- Explore all the Categories "The Major Divisions"
SELECT DISTINCT category, subcategory, product_name 
FROM gold.dim_products
ORDER BY 1,2,3;

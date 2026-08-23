
-- 02_Dimension_exploration

-- Identify the unique vale or categories in the dimension
-- So that you have a better understanding of how the data can grouped or segmented for dala analytics

-- Syntax: SELECT DISTICT [Dimension] FROM db.table

-- Explore all countries the cuatomers comes from

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

SELECT DISTINCT c.country
FROM gold.dim_customers AS c


-- Explore all product categories "The Major Division"
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'

SELECT *
FROM gold.dim_products;

SELECT DISTINCT p.category, p.subcategory, p.product_name
FROM gold.dim_products AS p

-- The more columns you add to SELECT DISTINCT, the more unique combinations you'll get —
-- because it's harder for all columns to match at once
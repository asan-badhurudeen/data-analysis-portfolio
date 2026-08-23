 
-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES
 
-- Explore all columns in the database 

 SELECT * FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'dim_customers'

 SELECT * FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'dim_products' AND DATA_TYPE = 'int'

 SELECT * FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'fact_sales'  AND (DATA_TYPE IN ('int', 'tinyint'))

 SELECT *
 FROM gold.fact_sales

 -- Find the total sales
SELECT SUM(f.sales_amount) totalSales
FROM gold.fact_sales AS f


  -- Find how many items sold
SELECT SUM(f.quantity) itemsSold
FROM gold.fact_sales AS f


 -- Find the average selling price
 SELECT AVG(price) AS avgSellingPrice
 FROM gold.fact_sales

 -- Find the total number of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Find the total number of products
 SELECT COUNT(DISTINCT product_id) total_products FROM gold.dim_products
  SELECT COUNT(product_id) AS total_products FROM gold.dim_products


 --Find the total number of customers
 SELECT COUNT(customer_id) total_customers FROM gold.dim_customers
 SELECT COUNT(DISTINCT customer_id) total_customers FROM gold.dim_customers

 -- Find the total number of customers who placed an order

 -- NO JOIN
 -- Return data from two tables without combining them

 SELECT * FROM gold.dim_customers;

 SELECT * FROM gold.fact_sales;

 SELECT COUNT(c.customer_key) customersWhoPlacedAnOrder
 FROM gold.dim_customers AS c
 INNER JOIN gold.fact_sales AS f
 ON c.customer_key = f.customer_key

SELECT COUNT(DISTINCT customer_key) customersWhoPlacedAnOrder FROM gold.fact_sales 

-- UNION
-- Get all distinch row from both queries

---------------------------------------------------
--- Generate a report of key metrics of the business
-----------------------------------------------------
SELECT 'TotalSales' AS measure_name , SUM(f.sales_amount) measure_value, 'fact_sales' AS source_table
FROM gold.fact_sales AS f

UNION 

SELECT 'totalItemsSold'  ,SUM(f.quantity), 'fact_sales'
FROM gold.fact_sales AS f

UNION

 SELECT 'avgSellingPrice',AVG(price), 'fact_sales'
 FROM gold.fact_sales

UNION

SELECT 'total_orders', COUNT(DISTINCT order_number) ,'fact_sales'  FROM gold.fact_sales

UNION

 SELECT 'total_products', COUNT(DISTINCT product_id) , 'dim_products' FROM gold.dim_products

UNION

 SELECT 'total_customers',COUNT(DISTINCT customer_id), 'dim_customers'  FROM gold.dim_customers

 UNION

 
SELECT 'customersWhoPlacedAnOrder', COUNT(DISTINCT customer_key), 'fact_sales'  FROM gold.fact_sales 
/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'D:\01_Data_with_baara\sql-data-analytics-project-main\datasets\csv-files\gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'D:\01_Data_with_baara\sql-data-analytics-project-main\datasets\csv-files\gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'D:\01_Data_with_baara\sql-data-analytics-project-main\datasets\csv-files\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES

 -- Explore all columns in the database
 SELECT * FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'dim_customers'

 SELECT DISTINCT i.TABLE_NAME 
 FROM INFORMATION_SCHEMA.COLUMNS AS i

 
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


-- Date Exploration

-- Get the earliest and latest dates
-- TO Undersatnd the timespan and scope of the data


-- Find the date of the first and last order date
-- How many years of sales are available

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'

SELECT *
FROM gold.fact_sales;

SELECT 
	MIN(f.order_date) AS FirstOrderDate,
	MAX(f.order_date) AS LastOrderDate,
	DATEDIFF(YEAR, MIN(f.order_date), MAX(f.order_date)) AS OrderRangeYears
FROM gold.fact_sales AS f



-- Find the yougest and oldest customer birthdate and their ages

SELECT *
FROM gold.dim_customers;


SELECT 
	MAX(c.birthdate) AS YougestBirthDate,
	DATEDIFF(YEAR, MAX(c.birthdate), GETDATE()) YougestCustomerAge,
	MIN(c.birthdate) AS OldestBirthDate,
	DATEDIFF(YEAR, MIN(c.birthdate), GETDATE()) OldestCustomerAge
FROM gold.dim_customers AS c


 
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



 -- Database exploration
 SELECT * FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'dim_customers'
 

 SELECT *
 FROM gold.dim_customers

 -- Dimension_exploration

 SELECT DISTINCT country
 FROM gold.dim_customers

-- Measure exploration
SELECT COUNT(c.customer_id) totalCustomers FROM gold.dim_customers AS c;

SELECT COUNT( DISTINCT c.customer_id) totalCustomers FROM gold.dim_customers AS c;


-- Find the total numer of customers by countries
SELECT
	c.country AS country,
	COUNT(c.customer_id) AS totalCustomers
FROM gold.dim_customers AS c
GROUP BY c.country
ORDER BY COUNT(c.customer_id) DESC

-- Find the total numer of customers by Genders
SELECT
	c.gender AS Gender,
	COUNT(c.customer_id) AS totalCustomers
FROM gold.dim_customers AS c
GROUP BY c.gender
ORDER BY COUNT(c.customer_id) DESC

-- Find the total products by category
SELECT * FROM gold.dim_products

SELECT DISTINCT category FROM gold.dim_products;

SELECT DISTINCT product_id FROM gold.dim_products;

SELECT 
	p.category,
	COUNT(DISTINCT p.product_id) totalProducts
FROM gold.dim_products AS p
GROUP BY p.category
ORDER BY COUNT(DISTINCT p.product_id) DESC

-- what is the average cost in each category

SELECT 
	p.category,
	AVG(p.cost) AverageCost
FROM gold.dim_products AS p
GROUP BY p.category
ORDER BY AVG(p.cost) DESC

SELECT p.cost
FROM gold.dim_products AS p
WHERE p.cost IS NULL

-- Total revenue generated for each category

/* SELECT 
	p.category,
	SUM(p.cost) TotalRevenue
FROM gold.dim_products AS p
GROUP BY p.category
ORDER BY AVG(p.cost) DESC */

SELECT * FROM gold.dim_products;

SELECT * FROM gold.fact_sales;

-- Main query

SELECT 
	t.category,
	SUM(t.sales_amount) total_revenue
FROM (
		--- Subquery in FROM Cluase act as temporaty table
		SELECT 
		p.product_key,
		p.category,
		f.sales_amount
		FROM gold.dim_products AS p
		INNER JOIN gold.fact_sales AS f
		ON p.product_key = f.product_key
	) AS t
GROUP BY t.category
ORDER BY SUM(t.sales_amount) DESC;

SELECT 
-- p.product_key,
p.category,
SUM(f.sales_amount) totalRevenue
FROM gold.dim_products AS p
INNER JOIN gold.fact_sales AS f
ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY SUM(f.sales_amount) DESC;

-- Total revenue generated by each customers

SELECT * FROM gold.fact_sales;

SELECT * FROM gold.dim_customers;


SELECT 
	f.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) totalRevenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY f.customer_key, c.first_name, c.last_name
ORDER BY SUM(f.sales_amount) DESC


SELECT 
	f.customer_key,
	SUM(f.sales_amount)
FROM gold.fact_sales AS f
GROUP BY f.customer_key;


SELECT * FROM INFORMATION_SCHEMA.COLUMNS

SELECT TOP 3 * FROM gold.dim_customers;

SELECT TOP 3 * FROM gold.dim_products;

SELECT TOP 3 * FROM gold.fact_sales;

-- Distribution of items sold across the countries

SELECT 
	c.country,
	SUM(f.quantity) items_sold
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY SUM(f.quantity) DESC

SELECT * FROM gold.dim_products;

SELECT * FROM gold.dim_customers;

SELECT * FROM gold.fact_sales


-- which 5 products generate the highest revenue ?
SELECT TOP 5
	f.product_key,
	SUM(f.sales_amount) AS totalRevenue,
	RANK() OVER(ORDER BY SUM(f.sales_amount) DESC) revenueRank
FROM gold.fact_sales AS f
GROUP BY f.product_key


SELECT t.revenueRank,
	p.product_key,
	p.product_name,
	p.category,
	t.totalRevenue
FROM gold.dim_products AS p
LEFT JOIN (	-- subquery
			-- join subquery is used to prepare data befoe joining  
			SELECT TOP 5
				f.product_key, 
				SUM(f.sales_amount) AS totalRevenue,
				RANK() OVER(ORDER BY SUM(f.sales_amount) DESC) revenueRank
			FROM gold.fact_sales AS f
			GROUP BY f.product_key
			)t
ON p.product_key = t.product_key
WHERE t.product_key IS NOT NULL
ORDER BY t.revenueRank ASC

SELECT TOP 5
	p.product_name,
	SUM(sales_amount) TotalRevenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY SUM(sales_amount) DESC

-- 5 worst performing products
SELECT TOP 5
	p.product_name,
	SUM(sales_amount) TotalRevenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY SUM(sales_amount) ASC

-- Find the top 10 customers who have generated the highest revenue

SELECT TOP 10
	f.customer_key,
	c.first_name,
	c.country,
	SUM(f.sales_amount) totalRevenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY f.customer_key,c.first_name,c.country
ORDER BY SUM(f.sales_amount) DESC


SELECT TOP 3
	f.customer_key,
	c.first_name,
	c.country,
	COUNT (DISTINCT f.order_number) totalOrders
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY f.customer_key, c.first_name, c.country
ORDER BY COUNT (DISTINCT f.order_number) ASC
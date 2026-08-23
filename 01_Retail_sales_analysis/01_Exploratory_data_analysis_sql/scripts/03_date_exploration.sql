
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
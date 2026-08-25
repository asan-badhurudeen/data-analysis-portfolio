SELECT *
FROM [gold].[fact_sales]

-- 1. Change over time
-- Measure by date dimension
-- to help understand the trends and seasonality in the data


-- Q1: Analyze Sales performace over time

SELECT 
	YEAR(s.order_date) AS order_year,
	SUM(s.sales_amount) AS total_sales,
	COUNT(DISTINCT s.customer_key) AS total_customers,
	SUM(s.quantity) AS total_quantities
FROM [gold].[fact_sales] AS s
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date)
ORDER BY YEAR(s.order_date) ASC

SELECT 
	MONTH(s.order_date) AS order_month,
	SUM(s.sales_amount) AS total_sales,
	COUNT(DISTINCT s.customer_key) AS total_customers,
	SUM(s.quantity) AS total_quantities
FROM [gold].[fact_sales] AS s
WHERE s.order_date IS NOT NULL
GROUP BY MONTH(s.order_date)
ORDER BY MONTH(s.order_date) ASC


SELECT 
	YEAR(s.order_date) AS order_year,
	MONTH(s.order_date) AS order_month,
	SUM(s.sales_amount) AS total_sales,
	COUNT(DISTINCT s.customer_key) AS total_customers,
	SUM(s.quantity) AS total_quantities
FROM [gold].[fact_sales] AS s
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(s.order_date), MONTH(s.order_date)
ORDER BY YEAR(s.order_date) ASC, MONTH(s.order_date) ASC

SELECT 
	DATETRUNC(month, s.order_date) AS order_date,
	SUM(s.sales_amount) AS total_sales,
	COUNT(DISTINCT s.customer_key) AS total_customers,
	SUM(s.quantity) AS total_quantities
FROM [gold].[fact_sales] AS s
WHERE s.order_date IS NOT NULL
GROUP BY DATETRUNC(month, s.order_date)
ORDER BY DATETRUNC(month, s.order_date) ASC

SELECT 
	FORMAT(s.order_date, 'yyyy-MMM') AS order_date,
	SUM(s.sales_amount) AS total_sales,
	COUNT(DISTINCT s.customer_key) AS total_customers,
	SUM(s.quantity) AS total_quantities
FROM [gold].[fact_sales] AS s
WHERE s.order_date IS NOT NULL
GROUP BY FORMAT(s.order_date, 'yyyy-MMM')
ORDER BY FORMAT(s.order_date, 'yyyy-MMM')



/*

======================================================================
customer Report
======================================================================
Purpose:
	- This report consolidates key customer metrics and behaviour

Highlights 

	1. Gather essential fields sunch as customer key, number, name, age
	2. Segment customers by age and based on their spending behaviour by VIP, Regular, New
			- VIP: total sales > 5000 and lifespan >= 12
			- Regular: total sales < 5000 but lifespan >= 12
			- New: totalsales < 5000 and lifespan < 12
	3. Aggregate customer-level metrics
			- total orders
			- total sales
			- total products
			- total quantities
			- lifespan (in months)
	4. Calculate valuable KPIs:
			- recency ( months since last sale)
			- average order reveenue
			- average monthly revenue

============================================================================================
*/






--CREATE VIEW gold.report_customers AS
WITH CTE_base_query AS (
/*---------------------------------------------------------
1) Base Query: Retreive all core columns from the table
----------------------------------------------------------*/
SELECT 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_number,
	c.customer_key,
	-- c.first_name,
	-- c.last_name,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	-- c.birthdate,
	DATEDIFF(YEAR, c.birthdate, GETDATE()) AS Customer_age
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
WHERE f.order_date IS NOT NULL)

, CTE_customer_aggregation AS 
(
/*---------------------------------------------------------
2) Customer Aggregation:summarize Key metrics at customer level
----------------------------------------------------------*/
SELECT 
	customer_key,
	customer_number,
	customer_name,
	Customer_age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantities,
	COUNT(DISTINCT product_key) AS total_products,
	-- order_date,
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM CTE_base_query
GROUP BY 	customer_key,
		customer_number,
		customer_name,
		Customer_age )


, Final_query AS
/*------------------------------------------
3.Final_query: Combines all query result into one output plus additional segmentation
---------------------------------------*/
(SELECT 
	customer_key,
	customer_number,
	customer_name,
	Customer_age,
	CASE
		WHEN Customer_age < 20 THEN 'Under 20'
		WHEN Customer_age BETWEEN 20 AND 29 THEN '20-29'
		WHEN Customer_age BETWEEN 30 AND 39 THEN '30-39'
		WHEN Customer_age BETWEEN 40 AND 49 THEN '40-49'
		WHEN Customer_age BETWEEN 50 AND 59 THEN '50-59'
		WHEN Customer_age BETWEEN 60 AND 69 THEN '60-69'
		ELSE '70 and above'
	END AS age_segment,
	CASE
		WHEN lifespan >= 12 AND total_sales >= 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales < 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_orders,
	total_sales,
	total_quantities,
	total_products,
	-- order_date,
	first_order_date,
	last_order_date,
	lifespan,
	-- compute recency
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
	-- compute average order value
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_value,
	-- compute average monthly spend
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan 
	END AS avg_monthly_spend

FROM CTE_customer_aggregation)

SELECT 
		customer_key,
	customer_number,
	customer_name,
	Customer_age,
	age_segment,
	customer_segment,
	total_orders,
	total_sales,
	total_quantities,
	total_products,
	first_order_date,
	last_order_date,
	lifespan,
	recency,
	avg_order_value,
	avg_monthly_spend
FROM Final_query


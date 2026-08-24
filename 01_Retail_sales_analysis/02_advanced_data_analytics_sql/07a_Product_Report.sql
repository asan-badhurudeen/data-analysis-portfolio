/*

======================================================================
Product Report
======================================================================
Purpose:
	- This report consolidates key product metrics and behaviour

Highlights 

	1. Gather essential fields sunch as product name, category, subcategory, and cost
	2. Segment products by revenue to identify gigh performers, Mid-Range, or Low Performers
	3. Aggregate product-level metrics
			- total orders
			- total sales
			- total quantity sold
			- total customers (unique)
			- lifespan (in months)
	4. Calculate valuable KPIs:
			- recency ( months since last sale)
			- average order revenue
			- average monthly revenue

============================================================================================
*/
CREATE VIEW gold.report_product AS
WITH CTE_base_query AS (
/*--------------------------
1. Base query: retrieving all the columns from the table
---------------------------*/
SELECT 
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost,
	--p.product_key,
	o.order_number,
	o.sales_amount,
	o.quantity,
	o.order_date,
	o.customer_key

FROM gold.fact_sales AS o
LEFT JOIN gold.dim_products AS p
ON p.product_key = o.product_key
WHERE o.order_date IS NOT NULL --only considering valid sales
),

product_aggregation AS (
/*------------------------
2. Product aggregation: summarize key metric at product level
----------------------------*/
SELECT 
	--product_key,
	product_name,
	category,
	subcategory,
	cost,
	COUNT(order_number) total_orders,
	SUM(sales_amount) total_sales,
	SUM(quantity) total_quantities_sold,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	COUNT(DISTINCT customer_key) total_customers,
	MAX(order_date) AS last_order_date,
	CAST( SUM(sales_amount) AS FLOAT) / NULLIF(SUM(quantity), 0) avg_selling_price
FROM CTE_base_query
GROUP BY product_name, category, subcategory, cost
),

Final_Query AS (
SELECT 
	product_name,
	category,
	subcategory,
	cost,
	total_orders,
	total_sales,
	total_quantities_sold,
	avg_selling_price,
		CASE WHEN total_sales > 20000 THEN 'High-Performer'
		WHEN total_sales > 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
		END AS product_segment,
	lifespan,
	total_customers,
	CASE
		WHEN total_orders != 0 THEN ROUND(CAST(total_sales AS FLOAT) / total_orders, 2) 
		ELSE total_sales
		END AS average_order_revenue,
	CASE 
		WHEN lifespan != 0 THEN ROUND(CAST(total_sales AS FLOAT) / lifespan, 2)
		ELSE total_sales
		END AS average_monthly_revenue,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS regency
FROM product_aggregation
)

/*----------------------------
Final Query: Combine All queries into a single Query
-----------------------*/

SELECT 
	product_name,
	category,
	subcategory,
	cost,
	total_orders,
	total_sales,
	total_quantities_sold,
	avg_selling_price,
	product_segment,
	lifespan,
	total_customers,
	average_order_revenue,
	average_monthly_revenue,
	regency
FROM Final_Query
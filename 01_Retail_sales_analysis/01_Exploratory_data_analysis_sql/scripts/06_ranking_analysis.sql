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
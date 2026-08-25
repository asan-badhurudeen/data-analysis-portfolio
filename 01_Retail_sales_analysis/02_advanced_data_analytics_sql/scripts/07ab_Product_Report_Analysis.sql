SELECT *
FROM gold.report_product


-- Query_1: Total orders based on product segment
SELECT 
	product_segment,
	SUM(total_orders) total_orders
FROM gold.report_product
GROUP BY product_segment

-- Query_2: Total sales based on product segment 
SELECT 
	product_segment,
	SUM(total_sales) total_sales
FROM gold.report_product
GROUP BY product_segment
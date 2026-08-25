SELECT *
FROM gold.report_customers

-- Query_1: sales based on age group
SELECT 
		age_segment,
		SUM(total_sales) total_sales
FROM gold.report_customers
GROUP BY age_segment

--Query_2: sales based on customer segment
SELECT 
		customer_segment,
		SUM(total_sales) total_sales
FROM gold.report_customers
GROUP BY customer_segment

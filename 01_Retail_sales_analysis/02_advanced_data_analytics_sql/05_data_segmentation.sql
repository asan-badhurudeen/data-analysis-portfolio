--
--- 5. Data segmentation
-- Crate a new dimesnion based on certain condition and aggreagte the measure by created dimension

--
-- Task_1: Segment producst based on cost range
-- count how many products fall into each segment
SELECT t.cost_range,
	COUNT(*) no_of_products
FROM 
(SELECT 
	p.product_key,
	p.product_name,
	p.cost,
	CASE 
		WHEN p.cost < 100 THEN 'Below 100'
		WHEN p.cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN p.cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END AS cost_range
FROM gold.dim_products AS p) t
GROUP BY t.cost_range


SELECT 	
FROM gold.fact_sales AS f

---
--- Group customers into each segment based on their spending behaviour
-- VIP: Customer with atleast 12 month of history with spending of 5000 or more
-- Regular: Customer with atleast 12 month of history with spending of less than 5000
-- New: Customer with lifespan less than 12

-- Question: Find the total number of customer by each group




WITH CTE_customer_spending_behaviour AS 
(SELECT 
	f.customer_key,
	--f.order_date,
	SUM(f.sales_amount) total_spends
FROM gold.fact_sales AS f
GROUP BY f.customer_key
--ORDER BY SUM(f.sales_amount) DESC
)


, CTE_customer_history AS (
SELECT 
	f.customer_key,
	MIN(f.order_date) AS first_order_date,
	MAX(f.order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(f.order_date),MAX(f.order_date)) AS lifespan
	--SUM(f.sales_amount) total_spends
FROM gold.fact_sales AS f
GROUP BY f.customer_key
-- ORDER BY DATEDIFF(MONTH, MIN(f.order_date),MAX(f.order_date)) DESC
)


, CTE_customer_segments AS (
SELECT 
	ccsb.customer_key,
	ccsb.total_spends,
	cch.lifespan,
	CASE
		WHEN ccsb.total_spends > 5000 AND cch.lifespan >= 12 THEN 'VIP'
		WHEN ccsb.total_spends < 5000 AND cch.lifespan >= 12 THEN 'Regular'
		--WHEN cch.month_history < 12 THEN 'New'
		ELSE 'New'
	END AS customer_segments
FROM CTE_customer_spending_behaviour AS ccsb
LEFT JOIN CTE_customer_history AS cch
ON ccsb.customer_key = cch.customer_key
)

SELECT 
	ccs.customer_segments,
	COUNT(ccs.customer_key) AS totalCustomers
FROM CTE_customer_segments AS ccs
-- WHERE ccs.customer_segments IS NOT NULL
GROUP BY ccs.customer_segments
ORDER BY COUNT(ccs.customer_key) DESC;
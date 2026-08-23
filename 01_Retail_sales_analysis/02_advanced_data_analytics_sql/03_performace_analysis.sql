
--- 3. Performance_analysis
-- Comparte current measure to target measure
-- to see if the performance is declining or growing

WITH CTE_yearly_sales AS (
	SELECT 
		YEAR(s.order_date) AS order_year,
		p.product_name,
		SUM(s.sales_amount) AS current_sales
	
	FROM gold.fact_sales as s
	LEFT JOIN gold.dim_products as p
	on s.product_key = p.product_key
	WHERE s.order_date IS NOT NULL
	GROUP BY YEAR(s.order_date),
		p.product_name )

SELECT *,
	AVG(current_sales) OVER (PARTITION BY product_name) AvgSales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		ELSE 'Avg'
		END AS avg_chnage,
	
	--- year over year analysis

	LAG(current_sales, 1, NULL) OVER (PARTITION BY product_name ORDER BY order_year ASC
									) previous_year_sales,
	current_sales - LAG(current_sales, 1, NULL) OVER (PARTITION BY product_name ORDER BY order_year ASC
									) diff_sales,
	CASE WHEN current_sales - LAG(current_sales, 1, NULL) OVER (PARTITION BY product_name ORDER BY order_year ASC
									) < 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales, 1, NULL) OVER (PARTITION BY product_name ORDER BY order_year ASC
									) > 0 THEN 'Decrease'
		ELSE 'No change'
		END AS previous_year_change

FROM CTE_yearly_sales
--ORDER BY product_name, order_year


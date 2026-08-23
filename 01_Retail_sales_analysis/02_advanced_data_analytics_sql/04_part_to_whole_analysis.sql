-- 4.Part to whole analysis
-- how a single dimension compared to the overall performance
-- to see which dimension or category as maximum impact on the business


-- Which categoris contributes the most to overall sales?

/*

SELECT *, 
	(SELECT SUM(sales_amount) FROM gold.fact_sales ) AS total_sales,
	CAST(Sales AS FLOAT) / (SELECT SUM(sales_amount) FROM gold.fact_sales ) * 100 
FROM (
SELECT 
	p.category,
	SUM(f.sales_amount) AS Sales
 FROM gold.fact_sales AS f
 LEFT JOIN gold.dim_products AS p
 ON f.product_key = p.product_key
 GROUP BY p.category ) t
 */

WITH CTE_category_sales AS 
(
 SELECT 
	p.category,
	SUM(f.sales_amount) AS Sales
 FROM gold.fact_sales AS f
 LEFT JOIN gold.dim_products AS p
 ON f.product_key = p.product_key
 GROUP BY p.category )

 SELECT *,
	SUM(Sales) OVER () overall_sales,
	CONCAT(ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER () * 100, 2), '%') AS  percenatage_of_total
 FROM CTE_category_sales AS ccs
 ORDER BY Sales DESC
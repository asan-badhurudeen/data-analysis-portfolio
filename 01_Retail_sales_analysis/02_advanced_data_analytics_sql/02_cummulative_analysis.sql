-- Culumative analysis 

-- aggregate the data progressively over time

-- calculate the total sales per month
-- and the running total of sales over time
SELECT *,
	SUM(totalSales) OVER (PARTITION BY YEAR(order_date) ORDER BY MONTH(order_date) ASC
								ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_sales_each_year
FROM 
		(SELECT 
			DATETRUNC(MONTH, s.order_date) AS order_date,
			SUM(s.sales_amount) AS totalSales,
			SUM(SUM(s.sales_amount) ) OVER (ORDER BY DATETRUNC(MONTH, s.order_date) ASC 
									ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_total_sales
		FROM gold.fact_sales as s
		WHERE s.order_date IS NOT NULL
		GROUP BY DATETRUNC(MONTH, s.order_date)
		--ORDER BY DATETRUNC(MONTH, s.order_date)
			) t


SELECT 
		DATETRUNC(YEAR, s.order_date) AS order_date,
		SUM(s.sales_amount) AS totalSales,
		SUM(SUM(s.sales_amount) ) OVER (ORDER BY DATETRUNC(YEAR, s.order_date) ASC 
									ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_total_sales
FROM gold.fact_sales as s
WHERE s.order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, s.order_date)


SELECT *,
	AVG(AvgSales) OVER (ORDER BY order_date ASC) Moving_avg_entire_sales 
FROM (SELECT 
	DATETRUNC(YEAR, s.order_date) order_date,
	AVG(s.sales_amount) AvgSales
FROM gold.fact_sales AS s
WHERE s.order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, s.order_date)) t

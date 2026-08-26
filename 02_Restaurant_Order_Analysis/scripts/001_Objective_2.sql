/*
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'order_details'
*/

-- =====================================
-- Objective 2
-- Explore the Orders Table
-- =====================================


-- =====================================================
-- 2.1 View the order_detils table. what is the date range of the table?
-- ======================================================
SELECT *
FROM dbo.order_details

-- Use MIN(), MAX() to find the date range
SELECT
 CAST(MIN(order_date) AS DATE) AS FirstOrder,
 CAST(MAX(order_date) AS DATE) AS LastOrder
FROM dbo.order_details

-- ================================================
-- 2.2 How many orders were made in this date range? how many items were ordered within the date range?
-- ================================================

SELECT COUNT(DISTINCT order_id) Total_orders FROM dbo.order_details

SELECT COUNT(item_id) TotalItemsOrdered FROM dbo.order_details;

-- ==============================================
-- 2.3 which orders had the most number of items?
-- 2.4 How many orders had more than 12 items ?
-- ==============================================

WITH CTE_OrdersRanked AS (
SELECT 
		t.order_id,
		t.TotalOrders,
		RANK() OVER (ORDER BY t.TotalOrders DESC) OrdersRank
FROM (	-- Subquery
		-- Each order ordered how many items 
		SELECT 
			order_id,
			COUNT(item_id) TotalOrders
		FROM dbo.order_details
		GROUP BY order_id)t

)
/*
-- Which orders had most number of items ?
SELECT 
		order_id,
		TotalOrders
		--OrdersRank
FROM CTE_OrdersRanked
WHERE OrdersRank = 1
*/

-- How many orders had more than 12 items ?

SELECT 
	COUNT(order_id) TotalOrders
FROM ( -- Subquery
	   -- Orders which have more than 12 items
		SELECT 
				order_id,
				TotalOrders
				-- RANK() OVER (ORDER BY t.TotalOrders DESC) OrdersRank
		FROM CTE_OrdersRanked
		WHERE TotalOrders > 12) t
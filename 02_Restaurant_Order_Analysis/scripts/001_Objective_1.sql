/* 
-- ========================================================
-- Objective 1: Explore the Items Table
-- Data source: menu_items
-- Author: asan
-- Date: 25/08/2026 8:00 PM
-- =========================================================
*/

-- Q1.1: View the menu_items table and write a query to find the number of items on the menu
SELECT 
	m.menu_item_id,
	m.item_name,
	m.category,
	m.price
FROM dbo.menu_items AS m


SELECT COUNT(DISTINCT m.menu_item_id) AS no_of_items FROM dbo.menu_items AS m

-- Q1.2 What are the least and most epensive items

-- Most expensive items in the menu
SELECT *
FROM ( -- Sub query
	   -- Ranking the items by most expensive to least
		SELECT 
			m.menu_item_id,
			m.item_name,
			m.category,
			m.price,
			RANK() OVER (ORDER BY m.price DESC) price_rank
		FROM dbo.menu_items AS m)t
WHERE price_rank = 1

-- Least expensive items in the menu
SELECT *
FROM ( -- Sub query
	   -- Ranking the items by Least expensive to Most
		SELECT 
			m.menu_item_id,
			m.item_name,
			m.category,
			m.price,
			RANK() OVER (ORDER BY m.price ASC) price_rank
		FROM dbo.menu_items AS m)t
WHERE price_rank = 1

-- ===================================
-- Dimension Exploartion (EDA)
SELECT DISTINCT Category FROM dbo.menu_items;
-- ===================================


-- Q1.3 How many italian dishes are on the menu? 
-- what are the least and most epensive italian dishes on  the menu

-- Total number of italian dishes in the menu
WITH Italian_dishes AS (
SELECT 
		m.menu_item_id,
		m.item_name,
		m.category,
		m.price
	FROM dbo.menu_items AS m
	WHERE m.category = 'Italian'
)

-- Count of italian dishes
SELECT COUNT(menu_item_id) AS No_of_italian_dishes
FROM Italian_dishes

-- Most Expensive Italian Dishes

SELECT 
	menu_item_id, 
	item_name,
	price
FROM (	-- Subquery
		-- Ranking dishes by price
		SELECT 
			menu_item_id,
			item_name,
			category,
			price,
			RANK() OVER(ORDER BY price DESC) ranked_price
		FROM Italian_dishes) t
WHERE ranked_price = 1



-- Least Expensive italian dishes

SELECT 
	menu_item_id, 
	item_name,
	price
FROM (	-- Subquery
		-- Ranking dishes by price
		SELECT 
			menu_item_id,
			item_name,
			category,
			price,
			RANK() OVER(ORDER BY price ASC) ranked_price
		FROM Italian_dishes) t
WHERE ranked_price = 1


-- Q1.4 How many dishes in each category?
-- what is the average price within each category
SELECT 
	m.category,
	COUNT(m.menu_item_id) AS no_of_items,
	ROUND(AVG(m.price), 2) AS avg_price
FROM dbo.menu_items AS m
GROUP BY m.category
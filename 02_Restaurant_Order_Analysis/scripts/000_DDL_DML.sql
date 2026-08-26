/*
=====================================
SELECT *
FROM dbo.order_details
 

SELECT *
FROM dbo.menu_items
======================================
*/

WITH cte_date_convertion AS
(
-- 1. Viewing the converted orderdate column
SELECT 
	order_date,
	TRY_CONVERT(DATETIME, order_date) convertedOrderDate
FROM dbo.order_details
)

-- =======================
-- 2.Finding the broken data example row with string 'hello'
-- =======================

SELECT
	order_date,
	convertedOrderDate
FROM cte_date_convertion
WHERE convertedOrderDate IS NULL AND order_date IS NOT NULL

/*
 ================================
 -- 3. Creating new orderdate column with type datetime 
 and dropping previous orderdate with type varchar
 ===============================
 */

-- step_1: creating new column OrderDate
ALTER TABLE dbo.order_details 
ADD OrderDate DATETIME

-- Step_2: update the column with values
UPDATE dbo.order_details
SET 
	OrderDate = TRY_CONVERT(DATETIME, order_date)

-- step_3: Dropping the old orderdate column
ALTER TABLE dbo.order_details
DROP COLUMN order_date

-- step_4: Renaming the newly created column
EXEC sp_rename 'dbo.order_details.OrderDate', 'order_date', 'COLUMN';





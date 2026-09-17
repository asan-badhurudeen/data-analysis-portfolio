-- Checking for duplicates and nulls in Primary key
-- Check for unwanted spaces in string columns
-- Check of negactive or zero values in numerical column
-- Check for unwanted leading and trailing spaces 

SELECT 
	District
FROM raw.scan_centres
WHERE District != TRIM(District)

SELECT 
	Place
FROM raw.scan_centres
WHERE Place != TRIM(Place)

-- Finding distinct machine type for dimension exploration
SELECT 
	DISTINCT Machine_Type
FROM raw.scan_centres

SELECT 
	DISTINCT Hospital_Type
FROM raw.scan_centres

-- Find negative or zero or nulls in slices
-- Encountered error
SELECT 
	Slices
FROM raw.scan_centres
WHERE CAST(TRIM(Slices) AS int) < 0 
OR Slices is NULL

-- 
SELECT 
	DISTINCT Slices
FROM raw.scan_centres


-- Replacing na with null for calculations
SELECT
	DISTINCT 
		CASE 
			WHEN Slices = 'NA' THEN NULL
			ELSE CAST(Slices AS INT)
		END
FROM raw.scan_centres

-- Creating boolean for if hospital opens for 24 hours

SELECT 
	CASE 
		WHEN LOWER(TRIM([24 Hrs])) LIKE '%24%' THEN 1
		WHEN LOWER(TRIM([24 Hrs])) IN ('yes', 'true') THEN 1
		ELSE 0
	END AS is_24_hrs
FROM raw.scan_centres


-- Identifying secondary mobile number
SELECT 
    Mobile_No,
	CASE
		WHEN CHARINDEX('/', Mobile_no) > 0
			THEN 
				CASE 
					WHEN LEN(SUBSTRING(TRIM(Mobile_no), CHARINDEX('/',TRIM(Mobile_no))+1, LEN(TRIM(Mobile_no)))) = 2
						THEN SUBSTRING(TRIM(Mobile_no),1 ,CHARINDEX('/', TRIM(Mobile_no))-3 ) + 
								SUBSTRING(TRIM(Mobile_no), CHARINDEX('/',TRIM(Mobile_no))+1, LEN(TRIM(Mobile_no)))
					ELSE SUBSTRING(TRIM(Mobile_no), CHARINDEX('/', TRIM(Mobile_no))+1, LEN(TRIM(Mobile_no)))
				END
		ELSE NULL
	END
FROM raw.scan_centres 
WHERE Mobile_No LIKE '%/%'


-- Extract secondary mobile number
SELECT
	CASE
		WHEN CHARINDEX('/', Mobile_no) > 0
			THEN SUBSTRING(TRIM(Mobile_no),1 ,CHARINDEX('/', TRIM(Mobile_no))-1 )
		ELSE NULLIF(TRIM(Mobile_no), '')
	END AS primary_number
FROM raw.scan_centres 







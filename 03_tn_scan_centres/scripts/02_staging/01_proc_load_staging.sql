WITH stage_transformation AS
(SELECT 
	TRIM(District) AS district, 
	TRIM(Place) AS place,
	TRIM(Machine_Type) AS machine_type,
	TRY_CAST(Machine_Count AS INT) AS machine_count,
	TRIM(Hospital_Type) AS hospital_type,
	CASE 
			WHEN Slices = 'NA' THEN NULL
			ELSE TRY_CAST(Slices AS INT)
	END AS slices,
	CASE 
		WHEN LOWER(TRIM([24 Hrs])) LIKE '%24%' THEN 1
		WHEN LOWER(TRIM([24 Hrs])) IN ('yes', 'true') THEN 1
		ELSE 0
	END AS is_24_hrs,
	TRIM(Address) AS hosiptal_name,
	TRY_CAST (Pincode AS INT) AS pincode,
	
	-- Extracting the primary number from mobile no
	CASE
		WHEN CHARINDEX('/', Mobile_no) > 0
			THEN SUBSTRING(TRIM(Mobile_no),1 ,CHARINDEX('/', TRIM(Mobile_no))-1 )
		ELSE NULLIF(TRIM(Mobile_no), '') -- null if phone number is empty
	END AS primary_number,
	
	-- Extracting the secondary number and yields null if there is no '/' or empty
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
	END AS secondary_number
FROM raw.scan_centres
)


INSERT INTO staging.scan_centres(	
	district, 
	place,
	machine_type,
	machine_count,
	hospital_type,
	slices,
	is_24_hrs,
	hosiptal_name,
	pincode,
	primary_number,
	secondary_number)



SELECT 
	district, 
	place,
	machine_type,
	machine_count,
	hospital_type,
	slices,
	is_24_hrs,
	hosiptal_name,
	pincode,
	primary_number,
	secondary_number
FROM stage_transformation
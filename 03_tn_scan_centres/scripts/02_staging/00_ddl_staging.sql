
IF OBJECT_ID('staging.scan_centres', 'u') IS NOT NULL
	DROP TABLE staging.scan_centres

CREATE TABLE staging.scan_centres (
	scan_centre_id INT IDENTITY(1, 1) PRIMARY KEY,
	district NVARCHAR(100), 
	place NVARCHAR(100),
	machine_type NVARCHAR(50),
	machine_count INT,
	hospital_type NVARCHAR(50),
	slices INT,
	is_24_hrs INT,
	hosiptal_name NVARCHAR(500),
	pincode NVARCHAR(50),
	primary_number NVARCHAR(50),
	secondary_number NVARCHAR(50),
	created_at DATETIME2 DEFAULT SYSDATETIME()

)





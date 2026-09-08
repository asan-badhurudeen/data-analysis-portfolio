IF OBJECT_ID('tempdb..#scan_centres', 'u') IS NOT NULL
	DROP TABLE dbo.#scan_centres

CREATE TABLE #scan_centres (
	[Sl.No] NVARCHAR(MAX),
	District NVARCHAR(MAX),
	Place NVARCHAR(MAX),
	Machine_Type NVARCHAR(MAX),
	Machine_Count NVARCHAR(MAX),
	Hospital_Type NVARCHAR(MAX),
	Slices NVARCHAR(MAX),
	[24 Hrs] NVARCHAR(MAX),
	Address NVARCHAR(MAX),
	Pincode NVARCHAR(MAX),
	Mobile_No NVARCHAR(MAX)

)


BULK INSERT #scan_centres
FROM 'C:\Users\edd\Downloads\tn_medical_scan_centre_details_as_on_17_02_2020.csv'
WITH (
	FIRSTROW = 2,
	FORMAT = 'CSV',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
	)

SELECT *
FROM #scan_centres

IF OBJECT_ID('raw.scan_centres', 'u') IS NOT NULL
	DROP TABLE raw.scan_centres


CREATE TABLE raw.scan_centres (
	[Sl.No] NVARCHAR(MAX),
	District NVARCHAR(MAX),
	Place NVARCHAR(MAX),
	Machine_Type NVARCHAR(MAX),
	Machine_Count NVARCHAR(MAX),
	Hospital_Type NVARCHAR(MAX),
	Slices NVARCHAR(MAX),
	[24 Hrs] NVARCHAR(MAX),
	Address NVARCHAR(MAX),
	Pincode NVARCHAR(MAX),
	Mobile_No NVARCHAR(MAX),
	LoadTimeStamp DATETIME2 DEFAULT SYSDATETIME(),
	LoadSourceFile NVARCHAR(50),
	LoadSourceFileDate NVARCHAR(MAX) NULL

)


INSERT INTO raw.scan_centres (	[Sl.No],
								District ,
								Place,
								Machine_Type ,
								Machine_Count ,
								Hospital_Type ,
								Slices ,
								[24 Hrs], 
								Address ,
								Pincode ,
								Mobile_No,

								LoadSourceFile,
								LoadSourceFileDate)
SELECT 
	[Sl.No],
	District ,
	Place,
	Machine_Type ,
	Machine_Count ,
	Hospital_Type ,
	Slices ,
	24 Hrs, 
	Address ,
	Pincode ,
	Mobile_No,
	'tn_medical_scan_centre_details_as_on_17_02_2020' ,
	'17_02_2020' 
FROM #scan_centres

DROP TABLE tempdb.#scan_centres
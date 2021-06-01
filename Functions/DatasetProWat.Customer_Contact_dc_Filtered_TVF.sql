SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      RYFE
  Description: Retrieve Customer Contacts where possible
--             ARG 2020-02-13 Changed Validate to Filter
--				ARG 2020-02-17 Amended to pass all records through rather than
--                             excluding records due to data cleansing
--             ARG 2020-02-19  Added rule to set tick boxes if only one contact
--                             and added account number for use further up the line,
--                             changed allocation of person id to be dome in transform
--                             Removed parameter, no longer needed
--             ARG 2020-02-20  Added table to hold mappings for Contact/Comm Method
--             ARG 2020-02-28  Added extra SELECT clause to create a 'dummy' DM Contact if there is
--                             a DMEmail value but we have no DMName value as per Safeena, UK business rule only 
--			   RJS 2021-01-11  Added specifics to point [5) send final set of records for transform] as source table has migrated date columns need to specify the column list otherwise proc fails
--			   RYFE 2021-02-19 Created as a TVF based on GBASP Data Cleansing customer contact send for transform
=============================================*/
CREATE FUNCTION [DatasetProWat].[Customer_Contact_dc_Filtered_TVF]
()
RETURNS @ReturnTable TABLE 
	(
		ID int,
		MIG_SITE_NAME		nvarchar(5),
		MIG_COMMENT			varchar(255),
		MIG_CREATED_DATE	datetime,
		CUSTOMER_ID			nvarchar(50),
		FIRST_NAME			nvarchar(100),
		MIDDLE_NAME			nvarchar(100),
		LAST_NAME			nvarchar(100),
		NX_PERSON_ID		nvarchar(50),
		NX_TITLE			nvarchar(100),
		NX_ROLE_DB			nvarchar(50),
		NX_CUSTOMER_PRIMARY varchar(5),
		NX_CUSTOMER_SECONDARY	varchar(5),
		NX_CUSTOMER_ADDRESS_ID  varchar(50),
		NX_CUSTOMER_ADDRESS_PRIMARY varchar(5),
		NX_FILTER_STATUS	int
	)

AS
BEGIN

	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	--DECLARE @FilterMode int = Dataset.Filter_Mode('dc','Customer');
	DECLARE @DUPES TABLE
		(	CUSTOMER_ID nvarchar(50),
			FIRST_NAME nvarchar(100),
			LAST_NAME nvarchar(50)
		)

	DECLARE @MINDUPE TABLE
		(
			MINID nvarchar(50),
			CUSTOMER_ID nvarchar(50),
			FIRST_NAME	nvarchar(100),
			LAST_NAME	nvarchar(100)
		)
	

INSERT INTO @ReturnTable   
SELECT
			  1,	
			  @MIG_SITENAME				AS MIG_SITE_NAME,
			  '',
			  GETDATE(),
			  CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
			  TRIM(ext.FIRST_NAME)		AS FIRST_NAME,
			  TRIM(ext.MIDDLE_NAME)		AS MIDDLE_NAME,
			  TRIM(ext.LAST_NAME)		AS LAST_NAME,
			  '1' 						AS NX_PERSON_ID,			-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '1' , done later in transform
			  TRIM(ext.TITLE)			AS NX_TITLE,
			  
			  [Dataset].[AssignRoleToContact] (CUS_POSITION1)		AS NX_ROLE_DB,		-- held in CUS_position1 on PROWAT
			  'FALSE'					AS NX_CUSTOMER_PRIMARY,	-- default
			  'FALSE'					AS NX_CUSTOMER_SECONDARY,	-- default
			  '1'						AS NX_CUSTOMER_ADDRESS_ID,	-- default
			  'FALSE'                   AS NX_CUSTOMER_ADDRESS_PRIMARY, -- new field added ARG 2020-02-19
			  Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), cus.CUS_Account)), LEFT(TRIM(cus.CUS_Company), 100), ISNULL(CONVERT(varchar(10), cus.CUS_SectorID), '{NULL}'))
FROM		DatasetProWat.Syn_Customer_dc cus
CROSS APPLY DatasetProWat.ExtractNameParts(cus.CUS_Contact1) AS ext
LEFT OUTER JOIN Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), cus.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID

WHERE [DatasetProWat].[Filter_Customer_Contact] (cus.CUS_Contact1) = 1 AND
(Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), cus.CUS_Account)), LEFT(TRIM(cus.CUS_Company), 100), ISNULL(CONVERT(varchar(10), cus.CUS_SectorID), '{NULL}')) > 0)
--AND			CUS_Account NOT IN				-- exclude records with an error found during data cleansing         -- REMOVED THIS CHECKING 17/02/2020
--			(SELECT DISTINCT SourceReferences FROM [GBASP_Angel_DataCleansing].dbo.view_DataDefect_Full 
--			WHERE TableName = 'Customer_dc' 
--			AND ID_Iteration = @ETLProcessId)	-- Data Cleansing DB
UNION ALL
SELECT
			  1,	
			  @MIG_SITENAME				AS MIG_SITE_NAME,
			  '',
			  GETDATE(),
			  CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
			  TRIM(ext.FIRST_NAME)		AS FIRST_NAME,
			  TRIM(ext.MIDDLE_NAME)		AS MIDDLE_NAME,
			  TRIM(ext.LAST_NAME)		AS LAST_NAME,
			  '2' 						AS NX_PERSON_ID,			-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '1' , done later in transform
			  TRIM(ext.TITLE)			AS NX_TITLE,
			  
			  [Dataset].[AssignRoleToContact] (CUS_POSITION2)		AS NX_ROLE_DB,		-- held in CUS_position1 on PROWAT
			  'FALSE'					AS NX_CUSTOMER_PRIMARY,	-- default
			  'FALSE'					AS NX_CUSTOMER_SECONDARY,	-- default
			  '1'						AS NX_CUSTOMER_ADDRESS_ID,	-- default
			  'FALSE'                   AS NX_CUSTOMER_ADDRESS_PRIMARY, -- new field added ARG 2020-02-19
			  Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), cus.CUS_Account)), LEFT(TRIM(cus.CUS_Company), 100), ISNULL(CONVERT(varchar(10), cus.CUS_SectorID), '{NULL}'))
FROM		DatasetProWat.Syn_Customer_dc cus
CROSS APPLY DatasetProWat.ExtractNameParts(cus.CUS_Contact2) AS ext
LEFT OUTER JOIN Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), cus.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID

WHERE [DatasetProWat].[Filter_Customer_Contact] (cus.CUS_Contact2) = 1 AND
(Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), cus.CUS_Account)), LEFT(TRIM(cus.CUS_Company), 100), ISNULL(CONVERT(varchar(10), cus.CUS_SectorID), '{NULL}')) > 0)
UNION ALL
SELECT
			  1,	
			  @MIG_SITENAME				AS MIG_SITE_NAME,
			  '',
			  GETDATE(),
			  CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
			  TRIM(ext.FIRST_NAME)		AS FIRST_NAME,
			  TRIM(ext.MIDDLE_NAME)		AS MIDDLE_NAME,
			  TRIM(ext.LAST_NAME)		AS LAST_NAME,
			  '3' 						AS NX_PERSON_ID,			-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '1' , done later in transform
			  TRIM(ext.TITLE)			AS NX_TITLE,
			  
			  ''						AS NX_ROLE_DB,		-- held in CUS_position1 on PROWAT
			  'FALSE'					AS NX_CUSTOMER_PRIMARY,	-- default
			  'FALSE'					AS NX_CUSTOMER_SECONDARY,	-- default
			  '1'						AS NX_CUSTOMER_ADDRESS_ID,	-- default
			  'FALSE'                   AS NX_CUSTOMER_ADDRESS_PRIMARY, -- new field added ARG 2020-02-19
			  Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), cus.CUS_Account)), LEFT(TRIM(cus.CUS_Company), 100), ISNULL(CONVERT(varchar(10), cus.CUS_SectorID), '{NULL}'))
FROM		DatasetProWat.Syn_Customer_dc cus
CROSS APPLY DatasetProWat.ExtractNameParts(cus.CUS_DMName) AS ext
LEFT OUTER JOIN Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), cus.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID

WHERE [DatasetProWat].[Filter_Customer_Contact] (cus.CUS_DMName) = 1 AND
(Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), cus.CUS_Account)), LEFT(TRIM(cus.CUS_Company), 100), ISNULL(CONVERT(varchar(10), cus.CUS_SectorID), '{NULL}')) > 0)

INSERT INTO @ReturnTable
SELECT
			  1,	
			  @MIG_SITENAME				AS MIG_SITE_NAME,
			  '',
			  GETDATE(),
			  CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
			  ''						AS FIRST_NAME,
			  ''						AS MIDDLE_NAME,
			  'CONTACT'					AS LAST_NAME,
			  '3' 						AS NX_PERSON_ID,			-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '1' , done later in transform
			  TRIM(ext.TITLE)			AS NX_TITLE,
			  
			  ''						AS NX_ROLE_DB,		-- held in CUS_position1 on PROWAT
			  'FALSE'					AS NX_CUSTOMER_PRIMARY,	-- default
			  'FALSE'					AS NX_CUSTOMER_SECONDARY,	-- default
			  '1'						AS NX_CUSTOMER_ADDRESS_ID,	-- default
			  'FALSE'                   AS NX_CUSTOMER_ADDRESS_PRIMARY, -- new field added ARG 2020-02-19
			  Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), cus.CUS_Account)), LEFT(TRIM(cus.CUS_Company), 100), ISNULL(CONVERT(varchar(10), cus.CUS_SectorID), '{NULL}'))
FROM		DatasetProWat.Syn_Customer_dc cus
CROSS APPLY DatasetProWat.ExtractNameParts(cus.CUS_DMName) AS ext
LEFT OUTER JOIN Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), cus.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID

WHERE [DatasetProWat].[Filter_Customer_Contact] (cus.CUS_DMName) = 1 AND
(Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
             ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), cus.CUS_Account)), LEFT(TRIM(cus.CUS_Company), 100), ISNULL(CONVERT(varchar(10), cus.CUS_SectorID), '{NULL}')) > 0)

AND		    cus.CUS_DMEmail <> ''
AND         cus.CUS_ACCOUNT NOT IN (SELECT CUSTOMER_ID FROM @ReturnTable WHERE NX_PERSON_ID = 3) -- don't already have a DM type contact

-- 1) get table with the duplicates in
INSERT INTO @DUPES
SELECT DISTINCT CUSTOMER_ID, FIRST_NAME, LAST_NAME  -- find where we have dupes
FROM		@ReturnTable
GROUP BY	CUSTOMER_ID, FIRST_NAME, LAST_NAME
HAVING		COUNT(CUSTOMER_ID) > 1

-- 2) get table with duplicate detail and the lowest value for the person id - prefix is based on where the record comes from
-- so 1 = Contact1, 2 = Contact2, 3 = DmName 
-- we will take the lowest prefix and delete the rest
INSERT INTO @MINDUPE
SELECT MIN(SUBSTRING(R.NX_PERSON_ID,1,1)) AS MINID, R.CUSTOMER_ID, R.FIRST_NAME, R.LAST_NAME  -- find lowest prefix for each dupe
FROM		@DUPES D
INNER JOIN	@ReturnTable R
ON			D.CUSTOMER_ID = R.CUSTOMER_ID
AND			D.FIRST_NAME = R.FIRST_NAME
AND			D.LAST_NAME = R.LAST_NAME
GROUP BY	R.CUSTOMER_ID, R.FIRST_NAME, R.LAST_NAME

-- 3) now use the above table to delete all but the lowest prefixed record

DELETE	a FROM @ReturnTable a, @MINDUPE b 
WHERE	a.CUSTOMER_ID=b.CUSTOMER_ID 
AND		a.FIRST_NAME= b.FIRST_NAME
AND		a.LAST_NAME= b.LAST_NAME
AND		SUBSTRING(a.NX_PERSON_ID,1,1) <> b.MINID -- delete all but the lowest prefix where we have the same name details

-- 4) where there is only one contact for the customer, they should be marked as default for CUSTOMER_PRIMARY and CUSTOMER_ADDRESS_PRIMARY
UPDATE		@ReturnTable
SET			NX_CUSTOMER_PRIMARY = 'TRUE',
		    NX_CUSTOMER_ADDRESS_PRIMARY = 'TRUE'
WHERE		CUSTOMER_ID IN (
								SELECT	CUSTOMER_ID
								FROM	@ReturnTable
								GROUP BY CUSTOMER_ID
								HAVING COUNT(CUSTOMER_ID) = 1
								)



/*

UNION ALL
SELECT		
			@MIG_SITENAME			AS MIG_SITE_NAME,
			'3'						AS PERSON_ID,	-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '3' 
			TRIM(ext.FIRST_NAME)	AS FIRST_NAME,
			TRIM(ext.MIDDLE_NAME)	AS MIDDLE_NAME,
			TRIM(ext.LAST_NAME)		AS LAST_NAME,
			TRIM(ext.TITLE)			AS TITLE,
			CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
			''						AS ROLE_DB,
			'FALSE'					AS CUSTOMER_PRIMARY,
			'FALSE'					AS CUSTOMER_SECONDARY,
			'1'						AS CUSTOMER_ADDRESS_ID,	-- default
			'FALSE'                 AS CUSTOMER_ADDRESS_PRIMARY -- new field added ARG 2020-02-19
FROM		CUSTOMER_EX cus WITH (NOLOCK)		-- view for In-Scope Customers from Extraction DB
CROSS APPLY [GBASP_Angel_DataCleansing].dbo.ExtractNameParts(cus.CUS_DMName) AS ext
INNER JOIN	[NEXUS_Transform].[dbo].[MAP_Customer] M	-- Legacy to IFS Customer map, used inner join as do not want anything which we don't have a valid
ON			CUS_Account = M.LEGACY_CUSTOMER_REF         -- customer for and unable to pass null through to the src table for the identity
AND			MIG_SITE_NAME = @MIG_SITENAME
WHERE		([GBASP_Angel_DataCleansing].[dbo].[Filter_Customer_Contact] (cus.CUS_DMName) = 1 -- this part will exclude any which are blank
AND         cus.CUS_Filter_Status >= @FilterMode)
--AND			CUS_Account NOT IN				-- exclude records with an error found during data cleansing
--			(SELECT DISTINCT SourceReferences FROM [GBASP_Angel_DataCleansing].dbo.view_DataDefect_Full 
--			WHERE TableName = 'Customer_dc' 
--			AND ID_Iteration = @ETLProcessId)	-- Data Cleansing DB

--	SELECT * FROM #RECS		-- get recs into temp table, compare for testing with final output to see if dupes removed

-- now check if we have a DM Name type contact, if we don't add one but only if we have a DMEmail
INSERT INTO #RECS
SELECT		
			@MIG_SITENAME			AS MIG_SITE_NAME,
			'3'						AS PERSON_ID,	-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '3' 
			''						AS FIRST_NAME,
			''						AS MIDDLE_NAME,
			'CONTACT'				AS LAST_NAME,
			''						AS TITLE,
			CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
			''						AS ROLE_DB,
			'FALSE'					AS CUSTOMER_PRIMARY,
			'FALSE'					AS CUSTOMER_SECONDARY,
			'1'						AS CUSTOMER_ADDRESS_ID,	-- default
			'FALSE'                 AS CUSTOMER_ADDRESS_PRIMARY -- new field added ARG 2020-02-19
FROM		CUSTOMER_EX cus WITH (NOLOCK)		-- view for In-Scope Customers from Extraction DB
CROSS APPLY [GBASP_Angel_DataCleansing].dbo.ExtractNameParts(cus.CUS_DMName) AS ext
INNER JOIN	[NEXUS_Transform].[dbo].[MAP_Customer] M	-- Legacy to IFS Customer map, used inner join as do not want anything which we don't have a valid
ON			CUS_Account = M.LEGACY_CUSTOMER_REF         -- customer for and unable to pass null through to the src table for the identity
AND			MIG_SITE_NAME = @MIG_SITENAME
WHERE		cus.CUS_DMEmail <> ''
AND         cus.CUS_Filter_Status >= @FilterMode
AND         cus.CUS_ACCOUNT NOT IN (SELECT CUSTOMER_ID FROM #RECS WHERE PERSON_ID = 3) -- don't already have a DM type contact



-- We know need to de-duplicate where we have more than one value with the same name
-- 1) get table with the duplicates in
SELECT DISTINCT CUSTOMER_ID, FIRST_NAME, LAST_NAME  -- find where we have dupes
INTO		#DUPES
FROM		#RECS
GROUP BY	CUSTOMER_ID, FIRST_NAME, LAST_NAME
HAVING		COUNT(CUSTOMER_ID) > 1

-- 2) get table with duplicate detail and the lowest value for the person id - prefix is based on where the record comes from
-- so 1 = Contact1, 2 = Contact2, 3 = DmName 
-- we will take the lowest prefix and delete the rest
SELECT MIN(SUBSTRING(R.PERSON_ID,1,1)) AS MINID, R.CUSTOMER_ID, R.FIRST_NAME, R.LAST_NAME  -- find lowest prefix for each dupe
INTO		#MINDUPE
FROM		#DUPES D
INNER JOIN	#RECS R
ON			D.CUSTOMER_ID = R.CUSTOMER_ID
AND			D.FIRST_NAME = R.FIRST_NAME
AND			D.LAST_NAME = R.LAST_NAME
GROUP BY	R.CUSTOMER_ID, R.FIRST_NAME, R.LAST_NAME

-- 3) now use the above table to delete all but the lowest prefixed record 

DELETE	a FROM #RECS a, #MINDUPE b 
WHERE	a.CUSTOMER_ID=b.CUSTOMER_ID 
AND		a.FIRST_NAME= b.FIRST_NAME
AND		a.LAST_NAME= b.LAST_NAME
AND		SUBSTRING(a.PERSON_ID,1,1) <> b.MINID -- delete all but the lowest prefix where we have the same name details

-- 4) where there is only one contact for the customer, they should be marked as default for CUSTOMER_PRIMARY and CUSTOMER_ADDRESS_PRIMARY
UPDATE		#RECS
SET			CUSTOMER_PRIMARY = 'TRUE',
		    CUSTOMER_ADDRESS_PRIMARY = 'TRUE'
WHERE		CUSTOMER_ID IN (
								SELECT	CUSTOMER_ID
								FROM	#RECS
								GROUP BY CUSTOMER_ID
								HAVING COUNT(CUSTOMER_ID) = 1
								)


-- 5) send final set of records for transform					--RJS 2021-01-11 Specified column list due to a mismatch error running the proc--
INSERT into	[NEXUS_Transform].[dbo].[Customer_Contact_src] 
(MIG_SITE_NAME,
PERSON_ID,	
FIRST_NAME,
MIDDLE_NAME,
LAST_NAME,
TITLE,
CUSTOMER_ID,
ROLE_DB,
CUSTOMER_PRIMARY,
CUSTOMER_SECONDARY,
CUSTOMER_ADDRESS_ID,	
CUSTOMER_ADDRESS_PRIMARY)
SELECT	* 
FROM	#RECS

-- 6) need to refer to the results of this in the comm method build. As data is only allowed 
--    in one direction, we need to store these results somewhere
--    only need the customer ids and whether we have 1,2 3 or not
TRUNCATE TABLE		MAP_Contact_Comm_Method 

INSERT INTO			MAP_Contact_Comm_Method
SELECT	DISTINCT	CUSTOMER_ID,
					PERSON_id
FROM				#RECS
*/
RETURN;
END


GO

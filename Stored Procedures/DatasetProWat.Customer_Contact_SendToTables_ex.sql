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
--			   RYFE 2021-02-19 Created based on GBASP Data Cleansing customer contact send for transform
=============================================*/
CREATE PROCEDURE [DatasetProWat].[Customer_Contact_SendToTables_ex]
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	--DECLARE @FilterMode int = Dataset.Filter_Mode('dc','Customer');

	---------------- Delete records already in the loading table for this site -----------------------------------------------
	BEGIN TRANSACTION
		DELETE FROM [Dataset].[Customer_Contact_ex] 
		WHERE MIG_SITE_NAME = @MIG_SITENAME
		COMMIT TRANSACTION
	---------------- Add records to the loading table ---------------------------------------------------------
	
		
	
  
	SELECT
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
		TRIM([DatasetProWat].[CleanString](ext.FIRST_NAME))		AS FIRST_NAME,
		TRIM([DatasetProWat].[CleanString](ext.MIDDLE_NAME))		AS MIDDLE_NAME,
		TRIM([DatasetProWat].[CleanString](ext.LAST_NAME))		AS LAST_NAME,
		'1' 						AS NX_PERSON_ID,			-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '1' , done later in transform
		TRIM([DatasetProWat].[CleanString](ext.TITLE))			AS NX_TITLE,
			  
		[Dataset].[AssignRoleToContact] (CUS_POSITION1)		AS NX_ROLE_DB,		-- held in CUS_position1 on PROWAT
		'FALSE'					AS NX_CUSTOMER_PRIMARY,	-- default
		'FALSE'					AS NX_CUSTOMER_SECONDARY,	-- default
		'1'						AS NX_CUSTOMER_ADDRESS_ID,	-- default
		'FALSE'                   AS NX_CUSTOMER_ADDRESS_PRIMARY -- new field added ARG 2020-02-19
		INTO	#RECS
		FROM	DatasetProWat.Syn_Customer_ex cus
		CROSS APPLY DatasetProWat.ExtractNameParts(cus.CUS_Contact1) AS ext
		--AND			CUS_Account NOT IN				-- exclude records with an error found during data cleansing         -- REMOVED THIS CHECKING 17/02/2020
		--			(SELECT DISTINCT SourceReferences FROM [GBASP_Angel_DataCleansing].dbo.view_DataDefect_Full 
		--			WHERE TableName = 'Customer_dc' 
		--			AND ID_Iteration = @ETLProcessId)	-- Data Cleansing DB
		LEFT OUTER JOIN
        Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), CUS.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
		WHERE [DatasetProWat].[Filter_Customer_Contact] (cus.CUS_Contact1) = 1
		AND (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), CUS.CUS_Account)), LEFT(TRIM(CUS.CUS_Company), 100), ISNULL(CUS.CUS_Type, '{NULL}')) > 0)


	UNION ALL


	SELECT
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
		TRIM([DatasetProWat].[CleanString](ext.FIRST_NAME))		AS FIRST_NAME,
		TRIM([DatasetProWat].[CleanString](ext.MIDDLE_NAME))		AS MIDDLE_NAME,
		TRIM([DatasetProWat].[CleanString](ext.LAST_NAME))		AS LAST_NAME,
		'2' 						AS NX_PERSON_ID,			-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '1' , done later in transform
		TRIM([DatasetProWat].[CleanString](ext.TITLE))			AS NX_TITLE,
			  
		[Dataset].[AssignRoleToContact] (CUS_POSITION2)		AS NX_ROLE_DB,		-- held in CUS_position1 on PROWAT
		'FALSE'					AS NX_CUSTOMER_PRIMARY,	-- default
		'FALSE'					AS NX_CUSTOMER_SECONDARY,	-- default
		'1'						AS NX_CUSTOMER_ADDRESS_ID,	-- default
		'FALSE'                   AS NX_CUSTOMER_ADDRESS_PRIMARY -- new field added ARG 2020-02-19
		FROM		DatasetProWat.Syn_Customer_ex cus
		CROSS APPLY DatasetProWat.ExtractNameParts(cus.CUS_Contact2) AS ext
		LEFT OUTER JOIN
        Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), CUS.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
		WHERE [DatasetProWat].[Filter_Customer_Contact] (cus.CUS_Contact2) = 1
		AND       (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), CUS.CUS_Account)), LEFT(TRIM(CUS.CUS_Company), 100), ISNULL(CUS.CUS_Type, '{NULL}')) > 0)


	UNION ALL


	SELECT
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
		TRIM([DatasetProWat].[CleanString](ext.FIRST_NAME))		AS FIRST_NAME,
		TRIM([DatasetProWat].[CleanString](ext.MIDDLE_NAME))		AS MIDDLE_NAME,
		TRIM([DatasetProWat].[CleanString](ext.LAST_NAME))		AS LAST_NAME,
		'3' 						AS NX_PERSON_ID,			-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '1' , done later in transform
		TRIM([DatasetProWat].[CleanString](ext.TITLE))			AS NX_TITLE,
			  
		''						AS NX_ROLE_DB,		-- held in CUS_position1 on PROWAT
		'FALSE'					AS NX_CUSTOMER_PRIMARY,	-- default
		'FALSE'					AS NX_CUSTOMER_SECONDARY,	-- default
		'1'						AS NX_CUSTOMER_ADDRESS_ID,	-- default
		'FALSE'                   AS NX_CUSTOMER_ADDRESS_PRIMARY -- new field added ARG 2020-02-19
		FROM		DatasetProWat.Syn_Customer_ex cus
		CROSS APPLY DatasetProWat.ExtractNameParts(cus.CUS_DMName) AS ext
		LEFT OUTER JOIN
        Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), CUS.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
		WHERE [DatasetProWat].[Filter_Customer_Contact] (cus.CUS_DMName) = 1
		AND        (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), CUS.CUS_Account)), LEFT(TRIM(CUS.CUS_Company), 100), ISNULL(CUS.CUS_Type, '{NULL}')) > 0)




	INSERT INTO #RECS
		SELECT
			  @MIG_SITENAME				AS MIG_SITE_NAME,
			  ''						AS [MIG_COMMENT],
			  GETDATE()					AS [MIG_CREATED_DATE],
			  CUS.CUS_ACCOUNT			AS CUSTOMER_ID,
			  ''						AS FIRST_NAME,
			  ''						AS MIDDLE_NAME,
			  'CONTACT'					AS LAST_NAME,
			  '3' 						AS NX_PERSON_ID,			-- Derive IFS PERSON_ID by prefixing the IFS_CUSTOMER_ID with '1' , done later in transform
			  TRIM([DatasetProWat].[CleanString](ext.TITLE))			AS NX_TITLE,
			  
			  ''						AS NX_ROLE_DB,		-- held in CUS_position1 on PROWAT
			  'FALSE'					AS NX_CUSTOMER_PRIMARY,	-- default
			  'FALSE'					AS NX_CUSTOMER_SECONDARY,	-- default
			  '1'						AS NX_CUSTOMER_ADDRESS_ID,	-- default
			  'FALSE'                   AS NX_CUSTOMER_ADDRESS_PRIMARY -- new field added ARG 2020-02-19
		FROM		DatasetProWat.Syn_Customer_ex cus
		CROSS APPLY DatasetProWat.ExtractNameParts(cus.CUS_DMName) AS ext
		LEFT OUTER JOIN
        Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), CUS.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
		WHERE        (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), CUS.CUS_Account)), LEFT(TRIM(CUS.CUS_Company), 100), ISNULL(CUS.CUS_Type, '{NULL}')) > 0)
		AND		    cus.CUS_DMEmail <> ''
			AND     cus.CUS_ACCOUNT NOT IN (SELECT CUSTOMER_ID FROM #RECS WHERE NX_PERSON_ID = 3) -- don't already have a DM type contact

	-- 1) get table with the duplicates in

	SELECT DISTINCT 
		CUSTOMER_ID, FIRST_NAME, LAST_NAME  -- find where we have dupes
		INTO		#DUPES
		FROM		#RECS
		GROUP BY	CUSTOMER_ID, FIRST_NAME, LAST_NAME
		HAVING		COUNT(CUSTOMER_ID) > 1


	-- 2) get table with duplicate detail and the lowest value for the person id - prefix is based on where the record comes from
	-- so 1 = Contact1, 2 = Contact2, 3 = DmName 
	-- we will take the lowest prefix and delete the rest

	SELECT 
		MIN(SUBSTRING(R.NX_PERSON_ID,1,1)) AS MINID, 
		R.CUSTOMER_ID, 
		R.FIRST_NAME, 
		R.LAST_NAME  -- find lowest prefix for each dupe
		INTO		#MINDUPE
		FROM		#DUPES D
		INNER JOIN	#RECS R
		ON			D.CUSTOMER_ID = R.CUSTOMER_ID
		AND			D.FIRST_NAME = R.FIRST_NAME
		AND			D.LAST_NAME = R.LAST_NAME
		GROUP BY	R.CUSTOMER_ID, R.FIRST_NAME, R.LAST_NAME

	-- 3) now use the above table to delete all but the lowest prefixed record

	DELETE	a 
		FROM #RECS a, 
			 #MINDUPE b 
		WHERE	a.CUSTOMER_ID=b.CUSTOMER_ID 
		AND		a.FIRST_NAME= b.FIRST_NAME
		AND		a.LAST_NAME= b.LAST_NAME
		AND		SUBSTRING(a.NX_PERSON_ID,1,1) <> b.MINID -- delete all but the lowest prefix where we have the same name details

	-- 4) where there is only one contact for the customer, they should be marked as default for CUSTOMER_PRIMARY and CUSTOMER_ADDRESS_PRIMARY
	UPDATE		#RECS
			SET			NX_CUSTOMER_PRIMARY = 'TRUE',
						NX_CUSTOMER_ADDRESS_PRIMARY = 'TRUE'
			WHERE		CUSTOMER_ID IN (
											SELECT	CUSTOMER_ID
											FROM	#RECS
											GROUP BY CUSTOMER_ID
											HAVING COUNT(CUSTOMER_ID) = 1
										)

	INSERT into	[Dataset].[Customer_Contact_ex] 
		(  [MIG_SITE_NAME]
		  ,[MIG_COMMENT]
		  ,[MIG_CREATED_DATE]
		  ,[CUSTOMER_ID]
		  ,[FIRST_NAME]
		  ,[MIDDLE_NAME]
		  ,[LAST_NAME]
		  ,[NX_PERSON_ID]
		  ,[NX_TITLE]
		  ,[NX_ROLE_DB]
		  ,[NX_CUSTOMER_PRIMARY]
		  ,[NX_CUSTOMER_SECONDARY]
		  ,[NX_CUSTOMER_ADDRESS_ID]
		  ,[NX_CUSTOMER_ADDRESS_PRIMARY]
		)
		SELECT	
		   [MIG_SITE_NAME]
		  ,[MIG_COMMENT]
		  ,[MIG_CREATED_DATE]
		  ,[CUSTOMER_ID]
		  ,isnull([FIRST_NAME],'')
		  ,isnull([MIDDLE_NAME],'')
		  ,isnull([LAST_NAME],'')
		  ,[NX_PERSON_ID]
		  ,[NX_TITLE]
		  ,[NX_ROLE_DB]
		  ,[NX_CUSTOMER_PRIMARY]
		  ,[NX_CUSTOMER_SECONDARY]
		  ,[NX_CUSTOMER_ADDRESS_ID]
		  ,[NX_CUSTOMER_ADDRESS_PRIMARY]
			FROM	#RECS





	-- 6) need to refer to the results of this in the comm method build. As data is only allowed 
	--    in one direction, we need to store these results somewhere
	--    only need the customer ids and whether we have 1,2 3 or not
	TRUNCATE TABLE		[DatasetProWat].[MAP_Contact_Comm_Method] 

	INSERT INTO			[DatasetProWat].[MAP_Contact_Comm_Method]
	SELECT	DISTINCT	CUSTOMER_ID,
						NX_PERSON_ID
			FROM		#RECS


END


GO

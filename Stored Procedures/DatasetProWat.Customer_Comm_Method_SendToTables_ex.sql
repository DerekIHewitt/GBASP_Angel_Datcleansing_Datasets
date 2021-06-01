SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- EXECUTE Customer_Comm_Method_SendForTransform 

/*=============================================
  Author:      ARG
  Description: Based on original version by James McCambridge 'Customer_Comms_Method_src_sp (06/12/2019)
--
--  1	 ARG	17-02-2020	Amended to pass all records through rather than
--							excluding records due to data cleansing
--  2    ARG	20-02-2020  Added fields to populate name and to use for AR contact, altered ref no to be populated further down the line
--							and added POD Email setting
--  3    ARG	24-02-2020  Changed Desc on Email2 Comm_Methods as these are to be identified later on in the MIG jobs as being the 
--							'AR Customer Contact'
--  4    ARG	28-02-2020  Added extra coding to identify the DM Comm methods and insert one with a CUS_Tel1 number where the CUS_DMTel is blank,
--							removed checking for duplicates, if they exist we want them brought over even if the same
--  5 	 ARG	24/03/2020  Introduced suffix for Email2 name (AR Customer Contact) so we can make sure this is inserted (name/method cannot be duplicated) ARG 24/03/2020
--  6    RJS	01/11/2021  Added specific column list to fix proc error
--  7    RJS	03/02/2021  Procedure failed on NULL so catered for isnull in intial SELECT INTO
--		 RYFE	19-02-2021	Created based on GBASP Data Cleansing Customer_Comm_Method_SendForTransform
=============================================*/
CREATE PROCEDURE [DatasetProWat].[Customer_Comm_Method_SendToTables_ex]
--(
-- @ETLProcessId Int -- used to exclude records based on iteration -- NOT NEEDED NOW ARG 17/02/2020
-- )
AS
BEGIN

SET NOCOUNT ON;
	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	
	 ---------------- Delete records already in the loading table for this site -----------------------------------------------
	 BEGIN TRANSACTION
		DELETE FROM [Dataset].[Customer_Comm_Method_ex] 
			WHERE MIG_SITE_NAME = @MIG_SITENAME
	 COMMIT TRANSACTION
	 ---------------- Add records to the loading table ---------------------------------------------------------


	-- Load the validated In-Scope Customers into a temp table
	SELECT
		  CUS_Account        AS CUS_Account, -- M.IFS_CUSTOMER_ID	AS IFS_CUSTOMER_ID,
		  ISNULL(TRIM([DatasetProWat].[CleanString](CUS_Contact1)),'') AS CUS_Contact1, -- added 20-02-2020
		  ISNULL(TRIM([DatasetProWat].[CleanString](CUS_Contact2)),'') AS CUS_Contact2,  -- added 20-02-2020
		  TRIM([DatasetProWat].[CleanString](CUS_DMName))	AS CUS_DMName,  -- added 20-02-2020
		  TRIM([DatasetProWat].[CleanString](CUS_Email1))	AS CUS_Email1,
		  TRIM([DatasetProWat].[CleanString](CUS_Email2))	AS CUS_Email2,
		  TRIM([DatasetProWat].[CleanString](CUS_Tel))		AS CUS_Tel,
		  TRIM([DatasetProWat].[CleanString](CUS_Tel2))	AS CUS_Tel2,
		  TRIM([DatasetProWat].[CleanString](CUS_Fax))		AS CUS_Fax,
		  TRIM([DatasetProWat].[CleanString](CUS_Fax2))	AS CUS_Fax2,
		  TRIM([DatasetProWat].[CleanString](CUS_DMEmail))	AS CUS_DMEmail,
		  TRIM([DatasetProWat].[CleanString](CUS_DMFax))	AS CUS_DMFax,
		  TRIM([DatasetProWat].[CleanString](CUS_DMPhone))	AS CUS_DMPhone,
		  TRIM([DatasetProWat].[CleanString](CUS_DMMob))	AS CUS_DMMob,
		  ISNULL(TRIM([DatasetProWat].[CleanString](CUS_Ext1)),'')	AS CUS_Ext1,
		  ISNULL(TRIM([DatasetProWat].[CleanString](CUS_Ext2)),'')	AS CUS_Ext2,
		  TRIM(CUS_HHDNMethod) AS CUS_HHDNMethod
		INTO		#tmpCustomers
		FROM		DatasetProWat.Syn_Customer_ex			WITH (NOLOCK)		-- view for In-Scope Customers from Extraction DB
		--INNER JOIN	[NEXUS_Transform].[dbo].[MAP_Customer] M	-- Legacy to IFS Customer map, used inner join as do not want anything which we don't have a valid
		--ON			CUS_Account = M.LEGACY_CUSTOMER_REF         -- customer for and unable to pass null through to the src table for the identity
		--AND			MIG_SITE_NAME = @MIG_SITENAME
		--WHERE		CUS_Account NOT IN				-- exclude records with an error found during data cleansing  -- REMOVED THIS CHECKING 17/02/2020
		--			(SELECT DISTINCT SourceReferences FROM dbo.view_DataDefect_Full 
		--			WHERE TableName = 'Customer_dc' 
		--			AND ID_Iteration = @ETLProcessId)	-- Data Cleansing DB
		--AND         Customer_ex.CUS_Filter_Status >= @FilterMode
		--WHERE         Customer_ex.CUS_Filter_Status >= @FilterMode
		LEFT OUTER JOIN
        Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
		WHERE  (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), CUS_Account)), LEFT(TRIM(CUS_Company), 100), ISNULL(CUS_Type, '{NULL}')) > 0)


		
		-- Load legacy data into the src table
		-- INSERT INTO NEXUS_TRANSFORM.[dbo].Customer_Comm_Method_src
		-- Email1
		-- As we now need to duplicate these for PERSON as well as CUSTOMER, insert into a temp table so we can use it again
			
	SELECT
		  @MIG_SITENAME			AS MIG_SITE_NAME,
		  'CUSTOMER'			AS [PARTY_TYPE_DB],
		  --IFS_CUSTOMER_ID		AS [IDENTITY],
		  CUS_Account			AS [IDENTITY],
		  1						AS [COMM_ID],
		  TRIM(CUS_Contact1)	AS [COMM_NAME],        -- All 1'S linked to Contact1
		  'Email1'				AS [COMM_DESCRIPTION],
		  'E_MAIL'				AS [METHOD_ID_DB],
		  TRIM(CUS_Email1)		AS [COMM_METHOD_VALUE],
		  ''					AS [DEFAULT_PER_METHOD],
		  ''					AS [ADDRESS_ID],
		  ''					AS [ADDRESS_DEFAULT],
		  ''					AS [EXT_NO],
		  CASE 
				WHEN CUS_HHDNMethod = 'E' 
				THEN 'TRUE'					-- Set POD_Email = ‘TRUE’ where CUS_HHDNMethod = ‘E’ and Email1 is not null
				ELSE
				''
		  END                   AS [POD_EMAIL_DB]
		INTO					#CustomerRECS
		FROM
		#tmpCustomers
		WHERE ISNULL(CUS_Email1,'') <> ''



	UNION ALL

	-- Email2
	SELECT
		  @MIG_SITENAME			AS MIG_SITE_NAME,
		  'CUSTOMER'			AS [PARTY_TYPE_DB],
		  --IFS_CUSTOMER_ID		AS [IDENTITY],
		  CUS_Account			AS [IDENTITY],
		  2						AS [COMM_ID],
		  CASE WHEN CUS_Contact2 <> ''				   -- we have something in the name so use it and add suffix
				THEN TRIM(CUS_Contact2) + ' (AR)'	   -- introduced suffix so we can make sure this is inserted (name/method cannot be duplicated) ARG 24/03/2020
				ELSE 'AR'							   -- nothing in name so just put in suffix to use later				
		  END					AS [COMM_NAME],        -- All 2'S linked to Contact2 (special case for GB as this is the AR contact
		  'AR Customer Contact'	AS [COMM_DESCRIPTION], -- change Desc so we can use it later to identify in the MIG job - ARG 24/02/2020
		  'E_MAIL'				AS [METHOD_ID_DB],
		  TRIM(CUS_Email2)		AS [COMM_METHOD_VALUE],
		  ''					AS [DEFAULT_PER_METHOD],
		  ''					AS [ADDRESS_ID],
		  ''					AS [ADDRESS_DEFAULT],
		  ''					AS [EXT_NO],
		  ''					AS [POD_EMAIL_DB]
		FROM		#tmpCustomers
		WHERE ISNULL(CUS_Email2,'') <> ''
		-- AND ISNULL(CUS_Email2,'') <> ISNULL(CUS_Email1,'') -- removed duplication check, if it exists we want it as an AR Customer Contact ARG 28/02/2020


	UNION ALL

	-- Tel
	SELECT
		  @MIG_SITENAME			AS MIG_SITE_NAME,
		  'CUSTOMER'			AS [PARTY_TYPE_DB],
		  --IFS_CUSTOMER_ID		AS [IDENTITY],
		  CUS_Account			AS [IDENTITY],
		  3						AS [COMM_ID],
		  TRIM(CUS_Contact1)	AS [COMM_NAME],        -- All 1'S linked to Contact1
		  'Phone1'				AS [COMM_DESCRIPTION],
		  'PHONE'				AS [METHOD_ID_DB],
		  TRIM(CUS_Tel)			AS [COMM_METHOD_VALUE],
		  ''					AS [DEFAULT_PER_METHOD],
		  ''					AS [ADDRESS_ID],
		  ''					AS [ADDRESS_DEFAULT],
		  CUS_Ext1				AS [EXT_NO],
		  ''					AS [POD_EMAIL_DB]
		FROM	#tmpCustomers
		WHERE ISNULL(CUS_Tel,'') <> ''


	UNION ALL


	-- Tel2
	SELECT
		  @MIG_SITENAME			AS MIG_SITE_NAME,
		  'CUSTOMER'			AS [PARTY_TYPE_DB],
		  --IFS_CUSTOMER_ID		AS [IDENTITY],
		  CUS_Account			AS [IDENTITY],
		  4						AS [COMM_ID],
		  TRIM(CUS_Contact2)	AS [COMM_NAME],        -- All 2'S linked to Contact2
		  'Phone2'				AS [COMM_DESCRIPTION],
		  'PHONE'				AS [METHOD_ID_DB],
		  TRIM(CUS_Tel2)		AS [COMM_METHOD_VALUE],
		  ''					AS [DEFAULT_PER_METHOD],
		  ''					AS [ADDRESS_ID],
		  ''					AS [ADDRESS_DEFAULT],
		  CUS_Ext2				AS [EXT_NO],
		  ''					AS [POD_EMAIL_DB]
		FROM	#tmpCustomers
		WHERE	ISNULL(CUS_Tel2,'') <> ''
			AND ISNULL(CUS_Tel2,'') <> ISNULL(CUS_Tel,'') 
			AND ISNULL(TRIM(CUS_Contact1),'') <> ISNULL(TRIM(CUS_Contact2),'')  -- need to eliminate duplicates if COMM_NAME and METHOD are the same ARG 24/03/2020


	UNION ALL


	-- Fax
	SELECT
		  @MIG_SITENAME			AS MIG_SITE_NAME,
		  'CUSTOMER'			AS [PARTY_TYPE_DB],
		  --IFS_CUSTOMER_ID		AS [IDENTITY],
		  CUS_Account			AS [IDENTITY],
		  5						AS [COMM_ID],
		  TRIM(CUS_Contact1)	AS [COMM_NAME],        -- All 1'S linked to Contact1
		  'Fax'					AS [COMM_DESCRIPTION],
		  'FAX'					AS [METHOD_ID_DB],
		  TRIM(CUS_Fax)			AS [COMM_METHOD_VALUE],
		  ''					AS [DEFAULT_PER_METHOD],
		  ''					AS [ADDRESS_ID],
		  ''					AS [ADDRESS_DEFAULT],
		  ''					AS [EXT_NO],
		  ''					AS [POD_EMAIL_DB]
		FROM	#tmpCustomers
		WHERE ISNULL(CUS_Fax,'') <> ''


	UNION ALL


	-- Fax2
	SELECT
		  @MIG_SITENAME			AS MIG_SITE_NAME,
		  'CUSTOMER'			AS [PARTY_TYPE_DB],
		  --IFS_CUSTOMER_ID		AS [IDENTITY],
		  CUS_Account			AS [IDENTITY],
		  6						AS [COMM_ID],
		  TRIM(CUS_Contact2)	AS [COMM_NAME],        -- All 2'S linked to Contact2
		  'Fax2'				AS [COMM_DESCRIPTION],
		  'FAX'					AS [METHOD_ID_DB],
		  TRIM(CUS_Fax2)		AS [COMM_METHOD_VALUE],
		  ''					AS [DEFAULT_PER_METHOD],
		  ''					AS [ADDRESS_ID],
		  ''					AS [ADDRESS_DEFAULT],
		  ''					AS [EXT_NO],
		  ''					AS [POD_EMAIL_DB]
		FROM	#tmpCustomers
		WHERE	ISNULL(CUS_Fax2,'') <> ''
			--  AND ISNULL(CUS_Fax2,'') <> ISNULL(CUS_Fax,'') -- removed checking for duplicates, if they exist we want them brought over even if the same ARG 28/02/2020
			AND ISNULL(CUS_Fax2,'') <> ISNULL(CUS_Fax,'')
			AND ISNULL(TRIM(CUS_Contact1),'') <> ISNULL(TRIM(CUS_Contact2),'')  -- need to eliminate duplicates if COMM_NAME and METHOD are the same ARG 24/03/2020


	UNION ALL


	-- DMEmail
	SELECT
		  @MIG_SITENAME			AS MIG_SITE_NAME,
		  'CUSTOMER'			AS [PARTY_TYPE_DB],
		  --IFS_CUSTOMER_ID		AS [IDENTITY],
		  CUS_Account			AS [IDENTITY],
		  7						AS [COMM_ID],
		  CASE WHEN TRIM(CUS_DMName) <> ''		   -- we have something in the name so use it and add suffix
				THEN TRIM(CUS_DMName) + ' (DM)'	   -- introduced suffix so we can make sure this is inserted (name/method cannot be duplicated) ARG 24/03/2020
				ELSE 'DM'						   -- nothing in name so just put in suffix to use later				
		  END					AS [COMM_NAME],    -- All DM's linked to DMName
		  'DMEmail'				AS [COMM_DESCRIPTION],
		  'E_MAIL'				AS [METHOD_ID_DB],
		  TRIM(CUS_DMEmail)		AS [COMM_METHOD_VALUE],
		  ''					AS [DEFAULT_PER_METHOD],
		  ''					AS [ADDRESS_ID],
		  ''					AS [ADDRESS_DEFAULT],
		  ''					AS [EXT_NO],
		  ''					AS [POD_EMAIL_DB]
		FROM	#tmpCustomers
		WHERE	ISNULL(CUS_DMEmail,'') <> ''
		--  AND ISNULL(CUS_DMEmail,'') <> ISNULL(CUS_Email1,'') -- removed checking for duplicates, if they exist we want them brought over even if the same ARG 28/02/2020
		--  AND ISNULL(CUS_DMEmail,'') <> ISNULL(CUS_Email2,'') -- removed checking for duplicates, if they exist we want them brought over even if the same ARG 28/02/2020


	UNION ALL


	-- DMPhone    -- this is a special case
	-- if we have a DMEmail, we will have created a DM Contact record and should therefore have comm method 8. As per Safeena, if there is no DMPhone number, use the one from
	-- CUS_Tel1 if it exists
	SELECT
		  @MIG_SITENAME			AS MIG_SITE_NAME,
		  'CUSTOMER'			AS [PARTY_TYPE_DB],
		  --IFS_CUSTOMER_ID		AS [IDENTITY],
		  CUS_Account			AS [IDENTITY],
		  8						AS [COMM_ID],
		  CASE WHEN TRIM(CUS_DMName) <> ''		   -- we have something in the name so use it and add suffix
				THEN TRIM(CUS_DMName) + ' (DM)'	   -- introduced suffix so we can make sure this is inserted (name/method cannot be duplicated) ARG 24/03/2020
				ELSE 'DM'						   -- nothing in name so just put in suffix to use later				
		  END					AS [COMM_NAME],    -- All DM's linked to DMName
		  'DMPhone'				AS [COMM_DESCRIPTION],
		  'PHONE'				AS [METHOD_ID_DB],
		  CASE WHEN ISNULL(CUS_DMPhone,'') <> '' THEN TRIM(CUS_DMPhone)	 -- take DM phone is we have one, otherwise take CUS_Tel
		  ELSE TRIM(CUS_Tel)	
		  END
		  AS [COMM_METHOD_VALUE],
		  ''					AS [DEFAULT_PER_METHOD],
		  ''					AS [ADDRESS_ID],
		  ''					AS [ADDRESS_DEFAULT],
		  ''					AS [EXT_NO],
		  ''					AS [POD_EMAIL_DB]
		FROM	#tmpCustomers
		WHERE	(ISNULL(CUS_DMPhone,'') <> '')
			OR  (ISNULL(CUS_DMEmail,'') <> '' AND ISNULL(CUS_Tel,'') <> '') -- so we know we have a DM Contact record
			--  AND ISNULL(CUS_DMPhone,'') <> ISNULL(CUS_Tel,'') -- removed checking for duplicates, if they exist we want them brought over even if the same ARG 28/02/2020
			--  AND ISNULL(CUS_DMPhone,'') <> ISNULL(CUS_Tel2,'') -- removed checking for duplicates, if they exist we want them brought over even if the same ARG 28/02/2020


	UNION ALL


	-- DMFax
	SELECT
		  @MIG_SITENAME			AS MIG_SITE_NAME,
		  'CUSTOMER'			AS [PARTY_TYPE_DB],
		  --IFS_CUSTOMER_ID		AS [IDENTITY],
		  CUS_Account			AS [IDENTITY],
		  9						AS [COMM_ID],
		  CASE WHEN TRIM(CUS_DMName) <> ''		   -- we have something in the name so use it and add suffix
				THEN TRIM(CUS_DMName) + ' (DM)'	   -- introduced suffix so we can make sure this is inserted (name/method cannot be duplicated) ARG 24/03/2020
				ELSE 'DM'						   -- nothing in name so just put in suffix to use later				
		  END					AS [COMM_NAME],    -- All DM's linked to DMName
		  'DMFax'				AS [COMM_DESCRIPTION],
		  'FAX'					AS [METHOD_ID_DB],
		  TRIM(CUS_DMFax)		AS [COMM_METHOD_VALUE],
		  ''					AS [DEFAULT_PER_METHOD],
		  ''					AS [ADDRESS_ID],
		  ''					AS [ADDRESS_DEFAULT],
		  ''					AS [EXT_NO],
		  ''					AS [POD_EMAIL_DB]
		FROM		#tmpCustomers
		WHERE	ISNULL(CUS_DMFax,'') <> ''
		--  AND ISNULL(CUS_DMFax,'') <> ISNULL(CUS_Fax,'')  -- removed checking for duplicates, if they exist we want them brought over even if the same ARG 28/02/2020
		--  AND ISNULL(CUS_DMFax,'') <> ISNULL(CUS_Fax2,'') -- removed checking for duplicates, if they exist we want them brought over even if the same ARG 28/02/2020




	INSERT INTO [Dataset].Customer_Comm_Method_ex  --RJS 2021-11-01 Added specific column list to fix proc error
		(  [MIG_SITE_NAME]
		  ,[MIG_COMMENT]
		  ,[MIG_CREATED_DATE]
		  ,[IDENTITY]
		  ,[COMM_ID]
		  ,[PARTY_TYPE_DB]
		  ,[COMM_NAME]
		  ,[COMM_DESCRIPTION]
		  ,[METHOD_ID_DB]
		  ,[COMM_METHOD_VALUE]
		  ,[DEFAULT_PER_METHOD]
		  ,[EXT_NO]
		  ,[POD_EMAIL_DB]
		  ,[NX_COMPANY]
		  ,[NX_ADDRESS_ID]
		  ,[NX_ADDRESS_DEFAULT]
		)
			SELECT  
				MIG_SITE_NAME,
				'',
				getdate(),
				[IDENTITY],
				[COMM_ID],
				[PARTY_TYPE_DB],
				[COMM_NAME],
				[COMM_DESCRIPTION],
				[METHOD_ID_DB],
				[COMM_METHOD_VALUE],
				[DEFAULT_PER_METHOD],
				[EXT_NO],
				[POD_EMAIL_DB],
				'',
				[ADDRESS_ID],
				[ADDRESS_DEFAULT]
				FROM #CustomerRECS
				-- now have to duplicate these for person with person id's as comm methods to be linked
				-- to person records where we have a contact

	UPDATE #CustomerRECS SET [PARTY_TYPE_DB] = 'PERSON'

	--SELECT * FROM #CustomerRECS

	-- NEED TO SET IDENTITY 
	INSERT INTO [Dataset].Customer_Comm_Method_ex
		(		[MIG_SITE_NAME]
			   ,[PARTY_TYPE_DB]
			   ,[IDENTITY]
			   ,[COMM_ID]
			   ,[COMM_NAME]
			   ,[COMM_DESCRIPTION]
			   ,[METHOD_ID_DB]
			   ,[COMM_METHOD_VALUE]
			   ,[DEFAULT_PER_METHOD]
			   ,[NX_ADDRESS_ID]
			   ,[NX_ADDRESS_DEFAULT]
			   ,[EXT_NO]
			   ,[POD_EMAIL_DB]
		)
			SELECT	DISTINCT	
				CR.[MIG_SITE_NAME]
			   ,CR.[PARTY_TYPE_DB]
			   ,'1{' + convert( varchar(100), CR.[IDENTITY]) + '}' 
			   ,CR.[COMM_ID]
			   ,CR.[COMM_NAME]
			   ,CR.[COMM_DESCRIPTION]
			   ,CR.[METHOD_ID_DB]
			   ,CR.[COMM_METHOD_VALUE]
			   ,CR.[DEFAULT_PER_METHOD]
			   ,CR.[ADDRESS_ID]
			   ,CR.[ADDRESS_DEFAULT]
			   ,CR.[EXT_NO]
			   ,CR.[POD_EMAIL_DB] 
				FROM		#CustomerRECS CR 
				INNER JOIN	[DatasetProWat].MAP_Contact_Comm_Method CCM  -- only where contact for the number we want
					ON		CR.[IDENTITY] = CCM.CUS_Account  
					AND     CCM.Contact_Type = 1         -- only want those which will link to Contact Type 1
				WHERE		CR.COMM_ID IN (1,3,5)        -- only take those relevant to Contact Type 1

	INSERT INTO [Dataset].Customer_Comm_Method_ex
		(	[MIG_SITE_NAME]
           ,[PARTY_TYPE_DB]
           ,[IDENTITY]
           ,[COMM_ID]
           ,[COMM_NAME]
           ,[COMM_DESCRIPTION]
           ,[METHOD_ID_DB]
           ,[COMM_METHOD_VALUE]
           ,[DEFAULT_PER_METHOD]
           ,[NX_ADDRESS_ID]
           ,[NX_ADDRESS_DEFAULT]
           ,[EXT_NO]
           ,[POD_EMAIL_DB]
		)
		SELECT	DISTINCT	
			CR.[MIG_SITE_NAME]
           ,CR.[PARTY_TYPE_DB]
           ,'2{' + convert( varchar(100),CR.[IDENTITY]) + '}'
           ,CR.[COMM_ID]
           ,CR.[COMM_NAME]
           ,CR.[COMM_DESCRIPTION]
           ,CR.[METHOD_ID_DB]
           ,CR.[COMM_METHOD_VALUE]
           ,CR.[DEFAULT_PER_METHOD]
           ,CR.[ADDRESS_ID]
           ,CR.[ADDRESS_DEFAULT]
           ,CR.[EXT_NO]
           ,CR.[POD_EMAIL_DB]  
			FROM		#CustomerRECS CR 
			INNER JOIN	[DatasetProWat].MAP_Contact_Comm_Method CCM  -- only where contact for the number we want
			ON			CR.[IDENTITY] = CCM.CUS_Account  
			AND         CCM.Contact_Type = 2         -- only want those which will link to Contact Type 2
			WHERE		CR.COMM_ID IN (2,4,6)        -- only take those relevant to Contact Type 2

	INSERT INTO [Dataset].Customer_Comm_Method_ex
		(	[MIG_SITE_NAME]
           ,[PARTY_TYPE_DB]
           ,[IDENTITY]
           ,[COMM_ID]
           ,[COMM_NAME]
           ,[COMM_DESCRIPTION]
           ,[METHOD_ID_DB]
           ,[COMM_METHOD_VALUE]
           ,[DEFAULT_PER_METHOD]
           ,[NX_ADDRESS_ID]
           ,[NX_ADDRESS_DEFAULT]
           ,[EXT_NO]
           ,[POD_EMAIL_DB]
		)
			SELECT	DISTINCT	
				CR.[MIG_SITE_NAME]
			   ,CR.[PARTY_TYPE_DB]
			   ,'3{' + convert( varchar(100),CR.[IDENTITY]) + '}'
			   ,CR.[COMM_ID]
			   ,CR.[COMM_NAME]
			   ,CR.[COMM_DESCRIPTION]
			   ,CR.[METHOD_ID_DB]
			   ,CR.[COMM_METHOD_VALUE]
			   ,CR.[DEFAULT_PER_METHOD]
			   ,CR.[ADDRESS_ID]
			   ,CR.[ADDRESS_DEFAULT]
			   ,CR.[EXT_NO]
			   ,CR.[POD_EMAIL_DB] 
				FROM		#CustomerRECS CR 
				INNER JOIN	[DatasetProWat].MAP_Contact_Comm_Method CCM  -- only where contact for the number we want
				ON			CR.[IDENTITY] = CCM.CUS_Account  
				AND         CCM.Contact_Type = 3         -- only want those which will link to Contact Type 3
				WHERE		CR.COMM_ID IN (7,8,9)        -- only take those relevant to Contact Type 3

END



GO

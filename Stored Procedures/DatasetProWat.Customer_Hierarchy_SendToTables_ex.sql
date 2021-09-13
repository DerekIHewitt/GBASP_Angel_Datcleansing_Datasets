SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      RYFE
  Description: Retrieve Customer Hierarchy details
--			   RYFE 2021-08-06 Created based on GBASP Data Cleansing customer contact send for transform
-- 2           RISM 2021-09-02 Changed the code as was limited by account group. No longer the driver, price book is the driver now
=============================================*/
CREATE PROCEDURE [DatasetProWat].[Customer_Hierarchy_SendToTables_ex]
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	--DECLARE @FilterMode int = Dataset.Filter_Mode('dc','Customer');

	---------------- Delete records already in the loading table for this site -----------------------------------------------
	BEGIN TRANSACTION
		DELETE FROM [Dataset].[Customer_Hierarchy_ex] 
		WHERE MIG_SITE_NAME = @MIG_SITENAME
		COMMIT TRANSACTION
	---------------- Add records to the loading table ---------------------------------------------------------
	
	SELECT 

    c.cus_pricebookac AS Key_Acct,										--LEVEL 1. This is the price book , this is the pure Prowat number to get the information  from legacy													--Account group. Give each account group its own unique Customer record. 
	left(trim(ISNULL(ac.cus_company, '')),35) AS Key_Acct_name,			--Account group. Take this description 
	c.cus_account AS Del_Acct,											--LEVEL 2. No manipulation needed here, just pull the IFS customer ID as is
	left(trim(c.cus_company),35) AS cus_company,						--Delivery account description
	(case when C.cus_acgroup = 0 then '' else cast(C.cus_acgroup as varchar(30)) end) as cus_acgroup,	    --Account group. Is a referenced item at delivery account level
	c.cus_type


	
	INTO #RECS
	FROM DatasetProWat.Syn_Customer_ex C
	LEFT JOIN DatasetProWat.Syn_Customer_ex AC ON c.cus_pricebookac = ac.cus_account					--joined at delivery account level. Intentional
	
	LEFT OUTER JOIN
    Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), C.cus_account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID

	--LEFT OUTER JOIN
    --Dataset.Customer_Filter_Override HR ON 'GBASP' = HR.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), AC.cus_account)) = HR.CUSTOMER_ID

	WHERE
	--c.cus_acgroup NOT LIKE 0  --RS 02/09/21 Doesn't matter whether there is an account group or not. incidental information
	c.cus_pricebookac NOT LIKE 0 --RS 02/09/21 We now only want hierarchy information IF a Prowat account has a valid key account linked to it. This will become level 1
	AND (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), C.cus_account)), LEFT(TRIM(C.CUS_Company), 100), ISNULL(C.CUS_Type, '{NULL}')) > 0)

	--AND (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(HR.isAlwaysIncluded, 0), ISNULL(HR.IsAlwaysExcluded, 0), 
    --                     ISNULL(HR.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), AC.cus_account)), LEFT(TRIM(AC.CUS_Company), 100), ISNULL(AC.CUS_Type, '{NULL}')) > 0)
	ORDER BY c.cus_pricebookac

																		--NOTE. Where the key account LEVEL 1 is zero, indicating that the delivery account uses itself for pricing, the delivery account takes the place of zero and becomes LEVEL 1. 
	
  
	--UPDATE #RECS
	--SET Key_Acct = Del_Acct, Del_Acct = '',Key_Acct_name = cus_company
	--WHERE Key_Acct is null OR Key_Acct = 0;

	INSERT into	[Dataset].[Customer_Hierarchy_ex] 
		(  [MIG_SITE_NAME]
      ,[MIG_COMMENT]
      ,[MIG_CREATED_DATE]
      ,[HIERARCHY_ID]
      ,[HIERARCHY_DESC]
      ,[LEVEL_ID]
      ,[LEVEL_NAME]
      ,[PARENT_CUST_ID]
      ,[CHILD_CUST_ID]
	  ,[ACCOUNT_GROUP]
		)
		SELECT
		DISTINCT 
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						    AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		Key_Acct					AS [HIERARCHY_ID],
		Key_Acct_name				AS [HIERARCHY_DESC],
        '1'							AS [LEVEL_ID],
		'Price Book'				AS [LEVEL_NAME],
		'*'							AS [PARENT_CUST_ID],
		Key_Acct					AS [CHILD_CUST_ID],
		case when cus_acgroup = 0 then ' ' ELSE cus_acgroup		END			AS [ACCOUNT_GROUP]			--Cannot have this because multiple account groups can be there for the same price book

      
		FROM	#RECS cus
		--WHERE   Del_Acct = ''
		WHERE Key_Acct is not null

	/*INSERT into	[Dataset].[Customer_Hierarchy_ex]
		(  [MIG_SITE_NAME]
      ,[MIG_COMMENT]
      ,[MIG_CREATED_DATE]
      ,[HIERARCHY_ID]
      ,[HIERARCHY_DESC]
      ,[LEVEL_ID]
      ,[LEVEL_NAME]
      ,[PARENT_CUST_ID]
      ,[CHILD_CUST_ID]
	  ,[ACCOUNT_GROUP]
		)
		SELECT
		DISTINCT 
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						    AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		Key_Acct					AS [HIERARCHY_ID],
		Key_Acct_name				AS [HIERARCHY_DESC],
        '1'							AS [LEVEL_ID],
		'Price Book'				AS [LEVEL_NAME],
		'*'							AS [PARENT_CUST_ID],
		Key_Acct					AS [CHILD_CUST_ID],
		''							AS [ACCOUNT_GROUP]			--Cannot have this because multiple account groups can be there for the same price book

      
		FROM	#RECS cus
		WHERE   Del_Acct != ''
		AND not exists (select 1 from [Dataset].[Customer_Hierarchy_ex] v where v.[HIERARCHY_ID] = cus.Key_Acct and v.mig_site_name = @MIG_SITENAME )
		*/
		

		INSERT into	[Dataset].[Customer_Hierarchy_ex] 
		(  [MIG_SITE_NAME]
      ,[MIG_COMMENT]
      ,[MIG_CREATED_DATE]
      ,[HIERARCHY_ID]
      ,[HIERARCHY_DESC]
      ,[LEVEL_ID]
      ,[LEVEL_NAME]
      ,[PARENT_CUST_ID]
      ,[CHILD_CUST_ID]
	  ,[ACCOUNT_GROUP]
		)
		SELECT
		DISTINCT 
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						    AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		Key_Acct					AS [HIERARCHY_ID],
		Key_Acct_name				AS [HIERARCHY_DESC],
        '2'							AS [LEVEL_ID],
		'Delivery Account'			AS [LEVEL_NAME],
		Key_Acct					AS [PARENT_CUST_ID],
		Del_Acct					AS [CHILD_CUST_ID],
		case when cus_acgroup = 0 then ' ' ELSE cus_acgroup		END			AS [ACCOUNT_GROUP]				   
		FROM	#RECS cus
		WHERE Del_Acct != ''
		
		 

		


END


GO

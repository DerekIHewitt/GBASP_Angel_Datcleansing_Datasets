SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      RYFE
  Description: Retrieve Customer Hierarchy details
--			   RYFE 2021-08-06 Created based on GBASP Data Cleansing customer contact send for transform
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
	c.cus_acgroup,														--LEVEL 1. Give each account group its own unique Customer record. This needs to be loaded in as a shell account as minimal customer header information to allow it to be chosen as LEVEL 1 root
	ISNULL(ac.acg_company, '') AS Del_Acct_Group,									--LEVEL 1. Take this description and put it on both the hoerarchy header descrition as well as the shell customer
	c.cus_pricebookac AS Key_Acct,										--This is the price book mid layer, this is the pure Prowat number to get the information  from legacy
	concat(c.cus_pricebookac,'-',c.cus_acgroup) AS KeyAC_UID,			--LEVEL 2. this splits the price book each time it sits on a different account group. this is to be able to create separate multiple instances in IFS off the single prowat base as 
																		--you cannot have a unique customer id in IFS across multiple hierarchies. (this is not great in terms of a one to one match in our customer mapping)
	c.cus_account AS Del_Acct,											--LEVEL 3. No manipulation needed here, just pull the IFS customer ID as is
	c.cus_company,
	c.cus_type
	INTO #RECS
	FROM DatasetProWat.Syn_Customer_ex C
	LEFT JOIN DatasetProWat.Syn_ACGroup_ex AC ON c.cus_acgroup = ac.acg_id					--joined at delivery account level. Intentional
	
	LEFT OUTER JOIN
    Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), C.cus_account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID

	WHERE
	c.cus_acgroup NOT LIKE 0
	AND (Dataset.Filter_Customer('GBASP', 'ex', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), C.cus_account)), LEFT(TRIM(C.CUS_Company), 100), ISNULL(C.CUS_Type, '{NULL}')) > 0)
	ORDER BY c.cus_acgroup

																		--NOTE. Where the key account LEVEL 2 is zero, indicating that the delivery account uses itself for pricing, the delivery account takes the place of zero and becomes LEVEL 2. In this instance level 3 is required
																		--and as such the key account split by account group logic is disregarded as this will always return a one to one match and will not straddle hierarchies
	
  
	UPDATE #RECS
	SET Key_Acct = Del_Acct, KeyAC_UID = Del_Acct, Del_Acct = ''
	WHERE Key_Acct = 0;

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
		)
		SELECT
		DISTINCT 
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						    AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		cus_acgroup					AS [HIERARCHY_ID],
		Del_Acct_Group				AS [HIERARCHY_DESC],
        '1'							AS [LEVEL_ID],
		'Account Group'				AS [LEVEL_NAME],
		'*'							AS [PARENT_CUST_ID],
		cus_acgroup					AS [CHILD_CUST_ID]
      
		FROM	#RECS cus

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
		)
		SELECT
		DISTINCT 
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						    AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		cus_acgroup					AS [HIERARCHY_ID],
		Del_Acct_Group				AS [HIERARCHY_DESC],
        '2'							AS [LEVEL_ID],
		'Price Book'				AS [LEVEL_NAME],
		cus_acgroup					AS [PARENT_CUST_ID],
		KeyAC_UID					AS [CHILD_CUST_ID]     
		FROM	#RECS cus

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
		)
		SELECT
		DISTINCT 
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						    AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		cus_acgroup					AS [HIERARCHY_ID],
		Del_Acct_Group				AS [HIERARCHY_DESC],
        '3'							AS [LEVEL_ID],
		'Delivery Account'			AS [LEVEL_NAME],
		KeyAC_UID					AS [PARENT_CUST_ID],
		Del_Acct					AS [CHILD_CUST_ID]     
		FROM	#RECS cus
		WHERE Del_Acct != ''
		
		 

		


END


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      RYFE
  Description: Retrieve Purchase Order details where possible
--			   RYFE 2021-02-19 Created based on GBASP Data Cleansing customer contact send for transform
=============================================*/
CREATE PROCEDURE [DatasetProWat].[Purchase_Order_Details_SendToTables]
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	--DECLARE @FilterMode int = Dataset.Filter_Mode('dc','Customer');

	---------------- Delete records already in the loading table for this site -----------------------------------------------
	BEGIN TRANSACTION
		DELETE FROM [Dataset].[Purchase_Order_Details_dc] 
		WHERE MIG_SITE_NAME = @MIG_SITENAME
		COMMIT TRANSACTION
	---------------- Add records to the loading table ---------------------------------------------------------
	
		
	
  
	

	INSERT into	[Dataset].[Purchase_Order_Details_dc] 
		(  [MIG_SITE_NAME]
      ,[MIG_COMMENT]
      ,[MIG_CREATED_DATE]
      ,[CUSTOMER_ID]
	  ,[PO_SCHEMA]
      ,[CUSTOMER_PO]
	  ,[CUSTOMER_PO_VALUE]
      ,[CUSTOMER_PO_START]
      ,[CUSTOMER_PO_EXPIRY]
      ,[PO_RENT]
	  ,[PO_RENT_VALUE]
      ,[PO_RENT_START]
      ,[PO_RENT_EXPIRY]
      ,[PO_SANI]
	  ,[PO_SANI_VALUE]
      ,[PO_SANI_START]
      ,[PO_SANI_EXPIRY]
	  ,[PO_EL]
	  ,[PO_EL_VALUE]
      ,[PO_EL_START]     
      ,[PO_EL_EXPIRY]
		)
		SELECT
		@MIG_SITENAME				AS MIG_SITE_NAME,
		''						    AS [MIG_COMMENT],
		GETDATE()					AS [MIG_CREATED_DATE],
		CUS.CUS_ACCOUNT			    AS CUSTOMER_ID,
		'CUSTOMER_LEVEL'			AS PO_SCHEMA,
		trim(isnull(CUS_CUSTORDER,''))				AS [CUSTOMER_PO],
		9999999						AS [CUSTOMER_PO_VALUE],
		'2001-01-01'				AS [CUSTOMER_PO_START],
		replace(DatasetProWat.CONVERTFROMCLARION(CUS_PODATE),'1800-12-28','') AS [CUSTOMER_PO_EXPIRY],
		trim(isnull(CUS_PORENT,''))					AS [PO_RENT],
		9999999						AS [PO_RENT_VALUE],
		'2001-01-01'				AS [PO_RENT_START],
		replace(DatasetProWat.CONVERTFROMCLARION(CUS_PORENTDATE),'1800-12-28','') AS [PO_RENT_EXPIRY],
		trim(isnull(CUS_POSANI,''))					AS [PO_SANI],
		9999999						AS [PO_SANI_VALUE],
		'2001-01-01'				AS [PO_SANI_START],
		replace(DatasetProWat.CONVERTFROMCLARION(CUS_POSANIDATE),'1800-12-28','') AS [PO_SANI_EXPIRY],
		trim(isnull(CUS_POEL,''))					AS [PO_EL],
		9999999						AS [PO_EL_VALUE],
		'2001-01-01'				AS [PO_EL_START],
		replace(DatasetProWat.CONVERTFROMCLARION(CUS_POELDATE),'1800-12-28','') AS [PO_EL_EXPIRY]

		FROM	DatasetProWat.Syn_Customer_dc cus
		
		LEFT OUTER JOIN
        Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), CUS.CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
		WHERE (Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), CUS.CUS_Account)), LEFT(TRIM(CUS.CUS_Company), 100), ISNULL(CUS.CUS_Type, '{NULL}')) > 0)

		AND isnull(CUS_CUSTORDER,'') != '' OR isnull(CUS_PORENT,'') != '' OR isnull(CUS_POSANI,'') != '' OR isnull(CUS_POEL,'') != ''
		AND CUS_TYPE NOT LIKE 'CANC%' AND CUS_TYPE NOT LIKE 'STOCK'


END


GO

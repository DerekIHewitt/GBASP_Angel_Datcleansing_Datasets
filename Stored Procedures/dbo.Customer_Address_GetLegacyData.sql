SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*=============================================
  Author:      James McCambridge
  Description: Load Customer Address into src table

  History:
  Ver  By   Date        Comments
  V1   JM	06/12/2019  Created.
  V2   DIH	03/02/2020	Converted to follow the agreed framework
  V3   DIH  03/02/2020	Converted in line convertions to functions
       ARG  05/02/2020  Amended call to Filter_Mode function
  V5   DIH	06/02/2020	Added use of @FilterMode
  --   DIH	21/02/2020	Code review - no issues found.
  V6	DIH	25/02/2020	Customer special instructions are strored in five fields (CUS_Instruct1/2/3/4/5).
  V7	DIH	25/02/2020	IFSDEF0012924 - Address is default visit address.
  V8   ARG  25/03/2020  IFSDEF0012927 - Set default addresses to TRUE for DEF_ADDRESS_HOME,	DEF_ADDRESS_PRIMARY, DEF_ADDRESS_SECONDARY
  V9   RJS  20/01/2021  ADDED PRINT ERRORMESSAGE IN THE CATCH. ADDED ISNULL TO THE FOLLOWING: COUNTY, SPECIAL_INS, ADDRESS2, CITY
  =============================================*/

CREATE PROCEDURE [dbo].[Customer_Address_GetLegacyData]
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	DECLARE @AlsoStrip varchar(10) = '''';
	DECLARE @FilterMode int;

	SET @FilterMode = [GBASP_Angel_DataCleansing].dbo.Filter_Mode('ex','Customer');

	 ---------------- Delete reords already in the loading table -----------------------------------------------
	 BEGIN TRANSACTION
		DELETE FROM [Dataset].[Customer_Address_dc]
			WHERE MIG_SITE_NAME = @MIG_SITENAME
	 COMMIT TRANSACTION


	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO [Dataset].[Customer_Address_dc]
				([MIG_SITE_NAME]
				,[CUSTOMER_ID]
				,[NX_ADDRESS_ID]
				,[NAME]
				,[ADDRESS1]
				,[ADDRESS2]
				,[ZIP_CODE]
				,[CITY]
				,[COUNTY]
				,[NX_DELIVERY_TERMS]
				,[NX_SHIP_VIA_CODE]
				,[NX_IN_CITY]
				,[NX_TAX_WITHHOLDING_DB]
				,[NX_TAX_ROUNDING_METHOD_DB]
				,[NX_TAX_ROUNDING_LEVEL_DB]
				,[NX_TAX_EXEMPT_DB]
				,[NX_INTRASTAT_EXEMPT_DB]
				,[VAT_NO]
				,[NX_OPENING_AM]
				,[NX_CLOSING_AM]
				,[NX_OPENING_PM]
				,[NX_CLOSING_PM]
				,[NX_MON_AM]
				,[NX_MON_PM]
				,[NX_TUE_AM]
				,[NX_TUE_PM]
				,[NX_WED_AM]
				,[NX_WED_PM]
				,[NX_THU_AM]
				,[NX_THU_PM]
				,[NX_FRI_AM]
				,[NX_FRI_PM]
				,[NX_SAT_AM]
				,[NX_SAT_PM]
				,[NX_SUN_AM]
				,[NX_SUN_PM]
				,[STATE]
				,[SPECIAL_INS]
				,[WORK_ORDER_NOTES]
				,[NX_DEF_ADDRESS_DELIVERY]
				,[NX_DEF_ADDRESS_INVOICE]
				,[NX_DEF_ADDRESS_PAY]
				,[NX_DEF_ADDRESS_HOME]
				,[NX_DEF_ADDRESS_PRIMARY]
				,[NX_DEF_ADDRESS_SECONDARY]
				,[NX_DEF_ADDRESS_VISIT])
				SELECT
					  @MIG_SITENAME												AS MIG_SITE_NAME,	
					  TRIM(CONVERT(varchar(20), CUS_Account))					AS CUSTOMER_ID,
					  ''														AS ADDRESS_ID,
					  [GBASP_Angel_DataCleansing].dbo.[ConvertMaxLenCleanString](CUS_Company,'', 100)		AS [NAME],
					  [GBASP_Angel_DataCleansing].dbo.[ConvertMaxLenCleanString](CUS_Addr1, @AlsoStrip, 35)	AS ADDRESS1,
					  ISNULL([GBASP_Angel_DataCleansing].dbo.[ConvertMaxLenCleanString](CUS_Addr2, @AlsoStrip, 35),'')	AS ADDRESS2,
					  [GBASP_Angel_DataCleansing].dbo.[ConvertMaxLenCleanString](CUS_PCode, @AlsoStrip, 35)	AS ZIP_CODE,
					  ISNULL([GBASP_Angel_DataCleansing].dbo.[ConvertMaxLenCleanString](CUS_Addr3, @AlsoStrip, 35),'{NULL}') AS CITY,
					  ISNULL([GBASP_Angel_DataCleansing].dbo.[ConvertMaxLenCleanString](CUS_County,@AlsoStrip, 35),'')	AS COUNTY,
					  ''														AS DELIVERY_TERMS,
					  ''														AS SHIP_VIA_CODE,
					  ''														AS IN_CITY,
					  ''														AS TAX_WITHHOLDING_DB,
					  ''														AS TAX_ROUNDING_METHOD,
					  ''														AS TAX_ROUNDING_LEVEL,
					  ''														AS TAX_EXEMPT_DB,
					  ''														AS INTRASTAT_EXEMPT_DB,
					  ''														AS VAT_NO,		
					  [GBASP_Angel_DataCleansing].dbo.ConvertProwatTime(CUS_OpenAM)							AS OPENING_AM,
					  [GBASP_Angel_DataCleansing].dbo.ConvertProwatTime(CUS_CloseAM)						AS CLOSING_AM,
					  [GBASP_Angel_DataCleansing].dbo.ConvertProwatTime(CUS_OpenPM)							AS OPENING_PM,
					  [GBASP_Angel_DataCleansing].dbo.ConvertProwatTime(CUS_ClosePM)						AS CLOSING_PM,
					  CUS_OpenAMDay1											AS MON_AM,
					  CUS_OpenPMDay1											AS MON_PM,
					  CUS_OpenAMDay2											AS TUE_AM,				
					  CUS_OpenPMDay2											AS TUE_PM,				
					  CUS_OpenAMDay3											AS WED_AM,				
					  CUS_OpenPMDay3											AS WED_PM,				
					  CUS_OpenAMDay4											AS THU_AM,				
					  CUS_OpenPMDay4											AS THU_PM,				
					  CUS_OpenAMDay5											AS FRI_AM,				
					  CUS_OpenPMDay5											AS FRI_PM,				
					  CUS_OpenAMDay6											AS SAT_AM,				
					  CUS_OpenPMDay6											AS SAT_PM,				
					  CUS_OpenAMDay7											AS SUN_AM,				
					  CUS_OpenPMDay7											AS SUN_PM,
					  ''														AS [STATE],
					  ----------------------------------------------------------
					  ISNULL([GBASP_Angel_DataCleansing].dbo.[ConvertMaxLenCleanString](TRIM(CUS_Instruct1) +
							  CASE 
								WHEN trim(isnull(CUS_Instruct2,'')) <> '' 
								THEN ' ' + trim(CUS_Instruct2) 
								ELSE '' 
							  END +
							  CASE 
								WHEN trim(isnull(CUS_Instruct3,'')) <> '' 
								THEN ' ' + trim(CUS_Instruct3) 
								ELSE '' 
							  END +
							  CASE 
								WHEN trim(isnull(CUS_Instruct4,'')) <> '' 
								THEN ' ' + trim(CUS_Instruct4) 
								ELSE '' 
							  END +
							  CASE 
								WHEN trim(isnull(CUS_Instruct5,'')) <> '' 
								THEN ' ' + trim(CUS_Instruct5) 
								ELSE '' 
							  END
						  , @AlsoStrip, 1000),'')									AS SPECIAL_INS,
					  ----------------------------------------------------------
					  ''														AS WORK_ORDER_NOTES,
					  'TRUE'													AS DEF_ADDRESS_DELIVERY,
					  'TRUE'													AS DEF_ADDRESS_INVOICE,
					  'TRUE'													AS DEF_ADDRESS_PAY,
					  ''														AS DEF_ADDRESS_HOME,		-- set to TRUE ARG 25/03/2020
					  ''														AS DEF_ADDRESS_PRIMARY,		-- set to TRUE ARG 25/03/2020
					  ''														AS DEF_ADDRESS_SECONDARY,	-- set to TRUE ARG 25/03/2020
					  'TRUE'													AS DEF_ADDRESS_VISIT
				FROM	[GBASP_Angel_DataCleansing].dbo.Customer_ex			WITH (NOLOCK)	
				WHERE	CUS_Filter_Status >= @FilterMode;
		END TRY

		BEGIN CATCH
		PRINT ERROR_MESSAGE()
			ROLLBACK TRANSACTION
			Return -1
		END CATCH	

	COMMIT TRANSACTION
END

GO

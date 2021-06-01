SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*=============================================
  Author:      James McCambridge
  Description: Load Customer Header details into src table.
               IFS objects: Customer Header, General, Invoice, Payment, Credit Info, Order and CRM Info

  History:
  Ver	By		Date        Comments
  V1	JM		06/12/2019  Created.
  ?V2?	DIH		20/01/2020	Started to conver to the standard .....
		ARG		05/02/2020  Amended call to Filter_Mode function
  V4	DIH		06/02/2020	Added use of @FilterMode.
  V5	DIH		11/02/2020	Bring [CUST_GRP] in line with new template definition.
  V6	DIH		12/02/2020	Do not pass through the 'Invoice to' data as the uk are not linking accounts.
  V7	DIH		24/02/2020	Pass CUS_SectorID as the CRM_Account_Type (James was passing TeleSales)
  V8    ARG     06/04/2020  Added Association_No field as must now be in Customer_src table in NEXUS_TRANSFORM (not present in Angel data)
  V9    ARG     06/04/2020  Removed DEFAULT_DEPOT as does not exist in MIG job
  V10   RJS     20/01/2021  remmed out [ADMIN_LIQUIDATION_DB][NATIONAL_ACCOUNT_DB][LEGAL_ENTITY_DB][CONSOLIDATE_CONTRACTS_DB] 
							also added ISNULL to CREDIT_LIMIT, CRM_ACCOUNT_TYPE,BLANKET_PURCHASE_ORDER, PAY_ADDR_ACCOUNT, PAY_ADDR_SORT_CODE, 
							PAY_ADDR_ACC_NAME, MAIN_REP, BOOK_IN_DB,PURCHASE_ORDER_REQ_DB, ACQUIRED_FROM_COMP,OLD_CUST_REF2
  =============================================*/

CREATE PROCEDURE [dbo].[Customer_Header_GetLegacyData]
AS
	--Declare variables
	SET NOCOUNT ON
	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	DECLARE @FilterMode int;

	SET @FilterMode = [GBASP_Angel_DataCleansing].dbo.Filter_Mode('ex','Customer') 

	 ---------------- Delete reords already in the loading table -----------------------------------------------
	 BEGIN TRANSACTION
		DELETE FROM [Dataset].[Customer_Header_dc] 
			WHERE MIG_SITE_NAME = @MIG_SITENAME
	 COMMIT TRANSACTION


	 BEGIN TRY
		BEGIN TRANSACTION

		INSERT INTO [Dataset].[Customer_Header_dc]
			   ([MIG_SITE_NAME]
			   ,[CUSTOMER_ID]
			   ,[NAME]
			   ,[NX_GROUP_ID]
			   ,[PAY_TERM_ID]
			   ,[NX_TAX_CODE]
			   ,[NX_CUST_GRP]
			   ,[CREDIT_LIMIT]
			   ,[NX_MARKET_CODE]
			   ,[INVOICE_CUSTOMER]
			   ,[NX_ORDER_TYPE]
			   ,[NX_IDENTITY_TYPE_DB]
			   ,[NX_CYCLE_PERIOD]
			   ,[INVOICE_SORT_DB]
			   ,[NX_CATEGORY_DB]
			   ,[NX_CREDIT_CONTROL_GROUP_ID]
			   ,[EMAIL_ORDER_CONF_DB]
			   ,[EMAIL_INVOICE_DB]
			   ,[NX_CREDIT_BLOCK]
			   ,[NX_PAY_OUTPUT_MEDIA_DB]
			   ,[NX_DEFAULT_PAYMENT_METHOD]
			   ,[CRM_ACCOUNT_TYPE]
			   ,[NX_ACTIVE_TRIAL_DB]
			   ,[NX_CCA_FLAG_DB]
			   ,[NX_BLANKET_PURCHASE_ORDER]
			   ,[NX_PO_EXPIRY_DATE]
			   ,[NX_PO_EXPIRY_VALUE]
			   ,[NX_PO_VALUE_USED]
			   ,[PAYMENT_METHOD]
			   ,[PAY_ADDR_DESCRIPTION]
			   ,[PAY_ADDR_ACCOUNT]
			   ,[PAY_ADDR_SORT_CODE]
			   ,[PAY_ADDR_ACC_NAME]
			   ,[PAY_ADDR_BUILD_SOC_REF]
			   ,[PAY_ADDR_TRANS_CODE]
			   ,[PAY_ADDR_OUR_REF]
			   ,[CREDIT_ANALYST]
			   ,[NX_MESSAGE_GROUP]
			   ,[NX_ALLOWED_OVERDUE_AMOUNT]
			   ,[NX_ALLOWED_OVERDUE_DAYS]
			   ,[NX_CREDIT_RELATIONSHIP_EXIST]
			   ,[NX_CREDIT_RELATIONSHIP_TYPE_DB]
			   ,[NX_PARENT_COMPANY]
			   ,[NX_PARENT_CUSTOMER_ID]
			   ,[NX_MAIN_REP]
			   --,[CONSOLIDATE_CONTRACTS_DB]      RJS 20/01/2021 REMMING OUT NOT REMOVING IN CASE COMES BACK IN SCOPE
			   ,[NX_CUST_ORDER_INVOICING_DB]
			   ,[NX_CUST_ORDER_INV_TYPE_DB]
			   ,[NX_CONSOLIDATION_DAY_DB]
			   ,[NX_SAGE_CODE]
			   ,[NX_OLD_CUST_REF1]
			   ,[NX_OLD_CUST_REF2]
			   ,[ACQUIRED_FROM_COMP]
			   ,[NX_BOOK_IN_DB]
			   ,[NX_NO_LIMIT_DB]
			   ,[NX_ON_SITE_RA_DB]
			   ,[NX_PURCHASE_ORDER_REQ_DB]
			   ,[ASSOCIATION_NO]               -- added 06/04/2020
			  -- ,[DEFAULT_DEPOT]              -- removed 06/04/2020
			   ,[NX_SHORT_TERM_DB]
			  -- ,[ADMIN_LIQUIDATION_DB]       RJS 20/01/2021 REMMING OUT NOT REMOVING IN CASE COMES BACK IN SCOPE
			  -- ,[NATIONAL_ACCOUNT_DB]        RJS 20/01/2021 REMMING OUT NOT REMOVING IN CASE COMES BACK IN SCOPE
			   ,[NX_COST_CODE]
			  -- ,[LEGAL_ENTITY_DB]           RJS 20/01/2021 REMMING OUT NOT REMOVING IN CASE COMES BACK IN SCOPE
			  )
				SELECT
					@MIG_SITENAME					AS MIG_SITE_NAME, 
					CUS_Account						AS CUSTOMER_ID,
					[GBASP_Angel_DataCleansing].dbo.ConvertSpecialChars(LEFT(TRIM(CUS_Company),100))
													AS [NAME],
					'0'								AS GROUP_ID,		--'0' is external
					CUS_PayTerms					AS PAY_TERM_ID,
					CUS_Charge_VAT					AS TAX_CODE,	
					'9999'							AS CUST_GRP,		-- 9999 = External
					ISNULL(TRIM(CONVERT(nvarchar(10), CUS_Credit_Limit)),0)  --RJS 20/01/2021 ADDED ISNULL
													AS CREDIT_LIMIT,	-- Target field is NVARCHAR(10)
					'0'								AS MARKET_CODE,		-- [CUS_Industry] apears to have Industry sector but cannot find linking table - 0 = Other
					-------------------------------
					/* (UK are not linking accounts but using the 'invoice' fields on the contracts (Commented out 12/02/2020)
					CASE
						WHEN	CUS_Acct_to_Inv <= 0					-- Legacy field is an int.
						THEN	''
						ELSE	TRIM(CONVERT(NVARCHAR(20), CUS_Acct_To_Inv))
					END	*/
					''								AS INVOICE_CUSTOMER,	
					--------------------------------
					'DIR'							AS ORDER_TYPE,		-- DIR = Direct Sales Order	
					''								AS IDENTITY_TYPE_DB,
					NULL							AS CYCLE_PERIOD,
					''								AS INVOICE_SORT_DB,
					''								AS CATEGORY_DB,
					''								AS CREDIT_CONTROL_GROUP_ID,
					'TRUE'							AS EMAIL_ORDER_CONF_DB,
					'TRUE'							AS EMAIL_INVOICE_DB,
					'FALSE'							AS CREDIT_BLOCK,
					'1'								AS PAY_OUTPUT_MEDIA_DB,			--
					'FALSE'							AS DEFAULT_PAYMENT_METHOD,
					isnull(convert(varchar(10), [CUS_SectorID]),'{NULL}')
													AS CRM_ACCOUNT_TYPE,
					'NO'							AS ACTIVE_TRIAL_DB,
					''								AS CCA_FLAG_DB,
					ISNULL(LEFT(TRIM(CUS_CustOrder),99),'')	AS BLANKET_PURCHASE_ORDER,
					----------------------------
					CASE
						WHEN ISNULL(CUS_PODate,0) = 0 
						THEN ''
						ELSE CONVERT(nvarchar(21), [GBASP_Angel_DataCleansing].dbo.ConvertProwatDate(CUS_PODate, NULL), 126)		-- 126 is ISO8601
					END								AS PO_EXPIRY_DATE,
					----------------------------
					0								AS PO_EXPIRY_VALUE,
					0								AS PO_VALUE_USED,
					CUS_PayType 					AS PAYMENT_METHOD,
					''								AS PAY_ADDR_DESCRIPTION,
					ISNULL(CONVERT(varchar(50), CUS_ACNumber),'')	
													AS PAY_ADDR_ACCOUNT,
					ISNULL(CONVERT(varchar(100), CUS_ACSortCode),'')	
													AS PAY_ADDR_SORT_CODE,
					ISNULL(TRIM(CUS_ACName),'')		AS PAY_ADDR_ACC_NAME,
					''								AS PAY_ADDR_BUILD_SOC_REF,
					''								AS PAY_ADDR_TRANS_CODE,
					''								AS PAY_ADDR_OUR_REF,
					'CA'							AS CREDIT_ANALYST,
					---------------------------
					CASE
						WHEN CUS_SectorID = 1 THEN 'NATIONAL'
						ELSE 'ALL'
					END								AS MESSAGE_GROUP,
					----------------------------
					0								AS ALLOWED_OVERDUE_AMOUNT,
					0								AS ALLOWED_OVERDUE_DAYS,
					''								AS CREDIT_RELATIONSHIP_EXIST,
					''								AS CREDIT_RELATIONSHIP_TYPE_DB,
					''								AS PARENT_COMPANY,
					''								AS PARENT_CUSTOMER_ID,
					ISNULL(trim(convert(nvarchar(20), CUS_RepNum)),'')
													AS MAIN_REP,
					--''								AS CONSOLIDATE_CONTRACTS_DB,   RJS 20/01/2021 REMMING OUT NOT REMOVING IN CASE COMES BACK IN SCOPE
					''								AS CUST_ORDER_INVOICING_DB,
					''								AS CUST_ORDER_INV_TYPE_DB,
					''								AS CONSOLIDATION_DAY_DB,
					TRIM(CUS_SageCode)				AS SAGE_CODE,
					TRIM(CONVERT(varchar(100), CUS_Account))
													AS OLD_CUST_REF1,
					ISNULL(TRIM(CUS_ImportAC),'')	AS OLD_CUST_REF2,
					ISNULL(TRIM(CONVERT(nvarchar(100),CUS_AcqFrom)),'')
													AS ACQUIRED_FROM_COMP,
					ISNULL(TRIM(CONVERT(nvarchar(20), CUS_BookIn)),0)
													AS BOOK_IN_DB,
					''								AS NO_LIMIT_DB,
					''								AS ON_SITE_RA_DB,
					ISNULL(trim(convert(nvarchar(20), CUS_POReq)),0)
													AS PURCHASE_ORDER_REQ_DB,
					''								AS ASSOCIATION_NO,
				--	''								AS DEFAULT_DEPOT,
					''								AS SHORT_TERM_DB,
				--	''								AS ADMIN_LIQUIDATION_DB,            RJS 20/01/2021 REMMING OUT NOT REMOVING IN CASE COMES BACK IN SCOPE
				--	''								AS NATIONAL_ACCOUNT_DB,             RJS 20/01/2021 REMMING OUT NOT REMOVING IN CASE COMES BACK IN SCOPE
					''								AS COST_CODE
				--	''								AS LEGAL_ENTITY_DB                  RJS 20/01/2021 REMMING OUT NOT REMOVING IN CASE COMES BACK IN SCOPE
				FROM
						[GBASP_Angel_DataCleansing].dbo.Customer_ex			WITH (NOLOCK)	-- view for In-Scope Customers from Extraction DB (Derek)
				WHERE	CUS_Filter_Status >= @FilterMode;


		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
	PRINT ERROR_MESSAGE()
		ROLLBACK TRANSACTION
	END CATCH	




GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		RYFE
-- Create date: 2021-04-16
-- Description:	Validate Service contract related prowat data
--
-- Ver	Who		When		What
-- 1	Ryfe	25/05/2021	created
-- =============================================
CREATE PROCEDURE [DatasetCustom].[Validate_Additional_Prowat_Data]
	@MIG_SITE_NAME varchar(5),
	@Iteration int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE	@return_value int

	-- Example of constant values used as a variable to 
	-- avoid having MAGIC numbers in the rest of the code
	DECLARE @MaxNameLength int = 100;

	-- use 'Find and Replace' to change use through the sproc
	DECLARE @Rule_CR1030_DefaultPO_Expiry	int = -1030;			
	DECLARE @Rule_CR1031_RentPO_Expiry      int = -1031;
	DECLARE @Rule_CR1032_SaniPO_Expiry	int = -1032;			
	DECLARE @Rule_CR1033_ELPO_Expiry      int = -1033;
	DECLARE @Rule_CR1034_TrialCustomer      int = -1034;
	

	

	-- All the rule numbers need to be in the 
	-- following string seperated by ; characters
	DECLARE @Rules varchar(1000) = ';-1030;-1031;;-1032;-1033;-1034;';

	EXEC	@return_value = [DatasetSys].[sysCheck_AnyRulesActive]
			@MIG_SITE_NAME = N' ',
			@Rules = @Rules;

	IF (@return_value = 0) goto Exit_Now

	EXEC @return_value = [DatasetSys].[sysUpdate_RulesToCurrentDefectVersion] @Rules, @Iteration;
	EXEC @return_value = [DatasetSys].[sysUpdate_RulesRecordLastRunTime] @Rules, 1, 0, @Iteration;




	-- ===============================================================================
	

	

	IF (OBJECT_ID('tempdb..#Result1') IS NOT NULL)
		DROP TABLE #Result1;		

		SELECT
			TBL2.MIG_SITE_NAME,
			TBL2.CUSTOMER_ID,
			
			TBL2.CUS_Type,

			TBL2.PO_DATE,
			TBL2.PO_RENTDATE,
			TBL2.PO_SANIDATE,
			TBL2.PO_ELDATE,

			TBL2.DEFECT_CR1030_DefaultPO_Expiry,
			TBL2.DEFECT_CR1031_RentPO_Expiry,
			TBL2.DEFECT_CR1032_SaniPO_Expiry,
			TBL2.DEFECT_CR1033_ELPO_Expiry,
			TBL2.DEFECT_CR1034_TrialCustomer,
			
			0 AS [SubSet]
	INTO #Result1
	FROM
	(
		SELECT 
			@MIG_SITE_NAME AS MIG_SITE_NAME
			,CUS_Account AS CUSTOMER_ID
			,CUS_TYPE
			,Dataset.ConvertProwatDate(CUS_PODate, NULL) AS PO_DATE
			,Dataset.ConvertProwatDate(CUS_PORentDate, NULL) AS PO_RENTDATE
			,Dataset.ConvertProwatDate(CUS_POSaniDate, NULL) AS PO_SANIDATE
			,Dataset.ConvertProwatDate(CUS_POELDate, NULL) AS PO_ELDATE
			,CASE 
             WHEN ISNULL(trim(CONVERT(nvarchar(20), CUS_POReq)), 0) = 1 AND  ISNULL(LEFT(TRIM(CUS_CustOrder), 99), '') != '' 
			      AND isnull(Dataset.ConvertProwatDate(CUS_PODate, NULL),getDate()+1) < getDate()
				THEN  CASE WHEN CUS_Acct_To_Inv = 0 
					 THEN CASE WHEN Cus_Balance <= 0 THEN 
								1 ELSE 0 END 
				ELSE CASE WHEN
					(SELECT        Cus_Balance
					FROM            DatasetProWat.Syn_Customer_dc v
					WHERE        v.CUS_Account = dc.CUS_Acct_To_Inv) <= 0 
					THEN 1 ELSE 0 END 
				END
			ELSE 0
			END AS DEFECT_CR1030_DefaultPO_Expiry

			,CASE 
             WHEN ISNULL(trim(CONVERT(nvarchar(20), CUS_POReq)), 0) = 1 AND  ISNULL(LEFT(TRIM(CUS_PORent), 99), '') != '' 
			      AND isnull(Dataset.ConvertProwatDate(CUS_PORentDate, NULL),getDate()+1) < getDate()
				THEN  CASE WHEN CUS_Acct_To_Inv = 0 
					 THEN CASE WHEN Cus_Balance <= 0 THEN 
								1 ELSE 0 END 
				ELSE CASE WHEN
					(SELECT        Cus_Balance
					FROM            DatasetProWat.Syn_Customer_dc v
					WHERE        v.CUS_Account = dc.CUS_Acct_To_Inv) <= 0 
					THEN 1 ELSE 0 END 
				END
			ELSE 0
			END AS DEFECT_CR1031_RentPO_Expiry

			,CASE 
             WHEN ISNULL(trim(CONVERT(nvarchar(20), CUS_POReq)), 0) = 1 AND  ISNULL(LEFT(TRIM(CUS_POSani), 99), '') != '' 
			      AND isnull(Dataset.ConvertProwatDate(CUS_POSaniDate, NULL),getDate()+1) < getDate()
				THEN  CASE WHEN CUS_Acct_To_Inv = 0 
					 THEN CASE WHEN Cus_Balance <= 0 THEN 
								1 ELSE 0 END 
				ELSE CASE WHEN
					(SELECT        Cus_Balance
					FROM            DatasetProWat.Syn_Customer_dc v
					WHERE        v.CUS_Account = dc.CUS_Acct_To_Inv) <= 0 
					THEN 1 ELSE 0 END 
				END
			ELSE 0
			END AS DEFECT_CR1032_SaniPO_Expiry

			,CASE 
             WHEN ISNULL(trim(CONVERT(nvarchar(20), CUS_POReq)), 0) = 1 AND  ISNULL(LEFT(TRIM(CUS_POEL), 99), '') != '' 
			      AND isnull(Dataset.ConvertProwatDate(CUS_POELDate, NULL),getDate()+1) < getDate()
				THEN  CASE WHEN CUS_Acct_To_Inv = 0 
					 THEN CASE WHEN Cus_Balance <= 0 THEN 
								1 ELSE 0 END 
				ELSE CASE WHEN
					(SELECT        Cus_Balance
					FROM            DatasetProWat.Syn_Customer_dc v
					WHERE        v.CUS_Account = dc.CUS_Acct_To_Inv) <= 0 
					THEN 1 ELSE 0 END 
				END
			ELSE 0
			END AS DEFECT_CR1033_ELPO_Expiry

			,CASE WHEN CUS_Type = 'TRIAL'
				THEN 1
				ELSE 0
				END						AS DEFECT_CR1034_TrialCustomer

	FROM
	DatasetProWat.Syn_Customer_dc DC 
	LEFT OUTER JOIN
                         Dataset.Customer_Filter_Override ON 'GBASP' = Dataset.Customer_Filter_Override.MIG_SITE_NAME AND TRIM(CONVERT(varchar(100), CUS_Account)) = Dataset.Customer_Filter_Override.CUSTOMER_ID
           WHERE        (Dataset.Filter_Customer('GBASP', 'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), TRIM(CONVERT(varchar(100), CUS_Account)), LEFT(TRIM(CUS_Company), 100), ISNULL(CUS_Type, '{NULL}')) > 0)
	 
			
)TBL2

			WHERE 
			( TBL2.DEFECT_CR1030_DefaultPO_Expiry <> 0
			OR TBL2.DEFECT_CR1031_RentPO_Expiry <> 0 
			OR TBL2.DEFECT_CR1032_SaniPO_Expiry <> 0
			OR TBL2.DEFECT_CR1033_ELPO_Expiry <> 0 
			OR TBL2.DEFECT_CR1034_TrialCustomer <> 0 
			)



			---------------------------------------------------------------------------------------------
			-- Process results
			---------------------------------------------------------------------------------------------

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1030_DefaultPO_Expiry ) = 1)
		BEGIN
			PRINT 'New Defect {CR1028_Pedal_No_Match}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1030_DefaultPO_Expiry,convert(varchar,CUSTOMER_ID),convert(varchar,PO_DATE), [SubSet]
					FROM #Result1	WHERE DEFECT_CR1030_DefaultPO_Expiry = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1031_RentPO_Expiry ) = 1)
		BEGIN
			PRINT 'New Defect {CR1028_Pedal_No_Match}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1031_RentPO_Expiry,convert(varchar,CUSTOMER_ID), convert(varchar,PO_RENTDATE),[SubSet]
					FROM #Result1	WHERE DEFECT_CR1031_RentPO_Expiry = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1032_SaniPO_Expiry ) = 1)
		BEGIN
			PRINT 'New Defect {CR1028_Pedal_No_Match}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1032_SaniPO_Expiry,convert(varchar,CUSTOMER_ID),convert(varchar,PO_SANIDATE), [SubSet]
					FROM #Result1	WHERE DEFECT_CR1032_SaniPO_Expiry = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1033_ELPO_Expiry ) = 1)
		BEGIN
			PRINT 'New Defect {CR1028_Pedal_No_Match}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1033_ELPO_Expiry,convert(varchar,CUSTOMER_ID),convert(varchar,PO_ELDATE), [SubSet]
					FROM #Result1	WHERE DEFECT_CR1033_ELPO_Expiry = 1;
		END

		IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME,  @Rule_CR1034_TrialCustomer ) = 1)
		BEGIN
			PRINT 'New Defect {CR1028_Pedal_No_Match}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration,  @Rule_CR1034_TrialCustomer,convert(varchar,CUSTOMER_ID),'Cus_Type = TRIAL', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1034_TrialCustomer = 1;
		END
			




Exit_Now:
	IF (OBJECT_ID('tempdb..#Result1') IS NOT NULL)
		DROP TABLE #Result1;		

	

    EXEC @return_value = [DatasetSys].[sysUpdate_RulesRecordLastRunTime] @Rules, 0, 1, @Iteration;
	print 'Done';
END	
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 2021-04-15
-- Description:	Template to be used for creating custom rules
--
-- Ver	Who		When		What
-- 1	DIH		15/04/2021	Template created
-- =============================================
CREATE PROCEDURE [DatasetCustom].[Validate_Template]
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
	DECLARE @Rule_CR1000_Code_Missing	int = -1000;			
	DECLARE @Rule_CR1001_Code_Duplicate int = -1001;
	DECLARE @Rule_CR1002_InvCode_Bad	int = -1002;
	DECLARE @Rule_CR1003_InvCode_Filter int = -1003;

	-- All the rule numbers need to be in the 
	-- following string seperated by ; characters
	DECLARE @Rules varchar(1000) = ';-1000;-1001;-1002;01003;';

	EXEC	@return_value = [DatasetSys].[sysCheck_AnyRulesActive]
			@MIG_SITE_NAME = N' ',
			@Rules = @Rules;

	IF (@return_value = 0) goto Exit_Now

	EXEC @return_value = [DatasetSys].[sysUpdate_RulesToCurrentDefectVersion] @Rules, @Iteration;
	EXEC @return_value = [DatasetSys].[sysUpdate_RulesRecordLastRunTime] @Rules, 1, 0, @Iteration;




	-- ===============================================================================
	-- Do checks for [customerid]

	/* Sample rule taken from functional database

	IF (OBJECT_ID('tempdb..#Result1') IS NOT NULL)
		DROP TABLE #Result1;		

	IF ( [DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1001_Code_Duplicate ) = 1)
		BEGIN
			SELECT
				TBL1.MIG_SITE_NAME,
				TBL1.CUS_ACCOUNT,
				TBL1.DEFECT_CR1000_Missing,
				CUS_FilterStatus,
				CASE WHEN CUS_FilterStatus >= 3 THEN 1 ELSE 0 END [SubSet]
				INTO #Result1
				FROM 
					(	SELECT
							T_CUST.MIG_SITE_NAME,
							T_CUST.CUS_FILTER_STATUS										[CUS_FilterStatus],
							trim(T_CUST.CUSTOMER_ID)									CUS_ACCOUNT,
							-----------------------------------------------------
							CASE
								WHEN ISNULL(trim(T_CUST.CUSTOMER_ID),'') = ''
								THEN Convert(bit, 1)
								ELSE Convert(bit, 0)
							END															DEFECT_CR1000_Missing
							-----------------------------------------------------
					
							FROM Functional.Customer_Header_dc AS T_CUST
					WHERE			(	ISNULL(trim(T_CUST.CUSTOMER_ID),'') = ''	)				-- Account is missing or NULL
						
					) TBL1
				WHERE	(		TBL1.DEFECT_CR1000_Missing <> 0
					
						)
					AND
						(		TBL1.CUS_FilterStatus <> 0	
						)


			---------------------------------------------------------------------------------------------
			-- Process results
			---------------------------------------------------------------------------------------------

			PRINT 'New Defect {Missing CR1000}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1000_Code_Missing, CUS_ACCOUNT, '0', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1000_Missing = 1;
		END




	-- ===============================================================================
	-- Do checks for duplicate [customerid]

	IF (OBJECT_ID('tempdb..#Result3') IS NOT NULL)
		DROP TABLE #Result3;		

	IF ( [DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1001_Code_Duplicate ) = 1)
		BEGIN
			SELECT
				TBL1.MIG_SITE_NAME,
				TBL1.CUS_ACCOUNT,
				TBL1.DEFECT_CR1001_Duplicate,
				CUS_FilterStatus,
				CASE WHEN CUS_FilterStatus >= 3 THEN 1 ELSE 0 END [SubSet]
				INTO #Result3
				FROM 
					(	SELECT
							T_CUST.MIG_SITE_NAME,
							T_CUST.CUS_FILTER_STATUS										[CUS_FilterStatus],
							trim(T_CUST.CUSTOMER_ID)										CUS_ACCOUNT,
							----------------------------------------------------------------------------------
							CASE
								WHEN ISNULL(trim(T_CUST.CUSTOMER_ID),'') <> ''
								THEN Convert(bit, 1)
								ELSE Convert(bit, 0)
							END															DEFECT_CR1001_Duplicate
							-----------------------------------------------------
							FROM Functional.Customer_Header_dc AS T_CUST
					WHERE			(	T_CUST.CUSTOMER_ID in 
										(	SELECT CUSTOMER_ID FROM Functional.Customer_Header_dc	-- Find Account codes used more than once
											WHERE CUSTOMER_ID is not NULL
											GROUP BY CUSTOMER_ID
											HAVING Count(CUSTOMER_ID) > 1
										)
									)
					) TBL1
				WHERE	(		TBL1.DEFECT_CR1001_Duplicate <> 0
						)
					AND
						(		TBL1.CUS_FilterStatus <> 0	
						)

				---------------------------------------------------------------------------------------------
				-- Process results
				---------------------------------------------------------------------------------------------

				PRINT 'Defect {Duplicate CR1001}';
				INSERT INTO [DatasetSys].[DataDefect]
					(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet) 
					SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1001_Code_Duplicate, CUS_ACCOUNT, CUS_ACCOUNT, [SubSet]
						FROM #Result3 WHERE DEFECT_CR1001_Duplicate = 1; 	
		END



	
	-- ===============================================================================--
	-- Do checks for [billcust]

	IF (OBJECT_ID('tempdb..#Result2') IS NOT NULL)
		DROP TABLE #Result2;		

	IF (		[DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1003_InvCode_Filter ) = 1
			OR	[DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1002_InvCode_Bad ) = 1	
		)
		BEGIN
			-- First, find all occurances that will have a bad [billcust] link after migration.
			-- Then, change any found records for accounts that do not exist to 'bad' account links
			-- leaving the other records to 'filter' errors

			SELECT
				TBL1.MIG_SITE_NAME,
				TBL1.CUS_ACCOUNT,
				TBL1.CUS_Acct_to_Inv,
				TBL1.DEFECT_CR1002_Bad,
				TBL1.DEFECT_CR1003_Filter,
				CUS_FilterStatus,
				CASE WHEN CUS_FilterStatus >= 3 THEN 1 ELSE 0 END [SubSet]
				INTO #Result2
				FROM 
					(	SELECT
							T_CUST.MIG_SITE_NAME,
							T_CUST.CUS_FILTER_STATUS											[CUS_FilterStatus],
							trim(T_CUST.CUSTOMER_ID)										[CUS_ACCOUNT],
							trim(T_CUST.INVOICE_CUSTOMER)									[CUS_Acct_to_Inv],
							-----------------------------------------------------
							Convert(bit, 0)											DEFECT_CR1002_Bad,				-- Start of asuming all link are bad because of filtering (this may change)
							Convert(bit, 1)											DEFECT_CR1003_Filter				-- Start with marking all records as 'filter' errors.
							-----------------------------------------------------
						FROM Functional.Customer_Header_dc AS T_CUST
						WHERE		(	ISNULL(trim(T_CUST.INVOICE_CUSTOMER),'') <> ''	)			-- Only consider records that have a [billcust] value
								AND	(	trim(T_CUST.INVOICE_CUSTOMER) not in 
										(	SELECT trim(CUSTOMER_ID) FROM Functional.Customer_Header_dc
											WHERE CUS_FILTER_STATUS >= 2								-- Only select accounts that will be migrated
										)
									)
					) TBL1
				WHERE	(		TBL1.DEFECT_CR1002_Bad <> 0
							OR	TBL1.DEFECT_CR1003_Filter <> 0
						)
					AND
						(		TBL1.CUS_FilterStatus <> 0	
						)

			-- Now correct for invoice accounts that simply do not exist.

			UPDATE #Result2 SET
				DEFECT_CR1002_Bad = 1,					-- Mark as target account is missing from the legacy system
				DEFECT_CR1003_Filter = 0					-- Remove mark that error is becuase of record filtering.
				FROM		#Result2		T_R2
				LEFT JOIN	Functional.Customer_Header_dc		T_CUS		-- Do not apply any filter to this table.
						ON	T_R2.CUS_Acct_to_Inv =trim(T_CUS.CUSTOMER_ID)
				WHERE		ISNULL(trim(T_CUS.CUSTOMER_ID),'') = ''


			---------------------------------------------------------------------------------------------
			-- Process results
			---------------------------------------------------------------------------------------------

			IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1002_InvCode_Bad ) = 1)
				BEGIN
					PRINT 'Inv account missing {Missing CR1002}';
					INSERT INTO [DatasetSys].[DataDefect]
						(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
						SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1002_InvCode_Bad, CUS_ACCOUNT, CUS_Acct_to_Inv, [SubSet]
							FROM #Result2	WHERE DEFECT_CR1002_Bad = 1;
				END

			IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1003_InvCode_Filter ) = 1)
				BEGIN
					PRINT 'Inv account filtered out {Filter CR1003}';
					INSERT INTO [DatasetSys].[DataDefect]
						(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet) 
						SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1003_InvCode_Filter, CUS_ACCOUNT, CUS_Acct_to_Inv, [SubSet]
							FROM #Result2 WHERE DEFECT_CR1003_Filter = 1; 
				END

		END
		*/

Exit_Now:
	IF (OBJECT_ID('tempdb..#Result1') IS NOT NULL)
		DROP TABLE #Result1;		

	IF (OBJECT_ID('tempdb..#Result2') IS NOT NULL)
		DROP TABLE #Result2;
		
	IF (OBJECT_ID('tempdb..#Result3') IS NOT NULL)
		DROP TABLE #Result3;

    EXEC @return_value = [DatasetSys].[sysUpdate_RulesRecordLastRunTime] @Rules, 0, 1, @Iteration;
	print 'Done';
END	
GO

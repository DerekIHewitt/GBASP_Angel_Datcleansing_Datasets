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
-- 1	Ryfe	19/04/2021	created
-- 2	Ryfe	21/04/2021	Added isActive to check rule
-- =============================================
CREATE PROCEDURE [DatasetCustom].[Validate_Pedal_Prowat_Data]
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
	DECLARE @Rule_CR1028_Pedal_No_Match	int = -1028;			
	DECLARE @Rule_CR1029_Pedal_Value_Exists int = -1029;
	

	

	-- All the rule numbers need to be in the 
	-- following string seperated by ; characters
	DECLARE @Rules varchar(1000) = ';-1028;-1029;';

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
			TBL2.LEGACY_MACHINE_ID,
			TBL2.EQH_ID,
			TBL2.EQUIP_STOCK_CODE,
			TBL2.CUS_Type,
			TBL2.RENTALCOST,
			TBL2.DEFECT_CR1029_Pedal_Value_Exists,
			TBL2.DEFECT_CR1028_Pedal_No_Match,
			0 AS [SubSet]
	INTO #Result1
	FROM
	(
		SELECT 
			@MIG_SITE_NAME AS MIG_SITE_NAME
			,TBL.EQH_ACCOUNT AS CUSTOMER_ID
			,TBL.CUS_TYPE
			,TBL.PEDAL_ID AS LEGACY_MACHINE_ID
			,SERIALLINK
			,TBL.EQH_ID
			,EQUIP_STOCK_CODE
			,product_type
			,MIFEQ.EQH_IDNO
			,MIFEQ.EQH_Stock_Code AS MACHINE
			,RENTALCOST
			,DEFECT_CR1029_Pedal_Value_Exists
			,CASE 
				WHEN MIFEQ.EQH_IDNO is null 
					THEN Convert(bit, 1)
					ELSE Convert(bit, 0)
				END AS DEFECT_CR1028_Pedal_No_Match 
	FROM
	(	SELECT 
			
			EQH_ACCOUNT 
			,C.CUS_Company
			,C.CUS_TYPE
			,EQH_IDNO AS PEDAL_ID
			,(eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) AS RENTALCOST
			,CASE 
				WHEN (eqh_rental_amnt+eqh_c_value+eqh_sani_amnt) > 0 
					THEN Convert(bit, 1)
					ELSE Convert(bit, 0)
			 END AS DEFECT_CR1029_Pedal_Value_Exists
			 			 
			,REPLACE(REPLACE(SUBSTRING(EQH_ID,4,100),' ',''),'-','') AS SERIALLINK
			,EQH_ID
			,EQH_STOCK_CODE AS EQUIP_STOCK_CODE
			,et.ety_name as product_type
			,eqh_rental_amnt
			,eqh_c_value
			,eqh_sani_amnt

			FROM DatasetProWat.Syn_EquipHdr_dc EQ
			JOIN DatasetProWat.Syn_Customer_dc C  ON C.CUS_ACCOUNT = EQ.EQH_ACCOUNT
			JOIN DatasetProWat.Syn_Stock_dc  ST   ON st.sto_stock_code = eq.eqh_stock_code
			JOIN DatasetProWat.Syn_EQTYPE_dc ET   ON et.ety_id = st.sto_eqtype
	 
			WHERE et.ety_name like 'PEDAL')TBL
			LEFT JOIN DatasetProWat.Syn_EquipHdr_dc MIFEQ ON MIFEQ.EQH_ID = TBL.SERIALLINK
)TBL2

			WHERE 
			( TBL2.DEFECT_CR1029_Pedal_Value_Exists <> 0
			OR TBL2.DEFECT_CR1028_Pedal_No_Match <> 0 
			)



			---------------------------------------------------------------------------------------------
			-- Process results
			---------------------------------------------------------------------------------------------

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1028_Pedal_No_Match ) = 1)
		BEGIN
			PRINT 'New Defect {CR1028_Pedal_No_Match}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration, @Rule_CR1028_Pedal_No_Match, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), '', [SubSet]
					FROM #Result1	WHERE DEFECT_CR1028_Pedal_No_Match = 1;
		END

	IF ([DatasetSys].[IsRuleActive](@MIG_SITE_NAME, @Rule_CR1029_Pedal_Value_Exists ) = 1)
		BEGIN
			PRINT 'New Defect {CR1029_Pedal_Value_Exists}';
			INSERT INTO [DatasetSys].[DataDefect]
				(MIG_SITE_NAME,ID_Iteration, ID_Rule, SourceReferences, BadValue, IsSubSet)
				SELECT MIG_SITE_NAME,@Iteration,  @Rule_CR1029_Pedal_Value_Exists, 'Customer ID - ' + convert(varchar,CUSTOMER_ID) + ' - Machine ID - ' + convert(varchar,LEGACY_MACHINE_ID), RENTALCOST, [SubSet]
					FROM #Result1	WHERE DEFECT_CR1029_Pedal_Value_Exists = 1;
		END
			




Exit_Now:
	IF (OBJECT_ID('tempdb..#Result1') IS NOT NULL)
		DROP TABLE #Result1;		

	

    EXEC @return_value = [DatasetSys].[sysUpdate_RulesRecordLastRunTime] @Rules, 0, 1, @Iteration;
	print 'Done';
END	
GO

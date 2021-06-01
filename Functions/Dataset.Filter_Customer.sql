SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		DIH
-- Create date: 2019-11-21
-- Description:	Filter for Customer table
--
--	Ver	Who		When		What
--	2	DIH		27-11-20	Make MIG_SITE_NAME to data stripe it.
--	3	DIH		17/02/2021	Add the 3 x @Is.... parameters for overriding the filter.
-- =============================================
CREATE   FUNCTION [Dataset].[Filter_Customer]
(
	@MIG_SITE_NAME varchar(5),
	@Scope varchar(2),								-- 'dc' for data cleansing or 'ex' for extraction
	@IsAlwaysIncluded bit,							-- This comes from table [Customer_Filter_Override]
	@IsAlwaysExcluded bit,							-- This comes from table [Customer_Filter_Override]
	@IsOnSubsetList bit,							-- This comes from table [Customer_Filter_Override]
	@CUS_Account varchar(100),						-- The reset of the fields come from links to the Legacy systems tables.
	@CUS_Company varchar(100),
	@CUS_Type varchar(50)
)
RETURNS int
AS
BEGIN
	DECLARE @Result_Drop int = 0;					-- Record fails filter;
	DECLARE @Result_WouldDrop int = 1;				-- Record fails filter but the current data scopt mode is ALL;
	DECLARE @Result_TakeOn int = 2;					-- Record passes filter;
	DECLARE @Result_Subset int = 3;					-- Record passed filter and is part of the SUBSET.
	DECLARE @Mode_All int = 1;						-- All records to be considered;
	DECLARE @Mode_TakeOn int = 2;					-- Normal TAKE_ON mode is active;
	DECLARE @Mode_Subset int = 3;					-- Using a filtered SUBSET of the TAKE_ON data.			

	DECLARE @Result int = @Result_TakeOn;
	DECLARE @CurrentMode int = Dataset.Filter_Mode(@MIG_SITE_NAME, @Scope, 'Customer');
	
	IF @MIG_SITE_NAME = 'GBASP'
		BEGIN
			------ Find records that require dropping ------------------------------------------------
			IF (@CUS_Company LIKE 'ZZZ%')
				BEGIN
					SET @Result = @Result_Drop;
				END
			ELSE
				BEGIN
					IF (@CUS_Type LIKE 'CANC%') OR
					   (@CUS_Type LIKE 'STOCK%') 
						BEGIN 
							SET @Result = @Result_Drop;
						END
				END


	
			------ If record falls into the subset and subset is active ------------------------------

			/***** Not details of a sub set yet ******
			IF (@Result = @Result_TakeOn) AND (@CurrentMode = @Mode_Subset)
				BEGIN
					IF ( %Criteria to be in the the sub set % )
						 SET @Result = @Result_Subset; 
				END
					******************************************/
		END




	------ If in ALL mode, upgrade any droped records to 'WouldDrop' ---------------------------

	IF (@IsAlwaysExcluded = 1) SET @Result = @Result_Drop
	IF (@IsAlwaysIncluded = 1) SET @Result = @Result_TakeOn
	IF (@Result = @Result_Drop) AND (@CurrentMode = @Mode_All) SET @Result = @Result_WouldDrop;
	IF (@IsOnSubsetList = 1) SET @Result = @Result_Subset
	RETURN @Result
END
GO

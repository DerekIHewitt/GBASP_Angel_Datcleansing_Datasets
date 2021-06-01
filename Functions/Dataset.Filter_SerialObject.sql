SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		DIH
-- Create date: 2019-12-12
-- Description:	Filter for Customer Serial Objects (Equipment)
-- =============================================
CREATE FUNCTION [Dataset].[Filter_SerialObject]
(	@MIG_SITE_NAME varchar(5),
	@Scope varchar(2),								-- 'dc' for data cleansing or 'ex' for extraction
	@IsAlwaysIncluded bit,
	@IsAlwaysExcluded bit,
	@IsOnSubsetList bit,
	@EQH_Status as varchar(1),						-- Determines if equipment is (R) company or (S) customer owned.
	@CUS_Type varchar(50),							-- Customer types may mean machine require dropping.
	@CUS_Filter_Status int							-- If the customer is invalid then the machine export is invalid.
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
	DECLARE @CurrentMode int = Dataset.Filter_Mode(@MIG_SITE_NAME, @Scope, 'SerialObject');
	
	------ Find records that require dropping ------------------------------------------------
	IF (@CUS_Filter_Status < 2)
		BEGIN
			SET @Result = @Result_Drop;
		END

	------ If in ALL mode, upgrade dropped records to 'WouldDrop' ---------------------------
	IF (@Result = @Result_Drop) AND (@CurrentMode = @Mode_All) SET @Result = @Result_WouldDrop;
	
	------ If record falls into the subset and subset is active ------------------------------

	/***** Not details of a sub set yet ******
	IF (@Result = @Result_TakeOn) AND (@CurrentMode = @Mode_Subset)
		BEGIN
			IF ( %Criteria to be in the the sub set % )
				 SET @Result = @Result_Subset; 
		END
	******************************************/
	IF (@IsAlwaysExcluded = 1) SET @Result = @Result_Drop
	IF (@IsAlwaysIncluded = 1) SET @Result = @Result_TakeOn
	IF (@Result = @Result_Drop) AND (@CurrentMode = @Mode_All) SET @Result = @Result_WouldDrop;
	IF (@IsOnSubsetList = 1) SET @Result = @Result_Subset

	RETURN @Result
END
GO

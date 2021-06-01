SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		DIH
-- Create date: 2019-11-21
-- Description:	Return an idicator of the current mode that
--				data cleansing / filtering is running in for the 
--				the entire database.
--				This is called by ALL UDFs for filtering (Filter_%TableName%).
--
--	1	21/11/2019	DIH		Created
--	2	04/02/2020	DIH		Added constants and put 'exe' in subset mode ready for test 14/02/2020
--  3	04/02/2020	DIH		Added 'unfiltered subset' to assist in debugging.
--	4	04/02/2020	DIH		Unfiltered_Subset is now 3 and SubSet is now for (previously the other way around)
--	4	05/02/2020	ARG		Amended to pull value from table FilterMode
--  5	27-11-2020	DIH		Added MIG_SITE_NAME as data is now striped. 
--	5b	27-11-2020	DIH		@TableName parameter changed to @DataType.
-- =============================================
CREATE FUNCTION [Dataset].[Filter_Mode] 
(
@MIG_SITE_NAME as varchar(5),
@ArgScope as varchar(2),
@DataType AS nvarchar(20)
)
RETURNS int
AS
BEGIN
	DECLARE @Mode_ALL int = 1;					-- All records (no filters but indicate the ones that would have been dropped)
	DECLARE @Mode_Normal int = 2;				-- Records that pass the filter.
	DECLARE @Mode_UnfilteredSubSet int = 3;		-- Unfiltered subset.
	DECLARE @Mode_SubSet int = 4;				-- Filtered subset.
	DECLARE @Current_Mode int = @Mode_Normal;	-- This is TAKE_ON data (The default setting)

	-- pull value from table to give FilterMode per table
	SET @Current_Mode =
		(	SELECT [CurrentMode] 
				FROM [DatasetSys].FilterMode 
				WHERE	MIG_SITE_NAME = @MIG_SITE_NAME
				AND		DataType = @DataType 
				AND		Scope = @ArgScope
		)

	-- replaced with above 05/02/2020 ARG
	--IF (@ArgScope = 'dc')
	--	BEGIN
	--	-- In the data cleansing scope
	--	-- Declare the return variable here
	--	-- SET @Current_Mode = @Mode_ALL				-- This is ALL data
	--	SET @Current_Mode = @Mode_Normal				-- This is TAKE_ON data
	--	--SET @Current_Mode = @Mode_UnfilteredSubSet	-- Unfiltered subset.This is SUBSET data
	--	-- SET @Current_Mode = @Mode_SubSet				-- This is SUBSET data
	--	END

	--IF (@ArgScope = 'ex')
	--	BEGIN
	--	-- In the data extraction scope
	--	-- SET @Current_Mode = @Mode_ALL				-- This is ALL data
	--	-- SET @Current_Mode = @Mode_Normal				-- This is TAKE_ON data
	--	SET @Current_Mode = @Mode_UnfilteredSubSet		-- unfiltered SUBSET data
	--	-- SET @Current_Mode = @Mode_SubSet				-- This is SUBSET data
	--	END

	-- Return the result of the function
	RETURN @Current_Mode
END
GO

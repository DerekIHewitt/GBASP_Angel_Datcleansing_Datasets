SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		ARG
-- Create date: 2020-02-13
-- Description:	Filter for Customer contacts based on contents of fields
--              Don't need to pass similar parameters to other filter functions
--              as the customers have already been filtered for us, these contacts
--              will be linked to those
-- =============================================
CREATE FUNCTION [DatasetProWat].[Filter_Customer_Contact]
(@CUS_Field nvarchar(200))
RETURNS bit
 
BEGIN
	DECLARE @Valid bit = 0
		-- start off with false
		IF CHARINDEX('/',@CUS_Field) = 0
		AND PATINDEX('%[0-9]%',@CUS_Field) = 0		-- will probably be a phone number
		AND CHARINDEX('@', @CUS_Field) = 0			-- will probably be an email address
		-- the criteria below have been added in since first load into WLITEST
		AND CHARINDEX(',',@CUS_Field) = 0
		--AND CHARINDEX('ACCOUNTS',@CUS_Field) = 0	-- confirmed these are ok to take for now - 'Accounts Payable'
		--AND CHARINDEX('PAYABLE',@CUS_Field) = 0	-- confirmed these are ok to take for now - 'Accounts Payable'
		AND CHARINDEX(' OR ',@CUS_Field) = 0
		AND CHARINDEX(' WHO ',@CUS_Field) = 0
		AND CHARINDEX(' FOR ',@CUS_Field) = 0
		AND CHARINDEX(' AT ',@CUS_Field) = 0
		AND CHARINDEX(' & ',@CUS_Field) = 0
		AND CHARINDEX('?', @CUS_Field) = 0
		AND CHARINDEX('#', @CUS_Field) = 0
		AND CHARINDEX('[', @CUS_Field) = 0
		AND CHARINDEX('{', @CUS_Field) = 0
		AND CHARINDEX('(', @CUS_Field) = 0
		AND LEN(@CUS_Field) > 1						-- should be more than one character 
		-- these criteria above have been added in since first load into WLITEST

		SET @Valid = 1

	RETURN @Valid;
END
GO

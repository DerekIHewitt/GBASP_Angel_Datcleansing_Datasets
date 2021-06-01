SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 25/02/2021
-- Description:	Determin if a rule is active or not.
-- =============================================
CREATE FUNCTION [DatasetSys].[IsRuleActive]
(
	@MIG_SITE_NAME varchar(5),
	@ID_Rule int
)
RETURNS bit
AS
BEGIN
	DECLARE @ResultVar bit = 0;
	SELECT @ResultVar = ISNULL(IsActive,1) 
		FROM [DatasetSys].[Rule_Custom]
		WHERE ID = @ID_Rule
	-- TODO: When rules are MIG stripped, this will require updating.
	RETURN @ResultVar
END
GO

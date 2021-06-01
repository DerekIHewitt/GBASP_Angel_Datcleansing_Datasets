SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 2021/02/26
-- Description:	Determine if any of the specified rules are active
--
-- =============================================
CREATE PROCEDURE [DatasetSys].[sysCheck_AnyRulesActive]
	@MIG_SITE_NAME varchar(5),	-- TODO: Place holder for when rules are MIG striped
	@Rules varchar(1000)		-- Format is '[Rule1][Rule2][Rule3]....'
AS
BEGIN
	SET NOCOUNT ON;
	Declare @RecCount as int = 0;
	Declare @ReturnVal int = 0;

	BEGIN TRY
		SELECT @RecCount = COUNT(1)
			FROM	[DatasetSys].[Rule_Custom]
			WHERE	@Rules LIKE '%;' + CAST(ID as varchar(20)) + ';%'
				AND IsActive = 1

		IF	(@RecCount > 0) SET @ReturnVal = 1;
	END TRY

	BEGIN CATCH
		SET @ReturnVal = 1;		-- If in doubt, run the rules
	END CATCH

	return (@ReturnVal);
END
GO

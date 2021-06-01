SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 2021/04/15
-- Description:	Prepair the database for a procedure to run for
--				a number of rules.
--				Each rule will be set to the current 'deffect version'. 
--				Any previouse 'found defects' for the current 'deffect version' are dropped.
--
-- Ver	Who	When		What
--	1	DIH	15/04/2021	Trtansfered routine from functional
-- =============================================
CREATE PROCEDURE [DatasetSys].[sysUpdate_RulesToCurrentDefectVersion]
	@Rules varchar(1000),		-- Format is '[Rule1][Rule2][Rule3]....'
	@Iteration int
AS
BEGIN
	SET NOCOUNT ON;

	-------- Update ALL supplied rules to use the current iteration ---------
	UPDATE			[DatasetSys].[Rule_Custom]
		SET			ID_Iteration_Deffect_Current = @Iteration
		WHERE		';' + @Rules + ';' LIKE '%;' + CAST(ID as varchar(20)) + ';%'
			AND		IsActive = 1;

	-------- Remove all previouse found defects for this rule / Current deffect combination ---------
	DELETE			[DatasetSys].[DataDefect]
		FROM		[DatasetSys].[DataDefect]			T_DD
		JOIN		[DatasetSys].[Rule_Custom]			T_TB
			ON		T_DD.ID_Rule = T_TB.ID
		WHERE		@Iteration = T_DD.ID_Iteration
			AND		';' + @Rules + ';'  LIKE '%;' + CAST(T_DD.ID_Rule as varchar(20)) + ';%'
			AND		T_TB.IsActive = 1
END

GO

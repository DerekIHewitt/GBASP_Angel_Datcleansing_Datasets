SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 2020/02/20
-- Description:	Record the Start/Stop time for each rule
--
-- ver	Who		When		What
-- 1	DIH		15/04/2021	Transfered from functional
-- =============================================
CREATE PROCEDURE [DatasetSys].[sysUpdate_RulesRecordLastRunTime]
	@Rules varchar(1000),		-- Format is '[Rule1][Rule2][Rule3]....'
	@DoStart bit,				-- Record the start time for each rule
	@DoEnd bit,					-- Record the finish time for each rule
	@Iteration int				-- Ensure that [IsHasRun] is true for the iteratin when finished.
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Now DateTime = GetDate();

	IF (@DoStart = 1)
		BEGIN
			UPDATE		[DatasetSys].[Rule_Custom]
				SET		LastRun_Start = @Now
				WHERE	@Rules LIKE '%;' + CAST(ID as varchar(20)) + ';%'
					AND IsActive = 1
		END

	IF (@DoEnd = 1)
		BEGIN
			UPDATE		[DatasetSys].[Rule_Custom]
				SET		LastRun_Finish = @Now
				WHERE	@Rules LIKE '%;' + CAST(ID as varchar(20)) + ';%'
					AND	IsActive = 1;
		END

END
GO

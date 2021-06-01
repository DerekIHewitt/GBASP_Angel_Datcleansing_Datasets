SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH	
-- Create date: 2019-12-12
-- Description:	Convert prowat date to nornal date
-- =============================================
CREATE FUNCTION [Dataset].[ConvertProwatDate]
(	@ProwatDate as int,
	@DefaultDate as date
	
)
RETURNS date
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result as date;
	DECLARE @BaseDate as date = '1800-12-28';

	-- Add the T-SQL statements to compute the return value here
	IF (ISNULL(@ProwatDate,0) > 0)
		BEGIN
		SET @Result = DateAdd(day, @ProWatDate, @BaseDate)
		END
	ELSE
		BEGIN
		SET @Result = @DefaultDate;
		END

	-- Return the result of the function
	RETURN @Result
END
GO

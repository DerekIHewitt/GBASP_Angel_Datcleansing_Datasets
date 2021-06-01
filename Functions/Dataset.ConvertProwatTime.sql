SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 03/02/2020
-- Description:	Convert the in line function James was using
--				that converst an integer to a smalldatetime
--				For example 1330 becomes 13:30.
-- =============================================
CREATE FUNCTION [Dataset].[ConvertProwatTime]
(
	@ProwatTime int
)
RETURNS smalldatetime
AS
BEGIN
	DECLARE @ResultVar as smalldatetime;
	
	SET @ResultVar =
		CONVERT(smalldatetime, 
					CONCAT(	IIF(LEN(@ProwatTime) = 3, LEFT(@ProwatTime,1), LEFT(@ProwatTime,2)),			-- Get the hours 
							 ':',																			-- Timne seperator
							 RIGHT(@ProwatTime,2)															-- Get the minutes
					      )
				)

	RETURN @ResultVar;
END
GO

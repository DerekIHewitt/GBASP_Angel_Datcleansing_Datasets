SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [DatasetProWat].[ConvertFromClarion]
(
	-- Add the parameters for the function here
	@ClarionDate AS NUMERIC
)
RETURNS VARCHAR(10)

AS
BEGIN

	DECLARE @Date DATE
	--DECLARE @Date VARCHAR(10)
	DECLARE @Return VARCHAR(10)
		
	SET @Date = CONVERT(DATE, CONVERT(DATETIME, (@ClarionDate - DATEDIFF(DAY,'18001228','')),103))
	--SET @RETURN = Right(@Date,2)  + '/' + SUBSTRING(@Date,6,2)  + '/' + LEFT(@Date,4) 

	RETURN @Date  --@RETURN

END

GO

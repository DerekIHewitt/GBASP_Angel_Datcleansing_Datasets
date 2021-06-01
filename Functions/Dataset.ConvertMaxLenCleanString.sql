SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: ??/12/2019
-- Description:	Ensure that the string contains no
--				special characters and truncate to
--				a maxium site.
--
--	1	??/12/2019	DIH		Created
--	2	03/02/2020	DIH		'|' is always a bad caracter.
--  3	28/02/2020	DIH		Moved @badChar to be outside the IF staement as it is cleaner code.
--	4	28/02/2020	DIH		Added additional functionality to @AlsoStrip and @MaxLength
--	5	28/02/2020	DIH		Converst bad characters to space (no longer removes them)
--	6	03/03/2020	DIH		Put DATALENGTH on the WHILE statements
-- =============================================
CREATE FUNCTION [Dataset].[ConvertMaxLenCleanString]
(
	@SourceString varchar(1000),
	@AlsoStrip varchar(100),				-- Null or blank string means no additional characters
	@MaxLength int							-- <= 0 Means do not truncate field 
)
RETURNS varchar(max)
AS
BEGIN
	DECLARE @ResultVar as varchar(max);
	DECLARE @badChar CHAR(1);
    DECLARE @increment INT= 1;

   WHILE @increment <= DATALENGTH(@SourceString)
        BEGIN
			SET @badChar = SUBSTRING(@SourceString, @increment, 1);
            IF		(ASCII(@badChar) < 32)		-- 32=space, 9=tab, 10=LF, 13=CR, etc.
				OR  (@badChar = '|')			-- Pipe always invalid when you use pipe delimited files.	
				BEGIN
					SET @SourceString = REPLACE(@SourceString, @badChar, ' ');	-- Convert to space
				END;
            SET @increment = @increment + 1;
        END;

	SET @increment = 1

    WHILE @increment <= DATALENGTH(ISNULL(@AlsoStrip,''))
        BEGIN
			SET @badChar = SUBSTRING(@AlsoStrip, @increment, 1);
			SET @SourceString = REPLACE(@SourceString, @badChar, ' ');	-- replace with a space
            SET @increment = @increment + 1;
        END;

	IF (@MaxLength > 0)
		SET @ResultVar = LEFT(TRIM(@SourceString), @MaxLength);
	ELSE
		SET @ResultVar = TRIM(@SourceString);

	RETURN @ResultVar;
END
GO

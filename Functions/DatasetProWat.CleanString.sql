SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE Function [DatasetProWat].[CleanString](@Temp VarChar(4000))
Returns VarChar(4000)
AS
--	1	??/12/2019	DIH		Copied from Stagging DB.
--	2	03/02/2020	DIH		Added '|' to bad characters.
--	3	28/02/2020	DIH		New code done so data cleansing dossn't report 'self correcting' issues as 'data owner issues' but 'migration auto corrections'
--	4	05/02/2020	DIH		Put DATALENGTH in line as the replace chages the string length
--  5   20/01/2021  RJS     Added counter -1 to allow the carriage return line feed to generate cleanse correctly
--	6	25/01/2022  RYFE	Remove the HOP character ASCII 129 specifically
Begin
	/* Original code
		Return TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
				(ISNULL(@Temp,''), 
				'|', ' '),				-- Pipe
				CHAR(39),'"'),			-- '
				CHAR(9), ' '),			-- TAB
				CHAR(13), ' '),			-- CR
				CHAR(10), ''),			-- LF
				',',';' ))
	*/
	DECLARE @Counter int;
	DECLARE @BadChar as char(1);
	DECLARE @BadCharAsc as int;

	SET @Counter = 1;

	WHILE @Counter <= DATALENGTH(isnull(@Temp,''))
		BEGIN
			SET @BadChar = SUBSTRING(@Temp, @Counter, 1)
			SET @BadCharAsc = ASCII(@BadChar);
			IF ( @BadChar='|' ) OR
			    ( @BadChar='"' ) OR
			   ( @BadCharAsc = 13 ) OR
			   ( @BadCharAsc =  9) 
			  
				BEGIN
					SET @Temp = REPLACE(@Temp, @BadChar, ' ');
				END
			ELSE
				BEGIN
					IF (@BadCharAsc < 32) OR @BadCharAsc = 129						--25/01/2022 RYFE remove HOP character specifically
						BEGIN
							SET @Temp = REPLACE(@Temp, @BadChar, '');
							SET @COUNTER = @COUNTER -1;  --RJS SEE ABOVE
						END
				END
			SET @Counter= @Counter + 1;
		END

	RETURN TRIM(ISNULL(@Temp,''));

	/*
  Return TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
			(ISNULL(@Temp,''), 
			CHAR(39),'"'),			-- '
			'|','"'),				-- Pipe
			CHAR(9), ' '),			-- TAB
			CHAR(13), ' '),			-- CR
			CHAR(10), ''),			-- LF
			'"',''''),              -- REPLACE DOUBLE QUOTES, CAUSING ERRORS IN LOAD
			',',';' ))
End
*/
End


GO

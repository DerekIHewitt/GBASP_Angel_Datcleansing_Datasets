SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =========================================================
-- Author:		ARG
-- Create date: 2020-02-11
-- Description:	Strip out the parts of names from a single
--              name field
-- 
-- 1	ARG	19/02/2020	Created
-- =========================================================
Create FUNCTION [DatasetProWat].[ExtractNameParts]
(
	@CUS_Field nvarchar(200)
)
RETURNS TABLE
AS
      RETURN
		  (	SELECT 
				-- FIRST_NAME.ORIGINAL_INPUT_DATA -- testing
				 FIRST_NAME.TITLE
				,FIRST_NAME.FIRST_NAME
				,CASE 
					WHEN 0 = CHARINDEX(' ',FIRST_NAME.REST_OF_NAME)
					THEN NULL  --no more spaces?  assume rest is the last name
					ELSE SUBSTRING(
									   FIRST_NAME.REST_OF_NAME
										,1
										,CHARINDEX(' ',FIRST_NAME.REST_OF_NAME)-1
								   )
				 END AS MIDDLE_NAME
				,SUBSTRING(
							FIRST_NAME.REST_OF_NAME
							,1 + CHARINDEX(' ',FIRST_NAME.REST_OF_NAME)
							,LEN(FIRST_NAME.REST_OF_NAME)
						  ) AS LAST_NAME
		
			FROM	(  
						 SELECT
							TITLE.TITLE
						   ,CASE 
								WHEN 0 = CHARINDEX(' ',TITLE.REST_OF_NAME)
								THEN TITLE.REST_OF_NAME --No space? return the whole thing
								ELSE SUBSTRING(
												 TITLE.REST_OF_NAME
												,1
												,CHARINDEX(' ',TITLE.REST_OF_NAME)-1
											   )
							END AS FIRST_NAME
						   ,CASE 
								WHEN 0 = CHARINDEX(' ',TITLE.REST_OF_NAME)  
								THEN NULL  --no spaces @ all?  then 1st name is all we have
								ELSE SUBSTRING(
												 TITLE.REST_OF_NAME
												,CHARINDEX(' ',TITLE.REST_OF_NAME)+1
												,LEN(TITLE.REST_OF_NAME)
												 )
							END AS REST_OF_NAME
						   ,TITLE.ORIGINAL_INPUT_DATA
						  FROM
								(   
									SELECT
										--if the first three characters are in this list,
										--then pull it as a "title".  otherwise return NULL for title.
										CASE 
											WHEN SUBSTRING(TEST_DATA.FULL_NAME,1,3) IN ('MR ','MS ','DR ','MRS ')
											THEN LTRIM(RTRIM(SUBSTRING(TEST_DATA.FULL_NAME,1,3)))
											ELSE NULL
										END AS TITLE
										--if you change the list, don't forget to change it here, too.
									  ,CASE 
											WHEN SUBSTRING(TEST_DATA.FULL_NAME,1,3) IN ('MR ','MS ','DR ','MRS ')
											THEN LTRIM(RTRIM(SUBSTRING(TEST_DATA.FULL_NAME,4,LEN(TEST_DATA.FULL_NAME))))
											ELSE LTRIM(RTRIM(TEST_DATA.FULL_NAME))
										END AS REST_OF_NAME
									   ,TEST_DATA.ORIGINAL_INPUT_DATA
									FROM
										  (
											  SELECT
													--trim leading & trailing spaces before trying to process
													--disallow extra spaces *within* the name
													REPLACE(REPLACE(LTRIM(RTRIM(FULL_NAME)),'  ',' '),'  ',' ') AS FULL_NAME
													,FULL_NAME AS ORIGINAL_INPUT_DATA
											  FROM
													(
														SELECT @CUS_Field AS FULL_NAME
													) RAW_DATA
											) TEST_DATA
								) TITLE
					) FIRST_NAME
		  )
GO

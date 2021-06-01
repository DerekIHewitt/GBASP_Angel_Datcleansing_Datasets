SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      Simon Hardstaff
  Description: Pulls out the data for the detail section of defect data total movement report 
  for the users to cleanse in the source system

  History:
  Ver	By		Date        Comments
  1		SH		??/??/2020	Initial version
  2		DIH		03/06/2020	Tidy up formating so code is redable.
							Changed filter to include results when defects are now zero.
  =============================================*/

CREATE PROCEDURE [dbo].[USP_RPT_DATA_DEFECT_RULE_CHANGE_COUNT]

AS

SET NOCOUNT ON

SELECT 
SORT_BY_OWNER_ID				=	RO.ID
,RULE_OWNER						=	RO.[Owner]
,[RULE_TABLE_TABLE_NAME]		=	CASE	WHEN R.ID_Owner	=	200
											AND R.TableName		=	'Customer_dc'
												THEN 'Customer Equipment Site'
											WHEN R.ID_Owner	=	200
											AND R.TableName		=	'Customer_Billing_Address'
												THEN 'Customer Head Office'	
											ELSE R.TableName
												END
,A.[RULE_TABLE_FIELD_NAME]
,A.[RULE_TABLE_DETAIL]
,A.[THIS_RUN_ID_ITERATION]
,A.[THIS_RUN_TOTAL]
,A.[PREVIOUS_ID_ITERATION]
,A.[PREVIOUS_RUN_TOTAL]
,A.[RULE_DIFFERENCE]
,A.[RULE_TREND_CHANGE]
,DATA_LAST_LOAD_DATE			=	CONVERT(DATE,A.[ETL_DATE_TIME_CREATED])
,CELL_COLOUR					=	CASE	WHEN	[RULE_DIFFERENCE] >		0	THEN	'Red'
											WHEN	[RULE_DIFFERENCE] =		0	THEN	'White'
											WHEN	[RULE_DIFFERENCE] <		0	THEN	'Green'
											END
,ID_RULE_PARAM					=	R.ID
FROM		[DatasetSys].[DataDefect_Total_Audit] A

LEFT JOIN	[ToBeDecided].[Rule] R
	ON		A.ID_Rule = R.ID

LEFT JOIN	[DatasetSys].[Rule_Owner] RO
	ON		R.ID_Owner = RO.ID

WHERE	[THIS_RUN_ID_ITERATION] >= (	SELECT MAX([THIS_RUN_ID_ITERATION])  
										FROM [AUPER_TSM_DATACLEANSING].[DBO].[DATADEFECT_TOTAL_AUDIT])
	AND		(		A.[THIS_RUN_TOTAL] <> 0
				OR	A.[PREVIOUS_RUN_TOTAL] <> 0
			)
GO

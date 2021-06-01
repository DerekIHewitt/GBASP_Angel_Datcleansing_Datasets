SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      Simon Hardstaff
  Description: Pulls out the data for the detail section of defect data for the users to cleanse in the source system

  History:
  Ver	By		Date        Comments
  
  =============================================*/

CREATE PROCEDURE [dbo].[USP_RPT_DATA_DEFECT_CURRENT_DETAIL_DATA_DRILL_THROUGH]
@ID_RULE INT

AS


	--Declare variables
	SET NOCOUNT ON
/* PRE FILTER DATA TO ONLY RETURN THE MOST RESENT DATA DEFECTS */
DECLARE @PRE_FILTER_ID_ITERATION AS TABLE 
(
ID_ITERATION				INT		NULL,
LAST_DATA_LOAD_DATE			DATE	NULL
)

INSERT INTO @PRE_FILTER_ID_ITERATION

SELECT 
ID_ITERATION							=	MAX(DD.ID_Iteration), 
LAST_DATA_LOAD_DATE						=	MAX(DD.CreatedDate)
FROM [DatasetSys].[DataDefect] DD

--SET @PRE_FILTER_ID_ITERATION = (SELECT MAX(ID_Iteration) FROM [dbo].[DataDefect])

SELECT 

GROUPING_RULE_OWNER_VALUE				=	RUO.[Owner],
GROUPING_RULE_MASTER_VALUE				=	RUMG.RequiredAction,
GROUPING_RULE_VALUE						=	RU.Detail,
GROUPING_RULE_HINT_VALUE				=	RU.FieldName + CASE		WHEN ISNULL(RU.MetaMethod,'') <> '' THEN ' :- ' + ISNULL(RU.MetaMethod,'') 
											ELSE ''
											END ,
GROUPING_IMPACT_ON_PROJECT_VALUE		=	CASE	WHEN	RU.ImpactOnProject	=	9	THEN 'Highest'
													WHEN	RU.ImpactOnProject	=	8	THEN 'Very High'
													WHEN	RU.ImpactOnProject	IN	(7)	THEN 'High'
													WHEN	RU.ImpactOnProject	IN	(5,6)	THEN 'Med'
													WHEN	RU.ImpactOnProject	IN	(3,4)	THEN 'Low'
													WHEN	RU.ImpactOnProject	IN	(1,2)	THEN 'Lowest'
													ELSE	'Check Data'	END,
GROUPING_IFS_SYSTEM_RULE_VALUE			=	CASE	WHEN	RU.IsIfsSystemRule	=	1	THEN 'YES'
													ELSE	'NO'	END,
GROUPING_BUSINESS_RULE_VALUE			=	CASE	WHEN	RU.IsBusinessRule	=	1	THEN 'YES'
													ELSE	'NO'	END,
GROUPING_DEFECT_YEAR					=	DATEPART(yyyy,DD.CreatedDate),
GROUPING_DEFECT_MONTH					=	DATEPART(mm,DD.CreatedDate),
GROUPING_DEFECT_WEEK					=	DATEPART(wk,DD.CreatedDate),
GROUPING_DEFECT_DATE					=	DD.CreatedDate,
GROUPING_DEFECT_DATE_VALUE				=	FORMAT(DD.CreatedDate,'dd-MMM-yyyy'),

COLUMN_HEADER_SOURCE_REF_NAME			=	CASE	WHEN	RU.TableName	LIKE	'%Customer%'	THEN 'Customer Ref '
													WHEN	RU.TableName	LIKE	'%EquipHdr%'	THEN 'Equip Ref '
													WHEN	RU.TableName	LIKE	'%Supplier%'	THEN 'Supplier Ref '
													ELSE	'Other Check Data '
													END,
DETAIL_SOURCE_REF_VALUE					=	DD.SourceReferences,
DETAIL_DATA_DEFECT_VALUE				=	CASE	WHEN ISNULL(DD.BadValue,'') <> '' THEN DD.BadValue + ' ' + ISNULL(DD.AdditionalInfo,'')
													ELSE 'Please check :- ' + ISNULL(RU.FieldName,'') + 
														CASE		WHEN ISNULL(RU.MetaMethod,'') <> '' THEN ' :- ' + ISNULL(RU.MetaMethod,'') 
																	ELSE ''
											END
											END,

GROUPING_DATA_OWNERS_ID					=	RUO.ID,
GROUPING_RULE_MASTER_ID					=	RUMG.ID,
GROUPING_RULE_ID						=	RU.ID,
GROUPING_IFS_SYSTEM_RULE_ID				=	RU.IsIfsSystemRule,
GROUPING_BUSINESS_RULE_ID				=	RU.IsBusinessRule,
LAST_DATA_LOAD_DATE						=	PFD.LAST_DATA_LOAD_DATE,
REPORT_SORT_ORDER_ID					=	RU.ImpactOnProject,

/* move to the where later */
PARAMETER_USER_GROUP_VALUE				=	RUMG.ID,
PARAMETER_DATA_OWNERS_VALUE				=	RUO.ID,
PARAMETER_RULES_VALUE					=	RU.ID,
PARAMETER_IFS_SYSTEM_RULE_ID			=	RU.IsIfsSystemRule,
PARAMETER_BUSINESS_RULE_ID				=	RU.IsBusinessRule
FROM @PRE_FILTER_ID_ITERATION PFD

INNER JOIN [DatasetSys].[DataDefect] DD
	ON PFD.ID_ITERATION = DD.ID_Iteration
INNER JOIN [ToBeDecided].[Rule] RU
	ON DD.[ID_Rule] = RU.ID
INNER JOIN [ToBeDecided].[RuleMasterGroup] RUMG
	ON RU.ID_MasterGroup = RUMG.ID
INNER JOIN [DatasetSys].[Rule_Owner] RUO
	ON RU.ID_OWNER = RUO.ID
WHERE RU.ID = @ID_RULE

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      Simon Hardstaff
  Description: SSRS Report parameter data to pull out the owner groups

  History:
  Ver	By					Date        Comments
  001	Simon Hardstaff		18-Mar-2020	Fist build

  =============================================*/

CREATE PROCEDURE [dbo].[USP_RPT_PARAMETER_RULE_OWNERS]
AS

	SET NOCOUNT ON

SELECT 
OwnerGroupValue				=	A.ID,
OwnerGroupLable				=	A.[Owner],
DisplaySortOrder			=	ROW_NUMBER() OVER(ORDER BY A.[Owner] ASC)
FROM 
[DatasetSys].[Rule_Owner] A

GO

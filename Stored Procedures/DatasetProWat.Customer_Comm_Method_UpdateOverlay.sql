SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*=============================================
  Author:      RYFE
  Description: Update Comm method overlay after new data cut is received

  V1	14/02/2022	RYFE	Created
=============================================*/
CREATE PROCEDURE [DatasetProWat].[Customer_Comm_Method_UpdateOverlay]
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @MIG_SITENAME varchar(5) = 'GBASP';
	

	---------------- Delete records that does not exist in the new cut -----------------------------------------------
	BEGIN TRANSACTION
		DELETE FROM [Dataset].[Customer_Comm_Method_ovl] 
		WHERE MIG_SITE_NAME = @MIG_SITENAME
		AND not exists (SELECT 1 FROM [Dataset].[Customer_Comm_Method_ex] t 
		               WHERE t.mig_site_name = @MIG_SITENAME
					   AND t.[IDENTITY] = [Dataset].[Customer_Comm_Method_ovl].[IDENTITY]
					   AND t.[COMM_ID] = [Dataset].[Customer_Comm_Method_ovl].[COMM_ID])
		COMMIT TRANSACTION
	---------------- UPDATE is suspect ---------------------------------------------------------
	
	


  UPDATE t1
  SET t1.IsSuspect = 1,t1.SRC_COMM_METHOD_VALUE = t2.[COMM_METHOD_VALUE]
  FROM [Dataset].[Customer_Comm_Method_ovl]   t1
  INNER JOIN [Dataset].[Customer_Comm_Method_ex]  t2
  ON t1.[IDENTITY] = t2.[IDENTITY] AND  t1.[COMM_ID] = t2.[COMM_ID]
  WHERE t1.[SRC_COMM_METHOD_VALUE] != t2.[COMM_METHOD_VALUE];


END


GO

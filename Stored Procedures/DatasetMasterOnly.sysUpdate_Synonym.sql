SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		DIH
-- Create date: 2019-11-06
-- Description:	Create all required synonymns
--
-- Note:
-- Prior to running this procedure, Functional.sym_Synonym & Functional.sym_Synonym_Control
-- MUST have ALREADY been linked to sysSynonym and sysSynonmy_control in the datasets database
--
--	Ver	Who		When			What
--	V2	DIH		22/02/2021		Added Pre and Post sript running.
--	V3	DIH		11/05/2021		Can handle {CALC} synonyms
--
-- =============================================
CREATE  PROCEDURE [DatasetMasterOnly].[sysUpdate_Synonym]
   @DbNum int = 2								-- Db_Num = 1 for Data cleansing
												-- Dn_Num = 2 for data extraction
												-- Db_Num = 1000 for Nexus_Tranform extraction.
												-- Db_Num = 1010 for Nexus_Master MDM database
AS

DECLARE
   @SynonymSchema varchar(100),
   @SynonymName varchar(100),
   @TargetTable varchar(100),
   @TargetSchema varchar(100),
   @DbName varchar(100),
   @SQL nvarchar(4000),
   @SQL_DROP nvarchar(4000),
   @SQL_CURRENT nvarchar(4000),
   @SQL_Script nvarchar(max),
   @RelativeOrder int,
   @ID int,
   @Detail varchar(255);


   PRINT 'Run PreProcess scripts';

   DECLARE PreRun_CURSOR CURSOR FOR
		SELECT [ScriptText], RelativeOrder, ID, Detail
			FROM [DatasetSys].[sysSynonym_UpdateScripts]
			WHERE	DB_NUM = @DbNum
				AND	IsActive = 1
				AND	IsPreScript = 1
			ORDER BY RelativeOrder

	OPEN PreRun_CURSOR

	FETCH NEXT FROM PreRun_CURSOR INTO    @SQL_Script, @RelativeOrder, @ID, @Detail

	WHILE @@FETCH_STATUS <> -1
		BEGIN
			PRINT 'Pre Process script - ' + 
				convert(varchar(8), @RelativeOrder) + 
				'/' + convert(varchar(8), @ID) +
				' - ' + @Detail;

			EXEC (@SQL_Script);

			FETCH NEXT FROM PreRun_CURSOR INTO    @SQL_Script, @RelativeOrder, @ID, @Detail
		END

	CLOSE PreRun_CURSOR
	DEALLOCATE PreRun_CURSOR



	--====================================================================================================



   DECLARE Synonmy_CURSOR CURSOR FOR 		
			SELECT	[SynonymSchema], [SynonymName],
					[TargetObjectSchema], [TargetObjectName],
					[DbName]
			FROM [DatasetSys].[sysSynonym]			SS
			JOIN [DatasetSys].[sysSynonym_Control]	SSC
			ON SS.DB_Num_ID = SSC.DB_Num_ID
			WHERE FlagActive = 1 AND ss.[DB_Num_ID] = @DbNum;

   	OPEN Synonmy_CURSOR

	FETCH NEXT FROM Synonmy_CURSOR INTO    @SynonymSchema, @SynonymName, @TargetSchema, @TargetTable, @DbName


	WHILE @@FETCH_STATUS <> -1
		BEGIN
			IF (@SynonymName = '{CALC}')
				BEGIN
					SET @SynonymName = @TargetTable + '_DcEx';
					SET @TargetTable = @TargetTable + '_' + @DbName 
					SET @DbName = '';
				END
			SET @SQL =  'CREATE SYNONYM [' + @SynonymSchema + '].['  + @SynonymName + '] FOR ' 
				+ @DbName + '.[' + @TargetSchema + '].[' + @TargetTable + ']'; 
			SET @SQL_DROP = 'DROP SYNONYM IF EXISTS [' + @SynonymSchema + '].[' + @SynonymName + ']'; 

			PRINT @SQL

			EXEC sp_executesql @SQL_DROP
			EXEC sp_executesql @SQL

			FETCH NEXT FROM Synonmy_CURSOR INTO @SynonymSchema, @SynonymName, @TargetSchema, @TargetTable, @DbName
		END

	CLOSE Synonmy_CURSOR
	DEALLOCATE Synonmy_CURSOR

	--========================================================================================================




   DECLARE PostRun_CURSOR CURSOR FOR
		SELECT [ScriptText], RelativeOrder, ID, Detail
			FROM [DatasetSys].[sysSynonym_UpdateScripts]
			WHERE	DB_NUM = @DbNum
				AND	IsActive = 1
				AND	IsPostScript = 1
			ORDER BY RelativeOrder

	OPEN PostRun_CURSOR

	FETCH NEXT FROM PostRun_CURSOR INTO    @SQL_Script, @RelativeOrder, @ID, @Detail;

	WHILE @@FETCH_STATUS <> -1
		BEGIN
			PRINT 'Post Process script - ' + 
				convert(varchar(8), @RelativeOrder) + 
				'/' + convert(varchar(8), @ID) +
				' - ' + @Detail;

			EXEC (@SQL_Script)

			FETCH NEXT FROM PostRun_CURSOR INTO    @SQL_Script, @RelativeOrder, @ID, @Detail;
		END

	CLOSE PostRun_CURSOR
	DEALLOCATE PostRun_CURSOR



	--=======================================================================================================

			 
	SET @SQL_CURRENT = 'UPDATE [DatasetSys].[sysSynonym_Control] SET [CurrentlyLinkedTo] = [DbName] WHERE [DB_Num_ID] = ' + convert(varchar(5),@DbNum);
	EXEC sp_executesql @SQL_CURRENT;

	PRINT 'Updated current db field';
GO

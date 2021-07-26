SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 25/06/2021
-- Description:	Check the interity of each synonym compared to the configuration information
-- =============================================
CREATE PROCEDURE [DatasetMasterOnly].[sysUpdate_Synonym_PostCheck]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		TReason.Reason,
		TReason.synonym_name,
		TReason.synonym_definition,
		TReason.server_name,
		TReason.[SynonymName],
		TReason.[DB_name],
		TReason.[schema_name],
		TReason.table_name,
		TReason.DB_Num_ID,
		TReason.DbName,
		TReason.TargetObjectSchema,
		TReason.TargetObjectName
		FROM (
				SELECT 
					CASE	
						WHEN	ISNULL(TDEF.DB_Num_ID,0) = 0
						THEN	'Missing definition'

						WHEN	(ISNULL(TCTRL.DbName,'') = '') AND (ISNULL(TDEF.DB_Num_ID,0) >= 0)
						THEN	'Target DB Missing'

						WHEN	ISNULL(TCTRL.DbName,'') <>  COALESCE (PARSENAME (base_object_name, 3), DB_NAME (DB_ID ())) AND (ISNULL(TDEF.DB_Num_ID,0) >= 0)
						THEN	'Target DB different'

						WHEN	ISNULL(TDEF.TargetObjectSchema,'') <>  COALESCE (PARSENAME (base_object_name, 2), SCHEMA_NAME (SCHEMA_ID ())) AND (ISNULL(TDEF.DB_Num_ID,0) >= 0)
						THEN	'Target schema different'

						WHEN	ISNULL(TDEF.TargetObjectName,'') <>  PARSENAME (base_object_name, 1) AND (ISNULL(TDEF.DB_Num_ID,0) >= 0)
						THEN	'Target Object different'

						ELSE 'OK'
					END as Reason,
					[name] AS synonym_name,																		-- Synonym
					[base_object_name] AS synonym_definition,													-- Server.Schema.Target
					COALESCE (PARSENAME (base_object_name, 4), @@servername) AS server_name,					-- Server name
					COALESCE (PARSENAME (base_object_name, 3), DB_NAME (DB_ID ())) AS DB_name,					-- Target Databse
					COALESCE (PARSENAME (base_object_name, 2), SCHEMA_NAME (SCHEMA_ID ())) AS schema_name,		-- Target Schema
					PARSENAME (base_object_name, 1) AS table_name,												-- Target object.
					create_date,
					modify_date,
					TDEF.[SynonymName],
					TDEF.DB_Num_ID,
					TDEF.TargetObjectSchema,
					TDEF.TargetObjectName,
					TCTRL.DbName
				FROM		sys.synonyms						TSYM
				LEFT JOIN	[DatasetSys].[sysSynonym]			TDEF
					ON		TSYM.[name] = TDEF.SynonymName
				LEFT JOIN	[DatasetSys].[sysSynonym_Control]	TCTRL
					ON		TDEF.DB_Num_ID = TCTRL.DB_Num_ID

			UNION

				SELECT 
					CASE
						WHEN	ISNULL([name],'') =''
						THEN	'Missing synonym'
						ELSE'OK'
					END  as Reason,
					'' AS synonym_name,																		-- Synonym
					'' as synonym_definition,													-- Server.Schema.Target
					'' AS server_name,					-- Server name
					'' DB_name,					-- Target Databse
					'' schema_name,		-- Target Schema
					'' table_name,												-- Target object.
					GetDate(),
					GetDate(),
					TDEF.[SynonymName],
					TDEF.DB_Num_ID,
					TDEF.TargetObjectSchema,
					TDEF.TargetObjectName,
					TCTRL.DbName
				FROM		[DatasetSys].[sysSynonym]			TDEF
				LEFT JOIN 	sys.synonyms						TSYM
					ON		TDEF.SynonymName = TSYM.base_object_name 
				LEFT JOIN	[DatasetSys].[sysSynonym_Control]	TCTRL
					ON		TDEF.DB_Num_ID = TCTRL.DB_Num_ID
				WHERE	TDEF.DB_Num_ID >= 2000
			) as  TReason
		WHERE TReason.Reason <> 'OK'

END
GO

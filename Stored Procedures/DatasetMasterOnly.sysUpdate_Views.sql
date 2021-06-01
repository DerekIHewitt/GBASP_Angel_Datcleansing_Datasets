SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 13/04/2021
-- Description:	Reset the cached meta data for each view.
--				After connecting synonyms to a new data source, the
--				view meta data remains cached in the view and dosn't 
--				always get updated for the views. This procedure should be
--				run after a schema drop/create to ensure that the views
--				are connected to the correct databases.
-- =============================================
CREATE PROCEDURE [DatasetMasterOnly].[sysUpdate_Views] AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Schema varchar(100), @View varchar(100);
	DECLARE @FullViewName varchar(255);
	PRINT 'Build cursor of DB views.';

   DECLARE View_CURSOR CURSOR FOR
		SELECT 	
			OBJECT_SCHEMA_NAME(v.object_id) schema_name,
			v.name
		FROM 
			sys.views as v;


	OPEN View_CURSOR
	FETCH NEXT FROM View_CURSOR INTO    @Schema, @View

	WHILE @@FETCH_STATUS <> -1
		BEGIN
			SET @FullViewName = '[' + @Schema + '].[' + @View + ']';
			IF (@Schema not in ('ToBeDecided'))
				BEGIN
					PRINT 'Pre reset view - ' +  @FullViewName;
					EXECUTE sp_refreshview  @viewname = @FullViewName;
				END
			ELSE
				BEGIN
					PRINT 'skip view - ' +  @FullViewName;
				END
			FETCH NEXT FROM View_CURSOR INTO    @Schema, @View
		END


	print 'Clean up.'
	CLOSE View_CURSOR
	DEALLOCATE View_CURSOR
	PRINT 'Done.';
END
GO

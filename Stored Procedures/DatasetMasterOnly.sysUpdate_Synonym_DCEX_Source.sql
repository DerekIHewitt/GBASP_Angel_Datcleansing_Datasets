SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 19/04/2022
-- Description:	During migration,   EX data can come from [custom views] or from EX_Filtered views.
--									The EX_Filtered views use the _DcEx synonyms and can be connected to either the DC or the EX stagging tables.
--				During Acquisition, EX data will come from the EX_Filtered views.
--									The EX_Filtered views use the _DcEx synonyms that should be connected to DC stagging tables.
--				This procedure is used to set the _DcEx Synonyms 
--				So they either point to either the DC stagging tables or the EX stagging tables.
-- =============================================
CREATE PROCEDURE [DatasetMasterOnly].[sysUpdate_Synonym_DCEX_Source]
	-- Add the parameters for the stored procedure here
	@Print_The_Instructions  bit = 1,
	@I_Have_Read_The_Instructions bit = 0,
	@Use_DcStaggingData_AlsoAs_ExStaggingData bit = 0
AS
BEGIN
    DECLARE @ExIsFrom varchar(50);
	DECLARE	@return_value int

	SET NOCOUNT ON;
	IF (@Use_DcStaggingData_AlsoAs_ExStaggingData is null)
		BEGIN
			SET @Print_The_Instructions = 1;
			SET @I_Have_Read_The_Instructions = 0;
		END
	SET @I_Have_Read_The_Instructions = ISNULL(@I_Have_Read_The_Instructions,0);
	IF ( @I_Have_Read_The_Instructions = 0)
			SET @Print_The_Instructions = 1;

	IF ( @Print_The_Instructions = 1)
		BEGIN
			PRINT 'During migration,'
			PRINT '  EX data can come from [custom views] or from the EX_Filtered views.';
			PRINT '  The EX_Filtered views use the _DcEx synonyms and can be connected to either the DC or the EX stagging tables.'
			PRINT '  The norm when using the EX_Filtered views for migration would be to connect the _DcEx synonmys to the EX stagging tables'
			PRINT ''
			PRINT 'During Acquisition,'
			PRINT '  EX data will come from the EX_Filtered views using the _DcEx synonyms.'
			PRINT '  The _DcEx synonyms should be connected to DC stagging tables'
			PRINT '  so that the EX_Filtered views also use the DC stagging data.'
			PRINT ''
			PRINT 'Usage:'
			PRINT '  If doing a migration and using [custom views], there is no need to run this procedure.'
			PRINT ''
			PRINT '  If doing a migration and using the EX_Filtered views for data loaded in the EX stagging tables, '
			PRINT '    set @Use_DcStaggingData_AlsoAs_ExStaggingData = 0 and '
			PRINT '    set @I_Have_Read_The_Instructions = 1.'
			PRINT ''
			PRINT '  If doing a migration and using the EX_Filtered views for data loaded in the DC stagging tables, '
			PRINT '    Firstly, are you sure this is what you really want to do as it is very odd? If that is what you really need to do, then,'
			PRINT '    set @Use_DcStaggingData_AlsoAs_ExStaggingData = 1 and '
			PRINT '    set @I_Have_Read_The_Instructions = 1.'
			PRINT ''
			PRINT '  If doing an acquisition (using the EX_Filtered views), the DC stagging data will also be '
			PRINT '    used for the EX Stagging data (no point loading it twice). So, '
			PRINT '    set @Use_DcStaggingData_AlsoAs_ExStaggingData = 1 and '
			PRINT '    set @I_Have_Read_The_Instructions = 1.'
		END

	IF (@I_Have_Read_The_Instructions = 0) GOTO Thats_All_Folks;


	PRINT ''
	PRINT 'Updating sysSynonymControl'
	IF ( @Use_DcStaggingData_AlsoAs_ExStaggingData = 0)
		SET @ExIsFrom = 'EX';
	else
		SET @ExIsFrom = 'DC';

	UPDATE [DatasetSys].[sysSynonym_Control]
	   SET [DbName] = @ExIsFrom
		WHERE [DB_Num_ID] = 2100


	PRINT '';
	PRINT 'Updaing the _DcEx synonyms.'
	EXEC @return_value = [DatasetMasterOnly].[sysUpdate_Synonym]
		 @DbNum = 2100,					-- Select the _DcEx synonyms.
		 @LinkForAcquisition = 0;		-- these are {Calc} types so this is ignored 



Thats_All_Folks:
	Print '';
	Print 'Routine exited';
END
GO

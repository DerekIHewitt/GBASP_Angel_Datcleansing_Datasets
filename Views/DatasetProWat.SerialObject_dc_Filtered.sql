SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DatasetProWat].[SerialObject_dc_Filtered]
AS
SELECT        ROW_NUMBER() OVER (ORDER BY EQH_IDNo) AS ID, 'GBASP' [MIG_SITE_NAME], '' AS MIG_COMMENT, getdate() AS MIG_CREATED_DATE, 
[EQH_IDNo] [MCH_CODE]/*{UID for machine?}				--UID in legacy system to be mapped to a unique IFS number for the piece of equipment*/ , ISNULL(T_ST.STO_Description, '') [MCH_NAME]/*Description for the piece of customer equiment*/ , 
[EQH_Account] [CUSTOMER_ID]/*Legacy account code to map to an IFS account for the address the machine is at.*/ , [EQH_Stock_Code] [PART_NO]/*----------------------------------------------------------*/ , 
[EQH_ID] [SERIAL_NO]/*-----------------------------------------------------------*/ , Dataset.ConvertProwatDate(EQH_INSTALL_DATE, '2009-01-01') [INSTALLATION_DATE]/*{Dates apear to be days offset from 01/01/1800}		--Date the machinewas installed.*/ , 
TRIM(ISNULL(EQH_Status_Flag, '{NULL}')) [OWNERSHIP], TRIM(LEFT(ISNULL([EQH_Location], ''), 10)) [LOCATION1], TRIM(SUBSTRING(ISNULL([EQH_Location], '') + space(15), 11, 15)) [LOCATION2], '' AS [OWNER], '' [NX_LATITUDE], 
'' [NX_LONGITUDE], 'IN_OPERATION' AS NX_OPERATIONAL_STATUS, ISNULL(HAS_PEDAL, '') AS NX_HAS_PEDAL, Dataset.ConvertProwatDate(eqh_WarEndDate, '') AS NX_WARRANTY_END_DATE,Dataset.Filter_SerialObject('GBASP', 'dc', ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysIncluded, 0), 
ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.SerialObject_Filter_Override.IsOnSubsetList, 0), '', ISNULL(DatasetProWat.Syn_Customer_dc.CUS_Type, '{NULL}'), Dataset.Filter_Customer('GBASP', 
'dc', ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), EQH_Account, 
LEFT(TRIM(DatasetProWat.Syn_Customer_dc.CUS_Company), 100), ISNULL(DatasetProWat.Syn_Customer_dc.CUS_Type, '{NULL}'))) AS NX_FILTER_STATUS
FROM            DatasetProWat.Syn_EquipHdr_dc T_EH LEFT JOIN
                         DatasetProWat.[Syn_Stock_dc] T_ST ON T_EH.EQH_Stock_Code = T_ST.STO_Stock_Code LEFT JOIN
                         Dataset.Customer_Filter_Override ON Dataset.Customer_Filter_Override.MIG_SITE_NAME = 'GBASP' AND Dataset.Customer_Filter_Override.CUSTOMER_ID = T_EH.EQH_Account LEFT JOIN
                         Dataset.SerialObject_Filter_Override ON 'GBASP' = Dataset.SerialObject_Filter_Override.MIG_SITE_NAME AND T_EH.EQH_IDNo = Dataset.SerialObject_Filter_Override.MCH_CODE LEFT JOIN
                         DatasetProWat.Syn_Customer_dc ON DatasetProWat.Syn_Customer_dc.CUS_Account = T_EH.EQH_Account LEFT JOIN
                         DatasetProWat.Syn_EQTYPE_dc T_ET ON T_ET.ety_id = T_ST.sto_eqtype LEFT JOIN
                             (SELECT        EQH_IDNO AS PEDAL_ID, REPLACE(REPLACE(SUBSTRING(EQH_ID, 4, 100), ' ', ''), '-', '') AS SERIALLINK, '1' AS HAS_PEDAL, STO_Description AS pedal_name
                               FROM            DatasetProWat.Syn_EquipHdr_dc EQ JOIN
                                                         DatasetProWat.Syn_Customer_dc C ON C.CUS_ACCOUNT = EQ.EQH_ACCOUNT JOIN
                                                         DatasetProWat.Syn_Stock_dc ST ON st.sto_stock_code = eq.eqh_stock_code JOIN
                                                         DatasetProWat.Syn_EQTYPE_dc ET ON et.ety_id = st.sto_eqtype
                               WHERE        et.ety_name LIKE 'PEDAL') PDL ON PDL.SERIALLINK = T_EH.EQH_ID
WHERE        (Dataset.Filter_SerialObject('GBASP', 'dc', ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysIncluded, 0), ISNULL(Dataset.SerialObject_Filter_Override.IsAlwaysExcluded, 0), 
                         ISNULL(Dataset.SerialObject_Filter_Override.IsOnSubsetList, 0), '', ISNULL(DatasetProWat.Syn_Customer_dc.CUS_Type, '{NULL}'), Dataset.Filter_Customer('GBASP', 'dc', 
                         ISNULL(Dataset.Customer_Filter_Override.isAlwaysIncluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsAlwaysExcluded, 0), ISNULL(Dataset.Customer_Filter_Override.IsOnSubSetList, 0), T_EH.EQH_Account, 
                         LEFT(TRIM(DatasetProWat.Syn_Customer_dc.CUS_Company), 100), ISNULL(DatasetProWat.Syn_Customer_dc.CUS_Type, '{NULL}'))) > 0) AND T_ET.ety_name NOT LIKE 'PEDAL' AND 
                         T_ET.ety_name NOT LIKE 'Management Fee' AND T_ET.ety_name NOT IN ('Recycling Scheme', 'Ancilliaries & Racks', 'Vending m/c')
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[30] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'DatasetProWat', 'VIEW', N'SerialObject_dc_Filtered', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DatasetProWat', 'VIEW', N'SerialObject_dc_Filtered', NULL, NULL
GO

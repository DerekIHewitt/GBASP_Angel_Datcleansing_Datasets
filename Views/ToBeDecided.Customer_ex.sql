SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ToBeDecided].[Customer_ex]
AS
SELECT        CUS_Account, CUS_Company, CUS_Addr1, CUS_Addr2, CUS_Addr3, CUS_County, CUS_PCode, CUS_Tel, CUS_Tel2, CUS_Fax, CUS_Fax2, CUS_EMail1, CUS_EMail2, CUS_Contact1, CUS_Contact2, CUS_SageCode, 
                         CUS_SageFlag, CUS_Charge_VAT, CUS_Exempt_Num, CUS_Instruct1, CUS_Instruct2, CUS_MapRef, CUS_Lat, CUS_Lng, CUS_Currency, CUS_ProCon, CUS_Staff, CUS_HHLastSig, CUS_Acct_To_Inv, CUS_Type, CUS_RouteID, 
                         CUS_Seq, CUS_SaniRouteID, CUS_SaniSeq, CUS_RepNum, CUS_StatusFlag, CUS_Equiry_Srce, CUS_EDIType, CUS_EDIAccount, CUS_Industry, CUS_ACGroup, CUS_PriceBookAC, CUS_ContactType, CUS_Recall, 
                         CUS_Last_Contact, CUS_Next_Contact, CUS_P_FLAG, CUS_Trial_End, CUS_Call_Flag, CUS_CustOrder, CUS_PORent, CUS_POSani, CUS_POEL, CUS_POSWR, CUS_POReq, CUS_COD, CUS_DNReq, CUS_PrePay, 
                         CUS_PayType, CUS_InvType, CUS_PayTerms, CUS_HHDNMethod, CUS_StatMethod, CUS_Statement1, CUS_Statement2, CUS_Statement3, CUS_CallFlag, CUS_InvACPBook, CUS_Inv1st, CUS_Spare1, CUS_Spare2, 
                         CUS_Spare3, CUS_Spare4, CUS_Spare5, CUS_Spare6, CUS_Credit_Limit, CUS_Balance, CUS_Oldest, CUS_Bottles1, CUS_Bottles2, CUS_Bottles3, CUS_Bottles4, CUS_Bottles5, CUS_Bottles6, CUS_Bottles7, CUS_Bottles8, 
                         CUS_FOC1, CUS_FOC2, CUS_FOC3, CUS_FOC4, CUS_FOC5, CUS_FOC6, CUS_FOC7, CUS_FOC8, CUS_PP1, CUS_PP2, CUS_PP3, CUS_PP4, CUS_PP5, CUS_PP6, CUS_PP7, CUS_PP8, CUS_Days_Credit, CUS_Month1, 
                         CUS_Month2, CUS_Month3, CUS_Month4, CUS_Month5, CUS_CoolDep, CUS_CoolDeps, CUS_CoolDepVal, CUS_BotDep, CUS_ACName, CUS_ACSortCode, CUS_ACNumber, CUS_DDActivate, CUS_CCName, CUS_CCNumber, 
                         CUS_CCTypeID, CUS_CCFrom, CUS_CCExpiry, CUS_CCIssue, CUS_CCAuthDate, CUS_WebUser, CUS_WebPW, CUS_WebMaxVal, CUS_DepotID, CUS_Created, CUS_Mobile1, CUS_Mobile2, CUS_Position1, CUS_Position2, 
                         CUS_KeyACFlag, CUS_DMName, CUS_DMPhone, CUS_DMFax, ISNULL(CUS_DMEMail, '') AS CUS_DMEMail, CUS_DMPosition, CUS_DMMob, CUS_PKGAccount, CUS_Instruct3, CUS_Instruct4, CUS_Instruct5, CUS_TermDate, 
                         CUS_PKStockID, CUS_PriceFixDate, CUS_InvCons, CUS_Priority, CUS_POSaniReq, CUS_PrePkgType, CUS_NOTES, CUS_PODate, CUS_PORentDate, CUS_POSaniDate, CUS_POELDate, CUS_InvEachDel, CUS_SectorID, 
                         CUS_TraceDate, CUS_LegalDate, CUS_WaterDate, CUS_ExcludeInvAll, CUS_ExcludeCharity, CUS_CharityCurrYear, CUS_CharityPrevYear, CUS_RentDates, CUS_PaperInvCharge, CUS_Spare7, CUS_Spare8, CUS_Spare9, 
                         CUS_Spare10, CUS_Spare11, CUS_Spare12, CUS_HHLastSig3, CUS_ACSubGrp, CUS_ContractDate, CUS_BookIn, CUS_OpenAM, CUS_CloseAM, CUS_OpenPM, CUS_ClosePM, CUS_VanOnly, CUS_WorkTime, 
                         CUS_LastUpdatedID, CUS_LastUpdated, CUS_OpenAMDay1, CUS_OpenAMDay2, CUS_OpenAMDay3, CUS_OpenAMDay4, CUS_OpenAMDay5, CUS_OpenAMDay6, CUS_OpenAMDay7, CUS_OpenPMDay1, CUS_OpenPMDay2, 
                         CUS_OpenPMDay3, CUS_OpenPMDay4, CUS_OpenPMDay5, CUS_OpenPMDay6, CUS_OpenPMDay7, CUS_AcqFrom, CUS_AcqVerified, CUS_AcqOKDate, CUS_AcqOKTime, CUS_AcqOKUser, CUS_LastWaterDate, 
                         CUS_LastCupsDate, CUS_OpenToHH, CUS_Spare13, CUS_Spare14, CUS_Spare15, CUS_Spare16, CUS_Spare17, CUS_Spare18, CUS_Spare19, CUS_Spare20, CUS_Spare21, CUS_Spare22, CUS_Spare23, CUS_Spare24, 
                         CUS_Spare25, CUS_Spare26, CUS_Spare27, CUS_Spare28, CUS_Spare29, CUS_Spare30, CUS_DefStockID, CUS_InvDaily, CUS_ImportAC, CUS_CredContID, CUS_WLUKTerms, CUS_Migrate, CUS_MigratedOn, 
                         CUS_DefStockQty, CUS_GDPRDate, CUS_GDPRContact, CUS_GDPRUserID, CUS_GDPRCLogID, CUS_Ext1, CUS_Ext2, CUS_Ext3, CUS_NoAddToEMail, CUS_CDtAddr, CUS_CByAddr, CUS_CDtTel1, CUS_CByTel1, CUS_CDtTel2, 
                         CUS_CByTel2, CUS_CDtTel3, CUS_CByTel3, CUS_CDtExt1, CUS_CByExt1, CUS_CDtExt2, CUS_CByExt2, CUS_CDtExt3, CUS_CByExt3, CUS_CDtEM1, CUS_CByEM1, CUS_CDtEM2, CUS_CByEM2, CUS_CDtEM3, CUS_CByEM3, 
                         CUS_CDtName1, CUS_CByName1, CUS_CDtName2, CUS_CByName2, CUS_CDtName3, CUS_CByName3, CUS_CDtPos1, CUS_CByPos1, CUS_CDtPos2, CUS_CByPos2, CUS_CDtPos3, CUS_CByPos3, CUS_EquipmentOnly, 
                         dbo.Filter_Customer('ex', CUS_Account, CUS_Company, CUS_Type) AS CUS_Filter_Status
FROM            dbo.Syn_Customer_ex
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "Syn_Customer_ex"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 280
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
         Alias = 2850
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
', 'SCHEMA', N'ToBeDecided', 'VIEW', N'Customer_ex', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'ToBeDecided', 'VIEW', N'Customer_ex', NULL, NULL
GO

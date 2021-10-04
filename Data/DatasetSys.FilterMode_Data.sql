SET IDENTITY_INSERT [DatasetSys].[FilterMode] ON
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (1, 'NEXUS', N'Customer', 'dc', 2, N'All records (no filters but indicate the ones that would have been dropped)')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (2, 'NEXUS', N'Customer', 'ex', 3, N'Unfiltered subset')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (3, '', N'FilterModes', '1', 1, N'Comment entry- All records (no filters but indicate the ones that would have been dropped)')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (4, '', N'FilterModes', '2', 2, N'Comment entry- Records that pass the filter (take on data)')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (5, '', N'FilterModes', '3', 3, N'Comment entry- Unfiltered subset')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (6, '', N'FilterModes', '4', 4, N'Comment entry- Filtered subset')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (7, 'NEXUS', N'SerialObject', 'dc', 2, N'All records (no filters but indicate the ones that would have been dropped)')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (8, 'NEXUS', N'SerialObject', 'ex', 3, N'Unfiltered subset')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (9, 'NEXUS', N'Stock', 'dc', 2, N'All records (no filters but indicate the ones that would have been dropped)')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (10, 'NEXUS', N'Stock', 'ex', 3, N'Unfiltered subset')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (11, 'NEXUS', N'Supplier', 'dc', 2, N'Records that pass the filter (take on data)')
INSERT INTO [DatasetSys].[FilterMode] ([ID], [MIG_SITE_NAME], [DataType], [Scope], [CurrentMode], [CurrentModeDescription]) VALUES (12, 'NEXUS', N'Supplier', 'ex', 2, N'Records that pass the filter (take on data)')
SET IDENTITY_INSERT [DatasetSys].[FilterMode] OFF

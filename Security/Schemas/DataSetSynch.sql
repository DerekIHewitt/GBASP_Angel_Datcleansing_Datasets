CREATE SCHEMA [DataSetSynch]
AUTHORIZATION [dbo]
GO
EXEC sp_addextendedproperty N'Detail', N'The DatasetSynch schema contaions the objects required for synchronising a remote database to the UK server. There is a corrisponding schema FunctionalSynch  in the functional database.', 'SCHEMA', N'DataSetSynch', NULL, NULL, NULL, NULL
GO

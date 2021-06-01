CREATE SCHEMA [ToBeDecided]
AUTHORIZATION [dbo]
GO
EXEC sp_addextendedproperty N'Detail', N'The ToBeDecided schema relates to objects that were already in the database used as a template to create the Datasets database but no decision has been mad as to if they are requred or not. In the fullness of time, these objects should either be edited to work with one of the other schemas or removed from the database.', 'SCHEMA', N'ToBeDecided', NULL, NULL, NULL, NULL
GO

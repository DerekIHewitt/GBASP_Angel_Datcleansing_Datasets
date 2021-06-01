CREATE SCHEMA [DatasetSys]
AUTHORIZATION [dbo]
GO
EXEC sp_addextendedproperty N'Details', N'The DatasetSys schema is the default schema. Objects that contain the raw data being processed should be in the Datasets Schema and Objects related to remote database synchronisation should be in the DatasetSynch schema. All other objects should be in the DatasetSys schema as they relate to manging the database and the processing of the data.', 'SCHEMA', N'DatasetSys', NULL, NULL, NULL, NULL
GO

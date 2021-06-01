CREATE SCHEMA [Dataset]
AUTHORIZATION [dbo]
GO
EXEC sp_addextendedproperty N'Details', N'The Dataset schema contains all the tables that contain the migration or aquisition data. If an object is not directly related to the actual data that is being processed, it should be in the DatasetSys schema.', 'SCHEMA', N'Dataset', NULL, NULL, NULL, NULL
GO

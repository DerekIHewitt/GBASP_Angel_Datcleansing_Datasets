CREATE TABLE [Dataset].[Open_Cases_Object_ex]
(
[PK] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LEGACY_CASE_ID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OBJECT_TYPE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SITE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OBJECT_ID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MIG_CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Open_Cases_Object_ex_MIG_CREATED_DATE] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Open_Cases_Object_ex] ADD CONSTRAINT [PK_Open_Cases_Object_ex] PRIMARY KEY CLUSTERED  ([PK]) ON [PRIMARY]
GO

CREATE TABLE [Dataset].[Customer_ContactNotes_dc]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MIG_SITE_NAME] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER_ID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CONTACT_NAME] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_ContactNotes_dc_CONTACT_NAME] DEFAULT (''),
[CONTACT_USER] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_ContactNotes_dc_CONTACT_USER] DEFAULT (''),
[NOTE_DATE] [datetime] NOT NULL,
[NOTE_SHORT] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NOTE_LONG] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_ContactNotes_dc_NOTE_LONG] DEFAULT (''),
[NOTE_REASON] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Customer_ContactNotes_dc_NOTE_REASON] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [Dataset].[Customer_ContactNotes_dc] ADD CONSTRAINT [PK_Customer_ContactNotes_dc] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of external person (ie at the customer) contacted', 'SCHEMA', N'Dataset', 'TABLE', N'Customer_ContactNotes_dc', 'COLUMN', N'CONTACT_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of account the person who contacted the customer is.', 'SCHEMA', N'Dataset', 'TABLE', N'Customer_ContactNotes_dc', 'COLUMN', N'CONTACT_USER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Legacy ID for customer account', 'SCHEMA', N'Dataset', 'TABLE', N'Customer_ContactNotes_dc', 'COLUMN', N'CUSTOMER_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date that the contact was made', 'SCHEMA', N'Dataset', 'TABLE', N'Customer_ContactNotes_dc', 'COLUMN', N'NOTE_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Full text version and detail of the note', 'SCHEMA', N'Dataset', 'TABLE', N'Customer_ContactNotes_dc', 'COLUMN', N'NOTE_LONG'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reason that prompted the contact', 'SCHEMA', N'Dataset', 'TABLE', N'Customer_ContactNotes_dc', 'COLUMN', N'NOTE_REASON'
GO

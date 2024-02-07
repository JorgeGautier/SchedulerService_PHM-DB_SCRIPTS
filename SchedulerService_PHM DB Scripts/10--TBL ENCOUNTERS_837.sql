USE [SCDB_QA]
GO

/****** Object:  Table [dbo].[ENCOUNTERS_837]    Script Date: 1/9/2024 6:36:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENCOUNTERS_837]') AND type in (N'U'))
DROP TABLE [dbo].[ENCOUNTERS_837]
GO

/****** Object:  Table [dbo].[ENCOUNTERS_837]    Script Date: 1/9/2024 6:36:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ENCOUNTERS_837](
	[ID] [varchar](10) NOT NULL,
	[FILE_NAME] [varchar](250) NULL
) ON [PRIMARY]
GO



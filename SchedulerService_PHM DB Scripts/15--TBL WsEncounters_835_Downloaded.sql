USE [SCDB_MMM]
GO
/****** Object:  Index [IX_835_Downloaded_FILENAME]    Script Date: 1/25/2024 9:50:23 AM ******/
DROP INDEX IF EXISTS [IX_835_Downloaded_FILENAME] ON [dbo].[WsEncounters_835_Downloaded]
GO
/****** Object:  Table [dbo].[WsEncounters_835_Downloaded]    Script Date: 1/25/2024 9:50:23 AM ******/
DROP TABLE IF EXISTS [dbo].[WsEncounters_835_Downloaded]
GO
/****** Object:  Table [dbo].[WsEncounters_835_Downloaded]    Script Date: 1/25/2024 9:50:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WsEncounters_835_Downloaded](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FILE_NAME] [varchar](1000) NULL,
	[LAST_WRITE_DATE] [datetime] NULL,
	[LOG_DATE] [datetime] NULL,
 CONSTRAINT [PK_WsEncounters_835_Downloaded] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_835_Downloaded_FILENAME]    Script Date: 1/25/2024 9:50:23 AM ******/
CREATE NONCLUSTERED INDEX [IX_835_Downloaded_FILENAME] ON [dbo].[WsEncounters_835_Downloaded]
(
	[LOG_DATE] DESC
)
INCLUDE([FILE_NAME]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

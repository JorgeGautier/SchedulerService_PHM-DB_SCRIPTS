USE [SCDB_MMM]
GO
/****** Object:  Table [dbo].[WsEncounters_SFTP_Received_TMP]    Script Date: 1/25/2024 9:48:53 AM ******/
DROP TABLE IF EXISTS [dbo].[WsEncounters_SFTP_Received_TMP]
GO
/****** Object:  Table [dbo].[WsEncounters_SFTP_Received_TMP]    Script Date: 1/25/2024 9:48:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WsEncounters_SFTP_Received_TMP](
	[LAST_WRITE_DATE] [datetime] NULL,
	[LENGTH] [int] NULL,
	[FILE_NAME] [varchar](1000) NULL
) ON [PRIMARY]
GO

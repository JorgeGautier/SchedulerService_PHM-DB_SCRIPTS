USE [SCDB_MMM]
GO
/****** Object:  StoredProcedure [dbo].[GET_NONPROCESSED_FILES]    Script Date: 1/25/2024 9:51:22 AM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_NONPROCESSED_FILES]
GO
/****** Object:  StoredProcedure [dbo].[GET_NONPROCESSED_FILES]    Script Date: 1/25/2024 9:51:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE GAUTIER
-- Create date: 1-13-2024
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GET_NONPROCESSED_FILES] (@LOG_DATE DATE)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT W.[FILE_NAME]
	FROM WsEncounters_SFTP_Received_TMP W  
	WHERE NOT EXISTS
			(SELECT [FILE_NAME] FROM WsEncounters_277_Downloaded D WHERE W.[FILE_NAME]=D.[FILE_NAME]
			AND D.LOG_DATE > '2022-01-01')
		AND W.[LENGTH] > 0
		AND W.[FILE_NAME] LIKE '%.277'

	SELECT W.[FILE_NAME]
	FROM WsEncounters_SFTP_Received_TMP W  
	WHERE NOT EXISTS
			(SELECT [FILE_NAME] FROM WsEncounters_835_Downloaded D WHERE W.[FILE_NAME]=D.[FILE_NAME]
			AND D.LOG_DATE > '2022-01-01')
		AND W.[LENGTH] > 0
		AND W.[FILE_NAME] LIKE '%.835'

	--SELECT [FILE_NAME]
	--FROM WsEncounters_835_Downloaded W  
	--WHERE NOT EXISTS
	--	(SELECT [FILE_NAME] FROM WsEncounters_SFTP_Received_TMP D WHERE W.[FILE_NAME]=D.[FILE_NAME])
	--	AND W.LOG_DATE > '2022-01-01'


	TRUNCATE TABLE WsEncounters_SFTP_Received_TMP

END









GO

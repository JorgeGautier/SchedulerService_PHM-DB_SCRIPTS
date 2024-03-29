USE [SCDB]
GO
/****** Object:  StoredProcedure [dbo].[ENCOUNTERS_CHANGE_STATUS_RESEND_MANUALLY]    Script Date: 11/21/2023 3:32:36 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ENCOUNTERS_CHANGE_STATUS_RESEND_MANUALLY]
GO
/****** Object:  StoredProcedure [dbo].[ENCOUNTERS_CHANGE_STATUS_RESEND_MANUALLY]    Script Date: 11/21/2023 3:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE GAUTIER
-- Create date: 11-20-2023
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ENCOUNTERS_CHANGE_STATUS_RESEND_MANUALLY] (@INSURANCE VARCHAR(50), @IPA_NUM VARCHAR(200), @STATUS VARCHAR(50), @FROM_SERV VARCHAR(20), @TO_SERV VARCHAR(20))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @QRY VARCHAR(500);
	SET @QRY =  'UPDATE R SET [STATUS] = -4 ' +  --'SELECT * ' +
				'FROM REF_HISTORY_MASTER R WHERE IS_ENCOUNTER = 1 ' 
				IF @INSURANCE <> ''
				BEGIN
					SET @QRY += 'AND INSURANCE IN ('+@INSURANCE+') ' 
				END
				IF @IPA_NUM <> ''
				BEGIN
					SET @QRY += 'AND IPA_NUM IN ('+@IPA_NUM+') ' 
				END
				SET @QRY +='AND FROM_DATE BETWEEN '+ @FROM_SERV +' AND '+ @TO_SERV +' ' + 
				'AND [STATUS] IN ('+@STATUS+') ';
	EXECUTE(@QRY);
END
GO

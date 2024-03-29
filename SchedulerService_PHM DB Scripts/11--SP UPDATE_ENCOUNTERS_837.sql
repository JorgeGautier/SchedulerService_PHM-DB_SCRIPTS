USE [SCDB_QA]
GO
/****** Object:  StoredProcedure [dbo].[UPDATE_ENCOUNTERS_837_SEND_MANUALLY]    Script Date: 1/9/2024 6:39:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE GAUTIER
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_ENCOUNTERS_837] (@STATUS VARCHAR(1))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


		UPDATE R SET [STATUS] = 3 
		FROM REF_HISTORY_MASTER R INNER JOIN ENCOUNTERS_837 E ON R.ID = E.ID
		WHERE [STATUS] <> 6

		/* INSERT PROCESSED ENCOUNTERS IN TBL ENCOUNTERS_LOG */
		INSERT INTO ENCOUNTERS_LOG 
		SELECT ID, GETDATE(), 'SENT', 'ENCOUNTER SENT TO THE INSURANCE COMPANY.', [FILE_NAME]
		FROM ENCOUNTERS_BATCH_837

END

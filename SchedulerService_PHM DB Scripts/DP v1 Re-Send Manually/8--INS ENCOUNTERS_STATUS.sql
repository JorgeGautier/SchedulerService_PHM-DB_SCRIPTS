USE [SCDB]
GO
/****** Object:  StoredProcedure [dbo].[UPDATE_ENCOUNTERS_837_SENT]    Script Date: 11/16/2023 2:23:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE GAUTIER
-- Create date: 11-01-2023
-- Description:	<Description,,>
-- =============================================


INSERT INTO ENCOUNTERS_STATUS VALUES (-4, 'Resend Manually')
GO
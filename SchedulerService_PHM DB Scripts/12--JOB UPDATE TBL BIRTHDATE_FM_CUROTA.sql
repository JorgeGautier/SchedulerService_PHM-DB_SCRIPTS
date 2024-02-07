USE [msdb]
GO

/****** Object:  Job [UPDATE TBL BIRTHDATE_FM_CUROTA]    Script Date: 1/9/2024 11:02:42 AM ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'f7376a66-98db-4aac-832b-bf6ad9a17903', @delete_unused_schedule=1
GO

/****** Object:  Job [UPDATE TBL BIRTHDATE_FM_CUROTA]    Script Date: 1/9/2024 11:02:42 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Data Collector]    Script Date: 1/9/2024 11:02:43 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Data Collector' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Data Collector'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'UPDATE TBL BIRTHDATE_FM_CUROTA', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'Data Collector', 
		@owner_login_name=N'scuser', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [TRUNCATE TBL]    Script Date: 1/9/2024 11:02:44 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'TRUNCATE TBL', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'TRUNCATE TABLE BIRTHDATE_FM_CUROTA', 
		@database_name=N'SCDB_QA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [INSERT TO TBL BIRTHDATE_FM_CUROTA]    Script Date: 1/9/2024 11:02:44 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'INSERT TO TBL BIRTHDATE_FM_CUROTA', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO BIRTHDATE_FM_CUROTA
SELECT ''00''+CONVERT(VARCHAR,CONTRATO), CONVERT(DATE,BIRTHDATE)
FROM OPENDATASOURCE(''SQLNCLI'',''Data Source=CUROTA;User ID=scuser;Password=SmartCap_2019;'').CDTNet.dbo.tblElegibilidadVital  
WHERE 
	 EFFECTIVEDATE >= DATEADD(MONTH,-12,GETDATE())
	AND BIRTHDATE <> ''01/01/1900'' 
	AND BIRTHDATE IS NOT NULL
GROUP BY ''00''+CONVERT(VARCHAR,CONTRATO), CONVERT(DATE,BIRTHDATE)', 
		@database_name=N'SCDB_QA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'FREQ WEEKLY', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20240108, 
		@active_end_date=99991231, 
		@active_start_time=30000, 
		@active_end_time=235959, 
		@schedule_uid=N'f51581cd-883b-49eb-a73e-d00f7c72bf50'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO



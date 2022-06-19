
--full backup
BACKUP DATABASE [KocsisHostel] TO  
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\KocsisHostel.bak'
GO

--diff backup
BACKUP DATABASE [KocsisHostel] TO  
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\KocsisHostel.bak' 
WITH  DIFFERENTIAL
GO

--logbackup
BACKUP LOG [KocsisHostel] TO  
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\KocsisHostel.bak'
GO

--drop backup device
USE [master]
GO
EXEC sp_dropdevice N'KocsisHostel Backup', 'delfile' ;  
GO

--backup device
USE [master]
GO
EXEC master.dbo.sp_addumpdevice  
@devtype = N'disk', 
@logicalname = N'KocsisHostel Backup', 
@physicalname = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\KocsisHostel.bak'
GO

--backup to backup device
BACKUP DATABASE [KocsisHostel] TO  [KocsisHostel Backup] 
GO

--recovery
/*
USE [master]
BACKUP LOG [KocsisHostel] TO  
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\KocsisHostel_LogBackup_2022-06-07_02-09-03.bak' 
RESTORE DATABASE [KocsisHostel] 
FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\KocsisHostel.bak' 
RESTORE DATABASE [KocsisHostel] 
FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\KocsisHostel.bak' 
RESTORE LOG [KocsisHostel] 
FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\KocsisHostel.bak' 
GO
*/

/*
USE [msdb]
GO
EXEC msdb.dbo.sp_delete_job @job_id=N'fc0991a6-b5e2-4597-ba39-d0e33b2c1c30', @delete_unused_schedule=1
GO
*/

--Full back up job (every sunday)
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Back Up Database - KocsisHostel Full', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ASUS\faith', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Back Up Database - KocsisHostel Full', @server_name = N'ASUS'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Back Up Database - KocsisHostel Full', @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [KocsisHostel] TO  [KocsisHostel Backup] WITH NOFORMAT, NOINIT,  NAME = N''KocsisHostel-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
', 
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Back Up Database - KocsisHostel Full', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ASUS\faith', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Back Up Database - KocsisHostel Full', @name=N'Sunday', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20220606, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO

/*
USE [msdb]
GO
EXEC msdb.dbo.sp_delete_job @job_id=N'73bcb948-7f91-4c64-b4de-a0424bb8a124', @delete_unused_schedule=1
GO
*/

--Diff backup job (every day)
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Back Up Database - KocsisHostel Diff', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ASUS\faith', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Back Up Database - KocsisHostel Diff', @server_name = N'ASUS'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Back Up Database - KocsisHostel Diff', @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [KocsisHostel] TO  [KocsisHostel Backup] WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N''KocsisHostel-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
', 
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Back Up Database - KocsisHostel Diff', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ASUS\faith', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Back Up Database - KocsisHostel Diff', @name=N'EveryDay Diff', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20220606, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO

/*
USE [msdb]
GO
EXEC msdb.dbo.sp_delete_job @job_id=N'e5e61a8f-f4ad-413a-a0d5-e8b40d5e922e', @delete_unused_schedule=1
GO
*/

--Log backup job (hourly)
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Back Up Database - KocsisHostel Log', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ASUS\faith', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Back Up Database - KocsisHostel Log', @server_name = N'ASUS'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Back Up Database - KocsisHostel Log', @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP LOG [KocsisHostel] TO  [KocsisHostel Backup] WITH NOFORMAT, NOINIT,  NAME = N''KocsisHostel-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
', 
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Back Up Database - KocsisHostel Log', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ASUS\faith', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Back Up Database - KocsisHostel Log', @name=N'EveryHour Log', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20220606, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO

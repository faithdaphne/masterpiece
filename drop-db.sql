EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'KocsisHostel'
GO
use master;
GO
USE master
GO
ALTER DATABASE KocsisHostel SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE master
GO
DROP DATABASE KocsisHostel
GO

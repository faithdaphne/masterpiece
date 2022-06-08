
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
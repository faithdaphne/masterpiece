USE [master]
GO

DROP LOGIN AdminLogin
DROP LOGIN ReceptionLogin
DROP LOGIN SocialWorkLogin
GO

USE [KocsisHostel]
GO

DROP USER IF EXISTS AdminUser
DROP USER IF EXISTS Receptionist
DROP USER IF EXISTS SocialWorker

GO

--create login 1 with user (admin)
USE [master]
GO
CREATE LOGIN [AdminLogin] WITH PASSWORD=N'12345', 
DEFAULT_DATABASE=[KocsisHostel]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [AdminLogin]
GO
use [master];
GO
USE [KocsisHostel]
GO
CREATE USER [AdminUser] FOR LOGIN [AdminLogin]
GO

--create login 2 with user
USE [master]
GO
CREATE LOGIN [ReceptionLogin] WITH PASSWORD=N'54321', 
DEFAULT_DATABASE=[KocsisHostel]
GO
use [master];
GO
USE [KocsisHostel]
GO
CREATE USER [Receptionist] FOR LOGIN [ReceptionLogin]
GO
ALTER ROLE [db_owner] ADD MEMBER [Receptionist]
GO

--create login 3 with user
USE [master]
GO
CREATE LOGIN [SocialWorkLogin] WITH PASSWORD=N'13579', 
DEFAULT_DATABASE=[KocsisHostel]
GO
use [master];
GO
USE [KocsisHostel]
GO
CREATE USER [SocialWorker] FOR LOGIN [SocialWorkLogin]
GO
USE [KocsisHostel]
GO
ALTER ROLE [db_datareader] ADD MEMBER [SocialWorker]
GO
USE [KocsisHostel]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [SocialWorker]
GO


--select * from syslogins
--select * from sysusers

--tablaszintu
--grant select on tablename to user
--revoke select on tablename to user
--deny select on tablename to user

--grant select on tablename to user with grant option
--revoke select on tablename to user cascade

--adatbazisszintu
--grant create table to user
--revoke create table to user
--deny create table to user


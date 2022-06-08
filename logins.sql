USE [master]
GO

DROP LOGIN [TestLogin1]
DROP LOGIN [TestLogin2]
DROP LOGIN [TestLogin3]
GO

USE [KocsisHostel]
GO

DROP USER [TestUser1]
DROP USER [TestUser2]
DROP USER [TestUser3]
GO

--create login 1 with user (admin)
USE [master]
GO
CREATE LOGIN [TestLogin1] WITH PASSWORD=N'12345', 
DEFAULT_DATABASE=[KocsisHostel]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [TestLogin1]
GO
use [master];
GO
USE [KocsisHostel]
GO
CREATE USER [TestUser1] FOR LOGIN [TestLogin1]
GO

--create login 2 with user
USE [master]
GO
CREATE LOGIN [TestLogin2] WITH PASSWORD=N'54321', 
DEFAULT_DATABASE=[KocsisHostel]
GO
use [master];
GO
USE [KocsisHostel]
GO
CREATE USER [TestUser2] FOR LOGIN [TestLogin2]
GO
ALTER ROLE [db_owner] ADD MEMBER [TestUser2]
GO

--create login 3 with user
USE [master]
GO
CREATE LOGIN [TestLogin3] WITH PASSWORD=N'13579', 
DEFAULT_DATABASE=[KocsisHostel]
GO
use [master];
GO
USE [KocsisHostel]
GO
CREATE USER [TestUser3] FOR LOGIN [TestLogin3]
GO
USE [KocsisHostel]
GO
ALTER ROLE [db_datareader] ADD MEMBER [TestUser3]
GO
USE [KocsisHostel]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [TestUser3]
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


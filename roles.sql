USE master
GO

DROP SERVER ROLE [ServerRole1]
GO

USE KocsisHostel
GO

DROP ROLE [Role1]
DROP ROLE [Role2]

--create role 1
USE [KocsisHostel]
GO
CREATE ROLE [Role1] --AUTHORIZATION [TestUser1]
GO
USE [KocsisHostel]
GO
ALTER AUTHORIZATION ON SCHEMA::[Person] TO [Role1]
GO
USE [KocsisHostel]
GO
ALTER AUTHORIZATION ON SCHEMA::[Hostel] TO [Role1]
GO
USE [KocsisHostel]
GO
ALTER AUTHORIZATION ON SCHEMA::[dbo] TO [Role1]
GO
USE [KocsisHostel]
GO
ALTER AUTHORIZATION ON SCHEMA::[sys] TO [Role1]
GO
USE [KocsisHostel]
GO
ALTER AUTHORIZATION ON SCHEMA::[INFORMATION_SCHEMA] TO [Role1]
GO
USE [KocsisHostel]
GO
ALTER AUTHORIZATION ON SCHEMA::[HumanResources] TO [Role1]
GO
USE [KocsisHostel]
GO
ALTER ROLE [Role1] ADD MEMBER [TestUser1]
GO

--create role 2
USE [KocsisHostel]
GO
CREATE ROLE [Role2]
GO
use [KocsisHostel]
GO
GRANT INSERT ON [dbo].[sysdiagrams] TO [Role2]
GO
use [KocsisHostel]
GO
GRANT SELECT ON [dbo].[sysdiagrams] TO [Role2]
GO
use [KocsisHostel]
GO
GRANT UPDATE ON [dbo].[sysdiagrams] TO [Role2]
GO

--create server role
USE [master]
GO
CREATE SERVER ROLE [ServerRole1]
GO
use [master]
GO
GRANT CREATE SERVER ROLE TO [ServerRole1]
GO
use [master]
GO
GRANT SHUTDOWN TO [ServerRole1]
GO

--alter role for a user
USE [KocsisHostel]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [TestUser2]
GO

--create application role
DROP APPLICATION ROLE WebApp;  
GO 

USE [KocsisHostel]
GO
CREATE APPLICATION ROLE [WebApp] WITH DEFAULT_SCHEMA = [dbo], PASSWORD = N'1234%'
GO
use [KocsisHostel]
GO
GRANT INSERT ON [dbo].[sysdiagrams] TO [WebApp]
GO
use [KocsisHostel]
GO
GRANT SELECT ON [dbo].[sysdiagrams] TO [WebApp]
GO
use [KocsisHostel]
GO
GRANT UPDATE ON [dbo].[sysdiagrams] TO [WebApp]
GO

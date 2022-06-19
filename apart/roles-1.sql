--beepitett role-ok a create login/users-ben

USE KocsisHostel;
GO

ALTER ROLE SocalWorkerRole DROP member AdminUser
GO
ALTER ROLE SocalWorkerRole DROP member SocialWorker
GO

DROP ROLE SocalWorkerRole
GO

 --create database role
USE [KocsisHostel]
GO
CREATE ROLE [SocalWorkerRole]
GO
USE [KocsisHostel]
GO
ALTER ROLE [SocalWorkerRole] ADD MEMBER [Receptionist]
GO
USE [KocsisHostel]
GO
ALTER ROLE [SocalWorkerRole] ADD MEMBER [SocialWorker]
GO
use [KocsisHostel]
GO
GRANT INSERT ON [dbo].[EmployeeInfo] TO [SocalWorkerRole]
GO
use [KocsisHostel]
GO
GRANT SELECT ON [dbo].[EmployeeInfo] TO [SocalWorkerRole]
GO
use [KocsisHostel]
GO
GRANT UPDATE ON [dbo].[EmployeeInfo] TO [SocalWorkerRole]
GO

USE KocsisHostel;
GO

DROP APPLICATION ROLE SocialWorkApp
GO

--create application role

USE [KocsisHostel]
GO
CREATE APPLICATION ROLE [SocialWorkApp] WITH DEFAULT_SCHEMA = [dbo], PASSWORD = N'1234%'
GO
use [KocsisHostel]
GO
GRANT SELECT ON [dbo].[EmployeeInfo] TO [SocialWorkApp]
GO

USE [KocsisHostel]
GO


DECLARE @RoleName sysname
set @RoleName = N'SocalWorkerRole'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    select [name]
    from sys.database_principals 
    where principal_id in ( 
        select member_principal_id
        from sys.database_role_members
        where role_principal_id in (
            select principal_id
            FROM sys.database_principals where [name] = @RoleName AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    into @RoleMemberName
    
    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)
        
        FETCH NEXT FROM Member_Cursor
        into @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;
END
/****** Object:  DatabaseRole [SocalWorkerRole]    Script Date: 6/18/2022 10:06:47 PM ******/
DROP ROLE [SocalWorkerRole]
GO

/****** Object:  DatabaseRole [SocalWorkerRole]    Script Date: 6/18/2022 10:06:47 PM ******/
CREATE ROLE [SocalWorkerRole]
GO

USE [KocsisHostel]
GO

/****** Object:  ApplicationRole [SocialWorkApp]    Script Date: 6/18/2022 10:24:48 PM ******/
DROP APPLICATION ROLE  [SocialWorkApp]
GO

/****** Object:  ApplicationRole [SocialWorkApp]    Script Date: 6/18/2022 10:24:48 PM ******/
/* To avoid disclosure of passwords, the password is generated in script. */
declare @idx as int
declare @randomPwd as nvarchar(64)
declare @rnd as float
select @idx = 0
select @randomPwd = N''
select @rnd = rand((@@CPU_BUSY % 100) + ((@@IDLE % 100) * 100) + 
       (DATEPART(ss, GETDATE()) * 10000) + ((cast(DATEPART(ms, GETDATE()) as int) % 100) * 1000000))
while @idx < 64
begin
   select @randomPwd = @randomPwd + char((cast((@rnd * 83) as int) + 43))
   select @idx = @idx + 1
select @rnd = rand()
end
declare @statement nvarchar(4000)
select @statement = N'CREATE APPLICATION ROLE [SocialWorkApp] WITH DEFAULT_SCHEMA = [dbo], ' + N'PASSWORD = N' + QUOTENAME(@randomPwd,'''')
EXEC dbo.sp_executesql @statement
GO

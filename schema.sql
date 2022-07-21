/*
--------------------------------------------------------------------
© 2022 Faith Tímea All Rights Reserved
--------------------------------------------------------------------
Name   : KocsisHostel
Link   : https://github.com/CodecoolGlobal/dbspec-masterpiece-general-faithdaphne
Version: 999.99
--------------------------------------------------------------------
*/
USE KocsisHostel;
GO

DROP FUNCTION IF EXISTS HumanResources.fnAddress
GO
DROP FUNCTION IF EXISTS Person.fnFullName
GO

DROP TABLE IF EXISTS Hostel.Reservation
DROP TABLE IF EXISTS Hostel.Room
DROP TABLE IF EXISTS Hostel.PriceTable
DROP TABLE IF EXISTS Hostel.RoomGender
DROP TABLE IF EXISTS Hostel.RoomType
DROP TABLE IF EXISTS Hostel.AccommodationType
DROP TABLE IF EXISTS HumanResources.OfficeConnection
DROP TABLE IF EXISTS HumanResources.Office
DROP TABLE IF EXISTS Person.Homeless
DROP TABLE IF EXISTS HumanResources.Address
DROP TABLE IF EXISTS HumanResources.Employee
DROP TABLE IF EXISTS HumanResources.Position
DROP TABLE IF EXISTS Person.Person
DROP TABLE IF EXISTS Person.PersonType
GO

DROP SCHEMA IF EXISTS Hostel
GO
DROP SCHEMA IF EXISTS HumanResources
GO
DROP SCHEMA IF EXISTS Person
GO

--create schemas
CREATE SCHEMA Person
GO
CREATE SCHEMA HumanResources
GO
CREATE SCHEMA Hostel
GO

-- create tables
CREATE TABLE Person.PersonType
(
	person_type_id INT IDENTITY (1, 1) CONSTRAINT PK_PersonType PRIMARY KEY,
	type_name VARCHAR(50) NOT NULL,
	acronym CHAR(1) NOT NULL
);

CREATE TABLE Person.Person 
(
	person_id INT IDENTITY (1, 1) CONSTRAINT PK_Person PRIMARY KEY,
    person_type_id INT NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	id_number CHAR(8) NOT NULL UNIQUE,
    social_number CHAR(9) NOT NULL UNIQUE,
    tax_number CHAR(10) NOT NULL UNIQUE,
    birth_place VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) NOT NULL,
    nationality VARCHAR(50) NOT NULL DEFAULT 'American',
	CONSTRAINT FK_Person_Type_Id FOREIGN KEY(person_type_id) REFERENCES Person.PersonType(person_type_id),
	CONSTRAINT CHK_IdNumber CHECK (id_number LIKE '%[0-9a-z]%'),
	CONSTRAINT CHK_SocNumber CHECK (social_number LIKE '%[0-9]%'),
	CONSTRAINT CHK_TaxNumber CHECK (tax_number LIKE '%[0-9]%'),
	--CONSTRAINT CHK_Age CHECK (dbo.fnCheckAge(person_id) >= 18)
);

CREATE TABLE HumanResources.Position 
(
	position_id INT IDENTITY (1, 1) CONSTRAINT PK_Position PRIMARY KEY,
	position_name VARCHAR(50) NOT NULL
);

CREATE TABLE HumanResources.Employee
(
	employee_id INT CONSTRAINT PK_Employee PRIMARY KEY,
	start_date DATE NOT NULL,
	end_date DATE,
	position_id INT NOT NULL,
	email VARCHAR(50) NOT NULL UNIQUE,
	phone_number VARCHAR(25) NOT NULL,
	CONSTRAINT FK_PersonId_Employee FOREIGN KEY(employee_id) REFERENCES Person.Person(person_id),
	CONSTRAINT FK_PositionId FOREIGN KEY(position_id) REFERENCES HumanResources.Position(position_id),
	CONSTRAINT CHK_Email CHECK (email LIKE '%[a-z]%.%[a-z0-9]%@kocsis.com'),
	CONSTRAINT CHK_EndDate CHECK (start_date < ISNULL(end_date, '2099-01-01'))
	
);

CREATE TABLE HumanResources.Address
(
	address_id INT IDENTITY (1, 1) CONSTRAINT PK_Address PRIMARY KEY,
	employee_id INT NOT NULL,
	house_number SMALLINT NOT NULL,
	street VARCHAR(50) NOT NULL,
	city VARCHAR(50) NOT NULL,
	state VARCHAR(50) NOT NULL,
	postal_code CHAR(5) NOT NULL,
	CONSTRAINT FK_EpmloyeeId_Address FOREIGN KEY(employee_id) REFERENCES HumanResources.Employee(employee_id)
);

CREATE TABLE Person.Homeless 
(
	person_id INT NOT NULL,
	employee_id INT NOT NULL,
	CONSTRAINT PK_Homless PRIMARY KEY (person_id, employee_id),
	CONSTRAINT FK_PersonId_Homeless FOREIGN KEY(person_id) REFERENCES Person.Person(person_id),
	CONSTRAINT FK_EpmloyeeId_Homeless FOREIGN KEY(employee_id) REFERENCES HumanResources.Employee(employee_id)
);

CREATE TABLE HumanResources.Office
(
	office_id INT IDENTITY (1, 1) CONSTRAINT PK_Office PRIMARY KEY,
	office_name VARCHAR(20) NOT NULL,
	office_phone VARCHAR(25) NOT NULL
);

CREATE TABLE HumanResources.OfficeConnection 
(
	office_id INT NOT NULL,
	employee_id INT NOT NULL,
	CONSTRAINT PK_OfficeId PRIMARY KEY (office_id, employee_id),
	CONSTRAINT FK_OfficeId FOREIGN KEY(office_id) REFERENCES HumanResources.Office(office_id),
	CONSTRAINT FK_Employee_Office FOREIGN KEY(employee_id) REFERENCES HumanResources.Employee(employee_id)
);

CREATE TABLE Hostel.AccommodationType 
(
	acc_type_id INT IDENTITY (1, 1) CONSTRAINT PK_AccType PRIMARY KEY,
	acc_type_name VARCHAR(50) NOT NULL
);

CREATE TABLE Hostel.RoomType 
(
	room_type_id INT IDENTITY (1, 1) CONSTRAINT PK_RoomType PRIMARY KEY,
	room_type_name VARCHAR(20) NOT NULL,
	person_number TINYINT NOT NULL
);

CREATE TABLE Hostel.RoomGender 
(
	gender_id INT IDENTITY (1, 1) CONSTRAINT PK_RoomGender PRIMARY KEY,
	gender_name VARCHAR(10) NOT NULL,
	acronym CHAR(1) NOT NULL
);

CREATE TABLE Hostel.PriceTable 
(
	price_id INT IDENTITY (1, 1) CONSTRAINT PK_Price PRIMARY KEY,
	acc_type_id INT NOT NULL,
	room_type_id INT NOT NULL,
	month_price MONEY NOT NULL,
	CONSTRAINT FK_AccType FOREIGN KEY(acc_type_id) REFERENCES Hostel.AccommodationType(acc_type_id),
	CONSTRAINT FK_RoomType FOREIGN KEY(room_type_id) REFERENCES Hostel.RoomType(room_type_id)
);

CREATE TABLE Hostel.Room
(
	room_id INT IDENTITY (1, 1) CONSTRAINT PK_Room PRIMARY KEY,
	room_number SMALLINT NOT NULL UNIQUE,
	floor TINYINT NOT NULL,
	room_phone VARCHAR(25) NOT NULL,
	gender_id INT NOT NULL,
	price_id INT NOT NULL,
	CONSTRAINT FK_Gender FOREIGN KEY(gender_id) REFERENCES Hostel.RoomGender(gender_id),
	CONSTRAINT FK_Price FOREIGN KEY(price_id) REFERENCES Hostel.PriceTable(price_id)
);

CREATE TABLE Hostel.Reservation
(
	res_id INT IDENTITY (1, 1) CONSTRAINT PK_Reservation PRIMARY KEY,
	room_id INT NOT NULL,
	person_id INT NOT NULL,
	pay_day TINYINT NOT NULL DEFAULT 10,
	start_date DATE NOT NULL DEFAULT GETDATE(),
	end_date DATE,
	archived CHAR(1) DEFAULT 'F'
	--status CHAR(8) DEFAULT 'Active'
	CONSTRAINT FK_Room FOREIGN KEY(room_id) REFERENCES Hostel.Room(room_id),
	CONSTRAINT FK_Reservation_Person FOREIGN KEY(person_id) REFERENCES Person.Person(person_id),
	CONSTRAINT UQ_Reservation_Unique_Row UNIQUE (room_id,person_id,start_date),
	CONSTRAINT CHK_EndDate2 CHECK (start_date < ISNULL(end_date, '2099-01-01'))
);

--some alter statement

--ALTER TABLE Hostel.Reservation
--ADD status CHAR(8) DEFAULT 'Active'
--GO

--ALTER TABLE Hostel.Reservation
--ALTER COLUMN status CHAR(8) DEFAULT 'Active'
--GO

--ALTER TABLE Hostel.Reservation
--DROP COLUMN status
--GO

USE [master]
GO

DROP LOGIN IF EXISTS AdminLogin
DROP LOGIN IF EXISTS ReceptionLogin
DROP LOGIN IF EXISTS SocialWorkLogin
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

USE KocsisHostel
GO

DROP FUNCTION IF EXISTS Person.fnFullName
GO

--function for fullname
CREATE FUNCTION Person.fnFullName
	(
		@PersonID AS INT
	)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @FullName AS VARCHAR(100) = 
	(
		SELECT CONCAT(first_name,' ',last_name)
		FROM Person.Person
		WHERE Person.person_id = @PersonID
	)
	RETURN @FullName
END
GO

--SELECT Person.fnFullName(1)

USE KocsisHostel
GO

DROP FUNCTION IF EXISTS HumanResources.fnAddress
GO

--function for full address
CREATE FUNCTION HumanResources.fnAddress
	(
		@AddressID AS INT
	)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @Address AS VARCHAR(200) = 
	(
		SELECT CONCAT(a.house_number,'. ',a.street,', ',a.city,' ',a.postal_code)
		FROM HumanResources.Address AS a
		WHERE a.address_id = @AddressID
	)
	RETURN @Address
END
GO

--SELECT HumanResources.fnAddress(1)

DROP FUNCTION IF EXISTS dbo.fnCheckAge
GO

--function for count age and check if older than 18
CREATE FUNCTION dbo.fnCheckAge
(@ID INT)
RETURNS SMALLINT
AS
BEGIN
DECLARE @Age SMALLINT
SET @Age =
(
	SELECT
	--FLOOR(DATEDIFF(DAY, p.birth_date, GETDATE())) /365.25
	DATEDIFF(HOUR,p.birth_date,GETDATE())/8766
	FROM Person.Person AS p
	WHERE p.person_id = @ID
)
RETURN @Age
END;
GO

--ALTER TABLE Person.Person
--DROP CONSTRAINT CHK_Age;  
--GO
ALTER TABLE Person.Person
ADD CONSTRAINT CHK_Age CHECK (dbo.fnCheckAge(person_id) >= 18)
GO

--SELECT * FROM Person.Person ORDER BY person_id DESC
--DELETE FROM Person.Person WHERE person_id = 202
/*
INSERT INTO Person.Person VALUES 
(2, 'John', 'Doe', '418933AS', '361856274', '5628456963', 'Las Vegas', '2005-06-12', 'M', 'American')
*/

USE KocsisHostel
GO

DROP VIEW IF EXISTS "Room_Price"
GO

--create view 1
CREATE VIEW "Room_Price" AS
SELECT
	CONCAT(LEFT(a.acc_type_name, 1),r.room_number) AS 'Room number',
	SUBSTRING(t.room_type_name,1,CHARINDEX(' ', t.room_type_name)) AS 'Room type',
	g.acronym AS 'Gender',
	CONCAT(t.person_number,' ',
		CASE
			WHEN t.person_number = 1 THEN 'person'
			ELSE 'people'
		END) AS 'Person/room',
	CONCAT(CAST(p.month_price AS INT),' ','HUF') AS 'Price/month/person',
	CONCAT(CAST(p.month_price*t.person_number AS INT),' ','HUF') AS 'Price/month/room'
FROM Hostel.Room AS r 
	JOIN Hostel.RoomGender AS g ON r.gender_id = g.gender_id
	JOIN Hostel.PriceTable AS p ON r.price_id = p.price_id
	JOIN Hostel.RoomType AS t ON p.room_type_id = t.room_type_id
	JOIN Hostel.AccommodationType AS a ON p.acc_type_id = a.acc_type_id
GO

--Select * from [dbo].[Room_Price]
--GO

DROP VIEW IF EXISTS "EmptyRooms"
GO

--create view 2
CREATE VIEW "EmptyRooms" AS
	SELECT
		SUBSTRING(a.acc_type_name,1,CHARINDEX(' ', a.acc_type_name)) AS 'Accommodation type',
		ro.room_number AS 'Room number',
		re.room_id,
		g.gender_name AS 'Gender',
		SUBSTRING(t.room_type_name,1,CHARINDEX(' ', t.room_type_name)) AS 'Room type',
		t.person_number - SUM(CASE WHEN re.end_date IS NULL THEN 1 ELSE 0 END) AS 'Free bed'
	FROM Hostel.Reservation AS re
	JOIN Hostel.Room ro ON re.room_id = ro.room_id
	JOIN Hostel.PriceTable AS p ON ro.price_id = p.price_id
	JOIN Hostel.RoomType AS t ON p.room_type_id = t.room_type_id
	JOIN Hostel.RoomGender AS g ON ro.gender_id = g.gender_id
	JOIN Hostel.AccommodationType AS a ON p.acc_type_id = a.acc_type_id
	GROUP BY t.person_number,ro.room_number,re.room_id,g.gender_name, t.room_type_name,a.acc_type_name
	HAVING t.person_number - SUM(CASE WHEN re.end_date IS NULL THEN 1 ELSE 0 END) != 0
GO
--INSERT INTO Hostel.Reservation VALUES (38, 199, 10, '2022-05-19', NULL)

--Select * from [dbo].[EmptyRooms]
--GO
--12,18,25,25,38,38,38,38,57,57 empty rooms

DROP VIEW IF EXISTS "EmployeeInfo"
GO

--create view 3
CREATE VIEW "EmployeeInfo" AS
SELECT
Person.fnFullName(pe.person_id) AS 'Emloyee name',
po.position_name AS 'Position',
CASE
	WHEN e.end_date IS NULL THEN 'active'
	ELSE 'resigned'
END AS 'Status',
HumanResources.fnAddress(a.address_id) AS Address,
e.email AS 'Email',
e.phone_number AS 'Phone'
FROM HumanResources.Address AS a
LEFT JOIN HumanResources.Employee AS e
ON a.employee_id = e.employee_id 
LEFT JOIN HumanResources.Position AS po
ON e.position_id = po.position_id 
LEFT JOIN Person.Person AS pe
ON e.employee_id = pe.person_id 
GO

--SELECT * FROM "EmployeeInfo"
--GO

DROP VIEW IF EXISTS forsp
GO

CREATE VIEW "forsp" AS
SELECT r.person_id, COUNT(r.start_date) AS start ,COUNT(r.end_date) AS finish FROM Hostel.Reservation AS r
GROUP BY r.person_id
HAVING COUNT(r.start_date) > COUNT(r.end_date)
GO
--select * from forsp

USE KocsisHostel
GO

CREATE OR ALTER PROC spHomeless_List
AS
BEGIN
	SELECT 
	(
		SELECT 
		Person.fnFullName(p.person_id) 
		FROM Person.Person AS p 
		WHERE p.person_id = h.person_id
	)	AS 'Homeless name',
	(
		SELECT Person.fnFullName(p.person_id) 
		FROM Person.Person AS p 
		WHERE p.person_id = h.employee_id
	)	AS 'Assigned social worker'

	FROM Person.Homeless AS h
	LEFT JOIN HumanResources.Employee AS e
	ON e.employee_id = h.employee_id
	WHERE e.end_date IS NULL
	ORDER BY 'Homeless name'
END
GO

--EXEC spHomeless_List

CREATE OR ALTER PROCEDURE spInsertToReservation
	(
	@room_number SMALLINT
	,@person VARCHAR(101)
	)
AS
BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @room_id INT = 
		(SELECT r.room_id  FROM Hostel.Room AS r WHERE r.room_number = @room_number)
		DECLARE @person_id INT = 
		(SELECT p.person_id FROM Person.Person AS p WHERE CONCAT(p.first_name,' ',p.last_name) = @person)
		DECLARE @pay_day TINYINT = DATEPART(DAY, GETDATE())
		DECLARE @checkPersonid INT = (SELECT person_id FROM forsp WHERE person_id = @person_id)
		IF @checkPersonid IS NOT NULL
		BEGIN
		PRINT @person + ' is already in a room.'
		END
		ELSE
		BEGIN
		INSERT INTO Hostel.Reservation (room_id, person_id, pay_day)
			VALUES 
			(
				@room_id
				,@person_id
				,@pay_day
			)
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			PRINT 'Data does not exist. Insert person to Person table or check room number or name.'
	ROLLBACK TRANSACTION
	END CATCH
		IF @@TRANCOUNT > 0
	COMMIT TRANSACTION
GO

/*
EXEC spInsertToReservation @person='Jane Doe', @room_number=202
EXEC spInsertToReservation @person='Bob Marley', @room_number=408

if data does not exist:
EXEC spInsertToReservation @person='Valami Valami', @room_number=666


SELECT r.res_id,r.room_id, Person.fnFullName(p.person_id) AS Fullname,r.pay_day, r.start_date, r.end_date
FROM Hostel.Reservation r 
JOIN Person.Person p ON p.person_id = r.person_id
ORDER BY r.res_id DESC

DELETE FROM Hostel.Reservation WHERE res_id = 167

INSERT INTO Person.Person VALUES 
(2, 'Bob', 'Marley', '418894WL', '361848274', '5628181963', 'Nine Mile', '1945-02-06', 'M', 'Jamaican')

UPDATE Hostel.Reservation SET end_date = '2022-08-01' WHERE res_id = 166

INSERT INTO Hostel.Reservation (room_id,person_id,pay_day,start_date,end_date)
VALUES (60, 201, 10,'2021-07-19', NULL)
*/

CREATE OR ALTER PROCEDURE spUpdateEnddate
	(
		@person VARCHAR(101)
		,@end_date DATE
	)
AS
BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @res_id INT = 
		(SELECT MAX(res_id)  FROM Hostel.Reservation AS r
		JOIN Person.Person AS p ON p.person_id = r.person_id 
		WHERE CONCAT(p.first_name,' ',p.last_name) = @person)
		UPDATE Hostel.Reservation
				SET
					end_date = @end_date
				WHERE res_id = @res_id
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			PRINT 'ERROR!'
		ROLLBACK TRANSACTION
	END CATCH
		IF @@TRANCOUNT > 0
			PRINT 'Enddate has been updated!'
		COMMIT TRANSACTION
GO

/*
EXEC spUpdateEnddate @person='Abdul Fall', @end_date='2022-08-30'
EXEC spUpdateEnddate @person='Chad Moss', @end_date='2022-08-30'

DELETE FROM Hostel.Reservation WHERE res_id = 240
EXEC spInsertToReservation @person='Abdul Fall', @room_number=408
EXEC spInsertToReservation @person='Chad Moss', @room_number=408

SELECT r.res_id,r.room_id, Person.fnFullName(p.person_id) AS Fullname,r.pay_day, r.start_date, r.end_date
FROM Hostel.Reservation r 
JOIN Person.Person p ON p.person_id = r.person_id
ORDER BY r.res_id DESC

Abdul Fall, Chad Moss, Julius Talbot, Nate Richardson

SELECT * FROM Hostel.Reservation WHERE end_date IS NOT NULL
*/

USE KocsisHostel;
GO

DROP TRIGGER IF EXISTS GenderTrigger;
GO

CREATE OR ALTER TRIGGER GenderTrigger
ON Hostel.Reservation
FOR UPDATE, INSERT
AS
BEGIN
BEGIN TRANSACTION
    DECLARE @InsertedPerson INT = 
		(SELECT person_id FROM inserted)
    DECLARE @GenderCheck VARCHAR(MAX) = 
		(SELECT gender FROM Person.Person WHERE person_id = @InsertedPerson)
    DECLARE @InsertedRoom INT = 
		(SELECT room_id FROM inserted)
    DECLARE @RoomGender VARCHAR(MAX) = 
	(
		SELECT g.acronym FROM Hostel.Room AS r 
		LEFT JOIN Hostel.RoomGender AS g ON g.gender_id = r.gender_id
		WHERE r.room_id = @InsertedRoom
	)
    IF @RoomGender = 'A'
		BEGIN
			PRINT 'All gender room, insert OK'
			COMMIT TRANSACTION
		END
    ELSE
    IF @RoomGender = @GenderCheck
		BEGIN
            PRINT 'Gender is OK!'
			COMMIT TRANSACTION
			RETURN
		END
	ELSE
		BEGIN
			PRINT 'Transaction rollbacked, because gender does not match. Check gender.'
			ROLLBACK TRANSACTION
			RETURN
		END
END
GO

/*
Select * from [dbo].[EmptyRooms]

EXEC spInsertToReservation @person='Bob Marley', @room_number=408 --(202:noi)
EXEC spInsertToReservation @person='Tom Smith', @room_number=607 --(607:paros)
EXEC spInsertToReservation @person='Daphne Smith', @room_number=408 --(408:ferfi)

INSERT INTO Person.Person VALUES 
(2, 'Bob', 'Marley', '418894WL', '361848274', '5628181963', 'Nine Mile', '1945-02-06', 'M', 'Jamaican')

INSERT INTO Person.Person VALUES 
(2, 'Daphne', 'Smith', '412194HK', '361848654', '5898181963', 'Los Angeles', '1988-02-06', 'F', 'American')

INSERT INTO Person.Person VALUES 
(2, 'Tom', 'Smith', '423194AF', '365748654', '5898981963', 'New York', '1989-01-22', 'M', 'American')

SELECT r.res_id,r.room_id, Person.fnFullName(p.person_id) AS Fullname,r.pay_day, r.start_date, r.end_date
FROM Hostel.Reservation r 
JOIN Person.Person p ON p.person_id = r.person_id
ORDER BY r.res_id DESC

DELETE FROM Hostel.Reservation WHERE res_id = 236

ALTER TABLE Hostel.Reservation ADD archived CHAR(1) DEFAULT 'F'
GO
*/

DROP TRIGGER IF EXISTS ArchiveTrigger
GO

CREATE OR ALTER TRIGGER ArchiveTrigger
ON Hostel.Reservation
FOR UPDATE
AS
    DECLARE @EndDate DATE = (SELECT end_date FROM inserted)
    IF @EndDate IS NOT NULL
        UPDATE Hostel.Reservation SET archived = 'T' WHERE res_id = (SELECT res_id FROM inserted)
GO


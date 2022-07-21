/*
--------------------------------------------------------------------
© 2022 Faith Tímea All Rights Reserved
--------------------------------------------------------------------
Name   : KocsisHostel
Link   : https://github.com/CodecoolGlobal/dbspec-masterpiece-general-faithdaphne
Version: 1.0
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

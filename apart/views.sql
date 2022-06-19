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

Select * from [dbo].[Room_Price]
GO

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

Select * from [dbo].[EmptyRooms]
GO
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

SELECT * FROM "EmployeeInfo"
GO

drop view if exists forsp
go
CREATE VIEW "forsp" AS
SELECT r.person_id, COUNT(r.start_date) AS start ,COUNT(r.end_date) AS finish FROM Hostel.Reservation AS r
GROUP BY r.person_id
HAVING COUNT(r.start_date) > COUNT(r.end_date)
GO
--select * from forsp
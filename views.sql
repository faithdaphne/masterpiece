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

Select * from [dbo].[Room/Price]
GO

DROP VIEW IF EXISTS "EmptyRooms"
GO

--create view 2
CREATE VIEW "EmptyRooms" AS
SELECT
ro.room_number AS 'Empty room',
t.person_number AS 'Person/room',
g.gender_name AS 'Gender'
FROM Hostel.Reservation AS re
JOIN Hostel.Room ro ON re.room_id = ro.room_id
JOIN Hostel.PriceTable AS p ON ro.price_id = p.price_id
JOIN Hostel.RoomType AS t ON p.room_type_id = t.room_type_id
JOIN Hostel.RoomGender AS g ON ro.gender_id = g.gender_id
WHERE re.end_date IS NOT NULL AND re.room_id NOT IN
	(SELECT room_id FROM Hostel.Reservation WHERE end_date IS NULL )
GROUP BY ro.room_number, re.room_id, t.person_number, g.gender_name
GO

Select * from [dbo].[EmptyRooms]
GO

DROP VIEW IF EXISTS "EmployeeInfo"
GO

--create view 3
CREATE VIEW "EmployeeInfo" AS
SELECT
CONCAT(pe.first_name,' ', pe.last_name) AS 'Emloyee name',
po.position_name AS 'Position',
CASE
	WHEN e.end_date IS NULL THEN 'active'
	ELSE 'resigned'
END AS 'Status',
CONCAT(a.house_number,'. ',a.street,', ',a.city,' ',a.postal_code) AS Address,
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
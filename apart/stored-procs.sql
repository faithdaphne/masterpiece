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
		(
			SELECT MAX(res_id)  FROM Hostel.Reservation AS r
			JOIN Person.Person AS p ON p.person_id = r.person_id 
			WHERE CONCAT(p.first_name,' ',p.last_name) = @person
		)
		UPDATE Hostel.Reservation
		SET end_date = @end_date
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
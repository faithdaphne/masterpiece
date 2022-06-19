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
(2, 'Bob', 'Marley', '418894AS', '361848274', '5628181963', 'Nine Mile', '1945-02-06', 'M', 'Jamaican')

INSERT INTO Person.Person VALUES 
(2, 'Daphne', 'Smith', '412194AS', '361848654', '5898181963', 'Los Angeles', '1988-02-06', 'F', 'American')

INSERT INTO Person.Person VALUES 
(2, 'Tom', 'Smith', '423194AS', '365748654', '5898981963', 'New York', '1989-01-22', 'M', 'American')

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
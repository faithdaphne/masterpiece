DROP FUNCTION IF EXISTS dbo.fnFreeBedsInRoom
GO

CREATE FUNCTION dbo.fnFreeBedsInRoom
(
	@room_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @count INT
	SET @count =
		(
			SELECT 
			COUNT(room_id) 
			FROM Hostel.Reservation 
			WHERE room_id = @room_id AND end_date IS NULL
		)
	RETURN @count
END
GO

DROP VIEW IF EXISTS "EmptyRooms2"
GO

CREATE VIEW "EmptyRooms2" AS
SELECT
	SUBSTRING(a.acc_type_name,1,CHARINDEX(' ', a.acc_type_name)) AS 'Accommodation type',
	r.room_number AS 'Room number',
	g.gender_name AS 'Gender',
	SUBSTRING(t.room_type_name,1,CHARINDEX(' ', t.room_type_name)) AS 'Room type',
	t.person_number - dbo.fnFreeBedsInRoom(r.room_id) AS 'Free beds'
FROM Hostel.Room AS r
JOIN Hostel.PriceTable AS p ON r.price_id = p.price_id
JOIN Hostel.RoomType AS t ON p.room_type_id = t.room_type_id
JOIN Hostel.RoomGender AS g ON r.gender_id = g.gender_id
JOIN Hostel.AccommodationType AS a ON p.acc_type_id = a.acc_type_id
WHERE t.person_number - dbo.fnFreeBedsInRoom(r.room_id) > 0
--AND a.acc_type_id = 2
GO

SELECT * FROM "EmptyRooms2"
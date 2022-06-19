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
		SELECT CONCAT(first_name,' ', last_name)
		FROM Person.Person
		WHERE Person.person_id = @PersonID
	)
	RETURN @FullName
END
GO

SELECT Person.fnFullName(1)

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

SELECT HumanResources.fnAddress(1)

ALTER TABLE Person.Person
DROP CONSTRAINT CHK_Age;  
GO  

DROP FUNCTION IF EXISTS dbo.fnCheckAge
GO

--function for count age and check if older than 18
CREATE OR ALTER FUNCTION dbo.fnCheckAge
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

ALTER TABLE Person.Person
ADD CONSTRAINT CHK_Age CHECK (dbo.fnCheckAge(person_id) >= 18)
GO

--SELECT * FROM Person.Person ORDER BY person_id DESC
--DELETE FROM Person.Person WHERE person_id = 202
/*
INSERT INTO Person.Person VALUES 
(2, 'John', 'Doe', '418933AS', '361856274', '5628456963', 'Las Vegas', '2005-06-12', 'M', 'American')
*/
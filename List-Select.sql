USE tempdb
GO

DROP TABLE IF EXISTS dbo.#connection
GO
DROP TABLE IF EXISTS dbo.#socworker
GO
DROP TABLE IF EXISTS dbo.#homeless
GO

USE KocsisHostel
GO

SELECT * INTO #socworker FROM
(SELECT
e.employee_id,
CONCAT(p.first_name,' ', p.last_name) AS Social_worker
FROM Person.Homeless h
JOIN HumanResources.Employee e
ON h.employee_id = e.employee_id
JOIN Person.Person p
ON e.employee_id = p.person_id
WHERE e.end_date IS NULL
) AS tmp

SELECT * INTO #homeless FROM
(SELECT
DISTINCT(h.person_id),
CONCAT(p.first_name,' ', p.last_name) AS Homless_name
FROM Person.Homeless h
JOIN Person.Person p
ON h.person_id = p.person_id
WHERE h.person_id = p.person_id) AS tmp

SELECT * INTO #connection FROM
(SELECT * FROM Person.Homeless) AS tmp


USE tempdb
GO

SELECT
DISTINCT(h.Homless_name) AS 'Homless name',
s.Social_worker AS 'Assigned social worker'
FROM dbo.#connection AS c
JOIN dbo.#socworker AS s
ON c.employee_id = s.employee_id
JOIN dbo.#homeless AS h
ON h.person_id = c.person_id
ORDER BY [Assigned social worker],[Homless name]
GO
DROP SCHEMA IF EXISTS sem_7;
CREATE SCHEMA sem_7;

DROP TABLE IF EXISTS sem_7.organization;
CREATE TABLE sem_7.organization AS
SELECT
    1 AS id_org,
    'АО Тинькофф Банк' AS name_org
UNION
SELECT
    2,
    'X5 Retail Group'
UNION
SELECT
    3,
    'Сбер';

DROP TABLE IF EXISTS sem_7.teacher;
CREATE TABLE sem_7.teacher (id_teach, last_name, first_name, birth_date, salary_amt, id_org) AS
SELECT
    1, 'Роздухова', 'Нина', '1992-04-15', 15000.00, 1
UNION
SELECT
    2, 'Меркурьева', 'Надежда', '1995-03-12', 25000.00, 1
UNION
SELECT
    3, 'Халяпов', 'Александр', '1994-09-30', 17000.00, 2
UNION
SELECT
    4, 'Иванов', 'Иван', NULL, 100000.00, 3
UNION
SELECT
    5, 'Петров', 'Петр', NULL, 3000.00, 3;

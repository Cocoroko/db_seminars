DROP SCHEMA IF EXISTS sem_7 CASCADE;
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
    5, 'Петров', 'Петр', NULL, 3000.00, 3
UNION
SELECT
    6, 'Сидоров', 'Василий', NULL, 17500.00, NULL
UNION
SELECT
    7, 'Данилов', 'Глеб', NULL, 2500.00, NULL;


/*
    1. Создать view – полную копию таблицы teacher;
*/

CREATE VIEW sem_7.teacher_v AS
SELECT *
FROM sem_7.teacher;

-- проверим, что есть в представлении
SELECT *
FROM sem_7.teacher_v;
/*
id_teach|last_name |first_name|birth_date|salary_amt|id_org|
--------+----------+----------+----------+----------+------+
       5|Петров    |Петр      |          |   3000.00|     3|
       6|Сидоров   |Василий   |          |  17500.00|      |
       3|Халяпов   |Александр |1994-09-30|  17000.00|     2|
       2|Меркурьева|Надежда   |1995-03-12|  25000.00|     1|
       7|Данилов   |Глеб      |          |   2500.00|      |
       4|Иванов    |Иван      |          | 100000.00|     3|
       1|Роздухова |Нина      |1992-04-15|  15000.00|     1|
*/

/*
    2. Создать view – копию таблицы teacher,
       за исключением строк, у которых нет связи с организацией;
*/

CREATE VIEW sem_7.teacher_with_org_v AS
SELECT *
FROM sem_7.teacher
WHERE id_org IS NOT NULL;

-- проверка
SELECT *
FROM sem_7.teacher_with_org_v;
/*
id_teach|last_name |first_name|birth_date|salary_amt|id_org|
--------+----------+----------+----------+----------+------+
       5|Петров    |Петр      |          |   3000.00|     3|
       3|Халяпов   |Александр |1994-09-30|  17000.00|     2|
       2|Меркурьева|Надежда   |1995-03-12|  25000.00|     1|
       4|Иванов    |Иван      |          | 100000.00|     3|
       1|Роздухова |Нина      |1992-04-15|  15000.00|     1|
*/

/*
    3. Создать view с полным списком преподавателей.
       Вместо id организации выводить ее название.
       Не включать в представление зарплату преподавателя;
*/

CREATE VIEW sem_7.teacher_org_v AS
SELECT id_teach, last_name, first_name, birth_date, name_org
FROM sem_7.teacher
LEFT OUTER JOIN
sem_7.organization
USING (id_org);

-- проверка
SELECT *
FROM sem_7.teacher_org_v;
/*
id_teach|last_name |first_name|birth_date|name_org        |
--------+----------+----------+----------+----------------+
       4|Иванов    |Иван      |          |Сбер            |
       5|Петров    |Петр      |          |Сбер            |
       1|Роздухова |Нина      |1992-04-15|АО Тинькофф Банк|
       2|Меркурьева|Надежда   |1995-03-12|АО Тинькофф Банк|
       3|Халяпов   |Александр |1994-09-30|X5 Retail Group |
       7|Данилов   |Глеб      |          |                |
       6|Сидоров   |Василий   |          |                |
*/

/*
    4. Создать view с полным списком преподавателей аналогично пункту (3).
       Фамилию и имя преподавателя объединить в одно поле.
       Поля назвать соответственно русским названиям
       – «Фамилия Имя», «Дата рождения», «Название организации»;
*/

CREATE OR REPLACE VIEW sem_7.teacher_org_name_v AS
SELECT id_teach, CONCAT(last_name, ' ', first_name) AS name, birth_date, name_org
FROM sem_7.teacher
LEFT OUTER JOIN
sem_7.organization
USING (id_org);

SELECT *
FROM sem_7.teacher_org_name_v;

/*
id_teach|name              |birth_date|name_org        |
--------+------------------+----------+----------------+
       4|Иванов Иван       |          |Сбер            |
       5|Петров Петр       |          |Сбер            |
       1|Роздухова Нина    |1992-04-15|АО Тинькофф Банк|
       2|Меркурьева Надежда|1995-03-12|АО Тинькофф Банк|
       3|Халяпов Александр |1994-09-30|X5 Retail Group |
       7|Данилов Глеб      |          |                |
       6|Сидоров Василий   |          |                |
*/

/*
    5. Написать вставку записи (на своё усмотрение) во view из пункта (1).
       Проверить, что новая запись появилась в исходной таблице;
*/

INSERT INTO sem_7.teacher_v
VALUES (8, 'Wick', 'John', '1964-09-02', 1500000.00, NULL);

SELECT *
FROM sem_7.teacher
WHERE last_name = 'Wick';
/*
id_teach|last_name|first_name|birth_date|salary_amt|id_org|
--------+---------+----------+----------+----------+------+
       8|Wick     |John      |1964-09-02|1500000.00|      |
*/

/*
    6. Написать удаление записи, вставленной в пункте (5), через view из пункта (1).
      Проверить, что запись удалилась из исходной таблицы;
*/

DELETE FROM sem_7.teacher_v
WHERE last_name = 'Wick';

SELECT *
FROM sem_7.teacher
WHERE last_name = 'Wick';
/*
id_teach|last_name|first_name|birth_date|salary_amt|id_org|
--------+---------+----------+----------+----------+------+
*/

/*
    7. Обновить дату рождения и у преподавателя id_teach = 4 (на любую) через view из пункта (1);
*/

UPDATE sem_7.teacher_v
SET birth_date = '1974-04-03'
WHERE id_teach = 4;

SELECT *
FROM sem_7.teacher
WHERE id_teach = 4;
/*
id_teach|last_name|first_name|birth_date|salary_amt|id_org|
--------+---------+----------+----------+----------+------+
       4|Иванов   |Иван      |1974-04-03| 100000.00|     3|
*/

/*
    8. Обновить id_org у преподавателя с id_teach = 4 на NULL через view из пункта (2).
       Проверить, что преподаватель пропал из view из пункта (2);
*/

UPDATE sem_7.teacher_with_org_v
SET id_org = NULL
WHERE id_teach = 4;

SELECT *
FROM sem_7.teacher_with_org_v
WHERE id_teach = 4;
/*
id_teach|last_name|first_name|birth_date|salary_amt|id_org|
--------+---------+----------+----------+----------+------+
*/

/*
    9. Пересоздать view и пункта (2) с условием [with local check option].
       Попробовать проделать те же манипуляции, что в пункте (8) на преподавателе id_teach = 5.
*/

CREATE OR REPLACE VIEW sem_7.teacher_with_org_v AS
SELECT *
FROM sem_7.teacher
WHERE id_org IS NOT NULL
WITH LOCAL CHECK OPTION;

UPDATE sem_7.teacher_with_org_v
SET id_org = NULL
WHERE id_teach = 5;
/*
SQL Error [44000]: ERROR: new row violates check option for view "teacher_with_org_v"
Detail: Failing row contains (5, Петров, Петр, null, 3000.00, null).
*/
   


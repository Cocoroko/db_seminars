-- ### 3. Практическое задание (триггеры)

/*
Пусть дана таблица `employee`,
в которой содержится информация о сотрудниках и их зарплате,
а также информация о том, кто
и когда в последний раз менял запись
(создайте и наполните ее самостоятельно):
*/

/* 1. Требуется создать триггер,
    который при любом добавлении или изменении строки в таблице
    сохраняет в этой строке
    информацию о текущем пользователе и отметку времени.
    Кроме того, он требует, чтобы было указано имя сотрудника и
    зарплата задавалась положительным числом.
*/

DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
    name text,
    salary int,
    last_change_role text,
    last_change_time timestamp
);

INSERT INTO employee
VALUES
('Aang', 1, NULL, NULL),
('Zuko', 99999, NULL, NULL);

CREATE OR REPLACE FUNCTION employee_insert_row() RETURNS TRIGGER AS
$$
BEGIN
    IF (NEW.name IS NULL OR NEW.salary IS NULL OR NEW.salary < 0) THEN
        RETURN NULL;
    END IF;
    NEW.last_change_role = current_user;
    NEW.last_change_time = current_timestamp;
    RETURN NEW;
END

$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE TRIGGER employee_insert_trigger
    BEFORE INSERT OR UPDATE ON employee
    FOR EACH ROW
    EXECUTE FUNCTION employee_insert_row();

INSERT INTO employee
VALUES ('Toph', 10000, NULL, NULL);

UPDATE employee
SET salary = 0
WHERE name = 'Zuko';

SELECT *
FROM employee;
/*
name|salary|last_change_role|last_change_time       |
----+------+----------------+-----------------------+
Aang|     1|                |                       |
Toph| 10000|postgres        |2024-01-09 12:34:25.032|
Zuko|     0|postgres        |2024-02-09 14:00:36.002|
*/





/*
2. Создать триггер, который будет записывать все изменения таблицы `employee` в отдельную таблицу логов.
Информация, которая должна быть отражена в таблице логов:
    * какая операция была совершена;
    * время операции;
    * пользователь, который совершил операцию;
    * значения новых полей.
*/

CREATE TABLE employee_history(
    operation_id serial,
    operation_type text,
    operation_time timestamp,
    operation_user text,
    new_name text,
    new_salary text
);

CREATE OR REPLACE FUNCTION employee_change_history_row() RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO employee_history(operation_type, operation_time, operation_user, new_name, new_salary)
    VALUES (TG_OP, current_timestamp, current_user, NEW.name, NEW.salary);
    RETURN NEW;
END

$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE TRIGGER employee_change_history_trigger
    BEFORE INSERT OR UPDATE ON employee
    FOR EACH ROW
    EXECUTE FUNCTION employee_change_history_row();

INSERT INTO employee(name, salary)
VALUES('Katara', 20);

UPDATE employee
SET salary = salary + 100
WHERE name = 'Katara' OR name = 'Aang';

UPDATE employee
SET salary = 0
WHERE name = 'Zuko';

SELECT *
FROM employee_history;
/*
operation_id|operation_type|operation_time         |operation_user|new_name|new_salary|
------------+--------------+-----------------------+--------------+--------+----------+
           1|INSERT        |2024-03-09 02:46:51.735|postgres      |Katara  |20        |
           2|UPDATE        |2024-03-09 02:46:55.037|postgres      |Aang    |101       |
           3|UPDATE        |2024-03-09 02:46:55.037|postgres      |Katara  |120       |
           4|UPDATE        |2024-03-09 02:46:57.330|postgres      |Zuko    |0         |
*/


## PostgreSQL и CHECK OPTION

[оригинал на английском](https://www.postgresqltutorial.com/postgresql-views/postgresql-views-with-check-option/)

Краткое описание: в этом руководстве вы узнаете, как создать обновляемое представление, используя WITH CHECK OPTION.
CHECK OPTION позволяет гарантировать, что изменения в базовых таблицах с помощью представления удовлетворяют условию, определяющему представление.
(Т.е. изменятся только строки, которые могли находиться в представлении).

Напоминание:
Представление (View) - это сохранённый именованый запроc. Простой View может быть обновляемым (т.е. через такой View можно обновлять исходные таблицы).

Используйте WITH CHECK OPTION, чтобы убедиться, что любое изменение данных через View, соответствует условиям из определения View (запроса, порождающего представление).

Как правило, вы указываете параметр WITH CHECK при создании представления с помощью инструкции CREATE VIEW:
```postgresql
CREATE VIEW view_name AS query
WITH CHECK OPTION;
```


### Область проверки (Scope of check)
В PostgreSQL вы можете указать область проверки условий:

```postgresql
LOCAL
```
```postgresql
CASCADED
```

LOCAL ограничивает применение опции проверки только текущим представлением. Она не применяет проверку к представлениям, на которых основано текущее представление.

CASCADED проверяет все представления, на которых основано текущее.

Синтаксис создания представления WITH LOCAL CHECK OPTION:

```postgresql
CREATE VIEW view_name AS
query
WITH LOCAL CHECK OPTION;
```

```postgresql
CREATE VIEW view_name AS
query
WITH CASCADED CHECK OPTION;
```

Используйте ALTER VIEW, чтобы изменить область проверки в существующем представлении.

```postgresql
ALTER VIEW employee_view
SET (check_option = CASCADED);
```

### Примеры

Создадим таблицу сотрудников.
```postgresql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INT,
    employee_type VARCHAR(20) 
       CHECK (employee_type IN ('FTE', 'Contractor'))
);


INSERT INTO employees (first_name, last_name, department_id, employee_type)
VALUES
    ('John', 'Doe', 1, 'FTE'),
    ('Jane', 'Smith', 2, 'FTE'),
    ('Bob', 'Johnson', 1, 'Contractor'),
    ('Alice', 'Williams', 3, 'FTE'),
    ('Charlie', 'Brown', 2, 'Contractor'),
    ('Eva', 'Jones', 1, 'FTE'),
    ('Frank', 'Miller', 3, 'FTE'),
    ('Grace', 'Davis', 2, 'Contractor'),
    ('Henry', 'Clark', 1, 'FTE'),
    ('Ivy', 'Moore', 3, 'Contractor');
```

Создадим представление, хранящее только сотрудников с type = 'FTE'.
```postgresql
CREATE OR REPLACE VIEW fte_v AS 
SELECT 
  id, 
  first_name, 
  last_name, 
  department_id,
  employee_type
FROM 
  employees 
WHERE 
  employee_type = 'FTE';

SELECT * FROM fte_v;
Output:

 id | first_name | last_name | department_id
----+------------+-----------+---------------
  1 | John       | Doe       |             1
  2 | Jane       | Smith     |             2
  4 | Alice      | Williams  |             3
  6 | Eva        | Jones     |             1
  7 | Frank      | Miller    |             3
  9 | Henry      | Clark     |             1
(6 rows)
```

Теперь добавим нового сотрудника:
```postgresql
INSERT INTO fte_v(first_name, last_name, department_id, employee_type) 
VALUES ('John', 'Smith', 1, 'Contractor');
```
Код успешно выполнен.

Проблема - добавили сотрудника типа 'Contractor' через представление, отвечающее за 'FTE'.

Чтобы быть уверенным, что через VIEW fte_v возможно добавить только 'FTE' сотрудников - используем  WITH CHECK OPTION:

Fourth, replace the fte_v view and add the WITH CHECK OPTION:

```postgresql
CREATE OR REPLACE VIEW fte_v AS 
SELECT 
  id, 
  first_name, 
  last_name, 
  department_id,
  employee_type
FROM 
  employees 
WHERE 
  employee_type = 'FTE'
WITH CHECK OPTION;
```

После указания WITH CHECK OPTION:
INSERT, UPDATE, DELETE будут выполнятся в таблице employee только на строчках, удовлетворяющих условию WHERE из запроса-определения представления.

Например, исполнение следующей инструкции INSERT выдаст ошибку:
```postgresql
INSERT INTO fte_v(first_name, last_name, department_id, employee_type) 
VALUES ('John', 'Snow', 1, 'Contractor');
```
Ошибка:
```javascript
ERROR:  new row violates check option for view "fte"
DETAIL:  Failing row contains (12, John, Snow, 1, Contractor).
```

Причина ошибки в том, что тип сотрудник employee_type = 'Contractor' не удовлетворяет условию из запроса-определения представления:

```postgresql
employee_type = 'FTE';
```

Но при попытке изменить запись с сотрудником типа FTE изменение будет благополучно совершено.
Fifth, change the last name of the employee id 2 to 'Doe':

```postgresql
UPDATE fte_v
SET last_name = 'Doe'
WHERE id = 2;
```

Работает как ожидалось.

### Пример использования WITH LOCAL CHECK OPTION
Создадим fte_v view без использования WITH CHECK OPTION:

```postgresql
CREATE OR REPLACE VIEW fte_v AS 
SELECT 
  id, 
  first_name, 
  last_name, 
  department_id,
  employee_type
FROM 
  employees 
WHERE 
  employee_type = 'FTE';
```

Теперь создадим представление fte_v_1, основанное на fte и оставляющее только сотрудников из отдела 1 (department = 1), с WITH LOCAL CHECK OPTION:

```postgresql
CREATE OR REPLACE VIEW fte_1 
AS 
SELECT 
  id, 
  first_name, 
  last_name, 
  department_id, 
  employee_type 
FROM 
  fte 
WHERE 
  department_id = 1 
WITH LOCAL CHECK OPTION;
```
```postgresql
SELECT * FROM fte_1;
Code language: SQL (Structured Query Language) (sql)
Output:

 id | first_name | last_name | department_id | employee_type
----+------------+-----------+---------------+---------------
  1 | John       | Doe       |             1 | FTE
  6 | Eva        | Jones     |             1 | FTE
  9 | Henry      | Clark     |             1 | FTE
(3 rows)
```
Так как используется WITH LOCAL CHECK OPTION, PostgreSQL проверит только fte_v_1 при изменении данных через это представление (fte_v_1).

Fourth, insert a new row into the employees table via the fte_1 view:
Добавим строку с новым сотрудником через представление fte_1_v:

```postgresql
INSERT INTO fte_1(first_name, last_name, department_id, employee_type)
VALUES ('Miller', 'Jackson', 1, 'Contractor');
```

Успешно выполнено.
Причина в том, что INSERT добавляет новые значения с department = 1, что удовлетворяет условию в представлении fte_1_v:

```postgresql
department_id = 1
```
Запросим информацию из таблицы employees:

```postgresql
SELECT 
  * 
FROM 
  employees 
WHERE 
  first_name = 'Miller' 
  and last_name = 'Jackson';

Output:

 id | first_name | last_name | department_id | employee_type
----+------------+-----------+---------------+---------------
 12 | Miller     | Jackson   |             1 | Contractor
(1 row)
```

### Использование WITH CASCADED CHECK OPTION example
Пересоздадим представление fte_1_v с WITH CASCADED CHECK OPTION:

```postgresql
CREATE OR REPLACE VIEW fte_1_v
AS 
SELECT 
  id, 
  first_name, 
  last_name, 
  department_id, 
  employee_type 
FROM 
  fte 
WHERE 
  department_id = 1 
WITH CASCADED CHECK OPTION;
```

Теперь добавим новую запись в таблицу employee через представление fte_1_v:

```postgresql
INSERT INTO fte_1(first_name, last_name, department_id, employee_type) 
VALUES ('Peter', 'Taylor', 1, 'Contractor');
```

Ошибка:
```postgresql
ERROR:  new row violates check option for view "fte"
DETAIL:  Failing row contains (24, Peter, Taylor, 1, Contractor).
```

WITH CASCADED CHECK OPTION указывает PostgreSQL проверять ограничения на fte_1_v а также для его базового представления fte_v.

Вот почему инструкция INSERT нарушает условие fte_1_v и fte_v.

### Резюмируя:
Используйте WITH CHECK OPTION чтобы наложить ограничения на изменения данных через представления и убедиться, что только соответствующая информация может быть изменена.


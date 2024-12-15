-- ### 2. Практическое задание (функции)

-- 1. Требуется написать функцию, которая будет выводить на экран фразу «Hello, World!».

DROP FUNCTION print_hello();

-- на plpgsql
CREATE OR REPLACE FUNCTION print_hello() RETURNS text AS
$$
    BEGIN
        RETURN 'Hello, World!';
    END;
$$ LANGUAGE 'plpgsql';

SELECT print_hello();
/*
print_hello  |
-------------+
Hello, World!|
*/

-- или так, на чистом sql:
CREATE OR REPLACE FUNCTION print_hello_sql() RETURNS text AS
$$
    SELECT 'Hello, World!';
$$ LANGUAGE 'sql';

SELECT print_hello_sql();
/*
print_hello_sql|
---------------+
Hello, World!  |
*/






-- 2. Требуется написать функцию, которая будет переворачивать строку, получаемую на вход;

-- Встроенная функция:
SELECT reverse('Hello, World!');
/*
reverse      |
-------------+
!dlroW ,olleH|
*/

-- Рукописная функция:
-- Не рекомендую писать эту функцию через FOR на PLPGSQL,
-- т.к. язык не поддерживает обращение к символу в тексте по индексу

-- так что нам придётся итерироваться по массиву символов, полученному из этой строки:
CREATE OR REPLACE FUNCTION reverse_custom(s varchar) RETURNS text AS
$$
DECLARE
    n int;
    c char;
    s_array char[];
BEGIN
    s_array := regexp_split_to_array(s, '');
    n := length(s);

    FOR i IN 0..(n / 2) LOOP
        c = s_array[i];
        s_array[i] = s_array[n - 1 - i];
        s_array[n - 1 - i] = c;
    END LOOP;

    RETURN array_to_string(s_array,'');

    /*FOR i IN 0..(n / 2) LOOP
        c = s[i];
        s[i] = s[n - 1 - i];
        s[n - 1 - i] = i;
    END LOOP;
    RETURN s;*/
END;
$$ LANGUAGE 'plpgsql';

SELECT reverse_custom('Hello, World!');
/*
reverse_custom|
--------------+
dlroW ,olleH! |
*/






-- 3. Требуется написать функцию, которая будет рассчитывать факториал заданного числа;

-- Напишем рекурсивно:
CREATE OR REPLACE FUNCTION factorial_recursive(n int) RETURNS int AS
$$
BEGIN
    IF (n <= 1) THEN
        RETURN 1;
    ELSE
        RETURN n * (factorial_recursive(n - 1));
    END IF;
END;
$$ LANGUAGE 'plpgsql';

SELECT factorial_recursive(5);
/*
factorial_recursive|
-------------------+
                120|
*/

-- Напишем циклом:
CREATE OR REPLACE FUNCTION factorial(n int) RETURNS int AS
$$
DECLARE fact int;
BEGIN
    fact := 1;
    FOR i IN 2..n LOOP 
        fact := fact * i;
    END LOOP;
    RETURN fact;
END;
$$ LANGUAGE 'plpgsql';

SELECT factorial(5);
/*
factorial|
---------+
      120|
*/

-- нам сообщают в случае переполнения:
SELECT factorial(1000);
/*
SQL Error [22003]: ERROR: integer out of range
  Where: PL/pgSQL function factorial(integer) line 6 at assignment
*/







-- 4. Требуется написать функцию, которая будет прибавлять к дате в формате `YYYY-MM-DD` n дней;

CREATE OR REPLACE FUNCTION date_add(date_s text, n int) RETURNS text AS
$$
DECLARE date_res date;
BEGIN
    date_res := to_date(date_s,'YYYY-MM-DD');
    date_res := date_res + n;
    RETURN TO_CHAR(date_res, 'YYYY-MM-DD');
END

$$ LANGUAGE 'plpgsql';

SELECT date_add('2001-03-09', 23 * 365);






-- 5. Требуется написать код, который создаст копии всех имеющихся таблиц вашей БД какой-либо схемы, например, добавив к
--    ним суффикс `copy`.
SELECT table_name
FROM information_schema.TABLES
WHERE table_schema = 'sem_7';
/*
table_name        |
------------------+
organization      |
teacher           |
teacher_v         |
teacher_org_v     |
teacher_org_name_v|
teacher_with_org_v|
*/

CREATE OR REPLACE FUNCTION copy_tables(schema_name text, suffix text) RETURNS int AS
$$
DECLARE t_name text;
BEGIN
    FOR t_name IN
        SELECT table_name
        FROM information_schema.TABLES
        WHERE table_schema = 'sem_7'
    LOOP
        EXECUTE format('CREATE TABLE %I.%I AS SELECT * FROM %I.%I',
                       schema_name, t_name || suffix, schema_name, t_name);
    END LOOP;
        
    RETURN 0;
END

$$ LANGUAGE 'plpgsql';

SELECT copy_tables('sem_7', '_copy');

SELECT table_name
FROM information_schema.TABLES
WHERE table_schema = 'sem_7';
/*
table_name             |
-----------------------+
teacher_v_copy         |
organization           |
teacher                |
teacher_v              |
teacher_org_v          |
teacher_org_name_v     |
teacher_with_org_v     |
organization_copy      |
teacher_copy           |
teacher_org_v_copy     |
teacher_org_name_v_copy|
teacher_with_org_v_copy|
*/

create user post2 with password 'password';

--1. Создать схему topic_6:

CREATE schema if not EXISTS topic_6;
grant all on schema topic_6 to post2;
--Создать таблицу:

drop table if exists topic_6.test_table;

CREATE TABLE topic_6.test_table (
    my_id         SERIAL,
    my_text_field TEXT
);

grant all on topic_6.test_table to post2;
grant usage, select on all sequences in schema topic_6 to post2;

--2. Открыть новую транзакцию в явном виде. Запустить операцию вставки

begin;

INSERT INTO topic_6.test_table (my_text_field) VALUES ('test_value1');

--Не завершая транзакцию, проверить, что данные в таблицу вставились. Обратить внимание на значение в поле my_id.

select * from topic_6.test_table; --Видим изменения в таблице

--3. В новой консоли написать запрос на получение всех строк таблицы, созданной в п.2. Объясните, почему так вышло.
--Закоммитьте изменения в консоли 1.

commit;

--4.В обеих консолях откройте новые транзакции.

begin;


--Напишите в первой консоли апдейт к единственной строке таблицы. Проверьте, что первая транзакция видит изменения.
update topic_6.test_table set my_text_field = 'test_value2';

select * from topic_6.test_table; -- Видим обновление строки в таблице

--Во второй консоли запустите операцию апдейта к той же строке. Подумайте, что произошло и почему?

--Сохраните изменения в первой консоли. Что произошло со второй консолью?

commit;

--Сохраните изменения во второй консоли.



--6. Повторите предыдущее упражнение с использованием уровня repeatable read. Что произошло при попытке закоммитить
--изменения первой открытой транзакцией? Откатите обе транзакции.

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

update topic_6.test_table set my_text_field = 'test_value6';

select * from topic_6.test_table;

commit;  

rollback;

--7. Для получения дефолтного значения уровня изолированности транзакций в вашем постгрес воспользуйтесь командой:



SHOW default_transaction_isolation;
--Объясните разницу в поведении транзакций в задачах 6 и 7, воспользовавшись новым знанием.


--8. Повторите задачу 5, используя оператор вставки данных, а не обновления, по аналогии с п.3. Посмотрите на значение в
--поле my_id после вставки второй транзакцией.

begin;

insert into topic_6.test_table (my_text_field)
values
('test 8 first');

rollback;

--9. В обеих консолях откройте новые транзакции уровня serializable


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

--Первой транзакцией считайте данные из таблицы.

select * from topic_6.test_table;

--Второй транзакцией осуществите вставку в таблицу новых данных. И сразу же примените изменения.

--Снова считайте данные первой транзакцией. Что произошло?

select * from topic_6.test_table;  --Никаких изменений не было замечено

--Попробуйте добавить в таблицу данные с использованием первой транзакции. Что произошло? Откатите изменения.

insert into topic_6.test_table (my_text_field)
values
('test 9 first');  --значение вставилось, но не видно изменений из второй консоли

select * from topic_6.test_table;

rollback;

--10. Откройте новую транзакцию в любой консоли, уровень изолированности не имеет значения.

begin;

--Добавьте в таблицу несколько строк.

insert into topic_6.test_table (my_text_field)
values
 ('test 10.1 first')
,('test 10.2 first')
,('test 10.3 first')
,('test 10.4 first');

--Создайте точку останова (savepoint) и посмотрите на значения в таблице.

savepoint save1;


--Снова добавьте в таблицу несколько строк, создайте точку останова и посмотрите на строки в таблице.

insert into topic_6.test_table (my_text_field)
values
 ('test 10.5 first')
,('test 10.6 first');

savepoint save2;

select * from topic_6.test_table; --видим, что все изменения сохранились в таблице

--Добавьте в таблицу еще одну строк и посмотрите на таблицу.

insert into topic_6.test_table (my_text_field)
values
 ('test 10.7 first');

select * from topic_6.test_table;  --видим последнее изменение

--Откатитесь ко второй точке останова и посмотрите на данные.

rollback to savepoint save2;

select * from topic_6.test_table; -- видим, что последнее изменение откатилось

--Откатитесь к первой точке останова и посмотрите на данные.

rollback to savepoint save1;

select * from topic_6.test_table; -- откатились до самого начала

--Откатите всю транзакцию.

rollback;
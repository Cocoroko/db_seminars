## Горизонтальное масштабирование, хранение на разных машинах

> [Оригинал на английском](https://pgdash.io/blog/horizontally-scaling-postgresql.html)

### Недостатки решения через партицирование

Партицирование купирует проблему работы с большими данными, но не решает ее полностью. Например, данных может быть настолько много, что
они не умещаются на одну машину. Или запросов на запись/чтение данных может быть очень много и сами запросы могут быть очень трудоемкими,
а вертикальное масштабирование имеет свои границы (расширение оперативной памяти, более вместительные диски, более мощный процессор).


### Доступ к таблицам на других серверах

Не все данные, распределенные по серверам, могут нуждаться в репликации или обновлении в режиме реального времени. Данные могут быть в основном статическими, предназначенными для справки, поиска или исторических данных и т. д. Доступ к таким данным можно получить с основных серверов OLTP/OLAP с использованием foreign data wrappers (FDW).

FDW позволяют работать с «чужими данными», которые могут находиться где угодно за пределами сервера Postgres. Возможность работы с данными с другого сервера Postgres реализована с помощью postgres_fdw — расширения, доступного в PostgreSQL.

### Postgres FDW
Вот как Postgres FDW выглядит на практике. Предположим, что есть исходная база данных с таблицей, например:

```sql
srcdb=# create table srct (a int primary key);
CREATE TABLE

srcdb=# insert into srct (a) select generate_series(1, 100);
INSERT 0 100
At a destination server, you can setup a foreign table srct, which acts a proxy table for the actual srct table that lives in our source database:

destdb=# create extension postgres_fdw;
CREATE EXTENSION

destdb=# create server src foreign data wrapper postgres_fdw options (host '/tmp', port '6000', dbname 'srcdb');
CREATE SERVER

destdb=# create user mapping for current_user server src;
CREATE USER MAPPING

destdb=# import foreign schema public limit to (srct) from server src into public;
IMPORT FOREIGN SCHEMA

destdb=# select count(*) from srct;
 count
-------
   100
(1 row)
```

Внешняя таблица не занимает места и не содержит данных — она просто служит оболочкой для ссылки на реальную таблицу, находящуюся где-то в другом месте. Расширение postgres_fdw целевого сервера Postgres установит и будет поддерживать соединение с исходным сервером Postgres, преобразуя каждый запрос, включающий внешнюю таблицу, в соответствующие сетевые вызовы.

Внешняя таблица может работать без проблем с обычными локальными таблицами, как в этом соединении:

```postgresql
destdb=# create table destt (b int primary key, c text);
CREATE TABLE

destdb=# insert into destt (b,c) values (10,'foo'), (20,'bar');
INSERT 0 2

destdb=# select a,b,c from srct join destt on srct.a = destt.b;
 a  | b  |  c
----+----+-----
 10 | 10 | foo
 20 | 20 | bar
(2 rows)
```

Основная задача FDW — максимально перенести работу на удаленный сервер и минимизировать объем данных, передаваемых туда и обратно между двумя серверами. Например, вы хотите, чтобы удаленный сервер обрабатывал ограничение на данные, а не извлекал все строки и затем применял ограничение на данные локально. Однако, учитывая сложность SQL, а также планировщика и исполнителя запросов PostgreSQL, это непростая задача. Эффективность продолжает улучшаться с каждой версией, но некоторые запросы могут занять слишком много времени или больше рабочей памяти, чем вы ожидаете.

### Materialized Views + Foreign Data Wrappers

В зависимости от вашего варианта использования объединение материализованных представлений с FDW может предложить разумный баланс между репликацией полной таблицы и ее полностью удаленным (внешним) доступом. Материализованное представление может эффективно функционировать как локальный кэш, который, в свою очередь, можно использовать вместе с локальными таблицами для обеспечения производительности локального уровня.

```sql
destdb=# create materialized view destmv as select a,b,c from srct join destt on srct.a = destt.b;
SELECT 2

destdb=# select * from destmv;
 a  | b  |  c
----+----+-----
 10 | 10 | foo
 20 | 20 | bar
(2 rows)
```

"Кэш” можно обновлять в любое время, периодически или иным образом, с помощью обычной команды “REFRESH MATERIALIZED VIEW”. В качестве бонуса в представлении можно определить (локальные) индексы для дальнейшего ускорения запросов.

### Распределение строк таблицы по серверам

Сегментирование (Sharding) строк одной таблицы на нескольких серверах с одновременным предоставлением SQL-клиентам унифицированного интерфейса обычной таблицы — пожалуй, наиболее востребованное решение для работы с большими таблицами. Такой подход упрощает приложения и заставляет администраторов баз данных работать усерднее!

Разделение таблиц на части, чтобы запросы работали только с соответствующими строками, желательно параллельно, является основным принципом сегментирования. В PostgreSQL v10 появилась функция секционирования, которая с тех пор претерпела множество улучшений и получила широкое распространение.

Вертикальное масштабирование с использованием секционирования предполагает создание разделов в разных табличных пространствах (на разных дисках). Горизонтальное масштабирование предполагает объединение секционирования и FDW.

### Partitioning + FDW
Going with the example from the Postgres documentation, let’s create the partition root table measurement having one local partition table and one foreign partition table:

Используя пример из документации Postgres, давайте создадим корневую секционированную таблицу measurement, имеющую одну локальную таблицу и одну внешнюю таблицу:

```postgresql
destdb=# CREATE TABLE measurement (
    city_id         int not null,
    logdate         date not null,
    peaktemp        int,
    unitsales       int
) PARTITION BY RANGE (logdate);
CREATE TABLE

destdb=# CREATE TABLE measurement_y2023
PARTITION OF measurement
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
CREATE TABLE

destdb=# CREATE FOREIGN TABLE measurement_y2022
PARTITION OF measurement
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01')
SERVER src;
CREATE FOREIGN TABLE
The foreign table is only a proxy, so the actual table itself must be present on the foreign server:

srcdb=# CREATE TABLE measurement_y2022 (
    city_id         int not null,
    logdate         date not null
        CHECK (logdate >= '2022-01-01' and logdate <= '2023-01-01'),
    peaktemp        int,
    unitsales       int
);
CREATE TABLE
```

Теперь мы можем вставлять строки в корневую таблицу и направлять их в соответствующий раздел. Вы можете видеть, что запрос SELECT выполняет как локальное, так и внешнее сканирование и объединяет результаты.

```postgresql
destdb=# insert into measurement (city_id, logdate, peaktemp, unitsales)
values (1, '2022-01-03', 66, 100), (1, '2023-01-03', 67, 300);
INSERT 0 2

destdb=# select * from measurement;
 city_id |  logdate   | peaktemp | unitsales
---------+------------+----------+-----------
       1 | 2022-01-03 |       66 |       100
       1 | 2023-01-03 |       67 |       300
(2 rows)

destdb=# explain select * from measurement;
                                           QUERY PLAN
-------------------------------------------------------------------------------------------------
 Append  (cost=100.00..219.43 rows=3898 width=16)
   ->  Foreign Scan on measurement_y2022 measurement_1  (cost=100.00..171.44 rows=2048 width=16)
   ->  Seq Scan on measurement_y2023 measurement_2  (cost=0.00..28.50 rows=1850 width=16)
(3 rows)
```
Однако как секционирование, так и внешние таблицы по-прежнему имеют ограничения реализации в PostgreSQL, а это означает, что этот способ работает удовлетворительно только для простых таблиц и базовых запросов.

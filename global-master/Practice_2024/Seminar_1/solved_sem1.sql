-- 1. Создать схему sem_1:

CREATE SCHEMA IF NOT EXISTS sem_1;

--2. Создать таблицу sem_1.movies с полями
-- title (название фильма)
-- release_year (год выпуска)
-- duration_min (длительность в мин)
-- genre (жанры)
-- rating (рейтинг)
-- director (режиссёр)
-- star_1 (1й главный актёр)
-- star_2 (2й главный актёр)

DROP TABLE IF EXISTS sem_1.movies;
CREATE TABLE sem_1.movies (
    title VARCHAR(100),
    release_year INTEGER,
    duration_min INTEGER,
    genre VARCHAR,
    rating NUMERIC,
    director VARCHAR(50),
    star_1 VARCHAR(50),
    star_2 VARCHAR(50)
);

--3. Посмотреть метаданные о таблице и столбцах в information_schema.tables и information_schema.columns

SELECT *
FROM information_schema.tables
WHERE table_schema = 'sem_1';

SELECT *
FROM information_schema.columns
WHERE table_schema = 'sem_1';

--4. Выведи всё содержимое таблицы
SELECT *
FROM sem_1.movies;

--5. Выведи все названия фильмов и их год выпуска
SELECT title, release_year
FROM sem_1.movies;

--6. Выведите всех режиссёров, встречающихся в таблице
SELECT DISTINCT director
FROM sem_1.movies;


--7. В каком году был снят 'Fight Club'? Вывести только год

SELECT release_year
FROM sem_1.movies
WHERE title = 'Fight Club';

--8. Выведите все фильмы 'Christopher Nolan', год и рейтинг

SELECT title, release_year,rating
FROM sem_1.movies
WHERE director = 'Christopher Nolan';

--9. Выведите все фильмы, в которых главную роль сыграл 'Christian Bale'

SELECT title
FROM sem_1.movies
WHERE star_1 = 'Christian Bale' OR star_2 = 'Christian Bale';

--10. Найдите все комедии (Comedy) длительностью меньше 2х часов и с рейтингом не менее 8.5
-- Выводить название фильма, год, длительность, жанр, рейтинг

SELECT title, release_year, duration_min, genre, rating
FROM sem_1.movies
WHERE genre LIKE '%Comedy%' AND duration_min < 120 AND rating >= 8.5;

--11. Выведите все фильмы, снятые до 2010 года, в которых снимался 'Leonardo DiCaprio' или 'Tom Hanks'.
-- Выводить название фильма, год, двух главных героев

SELECT title, release_year, star_1, star_2
FROM sem_1.movies
WHERE release_year < 2010 AND (star_1 IN ('Leonardo DiCaprio','Tom Hanks') OR star_2 IN ('Leonardo DiCaprio','Tom Hanks'));

--12. Выведите все фильмы жанра 'Drama'
-- Учитывайте, как лежат данные в столбце genre

SELECT *
FROM sem_1.movies
WHERE genre LIKE '%Drama%';

--13. Выведите всех актёров, которых зовут Jack, Sam или John (можно только для star_1).

SELECT DISTINCT star_1 AS actor
FROM sem_1.movies
WHERE star_1 SIMILAR TO '(Jack|Sam|John) %'
UNION
SELECT DISTINCT star_2 AS actor
FROM sem_1.movies
WHERE star_2 SIMILAR TO '(Jack|Sam|John) %';

--14. Выведите все названия фильмов, в которых содержится либо цифра 3, либо цифра 7.

SELECT DISTINCT title
FROM sem_1.movies
WHERE title SIMILAR TO '%(7|3)%';

--15. Найдите кол-во фильмов, кол-во различных режиссёров, самый ранний и поздний год релиза

SELECT COUNT(*) AS film_cnt,
       COUNT(DISTINCT director) AS director_cnt,
       MIN(release_year) AS min_year,
       MAX(release_year) AS max_year
FROM sem_1.movies;

--16. Выведите для каждого режиссёра кол-во его фильмов. Упорядочить по убыванию кол-ва фильмов

SELECT director, COUNT(*) AS film_cnt
FROM sem_1.movies
GROUP BY 1
ORDER BY 2 desc;

--17. Сколько часов займёт просмотр всех фильмов 'Quentin Tarantino'?

SELECT SUM(duration_min) / 60 as ans
FROM sem_1.movies
WHERE director = 'Quentin Tarantino';

-- 18. Выведите всех актёров, которые были 1-м главным актёром в более чем 3х фильмах,
-- и кол-во таких фильмов соответственно

SELECT star_1, COUNT(*) AS film_cnt
FROM sem_1.movies
GROUP BY 1
HAVING COUNT(*) > 3;

--19. Найдите всех режиссёров 21го века (первый фильм был снят после 2000го года). Вывести режиссёра и год первого фильма

SELECT director, MIN(release_year) as first_film_year
FROM sem_1.movies
GROUP BY 1
HAVING MIN(release_year) > 2000;

--20. Выведите фильм с самым большим рейтингом

SELECT *
FROM sem_1.movies
ORDER BY rating desc
LIMIT 1;

--21. Выведите для каждого режиссёра его самый ранний фильм (при равенстве годов выводить с наибольшим рейтингом)
-- Вывести стобцы режиссёр, название фильма, год, рейтинг

SELECT DISTINCT ON (director) director, title, release_year, rating
FROM sem_1.movies
ORDER BY 1, 4 desc;

--22. Найдите кол-во и средний рейтинг фильмов для двух категорий: фильмы 20го и 21го века
-- Округлить до двух знаков после запятой

SELECT
    CASE WHEN release_year <= 2000 THEN '20й век'
        ELSE '21й век'
    END AS category,
    CAST(AVG(rating) AS NUMERIC(3, 2)) AS avg_rating,
    COUNT(DISTINCT title) as film_cnt
FROM sem_1.movies
GROUP BY 1;


--Работа с датами

--23. Создадим таблицу с операциями:

DROP TABLE IF EXISTS sem_1.operations;
CREATE TABLE sem_1.operations (
    operation_id SERIAL,
    operation_dt DATE,
    client_rk INTEGER,
    operation_amt INTEGER
);

INSERT INTO sem_1.operations (operation_dt, client_rk, operation_amt) VALUES
    ('2023-12-01', 1, 1000),
    ('2024-01-01', 2, 100),
    ('2024-01-05', 1, 10),
    ('2024-01-07', 5, 50),
    ('2024-01-15', 7, 500),
    ('2024-01-21', 3, 5000),
    ('2024-01-31', 9, 500),
    ('2024-02-01', 4, 500);
;

-- 24. Как найти для каждого клиента сумму операций за последний месяц? (если сегодня 2 февраля, то операции считаем со 2го января)

SELECT client_rk, SUM (operation_amt) as last_mnth_sum
FROM sem_1.operations
WHERE operation_dt >= current_date - interval '1 month'
GROUP BY 1;

-- 25. Как найти для каждого клиента среднюю сумму операций за текущий месяц (если сегодня 2 февраля, то только за февраль)?

SELECT client_rk, AVG (operation_amt) as last_mnth_sum
FROM sem_1.operations
WHERE DATE_TRUNC('month', operation_dt) = DATE_TRUNC('month', current_date)
GROUP BY 1;

--26. Найдите сумму платежей в каждом квартале

SELECT TO_CHAR(operation_dt, 'YYYY"-Q"Q') as quarter, SUM(operation_amt)
FROM sem_1.operations
GROUP BY 1
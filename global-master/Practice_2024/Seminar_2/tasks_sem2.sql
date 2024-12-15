-- 1. Создать схему sem_2:

--2. Создать следующие таблицы. Какие первичные и внешние ключи нужны здесь? Создайте их.
-- Колонку id заведите типа serial. Как называется такой вид ключа?
/*
movies
id (идентификатор фильма)
title (название фильма)
release_year (год выпуска)
duration_min (длительность в мин)
rating (рейтинг)
director (режиссёр)
*/


/*
actors
id (идентификатор актёра)
first_nm (имя актёра)
last_nm (фамилия актёра)
*/


/*
cast
movie_id (идентификатор фильма)
actor_id (идентификатор актёра)
character_nm (персонаж)
*/

/*
genres
movie_id (идентификатор фильма)
genre_nm (жанр)
*/


--3. Заполнить таблицу movies 3 тестовыми строками.


--4. Добавить в таблицу movies новое поле `comment`.


--5. Написать запрос для обновления поля с комментарием. 
-- Для каждой строки необходимо указать свой комментарий. 
-- Подумайте, как это сделать одной операций `UPDATE`, а не пятью разными запросами.


--6. Удалить одну из строк таблицы на выбор.



--7. Очистить таблицу, используя оператор группы DDL.


--8. Снова заполните таблицу и обратите внимание на идентификаторы. Снова очистите полностью.


--9. Удалить из таблицы столбец с комментарием.


--10. Запустить операции вставки из отдельного файла

--11. Найдите все фильмы жанра Crime. Вывести название фильма, год выпуска и рейтинг
	
--12. Найдите ID актёров, по которым нет информации о фильмах, в которых они снимались

--13. Как зовут актёра, игравшего 'Harry Potter'?

--14. Выведите все фильмы 90х жанров Drama и Romance

--15. Для каждого жанра найдите кол-во фильмов и средний рейтинг
-- Отсортировать по убыванию среднего рейтинга, при равенстве по убыванию кол-ва фильмов
	
--16. Для каждого актёра выведите кол-во фильмов, в которых он сыграл (может быть 0).
-- Отсортировать по убыванию кол-ва фильмов

--17. Найдите все фильмы, в которых играл Jake Gyllenhaal. Выведите название фильма,
-- год выпуска и длительность. Отсортируйте по увеличению длительности фильма

--18. Выведите все фильмы с актёром, который играл 'Captain Jack Sparrow'
	
--19. Для каждого фильма выведите его жанры через запятую в виде строки 
-- (например, с помощью STRING_AGG)
-- Если для фильма не указан жанр, вывести -.

--20. Найдите всех актёров, которых играли вместе с Leonardo DiCaprio.
-- Опционально: вывести фильмы, в которых они играли вместе. 



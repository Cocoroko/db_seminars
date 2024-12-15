-- Оконные функции.

--1. Создать таблицу и заполнить ее данными согласно скрипту.


--2. Вывести все товары и среднюю цену товара в каждой из категорий в отдельном столбце. Ответ округлить до целого

select p.product_id, p.product_name
     , pg.group_name
     , round(avg(p.price) over(partition by p.group_id), 0) as avg_price
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;

--3. Вывести номер товара в порядке возрастания цены в каждой группе.

 select p.product_id, p.product_name
     , pg.group_name, p.price
     , row_number() over(partition by p.group_id order by p.price asc)
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;

--4. Повторить предыдущий шаг, но товары с одинаковой ценой должны иметь одинаковый порядковый номер.

 select p.product_id, p.product_name
     , pg.group_name, p.price
     , dense_rank() over(partition by p.group_id order by p.price asc)
     , rank() over(partition by p.group_id order by p.price asc)
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;
 

--5. Вывести для каждого товара разность его цены с предыдущим в одной товарной категории.

select p.product_id, p.product_name
     , pg.group_name, p.price
     , p.price - lag(p.price, 1) over(partition by p.group_id order by p.price) as price_diff
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;

--6. Для каждого товара вывести наименьшую стоимость в данной товарной категории.

select p.product_id, p.product_name
     , pg.group_name, p.price
     , max(p.price) over(partition by p.group_id) as max_group_price
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id; 


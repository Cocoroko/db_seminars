-- Оконные функции.

-- 1. Создать таблицу и заполнить ее данными согласно скрипту.

-- 2. Подсчитайте количество продуктов в каждой группе и вывести это в отдельном столбце для каждого продукта

SELECT 
    p.product_id,
    p.product_name,
    g.group_name,
    COUNT(p.product_id) OVER (PARTITION BY p.group_id) as total_products_in_group
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;

-- 3. Выведите все товары и среднюю цену товара в каждой из групп в отдельном столбце. Ответ округлите до целого

select p.product_id, p.product_name
     , pg.group_name
     , round(avg(p.price) over(partition by p.group_id), 0) as avg_price
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;

-- 4. Найдите цену следующего продукта (в порядке сортировки по цене) в группе, чтобы оценить изменения цен в рамках каждой группы продуктов.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    g.group_name,
    LEAD(p.price) OVER (PARTITION BY p.group_id ORDER BY p.price) AS next_price_in_group
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;


-- 5. Выведите для каждого товара разность его цены с предыдущим в одной товарной категории.

select p.product_id, p.product_name
     , pg.group_name, p.price
     , p.price - lag(p.price, 1) over(partition by p.group_id order by p.price) as price_diff
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;

-- 6. Найдите самый дешевый продукт в каждой группе и сопоставьте его цену с ценами других продуктов.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    g.group_name,
    FIRST_VALUE(p.price) OVER (PARTITION BY p.group_id ORDER BY p.price) AS min_price_in_group
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;

-- 7. Определите процент отклонения цены каждого продукта от максимальной цены в своей группе.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    g.group_name,
    MAX(p.price) OVER (PARTITION BY p.group_id) AS max_price_in_group,
    100.0 * (p.price / MAX(p.price) OVER (PARTITION BY p.group_id)) AS percent_of_max_price
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;

-- 8. Выведите номер товара в порядке возрастания цены в каждой группе. (т.е. нумерация отдельная для каждой группы)

 select p.product_id, p.product_name
     , pg.group_name, p.price
     , row_number() over(partition by p.group_id order by p.price asc)
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;

-- 9. Повторите предыдущий шаг, но товары с одинаковой ценой должны иметь одинаковый порядковый номер.

 select p.product_id, p.product_name
     , pg.group_name, p.price
     , dense_rank() over(partition by p.group_id order by p.price asc)
     , rank() over(partition by p.group_id order by p.price asc)
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;

-- 10. Для каждого продукта укажите, есть ли в группе продукт с более высокой ценой.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    g.group_name,
    CASE 
        WHEN LEAD(p.price) OVER (PARTITION BY p.group_id ORDER BY p.price) IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS has_next_product
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;

-- 11. Вычислите накопительную сумму цен продуктов в каждой группе.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    g.group_name,
    SUM(p.price) OVER (PARTITION BY p.group_id ORDER BY p.price) as cumulative_sum
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id
ORDER BY 
    g.group_name, p.price;

-- 12. Рассчитайте долю каждого продукта от суммарной цены группы и сравните с долей предыдущего продукта в группе.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    g.group_name,
    p.price / SUM(p.price) OVER (PARTITION BY p.group_id) AS market_share,
    LAG(p.price / SUM(p.price) OVER (PARTITION BY p.group_id)) OVER (PARTITION BY p.group_id ORDER BY p.product_id) AS previous_market_share,
    (p.price / SUM(p.price) OVER (PARTITION BY p.group_id)) - LAG(p.price / SUM(p.price) OVER (PARTITION BY p.group_id)) 
    OVER (PARTITION BY p.group_id ORDER BY p.product_id) AS change_in_share
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;

-- 13. Рассчитайте скользящее среднее цен для каждого продукта с учетом трех предыдущих и текущей строки в рамках своей группы.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    g.group_name,
    AVG(p.price) OVER (
        PARTITION BY p.group_id 
        ORDER BY p.price 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_price
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;

-- 14. Выведите информацию о том, как цена каждого продукта соотносится со средней ценой в своей группе, и посчитайте общее количество таких продуктов выше средней цены.

SELECT 
    g.group_name,
    p.product_id,
    p.product_name,
    p.price,
    AVG(p.price) OVER (PARTITION BY p.group_id) AS avg_price_in_group,
    CASE 
        WHEN p.price > AVG(p.price) OVER (PARTITION BY p.group_id) THEN 1 
        ELSE 0 
    END AS above_avg_flag,
    SUM(CASE 
            WHEN p.price > AVG(p.price) OVER (PARTITION BY p.group_id) THEN 1 
            ELSE 0 
        END) 
    OVER (PARTITION BY g.group_name) AS count_above_avg
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id
GROUP BY 
    g.group_name, p.product_id, p.product_name, p.price;




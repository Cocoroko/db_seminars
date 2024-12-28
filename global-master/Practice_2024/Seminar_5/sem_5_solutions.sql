-- Оконные функции.

-- 1. Создать таблицу и заполнить ее данными согласно скрипту.

-- 2. Подсчитать количество продуктов в каждой группе и вывести это в отдельном столбце для каждого продукта

SELECT 
    p.product_id,
    p.product_name,
    g.group_name,
    COUNT(p.product_id) OVER (PARTITION BY p.group_id) as total_products_in_group
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;

-- 3. Найдите цену следующего продукта в группе, чтобы оценить изменения цен в рамках каждой группы продуктов.

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

-- 4. Определите процент отклонения цены каждого продукта от максимальной цены в своей группе.

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

-- 5. Выведите все товары и среднюю цену товара в каждой из групп в отдельном столбце. Ответ округлите до целого

select p.product_id, p.product_name
     , pg.group_name
     , round(avg(p.price) over(partition by p.group_id), 0) as avg_price
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

-- 7. Вывести номер товара в порядке возрастания цены в каждой группе. (т.е. нумерация отдельная для каждой группы)

 select p.product_id, p.product_name
     , pg.group_name, p.price
     , row_number() over(partition by p.group_id order by p.price asc)
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;

-- 8. Повторить предыдущий шаг, но товары с одинаковой ценой должны иметь одинаковый порядковый номер.

 select p.product_id, p.product_name
     , pg.group_name, p.price
     , dense_rank() over(partition by p.group_id order by p.price asc)
     , rank() over(partition by p.group_id order by p.price asc)
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;
 

-- 9. Вывести для каждого товара разность его цены с предыдущим в одной товарной категории.

select p.product_id, p.product_name
     , pg.group_name, p.price
     , p.price - lag(p.price, 1) over(partition by p.group_id order by p.price) as price_diff
  from sem_5.products p
  join sem_5.product_groups pg
    on p.group_id = pg.group_id;


-- 10. Создайте запрос, который анализирует тренд изменения цен для каждого продукта в группе и определяет, увеличивается ли цена, уменьшается, или остается неизменной, сравнивая с предыдущей ценой.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    g.group_name,
    CASE 
        WHEN LAG(p.price) OVER (PARTITION BY p.group_id ORDER BY p.price) IS NULL THEN 'N/A'
        WHEN p.price > LAG(p.price) OVER (PARTITION BY p.group_id ORDER BY p.price) THEN 'Increasing'
        WHEN p.price < LAG(p.price) OVER (PARTITION BY p.group_id ORDER BY p.price) THEN 'Decreasing'
        ELSE 'Constant'
    END AS price_trend
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;

-- 11. Для каждого продукта укажите, есть ли в группе продукт с более высокой ценой.

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

-- 12. Вычислить накопительную сумму цен продуктов в каждой группе на основе цены.

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

-- 13. Для оценки изменения цен продуктов используем LAG и LEAD функции, анализируя, как изменяется цена по сравнению с предыдущей и следующей ценой того же продукта.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    LAG(p.price) OVER (PARTITION BY p.product_id ORDER BY p.product_id) AS previous_price,
    LEAD(p.price) OVER (PARTITION BY p.product_id ORDER BY p.product_id) AS next_price
FROM 
    sem_5.products p;

-- 14. Для каждого продукта в группе вычислите отклонение от средней цены продуктов в этой группе при помощи оконных функций.

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    g.group_name,
    AVG(p.price) OVER (PARTITION BY p.group_id) AS avg_price_in_group,
    p.price - AVG(p.price) OVER (PARTITION BY p.group_id) AS deviation_from_avg
FROM 
    sem_5.products p
JOIN 
    sem_5.product_groups g ON p.group_id = g.group_id;

-- 15.  Оценка динамики изменения цен. Отслеживание тенденции изменения цен для оценки общего направления изменения цен в группе (например, тренд к увеличению или уменьшению).

SELECT 
    g.group_name,
    SUM(CASE WHEN price_change > 0 THEN 1 ELSE 0 END) AS increases,
    SUM(CASE WHEN price_change < 0 THEN 1 ELSE 0 END) AS decreases,
    CASE 
        WHEN SUM(price_change) > 0 THEN 'Overall Increase'
        WHEN SUM(price_change) < 0 THEN 'Overall Decrease'
        ELSE 'No Overall Change'
    END AS overall_trend
FROM (
    SELECT 
        p.group_id,
        p.price - LAG(p.price) OVER (PARTITION BY p.group_id ORDER BY p.product_id) AS price_change
    FROM 
        sem_5.products p
) AS changes
JOIN 
    sem_5.product_groups g ON changes.group_id = g.group_id
GROUP BY 
    g.group_id;

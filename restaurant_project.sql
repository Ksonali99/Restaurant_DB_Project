USE restaurant_db;

-------------- OBJECTIVE : Explore Item Table -----------

-- 1. View the menu_items table.
select * from menu_items;

-- 2. Find the number of items on the menu.
select count(*) from menu_items;

-- 3. What are the least and most expensive items on the menu.
SELECT item_name, price
FROM (
    SELECT item_name, price
    FROM menu_items
    WHERE price = (SELECT MIN(price) FROM menu_items)
) AS least_expensive
UNION 
SELECT item_name, price
FROM (
    SELECT item_name, price
    FROM menu_items
    WHERE price = (SELECT MAX(price) FROM menu_items)
) AS least_expensive;

-- 4. How many Italian dishes are on the menu.
select * from menu_items
Where category = "Italian";

-- 5. What are the least and most expensive italian dishes on the menu?
-- Least expensive Italian dishes
SELECT item_name, price, 'Least Expensive' AS type
FROM menu_items
WHERE category = 'Italian'
  AND price = (
      SELECT MIN(price)
      FROM menu_items
      WHERE category = 'Italian'
  )

UNION ALL

-- Most expensive Italian dishes
SELECT item_name, price, 'Most Expensive' AS type
FROM menu_items
WHERE category = 'Italian'
  AND price = (
      SELECT MAX(price)
      FROM menu_items
      WHERE category = 'Italian'
  );
  
  -- 6. How many dishes are in each category?
  
  select 
	category, 
    count(menu_item_id) as count_of_items 
  from menu_items
  group by category;
  
  -- 7. what is the average dish price within each category?
  
select 
	category, 
    avg(price) as avg_price 
from menu_items
group by category;

-------------- OBJECTIVE : Explore Order Table -----------
-- 1. View the order_details table

Select * from order_details;

-- 2. what is the date range of the table?

Select 
	min(order_date), 
    max(order_date)
 from order_details;
 
-- 3. how many orders were made within this date range?

Select count(distinct order_id) from order_details;

-- 4. how many items were made within this date range?

select count(*) from order_details;

-- 5. which order had the most number of items list the top 5 order?

select order_id, count(item_id) as no_of_items 
from order_details
group by order_id
order by no_of_items desc
limit 5;

-- 6. how many orders had more than 12 items?
select count(*) from
(
select order_id, count(item_id) as no_of_items 
from order_details
group by order_id
having count(item_id) > 12
order by no_of_items) as num_order;

-------------- OBJECTIVE : analyze "CUSTOMER" Behaviour -----------

-- 1. Combine the menu_items and order_details tables into a single table.
select * 
from order_details o
left join menu_items m
on m.menu_item_id = o.item_id;

-- 2.What were the least and most ordered items? What categories were they in?
-- Most ordered item:
-- Most and least ordered items in one result
SELECT * FROM (
    SELECT 
        m.item_name, 
        COUNT(o.order_details_id) AS num_purchase 
    FROM order_details o
    LEFT JOIN menu_items m ON m.menu_item_id = o.item_id
    GROUP BY m.item_name
    ORDER BY num_purchase DESC
    LIMIT 1
) AS most_ordered

UNION

SELECT * FROM (
    SELECT 
        m.item_name, 
        COUNT(o.order_details_id) AS num_purchase 
    FROM order_details o
    LEFT JOIN menu_items m ON m.menu_item_id = o.item_id
    GROUP BY m.item_name
    ORDER BY num_purchase ASC
    LIMIT 1
) AS least_ordered;


-- 3.What were the top 5 orders that spent the most money?
select * from menu_items;
select * from order_details;

SELECT 
    od.order_id,
    SUM(mi.price) AS total_spent
FROM order_details od
LEFT JOIN menu_items mi 
    ON mi.menu_item_id = od.item_id
GROUP BY od.order_id
ORDER BY total_spent DESC
LIMIT 5;

-- 4. View the details of the highest spend order. What insights We gather from the results?
SELECT 
category, count(item_id) Item
FROM order_details od
LEFT JOIN menu_items mi 
    ON mi.menu_item_id = od.item_id
WHERE order_id = 440
GROUP BY category;

-- 5.View the details of the top 5 highest spend orders. What insights can you gather from the results?

SELECT 
category, order_id, count(item_id) Item
FROM order_details od
LEFT JOIN menu_items mi 
    ON mi.menu_item_id = od.item_id
WHERE order_id in (440,2075, 1957, 330, 2675)
GROUP BY category, order_id;


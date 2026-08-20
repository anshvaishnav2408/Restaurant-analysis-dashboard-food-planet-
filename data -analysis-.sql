
# q1 what were the least and most ordered items?what categories where they in?
# count for orders

SELECT 
    m.item_name, m.category, COUNT(*) AS total_orders
FROM
    menu_items AS m
        INNER JOIN
    order_details_new AS o ON m.menu_item_id = o.item_id
GROUP BY m.item_name , m.category
ORDER BY total_orders DESC;


#most orders
 
SELECT 
    m.item_name, m.category, COUNT(*) AS total_orders
FROM
    menu_items AS m
        INNER JOIN
    order_details_new AS o ON m.menu_item_id = o.item_id
GROUP BY m.item_name , m.category
ORDER BY total_orders DESC
LIMIT 1;


#least orders

SELECT 
    m.item_name, m.category, COUNT(*) AS total_orders
FROM
    menu_items AS m
        INNER JOIN
    order_details_new AS o ON m.menu_item_id = o.item_id
GROUP BY m.item_name , m.category
ORDER BY total_orders
LIMIT 1

# key insights
 #Hamburger is the most ordered menu item with 622 orders, making it the restaurant's best-selling item.
# Chicken Tacos is the least ordered menu item with 123 orders, indicating lower customer demand.


# q2 What do the highest spend orders look like? Which items did they buy and how much did they spend?

# highest spent orders
SELECT 
    o.order_id, SUM(m.price) AS total_spend
FROM
    menu_items AS m
        INNER JOIN
    order_details_new AS o ON m.menu_item_id = o.item_id
GROUP BY o.order_id 
ORDER BY total_spend DESC
LIMIT 1

# which item did they buy and how much did they spend ?

WITH highest_order AS
(
    SELECT
        od.order_id,
        m.item_name,
        m.category,
        m.price,
        SUM(m.price) OVER(PARTITION BY od.order_id) AS total_spent
    FROM order_details_new od
    JOIN menu_items m
        ON od.item_id = m.menu_item_id
)

SELECT *
FROM highest_order
WHERE total_spent =
(
    SELECT MAX(total_spent)
    FROM highest_order
);

# key insights
#Order 440 was the highest spending order, generating $192.15 in revenue.
#Italian dishes contributed the most to the highest-value order.
#High-spending customers tend to order multiple items from different cuisines.

#q3 were there certain time  that had more or less hour?

select hour(order_time) as order_hour,
count(*) as total_orders
from order_details_new
group by order_hour
order by total_orders desc 

# insights
#orders peak during lunch hours (12-1pm) and gradualy declined throughout the evening
#with the lowest demand observe at 3 pm

#q4 which cuisine should we focus on developing more menu items for based on the data?

select m.category,
count(*) as total_orders


from menu_items as m inner join order_details_new as o
on m.menu_item_id  = o.item_id
group by m.category
order by total_orders desc

#key insights
#Asian cuisine received the highest number of orders (3,470), making it the most popular category and a strong candidate for menu expansion.





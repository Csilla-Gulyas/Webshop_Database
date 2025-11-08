USE webshop;

----------------------------------------------------
-- List all products along with their category names
----------------------------------------------------
SELECT 
    p.product_id,                 -- Product ID
    p.name AS product_name,       -- Product name
    c.category_id,                -- Category ID
    c.name AS category_name       -- Category name
FROM products p
INNER JOIN categories c 
    ON p.category_id = c.category_id; -- Join products with their categories

---------------------------------------------
-- Find products that have never been ordered
---------------------------------------------
SELECT 
    p.product_id, 
    p.name
FROM products p
LEFT JOIN order_items oi 
    ON p.product_id = oi.product_id -- Left join with order items to find missing orders
WHERE oi.product_id IS NULL;       -- Keep only products with no matching order items

---------------------------------------------------------
-- Find users who have placed at least 2 completed orders
---------------------------------------------------------
SELECT 
    u.user_id, 
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,  -- Combine first and last name
    COUNT(o.order_id) AS total_orders                     -- Count completed orders
FROM users u
INNER JOIN orders o 
    ON u.user_id = o.user_id
WHERE o.status = 'completed'                             -- Only completed orders
GROUP BY u.user_id, full_name                             -- Group by user
HAVING total_orders >= 2;                                 -- Keep only users with 2 or more orders

--------------------------------------------------------------------------------------------
-- Find users who ordered products from at least 2 different categories in the last 6 months
--------------------------------------------------------------------------------------------
SELECT 
    u.user_id, 
    CONCAT(u.first_name, ' ', u.last_name) AS full_name
FROM users u
INNER JOIN orders o 
    ON u.user_id = o.user_id
INNER JOIN order_items oi 
    ON o.order_id = oi.order_id
INNER JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) -- Last 6 months only
GROUP BY u.user_id
HAVING COUNT(DISTINCT p.category_id) >= 2;                  -- At least 2 distinct categories

--------------------------------------------------------------------------------------------
-- List most popular products from the last year by number of orders and total sold quantity
--------------------------------------------------------------------------------------------
SELECT 
    p.product_id, 
    p.name AS product_name,
    SUM(oi.quantity) AS total_sold,      -- Total quantity sold
    COUNT(oi.product_id) AS times_ordered -- Number of times the product was ordered
FROM products p
INNER JOIN order_items oi 
    ON p.product_id = oi.product_id
INNER JOIN orders o 
    ON oi.order_id = o.order_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) -- Only orders from last year
GROUP BY p.product_id, p.name
ORDER BY times_ordered DESC;                                -- Most ordered products first

-----------------------------------------
-- Calculate average order value per user
-----------------------------------------
SELECT 
    u.user_id, 
    CONCAT(u.first_name, ' ', u.last_name) AS full_name, 
    AVG(order_total) AS avg_order_value
FROM users u
INNER JOIN orders o 
    ON u.user_id = o.user_id
INNER JOIN (
    -- Calculate total value per order
    SELECT order_id, SUM(quantity * price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS oi_sum 
    ON o.order_id = oi_sum.order_id
GROUP BY u.user_id; -- Group results by user

--------------------------------------------------
-- Get daily number of orders for the last 30 days
--------------------------------------------------
SELECT 
    o.order_date, 
    COUNT(o.order_id) AS daily_sales  -- Count of orders per day
FROM orders o
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY -- Only last 30 days
GROUP BY o.order_date
ORDER BY o.order_date DESC;                       -- Show most recent dates first

---------------------------------------------------------
-- List each supplier's products and their stock quantity
---------------------------------------------------------
SELECT 
    s.name AS supplier_name, 
    p.name AS product_name, 
    p.quantity AS stock_quantity
FROM suppliers s
INNER JOIN product_supplier ps 
    ON s.supplier_id = ps.supplier_id  -- Join suppliers with product_supplier
INNER JOIN products p 
    ON ps.product_id = p.product_id;   -- Join products

-------------------------------------------
-- Calculate total cart value for each user
-------------------------------------------
SELECT 
    u.user_id, 
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    SUM(ci.quantity * p.price) AS cart_value -- Total value of all items in the cart
FROM cart_items ci
INNER JOIN products p 
    ON ci.product_id = p.product_id        -- Get product price
INNER JOIN users u 
    ON ci.user_id = u.user_id              -- Link to user
GROUP BY u.user_id;

------------------------------------
-- Count of payments by their status
------------------------------------
SELECT 
    p.status, 
    COUNT(*) AS count
FROM payments p
GROUP BY p.status;                          -- Group results by payment status

---------------------------
-- Update a user's password
---------------------------
UPDATE users
SET password = 'newPassword852'             -- Set new password
WHERE user_id = 5;                          -- Specify the user

-----------------------------------------
-- Increase the price of a product by 20%
-----------------------------------------
UPDATE products
SET price = price * 1.20                    -- Multiply current price by 1.20
WHERE product_id = 7;                        -- Specify the product

-----------------------------------------------------
-- Update the status of a specific order to 'shipped'
-----------------------------------------------------
UPDATE orders
SET status = 'shipped'                     -- Change order status
WHERE order_id = 10;                        -- Specify the order

------------------------------------------------------
-- Update quantity of a specific item in a user's cart
------------------------------------------------------
UPDATE cart_items
SET quantity = 3                             -- Set new quantity
WHERE cart_item_id = 8 AND product_id = 4;  -- Specify cart item and product

--------------------------------
-- Change the name of a supplier
--------------------------------
UPDATE suppliers
SET name = 'MindentVisz Kft.'               -- New supplier name
WHERE supplier_id = 2;                       -- Specify the supplier

-----------------------------------------------
-- Update payment method for a specific payment
-----------------------------------------------
UPDATE payments
SET method = 'Credit Card'                  -- Set new payment method
WHERE payment_id = 7;                        -- Specify the payment

-------------------------------------------
-- Insert a new order into the orders table
-------------------------------------------
INSERT INTO orders 
(order_id, status, order_date, shipping_time, user_id, payment_id, supplier_id)
VALUES
(101, 'new', '2025-05-11', 3, 1, 2, 1);    -- Provide all required fields

-------------------------------------------------------
-- Check if the user ID already exists before inserting
-------------------------------------------------------
SELECT COUNT(*) AS count
FROM users
WHERE user_id = 10;

--------------------
-- Insert a new user
--------------------
INSERT INTO users
(user_id, username, password, first_name, last_name, phone, email, postal_code, city, street_name, street_type, house_number, address_extra)
VALUES
(10, 'szandika92', 'password123ANAN', 'Alexandra', 'Nagy', '06301234567', 'szandi.nagy92@gmail.com', '1138', 'Budapest', 'Váci', 'út', '12', '2nd floor');

----------------------------------------------------------------
-- First, delete related order items due to foreign key restrict
----------------------------------------------------------------
DELETE FROM order_items
WHERE product_id = 7;                        -- Specify the product

-- Then, delete the product itself
DELETE FROM products
WHERE product_id = 7;                         -- Specify the product

-----------------------------------------------------------
-- Retrieve all products with their price and category name
-----------------------------------------------------------
SELECT products.name AS product_name,
       products.price,
       categories.name AS category_name
FROM products
INNER JOIN categories ON products.category_id = categories.category_id;   -- Join to get category

---------------------------------------------------
-- Retrieve users with at least one completed order
---------------------------------------------------
SELECT DISTINCT users.first_name,
                users.last_name,
                users.email,
                users.city
FROM users
INNER JOIN orders ON users.user_id = orders.user_id
WHERE orders.status = 'completed';           -- Only completed orders

--------------------------------------------------------------------
-- Get the most recent 10 orders with order ID, date, and user email
--------------------------------------------------------------------
SELECT orders.order_id,
       orders.order_date,
       users.email
FROM orders
INNER JOIN users ON orders.user_id = users.user_id
ORDER BY orders.order_date DESC               -- Sort by newest first
LIMIT 10;                                     -- Only 10 latest orders

--------------------------------------------------
-- Retrieve products within a specific price range
--------------------------------------------------
SELECT name, price, quantity
FROM products
WHERE price BETWEEN 2000 AND 8000;            -- Filter by price range

---------------------------------------------------------------------------------------
-- Retrieve all orders currently shipped, including order ID, date, and shipping method
---------------------------------------------------------------------------------------
SELECT orders.order_id,
       orders.order_date,
       suppliers.method AS shipping_method
FROM orders
INNER JOIN suppliers ON orders.supplier_id = suppliers.supplier_id
WHERE orders.status = 'shipped';             -- Only orders in shipped status

--------------------------------------------------------------
-- Retrieve suppliers who supply at least 5 different products
--------------------------------------------------------------
SELECT suppliers.name AS supplier_name,
       suppliers_contacts.phone,
       suppliers_contacts.email
FROM suppliers
INNER JOIN product_supplier ON suppliers.supplier_id = product_supplier.supplier_id
INNER JOIN suppliers_contacts ON suppliers.supplier_id = suppliers_contacts.supplier_contact_id
GROUP BY suppliers.supplier_id, suppliers.name, suppliers_contacts.phone, suppliers_contacts.email
HAVING COUNT(DISTINCT product_supplier.product_id) >= 5;  -- Minimum 5 distinct products

-----------------------------------------------------------
-- Retrieve all products with their price and supplier name
-----------------------------------------------------------
SELECT products.name AS product_name,
       products.price,
       suppliers.name AS supplier_name
FROM products
INNER JOIN product_supplier ON products.product_id = product_supplier.product_id
INNER JOIN suppliers ON product_supplier.supplier_id = suppliers.supplier_id;

-------------------------------------------------------------------------------------
-- Retrieve products that are more expensive than the average price of their category
-------------------------------------------------------------------------------------
SELECT products.name,
       products.price,
       categories.name AS category_name
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
WHERE products.price > (
    SELECT AVG(price)
    FROM products AS p2
    WHERE p2.category_id = products.category_id
);

-------------------------------------------------------------------------------------------
-- Retrieve users who have at least one cancelled order, with the count of cancelled orders
-------------------------------------------------------------------------------------------
SELECT users.first_name,
       users.last_name,
       COUNT(orders.order_id) AS cancelled_orders_count
FROM users
INNER JOIN orders ON users.user_id = orders.user_id
WHERE orders.status = 'cancelled'           -- Only cancelled orders
GROUP BY users.user_id, users.first_name, users.last_name
HAVING COUNT(orders.order_id) >= 1
ORDER BY cancelled_orders_count DESC;        -- Most cancelled orders first

------------------------------------------------------
-- Retrieve number of registered users grouped by city
------------------------------------------------------
SELECT city,
       COUNT(user_id) AS user_count
FROM users
GROUP BY city
ORDER BY city;                               -- Sorted alphabetically by city





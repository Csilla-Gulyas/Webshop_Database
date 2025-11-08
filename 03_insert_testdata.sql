USE webshop;

-- =========================================
-- 1. Categories
-- =========================================
INSERT INTO categories (category_id, name) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Clothing');

-- =========================================
-- 2. Users
-- =========================================
INSERT INTO users (user_id, username, password, first_name, last_name, phone, email, postal_code, city, street_name, street_type, house_number, address_extra) VALUES
(1, 'john_doe', 'pass123', 'John', 'Doe', '1234567890', 'john@example.com', '1010', 'Budapest', 'Main', 'Street', '12A', NULL),
(2, 'jane_smith', 'pass456', 'Jane', 'Smith', '0987654321', 'jane@example.com', '1020', 'Budapest', 'Second', 'Avenue', '5', 'Floor 2');

-- =========================================
-- 3. Suppliers
-- =========================================
INSERT INTO suppliers (supplier_id, name, method) VALUES
(1, 'Tech Supplies Ltd', 'Courier'),
(2, 'BookWorld Kft', 'Postal');

-- =========================================
-- 4. Supplier Contacts
-- =========================================
INSERT INTO suppliers_contacts (supplier_contact_id, name, phone, email) VALUES
(1, 'Peter Johnson', '111222333', 'peter@techsupplies.com'),
(2, 'Anna Kovacs', '444555666', 'anna@bookworld.com');

-- =========================================
-- 5. Payments
-- =========================================
INSERT INTO payments (payment_id, status, transaction_fee, method) VALUES
(1, 'paid', 1.50, 'Credit Card'),
(2, 'pending', 0.00, 'Cash');

-- =========================================
-- 6. Products
-- =========================================
INSERT INTO products (product_id, name, price, quantity, description, category_id) VALUES
(1, 'Smartphone', 350.00, 10, 'Latest model smartphone', 1),
(2, 'Laptop', 1200.00, 5, 'Gaming laptop', 1),
(3, 'Novel Book', 25.50, 100, 'Bestselling novel', 2),
(4, 'T-Shirt', 15.00, 50, 'Cotton T-Shirt', 3);

-- =========================================
-- 7. Cart Items
-- =========================================
INSERT INTO cart_items (cart_item_id, quantity, product_id, user_id) VALUES
(1, 2, 1, 1),
(2, 1, 3, 2);

-- =========================================
-- 8. Product-Supplier Relationships
-- =========================================
INSERT INTO product_supplier (product_id, supplier_id) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 1);

-- =========================================
-- 9. Orders
-- =========================================
INSERT INTO orders (order_id, status, order_date, shipping_time, user_id, payment_id, supplier_id) VALUES
(1, 'completed', '2025-05-01', 3, 1, 1, 1),
(2, 'new', '2025-05-05', 5, 2, 2, 2);

-- =========================================
-- 10. Order Items
-- =========================================
INSERT INTO order_items (order_item_id, quantity, price, order_id, product_id) VALUES
(1, 1, 350.00, 1, 1),
(2, 1, 25.50, 1, 3),
(3, 2, 15.00, 2, 4);
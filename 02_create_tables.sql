USE webshop;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product_supplier;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS suppliers_contacts;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS categories;

-- =========================================
-- TABLE: categories
-- =========================================
CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY key,
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- =========================================
-- TABLE: users
-- =========================================
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    username VARCHAR(20) NOT NULL,
    password VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    postal_code VARCHAR(5) NOT NULL,
    city VARCHAR(50) NOT NULL,
    street_name VARCHAR(50) NOT NULL,
    street_type VARCHAR(20) NOT NULL,
    house_number VARCHAR(10) NOT NULL,
    address_extra VARCHAR(100)
) ENGINE=InnoDB;

-- =========================================
-- TABLE: suppliers
-- =========================================
CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    method VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- =========================================
-- TABLE: suppliers_contacts
-- =========================================
CREATE TABLE IF NOT EXISTS suppliers_contacts (
    supplier_contact_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    FOREIGN KEY (supplier_contact_id) REFERENCES suppliers(supplier_id)
    	ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- TABLE: payments
-- =========================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY,
    status ENUM('pending', 'paid', 'rejected', 'refunded', 'confirmed') DEFAULT 'pending',
    transaction_fee DECIMAL(10,3) NOT NULL,
    method VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- =========================================
-- TABLE: products
-- =========================================
CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,3) NOT NULL,
    quantity INT NOT NULL,
    description VARCHAR(500) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================
-- TABLE: cart_items
-- =========================================
CREATE TABLE IF NOT EXISTS cart_items (
    cart_item_id INT PRIMARY KEY,
    quantity INT NOT NULL,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================
-- TABLE: product_supplier
-- =========================================
CREATE TABLE IF NOT EXISTS product_supplier (
    product_id INT NOT NULL,
    supplier_id INT NOT NULL,
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================
-- TABLE: orders
-- =========================================
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    status ENUM('new','processing','shipped','completed','cancelled','faulty','returned','confirmed') DEFAULT 'new',
    order_date DATE NOT NULL,
    shipping_time INT NOT NULL,
    user_id INT NOT NULL,
    payment_id INT DEFAULT NULL,
    supplier_id INT DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================
-- TABLE: order_items
-- =========================================
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT PRIMARY KEY,
    quantity INT NOT NULL,
    price DECIMAL(10,3) NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;
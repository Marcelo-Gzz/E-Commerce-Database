

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- 1. USERS
CREATE TABLE users (
    user_id       SERIAL PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    full_name     VARCHAR(255) NOT NULL,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active     BOOLEAN NOT NULL DEFAULT TRUE
);

-- 2. PRODUCTS
CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    description   TEXT,
    price         NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    sku           VARCHAR(100) NOT NULL UNIQUE,
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. ORDERS
CREATE TABLE orders (
    order_id          SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    status            VARCHAR(20) NOT NULL,
    order_date        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount      NUMERIC(10, 2) NOT NULL CHECK (total_amount >= 0),
    shipping_address  TEXT NOT NULL,
    billing_address   TEXT NOT NULL,
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

ALTER TABLE orders
ADD CONSTRAINT chk_orders_status
CHECK (status IN ('PENDING', 'PAID', 'SHIPPED', 'CANCELLED'));

-- 4. ORDER_ITEMS
CREATE TABLE order_items (
    order_item_id  SERIAL PRIMARY KEY,
    order_id       INT NOT NULL,
    product_id     INT NOT NULL,
    quantity       INT NOT NULL CHECK (quantity > 0),
    unit_price     NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    line_total     NUMERIC(10, 2) NOT NULL CHECK (line_total >= 0),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 5. INVENTORY
CREATE TABLE inventory (
    product_id        INT PRIMARY KEY,
    quantity_in_stock INT NOT NULL CHECK (quantity_in_stock >= 0),
    last_updated      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

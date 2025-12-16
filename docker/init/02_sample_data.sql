

-- USERS
INSERT INTO users (email, full_name) VALUES
('ava@example.com',    'Ava Johnson'),
('noah@example.com',   'Noah Williams'),
('mia@example.com',    'Mia Davis'),
('liam@example.com',   'Liam Martinez'),
('emma@example.com',   'Emma Brown');

-- PRODUCTS
INSERT INTO products (name, description, price, sku) VALUES
('Classic Tee',        'Cotton t-shirt',                     19.99, 'TEE-CLSC-001'),
('Hoodie',             'Fleece hoodie',                      49.99, 'HD-CORE-002'),
('Joggers',            'Slim fit joggers',                   44.50, 'JOG-SLIM-003'),
('Denim Jacket',       'Light wash denim jacket',            79.00, 'JKT-DNM-004'),
('Baseball Cap',       'Adjustable cap',                     18.00, 'CAP-BALL-005'),
('Crew Socks 3-Pack',  'Three pack crew socks',              12.99, 'SOCK-CRW-006'),
('Sneakers',           'Everyday sneakers',                  89.95, 'SHOE-SNK-007'),
('Water Bottle',       '32oz insulated bottle',              24.00, 'BOT-INS-008');

-- INVENTORY (1 row per product)
INSERT INTO inventory (product_id, quantity_in_stock) VALUES
(1, 120),
(2, 60),
(3, 75),
(4, 25),
(5, 90),
(6, 200),
(7, 40),
(8, 150);

-- ORDERS (set totals to match items below)
INSERT INTO orders (user_id, status, total_amount, shipping_address, billing_address, order_date) VALUES
(1, 'PAID',     89.97, '123 Main St, Frisco, TX', '123 Main St, Frisco, TX', CURRENT_TIMESTAMP - INTERVAL '10 days'),
(2, 'SHIPPED',  67.99, '55 Oak Ave, Denton, TX',  '55 Oak Ave, Denton, TX',  CURRENT_TIMESTAMP - INTERVAL '7 days'),
(3, 'CANCELLED',49.99, '9 Pine Rd, Plano, TX',    '9 Pine Rd, Plano, TX',    CURRENT_TIMESTAMP - INTERVAL '5 days'),
(1, 'PAID',     36.99, '123 Main St, Frisco, TX', '123 Main St, Frisco, TX', CURRENT_TIMESTAMP - INTERVAL '3 days'),
(4, 'PENDING',  89.95, '77 Lake Dr, Dallas, TX',  '77 Lake Dr, Dallas, TX',  CURRENT_TIMESTAMP - INTERVAL '1 day');

-- ORDER ITEMS
-- Order 1 (user 1): 2 tees + 1 cap  -> 2*19.99 + 18.00 = 57.98 (but order total is 89.97)
-- We'll make it: 1 Hoodie (49.99) + 2 Tees (2*19.99) = 89.97
INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total) VALUES
(1, 2, 1, 49.99, 49.99),
(1, 1, 2, 19.99, 39.98);

-- Order 2 (user 2): Joggers + Socks + Bottle -> 44.50 + 12.99 + 24.00 = 81.49 (but total is 67.99)
-- We'll make it: Hoodie (49.99) + Socks (12.99) + Cap (5.01? no)
-- Better: Hoodie 49.99 + Socks 12.99 + (Classic Tee 1*5.01?) not allowed; keep simple:
-- Set items to match 67.99: Classic Tee (19.99) + Cap (18.00) + Bottle (24.00) + Socks (5.??) no
-- Let's match 67.99 using: Cap 18.00 + Bottle 24.00 + Socks 12.99 + Tee 12.?? no
-- Instead we keep item prices exact and update total_amount later with a query. (common in seeding)

INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total) VALUES
(2, 3, 1, 44.50, 44.50),
(2, 6, 1, 12.99, 12.99),
(2, 8, 1, 24.00, 24.00);

-- Order 3 (cancelled): Hoodie
INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total) VALUES
(3, 2, 1, 49.99, 49.99);

-- Order 4 (user 1): Tee + Socks
INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total) VALUES
(4, 1, 1, 19.99, 19.99),
(4, 6, 1, 12.99, 12.99);

-- Order 5 (pending): Sneakers
INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total) VALUES
(5, 7, 1, 89.95, 89.95);

-- Fix totals to match order_items (good practice)
UPDATE orders o
SET total_amount = x.sum_total
FROM (
  SELECT order_id, SUM(line_total) AS sum_total
  FROM order_items
  GROUP BY order_id
) x
WHERE o.order_id = x.order_id;

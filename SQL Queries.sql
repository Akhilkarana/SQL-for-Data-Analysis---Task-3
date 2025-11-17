CREATE DATABASE ecommerce_task3;
USE ecommerce_task3;


CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name VARCHAR(200),
  email VARCHAR(200),
  country VARCHAR(100),
  signup_date DATE
) ENGINE=InnoDB;

CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(255),
  category VARCHAR(100),
  price DECIMAL(10,2)
) ENGINE=InnoDB;

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  user_id INT,
  order_date DATE,
  status VARCHAR(50),
  payment_method VARCHAR(50),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  total_price DECIMAL(12,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB;


CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);


CREATE VIEW order_totals_view AS
SELECT o.order_id, o.user_id, o.order_date, o.status, SUM(oi.total_price) AS order_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.user_id, o.order_date, o.status;

DROP VIEW IF EXISTS customer_ltv_view;
CREATE VIEW customer_ltv_view AS
SELECT u.user_id, u.name, u.email, u.country,
       COALESCE(SUM(oi.total_price),0) AS lifetime_spend,
       COUNT(DISTINCT o.order_id) AS orders_count
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.name, u.email, u.country;


-- A. WHERE vs HAVING
-- WHERE filters rows before aggregation (orders in 2025)
SELECT * FROM orders
WHERE order_date BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY order_date DESC LIMIT 20;
-- HAVING filters groups after aggregation (products with revenue > 2000)
SELECT p.product_id, p.product_name, p.category, SUM(oi.total_price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category
HAVING SUM(oi.total_price) > 2000
ORDER BY revenue DESC;

-- B. JOINS examples
-- INNER JOIN: users who placed orders and their order totals
SELECT u.user_id, u.name, o.order_id, ot.order_total
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_totals_view ot ON o.order_id = ot.order_id
ORDER BY ot.order_total DESC LIMIT 20;
-- LEFT JOIN: all users and their latest order total (if any)
SELECT u.user_id, u.name, ot.order_total, ot.order_date
FROM users u
LEFT JOIN (
    SELECT o.user_id, o.order_id, o.order_date, SUM(oi.total_price) AS order_total
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.user_id, o.order_date
) ot ON u.user_id = ot.user_id
GROUP BY u.user_id, ot.order_date, ot.order_total
ORDER BY u.user_id LIMIT 50;

-- C. Average revenue per user (ARPU)
-- total revenue / count(distinct active users)
SELECT ROUND(SUM(oi.total_price) / NULLIF(COUNT(DISTINCT o.user_id),0),2) AS arpu_estimate
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id;

-- D. Subqueries examples
-- Users who spent more than average user
SELECT user_id, name, user_total FROM (
  SELECT u.user_id, u.name, COALESCE(SUM(oi.total_price),0) AS user_total
  FROM users u
  LEFT JOIN orders o ON u.user_id = o.user_id
  LEFT JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY u.user_id, u.name
) t
WHERE user_total > (
  SELECT AVG(user_total) FROM (
    SELECT COALESCE(SUM(oi.total_price),0) AS user_total
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY u.user_id
  ) x
);

-- E. Aggregations & business queries
-- Top 10 products by revenue
SELECT p.product_id, p.product_name, p.category, SUM(oi.total_price) AS revenue, SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC LIMIT 10;
-- Top 10 users by lifetime spend (from view)
SELECT user_id, name, lifetime_spend, orders_count
FROM customer_ltv_view
ORDER BY lifetime_spend DESC LIMIT 10;

-- F. Data quality checks
-- Products never sold
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.item_id IS NULL;
-- Orders without items
SELECT o.order_id, o.user_id
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.item_id IS NULL;

-- G. Segmentation using CASE
SELECT user_id, name, lifetime_spend,
  CASE
    WHEN lifetime_spend >= 2000 THEN 'Platinum'
    WHEN lifetime_spend >= 1000 THEN 'Gold'
    WHEN lifetime_spend >= 500 THEN 'Silver'
    ELSE 'Bronze'
  END AS tier
FROM customer_ltv_view
ORDER BY lifetime_spend DESC LIMIT 50;




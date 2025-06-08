-- Create Database
CREATE DATABASE FASOS;
USE FASOS;

-- 1. Driver Table
DROP TABLE IF EXISTS driver;
CREATE TABLE driver (
    driver_id INTEGER PRIMARY KEY,
    reg_date DATE
);

INSERT INTO driver(driver_id, reg_date) 
VALUES 
    (1, '2021-01-01'),
    (2, '2021-03-01'),
    (3, '2021-08-01'),
    (4, '2021-01-15');

-- 2. Ingredients Table
DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients (
    ingredients_id INTEGER PRIMARY KEY,
    ingredients_name VARCHAR(60)
);

INSERT INTO ingredients(ingredients_id, ingredients_name) 
VALUES 
    (1, 'BBQ Chicken'),
    (2, 'Chilli Sauce'),
    (3, 'Chicken'),
    (4, 'Cheese'),
    (5, 'Kebab'),
    (6, 'Mushrooms'),
    (7, 'Onions'),
    (8, 'Egg'),
    (9, 'Peppers'),
    (10, 'Schezwan Sauce'),
    (11, 'Tomatoes'),
    (12, 'Tomato Sauce');

-- 3. Rolls Table
DROP TABLE IF EXISTS rolls;
CREATE TABLE rolls (
    roll_id INTEGER PRIMARY KEY,
    roll_name VARCHAR(30)
);

INSERT INTO rolls(roll_id, roll_name) 
VALUES 
    (1, 'Non Veg Roll'),
    (2, 'Veg Roll');

-- 4. Rolls Recipes Table
DROP TABLE IF EXISTS rolls_recipes;
CREATE TABLE rolls_recipes (
    roll_id INTEGER,
    ingredients VARCHAR(24),
    FOREIGN KEY (roll_id) REFERENCES rolls(roll_id)
);

INSERT INTO rolls_recipes(roll_id, ingredients) 
VALUES 
    (1, '1,2,3,4,5,6,8,10'),
    (2, '4,6,7,9,11,12');

-- 5. Driver Order Table
DROP TABLE IF EXISTS driver_order;
CREATE TABLE driver_order (
    order_id INTEGER PRIMARY KEY,
    driver_id INTEGER,
    pickup_time DATETIME,
    distance VARCHAR(10),
    duration VARCHAR(20),
    cancellation VARCHAR(30),
    FOREIGN KEY (driver_id) REFERENCES driver(driver_id)
);

INSERT INTO driver_order(order_id, driver_id, pickup_time, distance, duration, cancellation) 
VALUES
    (1, 1, '2021-01-01 18:15:34', '20km', '32 minutes', NULL),
    (2, 1, '2021-01-01 19:10:54', '20km', '27 minutes', NULL),
    (3, 1, '2021-03-01 00:12:37', '13.4km', '20 mins', NULL),
    (4, 2, '2021-04-01 13:53:03', '23.4', '40', NULL),
    (5, 3, '2021-08-01 21:10:57', '10', '15', NULL),
    (6, 3, NULL, NULL, NULL, 'Cancellation'),
    (7, 2, '2020-08-01 21:30:45', '25km', '25mins', NULL),
    (8, 2, '2020-10-01 00:15:02', '23.4 km', '15 minute', NULL),
    (9, 2, NULL, NULL, NULL, 'Customer Cancellation'),
    (10, 1, '2020-11-01 18:50:20', '10km', '10minutes', NULL);

-- 6. Customer Orders Table
DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
    order_line_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    order_id INTEGER,
    customer_id INTEGER,
    roll_id INTEGER,
    not_include_items VARCHAR(10),
    extra_items_included VARCHAR(10),
    order_date DATETIME,
    FOREIGN KEY (roll_id) REFERENCES rolls(roll_id)
);

INSERT INTO customer_orders(order_id, customer_id, roll_id, not_include_items, extra_items_included, order_date)
VALUES 
    (1, 101, 1, '', '', '2021-01-01 18:05:02'),
    (2, 101, 1, '', '', '2021-01-01 19:00:52'),
    (3, 102, 1, '', '', '2021-02-01 23:51:23'),
    (3, 102, 2, '', NULL, '2021-02-01 23:51:23'),
    (4, 103, 1, '4', '', '2021-04-01 13:23:46'),
    (4, 103, 1, '4', '', '2021-04-01 13:23:46'),
    (4, 103, 2, '4', '', '2021-04-01 13:23:46'),
    (5, 104, 1, NULL, '1', '2021-08-01 21:00:29'),
    (6, 101, 2, NULL, NULL, '2021-08-01 21:03:13'),
    (7, 105, 2, NULL, '1', '2021-08-01 21:20:29'),
    (8, 102, 1, NULL, NULL, '2021-09-01 23:54:33'),
    (9, 103, 1, '4', '1,5', '2021-10-01 11:22:59'),
    (10, 104, 1, NULL, NULL, '2021-11-01 18:34:49'),
    (10, 104, 1, '2,6', '1,4', '2021-11-01 18:34:49');



SELECT * FROM driver;
SELECT * FROM ingredients;
SELECT * FROM rolls;
SELECT * FROM rolls_recipes;
SELECT * FROM driver_order;
SELECT * FROM customer_orders;

-- 1. Most Ordered Rolls
SELECT r.roll_name, COUNT(*) AS order_count
FROM customer_orders c
JOIN rolls r ON c.roll_id = r.roll_id
GROUP BY r.roll_name
ORDER BY order_count DESC;



-- 2. Peak Order Hours
SELECT HOUR(order_date) AS order_hour, COUNT(*) AS total_orders
FROM customer_orders
GROUP BY order_hour
ORDER BY total_orders DESC;

-- 3. Driver with Most Cancellations
SELECT driver_id, COUNT(*) AS cancellation_count
FROM driver_order
WHERE cancellation IS NOT NULL AND cancellation != ''
GROUP BY driver_id
ORDER BY cancellation_count DESC;

-- 4. Driver Performance: Total Orders Delivered
SELECT driver_id, COUNT(*) AS total_deliveries
FROM driver_order
WHERE cancellation IS NULL OR cancellation = ''
GROUP BY driver_id
ORDER BY total_deliveries DESC;

-- 5. Average Delivery Time per Driver (where time is valid)
SELECT driver_id,
  AVG(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) AS avg_minutes
FROM driver_order
WHERE duration IS NOT NULL AND duration != '' AND cancellation IS NULL
GROUP BY driver_id;

-- 6. Ingredient Usage Frequency in Rolls
SELECT i.ingredients_name, COUNT(*) AS times_used
FROM rolls_recipes rr
JOIN ingredients i ON FIND_IN_SET(i.ingredients_id, rr.ingredients)
GROUP BY i.ingredients_name
ORDER BY times_used DESC;

-- 7. Most Frequently Excluded Ingredients
SELECT i.ingredients_name, COUNT(*) AS exclusion_count
FROM customer_orders co
JOIN ingredients i ON FIND_IN_SET(i.ingredients_id, co.not_include_items)
WHERE co.not_include_items IS NOT NULL AND co.not_include_items != ''
GROUP BY i.ingredients_name
ORDER BY exclusion_count DESC;

-- 8. Most Frequently Added Ingredients
SELECT i.ingredients_name, COUNT(*) AS inclusion_count
FROM customer_orders co
JOIN ingredients i ON FIND_IN_SET(i.ingredients_id, co.extra_items_included)
WHERE co.extra_items_included IS NOT NULL AND co.extra_items_included != ''
GROUP BY i.ingredients_name
ORDER BY inclusion_count DESC;

-- 9. Total Cancellations & Cancellation Rate
SELECT 
  COUNT(*) AS total_orders,
  SUM(CASE WHEN cancellation IS NOT NULL AND cancellation != '' THEN 1 ELSE 0 END) AS cancelled_orders,
  ROUND(SUM(CASE WHEN cancellation IS NOT NULL AND cancellation != '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM driver_order;

-- 10. Total Orders Per Day
SELECT DATE(order_date) AS order_day, COUNT(*) AS total_orders
FROM customer_orders
GROUP BY order_day
ORDER BY order_day;





-- 🧠 Key Business Questions You Will Answer
-- 📦 Customer Order Insights:
-- Top 3 most ordered rolls?
-- Peak order hours or days?

-- What customizations (not included / extra) are most common?

-- 🚚 Driver Performance:
-- Which driver completed the most deliveries?
-- Average delivery time per driver?
-- Which driver has the most cancellations?
-- 🥙 Ingredient Analysis:
-- Which ingredients are most commonly excluded or added?
-- How frequently each ingredient is used overall?

-- 📉 Cancellations & Failures:
-- What % of orders get canceled?
-- Are cancellations linked to specific drivers or time?
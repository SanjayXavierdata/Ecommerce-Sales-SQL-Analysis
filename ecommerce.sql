create database sql1;

use sql1;


CREATE TABLE ecommerce_sales (
    order_id        VARCHAR(36) PRIMARY KEY,
    product_name    VARCHAR(100),
    category        VARCHAR(50),
    price           DECIMAL(10,2),
    quantity        INT,
    total_sales     DECIMAL(10,2),
    customer_id     VARCHAR(36),
    customer_age    INT,
    customer_gender VARCHAR(10),
    purchase_date   DATE,
    purchase_time   TIME
);



SHOW VARIABLES LIKE 'secure_file_priv';


CREATE TABLE staging_sales (
    order_id        VARCHAR(36),
    product_name    VARCHAR(100),
    category        VARCHAR(50),
    price           DECIMAL(10,2),
    quantity        INT,
    total_sales     DECIMAL(10,2),
    customer_id     VARCHAR(36),
    customer_age    INT,
    customer_gender VARCHAR(10),
    purchase_date   VARCHAR(20),
    purchase_time   TIME
);


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\ecommerce_sales_data.csv'
INTO TABLE staging_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) FROM staging_sales;
SHOW WARNINGS;


INSERT INTO ecommerce_sales
SELECT
    order_id,
    product_name,
    category,
    price,
    quantity,
    total_sales,
    customer_id,
    customer_age,
    customer_gender,
    STR_TO_DATE(purchase_date, '%d/%m/%Y'),
    purchase_time
FROM staging_sales;



SELECT COUNT(*) FROM ecommerce_sales;
SELECT * FROM ecommerce_sales LIMIT 5;


SELECT * FROM ecommerce_sales;


-- EDA


SELECT order_id, COUNT(*) AS cnt
FROM ecommerce_sales
GROUP BY order_id
HAVING cnt > 1;


SELECT
    SUM(order_id IS NULL) AS null_order_id,
    SUM(product_name IS NULL) AS null_product_name,
    SUM(category IS NULL) AS null_category,
    SUM(price IS NULL) AS null_price,
    SUM(quantity IS NULL) AS null_quantity,
    SUM(total_sales IS NULL) AS null_total_sales,
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(customer_age IS NULL) AS null_customer_age,
    SUM(customer_gender IS NULL) AS null_customer_gender,
    SUM(purchase_date IS NULL) AS null_purchase_date,
    SUM(purchase_time IS NULL) AS null_purchase_time
FROM ecommerce_sales;




SELECT COUNT(*) AS bad_rows
FROM ecommerce_sales
WHERE price <= 0 OR quantity <= 0 OR total_sales <= 0;



SELECT DISTINCT category FROM ecommerce_sales;

SELECT DISTINCT customer_gender FROM ecommerce_sales;

-- Check age range
SELECT MIN(customer_age) AS min_age, MAX(customer_age) AS max_age
FROM ecommerce_sales;


-- What is the total revenue generated, and how many total orders were placed?



select count(*)  as total_order,sum(total_sales) as total_revenue
from ecommerce_sales;


-- Which product category generates the highest revenue, and what percentage of total revenue does it contribute?
SELECT 
    category,
    SUM(total_sales) AS category_revenue,
    ROUND(SUM(total_sales) * 100.0 / SUM(SUM(total_sales)) OVER (), 2) AS pct_of_total
FROM ecommerce_sales
GROUP BY category
ORDER BY category_revenue DESC
LIMIT 1;


-- Who are the top 10 customers by total spending?

select customer_id as top_10_customers,sum(total_sales) as total_sales
from ecommerce_sales
group by customer_id
order by total_sales DESC
limit 10;


-- What is the month-over-month revenue trend, and which month had the highest sales?


SELECT 
    DATE_FORMAT(purchase_date, '%Y-%m') AS month,
    SUM(total_sales) AS monthly_revenue
FROM ecommerce_sales
GROUP BY month
ORDER BY month;


-- What is the average order value (AOV) by customer gender?

select customer_gender,avg(total_sales) as avg_sales
from ecommerce_sales
group by customer_gender;


-- Which day of the week generates the most revenue on average?

SELECT DAYNAME(purchase_date) AS day_of_week, AVG(total_sales) AS avg_sales
FROM ecommerce_sales
GROUP BY day_of_week
ORDER BY avg_sales DESC;


-- What is the revenue contribution of each age group

SELECT 
    CASE
        WHEN customer_age < 20 THEN 'under_20'
        WHEN customer_age BETWEEN 20 AND 50 THEN 'adult'
        WHEN customer_age > 50 THEN 'old_aged'
    END AS age_range,
    round(SUM(total_sales),2) AS total_revenue
FROM ecommerce_sales
GROUP BY age_range
ORDER BY total_revenue DESC;



-- For each category, what is the best-selling product by total quantity sold?

SELECT category, product_name, total_quantity
FROM (
    SELECT 
        category,
        product_name,
        SUM(quantity) AS total_quantity,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(quantity) DESC) AS rn
    FROM ecommerce_sales
    GROUP BY category, product_name
) ranked
WHERE rn = 1;


-- What is the running (cumulative) total of revenue over time?


SELECT 
    purchase_date,
    SUM(total_sales) AS daily_revenue,
    SUM(SUM(total_sales)) OVER (ORDER BY purchase_date) AS running_total
FROM ecommerce_sales
GROUP BY purchase_date
ORDER BY purchase_date;



-- Which customers made repeat purchases (more than one order), and how much did they spend in total?


SELECT 
    customer_id,
    COUNT(*) AS order_count,
    SUM(total_sales) AS total_spent
FROM ecommerce_sales
GROUP BY customer_id
HAVING order_count > 1
ORDER BY total_spent DESC;

-- Peak purchasing hour

select hour(purchase_time) as peak_purchasing_time,sum(total_sales) as sales
from ecommerce_sales
group by peak_purchasing_time
order by sales desc
limit 1;


-- Top 3 products in each category

WITH product_sales AS (
    SELECT
        category,
        product_name,
        SUM(total_sales) AS revenue
    FROM ecommerce_sales
    GROUP BY category, product_name
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY category
               ORDER BY revenue DESC
           ) AS rnk
    FROM product_sales
)
SELECT *
FROM ranked
WHERE rnk <= 3;



-- end


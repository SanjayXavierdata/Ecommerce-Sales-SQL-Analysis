# 🛒 E-Commerce Sales Analysis Using MySQL

## 📊 Project Overview

This project focuses on analyzing e-commerce sales data using **MySQL** to understand revenue performance, customer behavior, product performance, and sales trends.

The project follows an end-to-end data analysis workflow:

**Raw CSV Data → Staging Table → Data Cleaning → EDA → SQL Analysis → Business Insights**

---

## 🎯 Business Objectives

The main objective of this project is to answer important business questions such as:

* What is the total revenue generated?
* How many orders were placed?
* Which product category generates the highest revenue?
* What percentage of total revenue comes from each category?
* Who are the top 10 customers by spending?
* What is the monthly revenue trend?
* What is the average order value by customer gender?
* Which day of the week generates the highest average revenue?
* How does revenue vary across different age groups?
* What is the best-selling product in each category?
* What is the cumulative revenue over time?
* Which customers made repeat purchases?
* What are the top 3 products in each category?

---

## 🗂️ Dataset

The project uses an e-commerce sales dataset stored in CSV format.

### Main Columns

| Column            | Description                   |
| ----------------- | ----------------------------- |
| `order_id`        | Unique order identifier       |
| `product_name`    | Name of the purchased product |
| `category`        | Product category              |
| `price`           | Product price                 |
| `quantity`        | Quantity purchased            |
| `total_sales`     | Total sales amount            |
| `customer_id`     | Customer identifier           |
| `customer_age`    | Customer age                  |
| `customer_gender` | Customer gender               |
| `purchase_date`   | Date of purchase              |
| `purchase_time`   | Time of purchase              |

---

## 🧹 Data Preparation & EDA

Before performing the analysis, I carried out several data quality checks.

### Data preparation included:

* Created a staging table for raw CSV data
* Loaded the CSV using `LOAD DATA INFILE`
* Converted purchase dates into the appropriate `DATE` format
* Checked for duplicate order IDs
* Checked for NULL values
* Checked for invalid prices
* Checked for invalid quantities
* Checked for invalid sales values
* Examined unique product categories
* Examined unique customer genders
* Checked the minimum and maximum customer age

---

## 🔍 SQL Analysis

### 1. Revenue & Order Analysis

Calculated:

* Total number of orders
* Total revenue
* Category-level revenue
* Revenue contribution by category

### 2. Customer Analysis

Analyzed:

* Top 10 customers by spending
* Repeat customers
* Total spending by repeat customers
* Customer behavior by gender
* Customer age groups

### 3. Product Analysis

Analyzed:

* Best-selling product in each category
* Top 3 products in each category
* Product revenue performance
* Product quantity sold

### 4. Time-Based Analysis

Analyzed:

* Monthly revenue trends
* Average revenue by day of the week
* Daily revenue
* Cumulative revenue over time

---

## 🚀 Advanced SQL Concepts

This project also demonstrates intermediate and advanced SQL concepts including:

* `WITH` / Common Table Expressions (CTEs)
* Window functions
* `DENSE_RANK()`
* `ROW_NUMBER()`
* `LAG()`
* `PARTITION BY`
* `ORDER BY`
* Running totals
* Aggregate functions
* `CASE WHEN`
* `DATE_FORMAT()`
* `DAYNAME()`
* `STR_TO_DATE()`
* `GROUP BY`
* `HAVING`
* Subqueries

---

## ⭐ Example: Top 3 Products in Each Category

One of the key analyses uses a CTE and `DENSE_RANK()` to rank products within each category.

```sql
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
```

This query:

1. Calculates total revenue for each product
2. Ranks products within each category
3. Keeps only the top 3 products from every category

---

## 💡 Key Analytical Areas

The project provides a framework for understanding:

**Revenue Performance**
Identifying the highest-performing categories and products.

**Customer Behavior**
Understanding high-value and repeat customers.

**Product Performance**
Finding the products contributing most to sales.

**Sales Trends**
Identifying changes in revenue across different time periods.

**Customer Segmentation**
Comparing revenue across age groups and genders.

---

## 🛠️ Tools & Technologies

* **MySQL**
* **SQL**
* **CSV**
* **GitHub**

---

## 📌 Learning Outcomes

Through this project, I strengthened my ability to:

* Work with raw CSV data in MySQL
* Perform data quality checks
* Explore datasets using SQL
* Translate business questions into SQL queries
* Use CTEs for structured analysis
* Apply window functions for ranking and cumulative calculations
* Analyze customer and product behavior
* Extract business insights from sales data


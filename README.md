# 📊 Task 3 – SQL for Data Analysis

This repository contains my complete solution for **Task 3** of the Data Analyst Internship assignment. The goal of this task was to perform SQL-based data analysis on an E-commerce relational database using MySQL Workbench.

---

## 📁 Repository Structure

```
├── Users.csv
├── Products.csv
├── Orders.csv
├── Order_Items.csv
├── SQL Queries.sql          # All SQL queries used for the task
├── task3_mysql_setup.sql    # Table creation script
├── screenshots/             # Query result screenshots
└── README.md
```

---

## 📘 Objective

To analyze an E-commerce database using SQL by applying:

* SELECT, WHERE, ORDER BY, GROUP BY
* INNER / LEFT / RIGHT JOIN
* Subqueries
* Aggregate functions → SUM, AVG, COUNT, MAX, MIN
* Views for analysis
* Indexes for query optimization

This task demonstrates real-world SQL data analysis skills.

---

## 🗂 Dataset Overview

The project uses an **E-commerce dataset** consisting of four relational tables:

### **1. Users**

Basic customer information.

### **2. Products**

Product catalog with pricing.

### **3. Orders**

Order-level information including user ID and status.

### **4. Order_Items**

Line-level details linking products to orders.

This structure supports analytical operations such as revenue calculations, order analysis, customer segmentation, etc.

---

## 🛠 Tools Used

* **MySQL Workbench 8**
* **MySQL Server**
* CSV Import Wizard (MySQL GUI)
* SQL scripts

---

## 🚀 Steps Performed

### **1. Created Database & Tables**

I first executed the `task3_mysql_setup.sql` file to create the database structure with proper:

* Primary keys
* Foreign keys
* Data types
* Indexes

### **2. Imported the Data Using GUI (No LOAD DATA Used)**

I imported all four CSV files using:

> **MySQL Workbench → Table Data Import Wizard**
> Right-click table → *Table Data Import Wizard* → select CSV → map columns → Import

This method avoids the need for file paths or local infile permissions.

### **3. Executed SQL Queries**

All SQL queries that answer the Task 3 requirements are stored inside **SQL Queries.sql**, including:

#### ✔ WHERE vs HAVING

Filtering rows vs filtering aggregated groups.

#### ✔ JOINS

* INNER JOIN → matching records
* LEFT JOIN → users with or without orders
* RIGHT JOIN → products with/without sales

#### ✔ Aggregations

* Revenue
* Category-wise sales
* Average Revenue Per User (ARPU)
* Monthly revenue breakdown

#### ✔ Subqueries

* Users spending more than average
* Top orders by revenue
* Orders above percentile

#### ✔ Views

Created analytical views such as:

```sql
CREATE VIEW order_totals_view AS ...
CREATE VIEW customer_ltv_view AS ...
```

#### ✔ Optimization

Added indexes for performance improvement:

```sql
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
```

---

## 📷 Screenshots Provided

Inside the **/screenshots** folder are outputs for:

* WHERE vs HAVING
* JOINS (INNER, LEFT, RIGHT)
* Subqueries
* Aggregate analysis
* Views output
* Index verification (SHOW INDEX / EXPLAIN)

These fulfill the task’s submission requirements.


## 🧠 Key Learnings

* Understanding relational database design
* Using JOINs effectively for multi-table analysis
* Difference between WHERE and HAVING
* Importance of views in analytical workloads
* Indexing for query performance optimization


## 📤 Submission Summary

This repository includes:

* ✔ SQL Queries
* ✔ All CSV datasets
* ✔ MySQL table creation script
* ✔ Screenshots of query outputs
* ✔ README explaining the full workflow

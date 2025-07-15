# 🛒 Retail Sales Analysis (SQL Project)

This project focuses on analyzing a retail sales dataset using **MySQL** to extract actionable business insights. It includes real-world SQL use cases such as sales trends, customer behavior, revenue segmentation, and product performance.

## 📁 Dataset Overview

The dataset used is a CSV file (`retail-sale-data.csv`) containing **2001 sales records**, with the following key columns:

- `sale_date` – Date and time of the transaction
- `customer_id` – Unique ID for each customer
- `product_id` – Product identifier
- `category` – Product category (e.g., Electronics, Grocery, Clothing)
- `total_sale` – Total value of the transaction
- `quantity` – Number of items sold

> 💡 Imported and cleaned using MySQL Workbench.

---

## 🎯 Objectives

- Understand purchase behavior and seasonality
- Identify top-performing categories and products
- Track customer activity over time
- Evaluate month-over-month growth
- Segment sales by time-of-day (Morning, Afternoon, Evening)

---

## 🧪 SQL Skills Demonstrated

✅ Grouping & Aggregation  
✅ Window Functions (`RANK()`, `LAG()`)  
✅ Date Functions (`YEAR()`, `MONTH()`, `DAY()`)  
✅ Subqueries & Common Table Expressions (CTEs)  
✅ Conditional Aggregation  
✅ Data Cleaning & Validation

---

## 📊 Key SQL Questions Answered

| Question | SQL Concepts |
|---------|--------------|
| Which month had the highest sales? | `GROUP BY`, `MAX()` |
| What is the average sale per category? | `AVG()`, `GROUP BY` |
| Find the best-selling category per year | `RANK()`, `PARTITION BY` |
| Calculate month-over-month growth | `LAG()`, `OVER` |
| Show first & last purchase date per customer | `MIN()`, `MAX()` |
| Segment orders by shift (Morning/Afternoon/Evening) | `CASE`, `HOUR()` |
| What percentage of revenue comes from each category? | `SUM()`, subquery |

---

## 📎 Sample Queries

###  month-over-month growth rate in sales.
```sql
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    SUM(total_sale) AS monthly_sales,
    LAG(SUM(total_sale)) OVER (ORDER BY DATE_FORMAT(sale_date, '%Y-%m')) AS previous_month_sales,
    ROUND(
        (SUM(total_sale) - LAG(SUM(total_sale)) OVER (ORDER BY DATE_FORMAT(sale_date, '%Y-%m')))
        / LAG(SUM(total_sale)) OVER (ORDER BY DATE_FORMAT(sale_date, '%Y-%m')) * 100,
        2
    ) AS growth_rate_percent
FROM 
    retail_sales
GROUP BY 
    DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY 
    sale_month;



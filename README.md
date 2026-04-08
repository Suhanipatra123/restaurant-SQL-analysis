# 🍽️ Restaurant SQL Analysis Project

## 📌 Overview
This project analyzes restaurant and consumer data using SQL.  
It focuses on extracting insights using joins, aggregations, and advanced SQL concepts.

## 🛠️ Tools Used
- MySQL Workbench
- SQL

## 📊 Key Concepts Used
- SELECT, WHERE
- JOIN (INNER, LEFT)
- GROUP BY, HAVING
- ORDER BY
- CTE (Common Table Expressions)
- Window Functions
- Views & Stored Procedures

## 📁 Dataset
The dataset includes:
- consumers
- restaurants
- ratings
- consumer_preferences
- restaurant_cuisines

## 🔍 Sample Queries

### Example:
```sql
SELECT r.Name, AVG(rt.Overall_Rating) AS avg_rating
FROM restaurants r
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY r.Name
ORDER BY avg_rating DESC;

## ⚠️ Challenges Faced
Handling multiple joins
Debugging empty outputs
Understanding SQL execution order

## 🚀 Outcome
Improved SQL skills and real-world data analysis understanding.

## Author-Suhani Patra.

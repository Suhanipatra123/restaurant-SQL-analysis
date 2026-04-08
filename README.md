# 🍽️ Restaurant Data Analysis using SQL

## 📌 Project Overview
This project focuses on analyzing restaurant and consumer data using SQL.  
It explores customer behavior, restaurant performance, and cuisine preferences by applying various SQL concepts.

The goal is to extract meaningful insights from structured data using efficient queries.

---

## 🛠️ Tools & Technologies
- MySQL Workbench  
- SQL  

---

## 📂 Dataset Description
The dataset consists of multiple tables:

- **consumers** → Consumer details (age, occupation, budget, etc.)  
- **restaurants** → Restaurant details (name, city)  
- **ratings** → Ratings given by consumers  
- **consumer_preferences** → Preferred cuisines  
- **restaurant_cuisines** → Cuisine types of restaurants  

---

## 🔑 Key SQL Concepts Used
- SELECT, WHERE  
- INNER JOIN, LEFT JOIN  
- GROUP BY, HAVING  
- ORDER BY  
- CTE (Common Table Expressions)  
- Window Functions  
- Views & Stored Procedures  

---

## 📊 Sample Queries

### 🔹 1. Students who rated more than 2 restaurants
```sql
SELECT r.Consumer_ID, COUNT(r.Restaurant_ID) AS total_ratings
FROM ratings r
JOIN consumers c ON r.Consumer_ID = c.Consumer_ID
WHERE c.Occupation = 'Student'
GROUP BY r.Consumer_ID
HAVING COUNT(r.Restaurant_ID) > 2
ORDER BY total_ratings DESC;
```

---

### 🔹 2. Engagement Score Calculation
```sql
SELECT Consumer_ID, Age, FLOOR(Age/10) AS Engagement_Score
FROM consumers
WHERE FLOOR(Age/10) = 2
AND Transportation_Method = 'Public'
ORDER BY Age;
```

---

### 🔹 3. Average Rating of Restaurants in Cuernavaca
```sql
SELECT r.Name, r.City, AVG(rt.Overall_Rating) AS avg_rating
FROM restaurants r
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
WHERE r.City = 'Cuernavaca'
GROUP BY r.Restaurant_ID, r.Name, r.City
HAVING AVG(rt.Overall_Rating) > 1
ORDER BY avg_rating DESC;
```

---

### 🔹 4. Consumers who prefer Mexican but not rated high-rated restaurants
```sql
WITH mexican_lovers AS (
    SELECT Consumer_ID
    FROM consumer_preferences
    WHERE Preferred_Cuisine = 'Mexican'
)
SELECT ml.Consumer_ID
FROM mexican_lovers ml
WHERE ml.Consumer_ID NOT IN (
    SELECT DISTINCT rt.Consumer_ID
    FROM ratings rt
    JOIN restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
    WHERE rt.Overall_Rating > 1.5
);
```

---

## ⚠️ Challenges Faced
- Handling multiple table joins  
- Debugging empty result sets  
- Understanding SQL execution order  
- Managing data consistency  

---

## 📈 Conclusion
This project helped in strengthening SQL fundamentals and understanding real-world data analysis scenarios.  

It demonstrates the use of SQL for:
- Data extraction  
- Data transformation  
- Insight generation  

Overall, this project reflects practical knowledge of SQL and problem-solving skills required for data analytics roles.

---

## 👩‍💻 Author
**Suhani Patra**

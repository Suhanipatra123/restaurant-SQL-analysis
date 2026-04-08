-- =========================================
-- Project Title: Restaurant Recommendation & Consumer Behavior Analysis using SQL
-- =========================================

-- DATABASE
CREATE DATABASE restaurant_db;
USE restaurant_db;

-- Tables
-- 1.Consumers(Parent Table)
CREATE TABLE consumers (
    Consumer_ID VARCHAR(10) PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    Latitude DECIMAL(10,7),
    Longitude DECIMAL(10,7),
    Smoker VARCHAR(10),
    Drink_Level VARCHAR(50),
    Transportation_Method VARCHAR(50),
    Marital_Status VARCHAR(20),
    Children VARCHAR(20),
    Age INT NOT NULL CHECK (Age > 0),
    Occupation VARCHAR(50) NOT NULL,
    Budget VARCHAR(20) DEFAULT 'Unknown'
)ENGINE=InnoDB;

-- 2.Restaurants(Parent Table)
CREATE TABLE restaurants (
    Restaurant_ID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    Zip_Code VARCHAR(20),
    Latitude DECIMAL(10,7),
    Longitude DECIMAL(10,7),
    Alcohol_Service VARCHAR(50),
    Smoking_Allowed VARCHAR(50),
    Price VARCHAR(20) CHECK (Price IN ('Low','Medium','High')),
    Franchise VARCHAR(10),
    Area VARCHAR(50),
    Parking VARCHAR(50)
)ENGINE=InnoDB;

-- 3.Consumer_Preferences(Child of Consumers)
CREATE TABLE consumer_preferences (
    Consumer_ID VARCHAR(10),
    Preferred_Cuisine VARCHAR(100),
    PRIMARY KEY (Consumer_ID, Preferred_Cuisine),
    FOREIGN KEY (Consumer_ID) REFERENCES consumers(Consumer_ID)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

-- 4.Restaurant_Cuisines(Child of Restaurants)
CREATE TABLE restaurant_cuisines (
    Restaurant_ID INT,
    Cuisine VARCHAR(100),
    PRIMARY KEY (Restaurant_ID, Cuisine),
    FOREIGN KEY (Restaurant_ID) REFERENCES restaurants(Restaurant_ID)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

-- 5.Ratings(Bridge Table)
CREATE TABLE ratings (
    Consumer_ID VARCHAR(10),
    Restaurant_ID INT,
    Overall_Rating INT CHECK (Overall_Rating IN (0,1,2)),
    Food_Rating INT CHECK (Food_Rating IN (0,1,2)),
    Service_Rating INT CHECK (Service_Rating IN (0,1,2)),
    PRIMARY KEY (Consumer_ID, Restaurant_ID),
    FOREIGN KEY (Consumer_ID) REFERENCES consumers(Consumer_ID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Restaurant_ID) REFERENCES restaurants(Restaurant_ID)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;

-- Indexes(Performance Boost)
CREATE INDEX idx_consumer_id ON ratings(Consumer_ID);
CREATE INDEX idx_restaurant_id ON ratings(Restaurant_ID);

-- =====================================================
-- LOAD DATA:Data was succesfully loaded using My SQL Terminal.This code is provided only for reference purposes.
-- =====================================================

-- CONSUMERS TABLE
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE "C:/Users/SUHANI PATRA/Downloads/consumers.csv"
INTO TABLE consumers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@Consumer_ID, @City, @State, @Country, @Latitude, @Longitude, @Smoker, @Drink_Level, @Transportation_Method, @Marital_Status, @Children, @Age, @Occupation, @Budget)
SET 
    Consumer_ID = @Consumer_ID,
    City = @City,
    State = @State,
    Country = @Country,
    Latitude = @Latitude,
    Longitude = @Longitude,
    Smoker = @Smoker,
    Drink_Level = @Drink_Level,
    Transportation_Method = @Transportation_Method,
    Marital_Status = @Marital_Status,
    Children = @Children,
    Age = @Age,
    Occupation = @Occupation,
    Budget = @Budget;

-- RESTAURANTS TABLE
LOAD DATA LOCAL INFILE "C:/Users/SUHANI PATRA/Downloads/restaurants.csv"
INTO TABLE restaurants
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@Restaurant_ID, @Name, @City, @State, @Country, @Zip_Code, @Latitude, @Longitude, @Alcohol_Service, @Smoking_Allowed, @Price, @Franchise, @Area, @Parking)
SET 
    Restaurant_ID = @Restaurant_ID,
    Name = @Name,
    City = @City,
    State = @State,
    Country = @Country,
    Zip_Code = @Zip_Code,
    Latitude = @Latitude,
    Longitude = @Longitude,
    Alcohol_Service = @Alcohol_Service,
    Smoking_Allowed = @Smoking_Allowed,
    Price = @Price,
    Franchise = @Franchise,
    Area = @Area,
    Parking = @Parking;
  
  -- CONSUMER_PREFERENCES Table (Maps Consumer_ID to Consumer_ID, Preferred_Cuisine to Preferred_Cuisine)
LOAD DATA LOCAL INFILE "C:/Users/SUHANI PATRA/Downloads/consumer_preferences.csv"
INTO TABLE consumer_preferences
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@Consumer_ID, @Preferred_Cuisine)
SET 
    Consumer_ID = @Consumer_ID,
    Preferred_Cuisine = @Preferred_Cuisine;
 
 -- RESTAURANT_CUISINES Table (Maps Restaurant_ID to Restaurant_ID, Cuisine to Cuisine)
LOAD DATA LOCAL INFILE "C:\Users\SUHANI PATRA\Downloads\restaurant_cuisines.csv"
INTO TABLE restaurant_cuisines
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@Restaurant_ID, @Cuisine)
SET 
    Restaurant_ID = @Restaurant_ID,
    Cuisine = @Cuisine;
    
-- RATINGS TABLE
LOAD DATA LOCAL INFILE "C:/Users/SUHANI PATRA/Downloads/ratings.csv"
INTO TABLE ratings
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@Consumer_ID, @Restaurant_ID, @Overall_Rating, @Food_Rating, @Service_Rating)
SET 
    Consumer_ID = @Consumer_ID,
    Restaurant_ID = @Restaurant_ID,
    Overall_Rating = @Overall_Rating,
    Food_Rating = @Food_Rating,
    Service_Rating = @Service_Rating;    

-- =====================================================
-- DATA IMPORT USING LOAD DATA LOCAL INFILE
-- =====================================================

-- ================================
-- VERIFY DATA LOADING IN ALL TABLES
-- ================================
SELECT * FROM consumers;
SELECT * FROM restaurants;
SELECT * FROM consumer_preferences;
SELECT * FROM restaurant_cuisines;
SELECT * FROM ratings;

SELECT * FROM consumers LIMIT 5;
SELECT * FROM ratings LIMIT 5;

-- ================================
-- 1. CONSUMER INSIGHTS
-- ================================

-- Total number of consumers
SELECT COUNT(*) AS total_consumers FROM consumers;

-- Consumers by city
SELECT City, COUNT(*) AS total
FROM consumers
GROUP BY City
ORDER BY total DESC;

-- Budget distribution
SELECT Budget, COUNT(*) AS total
FROM consumers
GROUP BY Budget;


-- ================================
-- 2. RESTAURANT INSIGHTS
-- ================================

-- Total restaurants
SELECT COUNT(*) AS total_restaurants FROM restaurants;

-- Restaurants by price category
SELECT Price, COUNT(*) AS total
FROM restaurants
GROUP BY Price;

-- Restaurants offering alcohol service
SELECT Alcohol_Service, COUNT(*) 
FROM restaurants
GROUP BY Alcohol_Service;


-- ================================
-- 3. CUISINE ANALYSIS
-- ================================

-- Most common cuisines
SELECT Cuisine, COUNT(*) AS total
FROM restaurant_cuisines
GROUP BY Cuisine
ORDER BY total DESC;

-- Consumer preferred cuisines
SELECT Preferred_Cuisine, COUNT(*) AS total
FROM consumer_preferences
GROUP BY Preferred_Cuisine
ORDER BY total DESC;


-- ================================
-- 4. RATINGS ANALYSIS
-- ================================

-- Average ratings
SELECT 
    AVG(Overall_Rating) AS avg_overall,
    AVG(Food_Rating) AS avg_food,
    AVG(Service_Rating) AS avg_service
FROM ratings;

-- Top rated restaurants
SELECT Restaurant_ID, AVG(Overall_Rating) AS avg_rating
FROM ratings
GROUP BY Restaurant_ID
ORDER BY avg_rating DESC;


-- ================================
-- 5. RECOMMENDATION LOGIC
-- ================================

-- Find best restaurants based on rating + cuisine
SELECT r.Restaurant_ID, r.Name, rc.Cuisine, AVG(rt.Overall_Rating) AS avg_rating
FROM restaurants r
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY r.Restaurant_ID, rc.Cuisine
ORDER BY avg_rating DESC;

-- ================================
-- ** Using the WHERE clause to filter data based on specific criteria.**
-- ================================

-- Q1. List all details of consumers who live in the city of 'Cuernavaca'.
-- Consumers from Cuernavaca
SELECT *
FROM consumers
WHERE City = 'Cuernavaca';
-- Q2. Find Consumer_ID, Age, and Occupation of consumers who are Students AND Smokers.
-- Students who are Smokers
SELECT Consumer_ID, Age, Occupation
FROM consumers
WHERE Occupation = 'Student'
AND Smoker = 'Yes';
-- Q3. List Name, City, Alcohol_Service, Price of restaurants serving 'Wine & Beer' with 'Medium' price.
-- Restaurants serving Wine & Beer with Medium price
SELECT Name, City, Alcohol_Service, Price
FROM restaurants
WHERE Alcohol_Service = 'Wine & Beer'
AND Price = 'Medium';
-- Q4. Find names and cities of restaurants that are part of a Franchise.
-- Franchise restaurants
SELECT Name, City
FROM restaurants
WHERE Franchise = 'Yes';
-- Q5. Show Consumer_ID, Restaurant_ID, Overall_Rating where rating = 2 (Highly Satisfactory)
-- Highly satisfactory ratings
SELECT Consumer_ID, Restaurant_ID, Overall_Rating
FROM ratings
WHERE Overall_Rating = 2;
-- Q6. Find consumers who are non-smokers and drink level is 'Low'
SELECT Consumer_ID, City, Drink_Level
FROM consumers
WHERE Smoker = 'No'
AND Drink_Level = 'Low';
-- Q7. Find restaurants located in a specific city (e.g., 'Cuernavaca')
SELECT Name, City, Price
FROM restaurants
WHERE City = 'Cuernavaca';
-- Q8. Find restaurants with High price and parking available
SELECT Name, Price, Parking
FROM restaurants
WHERE Price = 'High'
AND Parking != 'None';

-- ================================
-- **Questions JOINs with Subqueries**
-- ================================

-- 1. List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer. 
-- Restaurants with highly satisfactory rating
-- Restaurants with Overall Rating = 2
SELECT DISTINCT r.Name, r.City
FROM restaurants r
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rt.Overall_Rating = 2;
-- 2. Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'
-- Consumers who rated restaurants in 'San Luis Potosi'
SELECT DISTINCT c.Consumer_ID, c.Age
FROM consumers c
JOIN ratings rt ON c.Consumer_ID = rt.Consumer_ID
JOIN restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
WHERE r.City = 'San Luis Potosi';
-- 3. List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
-- Mexican cuisine + rated by U1001
SELECT * FROM ratings Where Consumer_ID =  'U1001';
SELECT * FROM restaurant_cuisines Where Cuisine =  'U1001';
SELECT DISTINCT  r.NAME
FROM restaurants r
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
WHERE LOWER(rc.Cuisine) = 'mexican'
AND rt.Consumer_ID = 'U1001';

-- Debugging: Check which cuisines are rated by consumer U1001
SELECT rc.Cuisine, rt.Consumer_ID
FROM restaurant_cuisines rc
JOIN ratings rt 
ON rc.Restaurant_ID = rt.Restaurant_ID
WHERE rt.Consumer_ID = 'U1001';
-- 4. Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
-- Consumers who prefer American cuisine and have a Medium budget
-- Debug: Check available cuisine values in consumer_preferences
SELECT DISTINCT Preferred_Cuisine 
FROM consumer_preferences;

-- Debug: Check available budget values in consumers
SELECT DISTINCT Budget 
FROM consumers;

-- The query is correct, but no matching records exist in the dataset where consumers prefer 'American' cuisine and have a 'Medium' budget simultaneously.
SELECT c.*
FROM consumers c
JOIN consumer_preferences cp 
ON c.Consumer_ID = cp.Consumer_ID
WHERE cp.Preferred_Cuisine = 'American'
AND c.Budget = 'Medium';

-- Debug: Check consumers who prefer American cuisine and their budget values
SELECT c.Consumer_ID, c.Budget, cp.Preferred_Cuisine
FROM consumers c
JOIN consumer_preferences cp
ON c.Consumer_ID = cp.Consumer_ID
WHERE cp.Preferred_Cuisine = 'American';
-- Note:
-- The query is correct, but no matching records exist in the dataset.
-- 5. List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.
-- Restaurants with Food_Rating below average
SELECT DISTINCT r.Name, r.City
FROM restaurants r
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rt.Food_Rating < (
    SELECT AVG(Food_Rating) FROM ratings
);
-- 6. Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but have NOT rated any restaurant that serves 'Italian' cuisine.
-- Consumers who rated but NOT Italian restaurants
SELECT DISTINCT c.Consumer_ID, c.Age, c.Occupation
FROM consumers c
WHERE c.Consumer_ID IN (
    SELECT Consumer_ID FROM ratings
)
AND c.Consumer_ID NOT IN (
    SELECT rt.Consumer_ID
    FROM ratings rt
    JOIN restaurant_cuisines rc 
    ON rt.Restaurant_ID = rc.Restaurant_ID
    WHERE rc.Cuisine = 'Italian'
);
-- 7. List restaurants (Name) that have received ratings from consumers older than 30. 
-- Restaurants rated by consumers older than 30
SELECT DISTINCT r.Name
FROM restaurants r
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
JOIN consumers c ON rt.Consumer_ID = c.Consumer_ID
WHERE c.Age > 30;
-- 8. Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant). 
-- Mexican preference + gave rating 0
SELECT DISTINCT c.Consumer_ID, c.Occupation
FROM consumers c
JOIN consumer_preferences cp 
ON c.Consumer_ID = cp.Consumer_ID
JOIN ratings rt ON c.Consumer_ID = rt.Consumer_ID
WHERE cp.Preferred_Cuisine = 'Mexican'
AND rt.Overall_Rating = 0;
-- 9. List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city where at least one 'Student' consumer lives. 
-- Pizzeria cuisine + city with students
SELECT DISTINCT r.Name, r.City
FROM restaurants r
JOIN restaurant_cuisines rc 
ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Pizzeria'
AND r.City IN (
    SELECT DISTINCT City
    FROM consumers
    WHERE Occupation = 'Student'
);
-- 10. Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.
-- Social drinkers + restaurant with no parking
SELECT DISTINCT c.Consumer_ID, c.Age
FROM consumers c
JOIN ratings rt ON c.Consumer_ID = rt.Consumer_ID
JOIN restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
WHERE c.Drink_Level = 'Social Drinker'
AND r.Parking = 'No';
-- Top rated restaurant
SELECT r.Name, AVG(rt.Overall_Rating) AS avg_rating
FROM restaurants r
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY r.Name
ORDER BY avg_rating DESC;
-- Most preferred cuisine
SELECT Preferred_Cuisine, COUNT(*) AS total
FROM consumer_preferences
GROUP BY Preferred_Cuisine
ORDER BY total DESC;
-- Consumers who never rated any restaurant
SELECT *
FROM consumers
WHERE Consumer_ID NOT IN (
    SELECT Consumer_ID FROM ratings
);


-- ================================
-- **Questions Emphasizing WHERE Clause and Order of Execution**
-- ================================

-- 1. List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. Show only students who have rated more than 2 restaurants. 
-- Students who rated more than 2 restaurants
SELECT c.Consumer_ID, COUNT(r.Restaurant_ID) AS total_ratings
FROM consumers c
JOIN ratings r
ON c.Consumer_ID = r.Consumer_ID
WHERE c.Occupation = 'Student'
GROUP BY c.Consumer_ID
HAVING COUNT(r.Restaurant_ID) > 2 
ORDER BY total_ratings DESC;
-- 2. We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division). List the Consumer_ID, Age, and this calculated Engagement_Score, but only for consumers whose Engagement_Score would be exactly 2 and who use 'Public'
-- Consumers with Engagement Score = 2 and using Public transport
SELECT Consumer_ID, Age, (Age DIV 10) AS Engagement_Score
FROM consumers
WHERE (Age DIV 10) = 2
AND Transportation_Method = 'Public'
ORDER BY Age;
-- 3. For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name, City, and its calculated average Overall_Rating, but only for restaurants located in vaca' AND whose calculated average Overall_Rating is greater than 1.0.
-- Restaurants with average Overall_Rating > 1 in Cuernavaca
SELECT r.Name, r.City, AVG(rt.Overall_Rating) AS avg_rating
FROM restaurants r
JOIN ratings rt
ON r.Restaurant_ID = rt.Restaurant_ID
WHERE r.City = 'Cuernavaca'
GROUP BY r.Restaurant_ID, r.Name, r.City
HAVING AVG(rt.Overall_Rating) > 1.0;
-- 4. Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any restaurant is equal to their Service_Rating for that same restaurant, but only consider ratings where the Overall_Rating was 2. 
-- Married consumers where Food_Rating = Service_Rating and Overall_Rating = 2
SELECT DISTINCT c.Consumer_ID, c.Age
FROM consumers c
JOIN ratings r
ON c.Consumer_ID = r.Consumer_ID
WHERE c.Marital_Status = 'Married'
AND r.Overall_Rating = 2
AND r.Food_Rating = r.Service_Rating
ORDER BY c.Age;
-- 5. List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers who are 'Employed' and have given a Food_Rating of 0 to at least one restaurant located in 'Ciudad Victoria'.
-- Employed consumers who gave Food_Rating = 0 in Ciudad Victoria
SELECT DISTINCT c.Consumer_ID, c.Age, r2.Name AS Restaurant_Name
FROM consumers c
JOIN ratings r
ON c.Consumer_ID = r.Consumer_ID
JOIN restaurants r2
ON r.Restaurant_ID = r2.Restaurant_ID
WHERE c.Occupation = 'Employed'
AND r.Food_Rating = 0
AND r2.City = 'Ciudad Victoria';
-- Top 5 restaurants with highest number of ratings
SELECT r.Name, COUNT(rt.Consumer_ID) AS total_ratings
FROM restaurants r
JOIN ratings rt
ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY r.Restaurant_ID, r.Name
ORDER BY total_ratings DESC
LIMIT 5;
-- Average rating per cuisine
SELECT rc.Cuisine, AVG(r.Overall_Rating) AS avg_rating
FROM restaurant_cuisines rc
JOIN ratings r
ON rc.Restaurant_ID = r.Restaurant_ID
GROUP BY rc.Cuisine
ORDER BY avg_rating DESC;
-- Consumers who rated the most restaurants
-- Consumers with highest activity
SELECT Consumer_ID, COUNT(Restaurant_ID) AS total_rated
FROM ratings
GROUP BY Consumer_ID
ORDER BY total_rated DESC;
-- Restaurants with NO ratings
-- Restaurants that have never been rated
SELECT r.Name
FROM restaurants r
LEFT JOIN ratings rt
ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rt.Restaurant_ID IS NULL;
-- Restaurants with highest average rating
-- Top rated restaurants
SELECT r.Name, AVG(rt.Overall_Rating) AS avg_rating
FROM restaurants r
JOIN ratings rt
ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY r.Restaurant_ID, r.Name
ORDER BY avg_rating DESC;
-- Consumers who never rated any restaurant
-- Consumers with no ratings
SELECT c.Consumer_ID
FROM consumers c
LEFT JOIN ratings r
ON c.Consumer_ID = r.Consumer_ID
WHERE r.Consumer_ID IS NULL;
-- Average age of consumers per city
-- Average age by city
SELECT City, AVG(Age) AS avg_age
FROM consumers
GROUP BY City;

-- ================================
-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures 
-- ================================

-- 1. Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, Age, and the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.
-- CTE – Consumers in San Luis Potosi + Mexican restaurants rated
WITH slp_consumers AS (
    SELECT *
    FROM consumers
    WHERE City = 'San Luis Potosi'
)
SELECT sc.Consumer_ID, sc.Age, r.Name AS Restaurant_Name
FROM slp_consumers sc
JOIN ratings rt ON sc.Consumer_ID = rt.Consumer_ID
JOIN restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
AND rt.Overall_Rating = 2;
-- 2. For each Occupation, find the average age of consumers. Only consider consumers who have made at least one rating. (Use a derived table to get consumers who have rated). 
-- Average age per occupation (only consumers who rated)
SELECT c.Occupation, AVG(c.Age) AS avg_age
FROM consumers c
JOIN ratings r ON c.Consumer_ID = r.Consumer_ID
GROUP BY c.Occupation;
-- 3. Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings within each restaurant based on Overall_Rating (highest first). Display Restaurant_ID, Consumer_ID, _Rating, and the RatingRank. 
-- Ranking ratings in Cuernavaca
WITH cuernavaca_ratings AS (
    SELECT r.Restaurant_ID, rt.Consumer_ID, rt.Overall_Rating
    FROM restaurants r
    JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
    WHERE r.City = 'Cuernavaca'
)
SELECT Restaurant_ID, Consumer_ID, Overall_Rating,
RANK() OVER (PARTITION BY Restaurant_ID ORDER BY Overall_Rating DESC) AS rating_rank
FROM cuernavaca_ratings;
-- 4. For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and also display the average Overall_Rating given by that specific consumer across all their ratings. 
-- Consumer rating + their average rating
SELECT Consumer_ID, Restaurant_ID, Overall_Rating,
AVG(Overall_Rating) OVER (PARTITION BY Consumer_ID) AS avg_consumer_rating
FROM ratings;
-- 5. Using a CTE, identify students who have a 'Low' budget. Then, for each of these students, list their top 3 most preferred cuisines based on the order they appear in the r_Preferences table (assuming no explicit preference order, use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).
-- Students with Low budget + top 3 cuisines
WITH student_low AS (
    SELECT *
    FROM consumers
    WHERE Occupation = 'Student' AND Budget = 'Low'
)
SELECT Consumer_ID, Preferred_Cuisine
FROM (
    SELECT cp.Consumer_ID, cp.Preferred_Cuisine,
    ROW_NUMBER() OVER (PARTITION BY cp.Consumer_ID ORDER BY cp.Preferred_Cuisine) AS rn
    FROM consumer_preferences cp
    JOIN student_low sl ON cp.Consumer_ID = sl.Consumer_ID
) t
WHERE rn <= 3;
-- 6. Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating, and the Overall_Rating of the next restaurant they rated (if any), ordered by Restaurant_ID (as a proxy for time if rating time isn't available). Use a derived table to filter for the consumer's ratings first. 
-- Next restaurant rating (LEAD)
WITH user_ratings AS (
    SELECT *
    FROM ratings
    WHERE Consumer_ID = 'U1008'
)
SELECT Consumer_ID, Restaurant_ID, Overall_Rating,
LEAD(Overall_Rating) OVER (ORDER BY Restaurant_ID) AS next_rating
FROM user_ratings;
-- 7. Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, and City of all Mexican restaurants that have an average Overall_Rating greater than 1.5. 
-- VIEW – Highly Rated Mexican Restaurants
DROP VIEW IF EXISTS HighlyRatedMexicanRestaurants;
CREATE VIEW HighlyRatedMexicanRestaurants AS
SELECT r.Restaurant_ID, r.Name, r.City
FROM restaurants r
JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
GROUP BY r.Restaurant_ID, r.Name, r.City
HAVING AVG(rt.Overall_Rating) > 1.5;

SELECT * FROM  HighlyRatedMexicanRestaurants;
-- 8. First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, using a CTE to find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) who have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view
-- Consumers who prefer Mexican but NOT rated high-rated restaurants
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
    JOIN HighlyRatedMexicanRestaurants hmr
    ON rt.Restaurant_ID = hmr.Restaurant_ID
);
-- 9. Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and a minimum Overall_Rating as input. It should return the Consumer_ID, Overall_Rating, Food_Rating, and Service_Rating for that restaurant where the Overall_Rating meets or exceeds the threshold.
-- Stored Procedure – GetRestaurantRatingsAboveThreshold
DELIMITER //

CREATE PROCEDURE GetRestaurantRatingsAboveThreshold(
    IN rest_id INT,
    IN min_rating INT
)
BEGIN
    SELECT Consumer_ID, Overall_Rating, Food_Rating, Service_Rating
    FROM ratings
    WHERE Restaurant_ID = rest_id
    AND Overall_Rating >= min_rating;
END //

DELIMITER ;
-- 10. Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. If there are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and Overall_Rating.
-- Top 2 highest-rated restaurants per cuisine
SELECT *
FROM (
    SELECT rc.Cuisine, r.Name, r.City, AVG(rt.Overall_Rating) AS avg_rating,
    RANK() OVER (PARTITION BY rc.Cuisine ORDER BY AVG(rt.Overall_Rating) DESC) AS rnk
    FROM restaurants r
    JOIN restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
    JOIN ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
    GROUP BY rc.Cuisine, r.Restaurant_ID, r.Name, r.City
) t
WHERE rnk <= 2;
-- 11. First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by their average overall rating. For these top 5 consumers, list their Consumer_ID, their average rating, and the number of 'Mexican' restaurants they have rated.
-- Top 5 consumers + Mexican count
DROP VIEW IF EXISTS ConsumerAverageRatings;

CREATE VIEW ConsumerAverageRatings AS
SELECT Consumer_ID, AVG(Overall_Rating) AS avg_rating
FROM ratings
GROUP BY Consumer_ID;
WITH top5 AS (
    SELECT *
    FROM ConsumerAverageRatings
    ORDER BY avg_rating DESC
    LIMIT 5
)

SELECT t.Consumer_ID, t.avg_rating,
COUNT(rc.Restaurant_ID) AS mexican_count
FROM top5 t
JOIN ratings r 
ON t.Consumer_ID = r.Consumer_ID
JOIN restaurant_cuisines rc 
ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
GROUP BY t.Consumer_ID, t.avg_rating;

SELECT * FROM ConsumerAverageRatings;
-- 12. Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input. The procedure should: 
-- 1. Determine the consumer's "Spending Segment" based on their Budget: 
-- ○ 'Low' -> 'Budget Conscious' 
-- ○ 'Medium' -> 'Moderate Spender' 
-- ○ 'High' -> 'Premium Spender' 
-- ○ NULL or other -> 'Unknown Budget' 
-- 2. For all restaurants rated by this consumer: 
-- ○ List the Restaurant_Name. 
-- ○ The Overall_Rating given by this consumer. 
-- ○ The average Overall_Rating this restaurant has received from all consumers (not just the input consumer). 
-- ○ A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 'At Average', or 'Below Average' compared to the restaurant's overall average rating. 
-- ○ Rank these restaurants for the input consumer based on the Overall_Rating they gave (highest rating = rank 1). 

-- Stored Procedure – Consumer Segment + Performance
DELIMITER //

CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance(
    IN input_consumer_id VARCHAR(10)
)
BEGIN

    SELECT 
        c.Consumer_ID,
        CASE 
            WHEN c.Budget = 'Low' THEN 'Budget Conscious'
            WHEN c.Budget = 'Medium' THEN 'Moderate Spender'
            WHEN c.Budget = 'High' THEN 'Premium Spender'
            ELSE 'Unknown Budget'
        END AS Spending_Segment,
        r.Name AS Restaurant_Name,
        rt.Overall_Rating,
        AVG(rt2.Overall_Rating) AS avg_restaurant_rating,
        CASE 
            WHEN rt.Overall_Rating > AVG(rt2.Overall_Rating) THEN 'Above Average'
            WHEN rt.Overall_Rating = AVG(rt2.Overall_Rating) THEN 'At Average'
            ELSE 'Below Average'
        END AS Performance_Flag,
        RANK() OVER (ORDER BY rt.Overall_Rating DESC) AS rank_given
    FROM consumers c
    JOIN ratings rt ON c.Consumer_ID = rt.Consumer_ID
    JOIN restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
    JOIN ratings rt2 ON r.Restaurant_ID = rt2.Restaurant_ID
    WHERE c.Consumer_ID = input_consumer_id
    GROUP BY c.Consumer_ID, c.Budget, r.Name, rt.Overall_Rating;

END //

DELIMITER ;
-- Find top 3 restaurants with highest average rating
-- Top 3 highest rated restaurants
SELECT r.Name, r.City, AVG(rt.Overall_Rating) AS avg_rating
FROM restaurants r
JOIN ratings rt 
ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY r.Restaurant_ID, r.Name, r.City
ORDER BY avg_rating DESC
LIMIT 3;
-- Find consumers who have rated ALL restaurants they visited above average
-- Consumers who always give above-average ratings
SELECT Consumer_ID
FROM ratings
GROUP BY Consumer_ID
HAVING MIN(Overall_Rating) > (
    SELECT AVG(Overall_Rating) FROM ratings
);
-- Find most popular cuisine (based on number of ratings)
-- Most popular cuisine
SELECT rc.Cuisine, COUNT(*) AS total_ratings
FROM restaurant_cuisines rc
JOIN ratings r 
ON rc.Restaurant_ID = r.Restaurant_ID
GROUP BY rc.Cuisine
ORDER BY total_ratings DESC
LIMIT 1;
-- Find consumers who have never rated any restaurant
-- Consumers with no ratings
SELECT c.Consumer_ID
FROM consumers c
LEFT JOIN ratings r 
ON c.Consumer_ID = r.Consumer_ID
WHERE r.Consumer_ID IS NULL;
-- Find restaurants that have better service than food rating
-- Restaurants where service > food rating (on average)
SELECT r.Name, 
AVG(rt.Service_Rating) AS avg_service,
AVG(rt.Food_Rating) AS avg_food
FROM restaurants r
JOIN ratings rt 
ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY r.Restaurant_ID, r.Name
HAVING avg_service > avg_food;
-- Find rank of restaurants based on rating
-- Ranking restaurants
SELECT r.Name,
AVG(rt.Overall_Rating) AS avg_rating,
RANK() OVER (ORDER BY AVG(rt.Overall_Rating) DESC) AS ranking
FROM restaurants r
JOIN ratings rt 
ON r.Restaurant_ID = rt.Restaurant_ID
GROUP BY r.Restaurant_ID, r.Name;

-- =============================================================
-- END OF SCRIPT
-- =============================================================
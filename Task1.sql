-- TASK1 QUESTION#01
--  Data Exploration:
-- Explore the dataset'
-- s structure, identify key tables, and understand relationships between them.
-- Check for missing values, duplicates, and anomalies. in sql

-- Explore Dataset
   show tables from task1;
   select *from task1.spotify_data;

-- Check for Missing Value
   SELECT * FROM task1.spotify_data WHERE id IS NULL OR name IS NULL;

-- Dubplicate
   SELECT id, COUNT(*) FROM task1.spotify_data GROUP BY id HAVING COUNT(*) > 1;

-- Anamolies
   SELECT * FROM task1.spotify_data WHERE tempo < 100 and duration_ms > 50;
-----------------------------------------------------------------------------------------------------------------   
-- TASK1 QUESTION# 02
-- Basic Queery
-- Write basic SQL queries to retrieve specific data subsets or aggregate information.
-- Utilize SELECT, WHERE, GROUP BY, and ORDER BY clauses effectively.

-- Select all columns from the table
   SELECT * FROM task1.spotify_data;

--  Select specific columns from the "spotify_data" table
    SELECT id, name FROM task1.spotify_data;

-- Select data from "spotify_data" where a specific condition is met
   SELECT *
   FROM task1.spotify_data
   WHERE name = 'Per aspera ad astra';

-- Select data from "spotify_data" where multiple conditions are met
   SELECT * FROM task1.spotify_data WHERE name='Per aspera ad astra' AND id= '6OJjveoYwJdIt76y0Pxpxw';

-- Select and order data from "spotify_data" in ascending order based on a column
   SELECT * FROM task1.spotify_data ORDER BY id ASC;

-- Select and order data from "spotify_data" in ascending order based on a column
   SELECT * FROM task1.spotify_data ORDER BY artists DESC;

-- Group data from "TableName" based on a column and count occurrences
   SELECT id, COUNT(*) FROM task1.spotify_data GROUP BY id;

-- Group data from "spotify_data" and filter based on the count of occurrences
   SELECT id, COUNT(*) FROM task1.spotify_data GROUP BY id HAVING COUNT(*) > 1;

--------------------------------------------------------------------------------------------------------
-- TASK1 QUESTION#03  
-- Join Operations:
-- Practice different types of joins (INNER, LEFT, RIGHT, FULL) to combine data from multiple tables.
-- Understand how join operations affect result sets.

-- Join data from two tables where the specified condition is met
-- INNER JOIN:
   SELECT *
   FROM task1.spotify_data
   INNER JOIN task1.spotify_data2 ON task1.spotify_data.id = task1.spotify_data2.id;

-- LEFT JOIN:
-- Retrieve all rows from Table1 and matching rows from Table2
   SELECT *
   FROM task1.spotify_data
   LEFT JOIN task1.spotify_data2 ON task1.spotify_data.name = task1.spotify_data2.name;

-- RIGHT JOIN:
-- Retrieve all rows from Table2 and matching rows from Table1
   SELECT *
   FROM task1.spotify_data
   RIGHT JOIN task1.spotify_data2 ON task1.spotify_data.name = task1.spotify_data2.name;

-- CROSS JOIN
-- Create a Cartesian product of all rows from Table1 and Table2
   SELECT *
   FROM task1.spotify_data
   CROSS JOIN task1.spotify_data2;
----------------------------------------------------------------------------------------------------------------
-- TASK1 QUESTION#04
-- Data Transformation:
-- Use SQL functions to transform data, such as converting data types, handling NULL values, or
-- extracting substrings.
-- Employ aggregate functions for summarizing data (e.g., SUM, COUNT, AVG).

-- Convert data types:
-- Convert a string column to uppercase
   SELECT UPPER(name) AS uppercase_Name
   FROM task1.spotify_data;

-- Handling NULL values:
-- Replace NULL values in a column with a default value
   SELECT COALESCE(name, 'DefaultValue') AS transformed_column
   FROM task1.spotify_data;

-- Using aggregate functions - SUM::
-- Calculate the sum of a numeric column
   show columns from task1.spotify_data;   
   SELECT SUM(popularity) AS total_sum
   FROM task1.spotify_data;

-- Using aggregate functions - COUNT:
-- Count the number of rows in a table
   SELECT COUNT(*) AS row_count
   FROM task1.spotify_data;

-- Using aggregate functions - Average:
-- Calculate the average value of a numeric column
   SELECT AVG(popularity) AS average_value
   FROM task1.spotify_data;
---------------------------------------------------------------------------------------------------------------
-- TASK1 QUESTION#5
 -- Complex Queries and Analysis:
-- Write complex SQL queries involving subqueries, nested queries, or window functions for advanced
-- analysis.
-- Perform trend analysis, identify outliers, or calculate metrics using SQL.

-- Subquery for trend analysis:
-- Identify trends by calculating the percentage change in a numeric column
SELECT release_date,popularity,
       (popularity - LAG(popularity) OVER (ORDER BY release_date)) / LAG(popularity) OVER (ORDER BY release_date) * 100 AS percentage_change
FROM task1.spotify_data;

-- Nested query to calculate metrics:
-- Calculate average value per category and compare it with the overall average
SELECT name, AVG(popularity) AS category_avg,
       (SELECT AVG(popularity) FROM task1.spotify_data) AS overall_avg
FROM task1.spotify_data
GROUP BY name;

-- Window function for outlier detection:
-- Identify outliers using Z-score
WITH ZScoreCTE AS (
    SELECT name, popularity,
           (popularity - AVG(popularity) OVER ()) / STDDEV(popularity) OVER () AS z_score
    FROM task1.spotify_data
)
SELECT name, popularity
FROM ZScoreCTE
WHERE ABS(z_score) > 3;

-- Subquery with aggregation for cumulative sum:
-- Calculate cumulative sum over a partitioned column
SELECT year, popularity,
       SUM(popularity) OVER (PARTITION BY name ORDER BY year) AS cumulative_sum
FROM task1.spotify_data;

-- Window function for moving average:
-- Calculate a 3-day moving average for a numeric column
SELECT year, tempo,
       AVG(tempo) OVER (ORDER BY year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_average
FROM task1.spotify_data;



























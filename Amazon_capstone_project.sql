CREATE DATABASE amazon;                       -- creating new data base named as "amazon"
USE amazon;                                   -- use function is used to select respective database
DROP DATABASE amazon;                         -- Inorder to drop the database we can use drop function
DROP TABLE Sales_Data;                        -- Inorder to drop the table we can use drop function

-- Creating new table named as "Sales_data" under database "Amazon"

    
SELECT count(*) FROM Sales_Data;  -- checking the total rows count using count function

SELECT * FROM Sales_Data;    -- To select all the data from the table Sales_data

-- Data Wrangaling--

SELECT * FROM Sales_Data WHERE invoice_id IS NULL OR branch IS NULL OR city IS NULL OR customer_type OR gender IS NULL
OR product_line IS  NULL OR unit_price IS NULL OR quantity IS NULL or VAT IS NULL OR total IS NULL OR date_ IS NULL OR time_ IS NULL
OR payment_method IS NULL OR cogs OR gross_margin_percentage IS NULL OR gross_income IS NULL OR rating IS NULL;

select invoice_id from Sales_Data Where customer_type is null;

-- 2.1 Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. 
-- This will help answer the question on which part of the day most sales are made

alter table Sales_data   --  using alter function will help the table to drop the new column as "Time_of_day" by using drop function
drop Time_of_day;

alter table Sales_data  -- using alter function will help the table to drop the new column as "Day_name" by using drop function
drop Day_name;

alter table Sales_data   -- using alter function will help the table to drop the new column as "Month_name" by using drop function
drop Month_name;

SELECT time_ FROM Sales_data; --  selected the time_ column from sales_data

ALTER TABLE Sales_data               -- By using alter function we can add new column 
ADD COLUMN Time_of_day VARCHAR(20);    

select Time_of_day from Sales_data; -- To see the column is created or not

SET SQL_SAFE_UPDATES = 0;   -- To remove the safe_updates without getting any alerts

-- The "Time_of_day" column will be updated based on the time of day inferred from the time_ column.
-- In summary, this code categorizes the time of day (morning, afternoon, or evening) 
-- based on the hour portion of the timestamp in the time_ column

UPDATE Sales_data      
SET Time_of_day =
    CASE
        WHEN HOUR(Sales_data.time_) >=0 AND HOUR(Sales_data.time_) < 12 THEN "Morning"
        WHEN HOUR(Sales_data.time_) >=12 AND HOUR(time_) < 18 THEN "Afternoon"
        ELSE "Evening"
     END;         -
     
     
-- 2.2 Add a new column named dayname that contains the extracted days of the week on which the given 
-- transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

ALTER TABLE Sales_data     
ADD COLUMN Day_name VARCHAR(30);   -- using alter function adding new column "Day_name"

-- The Day_name column in the Sales_data table by formatting the day of the week 
-- (from the date_ column) as an abbreviated day name (e.g., “Mon” for Monday).

UPDATE Sales_data
SET day_name = Date_FORMAT(Sales_data.date_, '%a');  


-- 2.3 Add a new column named monthname that contains the extracted months of the year 
-- on which the given transaction took place (Jan, Feb, Mar). 
-- Help determine which month of the year has the most sales and profit.

ALTER TABLE Sales_data     -- the gvien code adds a new column named “Month_name” to the “Sales_data” table
ADD COLUMN Month_name VARCHAR(30);

 -- new column named “Month_name” to the “Sales_data” table, 
 -- where the values represent the abbreviated month names extracted from the “date_” column
UPDATE Sales_data    
SET Month_name = DATE_FORMAT(Sales_data.date_, '%b');

-- 1. What is the count of distinct cities in the dataset?

SELECT DISTINCT city FROM Sales_data;      -- Checking how many unique cities are present in the Sales_data
SELECT COUNT(DISTINCT(city)) as Distinct_count FROM Sales_data; -- Using count function we can check the city count in the Sales_data

-- 2. For each branch, what is the corresponding city?

SELECT branch, city FROM Sales_data;  -- checking the branch and city from "Sales_data"
SELECT DISTINCT branch FROM Sales_data; -- Checking the unique branch from "Sales_data"
SELECT DISTINCT city FROM Sales_data; -- Checking the unique city from "Sales_data"
SELECT DISTINCT branch, city FROM Sales_data; -- checking for each branch which is the corresponding city by using "Distinct" function

-- 3. What is the count of distinct product lines in the dataset?

SELECT product_line FROM Sales_data;     -- The code retrieves the product_line column from the Sales_data table
SELECT DISTINCT product_line FROM Sales_data;  --  To  retrieves the distinct values from the product_line column in the Sales_data table

SELECT COUNT(DISTINCT(product_line)) 
as count_distinct_product_line 
FROM Sales_data;       -- The code retrieves the count of distinct product lines from the Sales_data table

-- 4.Which payment method occurs most frequently?

SELECT payment_method, count(payment_method) 
FROM Sales_data WHERE payment_method = "Ewallet"; -- checking the count of how many "Ewallet" payments 

SELECT payment_method, count(payment_method) 
FROM Sales_data WHERE payment_method = "Cash"; -- checking the count of how many "Cash" payments 

SELECT payment_method, count(payment_method) 
FROM Sales_data WHERE payment_method = "Credit card"; -- checking the count of how many "Credit card" payments 

SELECT payment_method, count(payment_method) 
as payment_counts FROM Sales_data 
GROUP BY payment_method;  --  The code retrieves the count of occurrences for each payment method from the Sales_data table

-- 5. Which product line has the highest sales?

SELECT product_line, unit_price, quantity, cogs FROM Sales_data; -- To retrieve the data from selected columns from sales_data

SELECT product_line, sum(unit_price * quantity) 
as total_sales FROM Sales_data 
GROUP BY product_line ORDER BY total_sales DESC;

-- The code retrieves the total sales (sum of unit price multiplied by quantity) for each product line from the Sales_data table,
--  grouped by product line, and ordered by total sales in descending order which shows the top result by using Limit

SELECT product_line, sum(unit_price * quantity) 
as total_sales FROM Sales_data 
GROUP BY product_line ORDER BY total_sales DESC LIMIT 1;
-- OR --
SELECT product_line, SUM(cogs) AS total_sales 
FROM Sales_data GROUP BY product_line 
ORDER BY total_sales DESC LIMIT 1;  -- To get the total sales to sum the cogs from sales_data grouped by product line and ordered by descending order by using limit

-- 6 How much revenue is generated each month?

SELECT cogs, date_, total FROM Sales_data ORDER BY date_ asc; -- To retrieve the data from Sales_data

SELECT YEAR(date_) as year_ , month(date_) AS month_, MONTHNAME(date_) 
as month_name, sum(Total) AS Monthly_revenue FROM Sales_data 
GROUP BY YEAR(date_) ,month(date_),MONTHNAME(date_) ; -- To retrieve all the three months indiviual month monthly revenues

SELECT YEAR(date_) AS year_ , month(date_) AS month_, 
MONTHNAME(date_) as month_name, sum(total) AS Monthly_revenue 
FROM Sales_data  WHERE MONTH(date_) = 1 AND YEAR(date_) = 2019  
GROUP BY YEAR(date_), month(date_),MONTHNAME(date_) ; -- To retrieve indiviual month monthly revenues

-- 7. In which month did the cost of goods sold reach its peak?

SELECT date_, cogs FROM Sales_data;  -- To get data from date and cogs columns from Sales_data

SELECT YEAR(date_) as year_ , month(date_) AS month_, 
MONTHNAME(date_) as month_name, sum(cogs) 
as Monthly_cogs FROM Sales_data 
group by YEAR(date_),month(date_),MONTHNAME(date_) ;  -- To get the data from all the three months 

SELECT YEAR(date_) as year_ , month(date_) AS month_, MONTHNAME(date_) 
as month_name, sum(cogs) as Monthly_cogs FROM Sales_data 
group by YEAR(date_),month(date_),MONTHNAME(date_)
ORDER BY Monthly_cogs DESC LIMIT 1 ;  -- To get highest data from Sales_data

-- 8. Which product line generated the highest revenue?

SELECT product_line, total FROM Sales_data; -- To retrieve productline and total data from sales_data

SELECT product_line, sum(total) AS Total_revenue 
FROM Sales_data GROUP BY product_line 
ORDER BY Total_revenue DESC;   -- To retrieve different product_lines and their total_revenue

SELECT product_line, sum(total) AS Total_revenue 
FROM Sales_data GROUP BY product_line 
ORDER BY Total_revenue DESC LIMIT 1; -- To retrieve highest product_line and their total_revenue

-- 9.In which city was the highest revenue recorded?

 SELECT * FROM Sales_data; -- selecting the total columns from Sales_data
 
 SELECT city, sum(total) AS total_revenue 
 FROM Sales_data GROUP BY city 
 ORDER BY total_revenue desc; -- To retrieve the all the cities and their total revenues
 
  SELECT city, sum(total) AS total_revenue 
  FROM Sales_data GROUP BY city 
  ORDER BY total_revenue desc LIMIT 1; -- To retrieve the city and the highest revenue data
  
  -- 10.Which product line incurred the highest Value Added Tax?
  
  SELECT product_line, VAT FROM Sales_data; -- To retrieve product line and VAT data
  
  --  calculates the total VAT for each product line in the “Sales_data” table and 
  -- arranges the results in descending order based on the total VAT
  
  SELECT product_line, sum(VAT) as Total_VAT 
  FROM Sales_data GROUP BY product_line 
  ORDER BY Total_VAT DESC; 
  
 SELECT product_line, sum(VAT) as Total_VAT FROM Sales_data 
 GROUP BY product_line 
 ORDER BY Total_VAT DESC LIMIT 1; -- -- To know which product line is having the highest value added tax
 
 -- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad." 
 
 -- The below query calculates the performance of each product line based on whether its 
 -- gross income is above or below the average gross income in the “Sales_data” table
 SELECT product_line,
 CASE
     WHEN gross_income > (SELECT AVG(gross_income) FROM Sales_data) THEN "Good"
     ELSE "Bad"
END AS Performance_sales
FROM Sales_data;

-- 12 Identify the branch that exceeded the average number of products sold.

SELECT branch, Avg(cogs) AS avg_cogs_sold 
FROM Sales_data GROUP BY branch; -- To retrieve the branch and average of cogs from sales data

SELECT branch, sum(cogs) AS total_cogs_sold 
FROM Sales_data GROUP BY branch;  -- To retrieve the branch and sum of cogs from sales data

-- To calculate the total cost of goods sold (COGS) for each branch in the “Sales_data” table, 
-- the results by branch, and filters out branches 
-- where the COGS exceeds the average COGS across all branches.

SELECT branch, sum(cogs) as total_cogs_sold 
FROM Sales_data GROUP BY branch 
having sum(cogs) > (SELECT Avg(cogs) FROM Sales_data);

-- 13. Which product line is most frequently associated with each gender?

SELECT gender, product_line, count(*) as frequency 
FROM Sales_data GROUP BY gender, product_line 
ORDER BY gender, frequency DESC;

SELECT gender, product_line, count(*) as frequency FROM Sales_data 
GROUP BY gender, product_line ORDER BY gender, frequency DESC LIMIT 1; -- To get which product line is having more frequency from gender

SELECT gender, product_line, count(*) as frequency FROM Sales_data WHERE Gender ="Male"
GROUP BY gender, product_line ORDER BY gender, frequency DESC LIMIT 1;  -- To get the individual male data from sales data

SELECT gender, product_line, count(*) as frequency FROM Sales_data WHERE Gender ="Female"
GROUP BY gender, product_line ORDER BY gender, frequency DESC LIMIT 1; -- To get the individual female data from sales data

-- 14.Calculate the average rating for each product line.

SELECT product_line, avg(rating) as Avg_product_line 
FROM Sales_data GROUP BY product_line; -- To retrieve average rating for each product line using avg function and group by product line

-- 15. Count the sales occurrences for each time of day on every weekday.

SELECT Day_name, Time_of_day, count(invoice_id) as sales_count FROM Sales_data
WHERE Day_name NOT IN("Sat", "Sun") GROUP BY Day_name, Time_of_day
ORDER BY Day_name DESC, sales_count DESC;  -- To calculate the count of sales occurences for each time of day without weekends

-- 16. Identify the customer type contributing the highest revenue.
SELECT DISTINCT Customer_type  FROM Sales_data ; -- To get the unique customer_types from sales data

SELECT Customer_type, sum(total) as Highest_revenue 
FROM Sales_data GROUP BY customer_type 
ORDER BY Highest_revenue DESC; -- To calculate the customer types is contributing the highest revenue

SELECT Customer_type, sum(total) as Highest_revenue 
FROM Sales_data GROUP BY customer_type 
ORDER BY Highest_revenue DESC LIMIT 1; -- To calculate which customer types is contributing the highest revenue

-- 17. Determine the city with the highest VAT percentage.

-- The below query calculates the VAT percentage for each city based on the sum of VAT and total sales in the Sales_data table,
-- ordered in descending order of VAT percentage 
SELECT city, sum(VAT) / sum(TOTAL) * 100 as Highest_VAT_Percentage FROM Sales_data 
GROUP BY city ORDER BY  Highest_VAT_Percentage DESC ;

-- To get to know which city is having highest VAT percentage
SELECT city, sum(VAT) / sum(TOTAL) * 100 as Highest_VAT_Percentage FROM Sales_data 
GROUP BY city ORDER BY  Highest_VAT_Percentage DESC LIMIT 1;

-- 18 Identify the customer type with the highest VAT payments.

-- To retrieve the total VAT payments for each customer type in the Sales_data table, 
-- grouping them by customer type and ordering the results in descending order of VAT payments 

SELECT customer_type, sum(VAT) as Highest_VAT_payments 
FROM Sales_data GROUP BY customer_type 
ORDER BY Highest_VAT_payments DESC; 



-- 19 What is the count of distinct customer types in the dataset?

SELECT customer_type FROM Sales_data; 
SELECT DISTINCT customer_type FROM Sales_data; 


-- To retrieve the number of distinct customer types in the Sales_data table and 
-- provides the count for each type, ordered in descending order of occurrence 

SELECT DISTINCT customer_type, COUNT(DISTINCT (customer_type)) 
AS Count_customer_type FROM Sales_data 
GROUP BY customer_type 
ORDER BY Count_customer_type DESC ; 

SELECT  COUNT(DISTINCT (customer_type)) AS Count_customer_type 
FROM Sales_data  ORDER BY Count_customer_type DESC ;  -- To get to know the count of distinct customer types

-- 20 What is the count of distinct payment methods in the dataset?

-- The below query calculates the total number of distinct payment methods in the Sales_data table, 
-- grouping them by payment method and ordering the results based on the count of each payment method 

SELECT payment_method, COUNT(DISTINCT(Payment_method)) 
as Count_payment_method FROM Sales_data 
Group BY payment_method ORDER BY Count_payment_method; 

SELECT  COUNT(DISTINCT(Payment_method)) as Count_payment_method
FROM Sales_data ORDER BY Count_payment_method;  -- To get to know the count of distinct payment methods

-- 21.Which customer type occurs most frequently?

SELECT customer_type, count(*) 
FROM Sales_data 
GROUP BY Customer_type;  -- The query retrieves the count of each customer type

-- 22.Identify the customer type with the highest purchase frequency. 

SELECT customer_type , count(DISTINCT(invoice_id)) AS Highest_Purchase_frequency 
FROM Sales_data GROUP BY customer_type ORDER BY   Highest_Purchase_frequency DESC;

SELECT customer_type , count(DISTINCT(invoice_id)) 
AS Highest_Purchase_frequency FROM Sales_data 
GROUP BY customer_type 
ORDER BY Highest_Purchase_frequency DESC LIMIT 1;  -- It calulates the highest purchase frequency for each customer type based on distinct invoices

-- 23.Determine the predominant gender among customers.

SELECT gender, COUNT(*) AS customer_count FROM Sales_data 
GROUP BY gender ORDER BY customer_count DESC; 
 
SELECT gender, COUNT(*) AS customer_count 
FROM Sales_data GROUP BY gender 
ORDER BY customer_count DESC LIMIT 1;  -- It retrieves the total number of customers for each gender and ordering the results in descending order of customer count

-- 24 Examine the distribution of genders within each branch.

SELECT branch, 
      sum(CASE WHEN gender = "Male" THEN 1 ELSE 0 END) AS Male_count, -- using case statement when gender is male it will count
      sum(CASE WHEN gender = "Female" THEN 1 ELSE 0 END) AS Female_count --  -- using case statement when gender is female it will count
FROM Sales_data Group by branch;

SELECT branch, 
      sum(CASE WHEN gender = "Male" THEN 1 ELSE 0 END) AS Male_count, -- using case statement when gender is male it will count
      sum(CASE WHEN gender = "Female" THEN 1 ELSE 0 END) AS Female_count  -- using case statement when gender is female it will count
FROM Sales_data GROUP BY branch ORDER BY Male_count DESC LIMIT 1;  -- -- Grouped by branch and ordered by male results in descending order

SELECT branch, 
      sum(CASE WHEN gender = "Male" THEN 1 ELSE 0 END) AS Male_count,  -- using case statement when gender is male it will count
      sum(CASE WHEN gender = "Female" THEN 1 ELSE 0 END) AS Female_count -- using case statement when gender is female it will count
FROM Sales_data GROUP BY branch ORDER BY Female_count DESC LIMIT 1;  -- Grouped by branch and ordered by female results in descending order

-- 25 Identify the time of day when customers provide the most ratings.

SELECT time_of_day, count(rating) AS Most_ratings 
FROM Sales_data 
GROUP BY time_of_day 
ORDER BY Most_ratings DESC;   -- It provides the time of day along with the count of ratings for each time period

-- 26 Determine the time of day with the highest customer ratings for each branch.

SELECT branch ,time_of_day, count(rating) AS Highest_ratings 
FROM Sales_data        -- It calculates the highest number of ratings for each combination of branch and time of day in the Sales_data table,
GROUP BY branch, time_of_day  -- -- Grouping them by branch and time of day, and ordering the results by branch  
ORDER BY branch;   

-- 27 Identify the day of the week with the highest average ratings.

SELECT Day_name , AVG(rating) as Highest_average_ratings 
FROM Sales_data
GROUP BY Day_name 
ORDER BY Highest_average_ratings DESC;

SELECT Day_name , AVG(rating) as Highest_average_ratings 
FROM Sales_data   -- It retrieves the higesht average ratings for each day of the week
GROUP BY Day_name   -- Grouping by day name
ORDER BY Highest_average_ratings  -- ordering the results 
DESC LIMIT 1;     -- in descinding order of average ratings

-- 28 Determine the day of the week with the highest average ratings for each branch.

SELECT branch, Day_name, avg(rating) as average_ratings  -- It calculates the average rating of each combination of branch and day name
FROM Sales_data
GROUP BY branch, Day_name   -- grouping by branch and day name
ORDER BY branch, average_ratings  -- ordering the results by branch and average ratings in descending order
desc;

-- Conculsion

-- Product Analysis:
-- 1.There are 6 different product lines are available under table Sales data. Out of 6 products, Food and beverages generating highest revenue and Health and beauty generates lowest revenue.
-- 2.Also, Food and beverages generating highest sales.
-- 3.In relation to food and beverages are huge in demand generating more revenue and sales.

-- Sales Analysis: 
-- 1.Amongst all the 3 cities Naypyitaw city generates highest revenue and also having highest purchasing power in this location.
-- 2.Most of the customers are preferring the “Ewallet” payment method to make more digital transactions.
-- 3.The customer type “Member” is generating more revenues.


-- Customer Analysis:
-- 1.Based on the gender i.e Male and female, Female customers are more dominating than male customers in results for generating the income
-- 2.In relation to branch wise sales male customers under branch A and B are more compared to female customers and  female customers are more in branch C when compared to male customers
-- 3.Most of the ratings are more in "Afternon” time across all the branches and customers are actively giving ratings and most of the services in this time period.


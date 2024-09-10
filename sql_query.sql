drop table if exists retail_sales;

create table retail_sales(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(10),
	age int,
	category varchar(15),	
	quantity	int,
	price_per_unit float,	
	cogs float,
	total_sale float
);

alter table retail_sales rename column quantiy to "quantity";

select count(*) from retail_sales;

-- Data Cleaning

select *from retail_sales 
where transactions_id is null 
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
age is null
or
category is null
or
quantity is null
or 
price_per_unit is null
or
cogs is null
or
total_sale is null;

delete from retail_sales
where
transactions_id is null 
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
age is null
or
category is null
or
quantity is null
or 
price_per_unit is null
or
cogs is null
or
total_sale is null;

-- Data Exploration

-- Total Data:
SELECT * FROM RETAIL_SALES;

-- How many sales we have?
select count(*) as total_sales from retail_sales;

-- How many customes we have?
select count(distinct customer_id) as total_customer from retail_sales;

-- How many categories we have?
select count(distinct category) as categories from retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).


-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT *FROM RETAIL_SALES
WHERE SALE_DATE = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is equal to 4 in the month of Nov-2022.
SELECT * FROM RETAIL_SALES
WHERE CATEGORY = 'Clothing'
AND 
QUANTITY = 4
AND
SALE_DATE BETWEEN '2022-11-01' AND '2022-11-30';  --TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11' THIS WILL WORK TOO.

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT CATEGORY,SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY CATEGORY;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT CATEGORY,ROUND(AVG(AGE),2) AS AVG_AGE
FROM RETAIL_SALES
WHERE CATEGORY = 'Beauty'
GROUP BY CATEGORY;

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM  RETAIL_SALES 
WHERE TOTAL_SALE > 1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT CATEGORY,GENDER,COUNT(*) AS TOTAL_TRANSACTION FROM RETAIL_SALES
GROUP BY category,gender;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT year, month,avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT CUSTOMER_ID,SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY CUSTOMER_ID
ORDER BY CUSTOMER_ID DESC
LIMIT 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT CATEGORY,COUNT(DISTINCT CUSTOMER_ID) AS CNT_UNQ_CS
FROM RETAIL_SALES
GROUP BY CATEGORY;

-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
# Retail Sales Analysis

## Project Overview

This project analyzes retail sales data using SQL. It aims to uncover insights related to sales performance, customer behavior, and product trends.

## Table of Contents

- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Key Features](#key-features)
- [SQL Queries and Analysis](#sql-queries-and-analysis)
  - [Data Cleaning](#data-cleaning)
  - [Data Exploration](#data-exploration)
  - [Key Business Questions](#key-business-questions)
- [Tools Used](#tools-used)
- [How to Run the Project](#how-to-run-the-project)
- [Conclusion](#conclusion)

## Dataset

The dataset includes:

- **Transaction ID**: Unique identifier for each sale.
- **Sale Date**: Date of the transaction.
- **Sale Time**: Time of the transaction.
- **Customer ID**: Unique identifier for each customer.
- **Gender**: Customer's gender.
- **Age**: Age of the customer.
- **Category**: Product category.
- **Quantity**: Number of items sold.
- **Price per Unit**: Price of a single unit.
- **COGS**: Cost of goods sold.
- **Total Sale**: Total sales amount.

## Key Features

- Data cleaning and validation.
- Exploratory Data Analysis (EDA).
- Sales and customer insights.
- Time-based sales analysis.

## SQL Queries and Analysis

### Data Cleaning

To remove records with missing values:

```sql
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL 
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

### Data Exploration

- **Total number of sales**:

    ```sql
    SELECT COUNT(*) AS total_sales FROM retail_sales;
    ```

- **Total number of unique customers**:

    ```sql
    SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;
    ```

- **Number of unique product categories**:

    ```sql
    SELECT COUNT(DISTINCT category) AS categories FROM retail_sales;
    ```

### Key Business Questions

1. **Sales made on '2022-11-05'**:

    ```sql
    SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
    ```

2. **Transactions where the category is 'Clothing' and quantity sold is 4 in Nov-2022**:

    ```sql
    SELECT * FROM retail_sales 
    WHERE category = 'Clothing' 
    AND quantity = 4 
    AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
    ```

3. **Total sales for each category**:

    ```sql
    SELECT category, SUM(total_sale) AS total_sales 
    FROM retail_sales 
    GROUP BY category;
    ```

4. **Average age of customers in the 'Beauty' category**:

    ```sql
    SELECT ROUND(AVG(age), 2) AS avg_age 
    FROM retail_sales 
    WHERE category = 'Beauty';
    ```

5. **Transactions where the total sale is greater than 1000**:

    ```sql
    SELECT * FROM retail_sales 
    WHERE total_sale > 1000;
    ```

6. **Total number of transactions by each gender in each category**:

    ```sql
    SELECT category, gender, COUNT(*) AS total_transactions 
    FROM retail_sales 
    GROUP BY category, gender;
    ```

7. **Average sale for each month and best-selling month in each year**:

    ```sql
    SELECT year, month, avg_sale 
    FROM (    
        SELECT 
            EXTRACT(YEAR FROM sale_date) AS year,
            EXTRACT(MONTH FROM sale_date) AS month,
            AVG(total_sale) AS avg_sale,
            RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
        FROM retail_sales 
        GROUP BY year, month
    ) AS ranked_sales 
    WHERE rank = 1;
    ```

8. **Top 5 customers based on total sales**:

    ```sql
    SELECT customer_id, SUM(total_sale) AS total_sales 
    FROM retail_sales 
    GROUP BY customer_id 
    ORDER BY total_sales DESC 
    LIMIT 5;
    ```

9. **Number of unique customers who purchased items from each category**:

    ```sql
    SELECT category, COUNT(DISTINCT customer_id) AS unique_customers 
    FROM retail_sales 
    GROUP BY category;
    ```

10. **Number of orders by shift (Morning <12, Afternoon 12-17, Evening >17)**:

    ```sql
    WITH hourly_sale AS (
      SELECT *,
             CASE
                 WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
                 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
                 ELSE 'Evening'
             END AS shift
      FROM retail_sales
    )
    SELECT shift, COUNT(*) AS total_orders 
    FROM hourly_sale 
    GROUP BY shift;
    ```

## Tools Used

- **SQL**: For data manipulation and analysis.
- **Database**: To run queries and store data.

## How to Run the Project

1. Clone this repository:

    ```bash
    git clone https://github.com/utkarsh-us/retail-sales-analysis.git
    ```

2. Set up your SQL database and import the data.

3. Execute the SQL queries to analyze the data.

4. Review query results for insights.

## Conclusion

This project illustrates SQL-based retail sales analysis, providing insights into sales trends, customer behavior, and product performance.

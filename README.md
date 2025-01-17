# Walmart SQL Analysis

# Walmart Sales Data Analysis and SQL Queries

This project involves analyzing Walmart's sales dataset and performing various data preprocessing steps, including cleaning, transformation, and storage into a MySQL database. The dataset consists of sales records from Walmart stores, and the analysis focuses on cleaning the data, calculating total sales, and preparing it for further analysis.

## Table of Contents
- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Dataset](#dataset)
- [Data Cleaning and Transformation](#data-cleaning-and-transformation)
- [Database Integration](#database-integration)
- [SQL Queries](#sql-queries)
  - [General Overview Queries](#general-overview-queries)
  - [Aggregated Insights](#aggregated-insights)
- [Conclusion](#conclusion)


## Project Overview
The goal of this project is to clean and preprocess Walmart's sales data, which is available in CSV format. The data includes various fields such as `invoice_id`, `Branch`, `City`, `category`, `unit_price`, `quantity`, `payment_method`, and others. After cleaning and transforming the data, it is stored into a MySQL database for easy querying and analysis.

### Key Features:
- Clean and transformed dataset stored in a MySQL database
- SQL queries to extract meaningful business insights from the data
- Focus on payment methods, transaction volumes, profit margins, and more

## Prerequisites
To run this project, you need to have the following libraries installed:
- `pandas`
- `pymysql`
- `sqlalchemy`

You can install them using the following commands:
```bash
pip install pandas pymysql sqlalchemy
```

## Dataset
The dataset used in this project is a CSV file located at `S:/Walmart Project/walmart-10k-sales-datasets/Walmart.csv`. It contains sales records with the following columns:
- `invoice_id`: The unique identifier for each invoice
- `Branch`: The Walmart branch code
- `City`: The city where the branch is located
- `category`: The category of the product sold
- `unit_price`: The price of each unit of the product
- `quantity`: The quantity sold
- `date`: The date of the sale
- `time`: The time of the sale
- `payment_method`: The method used for payment (e.g., Ewallet, Cash, Credit Card)
- `rating`: The rating given for the purchase
- `profit_margin`: The profit margin of the sale

## Data Cleaning and Transformation
The following preprocessing steps are performed on the dataset:
1. **Duplicates Removal**: All duplicate records are removed from the dataset.
2. **Missing Values Handling**: Any rows with missing values in key columns like `unit_price` or `quantity` are dropped.
3. **Data Type Conversion**: The `unit_price` column is cleaned by removing the `$` sign and converting it to a float data type.
4. **Total Sales Calculation**: A new column `total` is added, which calculates the total sales amount by multiplying `unit_price` by `quantity`.

After cleaning, the dataset is saved as `Walmart_clean_data.csv`.

## Database Integration
The cleaned data is then inserted into a MySQL database for further analysis. The following steps are performed:
1. A MySQL connection is established using SQLAlchemy with the `create_engine` function.
2. The cleaned data is uploaded to a MySQL table named `walmart`.

### Example MySQL Connection:
```python
from sqlalchemy import create_engine

# MySQL connection details
engine_mysql = create_engine("mysql+pymysql://root:root@localhost:3306/walmart_db")

# Insert the cleaned data into the 'walmart' table
df.to_sql(name='walmart', con=engine_mysql, if_exists='append', index=False)
```

## SQL Queries

### General Overview Queries

- **Show all records from the `walmart` table**:
    ```sql
    SELECT * FROM walmart;
    ```
    **Explanation**: This query retrieves all records from the `walmart` table. It is useful for quickly inspecting the entire dataset.

- **Count the total number of records**:
    ```sql
    SELECT count(*) FROM walmart;
    ```
    **Explanation**: This query counts the total number of records (rows) in the `walmart` table. It's helpful to understand the dataset's size.

- **Show distinct payment methods**:
    ```sql
    SELECT DISTINCT payment_method FROM walmart;
    ```
    **Explanation**: This query retrieves a list of unique payment methods (e.g., Ewallet, Cash, Credit Card) used in the transactions. It helps identify all the payment methods used across Walmart branches.

- **Count the number of transactions per payment method**:
    ```sql
    SELECT 
        payment_method,
        count(*)
    FROM walmart
    GROUP BY payment_method;
    ```
    **Explanation**: This query groups transactions by payment method and counts the number of transactions for each. It provides insights into how many transactions were processed through each payment method.

- **Show distinct branches**:
    ```sql
    SELECT DISTINCT Branch FROM walmart;
    ```
    **Explanation**: This query retrieves a list of unique branches where sales occurred. It helps identify all Walmart locations included in the dataset.

- **Count the number of distinct branches**:
    ```sql
    SELECT 
        COUNT(DISTINCT Branch)
    FROM walmart;
    ```
    **Explanation**: This query counts how many distinct Walmart branches are represented in the dataset. It's helpful for understanding the geographic spread of the sales data.

- **Find the maximum quantity sold in any transaction**:
    ```sql
    SELECT 
        MAX(quantity)
    FROM walmart;
    ```
    **Explanation**: This query finds the maximum quantity of items sold in any single transaction. It helps identify the largest single sale in terms of quantity.

- **Find the minimum quantity sold in any transaction**:
    ```sql
    SELECT 
        MIN(quantity)
    FROM walmart;
    ```
    **Explanation**: This query finds the minimum quantity of items sold in any transaction. It helps identify the smallest sale in terms of quantity.

### Aggregated Insights

- **Find payment method and the number of transactions and quantity sold**:
    ```sql
    SELECT 
        payment_method,
        COUNT(*) AS no_of_payments,
        SUM(quantity) AS no_of_quantity_sold
    FROM walmart
    GROUP BY payment_method;
    ```
    **Explanation**: This query groups transactions by payment method and provides two metrics: the number of transactions and the total quantity of items sold through each payment method. This helps assess the usage of different payment methods and their impact on sales.

- **Identify the highest-rated category in each branch with the average rating**:
    ```sql
    SELECT 
        Branch,
        category,
        AVG(rating) AS average_rating,
        RANK() OVER (PARTITION BY Branch ORDER BY AVG(rating) DESC) AS Ranks
    FROM walmart
    GROUP BY 1, 2
    ORDER BY 1, 3 DESC;
    ```
    **Explanation**: This query calculates the average rating for each product category within each branch. The `RANK()` function assigns a rank to categories based on their average ratings within each branch. This query helps identify the top-rated categories at each branch.

- **Find the busiest day of the week for each branch based on transaction volume**:
    ```sql
    SELECT 
        Branch,
        DAYNAME(date) AS busiest_day,
        COUNT(invoice_id) AS transaction_count
    FROM walmart
    GROUP BY Branch, DAYNAME(date)
    ORDER BY Branch, transaction_count DESC;
    ```
    **Explanation**: This query groups transactions by branch and day of the week, counting the number of transactions for each. It helps determine which days are busiest for each branch.

- **Count the total number of items sold through each payment method**:
    ```sql
    SELECT 
        payment_method,
        SUM(quantity) AS total_items_sold
    FROM walmart
    GROUP BY payment_method
    ORDER BY total_items_sold DESC;
    ```
    **Explanation**: This query calculates the total number of items sold for each payment method. It helps assess the popularity of each payment method based on the volume of items sold.

- **Find the average, minimum, and maximum ratings for each category in each city**:
    ```sql
    SELECT 
        City,
        category,
        AVG(rating) AS average_rating,
        MIN(rating) AS minimum_rating,
        MAX(rating) AS maximum_rating
    FROM walmart
    GROUP BY City, category
    ORDER BY City, category;
    ```
    **Explanation**: This query calculates the average, minimum, and maximum ratings for each product category in each city. It provides insights into how products are rated in different cities.

- **Find the total profit for each category ranked from highest to lowest**:
    ```sql
    SELECT 
        category,
        SUM(profit_margin) AS total_profit
    FROM walmart
    GROUP BY category
    ORDER BY total_profit DESC;
    ```
    **Explanation**: This query calculates the total profit for each product category by summing the `profit_margin` values. It ranks the categories from highest to lowest profit, providing insights into the most profitable categories.

- **Identify the most frequently used payment method in each branch**:
    ```sql
    SELECT 
        Branch,
        payment_method,
        COUNT(*) AS usage_count
    FROM walmart
    GROUP BY Branch, payment_method
    ORDER BY Branch, usage_count DESC;
    ```
    **Explanation**: This query counts the usage of each payment method by branch, helping identify which payment method is most commonly used at each Walmart branch.

- **Count the number of transactions per shift (Morning, Afternoon, Evening) across branches**:
    ```sql
    SELECT 
        Branch,
        CASE
            WHEN HOUR(time) BETWEEN 6 AND 11 THEN 'Morning'
            WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN HOUR(time) BETWEEN 18 AND 23 THEN 'Evening'
        END AS shift,
        COUNT(*) AS transaction_count
    FROM walmart
    GROUP BY Branch, shift
    ORDER BY Branch, shift;
    ```
    **Explanation**: This query groups transactions by branch and shift (Morning, Afternoon, Evening) based on the time of day. It counts the number of transactions in each shift, helping to analyze transaction patterns throughout the day.

- **Identify branches that experienced the largest decrease in revenue compared to the previous year**:
    ```sql
    SELECT 
        r1.Branch,
        SUM(r1.total) AS revenue_current_year,
        SUM(r2.total) AS revenue_previous_year,
        (SUM(r1.total) - SUM(r2.total)) AS revenue_change
    FROM walmart r1
    JOIN walmart r2 ON r1.Branch = r2.Branch AND YEAR(r1.date) = YEAR(CURRENT_DATE) AND YEAR(r2.date) = YEAR(CURRENT_DATE) - 1
    GROUP BY r1.Branch
    HAVING revenue_change < 0
    ORDER BY revenue_change ASC;
    ```
    **Explanation**: This query compares the total revenue of each branch from the current year with the previous year's revenue. It helps identify branches that have experienced a decrease in revenue, which could indicate potential areas of concern or a need for further analysis.

## Conclusion

 It demonstrates how data cleaning, transformation, and analysis can be integrated to derive valuable insights from large sales datasets. By using SQL queries, we've successfully identified trends and metrics such as payment method preferences, top-rated categories, transaction volumes, and profit margins across Walmart branches. This type of analysis can be leveraged by businesses to make data-driven decisions, optimize operations, and improve customer experiences.

The integration of SQL queries with Python for data transformation and visualization in MySQL is essential for handling large datasets and ensuring efficient querying. The combination of these tools, along with the insights derived, can provide substantial support in business decision-making, especially for retail and sales-based organizations.

This project serves as a solid foundation for anyone interested in learning about data preprocessing, database integration, and SQL query optimization for business analytics.



---

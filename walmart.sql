use walmart_db;
-------
select * from walmart;
--------
select count(*) from walmart;
--------
select distinct payment_method from walmart;
--------
select 
       payment_method,
       count(*)
from walmart
group by payment_method;
--------
select distinct Branch from walmart;
---------
select 
count(distinct Branch)
from walmart;
--------
select 
max(quantity)
from walmart;
--------
select 
min(quantity)
from walmart;
--------
---- 1. Find different payment method and no.of.transactions , no.of.quantity sold
select 
      payment_method,
      count(*) as no_of_payments,
      sum(quantity) as no_of_quantity_sold
from walmart
group by payment_method;
------
---- 2. Identify the highest rated category in each branch,displaying the branch,category and average rating
select 
      Branch,
      category,
      avg(rating) as average_rating,
      rank() over (partition by Branch order by avg(rating) desc) as Ranks
from walmart
group by 1 , 2
order by 1 , 3 desc;    
------
---- 3.What is the busiest day of the week for each branch based on transaction volume?
SELECT 
    Branch,
    DAYNAME(date) AS busiest_day,
    COUNT(invoice_id) AS transaction_count
FROM walmart
GROUP BY Branch, DAYNAME(date)
ORDER BY Branch, transaction_count DESC;
----
---- 4.How many items were sold through each payment method?
SELECT 
    payment_method,
    SUM(quantity) AS total_items_sold
FROM walmart
GROUP BY payment_method
ORDER BY total_items_sold DESC;
------
---- 5.What are the average, minimum, and maximum ratings for each category in each city?
SELECT 
    City,
    category,
    AVG(rating) AS average_rating,
    MIN(rating) AS minimum_rating,
    MAX(rating) AS maximum_rating
FROM walmart
GROUP BY City, category
ORDER BY City, category;
------
---- 6. What is the total profit for each category, ranked from highest to lowest?
SELECT 
    category,
    SUM(profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;
----
---- 7.What is the most frequently used payment method in each branch?
SELECT 
    Branch,
    payment_method,
    COUNT(*) AS usage_count
FROM walmart
GROUP BY Branch, payment_method
ORDER BY Branch, usage_count DESC;
-----
---- 8.How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?
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
-----
---- 9. Which branches experienced the largest decrease in revenue compared to the previous year?
SELECT 
    r1.Branch,
    SUM(r1.total) AS revenue_current_year,
    SUM(r2.total) AS revenue_previous_year,
    (SUM(r1.total) - SUM(r2.total)) AS revenue_difference
FROM walmart r1
JOIN walmart r2 
    ON r1.Branch = r2.Branch 
    AND YEAR(r1.date) = YEAR(r2.date) + 1
GROUP BY r1.Branch
HAVING revenue_difference < 0
ORDER BY revenue_difference desc;
-----















      
      




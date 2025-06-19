create database project_1;
create table retail_sales(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,	
	sale_time TIME,	
	customer_id	INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(25),	
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);
select count(*)from retail_sales;
select*from retail_sales;

select*from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

--data cleaning
delete from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

--data exploration
--how many sales we have?
select count(*) as total_sales from retail_sales;

--how many unique customers we have?
select count(distinct customer_id) as total_sales from retail_sales;

--3. Data Analysis & Findings
--The following SQL queries were developed to answer specific business questions:

--Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select*from retail_sales where sale_date='2022-11-05'; 

--Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select*from retail_sales where category='Clothing'
and sale_date>='2022-11-01'
and sale_date='2022-12-01'
and quantiy>=4;

--Q3.Write a SQL query to calculate the total sales (total_sale) for each category.:
select 
	category,
sum(total_sale) as net_sales,
count(*) as total_orders
from retail_sales
group by category
order by category;

--Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select*from retail_sales where total_sale>'1000';

--Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY category;

--Q7.Write a SQL query to find the top 5 customers based on the highest total sales:
SELECT 
  customer_id,
  SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--Q8. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
  year,
  month,
  avg_sale
FROM (
  SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER (
      PARTITION BY EXTRACT(YEAR FROM sale_date)
      ORDER BY AVG(total_sale) DESC
    ) AS month_rank
  FROM retail_sales
  GROUP BY year, month
) AS ranked_months
WHERE month_rank = 1;

--Q9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

--Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
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
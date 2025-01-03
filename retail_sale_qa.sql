create database retail_project;
use retail_project;
create table retail_sales(
	transactions_id int primary key,
    sale_date date,
    sale_time time,
    customer_id int,
    gender varchar(30),
    age int,
    category varchar(50),
    quantiy int,
    price_per_unit float,
    cogs float,
    total_sale float

);

select * from retail_sales;
select count(*) from retail_sales;
select * from retail_sales where cogs is null;

-- How many sales we have?
select count(*) as total_sales from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id) as total_customers from retail_sales;

-- How many unique category we have?
select count(distinct category) as num_category from retail_sales;
select distinct category as num_category from retail_sales;

-- 1. write a query to retrieve all columns for sales made on '2022-11-05'
select count(*) from retail_sales where sale_date like '2022-11-05';

select * from retail_sales where sale_date = '2022-11-05';

-- 2. write a query to retrieve all transactions where the category is clothing and quantity
-- sold is more than 4 in the month of nov-2022?
SELECT * 
FROM retail_sales
WHERE category = 'Clothing' 
  AND sale_date >= DATE '2022-11-01' 
  AND sale_date < DATE '2022-12-01'
  AND quantiy > 3;
  
-- Write a query to calculate the total Sales for each category?
select category, sum(total_sale) as net_total,
count(*) as total_orders
from retail_sales
group by category;

-- write a query to find avg age of the customer who purchased item Beauty category?
select round(avg(age),2) as avg_Age_beauty from retail_sales
where category='Beauty';

-- write a qurey to find all the transaction where the total_sales is greater than 1000?
select * from retail_sales
where total_sale>1000;

-- write a query to find total number of transcation made by each gender in each category?
select category, gender,  count(total_sale)
from retail_sales
group by category, gender
order by 1;

-- write a query to calculate the average sales for each month find the best selling month for each year
select
year(sale_date) as year,
month(sale_date) as month,
round(avg(total_sale),2) as avg_sales
from retail_sales
group by year, month
order by year, avg_sales desc;

SELECT
    year,
    month,
    avg_sales,
    RANK() OVER (PARTITION BY year ORDER BY avg_sales DESC) AS rank
FROM (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sales
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS subquery;

-- write a sql query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sale
from retail_sales group by customer_id order by total_sale desc limit 5;

-- write a sql query to find the number of unique customer who purchased items from each category
select count(distinct customer_id), category
from retail_sales
group by category;

-- write a query to create a each shift and number of orders 
-- ex: norning <=12, afternoon btw 12 & 17, eve >17?

SELECT shift, 
       COUNT(*) AS total_orders
FROM (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
) AS hourly_sale
GROUP BY shift;

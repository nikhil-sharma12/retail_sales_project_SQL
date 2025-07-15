create database sql_project_1;

create table retail_sales (
				transactions_id  int primary key,
				sale_date date	,
				sale_time time,
				customer_id	int,
				gender	varchar (15),
				age	int,
				category varchar (15),
				quantiy	int,
				price_per_unit	float,
				cogs	float,
				total_sale float
);
select * from retail_sales;

select count(*) from retail_sales;

select * from retail_sales
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
    quantiy is null
    or 
    price_per_unit is null
    or 
    cogs is null
    or 
    total_sale is null;

-- total sales we have?
select sum(total_sale) as total_sale from retail_sales;
    
-- how many unique customers we have?

select count(distinct customer_id) as unique_customers from retail_sales;

-- unique category?
select count(distinct category) as unique_category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales
where category = 'clothing' 
	and DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
	and quantiy >= 4 ;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sales from retail_sales
group by category;
	-- instead of mentioning "group by category;", we can also write it as "group by 1;" which has the same meaning. here '1' indicate to 'category'

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, round(avg(age),2) as mean_age from retail_sales
where category = 'beauty';
	-- for upto 2 decimals, we can round off the mean age by round (), like round(avg(age),2)

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale >= 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender, count(transactions_id) as net_transactions from retail_sales
group by category,gender
order by 1 ;	-- here 1 reference to category.

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year, month, avg_sale
from
(
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    round(AVG(total_sale),2) AS avg_sale,
	RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_in_year
FROM retail_sales
group by 1, 2
) as t1
where rank_in_year = 1;
-- order by 1, 3 desc; ,where -- 3 for avg(total_sale)

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) as total_sales from retail_sales
group by 1
order by 2 desc 
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category , count(distinct customer_id) as unique_customers from retail_sales
group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
    CASE
        WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) > 12 AND HOUR(sale_time) <= 17 THEN  'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY shift
ORDER BY FIELD(shift, 'Morning', 'Afternoon', 'Evening');

-- Q.11 Which category has the highest average order value?
SELECT 
    category,
    ROUND(AVG(total_sale), 2) AS avg_order_value
FROM 
    retail_sales
GROUP BY 
    category
ORDER BY 
    avg_order_value DESC
LIMIT 1;

-- Q.12 Find the percentage contribution of each category to total revenue?
select category, sum(total_sale) as total_revenue,
	   round((sum(total_sale)/ (select sum(total_sale) from retail_sales)) *100, 2) as percentage_contribution
       from retail_sales
group by category
order by percentage_contribution desc;

-- Q.13 Find the month-over-month growth rate in sales.
-- Growth Rate= ((Current Month Sales - Previous Month Sales) / PreviousMonthSales) *100

SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    SUM(total_sale) AS monthly_sales,
    LAG(SUM(total_sale)) OVER (ORDER BY DATE_FORMAT(sale_date, '%Y-%m')) AS previous_month_sales,
    ROUND(
        (SUM(total_sale) - LAG(SUM(total_sale)) OVER (ORDER BY DATE_FORMAT(sale_date, '%Y-%m')))
        / LAG(SUM(total_sale)) OVER (ORDER BY DATE_FORMAT(sale_date, '%Y-%m')) * 100,
        2
    ) AS growth_rate_percent
FROM 
    retail_sales
GROUP BY 
    DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY 
    sale_month;

-- The LAG() function is a window function in SQL that lets you access data from the previous row within a result set, without using a self-join or subquery.

-- Q.14 List the top category by total sale amount each year?
select sale_year, category, total_sales 
from
(
select 
	year(sale_date) as sale_year, 
    category, 
    sum(total_sale) as total_sales, 
    rank() over (partition by year(sale_date) order by sum(total_sale) desc) as category_rank
    from retail_sales
group by 1,2
)  as ranked_categories
where category_rank = 1		--  filters to only the top category per year
order by 1;

-- Q.15 Find the first and last purchase date for each customer?
select 
    customer_id,
    min(sale_date) as first_purchase_date,
    max(sale_date) as last_purchase_date from retail_sales
group by 1
order by 1;

-- Q.16 Find the day with the highest number of orders?
select sale_date, count(quantiy) from retail_sales
group by 1
order by 2 desc;


-- FINISH --

 
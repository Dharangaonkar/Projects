create database walmartsales;

create table if not exists  sales (
invoice_id varchar (30) not null primary key,
branch varchar (5) not null,
city varchar (30) not null,
customer_type varchar (30) not null,
gender varchar (10) not null,
product_line varchar(100) not null,
unit_price decimal (10, 2) not null,
quantity Int not null,
VAT float (6, 4) not null,
total decimal (12, 4) not null,
date datetime not null,
time time not null,
payment_method varchar (15) not null,
cogs decimal (10, 2) not null,
gross_margin_pct float (11, 9),
gross_income decimal (12, 4) not null,
rating float (2, 1)
);


select 
 time,
(case
    when time between '00:00:00' and '12:00:00' then 'morning'
    when time between '12:01:00' and "16:00:00" then 'afternoon'
    else 'evening'
    end ) as time_of_day 
from sales;

Alter table sales add column time_of_day varchar (20);

update sales 
set time_of_day = ( 
case
    when time between "00:00:00" and "12:00:00" then "morning"
    when time between "12:01:00" and "16:00:00" then "afternoon"
    else " evening"
    end 
    );
    
    
    --- day name
    
    Select
    date,
    dayname(date) as day_name
    from sales;
    
Alter table sales add column day_name varchar (10);

update sales 
set day_name = dayname(date);

Select 
date,
monthname(date) as month_name
from sales;

Alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);

    ------------------------------------------------ 
    ------------------- Generic--------------
    
    Select 
     distinct city 
     from sales;
     
     Select 
     distinct city, 
     branch 
     from sales;
     
     ---------------------------------------------------------
     ----------------------- product------------------
     
---------------- unique product lines--------------
Select
Count(distinct product_line)
from sales;

--------------------------- most common payment method---------------
select 
Payment_method,
 Count(payment_method) as cnt
  from sales
  group by Payment_method
  order by cnt desc;
  
  ---------------------- product line-----------------
select 
product_line,
 Count(product_line) as PLCnt
  from sales
  group by product_line
  order by PLCnt desc;

----------------------- total revenue------------------

select 
month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;  


------------------------- COGS-------------------

Select  month_name as month,
 sum(cogs) as cogs
 from sales
 group by month
order by cogs desc;

--------------- product line with largest revenue----------------
select product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

--- city with largest revenue-----------

Select branch,
city,
sum(total)as total_revenue
from sales
group by branch, city
order by total_revenue desc;

-------- product line with largest VAT-------

Select product_line,
AVG(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

--------------- Which branch sole more products than avg product sold--------

Select branch, 
sum(quantity) as qty
from sales 
group by branch 
Having sum(quantity)>(select avg (quantity) from sales);

-------------------- common product line by gender----------------
Select 
    gender,
    product_line,
    count(gender) as total_cnt
    from sales
	group by gender, product_line
    order by total_cnt desc;
    
-------------- Avg rating of each product line----------
Select
round(avg(rating),2) as avg_rating,
product_line
from sales
group by product_line
order by avg_rating desc
;

------------------- Number of sales made in each time of the day  per weekday------------- 

select 
time_of_day, count(*) as total_sales
from sales
where day_name = "sunday"
group by time_of_day
order by total_sales desc;  

------------------------- which of the customer types brings most revenue----------------

Select customer_type, 
 sum(total) as total_rev
 from sales
 group by customer_type
 order by total_rev desc;
---------------------------------
------------------------- City with largest VAT--------------------

Select
city,
Avg(VAT) as VAT
from sales
group by city
order by VAT desc;

--------------------------------- Customer type pays the more VAT--------------

Select 
customer_type, 
Sum(VAT) as VAT
from sales 
group by customer_type
order by VAT desc;

--------------- unique customer types------------
Select 
distinct customer_type
from sales;

----------------- unique payment method types----------
Select 
distinct Payment_method
from sales;

------------ customer type buys the more--------------

Select
 customer_type,
 count(*) as cust_cnt
 from sales
 group by customer_type;
 
 ---------------------- Gender of most of the customers-------------
 
 select gender,
 count(*) as gender_cnt 
 from sales
 group by gender
 order by gender_cnt desc;

------------- Gender distribution per branch------------
 select gender,
 count(*) as gender_cnt 
 from sales
 where branch = 'c'
 group by gender
 order by gender_cnt desc;
 
 ------------ Which time of the day do customers give rating-----------
 Select 
 time_of_day, 
 Avg(rating) as avg_rating
 from sales
 group by time_of_day
 order by avg_rating desc;
 
 ----------------- Which time of the day do customers give rating per branch--------------
 Select 
 time_of_day, 
 Avg(rating) as avg_rating
 from sales
 where branch = 'c'
 group by time_of_day
 order by avg_rating desc;
 
 -------------- which day of the week has best avg rating----------
 
 Select
 day_name,
 avg(rating)as avg_rating
 from sales
 group by day_name
 order by avg_rating desc;
 
 Select
 day_name,
 avg(rating)as avg_rating
 from sales
 where branch = 'a'
 group by day_name
 order by avg_rating desc;

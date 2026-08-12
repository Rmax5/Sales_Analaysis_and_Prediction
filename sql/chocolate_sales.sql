select * from products;
select * from customers;
select * from calendar;
select * from stores;
select * from sales;

ALTER TABLE calendar
ALTER COLUMN date
TYPE DATE
USING date::DATE;

select distinct city,country from stores
order by city,country;
--The output indicates there is error in the data, where the cities and the countries are not matching

--Finding the details of order with maximum profit using Subquery
select max(profit) as Max_Profit from sales;

select s.product_id,p.product_name,p.brand,p.category,st.store_name,st.city,c.age as Customers_Age,c.gender,
st.store_type,s.profit as Profit from sales as s
inner join products as p on p.product_id=s.product_id
inner join stores as st on st.store_id=s.store_id
inner join customers as c on c.customer_id=s.customer_id
where s.profit = (select max(profit) from sales);

--Profit Margin from the total sales datset
select round((sum(profit)*100/sum(revenue))::Numeric,2) as profit_margin from sales;

--profit margin per year and month
create view  p_margin as (
with p_margin_per_year as(
select ca.year,round((sum(profit)*100/sum(revenue))::Numeric,2) as profit_margin_per_year from sales as s
inner join calendar as ca on ca.date=s.order_date
group by ca.year
)
select ca.year,ca.month,round((sum(profit)*100/sum(revenue))::Numeric,2) as profit_margin_per_month,profit_margin_per_year
from sales as s
inner join calendar as ca on ca.date=s.order_date
cross join p_margin_per_year
group by ca.year,ca.month,profit_margin_per_year);

--grouping and analysing the sales based on the product_type,store_details,customer_details
--calculating the quantity based on product,store, and customer

--product Analysis
create view product_sales as(
select p.product_name,p.brand,p.category,sum(quantity) as Total_Quantity,round(sum(revenue)::numeric,2) as Total_Revenue,
round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join products as p on p.product_id=s.product_id
group by s.product_id,p.product_name,p.brand,p.category
order by total_quantity desc);

create view product_sales as(
select ca.year,ca.month,st.country,p.product_name,p.brand,p.category,sum(quantity) as Total_Quantity,round(sum(revenue)::numeric,2) as Total_Revenue,
round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join products as p on p.product_id=s.product_id
inner join calendar as ca on ca.date=s.order_date
inner join stores as st on st.store_id=s.store_id
group by ca.year,ca.month,st.country,s.product_id,p.product_name,p.brand,p.category
order by total_quantity desc);

select p.product_name,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_profit
from sales as s
inner join products as p on p.product_id=s.product_id
group by p.product_name
order by total_quantity desc;

select p.brand,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_profit
from sales as s
inner join products as p on p.product_id=s.product_id
group by p.brand
order by total_quantity desc;

select p.category,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_profit
from sales as s
inner join products as p on p.product_id=s.product_id
group by p.category
order by total_quantity desc;

--Sorting the sales based on the cocoa_percent
create view cocao_content as (
select case when p.cocoa_percent>=80 then 'High Cocoa content'
            when p.cocoa_percent>=60 then 'Moderate Cocoa content'
			else 'Low Cocoa content'
			end as Cocao_content
,sum(s.quantity) as Total_Quantity,round(sum(revenue)::numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join products as p on p.product_id=s.product_id
group by cocao_content
order by total_quantity);

select p.brand,sum(s.revenue) as Total_Revenue_generated,
Rank() over(order by sum(s.revenue) desc) as Rank
from sales as s
inner join products as p on p.product_id=s.product_id
group by p.brand
order by Total_Revenue_generated desc;

--Finding the stores have Average Revenue more than overall Average Revenue
select p.brand, round(avg(s.revenue)::numeric,2) as Total_Revenue from sales as s
inner join products as p on p.product_id=s.product_id
group by p.brand
having avg(s.revenue)>(select avg(revenue) from sales);



--Store Analysis
create view store_sales_country as(
select st.store_id,st.store_name,st.country,st.store_type,sum(quantity) as Total_Quantity,
round(sum(revenue)::Numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join stores as st on st.store_id=s.store_id
group by  st.store_id,st.store_name,st.city,st.country,st.store_type
order by total_quantity desc);

select * from store_sales;

create view store_sales_city as(
select st.store_id,st.store_name,st.city,st.store_type,sum(quantity) as Total_Quantity,
round(sum(revenue)::Numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join stores as st on st.store_id=s.store_id
group by  st.store_id,st.store_name,st.city,st.store_type
order by total_quantity desc);

select st.country,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_revenue,round(sum(profit)::numeric,2) as Total_profit 
from sales as s
inner join stores as st on st.store_id=s.store_id
group by st.country
order by Total_Quantity Desc;

select st.city,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_revenue,round(sum(profit)::numeric,2) as Total_profit
from sales as s
inner join stores as st on st.store_id=s.store_id
group by st.city
order by Total_Quantity Desc;

select st.store_type,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_revenue,round(sum(profit)::numeric,2) as Total_profit
from sales as s
inner join stores as st on st.store_id=s.store_id
group by st.store_type
order by Total_Quantity Desc;


select st.store_name,st.country,st.store_type,sum(quantity) as Total_Quantity, 
round(sum(revenue)::Numeric,2) as Total_Revenue, round(sum(profit)::numeric,2) as Total_Profit,
round(sum(revenue)::numeric,2) as Total_Revenue_Generated from sales as s
inner join stores as st on st.store_id=s.store_id
group by st.store_name,st.country,st.store_type
order by total_quantity;


--Ranking the cities and countries based on the Total_revenue generated 
select st.country,round(sum(revenue)::numeric,2) as Total_Revenue_Generated, rank() over(order by sum(s.revenue) desc) as Country_Rank
from sales as s
inner join stores as st on st.store_id=s.store_id
group by st.country;

select st.city,round(sum(revenue)::numeric,2) as Total_Revenue_Generated, rank() over(order by sum(s.revenue) desc) as City_Rank
from sales as s
inner join stores as st on st.store_id=s.store_id
group by st.city;

--Ranking the store type based on the Total_revenue generated country wise
select st.country,st.store_type,round(sum(revenue)::numeric,2) as Total_Revenue_Generated, rank() over(partition by st.country order by sum(s.revenue) desc) as City_Rank
from sales as s
inner join stores as st on st.store_id=s.store_id
group by st.country,st.store_type;

select st.store_name,sum(s.revenue) as Total_Revenue_generated from sales as s
inner join stores as st on st.store_id=s.store_id
group by st.store_name
order by Total_Revenue_generated desc
limit 10;
--Finding the sales at a particular store type with revenue condition 
with avg_revenue as
(select Round(avg(revenue)::Numeric,2) as avg_revenue from sales as s
inner join stores as st on st.store_id=s.store_id
where st.store_type='Airport')
select st.store_type,s.revenue,avg_revenue as Avg_Revenue,s.profit from sales as s
inner join stores as st on st.store_id=s.store_id
cross join avg_revenue 
where st.store_type='Airport'and s.revenue>(avg_revenue);

--Finding the Cities with Average Revenue more than Overall Average Revenue
select st.city, round(avg(s.revenue)::numeric,2) as Total_Revenue from sales as s
inner join stores as st on st.store_id=s.store_id
group by st.city
having avg(s.revenue)>(select avg(revenue) from sales);



--Customer Analysis
create view customer_sales as(
select c.customer_id,c.age,c.gender,c.loyalty_member,sum(quantity) as Total_Quantity,
round(sum(revenue)::Numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join customers as c on c.customer_id=s.customer_id
group by  c.customer_id,c.age,c.gender,c.loyalty_member
order by total_quantity desc);
--Finding the top top 10 customers based on the total revenue generated

select c.age,c.gender,sum(s.revenue) as Total_Revenue_generated from sales as s
inner join customers as c on c.customer_id=s.customer_id
group by c.customer_id,c.age,c.gender
order by Total_Revenue_generated desc
limit 10;

--Finding the discount got by the customer based on the loyalty scheme 
select c.loyalty_member,sum(s.discount) as Total_discount from sales as s
inner join customers as c on c.customer_id=s.customer_id
group by c.loyalty_member;


create view age_category_sales as(
select ca.year,st.country,case when c.age<=25 then 'young'
                  when c.age<=45 then 'Adult'
                  when c.age<=60 then 'Middle Age'
                  else 'Senior'
				  end as Age_category
,sum(quantity) as Total_Quantity,round(sum(revenue)::numeric,2) as Total_Revenue,round(avg(discount)::numeric,4) as Avg_discount_given,
round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join customers as c on c.customer_id=s.customer_id
inner join stores as st on st.store_id=s.store_id
inner join calendar as ca on ca.date=s.order_date
group by st.country,st.city,Age_category);



--Analysis by Calendar
create view year_sales as(
select ca.year,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join calendar as ca on ca.date=s.order_date
group by ca.year);
select * from year_sales;


select ca.year,ca.month,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join calendar as ca on ca.date=s.order_date
group by ca.year,ca.month;

create view monthly_sales as( 
select ca.year,ca.month,to_char(ca.date,'Month') as Month_name,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_Revenue,
round(sum(profit)::numeric,2) as Total_profit from sales as s
inner join calendar as ca on ca.date=s.order_date
group by ca.year,ca.month, Month_name
order by ca.year asc);
select * from monthly_sales;

create view daywise_sales as(
select to_char(date,'Day') as Day_Name ,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_Revenue,
round(sum(profit)::numeric,2) as Total_profit from sales as s
inner join calendar as ca on ca.date=s.order_date
group by Day_Name);
select * from daywise_sales
order by total_revenue desc;

create view weekend_category_sales as(
select ca.year,st.country,case when ca.day_of_week<=5 then 'Weekend'
                else 'Weekday'
				end as day_in_week
,sum(quantity) as Total_Quantity,round(sum(revenue)::numeric,2) as Total_Revenue,round(sum(profit)::numeric,2) as Total_Profit from sales as s
inner join calendar as ca on ca.date=s.order_date
inner join stores as st on st.store_id=s.store_id
group by st.country,st.city,day_in_week,ca.year);	

--Using  CTE and  Windows function to find the rolling Revenue
with monthly_revenue as(
      select ca.year,ca.month,sum(quantity) as Total_Quantity,round(sum(revenue)::Numeric,2) as Total_Revenue
 from sales as s
inner join calendar as ca on ca.date=s.order_date
group by ca.year,ca.month
)
select m.year,m.month,Total_quantity,Total_Revenue,sum(Total_Revenue) over(partition by m.year order by m.month) as Rolling_Revenue 
from monthly_revenue as m;



--Finding the growth rate per month, for each country and brand
create view Monthly_revenue_growth as(
with monthly_sales as(
 select ca.year,ca.month,to_char(ca.date,'Month') as Month_name,st.country,
 p.brand,
 round(sum(revenue)::Numeric,2) as Total_Revenue
 from sales as s
inner join calendar as ca on ca.date=s.order_date
inner join stores as st on st.store_id=s.store_id
inner join products as p on p.product_id=s.product_id
group by ca.year,ca.month,Month_name,st.country,p.brand
)
select year,month,Month_name,country,brand,total_revenue,
lag(total_revenue) over(partition by year,country,brand order by month)as Previous_month_revenue,
round((total_revenue-lag(total_revenue) over(partition by year ,country,brand order by month))*100/
                           (lag(total_revenue) over(partition by year,country,brand order by month))::numeric,2) 
as Growth_rate_per_month from monthly_sales);

select * from monthly_revenue_growth;





















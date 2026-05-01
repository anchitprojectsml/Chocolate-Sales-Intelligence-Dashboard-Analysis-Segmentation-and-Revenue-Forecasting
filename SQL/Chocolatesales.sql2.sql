

-- Creating table
CREATE TABLE sales2 (
    order_id TEXT,
    order_date DATE,
    product_id TEXT,
    store_id TEXT,
    customer_id TEXT,
    quantity INT,
    unit_price FLOAT,
    discount FLOAT,
    revenue FLOAT,
    cost FLOAT,
    profit FLOAT,
    product_name TEXT,
    brand TEXT,
    category TEXT,
    cocoa_percent FLOAT,
    weight_g FLOAT,
    age INT,
    gender TEXT,
    loyalty_member TEXT,
    join_date DATE,
    store_name TEXT,
    city TEXT,
    country TEXT,
    store_type TEXT,
    date DATE,
    year INT,
    month INT,
    day INT,
    week INT,
    day_of_week TEXT,
    age_group TEXT,
    cluster INT
);

-- After Successfully Importing Data we are cheking data is fully loaded or not 

select * from sales2 limit 10;


-- Basic Metrics
-- TOTAL REVENUE 
select Round(sum(revenue)::numeric,2) as total_revenue
From sales2;


-- TOTAL PROFIT
select Round(sum(profit)::numeric, 2) as total_profit
From sales2;

-- Product Analysis
-- Revenue By Category
Select category,
       Round(Sum(revenue)::numeric,2) as revenue
From sales2
Group by category
Order by revenue Desc;

--TOP 10 CITIES
Select city,
       Round(Sum(revenue)::numeric,2) as revenue
From sales2
Group By city
Order By revenue Desc
Limit 10;

-- Customer Analysis
-- Revenue By Age Group (Handled Missing Values)
Select
    Coalesce(age_group, 'Unknown') as age_group,
    Round(Sum(revenue)::numeric, 2) as revenue
From sales2
Group by Coalesce(age_group, 'Unknown')
Order by revenue Desc;

--Location Analysis
-- Profit Margin By Category
Select category,
       Round((Sum(profit)/Sum(revenue)*100)::numeric, 2) as profit_margin
From sales2
Group By category;

-- Top Store Per Country
Select *
From (
    Select country,
           store_name,
           Round(Sum(profit)::numeric,2) as profit,
           Rank() Over(Partition By country Order By Sum(profit) Desc) As rank
    From sales2
    Group By country, store_name
) t
Where rank = 1;

-- MONTHLY REVENUE TREND

Select year, month,
       Round(Sum(revenue)::numeric,2) as revenue
From sales2
Group By year, month
Order By year, month;

-- Business Analysis
-- Discount Impact Analysis
Select 
    Case 
        When discount = 0 Then 'No Discount'
        Else 'Discount Applied'
    End As discount_type,
    Round(Avg(revenue)::numeric,2) As avg_revenue,
    ROUND(Avg(profit)::numeric,2) As avg_profit
From sales2
Group By discount_type;

-- Repeat Customers Rentention
Select customer_id,
       Count(order_id) as total_orders
From sales2
Group by customer_id
Having Count(order_id) > 1
Order By total_orders Desc;

-- Customer Segmentation
Select 
    customer_id,
    Sum(revenue) as total_spend,
    Case 
        When Sum(revenue) > 500 Then 'High Value'
        When Sum(revenue) > 175 Then 'Medium Value'
        Else 'Low Value'
    End as customer_segment
From sales2
Group By customer_id;
SELECT * FROM  pizza_sales;
-- alter table pizza_sales modify order_date date;

-- A.  KPI'S Requirement 
    -- 1. Total Revenue

SELECT pizza_category,ROUND(SUM(total_price),2) Revenue
FROM pizza_sales
GROUP BY pizza_category WITH ROLLUP; -- 817860.05

    -- 2. Average Order Value 
SELECT  Round(SUM(total_price)/COUNT(DISTINCT order_id),2) as avg_value
FROM pizza_sales; -- 38.3

    -- 3. Total Pizza Sold 
SELECT SUM(quantity) totalpiz_sold
FROM pizza_sales; -- 49574

	-- 4. Average Pizza Sold by Month 
SELECT Round(SUM(quantity) / 12,2) avgpiz_sold_bymonth
FROM pizza_sales;  -- 4131.1667

    -- 5. Total Orders 
SELECT SUM(DISTINCT order_id) total_orders
FROM pizza_sales;  -- 227921925

    -- 6. Average Pizzas Per Order 
SELECT Round(SUM(quantity) / COUNT(DISTINCT order_id),2) avgpiz_perorder
FROM pizza_sales;   -- 2.322

    
-- B. Hourly Trend for Total Pizzas Sold
 
   SELECT extract(HOUR FROM order_time) order_hours, SUM(quantity) as total_pizzas_sold
   FROM pizza_sales
   GROUP BY  extract(HOUR FROM order_time)
   ORDER BY  extract(HOUR FROM order_time);
 
   
-- C. Weekly Trend for Orders
SELECT 
    week(str_to_date(order_date,'%c/%d/%Y'),1) week_num,
    COUNT(DISTINCT order_id) AS Total_orders
FROM 
    pizza_sales
GROUP BY 
    week(str_to_date(order_date,'%c/%d/%Y'),1)
ORDER BY 
  week(str_to_date(order_date,'%c/%d/%Y'),1);
   


   
-- D. % of sales by Pizza Category 
       
	SELECT pizza_category,Round(sum(total_price),2) total_rev_bycate,ROUND(sum(total_price)*100/(SELECT SUM(total_price) from pizza_sales),2) as PCT
    FROM pizza_sales
    GROUP BY pizza_category;
    


-- E. % of Sales by Pizza Size
    SELECT pizza_size,Round(sum(total_price),2) total_rev_bycate,ROUND(sum(total_price)*100/(SELECT SUM(total_price) from pizza_sales),2) as PCT
    FROM pizza_sales
    GROUP BY pizza_size
    ORDER BY pizza_size;
-- F. Total Pizzas Sold by Pizza Category
	SELECT pizza_category,sum(quantity) total_sold_bycate
    FROM pizza_sales
    GROUP BY pizza_category
    ORDER BY pizza_category;
      
      
-- G. Top 5 Pizzas by Revenue
	select pizza_name, sum(total_price) revenue_by_pizzas
    from pizza_sales 
    group by pizza_name
    order by revenue_by_pizzas DESC
    LIMIT 5;

-- H. Bottom 5 Pizzas by Revenue
   select pizza_name, sum(total_price) revenue_by_pizzas
    from pizza_sales 
    group by pizza_name
    order by revenue_by_pizzas 
    LIMIT 5;
-- I. Top 5 Pizzas by Quantity
	select pizza_name, sum(quantity) total_pizza_sold
    from pizza_sales 
    group by pizza_name
    order by total_pizza_sold desc
    limit 5;
  
-- J. Bottom 5 Pizzas by Quantity
    select pizza_name, sum(quantity) total_pizza_sold
    from pizza_sales 
    group by pizza_name
    order by total_pizza_sold 
    limit 5;
-- K. Top 5 Pizzas by Total Orders
    select pizza_name,count(distinct order_id) total_orders
    from pizza_sales 
    group by pizza_name
    order by total_orders desc
    limit 5;
-- L. Borrom 5 Pizzas by Total Orders
    select pizza_name,count(distinct order_id) total_orders
    from pizza_sales 
    group by pizza_name
    order by total_orders 
    limit 5;
-- Total Sales
-- Total Profit
-- Total Ratio
-- Average Discount

select extract (year from o.order_date) as year, -- Год
		round(SUM(o.sales),2) as total_sales, -- Продажи $
		round(SUM(o.profit),2) as total_profit, -- Прибыль $
		concat(round(100*SUM(o.profit) / SUM(o.sales)),' ','%') as profit_ratio, -- Прибыль в % 
		concat(round(avg(o.discount)*100), ' ', '%') as average_discount -- Средняя скидка в % 
from orders o 
group by year
order by year asc;

-- Profit per Order

select o.order_id as number_order, -- Номер заказа
		round(SUM(o.profit),2) as profit_per_order -- Прибыль $ 
from orders o
group by o.order_id
order by o.order_id asc;

-- Sales per Customer

select o.customer_name, -- Клиент
		round(SUM(o.sales),2) as sales_per_customer -- сумма продаж на одного клиента $ 
from orders o
group by o.customer_name
order by o.customer_name asc;

-- Monthly Sales by Segment

select extract (year from o.order_date) as year, -- Год
		extract (month from o.order_date) as month, -- Месяц
		o.segment, -- Название сегмента
		round(SUM(o.sales),2) as sales_segment -- сумма ежемесячных продаж по сегментам $ 
from orders o 
group by year, month, o.segment
order by year, month, o.segment asc;

-- Monthly Sales by product category

select extract (year from o.order_date) as year, -- Год
		extract (month from o.order_date) as month, -- Месяц
		o.category, -- Название категории
		round(SUM(o.sales),2) as sales_segment -- сумма ежемесячных продаж по категориям $ 
from orders o 
group by year, month, o.category
order by year, month, o.category asc;

-- Sales by Product Category over time

select o.category, -- Категории
		round(SUM(o.sales),2) as total_sales -- Сумма продаж по категория $
from orders o 
group by o.category

union 

select 'Total_Sales' as category, -- Итог
		round(SUM(o.sales),2) as total_sales -- Сумма общих продаж $
from orders o
order by category asc;


-- Sales and Profit by Customer

select o.customer_name, -- Клиент
		round(SUM(o.sales),2) as sales_per_customer, -- сумма продаж на одного клиента $ 
		round(SUM(o.profit),2) as profit_per_customer -- сумма прибыли на одного клиента $ 
from orders o
group by o.customer_name
order by o.customer_name asc;

-- Customer ranking
-- TOP 10 the greatest profit

select o.customer_name, -- Клиент
		round(SUM(o.profit),2) as profit_per_customer -- сумма прибыли на одного клиента $ 
from orders o
group by o.customer_name
order by profit_per_customer desc
limit 10;


-- Sales per Region

select o.region, -- Регион
		round(sum(o.sales),2) as total_sales,  -- сумма продаж по регионам $ 
		concat(round(100*sum(o.sales) / (select sum(o.sales)
							from orders o 
							),1), ' ', '%') as procent_sales -- процент продаж по регионам % 
from orders o 
group by o.region


union 

select 'Total_Sales' as region, -- Итог
		round(SUM(o.sales),2) as total_sales, -- Сумма общих продаж $
		concat(round(100*sum(o.sales) / (select sum(o.sales)
							from orders o 
							),1), ' ', '%') as procent_sales -- процент продаж по регионам % 
from orders o
order by total_sales asc;

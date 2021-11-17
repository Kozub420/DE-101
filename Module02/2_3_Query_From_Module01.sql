-- Total Sales
-- Total Profit
-- Total Ratio
-- Average Discount

select extract (year from o.order_date) as year, -- ���
		round(SUM(o.sales),2) as total_sales, -- ������� $
		round(SUM(o.profit),2) as total_profit, -- ������� $
		concat(round(100*SUM(o.profit) / SUM(o.sales)),' ','%') as profit_ratio, -- ������� � % 
		concat(round(avg(o.discount)*100), ' ', '%') as average_discount -- ������� ������ � % 
from orders o 
group by year
order by year asc;

-- Profit per Order

select o.order_id as number_order, -- ����� ������
		round(SUM(o.profit),2) as profit_per_order -- ������� $ 
from orders o
group by o.order_id
order by o.order_id asc;

-- Sales per Customer

select o.customer_name, -- ������
		round(SUM(o.sales),2) as sales_per_customer -- ����� ������ �� ������ ������� $ 
from orders o
group by o.customer_name
order by o.customer_name asc;

-- Monthly Sales by Segment

select extract (year from o.order_date) as year, -- ���
		extract (month from o.order_date) as month, -- �����
		o.segment, -- �������� ��������
		round(SUM(o.sales),2) as sales_segment -- ����� ����������� ������ �� ��������� $ 
from orders o 
group by year, month, o.segment
order by year, month, o.segment asc;

-- Monthly Sales by product category

select extract (year from o.order_date) as year, -- ���
		extract (month from o.order_date) as month, -- �����
		o.category, -- �������� ���������
		round(SUM(o.sales),2) as sales_segment -- ����� ����������� ������ �� ���������� $ 
from orders o 
group by year, month, o.category
order by year, month, o.category asc;

-- Sales by Product Category over time

select o.category, -- ���������
		round(SUM(o.sales),2) as total_sales -- ����� ������ �� ��������� $
from orders o 
group by o.category

union 

select 'Total_Sales' as category, -- ����
		round(SUM(o.sales),2) as total_sales -- ����� ����� ������ $
from orders o
order by category asc;


-- Sales and Profit by Customer

select o.customer_name, -- ������
		round(SUM(o.sales),2) as sales_per_customer, -- ����� ������ �� ������ ������� $ 
		round(SUM(o.profit),2) as profit_per_customer -- ����� ������� �� ������ ������� $ 
from orders o
group by o.customer_name
order by o.customer_name asc;

-- Customer ranking
-- TOP 10 the greatest profit

select o.customer_name, -- ������
		round(SUM(o.profit),2) as profit_per_customer -- ����� ������� �� ������ ������� $ 
from orders o
group by o.customer_name
order by profit_per_customer desc
limit 10;


-- Sales per Region

select o.region, -- ������
		round(sum(o.sales),2) as total_sales,  -- ����� ������ �� �������� $ 
		concat(round(100*sum(o.sales) / (select sum(o.sales)
							from orders o 
							),1), ' ', '%') as procent_sales -- ������� ������ �� �������� % 
from orders o 
group by o.region


union 

select 'Total_Sales' as region, -- ����
		round(SUM(o.sales),2) as total_sales, -- ����� ����� ������ $
		concat(round(100*sum(o.sales) / (select sum(o.sales)
							from orders o 
							),1), ' ', '%') as procent_sales -- ������� ������ �� �������� % 
from orders o
order by total_sales asc;

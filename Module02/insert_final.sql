-- insert practic.customer_dim

insert into practic.customer_dim(customer_id,customer_name,segment)
select o.customer_id,
		o.customer_name,
		o.segment
from public.orders o
group by o.customer_id,
		o.customer_name,
		o.segment
order by  o.customer_id,
		o.customer_name;
	
	
-- checking customer_dim
select *,
		count(*) over() as num
from practic.customer_dim;

-- update orders 05401

update public.orders
set postal_code = 05401
where postal_code is null;

-- insert practic.geography_dim

insert into practic.geography_dim(country,city,state,region,postal_code,full_name_manager)
select distinct o.country,
				o.city,
				o.state,
				o.region,
				o.postal_code,
				p.person
from public.orders o
join public.people p 
	on o.region = p.region 
group by o.country,
		o.city,
		o.state,
		o.region,
		o.postal_code,
		p.person;

-- checking geography_dim
select *,
		count(*) over() as num
from practic.geography_dim;


-- insert practic.product_dim

insert into practic.product_dim(category, subcategory, product_name, product_id)
select  o.category,
		o.subcategory,
		o.product_name,
		o.product_id
from public.orders o
group by o.category,
			o.subcategory,
			o.product_name,
			o.product_id;


-- checking product_dim
select *,
		count(*) over() as num
from practic.product_dim;

-- insert practic.shipping_dim

insert into practic.shipping_dim (ship_mode)
select  o.ship_mode
from public.orders o
group by o.ship_mode;

-- checking shipping_dim
select *,
		count(*) over() as num
from practic.shipping_dim;

-- insert calendar_dim

insert into practic.calendar_dim(date_dim_id,year,quarter,"month",week,"date",week_day,leap)
select 
to_char(date,'yyyymmdd')::int as date_dim_id, 
       extract('year' from date)::int as year,
       extract('quarter' from date)::int as quarter,
       extract('month' from date)::int as month,
       extract('week' from date)::int as week,
       date::date,
       to_char(date, 'dy') as week_day,
       case when (extract('year' from date)::int % 4 = 0) and 
       			(extract('year' from date)::int % 100 != 0) or 	
       			(extract('year' from date)::int % 400 = 0) 
       		then True
       		else False
       end
       as leap 
  from generate_series(date '2015-01-01',
                       date '2030-01-01',
                       interval '1 day')
       as t(date);
      
      
--checking
      
select *
from practic.calendar_dim; 


-- insert practic.sales_fact

insert into practic.sales_fact(order_id,
								sales,
								quantity,
								discount,
								profit,
								returned,
								geo_dim_id,
								customer_dim_id,
								ship_dim_id,
								product_dim_id,
								ship_date_id,
								order_date_id)
select distinct o.order_id,
				o.sales,
				o.quantity,
				o.discount,
				o.profit,
				r.returned,
				gd.geo_dim_id,
				cd.customer_dim_id,
				sd.ship_dim_id,
				pd.product_dim_id,
				to_char(o.ship_date, 'yyyymmdd')::int as ship_date_id,
				to_char(o.order_date, 'yyyymmdd')::int as order_date_id
from orders o
-- join to "returns" 
left join "returns" r 
		on o.order_id = r.order_id
-- join customer_dim on customer_id 
inner join practic.customer_dim cd 
		on o.customer_id = cd.customer_id
-- join practic.geography_dim on state, city and postal code
inner join practic.geography_dim gd 
		on o.state = gd.state and o.city = gd.city and o.postal_code = gd.postal_code 
-- join shipping on ship_mode
inner join practic.shipping_dim sd 
		on o.ship_mode = sd.ship_mode 
-- join product_dim on product_id 
inner join practic.product_dim pd 
		on o.product_id = pd.product_id 
		
		
		
-- checking

select * 
from practic.sales_fact sf 



create database hw2_sql_operators;

create table customer(
    customer_id int primary key,
    first_name text not null,
    last_name text not null,
    gender varchar(8) not null,
    DOB varchar(10) not null,
    job_title text,
    job_industry_category text,
    wealth_segment text,
    deceased_indicator varchar(1) not null,
    owns_car varchar(3) not null,
    address text not null,
    postcode int not null,
    state text,
    country text not null,
    property_valuation int
)

create table transaction(
	transaction_id INT PRIMARY KEY,
	product_id INT NOT NULL,
	customer_id INT NOT NULL,
	transaction_date VARCHAR(10) NOT NULL,
	online_order BOOL,
	order_status VARCHAR(10) NOT NULL,
	brand TEXT,
	product_line VARCHAR(15),
	product_class VARCHAR(15),
	product_size VARCHAR(10),
	list_price FLOAT8 NOT null,
	standard_cost FLOAT8
)


--Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов
select distinct brand 
from "transaction" t
where standard_cost > 1500;

--Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно
select transaction_id
from "transaction" t 
where (to_date(transaction_date,'DD.MM.YYYY') between '2017-04-01' and '2017-04-09') 
      and order_status = 'Approved';

--Вывести все профессии у клиентов из сферы IT или Financial Services,
--которые начинаются с фразы 'Senior'
select job_title
from customer c 
where job_industry_category in ('IT', 'Financial Services')
      and job_title like 'Senior%';
 
--Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
select brand
from "transaction" t  inner join customer c 
     on t.customer_id = c.customer_id  
where c.job_industry_category = 'Financial Services'

--Вывести 10 клиентов, которые оформили онлайн-заказ продукции из 
--брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
select c.customer_id
from customer c inner join "transaction" t 
     on t.customer_id = c.customer_id
where t.brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
      and online_order = true
limit 10;

--Вывести всех клиентов, у которых нет транзакций
select c.customer_id
from customer c left join "transaction" t 
     on t.customer_id = c.customer_id 
where t.customer_id is null;

--Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
select c.customer_id
from customer c inner join "transaction" t 
     on c.customer_id = t.customer_id
where job_industry_category = 'IT' and 
      t.standard_cost = (select max(standard_cost) from "transaction");
     
--Вывести всех клиентов из сферы IT и Health, у которых есть 
--подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
with filtered_customer as (
    select customer_id
    from customer c
    where job_industry_category in ('IT', 'Health')
), 
filtered_transaction as (
    select customer_id, transaction_id
    from "transaction" t 
    where to_date(transaction_date, 'DD.MM.YYYY') between '2017-07-07' and '2017-07-17'
          and order_status = 'Approved'
)
select c.customer_id
from filtered_customer c inner join filtered_transaction t
on c.customer_id = t.customer_id;


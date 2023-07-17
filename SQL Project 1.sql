create database project1

use project1

CREATE TABLE goldusers_signup(ID int,gold_signup_date date); 

INSERT INTO goldusers_signup(ID,gold_signup_date) 
 VALUES (1,'09-22-2017'),
        (3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(ID int,signup_date date); 

INSERT INTO users(ID,signup_date) 
 VALUES (1,'09-02-2014'),
        (2,'01-15-2015'),
        (3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(ID int,created_date date,product_id int); 

INSERT INTO sales(ID,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
        (3,'12-18-2019',1),
        (2,'07-20-2020',3),
        (1,'10-23-2019',2),
        (1,'03-19-2018',3),
        (3,'12-20-2016',2),
        (1,'11-09-2016',1),
        (1,'05-20-2016',3),
        (2,'09-24-2017',1),
        (1,'03-11-2017',2),
        (1,'03-11-2016',1),
        (3,'11-10-2016',1),
        (3,'12-07-2017',2),
        (3,'12-15-2016',2),
        (2,'11-08-2017',2),
		(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_ID int,product_name varchar(100),price int); 

INSERT INTO product(product_ID,product_name,price) 
 VALUES (1,'p1',980),
        (2,'p2',870),
        (3,'p3',330);

select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

Queustion 1) what is the total and average amount each customer spent on Zomato?

select sales.ID,sum(product.price) as Total_amont_spent,avg(product.price) as average_expenditure
from sales inner join product 
on sales.product_id=product.product_ID
group by ID

Question 2) what is the number of days each customer spent on zomato?

select ID,count(created_date) as total_days_spent_on_zomato from sales group by ID

Question 3) What is the first product purchased by each customer?

Select ID,min(created_date) from sales group by ID

OR

select * from (select ID,created_date, rank() over(partition by ID order by created_date) as rank_no from sales) t 
where rank_no = 1

Question 4) what was the most purchased item on the menu and how many times did each customer buy that product??

select top 1 product_id,count(product_id) as individuals_purchase from sales 
group by product_id order by individuals_purchase desc

select ID, count(product_id) as no_of_purchases from sales 
where product_id=(select top 1 product_id from sales group by product_id order by count(product_id) desc)
group by ID

Question 5) which product was most popular for each customer?

select ID,product_id as popular_product from
(select *,rank() over(partition by ID order by cnt desc) as rnk from
(select ID,product_id,count(product_id) as cnt from sales group by ID,product_id)a)b
where rnk=1

Question 6) which item was purchased first by the customer after they become a member?

select * from
(select a.*,rank() over(partition by ID order by created_date)rnk from 
(select sales.*,goldusers_signup.gold_signup_date from sales inner join goldusers_signup
on sales.ID=goldusers_signup.ID where created_date>=gold_signup_date)a)b
where rnk=1

Question 7) which product was purchased just before a user became a member?

select * from
(select a.*,rank() over(partition by ID order by created_date desc)rnk from 
(select sales.*,goldusers_signup.gold_signup_date from sales inner join goldusers_signup
on sales.ID=goldusers_signup.ID where created_date<gold_signup_date)a)b
where rnk=1

Question 8) what is the total number of orders and amount spent by a user before they became a member
 
 select b.ID,count(b.created_date)no_of_orders,sum(b.price)total_amt_spent from
 (select a.*,product.price from
 (select sales.ID,sales.created_date,sales.product_id,goldusers_signup.gold_signup_date from sales 
 inner join goldusers_signup on sales.ID=goldusers_signup.ID and created_date<gold_signup_date)a
 inner join product on a.product_id=product.product_ID)b
 group by ID

Question 9) if buying each product gives the customer points eg, 5rs= 2pt
and each product has different purchasing poing eg, for p1 5rs=1pt, p2 10rs=5pt, p3 5rs=1pt
calculate the amount of pts each user has till now and for which product most pts have been given till now.;

select c.*,c.total_points*2.5 as cashback_earned from
(select b.ID,count(b.Created_date)no_of_orders,sum(b.price)total_amt,sum(b.no_of_points)total_points from
(select a.*,case when a.product_id=2 then a.price/2 else a.price/5 end as no_of_points from
(select sales.*, product.price from sales inner join product
on sales.product_id=product.product_ID)a)b group by ID)c;
OR;
select c.ID, sum(c.points)as total_points,sum(c.points)*2.5 as cashback_earned from 
(select b.*,case when b.product_id=2 then b.total_amt/2 else b.total_amt/5 end as points from
(select a.ID,a.product_id,sum(a.price)total_amt from
(select sales.*, product.price from sales inner join product
on sales.product_id=product.product_ID)a  group by ID,product_id)b)c
group by ID;

select e.* from
(select d.*,rank() over (order by d.points_earned desc)rnk from
(select c.product_id,sum(c.points) as points_earned from 
(select b.*,case when b.product_id=2 then b.total_amt/2 else b.total_amt/5 end as points from
(select a.ID,a.product_id,sum(a.price)total_amt from
(select sales.*, product.price from sales inner join product
on sales.product_id=product.product_ID)a  group by ID,product_id)b)c
group by Product_id)d)e where rnk=1

 Question 10) In the first year of joining the gold membership each members gets 5 pt for every 10rs spent.who earned more 1 or 3
              what was the total amount of point earned by the in first year of membership


select a.ID,a.product_id, product.price,product.price/2 as points_earned from
(select sales.ID,sales.product_id,sales.created_date,goldusers_signup.gold_signup_date
from sales inner join  goldusers_signup
on sales.ID=goldusers_signup.ID and created_date>=gold_signup_date and created_date<=dateadd(year,1,gold_signup_date))a 
inner join product 
on a.product_id=product.product_ID


Question 11) Rank all the transactions of the customers who are gold members and 'na' for non gold members

select d.ID,d.product_id,d.created_date,case when rnk!=0 then rnk else 'NA'end as Rnkk from
(select c.*, cast(case when gold_signup_date is null then 0 else rank() over(partition by c.ID order by c.created_date desc)end as varchar) as rnk from
(Select a.*,b.gold_signup_date from sales a
left join goldusers_signup b on a.ID=b.ID and a.created_date>=b.gold_signup_date)c)d













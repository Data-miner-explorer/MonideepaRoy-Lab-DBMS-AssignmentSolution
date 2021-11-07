-- solution to 3 number of customers by gender who have placed order >3000
select cus_gender, COUNT(*)
from 
	`order`,
    customer
where `order`.cus_id = customer.cus_id
and ord_amount >= 3000
group by customer.cus_gender;

-- 4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.

select *
from
	`order`
    inner join
    product_details
    on `order`.prod_id = product_details.prod_id
    inner join
    product
    on product_details.pro_id = product.pro_id
where cus_id = 2;

-- 5)	Display the Supplier details who can supply more than one product.
-- 5a) Find out supp_id of suppliers supplying more than 1 product
select supp_id
from product_details
group by supp_id
having count(*) > 1;

-- 5b) Use suppliers obtained from the previous query to get the supplier details
-- EXERCISE
-- HINT: Use IN in the WHERE clause and provide the result of previous query (5a) to IN
select *
from supplier
where supp_id in (
	select supp_id
	from product_details
	group by supp_id
	having count(*) > 1
);


-- 6)	Find the category of the product whose order amount is minimum.
select *
from
	`order`
    inner join product_details on product_details.prod_id = `order`.prod_id
    inner join product on product_details.pro_id = product.pro_id
    inner join category on product.cat_id = category.cat_id
order by ord_amount limit 1;
-- alternatively we can also do as below , it does not use sort, so less expensive:
select *
from
	`order`
    inner join product_details on product_details.prod_id = `order`.prod_id
    inner join product on product_details.pro_id = product.pro_id
    inner join category on product.cat_id = category.cat_id
where ord_amount=(select min(ord_amount) from `order`);
   
-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”

select ord_id, ord_date, product.pro_id, pro_name, pro_desc
from 
	`order`
	inner join product_details on `order`.prod_id = product_details.prod_id
    inner join product on product_details.pro_id = product.pro_id
where ord_date > "2021-10-05";


-- 8)	Print the top 3 supplier name and id and their rating on the basis of their rating along with the customer name who has given the rating.
select supplier.supp_id, supp_name, cus_name, rating.rat_ratstars
from 
	rating
    inner join supplier on supplier.supp_id = rating.supp_id
    inner join customer on customer.cus_id = rating.cus_id
order by rating.rat_ratstars desc limit 3;


-- 9)	Display customer name and gender whose names start or end with character 'A'.
-- HINT: WHERE cus_name LIKE 'A%' OR cus_name LIKE '%A'
select cus_name, cus_gender
from customer
where cus_name like 'A%' or cus_name like '%A';
-- alternatively we can also use regexp
select cus_name, cus_gender
from customer
where cus_name regexp '^A' or cus_name regexp 'A$';


-- 10)	Display the total order amount of the male customers.
select if(cus_gender='M','Male','Female') as cust_gender, sum(ord_amount)
from `order` inner join customer on `order`.cus_id = customer.cus_id
where cus_gender = 'M';


-- 11)	Display all the Customers left outer join with  the orders.
-- join customer with order and display all fields - use "left outer join" instead of "inner join"
-- left outer join ensures that records in the table on the left ALWAYS appear in the result
-- eg. Pallavi who is a new customer and has NO order still apeears in the result

-- add a new customer Pallavi - initially she has NO order
insert into customer(cus_id, cus_name, cus_phone, cus_city, cus_gender) values(6, 'Pallavi', 1234567890, 'Bangalore', 'F');

-- solution
select *
from customer left outer join `order` on `order`.cus_id = customer.cus_id;


create database sample_ecomm;
use sample_ecomm;

# table editing
#customers
describe customers;
alter table customers modify email varchar(100);
alter table customers modify account_created date;
alter table customers modify last_login date;
alter table customers add primary key(customer_id);
select * from customers;

#orders
describe orders;
alter table orders modify order_date date;
alter table orders add primary key(order_id);
alter table orders add constraint e_com_er foreign key(customer_id) references customers(customer_id);
alter table orders add  foreign key(product_id) references products(product_id);
select * from orders;

#payments
describe payments;
alter table payments add primary key(payment_id);
alter table payments add foreign key(order_id) references orders(order_id);
select * from payments;

#products
describe products;
alter table products add primary key(product_id);
select * from products;

#shipping
describe shipping;
alter table shipping add primary key(shipping_id);
alter table shipping add foreign key(order_id) references orders(order_id);
select * from shipping;


# project task 1

select * from customers;

update customers
set loyalty_points = loyalty_points +
case
 when age < 25 then  10
 when age between 25 and 40 then 20
 else  5
 end ;
 
 
 select * from customers ;
 
# project task 2
 
 select * from orders;
 
 select c.country,round(sum(o.order_value)) as total_order ,
 case
 when sum(o.order_value) > 100000 then "high"
 when sum(o.order_value) between 50000 and 100000 then "medium"
 else "low"
 end as total_order_value
 from orders as o
 join customers as c
 on o.customer_id = c.customer_id
 group by c.country;
 
 
# project task 3
 
select * from orders;

select payment_method,sum(quantity) as total_quantity,
case when payment_method = "bank transfer" then sum(quantity) end as bank_transfer_qty,
case when payment_method = "credit card" then sum(quantity) end as credit_qty,
case when payment_method = "paypal" then sum(quantity)end  as paypal_qty,
case when payment_method = "cash" then sum(quantity) end as cash_qty from orders
group by payment_method;
 

 
# project task 4
 
 select * from orders;
 select customer_id,customer_name,customer_order_value from
 (select c.customer_id,c.customer_name,round(sum(o.order_value))as customer_order_value,
 rank()over(order by sum(o.order_value) desc)
 from customers  c
 join orders o
 on c.customer_id= o.customer_id group by c.customer_id,c.customer_name ) as rank_customer 
 order by customer_order_value desc limit 3;
 

 
 # project task 5
 
 select * from orders;
 select * from products;
 
 SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_quantity
FROM products p
JOIN orders oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >
       (
           SELECT AVG(total_qty)
           FROM (
               SELECT SUM(quantity) AS total_qty
               FROM orders
               GROUP BY product_id 
           ) AS avg_table
       ) ORDER BY total_quantity DESC;

 
# project task 6
 
 select * from orders;
 
 delimiter //
 create procedure get_all_order(in customer int)
 begin
 select * from orders
 where customer_id = customer;
 end //
 delimiter ;
 
 call get_all_order(4555);
 

 
# project task 7
 
 DELIMITER //

CREATE PROCEDURE update_latest(
    IN p_customer_id INT,
    INOUT total_spent DECIMAL(10,2)
)
BEGIN
    SELECT SUM(order_value)
    INTO total_spent
    FROM orders
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;
drop procedure update_latest;
select * from orders;
 set @total_spent =0;
 call update_latest (1753,@total_spent);
 select @total_spent;
 

 
# project task 8
 
 DELIMITER //

CREATE TRIGGER before_customer_insert
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    IF NEW.loyalty_points IS NULL THEN
        SET NEW.loyalty_points = 0;
    END IF;
END //

DELIMITER ;

drop trigger before_customer_insert;
select * from customers;
 
update customers
set loyalty_points = 4011
where customer_id =1;



# project task 9

select * from orders;
select * from products;

DELIMITER //
CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END//
DELIMITER ;
select * from products;
select * from orders;

insert into orders 
values(1003,4555,1,'2024-05-02','delivered',5,0.02,18.69,'credit card',143.34);

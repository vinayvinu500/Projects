/*
# What is the database all about
    - offices (7) => (San Francisco,Boston,NYC,Paris,Tokyo,Sydney,London)
    - employees (23) are working in a particular office for their customers (22) (clients)
    - orders placed by the customers and payment made
    - particular order has order details
    - particular order detail has certain products in stock
    - which is categorised by productlines (Classic Cars,Motorcycles,Planes,Ships,Trains,Trucks and Buses,Vintage Cars)

# Relationship
    offices
        |  -> offices.officeCode = employees.officeCode
    employees
        |  -> employees.employeeNumber = customers.salesRepEmployeeNumber
    customers
        |
    |        | -> customers.customerNumber = orders.customerNumber | -> customers.customerNumber = payments.customerNumber
orders     payments
    | -> orders.orderNumber = orderdetails.orderNumber
orderdetails
    | -> orderdetails.productCode = products.productCode
products
    | -> products.productLine = productlines.productLine
productlines

# Tables:
    customers	    122
    employees   	23
    offices     	7
    orderdetails	2996
    orders      	326
    payments	    273
    productlines	7
    products	    110


# Questions
-- Get those order details whose amount is greater than 100,000 and got cancelled(1 Row))
-- Get employee details who shipped an order within a time span of two days from order date (15 Rows)
-- Get product name , product line , product vendor of products that got cancelled(53 Rows)
-- Display those customers who ordered product of price greater than average price(buyPrice) of all products(98 Rows)

*/
-- -------------------------------------------------------------------------------------------------------------------------
-- Get those order details whose amount is greater than 100,000 and got cancelled(1 Row))
-- -------------------------------------------------------------------------------------------------------------------------
# tables : orders, payments
select * from orders; # orders.status = 'Cancelled'
select * from payments; # payments.amount > 100000

# join query
select distinct orders.*
from orders inner join payments
on orders.customerNumber = payments.customerNumber
and orders.status = 'Cancelled' and payments.amount > 100000;

# sub query
select orders.*
from orders where customerNumber in (select customerNumber from payments where amount>100000)
              and orders.status = 'Cancelled';

-- -------------------------------------------------------------------------------------------------------------------------
-- Get employee details who shipped an order within a time span of two days from order date (15 Rows)
-- -------------------------------------------------------------------------------------------------------------------------
# tables : employees, orders
select * from employees; # employees.*
select * from orders; # orders.orderDate | orders.shippedDate
# shipped an order within a time span of two days from order date => orders.shippedDate between orders.orderDate and orders.orderDate+2days

# join query
select distinct employees.*
from employees inner join customers inner join orders
on employees.employeeNumber = customers.salesRepEmployeeNumber and customers.customerNumber = orders.customerNumber
and orders.shippedDate <= orders.orderDate+2;

# sub query
select *
from employees
where employeeNumber in (select salesRepEmployeeNumber
                        from customers inner join orders using(customerNumber)
                        where shippedDate <= date_add(orders.orderDate,interval 2 day));


-- -------------------------------------------------------------------------------------------------------------------------
-- Get product name , product line , product vendor of products that got cancelled(53 Rows)
-- -------------------------------------------------------------------------------------------------------------------------
# tables : products, orders
select * from orders; # orders.status = 'Cancelled'
select * from products; # products.productName, productLine, productVendor

# inner join
select distinct products.productName, products.productLine, products.productVendor
from products inner join orderdetails inner join orders
on orders.orderNumber = orderdetails.orderNumber and orderdetails.productCode = products.productCode and orders.status = 'Cancelled';

# sub query join
select products.productName, products.productLine, products.productVendor
from products where productCode in (select productCode from orderdetails inner join orders using(orderNumber) where orders.status = 'Cancelled');


-- -------------------------------------------------------------------------------------------------------------------------
-- Display those customers who ordered product of price greater than average price(buyPrice) of all products(98 Rows)
-- -------------------------------------------------------------------------------------------------------------------------
# tables : customers, orders, products
select * from customers; # customers.*
select * from products; # product.buyPrice > avg(product.buyPrice)

# inner join
select distinct customers.*
from customers inner join orders using(customerNumber) inner join orderdetails using(orderNumber) inner join products using(productCode)
where buyPrice > (select avg(buyPrice) from products);

# sub query join
select *
from customers
where customerNumber in (select customerNumber from orders
where orderNumber in (select orderNumber from orderdetails
where productCode in (select productCode from products
where buyPrice > (select avg(buyPrice) from products))));

-- fetch the customers who doesn't ordered
-- sub query
select * from customers
where customerNumber not in (select distinct customerNumber from orders);

-- sub query
select * from customers where not exists(select customerNumber from orders
where customers.customernumber = orders.customerNumber);

-- join
select customers.*
from customers left outer join orders using (customerNumber)
where orderNumber is null;

-- -------------------------------------------------------------------------

-- ranking the creditlimit in descending order
select creditLimit, rank() over(order by creditLimit desc) as ranking
from customers order by creditLimit desc;

-- customers : 122 | orders : 326 | orderdetails : 2996
select count(*) from customers inner join orders o on customers.customerNumber = o.customerNumber inner join orderdetails o2 on o.orderNumber = o2.orderNumber;

select count(*) from customers inner join orders inner join orderdetails
on customers.customerNumber = orders.customerNumber and orders.orderNumber = orderdetails.orderNumber;


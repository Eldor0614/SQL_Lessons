--BULK INSERT - is a database operation designed to efficiently load large number of records into a database table in a single operation.

-- CSV, TSV, Excel, and XML files. 

drop table if exists Products
create table Products (ProductID int primary key, ProductName varchar (50), Price decimal(10,2))

insert into Products (ProductID, productName, Price)
values (3, 'Banana', 12000), 
(7, 'cookies', 40000), 
(4, 'fridge', 250);

--null allows missing data while not null requires data to be present

alter table products 
add constraint uq_produtname
unique(productName);

 -- a comment on unique constrint - it ensures that all values in a column or combination of columns 
--are unique within a database table

alter table Products 
add CategoryID int 

create table Categories (CategoryID int primary key, CategoryName varchar (50) unique)

--it is used to automatically generate unique, sequential numeric values for a column


bulk insert emails 
from 'C:\Users\Asus\Downloads\Telegram Desktop\emails.txt'
with 
(
firstrow = 2, 
fieldterminator = ',',
rowterminator = '\n'
);


alter table Products 
add constraint fk_categoryID foreign key (CategoryID) REFERENCES Categories (CategoryID)

-- A table can have only one primary key, while it can have multiple unique keys. A primary key cannot contain NULL values, 
-- but a unique key can include NULL values.

alter table PRODUCTS 
add constraint chk_price check (price>0)

alter table PRODUCTS 
add Stock int not null 

select productName, isnull(price, 0) AS price from PRODUCTS 

-- it is constraint that makes sure the value in a column (the foreign key) 
-- matches a value in another table's column (usually primary key) 

create table Customers (Name varchar (50), address varchar (50), age int constraint chk_age check (age >=18))


create table car_renting(carID int identity (100, 10), car_type varchar (50), colour varchar(50))


create table OrderDetails (CustomerID int, OrderID int, FirstName varchar (50), LastName varchar (50), branch varchar (50 ), Primary key (CustomerID, OrderID))

--ISNULL and COALESCE are functions used to handle NULL values. They act like a mask, replacing NULL with a specified value in the result. 
--The difference is that ISNULL works with a single expression, while COALESCE can evaluate multiple expressions and return the first non-NULL value


create table Employees (EmpID int primary key, email varchar(50) unique, constraint uk_email unique (email))

create table orders (Orderid int primary key, customername varchar (50), order_code int, branch varchar (50))
insert into orders values(1, 'daniel', 2323, 'novza'),
(2, 'fred', 4545, 'yashnaobod'),
(3, 'david', 6453, 'yashnaobod')

select * from orders 

create table customers (customerid int primary key, Orderid int constraint fk_orderid foreign key (orderid) references orders (orderid) on delete cascade/ on update cascade, age int)
		insert into customers (customerid, Orderid, age)
		values (1, 2, 18 ), (2, 3, 19);
		select * from customers

		select * from customers








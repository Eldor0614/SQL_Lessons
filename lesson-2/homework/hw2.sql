create table Employees 
(
EmpID int primary key, Name varchar (50),
Salary decimal (10,2))
select * from Employees 


insert into Employees (EmpID, Name, Salary)
values (1, 'charlie', 1000.00)

insert into Employees 
values (1, 'john', 999.9), 
       (2,'leo', 1200),
	   (3, 'Trafford', 1100);


update Employees
set 
salary=7000
where EmpID =1 


delete from Employees
WHERE EmpID=2 


--these three queries are used for removals. the drop query is used to delete tables and database completely while the truncate and delete quaries are mainly for removing rows and data in tables.  
-- As for the difference betwen delete and truncate, delete can remove rows and data by logging, making the process slower, and it can also use where,  clouse, to remove specific data in tables.
--Compared to the delete query, the truncate query may work faster as it does not usually log while removing data,  and using Where clouse with truncate quiery to specify data to remove is impossible.

alter table Employees 
alter column name varchar (100)

alter table Employees 
add Department varchar (50)

alter table Employees 
alter column salary float 

create table Departments (DepartmentID int primary key, DepartmenName varchar(50))
select * from Departments

truncate Employees

Insert into Departments 
values (1, 'Finance', 3, 5200, 1234),(2, 'IT', 3, 6800, 1274),
(3, 'Management', 5, 1200, 1634),
(4, 'administration', 1, 800, 1334),
(5, 'HR', 4, 5500, 4234);
SELECT * FROM Departments 


update Departments 
set 
DepartmenName = 'management' 
where salary > 5000

delete from Employees

alter table Employees 
drop column Department 

exec sp_rename 'Employees' , 'StaffMembers'

DROP TABLE DEPARTMENTS



create table Products (ProductID int primary key, ProductName varchar (50), category varchar (50),
price decimal constraint PRICE check (price>=0)) -- check constraint qo'shish 
select * from Products

alter table Products 
add StockQuantity int constraint df_stockquantity default 50; -- adding a new column with a default value 


exec sp_rename 'Products.category', 'ProductCategory', 'column';

insert into Products (ProductID, ProductName, ProductCategory, price)
values (3, 'Banana', 'fruits', 12000), 
(4, 'fridge', 'household_appliance', 250),
(5, 'laptop', 'tech_tools', 600), 
(6, 'smarphone', 'tech_tools', 350), 
(7, 'cookies', 'cakes', 40000)

select * into Products_backup from Products

exec sp_rename 'Products', 'Inventory'

alter table inventory 
alter column price float 

alter table inventory 
add ProductCode int identity (1000, 5)















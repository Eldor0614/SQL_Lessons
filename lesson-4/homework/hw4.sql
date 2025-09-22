
select top 5 * from Employees 



select distinct Category from Products 



Select * from Products where price > 100 



select * from Customers 
where FirstName like 'a%'





select * from Products order by Price asc


select * from Employees where salary >= 60000 and DepartmentName = 'HR'


select isnull(Email, 'noemail@example.com' ) from Employees


select * from Products where Price between 50 and 100;

select distinct ProductName, Category from Products 

select distinct ProductName, Category from Products order by ProductName desc



----MEDIUM

select top 10 * from Products order by price desc

select coalesce (firstname,lastname) from Employees 


select * from Employees where age between 30 and 40 or DepartmentName  = 'Marketing'

select * from Employees  order by salary desc
offset 10 rows
fetch next 10 rows only 


select * from Products
where Price <= 1000 and
StockQuantity > 50 
order by Stock;


select  * from Products where ProductName like '%e%'


select * from employees 
where DepartmentName in ('HR', 'IT', 'Finance')

select * from Customers
order by city asc, PostalCode desc 


select top 5 * from Sales order by SaleAmount desc


select EmployeeID, FirstName + ' ' + LastName as FullName from Employees 

select distinct Category, ProductName, Price from  Products where Price > 50

select * from products where price < 0.1 * (select avg(price) from products)

select * from Employees where age < 30 and DepartmentName IN ('HR', 'IT') 

select * from customers where Email like '%@gmail.com%'

select * from employees 
where salary > all ( select salary from employees where DepartmentName = 'sales')


select max(orderdate)from orders
select * from orders where orderdate between dateadd (day, -180, (select max(orderdate ) from orders )) and (SELECT MAX(OrderDate) FROM Orders)

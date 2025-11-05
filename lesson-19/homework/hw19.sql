---HOMEWORK NUMBER 19 -----

--1. 
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8);

CREATE PROCEDURE dbo.Calculating_Bonus 
AS
BEGIN 
CREATE TABLE #Bonus 
	(EmployeeID INT,
	FullName VARCHAR (50),
	Department VARCHAR (50), 
	Salary INT, 
	BonusAmount INT)
INSERT INTO #Bonus
SELECT 
	E.EmployeeID, 
	CONCAT(E.FirstName, ' ', E.LastName) AS FullName,
	E.Department AS DepartmentName, 
	E.Salary, 
	(E.Salary * D.BonusPercentage / 100) AS BonusAmount
FROM Employees AS E
LEFT JOIN DepartmentBonus AS D
ON E.Department = D.Department 

SELECT * FROM  #Bonus

END;

EXEC dbo.Calculating_Bonus;

--2.Create a stored procedure that:

--Accepts a department name and an increase percentage as parameters
--Update salary of all employees in the given department by the given percentage
--Returns updated employees from that department.
CREATE PROCEDURE dbo.IncreaseEmpSalary 
@Department NVARCHAR(50),
@Percentage INT
AS 
BEGIN 
SELECT 
	EmployeeID, 
	FirstName, 
	LastName, 
	cast(Salary + (Salary * @Percentage / 100) AS decimal (10, 2)) AS Salary
	FROM Employees
	WHERE Department = @Department

END;

EXEC dbo.IncreaseEmpSalary @Department = 'Sales', @Percentage = 7;


--3. 

CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);

SELECT * FROM Products_Current
SELECT * FROM Products_New

MERGE INTO Products_Current AS PC
USING Products_New AS PN
ON PC.ProductID = PN.ProductID
WHEN MATCHED THEN 
	UPDATE SET PC.ProductName = PN.ProductName, PC.Price = PN.Price
WHEN NOT MATCHED BY TARGET THEN 
	INSERT (ProductID, ProductName, Price)
	VALUES (PN.ProductID, PN.ProductName, PN.Price)
WHEN NOT MATCHED BY SOURCE THEN 
	DELETE 
;

SELECT * FROM Products_Current;

--4. 
CREATE TABLE  Tree (id INT, p_id INT);
TRUNCATE TABLE Tree;
INSERT INTO Tree (id, p_id) VALUES (1, NULL);
INSERT INTO Tree (id, p_id) VALUES (2, 1);
INSERT INTO Tree (id, p_id) VALUES (3, 1);
INSERT INTO Tree (id, p_id) VALUES (4, 2);
INSERT INTO Tree (id, p_id) VALUES (5, 2);

SELECT * FROM Tree

select  
	t1.id,
	t2.id, 
	t2.p_id,
	case 
	when t2.p_id IS null then 'root'
	when t2.id Is null then 'leaf' 
	else 'inner'
end 
from tree as t1
full outer join  tree as t2
on t2.p_id = t1.id
order by t2.id


select 
a.id,
CASE
	WHEN a.p_id Is null THEN 'Root'
	WHEN a.p_id IS not null and b.p_id IS not null THEN 'Inner'
	ELSE 'Leaf'
END AS Type
	FROM Tree a
left join 
(select distinct  p_id from tree) b on a.id=b.p_id;

--5
CREATE TABLE  Signups (user_id INT, time_stamp DATETIME);
CREATE TABLE Confirmations (
  user_id INT,
  time_stamp DATETIME,
  action VARCHAR(20) CHECK (action IN ('confirmed','timeout')))

INSERT INTO Signups (user_id, time_stamp) VALUES 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

TRUNCATE TABLE Confirmations;
INSERT INTO Confirmations (user_id, time_stamp, action) VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

;WITH CTE AS (SELECT 
a.user_id,
b.action,
count (b.action) AS CountingConAndTimeOut
FROM Signups AS A
LEFT JOIN 
(Select User_id, action FROM Confirmations AS B ) AS B
ON A.user_id = B.User_id
group by a.user_id, b.action),

SUMMARY AS (
select 
user_id, 
SUM(CountingConAndTimeOut) AS CountingConAndTimeOut ,
sum(CASE WHEN action = 'CONFIRMED' THEN CountingConAndTimeOut ELSE 0 END) AS OnlyConfirmed from CTE
GROUP BY user_id)
select * from SUMMARY

SELECT 
user_id, 
CASE 
	WHEN CountingConAndTimeOut = 0 THEN 0.00
	ELSE CAST (OnlyConfirmed * 1.0 / CountingConAndTimeOut AS DECIMAL(10,2))
EnD AS ConfirmationRate 
from SUMMARY;
--6. Find employees with the lowest salary
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

SELECT 
* FROM 
(SELECT ID, Name, Salary, DENSE_RANK() OVER (ORDER BY Salary ASC) AS SalaryRanking
FROM Employees) AS A
WHERE SalaryRanking = 1;

--7. 

CREATE TABLE Products1 (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products1 (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');

CREATE OR ALTER PROCEDURE GetProductSalesSummary
@ProductID INT 
AS
BEGIN 
SELECT 
	P.ProductID,
	P.ProductName, 
	SUM(S.Quantity) AS QuantitySold,
	SUM(S.Quantity * P.Price) AS TotalSaleAmount,
	MIN(S.SaleDate) AS First_Date,
	MAX(S.SaleDate) AS Last_Date
FROM Products1 AS P
LEFT JOIN Sales AS S
ON P.ProductID = S.ProductID
WHERE P.ProductID = @ProductID
GROUP BY
	P.ProductID,
	P.ProductName
END;

EXEC GetProductSalesSummary @ProductID = 1;



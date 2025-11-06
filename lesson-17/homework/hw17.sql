---HOMEWORK NUMBER 17 ----
--1. 1. You must provide a report of all distributors and their sales by region. If a distributor did not have any sales for a region, 
-- rovide a zero-dollar value for that day. Assume there is at least one sale for each region
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);


WITH Region AS
	(SELECT DISTINCT Region
	FROM #RegionSales),
Distributor AS 
	(SELECT DISTINCT Distributor
	FROM #RegionSales)

SELECT 
	R.Region, 
	D.Distributor, 
	COALESCE(RS.Sales, 0)
FROM Region AS R
CROSS JOIN Distributor AS D
LEFT JOIN #RegionSales AS RS
ON R.Region = RS.Region
AND D.Distributor = RS.Distributor;


--2. Find managers with at least five direct reports
drop table Employee
CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT 
ManagerName 
FROM 
(SELECT 
B.name AS ManagerName,
COUNT(A.name) AS EmpNameCount
From Employee AS A
JOIN Employee AS B
ON B.id = A.managerId
GROUP BY B.name
HAVING COUNT(A.name) >= 5) AS A;

--3.  Write a solution to get the names of products that have at least 100 units ordered 
-- in February 2020 and their amount.

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

SELECT 
	O.product_id,
	P.product_name,
	SUM(unit) AS TotalUnit
FROM Products AS P
JOIN Orders AS O
ON P.product_id = O.product_id
WHERE YEAR(O.order_date) = 2020 AND MONTH(O.order_date) = 2
GROUP BY 
O.product_id,
P.product_name
HAVING 	SUM(unit) >= 100;

--4. Write an SQL statement that returns the vendor from which each customer has placed the most orders

CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');
SELECT * FROM Orders

WITH CTE AS (SELECT 
	CustomerID,
	Vendor,
	Count(OrderID) AS OrderCount
FROM Orders
GROUP BY Vendor, CustomerID)

SELECT TOP 2 
CustomerID,
Vendor
FROM CTE 
ORDER BY OrderCount DESC; 

-- 5.You will be given a number as a variable called @Check_Prime check if this number is prime then return 'This number is prime' else eturn 'This number is not prime'

CREATE FUNCTION dbo.IsPrime (@Check_Prime INT)
RETURNS NVARCHAR(50)
AS 
BEGIN 
IF @Check_Prime < 2
RETURN 'THIS IS NOT A PRIME NUMBER '

IF @Check_Prime = 2
RETURN 'THIS IS A PRIME NUMBER'

IF @Check_Prime % 2 = 0
RETURN 'THIS IS NOT A PRIME NUMBER'

DECLARE @DEVISOR INT = 3
WHILE @DEVISOR * @DEVISOR <=@Check_Prime
BEGIN 
IF @Check_Prime % @DEVISOR = 0 
RETURN 'THIS IS NOT A PRIME NUMBER'
SET @DEVISOR = @DEVISOR + 2 
END 
RETURN 'THIS IS A PRIME NUMBER'
END;

DECLARE @Check_Prime INT = 91;
SELECT dbo.IsPrime(@Check_Prime) AS NumberType;


--6. Write an SQL query to return the number of locations,in which location most signals sent, 
-- and total number of signal for each device from the given table.

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

WITH Signal_Count AS (SELECT 
	Device_id, 
	Locations, 
	COUNT(*) AS Signal_Count
FROM Device
GROUP BY 
	Device_id, 
	Locations),

Topping AS 
(SELECT 
Device_id, 
COUNT(Locations) AS No_of_locations, 
SUM(Signal_Count) No_of_Signals,
(SELECT TOP 1 Locations
FROM Signal_Count AS A
WHERE A.Device_id  = B.Device_id
ORDER BY Signal_Count DESC) AS Max_Signal_Location
FROM Signal_Count AS B
GROUP BY Device_id)

SELECT * FROM Topping;


--7. Write a SQL to find all Employees who earn more than the average salary in their corresponding department. 
-- Return EmpID, EmpName,Salary in your output

CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

SELECT
EmpID,
EmpName, 
Salary,
A.DeptID
FROM Employee AS A
CROSS JOIN 
(SELECT 
	AVG(B.Salary) AvgSalaryPerDepartment, 
	B.DeptID
FROM Employee AS B
GROUP BY B.DeptID) AS B
WHERE A.DeptID <> B.DeptID
AND A.Salary > AvgSalaryPerDepartment;

--8. 
CREATE TABLE Numbers (
    Number INT
);

-- Step 2: Insert values into the table
INSERT INTO Numbers (Number)
VALUES
(25),
(45),
(78);



drop table Tickets
CREATE TABLE Tickets (
    TicketID VARCHAR(10),
    Number INT
);

-- Step 2: Insert the data into the table
INSERT INTO Tickets (TicketID, Number)
VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

;WITH CTE AS 
(SELECT 
COUNT(A.Number) AS NumberCount,
B.TicketID
FROM Numbers A
right JOIN Tickets B
ON A.Number = B.Number
group by B.TicketID)

SELECT 
SUM (CASE
	when NumberCount = 3 then 100
	when NumberCount IN (2, 1) then 10 
	ELSE 0 
END )AS WinningPrize
FROM CTE;


--9. Write an SQL query to find the total number of users and the total amount spent using mobile only, 
-- desktop only and both mobile and desktop together for each date.

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

SELECT * FROM Spending





--10.

CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2)

;WITH RecursiveCTE AS
(SELECT 
	PRODUCT,
	Quantity,
	1 AS QuantityN
FROM Grouped
UNION ALL
SELECT 
	PRODUCT,
	Quantity,
	QuantityN + 1
FROM RecursiveCTE
WHERE Quantity > QuantityN)
SELECT PRODUCT , 1 AS Quantity FROM RecursiveCTE
Order by PRODUCT;


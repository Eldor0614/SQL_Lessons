--------HOMEOWORK NUMBER 16 ---------

--1. Create a numbers table using a recursive query from 1 to 1000.
WITH CTERecursive AS 
(SELECT 
1 AS NUMBER
UNION ALL 
SELECT NUMBER + 1
FROM CTERecursive
WHERE NUMBER < 1000 )
SELECT * FROM CTERecursive
OPTION ( MAXRECURSION 0);

--2. Write a query to find the total sales per employee using a derived table.(Sales, Employees)

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees (EmployeeID, DepartmentID, FirstName, LastName, Salary) VALUES
(1, 1, 'John', 'Doe', 60000.00),
(2, 1, 'Jane', 'Smith', 65000.00),
(3, 2, 'James', 'Brown', 70000.00),
(4, 3, 'Mary', 'Johnson', 75000.00),
(5, 4, 'Linda', 'Williams', 80000.00),
(6, 2, 'Michael', 'Jones', 85000.00),
(7, 1, 'Robert', 'Miller', 55000.00),
(8, 3, 'Patricia', 'Davis', 72000.00),
(9, 4, 'Jennifer', 'García', 77000.00),
(10, 1, 'William', 'Martínez', 69000.00);


CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    EmployeeID INT,
    ProductID INT,
    SalesAmount DECIMAL(10, 2),
    SaleDate DATE
);
INSERT INTO Sales (SalesID, EmployeeID, ProductID, SalesAmount, SaleDate) VALUES
-- January 2025
(1, 1, 1, 1550.00, '2025-01-02'),
(2, 2, 2, 2050.00, '2025-01-04'),
(3, 3, 3, 1250.00, '2025-01-06'),
(4, 4, 4, 1850.00, '2025-01-08'),
(5, 5, 5, 2250.00, '2025-01-10'),
(6, 6, 6, 1450.00, '2025-01-12'),
(7, 7, 1, 2550.00, '2025-01-14'),
(8, 8, 2, 1750.00, '2025-01-16'),
(9, 9, 3, 1650.00, '2025-01-18'),
(10, 10, 4, 1950.00, '2025-01-20'),
(11, 1, 5, 2150.00, '2025-02-01'),
(12, 2, 6, 1350.00, '2025-02-03'),
(13, 3, 1, 2050.00, '2025-02-05'),
(14, 4, 2, 1850.00, '2025-02-07'),
(15, 5, 3, 1550.00, '2025-02-09'),
(16, 6, 4, 2250.00, '2025-02-11'),
(17, 7, 5, 1750.00, '2025-02-13'),
(18, 8, 6, 1650.00, '2025-02-15'),
(19, 9, 1, 2550.00, '2025-02-17'),
(20, 10, 2, 1850.00, '2025-02-19'),
(21, 1, 3, 1450.00, '2025-03-02'),
(22, 2, 4, 1950.00, '2025-03-05'),
(23, 3, 5, 2150.00, '2025-03-08'),
(24, 4, 6, 1700.00, '2025-03-11'),
(25, 5, 1, 1600.00, '2025-03-14'),
(26, 6, 2, 2050.00, '2025-03-17'),
(27, 7, 3, 2250.00, '2025-03-20'),
(28, 8, 4, 1350.00, '2025-03-23'),
(29, 9, 5, 2550.00, '2025-03-26'),
(30, 10, 6, 1850.00, '2025-03-29'),
(31, 1, 1, 2150.00, '2025-04-02'),
(32, 2, 2, 1750.00, '2025-04-05'),
(33, 3, 3, 1650.00, '2025-04-08'),
(34, 4, 4, 1950.00, '2025-04-11'),
(35, 5, 5, 2050.00, '2025-04-14'),
(36, 6, 6, 2250.00, '2025-04-17'),
(37, 7, 1, 2350.00, '2025-04-20'),
(38, 8, 2, 1800.00, '2025-04-23'),
(39, 9, 3, 1700.00, '2025-04-26'),
(40, 10, 4, 2000.00, '2025-04-29'),
(41, 1, 5, 2200.00, '2025-05-03'),
(42, 2, 6, 1650.00, '2025-05-07'),
(43, 3, 1, 2250.00, '2025-05-11'),
(44, 4, 2, 1800.00, '2025-05-15'),
(45, 5, 3, 1900.00, '2025-05-19'),
(46, 6, 4, 2000.00, '2025-05-23'),
(47, 7, 5, 2400.00, '2025-05-27'),
(48, 8, 6, 2450.00, '2025-05-31'),
(49, 9, 1, 2600.00, '2025-06-04'),
(50, 10, 2, 2050.00, '2025-06-08'),
(51, 1, 3, 1550.00, '2025-06-12'),
(52, 2, 4, 1850.00, '2025-06-16'),
(53, 3, 5, 1950.00, '2025-06-20'),
(54, 4, 6, 1900.00, '2025-06-24'),
(55, 5, 1, 2000.00, '2025-07-01'),
(56, 6, 2, 2100.00, '2025-07-05'),
(57, 7, 3, 2200.00, '2025-07-09'),
(58, 8, 4, 2300.00, '2025-07-13'),
(59, 9, 5, 2350.00, '2025-07-17'),
(60, 10, 6, 2450.00, '2025-08-01');

SELECT E.EmployeeID, E.FirstName, E.LastName, SC.SaleCount FROM Employees AS E
LEFT JOIN
(SELECT 
S.EmployeeID, 
COUNT(S.SalesID) AS SaleCount
FROM Sales AS S
GROUP BY S.EmployeeID) AS SC
ON SC.EmployeeID = E.EmployeeID;

--3. Create a CTE to find the average salary of employees.(Employees)

WITH CTEAvgSalary AS 
(SELECT 
AVG(Salary) AS AvgSalary
FROM Employees)

select AvgSalary FROM CTEAvgSalary;

--4. Write a query using a derived table to find the highest sales for each product.(Sales, Products)

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    CategoryID INT,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, CategoryID, ProductName, Price) VALUES
(1, 1, 'Laptop', 1000.00),
(2, 1, 'Smartphone', 800.00),
(3, 2, 'Tablet', 500.00),
(4, 2, 'Monitor', 300.00),
(5, 3, 'Headphones', 150.00),
(6, 3, 'Mouse', 25.00),
(7, 4, 'Keyboard', 50.00),
(8, 4, 'Speaker', 200.00),
(9, 5, 'Smartwatch', 250.00),
(10, 5, 'Camera', 700.00);

SELECT 
P.ProductID, 
P.ProductName, 
S.TheHighest_Price
FROM Products AS P
JOIN 
(SELECT 
S.ProductID, 
MAX(S.SalesAmount) AS TheHighest_Price
FROM Sales AS S
GROUP BY ProductID) AS S
ON P.ProductID = S.ProductID;

--5. Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.
WITH CteRECURSIVE AS 
(SELECT 
1 AS RECORDING 
UNION ALL
SELECT RECORDING * 2
FROM CteRECURSIVE 
WHERE RECORDING < 1000000 )

SELECT * FROM CteRECURSIVE
OPTION ( MAXRECURSION 0);

--6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
WITH CTE AS 
(SELECT
S.EmployeeID,
COUNT(S.SalesID) AS SaleCount
FROM Sales AS S
GROUP BY EmployeeID
HAVING COUNT(S.SalesID) > 5
)

SELECT CTE.EmployeeID, E.FIRSTNAME, E.LASTNAME, CTE.SaleCount FROM CTE
JOIN Employees AS E
ON CTE.EmployeeID = E.EMPLOYEEID


--7. Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

WITH CTE AS 
(SELECT  
ProductID, 
SUM(SalesAmount) AS Total_Sale
FROM Sales AS S
GROUP BY ProductID
having SUM(SalesAmount) > 500)

SELECT P.ProductID, P.ProductName, Cte.Total_Sale FROM CTE 
JOIN products AS P 
ON CTE.ProductID = P.ProductID;

--8. Create a CTE to find employees with salaries above the average salary.(Employees)
WITH CTE AS 
(SELECT 
FirstName, 
LastName, 
Salary 
FROM Employees)

SELECT * FROM CTE
WHERE CTE.SALARY > (SELECT AVG(Salary) FROM Employees);

---Medium ----
--9. Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

SELECT TOP 5 
E.FirstName, 
E.LastName, 
A.EmployeeID, 
A.OrderCount
FROM 
	(SELECT EmployeeID, COUNT(SalesID) AS OrderCount FROM Sales GROUP BY EmployeeID ) AS A
JOIN Employees AS E
ON A.EmployeeID = E.EmployeeID
ORDER BY OrderCount DESC

--10. Write a query using a derived table to find the sales per product category.(Sales, Products)
SELECT 
SUM(B.ProductSales) AS ProductSales,
A.CategoryID
FROM Products AS A 
JOIN 
(SELECT
	ProductID,
	SUM(SalesAmount) as ProductSales
	FROM Sales
	GROUP BY ProductID) AS B
ON A.ProductID = B.ProductID
GROUP BY A.CategoryID


--11. Write a script to return the factorial of each value next to it.(Numbers1)

CREATE TABLE Numbers1(Number INT)

INSERT INTO Numbers1 VALUES (5),(9),(8),(6),(7)
SELECT * FROM Numbers1

DECLARE @MaxNumber int = (SELECT MAX(Number) FROM Numbers1);


WITH FactorialCTE AS 
(SELECT 
	CAST(1 AS BIGINT) AS Number,
	CAST(1 AS BIGINT) AS FactorialResult
UNION ALL

SELECT 
	F.Number + 1, 
	F.FactorialResult * (F.Number + 1)
FROM FactorialCTE AS F
WHERE F.Number < @MaxNumber
)

SELECT 
	t.Number,
	CTE.FactorialResult
FROM Numbers1 AS T
JOIN FactorialCTE AS CTE
ON T.Number = CTE.Number
ORDER BY t.Number;


--12.This script uses recursion to split a string into rows of substrings
-- for each character in the string.(Example)


CREATE TABLE Example
(
Id       INTEGER IDENTITY(1,1) PRIMARY KEY,
String VARCHAR(30) NOT NULL
);


INSERT INTO Example VALUES('123456789'),('abcdefghi');

;WITH CharSplitter AS 
( SELECT 1 AS POSITION,
SUBSTRING (String, 1, 1) AS Character,
SUBSTRING(String, 2, LEN(String) - 1) AS RemainingString
FROM Example 
WHERE LEN(String) > 0

UNION ALL

SELECT 
POSITION + 1,
SUBSTRING(RemainingString, 1, 1),
SUBSTRING(RemainingString, 2, LEN(RemainingString) - 1)
FROM CharSplitter
WHERE LEN(RemainingString) > 0)


SELECT POSITION, Character FROM CharSplitter
ORDER BY Character      --- BU KOD BILAN QANDAY QILIB BIR COLUMN DAGI STRINGLARNI BUSTRING QILIB QATORLARGA AJRATILDI  

--13. Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

SELECT 
YEAR(SaleDate) AS SaleYear, 
MONTH(SaleDate)AS SaleMonth, 
SUM(SalesAmount) AS CurrenTMonthSales, 
LAG(SUM(SalesAmount), 1, 0) OVER (ORDER BY YEAR(SaleDate), MONTH(SaleDate)) AS PreviousMonthSales,
SUM(SalesAmount) -  LAG(SUM(SalesAmount), 1, 0) OVER (ORDER BY YEAR(SaleDate), MONTH(SaleDate)) AS SalesDifference
FROM Sales
GROUP BY 
YEAR(SaleDate), 
MONTH(SaleDate)
ORDER BY SaleYear, SaleMonth;

--14. Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)
select * from Sales
select * from Employees
SELECT 
A.EmployeeID, 
E.FirstName, 
E.LastName, 
A.Quarter, 
A.TotalSalesPerQuarter
FROM 
(select 
DATEPART(QUARTER, SaleDATE ) AS Quarter, 
EmployeeID, 
SUM(SalesAmount) AS TotalSalesPerQuarter
FROM Sales
GROUP BY DATEPART(QUARTER, SaleDATE ), EmployeeID
HAVING SUM(SalesAmount) > 45000) AS A

JOIN Employees AS E
ON E.EmployeeID = A.EmployeeID
ORDER BY A.Quarter;

--15. This script uses recursion to calculate Fibonacci numbers

WITH CTEFibanaccia (N, NEXTN )AS 
(SELECT 0,1
UNION ALL
SELECT NEXTN, N + NEXTN
FROM CTEFibanaccia
WHERE NEXTN < 10)

SELECT * FROM CTEFibanaccia;

--16. Find a string where all characters are the same and the length is 
-- greater than 1.(FindSameCharacters)
CREATE TABLE FindSameCharacters
(
     Id INT
    ,Vals VARCHAR(10)
)
 
INSERT INTO FindSameCharacters VALUES
(1,'aa'),
(2,'cccc'),
(3,'abc'),
(4,'aabc'),
(5,NULL),
(6,'a'),
(7,'zzz'),
(8,'abc')

SELECT 
Vals
FROM FindSameCharacters
WHERE Vals = REPLICATE(LEFT(Vals, 1), LEN(Vals));


--17. Create a numbers table that shows all numbers 1 through n and
-- ir order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)

WITH RecursiveCTE AS
(SELECT
1 AS NUMBER,
CAST('1 ' AS varchar(MAX))AS Sequence

UNION ALL
SELECT 
NUMBER + 1,
Sequence+CAST(NUMBER+1 AS VARCHAR)
FROM RecursiveCTE
WHERE NUMBER < 5)

SELECT * FROM 
RecursiveCTE;

--18. Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

SELECT A.EmployeeID, A.LastSixMonth, A.TotalSales, E.FirstName, E.LastName
FROM
(
SELECT TOP 1
EmployeeID, 
DATEADD(MONTH, -6,  GETDATE()) AS LastSixMonth,
SUM(SalesAmount) AS TotalSales
FROM Sales
WHERE SaleDate >= DATEADD(MONTH, -6,  GETDATE())
GROUP BY 
EmployeeID
ORDER BY TotalSales DESC) AS A

JOIN Employees AS E
ON E.EMPLOYEEID = A.EMPLOYEEID;

--19. Write a T-SQL query to remove the duplicate integer values present in the string column. 
-- Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)


CREATE TABLE RemoveDuplicateIntsFromNames
(
      PawanName INT
    , Pawan_slug_name VARCHAR(1000)
)
 
 
INSERT INTO RemoveDuplicateIntsFromNames VALUES
(1,  'PawanA-111'  ),
(2, 'PawanB-123'   ),
(3, 'PawanB-32'    ),
(4, 'PawanC-4444' ),
(5, 'PawanD-3'  )

SELECT * FROM RemoveDuplicateIntsFromNames
;WITH CTE AS (SELECT
SUBSTRING(Pawan_slug_name, PATINDEX('%[0-9]%', Pawan_slug_name), LEN(Pawan_slug_name)) AS SeperatedInt
FROM RemoveDuplicateIntsFromNames)
SELECT * FROM CTE
CROSS APPLY string_split(SeperatedInt, ' ',1)

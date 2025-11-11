-----HOMEWORK NUMBER 20 ----
CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

SELECT * FROM #Sales as a
WHERE EXISTS 
(
SELECT 1
FROM #Sales AS B
WHERE 
	a.SaleID = B.SaleID AND
	YEAR(B.SaleDate) = 2024 AND
	MONTH(B.SaleDate) = 3  AND
	B.Quantity >= 1);
	
--2.  Find the product with the highest total sales revenue using a subquery.
SELECT TOP 1 * FROM 
(
SELECT
	PRODUCT, 
	SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY PRODUCT) AS A
ORDER BY TotalRevenue;

--3.  Find the second highest sale amount using a subquery

SELECT *, Ranking FROM 
(SELECT 
*, 
ROW_NUMBER () OVER (ORDER BY Price desc) AS Ranking
FROM #Sales) AS A
WHERE Ranking = 2;

--4. Find the total quantity of products sold per month using a subquery
SELECT * FROM 
(
SELECT 
SUM(Quantity) AS CountQuantity,
MONTH(SaleDate) AS Months
FROM #Sales
GROUP BY MONTH(SaleDate)) AS B;

--5.Find customers who bought same products as another customer using EXISTS

SELECT * FROM #Sales


select 
	CustomerName
	Product
FROM #Sales AS A
WHERE EXISTS (
SELECT 
	1
FROM #Sales AS B
WHERE A.Product = B.Product AND 
A.CustomerName <> B.CustomerName);

--6. 
create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

SELECT Name,[APPLE], [ORANGE ], [BANANA]
FROM (SELECT Name, Fruit FROM Fruits)AS SourseTable
PIVOT
(COUNT (Fruit) FOR Fruit IN ([APPLE], [ORANGE ], [BANANA]))AS PivotTable;


--7. Return older people in the family with younger ones
create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)


;WITH RecursiveCte AS 
(Select 
ParentId, 
ChildId 
FROM Family
UNION ALL
SELECT 
RC.ParentId, 
F2.ChildID 
FROM RecursiveCte AS RC
JOIN Family AS F2
ON  RC.ChildID = F2.ParentId)

SELECT * FROM RecursiveCte
ORDER BY ParentId;

--8.

CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

SELECT 
* FROM #Orders AS A
WHERE A.DeliveryState = 'TX' AND
exists 
(SELECT * FROM #Orders AS B
WHERE A.CustomerID = B.CustomerID AND B.DeliveryState = 'CA');

--9. Insert the names of residents if they are missing
create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')


UPDATE #residents
SET address = address + ' ' + 'name' + '='+ fullname
WHERE ADDRESS NOT LIKE '%name%';



--10. Write a query to return the route to reach from Tashkent to Khorezm. 
-- The result should include the cheapest and the most expensive routes
CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);
SELECT * FROM #Routes

;WITH RecursiveRouteKhorazm AS 
(
    SELECT 
        CAST(A.DepartureCity + '-' + A.ArrivalCity AS VARCHAR(MAX)) AS RouteToKhorazm, 
        A.Cost AS TotalCost
    FROM #Routes AS A
    WHERE A.DepartureCity = 'Tashkent'

    UNION ALL

    SELECT 
        CAST(RC.RouteToKhorazm + '-' + A.ArrivalCity AS VARCHAR(MAX)) AS RouteToKhorazm,
        RC.TotalCost + A.Cost AS TotalCost
    FROM RecursiveRouteKhorazm AS RC
    INNER JOIN #Routes AS A
        ON REVERSE(LEFT(REVERSE(RC.RouteToKhorazm),
           CHARINDEX('-', REVERSE(RC.RouteToKhorazm)) - 1)) = A.DepartureCity
), 
All_RoutesToKhorazm AS(
SELECT  
	RouteToKhorazm,
	TotalCost
FROM RecursiveRouteKhorazm
WHERE REVERSE(LEFT(REVERSE(RouteToKhorazm),
      CHARINDEX('-', REVERSE(RouteToKhorazm)) - 1)) = 'Khorezm')

SELECT 
*
FROM All_RoutesToKhorazm
WHERE TotalCost IN ((SELECT MAX(TotalCost) FROM All_RoutesToKhorazm ),
					(SELECT MIN(TotalCost) FROM All_RoutesToKhorazm));


--11. 
CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')


;WITH CTE AS (SELECT 
	ID,
	Vals,
	CASE 
		WHEN Vals = 'Product' THEN 1 ELSE 0 
	END AS Marker
FROM #RankingPuzzle)

SELECT 
*, 
SUM(Marker) OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS ProductRanking
FROM CTE;

--12. Find employees whose sales were higher than the average sales in their department
CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

SELECT 
*
FROM #EmployeeSales AS A
WHERE A.SalesAmount > (SELECT AVG(B.SalesAmount) FROM #EmployeeSales AS B WHERE A.Department = B.Department);

--13. Find employees who had the highest sales in any given month using EXISTS
SELECT 
* FROM #EmployeeSales AS A
WHERE A.SalesAmount = (SELECT MAX(B.SalesAmount) from  #EmployeeSales AS b
WHERE A.salesMonth = B.salesMonth )

--14.  Find employees who made sales in every month using NOT EXISTS

CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

SELECT 
	EmployeeID, 
	A.EmployeeName
FROM #EmployeeSales AS A
WHERE NOT EXISTS 
(SELECT DISTINCT SalesMonth FROM #EmployeeSales AS B
WHERE B.SalesMonth NOT IN 
(SELECT SalesMonth FROM #EmployeeSales AS C WHERE C.EmployeeID = A.EmployeeID));
--15. 

CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

SELECT 
* FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

--16. Find the products that have a stock count lower than the highest stock count.
;WITH LowerStockCount AS (
SELECT 
	ProductID,
	Name, 
	Category,
	Price, 
	SUM(Stock) AS TotalStockCount 
FROM Products
GROUP BY ProductID, Name, Category,Price),

FindingMaxStockCount AS (SELECT 
	MAX(TotalStockCount) AS MaxStockCount FROM LowerStockCount)

SELECT 
	L.ProductID,
	L.Name, 
	L.Category,
	L.Price, 
	L.TotalStockCount
FROM LowerStockCount AS L
CROSS JOIN FindingMaxStockCount AS M
WHERE L.TotalStockCount < M.MaxStockCount;

--17.  Get the names of products that belong to the same category as 'Laptop'.

SELECT Name, A.Category FROM Products AS A
WHERE A.Category = (
SELECT Category FROM Products AS B
WHERE Name = 'Laptop' );

--18.Retrieve products whose price is greater than the lowest price in the Electronics category.

SELECT * 
FROM Products
WHERE price > (SELECT MIN(price) FROM Products WHERE Category = 'Electronics')
AND Category <> 'Electronics';

--19.Find the products that have a higher price than the average price of their respective category.

Select 
* FROM Products AS A
WHERE Price >
(
SELECT 
	AVG(price) AS AvgPriceByCategory
FROM Products AS B WHERE A.Category = B.Category);

--20. Find the products that have been ordered at least once.

CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    Constraint Fk_Orders FOREIGN KEY (ProductID) REFERENCES Products(ProductID) 
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');

SELECT 
* FROM Products AS P
WHERE EXISTS (SELECT 1 FROM Orders AS O
WHERE O.ProductID = P.ProductID);

--21. Retrieve the names of products that have been ordered more than the average quantity ordered.

SELECT 
	P.Name, 
	O.OrderID, 
	SUM(O.Quantity)
FROM Products AS P
JOIN Orders AS O
	ON P.ProductID = O.ProductID
GROUP BY P.Name, O.OrderID
	HAVING SUM(O.Quantity) > (SELECT AVG(Quantity) FROM Orders);

--22. Find the products that have never been ordered.
SELECT 
* FROM Products AS P
WHERE NOT EXISTS (SELECT 1 FROM Orders AS O WHERE O.ProductID = P.ProductID);

--23.  Retrieve the product with the highest total quantity ordered.
SELECT TOP 1
P.Name,
SUM(O.Quantity) AS TotalQuantity
FROM Products AS P
JOIN Orders AS O
ON P.ProductID = O.ProductID
GROUP BY P.Name
ORDER BY TotalQuantity DESC;



-----------
SELECT * FROM #EmployeeSales

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50)
);

CREATE TABLE Sales (
    SaleID INT IDENTITY,
    EmployeeID INT,
    ProductID INT,
    SaleAmount DECIMAL(10,2),
    SaleMonth VARCHAR(15),
    SaleDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Employees VALUES 
(1, 'Ali'),
(2, 'Laylo'),
(3, 'Jasur');

INSERT INTO Sales (EmployeeID, ProductID, SaleAmount, SaleMonth, SaleDate) VALUES
(1, 101, 1200, 'January', '2024-01-15'),
(1, 102, 900,  'February', '2024-02-12'),
(1, 103, 1500, 'March', '2024-03-09'),

(2, 101, 800,  'February', '2024-02-14'),
(2, 102, 700,  'March', '2024-03-10'),

(3, 103, 1300, 'January', '2024-01-20'),
(3, 101, 1400, 'February', '2024-02-22'),
(3, 102, 1600, 'March', '2024-03-17');


SELECT * FROM Employees
SELECT * FROM Sales

SELECT * FROM Employees AS E
LEFT JOIN Sales AS S
ON E.EmployeeID = S.EmployeeID
WHERE E.EmployeeID IS NULL


SELECT 
	EmployeeName
FROM Employees AS A
WHERE NOT EXISTS (SELECT * FROM Sales AS S
WHERE A.EmployeeID = S.EmployeeID)

--2. 
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY,
    ProductID INT,
    CustomerID INT,
    Quantity INT,
    OrderDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products VALUES 
(101, 'Laptop', 'Electronics', 1500),
(102, 'Phone', 'Electronics', 900),
(103, 'Tablet', 'Electronics', 1200),
(104, 'Shoes', 'Clothing', 120),
(105, 'Jacket', 'Clothing', 220),
(106, 'Watch', 'Accessories', 300);

INSERT INTO Orders (ProductID, CustomerID, Quantity, OrderDate) VALUES
(101, 1, 2, '2024-01-05'),
(102, 1, 1, '2024-01-10'),
(103, 2, 3, '2024-02-05'),
(104, 3, 5, '2024-02-12'),
(105, 1, 2, '2024-03-01'),
(106, 3, 1, '2024-03-05'),
(101, 2, 1, '2024-03-10');

SELECT * FROM products
SELECT * FROM orders

SELECT DISTINCT 
	MONTH(OrderDate) AS DistinctMonths
FROM orders


SELECT ProductName
FROM products AS P
WHERE NOT EXISTS (
SELECT DISTINCT 
	MONTH(OrderDate) AS DistinctMonths
FROM orders AS O
WHERE MONTH(OrderDate) NOT IN (SELECT ProductName, O.OrderDate
FROM products AS P
JOIN orders AS O
ON P.ProductID = O.OrderID ))





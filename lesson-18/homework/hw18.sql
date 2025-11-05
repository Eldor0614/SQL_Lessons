---HOMEWORK NUMBER 18 ----

--1,
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

GO
WITH CTE AS 
(SELECT 
	P.ProductID, 
	p.ProductName, 
	P.Price, 
	S.SaleID, 
	S.Quantity, 
	DATEPART(MONTH, S.SaleDate) AS SalesInMonth,
	YEAR(SaleDate) AS CurrentYear
FROM Products AS P
INNER JOIN Sales AS S
	ON P.ProductID = S.ProductID
WHERE YEAR(SaleDate) = 2025)
	

SELECT 
	ProductID, 
	SUM(Quantity) AS Total_Quantity, 
	SUM(Price * Quantity) AS Total_Revenue, 
	SalesInMonth 
	into #MonthLySales
FROM CTE 
GROUP BY ProductID, SalesInMonth

select * from #MonthLySales;

--2. . Create a view named vw_ProductSalesSummary that returns product info 
-- along with total sales quantity across all time.
DROP VIEW vw_ProductSalesSummary
GO
CREATE VIEW vw_ProductSalesSummary
AS 
SELECT 
	P.ProductID, 
	P.ProductName, 
	ISNULL(SUM(S.Quantity), 0) AS TotalSalesQuantity
FROM Products AS P
LEFT JOIN Sales AS S
	ON P.ProductID = S.ProductID
GROUP BY 
	P.ProductID, 
	P.ProductName

	select * from vw_ProductSalesSummary;

--3. . Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
GO
CREATE OR ALTER FUNCTION  dbo.GetTotalRevenueForProduct(@ProductID INT)
RETURNS TABLE
AS
RETURN 
	(SELECT 
		P.ProductID, 
		SUM(P.Price * S.Quantity) AS TotalRevenue
		FROM Products AS P 
		JOIN Sales AS S
		ON P.ProductID = S.ProductID
		WHERE P.ProductID = @ProductID
		GROUP BY P.ProductID);
GO

SELECT * FROM GetTotalRevenueForProduct(3);

--4. Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
go
CREATE OR ALTER FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE 
AS 
RETURN 
	(SELECT 
		P.ProductName, 
		S.Quantity AS TotalQuantity,
		SUM(P.Price * S.Quantity) AS TotalRevenue
	FROM Products AS P 
	JOIN Sales AS S
	ON P.ProductID = S.ProductID
	WHERE P.Category = @Category
	GROUP BY P.ProductName, S.Quantity
	);

GO

SELECT * FROM fn_GetSalesByCategory('Electronics');

--5. You have to create a function that get one argument as input from user and the function should return 'Yes' 
-- if the input number is a prime number and 'No' otherwise. You can start it like this:

create function dbo.prime_checking (@check_prime INT)
returns varchar(50)
as 
begin
declare @devisor int = 2 
while @devisor * @devisor <=@check_prime
begin 
if @check_prime % @devisor = 0 
return 'no'
set @devisor = @devisor + 1
end 
return 'yes'
end

declare @check_prime int = 13
select dbo.prime_checking (@check_prime) AS NumberType;

--6. Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:

CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS TABLE 
AS 
RETURN
( WITH RecursiveCTE AS (
SELECT @Start AS NUMBER 
UNION ALL
SELECT NUMBER + 1
FROM RecursiveCTE 
WHERE NUMBER <  @End)
SELECT NUMBER FROM RecursiveCTE 
);


SELECT * FROM fn_GetNumbersBetween (11, 22);

--7.  Write a SQL query to return the Nth highest distinct salary from the Employee table. 
--If there are fewer than N distinct salaries, return NULL.
--SELECT * FROM Employees
GO
CREATE OR ALTER FUNCTION dbo.fn_GetSalaryByRank (@numb INT)
RETURNS TABLE 
AS 
RETURN 
(
WITH CTE AS (
SELECT 
*, 
DENSE_RANK () OVER (ORDER BY  Salary DESC)AS DenseRanking
FROM employees )

SELECT DISTINCT
	CASE 
		WHEN @numb IN (SELECT DenseRanking FROM CTE ) THEN Salary 
		ELSE NULL
	END Salary
FROM CTE
WHERE @numb = DenseRanking OR @numb > (SELECT DISTINCT  MAX(DenseRanking) FROM CTE))

SELECT * FROM dbo.fn_GetSalaryByRank (11);

--8.

CREATE TABLE RequestAccepted (
    requester_id INT,
    accepter_id INT,
    accept_date DATE
);

-- Insert sample data
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date)
VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09');

SELECT * FROM RequestAccepted

;WITH CTE AS (SELECT  requester_id, accepter_id
FROM RequestAccepted
UNION ALL
SELECT accepter_id, requester_id
FROM RequestAccepted)

SELECT TOP 1
requester_id,
COUNT(accepter_id) AS FriendCount
FROM CTE
GROUP BY 
requester_id
ORDER BY FriendCount DESC;


--9. 

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);

CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
	O.customer_id, 
	C.name,
	COUNT(O.order_id) AS total_orders, 
	SUM(O.amount) AS total_amount, 
	MAX(order_date) AS last_order_date
FROM Customers AS C
LEFT JOIN Orders AS O
	ON C.customer_id = O.customer_id
GROUP BY 
	O.customer_id, 
	C.name

	SELECT * FROM vw_CustomerOrderSummary;

--10

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,NULL),(8,NULL),(9,NULL),(10,'Charlie'), (11, NULL), (12, NULL)


SELECT ROWNUMBER,(SELECT MAX(TESTCASE) FROM Gaps B WHERE  B.RowNumber <= A.RowNumber) AS TESTCASE  FROM Gaps AS A;




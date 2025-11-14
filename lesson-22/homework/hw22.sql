	---HOMEWORK NUMBER 22 ------

--1.Compute Running Total Sales per Customer
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

	SELECT 
	*,
	SUM(Total_amount) OVER (PARTITION BY Customer_id ORDER BY Sale_id) AS RunningTotalSales
	FROM sales_data
	order by Customer_id;

--2.Count the Number of Orders per Product Category
SELECT 
	Product_Category, 
	SUM(Quantity_Sold)
FROM sales_data
GROUP BY Product_Category

--3.Find the Maximum Total Amount per Product Category
;WITH CTE AS (SELECT 
product_name,
Product_category, 
Total_amount,
DENSE_RANK() OVER (PARTITION BY Product_category ORDER BY Total_amount DESC) AS RankingTotalAmount
FROM sales_data)
SELECT * FROM CTE
WHERE RankingTotalAmount = 1;

--4. Find the Minimum Price of Products per Product Category
SELECT 
	Product_name, 
	Product_Category, 
	Unit_Price
	FROM (SELECT *,
	MIN(unit_price) OVER (PARTITION BY Product_Category ORDER BY Unit_Price ASC) AS MinPricePerCategory 
FROM sales_data) as a
WHERE Unit_Price = MinPricePerCategory;

--5. Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)
SELECT 
	sale_id, 
	customer_id, 
	customer_name, 
	product_name, 
	total_amount, 
	CAST(ROUND(AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING),2)AS decimal(10,2)) AS MovingAvg3Days,
	order_date
FROM sales_data;

--6. Find the Total Sales per Region
SELECT DISTINCT
	Region, 
	TotalSalesPerRegion
FROM (
SELECT
	region, 
	SUM(total_amount) OVER (PARTITION BY region) AS TotalSalesPerRegion
FROM sales_data
) AS TS;

--7. Compute the Rank of Customers Based on Their Total Purchase Amount

SELECT 
	Customer_id, 
	TotalAmount, 
	DENSE_RANK() OVER (ORDER BY TotalAmount DESC) AS RankOnTotalSales
FROM ( SELECT Customer_id, SUM(Total_amount) AS TotalAmount FROM sales_data GROUP BY Customer_id) AS TA;

--8. Calculate the Difference Between Current and Previous Sale Amount per Customer
;WITH CTE AS (SELECT 
	Customer_id, 
	Total_amount, 
	LAG(Total_amount) OVER (PARTITION BY Customer_id ORDER BY Customer_id ) AS PreviousSale, 
	(Total_amount - 	LAG(Total_amount) OVER (PARTITION BY Customer_id ORDER BY Customer_id )) AS diff
FROM sales_data)
SELECT 
*, 
CASE 
	WHEN Diff IS NULL  THEN 'OnlyOneSale'
	when diff like '-%' THEN 'Growth'
	ELSE 'Decline'
END AS Evaluation
	FROM CTE;

--9. Find the Top 3 Most Expensive Products in Each Category

WITH CTE AS 
(SELECT *,
	DENSE_RANK () OVER (PARTITION BY Product_Category Order by Unit_Price DESC) AS PriceRanking
FROM sales_data)

Select 
	Product_Name, 
	product_category,
	Unit_Price,
	PriceRanking
FROM CTE
WHERE PriceRanking <= 3;

--10. Compute the Cumulative Sum of Sales Per Region by Order Date

Select 
	Region, 
	Total_amount, 
	SUM(Total_amount) OVER (PARTITION BY Region ORDER BY Order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeTotalSales
FROM sales_data;

--11.Compute Cumulative Revenue per Product Category

;WITH CTE AS 
	(SELECT 
	product_category,
	Product_name, 
	SUM(Total_Amount) AS TotalRevenue
FROM sales_data 
Group by Product_name, product_category)
SELECT  
	product_category,
	product_name,
	TotalRevenue,
	SUM(TotalRevenue) OVER (PARTITION BY product_category ORDER BY product_category ASC 
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeAmount
FROM CTE;

--12.
CREATE TABLE Numbers (
    ID INT
);

INSERT INTO Numbers (ID)
VALUES (1), (2), (3), (4), (5);

SELECT *, 
SUM (ID) OVER (Order by ID ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SumPreValues
FROM Numbers;

--13. Sum of Previous Values to Current Value
CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

SELECT 
	*, 
	SUM (Value) OVER (Order by Value ASC ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS SumPreValues
FROM OneColumn

--14. Find customers who have purchased items from more than one product_category

SELECT 
	customer_id, 
	COUNT(DISTINCT product_category) AS CategoryCount
FROM sales_data
Group by customer_id
HAVING COUNT(DISTINCT product_category) > 1;

--15. Find Customers with Above-Average Spending in Their Region
WITH CTE AS (SELECT 
	customer_id,
	region,
	SUM(Total_amount) AS TotalSales, 
	AVG(SUM(Total_amount)) OVER (PARTITION BY region)AS AvgAmountPerRegion 
FROM sales_data AS A
GROUP BY customer_id, region)

SELECT * FROM CTE
WHERE TotalSales > AvgAmountPerRegion;

--16. Rank customers based on their total spending (total_amount) within each region. If multiple customers have the same spending, they should receive the same rank.
SELECT 
	*, 
	DENSE_RANK() OVER (PARTITION BY Region ORDER BY Total_amount DESC) AS RankSpending
FROM sales_data;

--17. Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.
SELECT 
*,
	SUM(Total_amount) OVER (Partition by Customer_id ORDER BY order_date   ROWS BETWEEN UNBOUNDED PRECEDING AND current row) AS CumulativeAmount
FROM sales_data

--18. Calculate the sales growth rate (growth_rate) for each month compared to the previous month.

SELECT 
	YEAR(order_date), 
	month(order_date)
FROM sales_data

SELECT * FROM sales_data

--19. Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)
;WITH CTE AS 
	(SELECT 
		*, 
		LAG(total_amount) over (PARTITION BY customer_id ORDER BY customer_id) AS PreviousOrder
	FROM sales_data)
SELECT * FROM CTE
WHERE total_amount > PreviousOrder;

--20. Identify Products that prices are above the average product price
SELECT
	*
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

--21. 

CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

;WITH CTE AS (SELECT 
	Grp,
	SUM(Val1 + Val2) AS Tot
FROM MyData 
GROUP BY Grp), 
	CTE2 AS 
		(SELECT 
		B.Grp, 
		B.Val1, 
		B.Val2, 
		A.Tot, 
	ROW_NUMBER () OVER (PARTITION BY A.Grp ORDER BY (SELECT NULL))AS RN
	FROM MyData AS B 
	RIGHT JOIN CTE AS A
	ON B.Grp = A.Grp) 
SELECT 
	Grp, 
	Val1, 
	Val2, 
	CASE 
		WHEN RN = 1 THEN Tot ELSE NULL END AS TOT
FROM CTE2;

--22.

CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

;WITH CTE AS (SELECT 
ID,
SUM(Quantity) AS Quantity
FROM (
SELECT DISTINCT Quantity AS QUANTITY, ID FROM TheSumPuzzle) AS Q
GROUP BY ID),

CTE2 AS (SELECT 
	ID,
	SUM(Cost) AS Cost
FROM TheSumPuzzle
GROUP BY ID)

SELECT 
	A.ID, 
	B.Cost,
	A.Quantity
FROM CTE AS A
JOIN CTE2 AS B
ON A.ID = B.ID;

--23. 
CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

WITH SeatOrder AS
	(SELECT 
		SeatNumber, 
		LEAD(SeatNumber) OVER (ORDER BY SeatNumber) AS NextSeat
	FROM Seats), 

SeatGaps AS 
	(SELECT 
	1 AS GapStart, 
	SeatNumber - 1 AS GapEnd
	FROM Seats
	WHERE SeatNumber = (SELECT MIN(SeatNumber) FROM Seats)
	AND SeatNumber > 1
	
UNION ALL
	SELECT 
	SeatNumber + 1 AS GapStart, 
	NextSeat - 1 AS GapEnd
	FROM SeatOrder
	WHERE NextSeat IS NOT NULL
	AND NextSeat <> SeatNumber + 1)

SELECT *
	FROM SeatGaps;


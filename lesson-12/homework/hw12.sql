Create table Person (personId int, firstName varchar(255), lastName varchar(255))
Create table Address (addressId int, personId int, city varchar(255), state varchar(255))
Truncate table Person
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen')
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob')
Truncate table Address
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York')
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California')

SELECT 
P.firstName, 
P.lastName, 
A.city, 
A.state 
FROM Person AS P
LEFT JOIN Address AS A
ON P.personId = A.personId;

--2.
Create table Employee (id int, name varchar(255), salary int, managerId int)
Truncate table Employee
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3')
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4')
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL)
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL)

SELECT 
A.name AS EmployeeName
FROM Employee AS A
JOIN Employee AS B
ON B.id = A.managerId
WHERE A.salary > B.salary;

--3. 
DROP TABLE Person
CREATE TABLE Person (id int, email varchar(255)) 
Truncate table Person 
insert into Person (id, email) 
values ('1', 'a@b.com') 
insert into Person (id, email) 
values ('2', 'c@d.com') 
insert into Person (id, email) 
values ('3', 'a@b.com')

SELECT 
A.ID,
A.Email
FROM Person AS A
LEFT JOIN Person AS B
ON A.email = B.email
WHERE A.id <> B.id;

--4.
DROP TABLE Person
CREATE TABLE Person (ID INT PRIMARY KEY,Email VARCHAR(50))
INSERT INTO Person (ID,Email) VALUES
(1,'john@example.com '),
(2,' bob@example.com'),
(3,'john@example.com ')

WITH DuplicateCTE AS (
SELECT 
ID, 
Email,
ROW_NUMBER () OVER (PARTITION BY Email ORDER BY ID) AS TEMP
FROM Person) 

DELETE FROM DuplicateCTE
WHERE TEMP > 1;


--5. 
DROP TABLE girls
CREATE TABLE boys (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

CREATE TABLE girls (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

INSERT INTO boys (Id, name, ParentName) 
VALUES 
(1, 'John', 'Michael'),  
(2, 'David', 'James'),   
(3, 'Alex', 'Robert'),   
(4, 'Luke', 'Michael'),  
(5, 'Ethan', 'David'),    
(6, 'Mason', 'George');  


INSERT INTO girls (Id, name, ParentName) 
VALUES 
(1, 'Emma', 'Mike'),  
(2, 'Olivia', 'James'),  
(3, 'Ava', 'Robert'),    
(4, 'Sophia', 'Mike'),  
(5, 'Mia', 'John'),      
(6, 'Isabella', 'Emily'),
(7, 'Charlotte', 'George');

SELECT DISTINCT
G.ParentName
FROM Girls AS G
WHERE G.ParentName
NOT IN (
SELECT
B.ParentName
FROM boys AS B);

--6. 
USE TSQL2012
GO 



SELECT
A.OrderID,
A.CustID,
SUM(FREIGHT) AS TOTAL_SALES,
LEAST_WEIGHT
FROM Sales.Orders AS A
JOIN
(SELECT
b.orderid,
B.CustID,
MIN(B.FREIGHT) AS LEAST_WEIGHT
FROM Sales.Orders AS B
GROUP BY b.orderid, 
CustID
) as b
ON A.OrderID = B.OrderID
group by A.OrderID,
A.CustID,
LEAST_WEIGHT
having SUM(FREIGHT) > 50;

--7. 
DROP TABLE IF EXISTS Cart1;
DROP TABLE IF EXISTS Cart2;
GO

CREATE TABLE Cart1
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

CREATE TABLE Cart2
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

INSERT INTO Cart1 (Item) VALUES
('Sugar'),('Bread'),('Juice'),('Soda'),('Flour');
GO

INSERT INTO Cart2 (Item) VALUES
('Sugar'),('Bread'),('Butter'),('Cheese'),('Fruit');
GO

SELECT 
C1.Item,
C2.Item
FROM Cart1 AS C1
LEFT JOIN Cart2 AS C2
ON C1.Item = C2.Item
ORDER BY 
	CASE
		WHEN C1.Item = 'SUGAR' THEN 0
		ELSE 1
	END;

--8. 

Create table Customers (id int, name varchar(255))
Create table Orders (id int, customerId int)
Truncate table Customers
insert into Customers (id, name) values ('1', 'Joe')
insert into Customers (id, name) values ('2', 'Henry')
insert into Customers (id, name) values ('3', 'Sam')
insert into Customers (id, name) values ('4', 'Max')
Truncate table Orders
insert into Orders (id, customerId) values ('1', '3')
insert into Orders (id, customerId) values ('2', '1')

SELECT 
C.Name AS Customers		
from Customers AS C
LEFT JOIN Orders AS O
ON C.ID = O.customerId
WHERE O.customerId IS NULL;

--9. 
Create table Students (student_id int, student_name varchar(20))
Create table Subjects (subject_name varchar(20))
Create table Examinations (student_id int, subject_name varchar(20))
Truncate table Students
insert into Students (student_id, student_name) values ('1', 'Alice')
insert into Students (student_id, student_name) values ('2', 'Bob')
insert into Students (student_id, student_name) values ('13', 'John')
insert into Students (student_id, student_name) values ('6', 'Alex')
Truncate table Subjects
insert into Subjects (subject_name) values ('Math')
insert into Subjects (subject_name) values ('Physics')
insert into Subjects (subject_name) values ('Programming')
Truncate table Examinations
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Programming')
insert into Examinations (student_id, subject_name) values ('2', 'Programming')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Programming')
insert into Examinations (student_id, subject_name) values ('13', 'Physics')
insert into Examinations (student_id, subject_name) values ('2', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Math')


SELECT 
S.Student_ID, 
S.student_name,
Sub.Subject_Name, 
count(E.Student_ID) AS attended_exams 
FROM Students AS S
CROSS JOIN Subjects AS SUB
LEFT JOIN Examinations AS E
ON S.student_id = E.student_id
and e.subject_name = sub.subject_name
GROUP BY 
S.Student_ID, 
S.student_name,
Sub.Subject_Name
ORDER BY 
S.Student_ID, 
Sub.Subject_Name;





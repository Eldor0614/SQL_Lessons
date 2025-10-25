CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

SELECT 
name, 
salary
from employees
where salary =
	(SELECT MIN(salary) AS MIN_Salary FROM employees);

--2. Retrieve products priced above the average price. Tables: products (columns: id, product_name, price)

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

SELECT 
product_name,
price
FROM products
WHERE price > (
SELECT AVG(Price) FROM products);


--3. . Find Employees in Sales Department Task:
--Retrieve employees who work in the "Sales" department. Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);

SELECT 
e.Department_id,
e.name, 
d.Department_name 
FROM employees AS e
JOIN departments AS d
	on e.Department_id = d.id
where  d.department_name = 'Sales';

--4.  Retrieve customers who have not placed any orders. 
--Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');



INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);

SELECT
C.customer_id, 
C.name, 
O.order_id
FROM customers AS C
LEFT JOIN orders AS O
ON C.customer_id = O.customer_Id
WHERE O.order_id IS NULL;

--5.  Retrieve products with the highest price in each category. Tables: products (columns: id, product_name, price, category_id)

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);


SELECT 
p.ID, 
p.product_name, 
p.price, 
p.category_id 
FROM products as p
WHERE price  = (SELECT MAX(Price) as Max_price FROM products as p2 where p2.category_id = p.category_id );


--6. Retrieve employees working in the department with the highest average salary. 
--Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);

SELECT 
a.name, 
b.Avg_Salary,
d.department_name 
FROM employees AS A
join 
(SELECT TOP 1
AVG(Salary) Avg_Salary, 
Department_id
FROM employees AS B
GROUP BY Department_id
Order by  AVG(Salary) desc )as b
on A.DEPARTMENT_ID = B.DEPARTMENT_ID
JOIN departments AS D
ON A.DEPARTMENT_ID = D.id;

--7.  Retrieve employees earning more than the average salary in their department. 
-- Tables: employees (columns: id, name, salary, department_id)

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);

SELECT 
*
FROM employees AS A
WHERE SALARY > (SELECT AVG(salary) AS Avg_Salary FROM Employees AS B  WHERE  A.DEPARTMENT_ID = B.DEPARTMENT_ID);

--8. Retrieve students who received the highest grade in each course. 
-- Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);



SELECT 
S.name, 
G.course_id, 
G.grade
FROM students AS S
JOIN grades AS G
ON S.student_id = G.student_id
WHERE G.grade = (SELECT MAX(G2.grade) from grades AS G2 where G.course_id = g2.course_id);

--9. Find Third-Highest Price per Category Task: Retrieve products with the third-highest price in each category. 
-- Tables: products (columns: id, product_name, price, category_id)
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);

SELECT 
*
FROM (
SELECT 
ID, 
Product_name, 
price, 
RANK() OVER (PARTITION BY category_id ORDER BY price DESC ) AS RANKING_SALARY 
FROM products) AS A
WHERE A.RANKING_SALARY = 3;

--10. Retrieve employees with salaries above the company average but below the maximum in their department. 
-- Tables: employees (columns: id, name, salary, department_id)

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);

SELECT 
ID, 
name, 
salary,
department_id
FROM employees AS A
WHERE salary > (SELECT AVG(salary) AS Company_AvgSalary FROM employees)
AND salary < (SELECT MAX(salary) AS Department_MaxSalary FROM employees AS B WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID);

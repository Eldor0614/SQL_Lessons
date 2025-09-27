
CREATE TABLE InputTbl (
    col1 VARCHAR(10),
    col2 VARCHAR(10)
);
    INSERT INTO InputTbl (col1, col2) VALUES 
('a', 'b'),
('a', 'b'),
('b', 'a'),
('c', 'd'),
('c', 'd'),
('m', 'n'),
('n', 'm');

SELECT * FROM 
(SELECT col1,col2 FROM InputTbl 
UNION 
SELECT col2,col1 FROM InputTbl) AS Result  
WHERE col1<col2;

SELECT DISTINCT 
CASE WHEN col1 < Col2 THEN col1 ELSE col2 END AS col1,
CASE WHEN  COL1 < COL2 THEN col2 Else col1 END AS col2 
from InputTbl;



CREATE TABLE TestMultipleZero (
    A INT NULL,
    B INT NULL,
    C INT NULL,
    D INT NULL
);

INSERT INTO TestMultipleZero(A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);
	DELETE FROM TestMultipleZero
	WHERE A=0 AND B=0 AND C=0 AND D=0;



create table section1(id int, name varchar(20))
insert into section1 values (1, 'Been'),
       (2, 'Roma'),
       (3, 'Steven'),
       (4, 'Paulo'),
       (5, 'Genryh'),
       (6, 'Bruno'),
       (7, 'Fred'),
       (8, 'Andro')
	   SELECT * FROM section1
	   where id % 2 = 1;


SELECT TOP 1 Name, id 
from section1
order by id;



SELECT TOP 1 Name, id 
FROM section1
ORDER BY id DESC;


SELECT * FROM section1 WHERE Name like 'b%';

SELECT * FROM ProductCodes WHERE CODE LIKE '%\_%' escape '\';

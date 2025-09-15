-- data - is row information that is collected to be organized and analayzed to get insights for business. 
-- database - is organized collection of data
-- relation database - is one that stores data in tables
-- table - is fundamental database object used to store and organize data within a relational database 

--Relational database engine/High availability and disaster recovery/Advanced security/Data integration and Warehousing/ Big data integration.

--windows authentication/SQL server authentication 

create database SchoolIDB
use SchoolIDB
create table Students (StudentID int primary key, Name varchar (50), age int )
select * from Students
  
--SQL is a query language that helps users to connect with a databse.   /  SQL server - relational database management system, it is the backbone for data storage and processing.   / SSMS > it provides a user_friendly environment for tasks such as database administration, queries, and scripting.
  
--DQL > data query language. it is used only to fetch data from a database and include 'select' query
-- DDL > data definition language. it is used to create and modify tables, views, users, and other objects in the database and includes queries - create, alter,table.
-- DCL > data control language. it allows other people to qyery a table you created and include GRAND and REVOKE queries
-- DML > data manipulation language. it is used on data itself and include INSERT, UPDSTR and DELETE queries
-- TCL > transaction control language. that is used to manage transactio and in a relational database and include COMMIT and ROLLBACK queries.
insert into Students values(1, 'Eldor', 19), (2, 'Elyor', 20), (3, 'Farrux', 23);

--Step1 - download AdventureWorksDW2022.bak file from :https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2022.bak
-- Step2 - save this AdventureWorksDW2022.bak file to C:\ disk
-- Step3 - open SQL
-- Step4 - open "Databases" folder in Object Explorer
-- Step5 - select Restore Database...
-- Step6 - choose Device and click ... button, click Add, choose AdventureWorksDW2022.bak file and click ok
-- Step7 - back to Object Explorer, click Refresh

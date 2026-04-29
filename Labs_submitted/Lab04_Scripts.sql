

USE Northwind;
GO

-- 1) Select all data from the Order Details table.
SELECT *
FROM [Order Details];


-- 2) Select all data from the Customers table, ordered by ContactName.
SELECT *
FROM Customers
ORDER BY ContactName;


-- 3) Select all data from the Orders table, ordered by OrderDate, oldest date on top.
SELECT *
FROM Orders
ORDER BY OrderDate ASC;


-- 4) Select all data from the Orders table, ordered by ShippedDate, newest date on top.
SELECT *
FROM Orders
ORDER BY ShippedDate DESC;


-- 5) Select all data from the Orders table, where order has not shipped yet (ShippedDate is null).
SELECT *
FROM Orders
WHERE ShippedDate IS NULL;


-- 6) Select CompanyName, ContactName and ContactTitle from the Customers table, where CompanyName starts with D.
SELECT CompanyName, ContactName, ContactTitle
FROM Customers
WHERE CompanyName LIKE 'D%';


-- 7) Select EmployeeID, FirstName, LastName and Title from Employees, where LastName starts with E, F, or G.
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE LastName LIKE 'E%'
   OR LastName LIKE 'F%'
   OR LastName LIKE 'G%';


-- 8) Select number of records from the Suppliers table.
SELECT COUNT(*) AS SupplierCount
FROM Suppliers;


-- 9) List all data from Orders table for OrderID 10253.
SELECT *
FROM Orders
WHERE OrderID = 10253;


-- 10) List all order data (Orders table) placed by CustomerID AROUT or BERGS or BLAUS.
SELECT *
FROM Orders
WHERE CustomerID IN ('AROUT', 'BERGS', 'BLAUS');


-- 11) List all company names that start with letters B or C (Customers table).
SELECT CompanyName
FROM Customers
WHERE CompanyName LIKE 'B%'
   OR CompanyName LIKE 'C%';


-- 12) List unique company names that placed an order in 1996 (Customers + Orders). Use YEAR(date).
SELECT DISTINCT c.CompanyName
FROM Customers AS c
JOIN Orders AS o
  ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 1996;


-- 13) List out all records from Orders table for CompanyName B's Beverages.
SELECT o.*
FROM Orders AS o
JOIN Customers AS c
  ON o.CustomerID = c.CustomerID
WHERE c.CompanyName = 'B''s Beverages';


-- 14) List all customers whose US phone area code is 206.
SELECT *
FROM Customers
WHERE Phone LIKE '(206)%';


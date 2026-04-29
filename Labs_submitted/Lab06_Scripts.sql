USE Northwind;
GO

/* ------------------------------------------------------------
Q1) Select all data from the Orders table, ordered by OrderDate, 
newest date on top, for orders shipped between January 1997 and August 1997.
------------------------------------------------------------ */
SELECT *
FROM Orders
WHERE ShippedDate >= '1997-01-01'
  AND ShippedDate <  '1997-09-01'
ORDER BY OrderDate DESC;
SELECT GETDATE() AS TimeStamp;
GO

/* ------------------------------------------------------------
Q2) Select all data from the Orders table, ordered by OrderDate, 
newest date on top, for orders placed between July 1996 and January 1997.
------------------------------------------------------------ */
SELECT *
FROM Orders
WHERE OrderDate >= '1996-07-01'
  AND OrderDate <  '1997-02-01'
ORDER BY OrderDate DESC;
SELECT GETDATE() AS TimeStamp;
GO

/* ------------------------------------------------------------
Q3) Select all data from the Orders table, for orders placed in January 1998.
------------------------------------------------------------ */
SELECT *
FROM Orders
WHERE OrderDate >= '1998-01-01'
  AND OrderDate <  '1998-02-01';
SELECT GETDATE() AS TimeStamp;
GO

/* ------------------------------------------------------------
Q4) Select count of Orders shipped in 1996, 1997 and 1998. 
(one query containing all values) -> 2 columns (count and year), 3 rows (1 row per year).
------------------------------------------------------------ */
SELECT
  COUNT(*) AS OrderCount,
  YEAR(ShippedDate) AS [Year]
FROM Orders
WHERE ShippedDate IS NOT NULL
  AND YEAR(ShippedDate) IN (1996, 1997, 1998)
GROUP BY YEAR(ShippedDate)
ORDER BY [Year];
SELECT GETDATE() AS TimeStamp;
GO

/* ------------------------------------------------------------
Q5) Select all records from Employee table that any title related to “Sale”.
------------------------------------------------------------ */
SELECT *
FROM Employees
WHERE Title LIKE '%Sale%';
SELECT GETDATE() AS TimeStamp;
GO

/* ------------------------------------------------------------
Q6) Select all data from Orders table whose freight is more than 500.
------------------------------------------------------------ */
SELECT *
FROM Orders
WHERE Freight > 500;
SELECT GETDATE() AS TimeStamp;
GO

/* ------------------------------------------------------------
Q7) List all employees who have worked in company Northwind for more than 25 years.
------------------------------------------------------------ */
SELECT
  EmployeeID,
  LastName,
  FirstName,
  HireDate
FROM Employees
WHERE DATEADD(year, 25, HireDate) <= GETDATE();
SELECT GETDATE() AS TimeStamp;
GO

/* ------------------------------------------------------------
Q8) Calculate the average number of days it takes Northwind for 
all orders from “Ordered” (OrderDate) to “Shipped” (ShippedDate) status.
------------------------------------------------------------ */
SELECT
  AVG(CAST(DATEDIFF(day, OrderDate, ShippedDate) AS float)) AS AvgDaysFromOrderedToShipped
FROM Orders
WHERE OrderDate IS NOT NULL
  AND ShippedDate IS NOT NULL;
SELECT GETDATE() AS TimeStamp;
GO

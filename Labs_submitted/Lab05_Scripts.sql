USE Northwind;
GO

/* ------------------------------------------------------------
Q1) List all employee names in the following format: LAST NAME, first name.
 (Uppercased last name, followed by comma and space, followed by lowercased first name).
------------------------------------------------------------ */
SELECT
  UPPER(LastName) + ', ' + LOWER(FirstName) AS EmployeeName
FROM Employees;
GO

/* ------------------------------------------------------------
Q2) List all company names as well as the length of their name (not including blanks), 
from the Customers table. 2 Columns – Company Name, Text length.
------------------------------------------------------------ */
SELECT
  CompanyName,
  LEN(REPLACE(CompanyName, ' ', '')) AS TextLength
FROM Customers;
GO

/* ------------------------------------------------------------
Q3) List all shipped dates as well as expected delivery dates from the Orders table WHERE SHIP DATE IS NOT NULL.
 (Expected delivery date is 5 days from the ship date).
------------------------------------------------------------ */
SELECT
  ShippedDate,
  DATEADD(day, 5, ShippedDate) AS ExpectedDeliveryDate
FROM Orders
WHERE ShippedDate IS NOT NULL;
GO

/* ------------------------------------------------------------
Q4) List all orders from the Orders table that were shipped in 1998. 
------------------------------------------------------------ */
SELECT *
FROM Orders
WHERE ShippedDate >= '1998-01-01'
  AND ShippedDate <  '1999-01-01';
GO

/* ------------------------------------------------------------
Q5) List all orders placed on January 1st 1997, from the Orders table. 
------------------------------------------------------------ */
SELECT *
FROM Orders
WHERE OrderDate >= '1997-01-01'
  AND OrderDate <  '1997-01-02';
GO

/* ------------------------------------------------------------
Q6)	Find the oldest / youngest employee’s date of birth from Employee table.
------------------------------------------------------------ */
SELECT
  MIN(BirthDate) AS OldestDOB,
  MAX(BirthDate) AS YoungestDOB
FROM Employees;
GO

/* ------------------------------------------------------------
Q7) Calculate the average freight (rounded up to cent) for each Ship City from Orders table.
------------------------------------------------------------ */
SELECT
  ShipCity,
  CEILING(AVG(Freight) * 100) / 100.0 AS AvgFreightCeilToCent
FROM Orders
GROUP BY ShipCity
ORDER BY ShipCity;
GO

/* ------------------------------------------------------------
Q8) Count how many unique orders from [Order Details] table. 
------------------------------------------------------------ */
SELECT
  COUNT(DISTINCT OrderID) AS UniqueOrderCount
FROM [Order Details];
GO

/* ------------------------------------------------------------
Q9)	Get dates of First and Last orders placed (Orders table)
------------------------------------------------------------ */
SELECT
  MIN(OrderDate) AS FirstOrderDate,
  MAX(OrderDate) AS LastOrderDate
FROM Orders;
GO

/* ------------------------------------------------------------
Q10) List all employees whose birthday is in January
------------------------------------------------------------ */
SELECT *
FROM Employees
WHERE MONTH(BirthDate) = 1;
GO

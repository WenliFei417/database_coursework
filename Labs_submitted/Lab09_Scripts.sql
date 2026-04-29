USE Northwind;
GO

/* ------------------------------------------------------------
Q1) List all orders and their corresponding order details.
------------------------------------------------------------ */
SELECT
  o.OrderID,
  o.CustomerID,
  o.EmployeeID,
  o.OrderDate,
  o.ShippedDate,
  od.ProductID,
  od.UnitPrice,
  od.Quantity,
  od.Discount
FROM Orders AS o
INNER JOIN [Order Details] AS od
  ON o.OrderID = od.OrderID;
GO

SELECT GETDATE() AS TimeStamp;
GO


/* ------------------------------------------------------------
Q2) List all orders (OrderID) and all customers (Company Name), matching records appropriately.
------------------------------------------------------------ */
SELECT
  o.OrderID,
  c.CompanyName
FROM Orders AS o
INNER JOIN Customers AS c
  ON o.CustomerID = c.CustomerID;
GO

SELECT GETDATE() AS TimeStamp;
GO


/* ------------------------------------------------------------
Q3) List all company names that placed more than 5 orders.
------------------------------------------------------------ */
SELECT
  c.CompanyName,
  COUNT(*) AS OrderCount
FROM Customers AS c
INNER JOIN Orders AS o
  ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName
HAVING COUNT(*) > 5;
GO

SELECT GETDATE() AS TimeStamp;
GO


/* ------------------------------------------------------------
Q4) List orders (OrderID) and corresponding customers (Company Name), only where the records match up.
------------------------------------------------------------ */
SELECT
  o.OrderID,
  c.CompanyName
FROM Orders AS o
INNER JOIN Customers AS c
  ON o.CustomerID = c.CustomerID;
GO

SELECT GETDATE() AS TimeStamp;
GO


/* ------------------------------------------------------------
Q5) List matching orders (OrderID) and all customers (Company Name).
------------------------------------------------------------ */
SELECT
  o.OrderID,
  c.CompanyName
FROM Customers AS c
LEFT JOIN Orders AS o
  ON c.CustomerID = o.CustomerID
ORDER BY c.CompanyName, o.OrderID;
GO

SELECT GETDATE() AS TimeStamp;
GO


/* ------------------------------------------------------------
Q6) List all employees (names and IDs only) and their corresponding managers (names only).
------------------------------------------------------------ */
SELECT
  e.EmployeeID,
  e.FirstName,
  e.LastName,
  m.FirstName AS ManagerFirstName,
  m.LastName  AS ManagerLastName
FROM Employees AS e
LEFT JOIN Employees AS m
  ON e.ReportsTo = m.EmployeeID;
GO

SELECT GETDATE() AS TimeStamp;
GO


/* ------------------------------------------------------------
Q7) List all orders (OrderID) and matching customers (Company Name).
------------------------------------------------------------ */
SELECT
  o.OrderID,
  c.CompanyName
FROM Orders AS o
LEFT JOIN Customers AS c
  ON o.CustomerID = c.CustomerID;
GO

SELECT GETDATE() AS TimeStamp;
GO


/* ------------------------------------------------------------
Q8) Calculate the average number of days it takes for each employee (including NULL employee) to deal with orders from “Ordered” (OrderDate) to “Shipped” (ShippedDate) status.
------------------------------------------------------------ */
SELECT
  o.EmployeeID,
  e.FirstName,
  e.LastName,
  AVG(DATEDIFF(day, o.OrderDate, o.ShippedDate) * 1.0) AS AvgDaysToShip
FROM Orders AS o
LEFT JOIN Employees AS e
  ON o.EmployeeID = e.EmployeeID
WHERE o.OrderDate IS NOT NULL
  AND o.ShippedDate IS NOT NULL
GROUP BY o.EmployeeID, e.FirstName, e.LastName
ORDER BY o.EmployeeID;
GO

SELECT GETDATE() AS TimeStamp;
GO





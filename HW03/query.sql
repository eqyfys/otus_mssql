1)
a)
  SELECT PersonID, FullName FROM Application.People 
    WHERE IsSalesperson = 1
	AND PersonID NOT IN (SELECT SalespersonPersonID FROM Sales.Invoices)

b)
WITH SalesPeople AS
(
  SELECT  SalespersonPersonID FROM Sales.Invoices
)
  SELECT p.PersonID, p.FullName FROM Application.People as p
   WHERE p.IsSalesperson = 1
   AND  NOT EXISTS (SELECT * FROM SalesPeople WHERE SalespersonPersonID = p.PersonID)

2)
a)
  SELECT StockItemID, StockItemName, UnitPrice
   FROM Warehouse.StockItems 
   WHERE UnitPrice = (SELECT MIN (UnitPrice) FROM Warehouse.StockItems)

b)
  SELECT StockItemID, StockItemName, UnitPrice
   FROM Warehouse.StockItems 
   WHERE UnitPrice = (SELECT TOP 1 UnitPrice FROM Warehouse.StockItems ORDER BY UnitPrice)
 
 c)
 WITH MinPrice AS 
 (
    SELECT MIN (UnitPrice) as Price FROM Warehouse.StockItems
 )
   
 SELECT StockItemID, StockItemName, UnitPrice
   FROM Warehouse.StockItems 
   WHERE UnitPrice = (SELECT Price FROM  MinPrice)

3)
a)
 SELECT CustomerID, CustomerName
  FROM Sales.Customers
   WHERE CustomerID IN (SELECT TOP 5 CustomerID FROM Sales.CustomerTransactions ORDER BY TransactionAmount DESC)

b)
  SELECT DISTINCT * FROM 
	  (SELECT TOP 5  ct.CustomerID,
			   cu.CustomerName
	  FROM Sales.CustomerTransactions as ct
	  JOIN (SELECT CustomerID, CustomerName FROM Sales.Customers) as cu
		   ON cu.CustomerID = ct.CustomerID
	  GROUP BY ct.CustomerID, cu.CustomerName, ct.TransactionAmount
	  ORDER BY ct.TransactionAmount DESC
	 )  as tbl

c)
 WITH MaxTrans AS 
 (
   SELECT TOP 5 CustomerID FROM Sales.CustomerTransactions ORDER BY TransactionAmount DESC
 )
 
  SELECT DISTINCT cu.CustomerID, cu.CustomerName
  FROM Sales.Customers as cu
  JOIN MaxTrans as mt ON mt.CustomerID = cu.CustomerID

4)
a)
SELECT DISTINCT c.CityID,
       c.CityName,
	  (SELECT FullName FROM Application.People WHERE PersonID = i.PackedByPersonID) as Supplier
 FROM Application.Cities as c
 JOIN Sales.Customers as cu ON cu.DeliveryCityID = c.CityID
 JOIN  Sales.Invoices as i ON i.CustomerID = cu.CustomerID
 JOIN Sales.InvoiceLines as il ON il.InvoiceID = i.InvoiceID
 JOIN Warehouse.StockItems as si ON si.StockItemID = il.StockItemID
 WHERE si.StockItemID IN (SELECT TOP 3 StockItemID  FROM Warehouse.StockItems ORDER BY  UnitPrice DESC)

 b)
 WITH MostExpensiveItems as 
 (
   SELECT TOP 3 StockItemID  FROM Warehouse.StockItems ORDER BY  UnitPrice DESC
 )

 SELECT DISTINCT c.CityID,
       c.CityName,
	  (SELECT FullName FROM Application.People WHERE PersonID = i.PackedByPersonID) as Supplier
 FROM Application.Cities as c
 JOIN Sales.Customers as cu ON cu.DeliveryCityID = c.CityID
 JOIN  Sales.Invoices as i ON i.CustomerID = cu.CustomerID
 JOIN Sales.InvoiceLines as il ON il.InvoiceID = i.InvoiceID
 JOIN Warehouse.StockItems as si ON si.StockItemID = il.StockItemID
 JOIN MostExpensiveItems as mei ON mei.StockItemID = si.StockItemID
 
 



 

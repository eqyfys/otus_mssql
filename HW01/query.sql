--1
 SELECT  StockItemName 
 FROM Warehouse.StockItems
 WHERE StockItemName LIKE '%urgent%'
     OR StockItemName LIKE 'Animal%'

--2 
 SELECT su.* FROM Purchasing.Suppliers as su
	LEFT JOIN Purchasing.PurchaseOrders as po ON po.SupplierID = su.SupplierID
 WHERE po.PurchaseOrderID IS NULL

 --3 
 --a
SELECT o.*,
        DATENAME(month, o.OrderDate) as MonthName,
	DATEPART(quarter, o.OrderDate) as QuarterOrder,
	((DATEPART(month, o.OrderDate)-1)/4 +1) as ThirdOrder ,
        ol.Description,
	ol.UnitPrice,
	ol.Quantity 
 FROM Sales.Orders as o
	LEFT JOIN Sales.OrderLines as ol ON ol.OrderID = o.OrderID
 WHERE o.PickingCompletedWhen IS NOT NULL 
	AND (ol.UnitPrice > 100  OR ol.Quantity > 20)

--b	  
 SELECT o.*,
        DATENAME(month, o.OrderDate) as MonthName,
        DATEPART(quarter, o.OrderDate) as QuarterOrder,
	((DATEPART(month, o.OrderDate)-1)/4 +1) as ThirdOrder ,
        ol.Description,
	ol.UnitPrice,
	ol.Quantity,
        ol.OrderLineID
 FROM Sales.Orders as o
	LEFT JOIN Sales.OrderLines as ol ON ol.OrderID = o.OrderID
 WHERE o.PickingCompletedWhen IS NOT NULL 
	AND (ol.UnitPrice > 100  OR ol.Quantity > 20)
 ORDER BY QuarterOrder, ThirdOrder, o.OrderDate 
 OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY

--4
SELECT po.*,
	   su.SupplierName,
	   p.FullName,
	   dm.DeliveryMethodName	    
FROM Purchasing.PurchaseOrders as po
	   LEFT JOIN Purchasing.Suppliers as su ON su.SupplierID = po.SupplierID
	   LEFT JOIN Application.DeliveryMethods as dm ON dm.DeliveryMethodID = po.DeliveryMethodID
	   LEFT JOIN Application.People as p ON p.PersonID = po.ContactPersonID
 WHERE dm.DeliveryMethodName IN ('Road Freight', 'Post')  
     AND  po.OrderDate BETWEEN '2014-01-01' AND '2014-12-31'

 --5
 SELECT TOP 10 o.*,
	cu.CustomerName,
        p.FullName
 FROM Sales.Orders as o 
       LEFT JOIN Sales.Customers as cu ON cu.CustomerID = o.CustomerID
       LEFT JOIN Application.People as p ON p.PersonID = o.PickedByPersonID
 ORDER BY o.OrderDate DESC

 --6
SELECT cu.CustomerID,
       cu.CustomerName,
       cu.PhoneNumber
 FROM Sales.Orders as o
        LEFT JOIN Sales.OrderLines as ol ON ol.OrderID = o.OrderID
        LEFT JOIN Sales.Customers as cu ON cu.CustomerID = o.CustomerID
 WHERE ol.Description = 'Chocolate frogs 250g'

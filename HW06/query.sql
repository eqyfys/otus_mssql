

--1)
 SET STATISTICS TIME ON;

--a) with windows function
SELECT i.InvoiceID,
       c.CustomerName,
       i.InvoiceDate,
       ct.TransactionAmount as Summ,
       SUM(ct.TransactionAmount) OVER (ORDER BY DATEPART(year, i.InvoiceDate),
       DATEPART(month, i.InvoiceDate)) as RunningPerMonthSumm
FROM  Sales.Invoices as i
JOIN Sales.CustomerTransactions as ct ON ct.InvoiceID = i.InvoiceID
JOIN Sales.Customers as c ON c.CustomerID = ct.CustomerID
WHERE i.InvoiceDate >= '2015-01-01'
ORDER BY i.InvoiceDate

 --b) without windows function
SELECT 
      i.InvoiceID,
      c.CustomerName,
      i.InvoiceDate,
      ct.TransactionAmount as Summ,
      (SELECT SUM(TransactionAmount) FROM Sales.CustomerTransactions 
       WHERE InvoiceID IN (SELECT InvoiceID FROM Sales.Invoices 
			    WHERE InvoiceDate BETWEEN '2015-01-01' 
			    AND EOMONTH(i.InvoiceDate))) as RunningPerMonthSumm
FROM  Sales.Invoices as i
JOIN Sales.CustomerTransactions as ct ON ct.InvoiceID = i.InvoiceID
JOIN Sales.Customers as c ON c.CustomerID = ct.CustomerID
WHERE i.InvoiceDate >= '2015-01-01'

 SET STATISTICS TIME OFF;

 --статистика

--(затронуто строк: 31440)

-- SQL Server Execution Times:
--   CPU time = 547 ms,  elapsed time = 7756 ms.
					
--(затронуто строк: 31440)

-- SQL Server Execution Times:
--   CPU time = 10437 ms,  elapsed time = 10560 ms.

-- вывод: запрос а работает быстрее
					
--2) 
SELECT * FROM (
  SELECT
       DATEPART(month, i.InvoiceDate) as MonthOrders, 
       DATENAME(month, i.InvoiceDate) as MonthNames, 
       si.StockItemName as ItemName,
       SUM(il.Quantity) as ItemsCount,
       ROW_NUMBER() OVER (PARTITION BY DATEPART(month, i.InvoiceDate)
			  ORDER BY SUM(il.Quantity) DESC) as PopularityOrder
  FROM Sales.Invoices as i 
  JOIN Sales.InvoiceLines as il ON il.InvoiceID = i.InvoiceID
  JOIN Warehouse.StockItems as si ON si.StockItemID = il.StockItemID
  WHERE i.InvoiceDate BETWEEN '2016-01-01' AND '2016-12-31'
  GROUP BY DATEPART(month, i.InvoiceDate), DATENAME(month, i.InvoiceDate),  si.StockItemName
) as tbl 
  WHERE tbl.PopularityOrder IN (1,2)
  ORDER BY tbl.MonthOrders, tbl.ItemsCount DESC;
					
--3)
SELECT si.StockItemID,
       si.StockItemName, 
       si.Brand,
       si.UnitPrice,
       ROW_NUMBER() OVER (PARTITION BY LEFT(si.StockItemName, 1) ORDER BY si.StockItemName) as FirstLetterOrder,
       SUM(QuantityPerOuter) OVER() as CountAll,
       SUM(QuantityPerOuter) OVER(PARTITION BY LEFT(si.StockItemName, 1) ORDER BY LEFT(si.StockItemName, 1)) as CountByLetter,
       LEAD(StockItemID) OVER (ORDER BY si.StockItemName) as NextID,
       LAG(StockItemID) OVER (ORDER BY si.StockItemName) as PreviosID,
       LAG(si.StockItemName, 2, 'No items') OVER (ORDER BY si.StockItemName) as PreviosItemName,
       NTILE (30) OVER (ORDER BY si.TypicalWeightPerUnit) as GroupOrder 	  
FROM Warehouse.StockItems as si
ORDER BY si.StockItemName;

--4)
SELECT     tbl.SalespersonPersonID,
	   tbl.FullName,
	   tbl.CustomerID,
	   tbl.CustomerName,
	   tbl.InvoiceDate,
	   tbl.DealSumm as DealSumm
FROM (
	SELECT     i.SalespersonPersonID,
	           p.FullName,
		   c.CustomerID,
		   c.CustomerName,
		   i.InvoiceDate,
		   ct.TransactionAmount as DealSumm,
		   ROW_NUMBER() OVER (PARTITION BY  SalespersonPersonID ORDER BY i.InvoiceDate DESC) as InvoiceDateOrder
	FROM  Sales.Invoices as i
	JOIN Sales.CustomerTransactions as ct ON ct.InvoiceID = i.InvoiceID
	JOIN Application.People as p ON p.PersonID = i.SalespersonPersonID
	JOIN Sales.Customers as c ON c.CustomerID = i.CustomerID
) as tbl 
WHERE tbl.InvoiceDateOrder = 1;
					

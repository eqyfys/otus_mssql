

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
  ORDER BY tbl.MonthOrders, tbl.ItemsCount DESC
					
					



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

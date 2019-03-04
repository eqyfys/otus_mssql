--1)
--a)with temp table
CREATE TABLE #CustomersSumm ( InoviceID int, CustomerName nvarchar(100), InvoiceDate datetime, TransactionAmount decimal(18,2), RunningPerMonthSumm decimal(18,2))

INSERT INTO #CustomersSumm (InoviceID, CustomerName, InvoiceDate, TransactionAmount, RunningPerMonthSumm)

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

SELECT * FROM #CustomersSumm

--b)with table variable
DECLARE @CustomersSumm TABLE ( InoviceID int, CustomerName nvarchar(100), InvoiceDate datetime, TransactionAmount decimal(18,2), RunningPerMonthSumm decimal(18,2))

INSERT INTO @CustomersSumm (InoviceID, CustomerName, InvoiceDate, TransactionAmount, RunningPerMonthSumm)

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

SELECT * FROM @CustomersSumm

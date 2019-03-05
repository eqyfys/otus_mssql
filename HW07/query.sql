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
							 
--Анализ планов: планы запросов отличаются, но самая затратная по стоимости операция одна и та же - 
--   это Hash Matсh таблиц CustomerTransactions и Invoices по полю InvoiceID. И там , и там это 80% от стоимости запроса (7366037 строк).
--Оптимизация этих запросов в первую очередь заключалась бы, полагаю, 
-- в создании ключа по InvoceID при создании таблицы или табличной переменной. 							 
							 
							 

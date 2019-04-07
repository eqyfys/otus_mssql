--1)

CREATE FUNCTION GetCustomerMaxSumm()
RETURNS nvarchar(100)
AS
BEGIN
	DECLARE @Result nvarchar(100)

	SET @Result = (SELECT TOP 1 CustomerName 
	               FROM Sales.CustomerTransactions as ct
                   JOIN Sales.Customers as c ON c.CustomerID = ct.CustomerID
                   ORDER BY ct.TransactionAmount DESC)

	RETURN @Result
END
GO

--2)

CREATE PROCEDURE [Sales].[GetSummByCustomerID]
	@CustomerID int
AS
BEGIN
   SELECT SUM(il.UnitPrice*il.Quantity) as InvoiceSumm
   FROM Sales.InvoiceLines as il
   JOIN Sales.Invoices as i ON i.InvoiceID = il.InvoiceID
   JOIN Sales.Customers as c ON c.CustomerID = i.CustomerID
   WHERE c.CustomerID = @CustomerID
END
GO

--3)

CREATE FUNCTION [Sales].[GetTranSummByDate]
(
	@TransactionDate datetime
)
RETURNS decimal(18,2)
AS
BEGIN
    DECLARE @Result decimal(18,2)

    SET @Result = (SELECT SUM(TransactionAmount)
	           FROM Sales.CustomerTransactions
	           WHERE TransactionDate = @TransactionDate)
    RETURN @Result
END
GO

CREATE PROCEDURE  [Sales].[GetTranSummByTranDate]
	@TransactionDate datetime
AS
BEGIN
	SELECT SUM(TransactionAmount) as Result
	       FROM Sales.CustomerTransactions
		   WHERE TransactionDate = @TransactionDate
END
GO


--Сравнение производительности:
--Планы оказалаись практически идентичными, в обоих случаях 100% стоимость - просмотр кластерного индекса табл. CustomerTransactions. 
--Поэтому разницы в производительности не наблюдается. 




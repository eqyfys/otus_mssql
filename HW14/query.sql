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

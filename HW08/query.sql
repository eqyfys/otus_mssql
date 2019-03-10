--1)
SELECT FORMAT(InvoiceMonthFormat, 'dd.MM.yyyy') as InvoiceMonth,
       pvt.[Sylvanite, MT],
		   pvt.[Peeples Valley, AZ],
		   pvt.[Medicine Lodge, KS],
		   pvt.[Gasport, NY],
		   pvt.[Jessie, ND]
FROM (
   SELECT 
      (SELECT DATEFROMPARTS(YEAR(i.InvoiceDate), MONTH(i.InvoiceDate), 1)) as InvoiceMonthFormat,
      REPLACE(REPLACE(c.CustomerName, 'Tailspin Toys (', ''), ')', '') as CustomerName,
      i.InvoiceID
   FROM Sales.Invoices as i
   JOIN Sales.Customers as c on c.CustomerID = i.CustomerID
   WHERE c.CustomerID IN (2,3,4,5,6)
) as tbl
PIVOT (
   COUNT(InvoiceID)
   FOR [CustomerName] IN ([Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS],[Gasport, NY], [Jessie, ND])
) as pvt
ORDER BY InvoiceMonthFormat;  -- по дате в формате dd.MM.yyyy сортировка работает некорректно
												      
--3)
 SELECT unpvt.CountryID,
        unpvt.CountryName,
	unpvt.Code
FROM (
	SELECT c.CountryID,
	       c.CountryName,
	       c.IsoAlpha3Code as StringCode,
	       CAST(c.IsoNumericCode as nvarchar(3)) as NumericCode
	FROM Application.Countries  as  c
) as tbl
UNPIVOT (Code FOR CodeColumns IN (StringCode, NumericCode)) as unpvt;

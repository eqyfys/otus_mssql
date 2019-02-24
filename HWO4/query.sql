 --1)
SELECT YEAR(i.InvoiceDate) as Years,
       DATENAME(month, i.InvoiceDate) as Months,
       AVG(il.UnitPrice) as AveragePrice,
	     SUM(il.UnitPrice*il.Quantity) as AllSumm
FROM Sales.Invoices as i
JOIN Sales.InvoiceLines as il ON il.InvoiceID = i.InvoiceID
GROUP BY YEAR(i.InvoiceDate),  DATENAME(month, i.InvoiceDate)
ORDER BY  YEAR(i.InvoiceDate),  DATENAME(month, i.InvoiceDate);

-- 2)
SELECT  YEAR(i.InvoiceDate) as Years,
        DATENAME(month, i.InvoiceDate) as Months,
        AVG(il.UnitPrice) as AveragePrice,
	      SUM(il.UnitPrice*il.Quantity) as AllSumm
FROM Sales.Invoices as i
JOIN Sales.InvoiceLines as il ON il.InvoiceID = i.InvoiceID
GROUP BY YEAR(i.InvoiceDate),  DATENAME(month, i.InvoiceDate)
HAVING  SUM(il.UnitPrice*il.Quantity) > 10000
ORDER BY  YEAR(i.InvoiceDate),  DATENAME(month, i.InvoiceDate);
   
 --3)
SELECT YEAR(i.InvoiceDate) as Years,
       DATENAME(month, i.InvoiceDate) as Months,
	     il.StockItemID,
	     il.Description,
       SUM(il.Quantity) as ItemsCount,
	     SUM(il.UnitPrice*il.Quantity) as AllSumm,
	     MIN(i.InvoiceDate) as FirstSaleDate
FROM Sales.Invoices as i
JOIN Sales.InvoiceLines as il ON il.InvoiceID = i.InvoiceID
GROUP BY YEAR(i.InvoiceDate),  DATENAME(month, i.InvoiceDate),	il.StockItemID, il.Description
HAVING  SUM(il.Quantity)  < 50
ORDER BY  YEAR(i.InvoiceDate),  DATENAME(month, i.InvoiceDate), il.StockItemID, il.Description;

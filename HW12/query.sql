--1)
DECLARE @handle int
DECLARE @tbl XML
SET @tbl = (SELECT * FROM OPENROWSET (BULK 'D:\StockItems.xml', SINGLE_CLOB) as FromFile)

EXEC sp_xml_preparedocument @handle OUTPUT, @tbl

MERGE WareHouse.StockItems as target
USING(
	SELECT Name as StockItemName,
	       SupplierID,
	       UnitPackageID,
	       OuterPackageID,
	       QuantityPerOuter,
	       TypicalWeightPerUnit,
	       LeadTimeDays,
	       IsChillerStock,
	       TaxRate,
	       UnitPrice,
	       1 as LastEditedBy
	FROM OPENXML(@handle, N'/StockItems/Item', 3)
	WITH ( 
		[Name] nvarchar(100),
		[SupplierID] int ,
		[UnitPackageID] int 'Package/UnitPackageID',
		[OuterPackageID] int 'Package/OuterPackageID',
		[QuantityPerOuter] int 'Package/QuantityPerOuter',
		[TypicalWeightPerUnit] decimal(18,3) 'Package/TypicalWeightPerUnit',
		[LeadTimeDays] int,
		[IsChillerStock] bit,
		[TaxRate] decimal(18,3),
		[UnitPrice] decimal(18,2)
		)
     ) as source (StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter,
                 TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate,  UnitPrice, LastEditedBy)
ON (source.StockItemName = target.StockItemName)
	WHEN MATCHED 
		 THEN UPDATE
		 SET SupplierID = source.SupplierID,
			   UnitPackageID = source.UnitPackageID,
			   OuterPackageID = source.OuterPackageID,
			   QuantityPerOuter = source.QuantityPerOuter,
			   TypicalWeightPerUnit = source.TypicalWeightPerUnit,
			   LeadTimeDays = source.LeadTimeDays,
			   IsChillerStock = source.IsChillerStock,
			   TaxRate= source.TaxRate,
			   UnitPrice = source.UnitPrice
	WHEN NOT MATCHED 
	    THEN INSERT (StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, 
                   TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate,  UnitPrice, LastEditedBy)
		 VALUES (source.StockItemName, source.SupplierID, source.UnitPackageID, source.OuterPackageID, 
                  source.QuantityPerOuter, source.TypicalWeightPerUnit, source.LeadTimeDays,
                  source.IsChillerStock, source.TaxRate, source.UnitPrice, source.LastEditedBy);       

EXEC sp_xml_removedocument @handle

--2)
SELECT  StockItemName as '@Name',
	SupplierID,
	UnitPackageID as 'Package/UnitPackageID',
	OuterPackageID as 'Package/OuterPackageID',
	QuantityPerOuter as 'Package/QuantityPerOuter',
	TypicalWeightPerUnit as 'Package/TypicalWeightPerUnit',
	LeadTimeDays,
	IsChillerStock,
	TaxRate,
	UnitPrice
FROM Warehouse.StockItems FOR XML PATH('Item'), TYPE,  ELEMENTS, ROOT('StockItems');

--3)
SELECT StockItemID,
       StockItemName,
       CountryOfManufacture = JSON_VALUE(CustomFields, '$.CountryOfManufacture'),
       Range = JSON_VALUE(CustomFields, '$.Range')
FROM Warehouse.StockItems 

--4)
SELECT StockItemID,
       StockItemName,
       JSON_QUERY(CustomFields, '$.Tags') as Tags,
       CustomFields
FROM Warehouse.StockItems   
WHERE JSON_QUERY(CustomFields, '$.Tags') LIKE '%Vintage%'

--5)
--формируем строку со стоблцами (для этого грузим нужные значения в json, затем обрабатываем)
DECLARE @cols nvarchar(MAX)
SET @cols = (SELECT DISTINCT CustomerName FROM Sales.Customers  FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)
SET @cols = (SELECT REPLACE(@cols, '"CustomerName":', ''))
SET @cols = (SELECT REPLACE(@cols, '{', '['))
SET @cols = (SELECT REPLACE(@cols, '}', ']'))
SET @cols = (SELECT REPLACE(@cols, '"', ''))

--составляем запрос  вместе с сформированной строкой стоблцов и выполняем его
DECLARE @query nvarchar(MAX)
SET @query = N'
SELECT * 
FROM (
   SELECT 
       (FORMAT(DATEFROMPARTS(YEAR(i.InvoiceDate), MONTH(i.InvoiceDate), 1), ''dd.MM.yyyy'')) as InvoiceMonth,
       CustomerName,
       i.InvoiceID
   FROM Sales.Invoices as i
   JOIN Sales.Customers as c on c.CustomerID = i.CustomerID
) as tbl
PIVOT (
   COUNT(InvoiceID)
   FOR [CustomerName] IN ( ' + @cols +')
) as pvt
ORDER BY InvoiceMonth; '

EXEC (@query)

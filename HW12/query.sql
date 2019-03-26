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

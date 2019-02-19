
1)
INSERT INTO Sales.Customers
      (CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, 
      AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate,
      StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun,
      RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation,
       PostalAddressLine1,  PostalAddressLine2, PostalPostalCode, LastEditedBy)
  VALUES 
    (NEXT VALUE FOR Sequences.CustomerID, 'Oleg Zelepukin', NEXT VALUE FOR Sequences.CustomerID, 5, null, 3244, null, 3, 16702,
	    16702, 5500, '2019-02-16', 0, 0, 0, 7, '(321) 333-0100', '(321) 333-0101', null, null ,
		 'http://wreqesfds.ru',  '', '', 3245325,  null, '', '', 53453, 1),
	  (NEXT VALUE FOR Sequences.CustomerID, 'Nikolay Sutulov', NEXT VALUE FOR Sequences.CustomerID, 3, null, 3254, null, 3, 16702,
	    16702, 4343, '2019-02-16', 0, 0, 0, 7, '(543) 555-0100', '(543) 555-0101', null, null ,
		 'http://dgdsfgs.ru',  '', '', 56754,  null, '', '', 43564, 1),
	  (NEXT VALUE FOR Sequences.CustomerID, 'Ivan Troezadov', NEXT VALUE FOR Sequences.CustomerID, 3, null, 3256, null, 3, 16702,
	    16702, 5500, '2019-02-16', 0, 0, 0, 7, '(321) 444-0100', '(321) 444-0101', null, null ,
		 'http://wreqesfds.ru',  '', '', 3245325,  null, '', '', 53453, 1),
    (NEXT VALUE FOR Sequences.CustomerID, 'Petr Makakov', NEXT VALUE FOR Sequences.CustomerID , 3, null, 3257, null, 3, 16702,
	    16702, 4343, '2019-02-16', 0, 0, 0, 7, '(543) 777-0100', '(543) 777-0101', null, null ,
		 'http://hgjgfgf.ru',  '', '', 56754,  null, '', '', 43564, 1),
	  (NEXT VALUE FOR Sequences.CustomerID, 'Anna  Polosatova', NEXT VALUE FOR Sequences.CustomerID, 5, null, 3259, null, 3, 16702,
	    16702, 4343, '2019-02-16', 0, 0, 0, 7, '(543) 666-0100', '(543) 666-0101', null, null ,
		 'http://hjkhlghlsdhs.ru',  '', '', 56754,  null, '', '', 43564, 1);
     
2)
DELETE FROM Sales.Customers WHERE CustomerID = 1074

3)
   UPDATE Sales.Customers 
   SET CustomerName = 'Petr Makarov',
       CustomerCategoryID = 5                   
   WHERE CustomerID = 1073

4) 
 MERGE Sales.Customers AS target 
   USING (  
     SELECT
	     1075 as CustomerID,
		 'Anna  Polosatova' as CustomerName,
		 1075 as  BillToCustomerID,
		 5 as CustomerCategoryID,
		 null as BuyingGroupID,
		 3259 as PrimaryContactPersonID,
		 null as AlternateContactPersonID, 
	     3 as DeliveryMethodID,
		 16702 as DeliveryCityID,
		 16702 as PostalCityID,
		 4343 as CreditLimit,
		 '2019-02-16' as AccountOpenedDate,
		 0 as StandardDiscountPercentage,
		 0 as IsStatementSent,
		 0 as IsOnCreditHold,
		 7 as PaymentDays,
		 '(543) 666-0100' as PhoneNumber,
		 '(543) 666-0101' as FaxNumber, 
		  null as DeliveryRun,
		  null as RunPosition,
		  'http://hjkhlghlsdhs.ru' as WebsiteURL,
		  '' as DeliveryAddressLine1,
		  '' as DeliveryAddressLine2,
		  56754 as DeliveryPostalCode, 
		  null as DeliveryLocation,
		  '' as PostalAddressLine1, 
		  '' as PostalAddressLine2,
		   43564 as PostalPostalCode, 
		   1 as LastEditedBy	      
   )  as source   (CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, 
                   AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate,
				   StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun,
				   RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation,
				   PostalAddressLine1,  PostalAddressLine2, PostalPostalCode, LastEditedBy)
   ON (target.CustomerID = source.CustomerID)
  WHEN MATCHED 
 	 THEN UPDATE SET 
	      PhoneNumber = '(543) 777-0100',
				FaxNumber = '(543) 777-0101'
	WHEN NOT MATCHED
	 THEN INSERT 
        (CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, 
        AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, CreditLimit, AccountOpenedDate,
        StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, FaxNumber, DeliveryRun,
        RunPosition, WebsiteURL, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation,
        PostalAddressLine1,  PostalAddressLine2, PostalPostalCode, LastEditedBy)
	  VALUES (1075, 'Anna  Polosatova', 1075, 5, null, 3259, null, 3, 16702, 16702,
	          4343, '2019-02-16', 0, 0, 0, 7, '(543) 666-0100', '(543) 666-0101', null, null , 'http://hjkhlghlsdhs.ru', 
             '', '', 56754,  null, '', '', 43564, 1);
             
5)
EXEC sp_configure 'show advanced options', 1;  
GO  

RECONFIGURE;  
GO  
  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  

RECONFIGURE;  
GO  

--bulk out 
exec master..xp_cmdshell 'bcp "[WideWorldImporters].Application.Countries" out  "D:\Countries.txt" -T -w -t! -S LAPTOP-6V77GOBE'

--create table
CREATE TABLE [Application].[CountriesRestored](
	[CountryID] [int] NOT NULL,
	[CountryName] [nvarchar](60) NOT NULL,
	[FormalName] [nvarchar](60) NOT NULL,
	[IsoAlpha3Code] [nvarchar](3) NULL,
	[IsoNumericCode] [int] NULL,
	[CountryType] [nvarchar](20) NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[Continent] [nvarchar](30) NOT NULL,
	[Region] [nvarchar](30) NOT NULL,
	[Subregion] [nvarchar](30) NOT NULL,
	[Border] [geography] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK_Application_CountriesRestored] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [USERDATA],
 CONSTRAINT [UQ_Application_CountriesRestored_CountryName] UNIQUE NONCLUSTERED 
(
	[CountryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [USERDATA],
 CONSTRAINT [UQ_Application_CountriesRestored_FormalName] UNIQUE NONCLUSTERED 
(
	[FormalName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [USERDATA],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [USERDATA] TEXTIMAGE_ON [USERDATA]

GO

-- bulk in
	BULK INSERT [WideWorldImporters].[Application].[CountriesRestored]
				   FROM "D:\Countries.txt"
				   WITH 
					 (
						BATCHSIZE = 1000, 
						DATAFILETYPE = 'widechar',
						FIELDTERMINATOR = '!',
						ROWTERMINATOR ='\n',
						KEEPNULLS,
						TABLOCK        
					  );
             
             

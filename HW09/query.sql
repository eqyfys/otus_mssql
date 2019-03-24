--1) создание базы данных
CREATE DATABASE [StadiumServices]

--2) Создание схемы
USE [StadiumServices]
GO
CREATE SCHEMA [Food] AUTHORIZATION [db_owner]
GO

--3) Создание таблицы Customers
CREATE TABLE [Food].[Customers] 
(
 [CustomerID] [int] NOT NULL,
	[PhoneNumber] [nvarchar](20) NOT NULL,
	[CustomerName] [nvarchar](150) NOT NULL,
	[RegistrationDate] [datetime] NOT NULL,
	[Comments] [nvarchar](500),
CONSTRAINT [PK_Food_Customers] PRIMARY KEY CLUSTERED 
(
  [CustomerID] ASC
)
)

--4) Создание таблицы Items
CREATE TABLE [Food].[Items](
	[ItemID] [int] NOT NULL,
	[ItemName] [nvarchar](200) NOT NULL,
	[Price] [decimal] (18,2) NOT NULL,
	[Balance] [int]  NOT NULL,
	[Comms] [nvarchar](500) NULL,
 CONSTRAINT [PK_Food_Items] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)
)
GO

--5) Создание таблицы Orders
CREATE TABLE [Food].[Orders](
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OrderDate] [datetime]  NOT NULL,
	[Status] nvarchar(20) CHECK ([Status] IN ('новый', 'в работе', 'готов к доставке', 'доставка', 'закрыт')),
	[SectorNumber] [int]  NOT NULL,
	[RowNumber] [int] NOT NULL,
	[PlaceNumber] [int] NOT NULL,
	[Comms] [nvarchar](500) NULL,
 CONSTRAINT [PK_Food_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)
) 
GO
		 
--6)  Создание таблицы OrderItems
CREATE TABLE [Food].[OrderItems](
        [OrderItemID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[ItemID] [int]  NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [decimal](18,2) NOT NULL,
	[Comms] [nvarchar](500) NULL,
 CONSTRAINT [PK_Food_OrderItems] PRIMARY KEY CLUSTERED 
(
	[OrderItemID]  ASC
)
)
GO

--7) Создание таблички ItemsHistory
CREATE TABLE [Food].[ItemsHistory](
	[ItemsHistoryID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ActionType] [nvarchar](50) NOT NULL,
	[ActionDate] [datetime] NOT NULL,
	[ActionUser] [nvarchar] (100) NOT NULL,
	[Price] [decimal] (18,2) NOT NULL,
	[Balance] [int]  NOT NULL,
	[Comms] [nvarchar](500) NULL,
 CONSTRAINT [PK_Food_ItemsActions] PRIMARY KEY CLUSTERED 
(
	[ItemsHistoryID] ASC
)
)
GO


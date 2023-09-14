/*Create Stagining Tables*/
CREATE TABLE staging.Product(
	ProductID int
    ,Name nvarchar(50)
    ,ProductNumber nvarchar(20)
    ,Color nvarchar(15)
    ,StandardCost money
    ,ListPrice money
    ,Size nvarchar(5)
    ,Weight decimal(8,2)
    ,ProductCategoryID int
    ,ProductModelID int
    ,SellStartDate datetime
    ,SellEndDate datetime
    ,DiscontinuedDate datetime
	,IngestionTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staging.ProductCategory(
	ProductCategoryID int
	,Name nvarchar(50)
	,IngestionTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staging.ProductModel(
	ProductModelID int
	,Name nvarchar(50)
	,IngestionTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staging.Customer(
	CustomerID int
    ,Title nvarchar(8)
    ,FirstName nvarchar(50)
    ,MiddleName nvarchar(50)
    ,LastName nvarchar(50)
    ,Suffix nvarchar(10)
    ,CompanyName nvarchar(128)
    ,SalesPerson nvarchar(256)
	,IngestionTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staging.CustomerAddress(
	CustomerID int
    ,AddressID int
    ,AddressType nvarchar(50)
	,IngestionTimestamp datetime DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE staging.Address(
	AddressID int
    ,City nvarchar(30)
    ,StateProvince nvarchar(50)
    ,CountryRegion nvarchar(50)
    ,PostalCode nvarchar(15)
	,IngestionTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staging.SalesOrderDetail(
	SalesOrderID int
    ,SalesOrderDetailID int
    ,OrderQty smallint
    ,ProductID int
    ,UnitPrice money
    ,UnitPriceDiscount money
    ,LineTotal money
	,IngestionTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE staging.SalesOrderHeader(
	SalesOrderID int
      ,OrderDate datetime
      ,DueDate datetime
      ,ShipDate datetime
      ,SalesOrderNumber nvarchar(25)
      ,PurchaseOrderNumber nvarchar(25)
      ,CustomerID int
      ,ShipToAddressID int
      ,ShipMethod nvarchar(50)
      ,SubTotal money
      ,TaxAmt money
      ,Freight money
      ,TotalDue money
	  ,IngestionTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);
/*
Config table to store last loaded date
and the name of the table for which this loading was done.

Table name and WaterMarkValue to be updated during ETL process.

Watermark takes latest datetime from source date to perform incremental load.
*/
CREATE TABLE staging.ConfigTable(
	ConfigID int IDENTITY(1, 1)
	,TableName nvarchar(100)
	,WaterMarkValue datetime
);

/*Populate Config Table with initial values*/
INSERT INTO staging.ConfigTable
VALUES
	('SalesLT.SalesOrderDetail', CAST('1950-01-01 00:00:00' AS datetime))
	,('SalesLT.SalesOrderHeader', CAST('1950-01-01 00:00:00' AS datetime))
	,('staging.SalesOrderDetail', CAST('1950-01-01 00:00:00' AS datetime))
GO
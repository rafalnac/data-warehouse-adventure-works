/*Preapate transformed and cleaned tables for loading into core layer*/

CREATE TABLE stagingtransformed.CustomerAddress(
	CustomerID int
	,AddressID int
	,AddressType nvarchar(50)
	,City nvarchar(30)
	,PostalCode nvarchar(30)
	,StateProvince nvarchar(50)
	,CountryRegion nvarchar(50)
	,IngestionTimestamp datetime
	,ProcessedTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stagingtransformed.Customer(
	CustomerID int
	,Title nvarchar(30)
	,CustomerFullName nvarchar(200)
	,CompanyName nvarchar(150)
	,AssignedSalesPerson nvarchar(200)
	,IngestionTimestamp datetime
	,ProcessedTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stagingtransformed.Address(
	AddressID int
    ,City nvarchar(30)
    ,StateProvince nvarchar(50)
    ,CountryRegion nvarchar(50)
    ,PostalCode nvarchar(50)
    ,IngestionTimestamp datetime
	,ProcessedTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stagingtransformed.Product(
	ProductID int
	,Name nvarchar(50)
	,Category nvarchar(50)
	,Model nvarchar(50)
	,ProductNumber nvarchar(50)
	,Color nvarchar(30)
	,StandardCost money
	,ListPrice money
	,Size nvarchar(30)
	,Weight decimal(8,2)
	,SellStartDate date
	,SellEndDate date
	,DiscontinuedDate date
	,IngestionTimestamp datetime
	,ProcessedTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE stagingtransformed.ShipMethod(
	ShipMethodID int IDENTITY(1, 1)
		CONSTRAINT AK_ShipMethodID UNIQUE(ShipMethodID)
	,ShipMethod nvarchar(100)
	,ProcessedTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stagingtransformed.Sales(
	SalesOrderID int
	,PurchaseOrderNumber nvarchar(30)
	,OrderDate date
	,DueDate date
	,ShipDate date
    ,UnitPrice money
	,OrderQty int
    ,UnitPriceDiscount money
    ,LineTotal money
	,SubTotal money
	,TaxAmt money
	,TaxPct decimal(4,3)
	,Freight money
	,TotalDue money
	,ShipMethod nvarchar(100)
	,CustomerID int
	,ProductID int
	,ShipToAddressID int
	,IngestionTimestamp datetime
	,ProcessedTimestamp datetime DEFAULT CURRENT_TIMESTAMP
);
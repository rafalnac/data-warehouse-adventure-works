/*Preapare transformed and cleaned tables for loading into core layer*/

CREATE TABLE core.CustomerAddress(
	CustomerAddressKey int IDENTITY(1, 1)
	,CustomerID int NOT NULL
	,AddressID int NOT NULL
	,AddressType nvarchar(50) NULL
	,City nvarchar(30) NULL
	,PostalCode nvarchar(30) NULL
	,StateProvince nvarchar(50) NULL
	,CountryRegion nvarchar(50) NULL
	,StartDate date NOT NULL
	,EndDate date NULL
	,IsCurrent nchar(2) NOT NULL
	,CONSTRAINT PK_CustomerAddress_AddressPK PRIMARY KEY (CustomerAddressKey)
);

CREATE TABLE core.Customer(
	CustomerKey int IDENTITY(1, 1)
	,CustomerID int NOT NULL
	,CustomerAddressKey int NULL
	,CustomerFullName nvarchar(200) NOT NULL
	,CompanyName nvarchar(150) NULL
	,AssignedSalesPerson nvarchar(200) NULL
	,StartDate date NOT NULL
	,EndDate date NULL
	,IsCurrent nchar(2) NOT NULL
	,CONSTRAINT PK_Customer_CustomerKey PRIMARY KEY (CustomerKey)
	,CONSTRAINT FK_Customer_CustomerAddress FOREIGN KEY(CustomerAddressKey) REFERENCES core.CustomerAddress(CustomerAddressKey)
);

CREATE TABLE core.Address(
	AddressKey int IDENTITY(1, 1)
	,AddressID int NOT NULL
    ,City nvarchar(30) NOT NULL
    ,StateProvince nvarchar(50) NOT NULL
    ,CountryRegion nvarchar(50) NOT NULL
    ,PostalCode nvarchar(50) NOT NULL
	,CONSTRAINT PK_Address_AddressKey PRIMARY KEY (AddressKey)
);

CREATE TABLE core.Product(
	ProductKey int IDENTITY(1, 1)
	,ProductID int NOT NULL
	,Name nvarchar(50) NOT NULL
	,Category nvarchar(50) NOT NULL
	,Model nvarchar(50) NOT NULL
	,ProductNumber nvarchar(50) NOT NULL
	,Color nvarchar(30) NULL
	,StandardCost money NOT NULL
	,ListPrice money NOT NULL
	,Size nvarchar(30) NULL
	,Weight decimal(8,2) NULL
	,SellStartDate date NULL
	,SellEndDate date NULL
	,DiscontinuedDate date NULL
	,CONSTRAINT PK_Product_ProductKey PRIMARY KEY (ProductKey)
);

CREATE TABLE core.ShipMethod(
	ShipMethodKey int IDENTITY(1, 1)
	,ShipMethodID int NOT NULL
	,ShipMethod nvarchar(100) NOT NULL
	,CONSTRAINT PK_ShipMethod_ShipMethodKey PRIMARY KEY (ShipMethodKey)
);

CREATE TABLE core.Sales(
	SalesKey int IDENTITY(1, 1)
	,SalesOrderID int NOT NULL
	,AddressKey int NOT NULL
	,CustomerKey int NOT NULL
	,ProductKey int NOT NULL
	,ShipMethodKey int NOT NULL
	,PurchaseOrderNumber nvarchar(30) NOT NULL
	,OrderDate date NOT NULL
	,DueDate date NOT NULL
	,ShipDate date NULL
    ,UnitPrice money NOT NULL
	,OrderQty int NOT NULL
    ,UnitPriceDiscount money NOT NULL
    ,LineTotal money NULL
	,SubTotal money NOT NULL
	,TaxAmt money NOT NULL
	,TaxPct decimal(4,3) NOT NULL
	,Freight money NOT NULL
	,TotalDue money NOT NULL
	,IngestionTimestamp datetime DEFAULT CURRENT_TIMESTAMP
	,UpdatedTimestamp datetime NULL
	,CONSTRAINT PK_Sales_SalesKey PRIMARY KEY (SalesKey)
	,CONSTRAINT FK_Sales_Address FOREIGN KEY(AddressKey) REFERENCES core.Address(AddressKey)
	,CONSTRAINT FK_Sales_Customer FOREIGN KEY(CustomerKey) REFERENCES core.Customer(CustomerKey)
	,CONSTRAINT FK_Sales_Product FOREIGN KEY (ProductKey) REFERENCES core.Product(ProductKey)
	,CONSTRAINT FK_Sales_ShipMethod FOREIGN KEY (ShipMethodKey) REFERENCES core.ShipMethod(ShipMethodKey)
);

/*Create indexes for core.Sales table.*/
CREATE NONCLUSTERED INDEX ix_Sales_SalesOrderId
ON core.Sales (SalesOrderID);

CREATE NONCLUSTERED INDEX ix_Sales_AddressKey
ON core.Sales (AddressKey);

CREATE NONCLUSTERED INDEX ix_Sales_CustomerKey
ON core.Sales (CustomerKey);

CREATE NONCLUSTERED INDEX ix_Sales_ProductKey
ON core.Sales (ProductKey);

CREATE NONCLUSTERED INDEX ix_Sales_ShipMethodKey
ON core.Sales (ShipMethodKey);
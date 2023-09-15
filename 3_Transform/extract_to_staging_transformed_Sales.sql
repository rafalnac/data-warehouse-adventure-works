/*Truncate staging table before load.*/
TRUNCATE TABLE stagingtransformed.Sales;

DECLARE @LastLoadedDate datetime;

SELECT @LastLoadedDate = WaterMarkValue
FROM staging.ConfigTable
WHERE TableName = 'SalesLT.SalesOrderDetail';

IF OBJECT_ID('tempdb..#OrdersPerPurchase') IS NULL
BEGIN
	CREATE TABLE #OrdersPerPurchase
	(
		SalesOrderID int
		,PurchaseOrderNumber nvarchar(50)
		,SalesOrderNumber nvarchar(50)
		,OrderDate datetime
		,DueDate datetime
		,ShipDate datetime
		,OrderQty int
		,UnitPrice money
		,UnitPriceDiscount money
		,LineTotal money
		,SubTotal money
		,TaxAmt money
		,Freight money
		,TotalDue money
		,ShipMethod nvarchar(50)
		,CustomerID int
		,ProductID int
		,ShipToAddressID int
		,OrderDetailIngestionTimestamp datetime
		,TaxPct decimal(4,3)
		,OrderQuantityPerPurchase smallint
	)
END
ELSE
BEGIN
	TRUNCATE TABLE #OrdersPerPurchase
END;

/*
Get number of orders for each purchase.
Retrieve only not previously loaded data to perform Incremental Load.
*/
INSERT INTO #OrdersPerPurchase(SalesOrderID, PurchaseOrderNumber, SalesOrderNumber, OrderDate, DueDate, ShipDate, OrderQty, UnitPrice, UnitPriceDiscount
, LineTotal, SubTotal, TaxAmt, Freight, TotalDue, ShipMethod, CustomerID, ProductID, ShipToAddressID, OrderDetailIngestionTimestamp, TaxPct, OrderQuantityPerPurchase)
SELECT
	sod.SalesOrderID
	,soh.PurchaseOrderNumber
	,soh.SalesOrderNumber
	,soh.OrderDate
	,soh.DueDate
	,soh.ShipDate
    ,sod.OrderQty
    ,sod.UnitPrice
    ,sod.UnitPriceDiscount
    ,sod.LineTotal
	,soh.SubTotal
	,soh.TaxAmt
	,soh.Freight
	,soh.TotalDue
	,soh.ShipMethod
	,soh.CustomerID
	,sod.ProductID
	,soh.ShipToAddressID
	,sod.IngestionTimestamp AS OrderDetailIngestionTimestamp
	,ROUND(soh.[TaxAmt] / soh.SubTotal, 2) AS TaxPct
	,SUM(sod.OrderQty) OVER (PARTITION BY soh.SalesOrderNumber) AS OrderQuantityPerPurchase
FROM staging.SalesOrderHeader AS soh
INNER JOIN staging.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE sod.IngestionTimestamp > @LastLoadedDate;

/*Insert into staging transformed table.*/
INSERT INTO stagingtransformed.Sales(SalesOrderID, PurchaseOrderNumber, OrderDate, DueDate, ShipDate, UnitPrice, OrderQty, 
UnitPriceDiscount, LineTotal, SubTotal, TaxAmt, TaxPct, Freight, TotalDue, ShipMethod, CustomerID, ProductID, ShipToAddressID, IngestionTimestamp)
SELECT
	SalesOrderID
	,PurchaseOrderNumber
	,CAST(OrderDate AS date) AS OrderDate
	,CAST(DueDate AS date) AS DueDate
	,CAST(ShipDate AS date) AS ShipDate
    ,UnitPrice
	,OrderQty
    ,UnitPriceDiscount
    ,LineTotal
	,SubTotal / OrderQuantityPerPurchase AS SubTotal
	,TaxAmt / OrderQuantityPerPurchase AS TaxAmt
	,TaxPct
	,Freight/ OrderQuantityPerPurchase AS Freight
	,TotalDue / OrderQuantityPerPurchase AS TotalDue
	,ShipMethod
	,CustomerID
	,ProductID
	,ShipToAddressID
	,OrderDetailIngestionTimestamp
FROM #OrdersPerPurchase;
GO
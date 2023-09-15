/*
Incremental load to persistent table staging.SalesOrderHeader.
Updates to table according to SCD type 1.
*/

/*Truncate staging table*/
--TRUNCATE TABLE staging.SalesOrderHeader;

/*Get last loaded data from config table*/
DECLARE @LastLoadedDate datetime;

SELECT @LastLoadedDate = WaterMarkValue
FROM staging.ConfigTable
WHERE TableName = 'SalesLT.SalesOrderHeader';

/*Get date from source after or equal to last loaded date.*/
DECLARE @IncrementalLoadSalesOrderHeader TABLE(
	SalesOrderID int
	,OrderDate date
	,DueDate date
	,ShipDate date
	,SalesOrderNumber nvarchar(30)
	,PurchaseOrderNumber nvarchar(30)
	,CustomerID int
	,ShipToAddressID int
	,ShipMethod nvarchar(50)
	,SubTotal money
	,TaxAmt money
	,Freight money
	,TotalDue money
);

INSERT INTO @IncrementalLoadSalesOrderHeader(SalesOrderID, OrderDate, DueDate, ShipDate, SalesOrderNumber,
PurchaseOrderNumber, CustomerID, ShipToAddressID, ShipMethod, SubTotal, TaxAmt, Freight, TotalDue)
SELECT
	SalesOrderID
	,OrderDate
	,DueDate
	,ShipDate
	,SalesOrderNumber
	,PurchaseOrderNumber
	,CustomerID
	,ShipToAddressID
	,ShipMethod
	,SubTotal
	,TaxAmt
	,Freight
	,TotalDue
FROM SalesLT.SalesOrderHeader
WHERE ModifiedDate >= @LastLoadedDate;

/*Load to table staging.SalesOrderHeader.*/
MERGE INTO staging.SalesOrderheader AS t
USING @IncrementalLoadSalesOrderHeader AS s
ON t.SalesOrderID = s.SalesOrderID
WHEN MATCHED THEN UPDATE SET
	t.OrderDate = s.OrderDate
	,t.DueDate = s.DueDate
	,t.ShipDate = s.ShipDate
	,t.SalesOrderNumber = s.SalesOrderNumber
	,t.PurchaseOrderNumber = s.PurchaseOrderNumber
	,t.CustomerID = s.CustomerID
	,t.ShipToAddressID = s.ShipToAddressID
	,t.ShipMethod = s.ShipMethod
	,t.SubTotal = s.SubTotal
	,t.TaxAmt = s.TaxAmt
	,t.Freight = s.Freight
	,t.TotalDue = s.TotalDue
	,t.IngestionTimestamp = CURRENT_TIMESTAMP
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
	SalesOrderID
	,OrderDate
	,DueDate
	,ShipDate
	,SalesOrderNumber
	,PurchaseOrderNumber
	,CustomerID
	,ShipToAddressID
	,ShipMethod
	,SubTotal
	,TaxAmt
	,Freight
	,TotalDue
)
VALUES
(
	s.SalesOrderID
	,s.OrderDate
	,s.DueDate
	,s.ShipDate
	,s.SalesOrderNumber
	,s.PurchaseOrderNumber
	,s.CustomerID
	,s.ShipToAddressID
	,s.ShipMethod
	,s.SubTotal
	,s.TaxAmt
	,s.Freight
	,s.TotalDue
);
GO
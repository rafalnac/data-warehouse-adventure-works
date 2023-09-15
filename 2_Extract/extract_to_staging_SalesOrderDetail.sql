/*
Incremental load to persistent table staging.SalesOrderDetail.
Updates to table according to SCD type 1.
*/

/*Truncate staging table*/
--TRUNCATE TABLE staging.SalesOrderDetail;

/*Get last loaded data from config table*/
DECLARE @LastLoadedDate datetime;

SELECT @LastLoadedDate = WaterMarkValue
FROM staging.ConfigTable
WHERE  TableName = 'SalesLT.SalesOrderDetail';

/*Get date from source after or equal to last loaded date.*/
DECLARE @IncrementalLoadSalesOrderDetail TABLE(
	SalesOrderID int
    ,SalesOrderDetailID int
    ,OrderQty int
    ,ProductID int
    ,UnitPrice money
    ,UnitPriceDiscount money
    ,LineTotal money
);

/*Get latest data from SalesOrderDetail.*/
INSERT INTO @IncrementalLoadSalesOrderDetail(SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount, LineTotal)
SELECT
	SalesOrderID
    ,SalesOrderDetailID
    ,OrderQty
    ,ProductID
    ,UnitPrice
    ,UnitPriceDiscount
    ,LineTotal
FROM SalesLT.SalesOrderDetail
WHERE ModifiedDate >= @LastLoadedDate;

/*Load to table staging.SalesOrderDetail.*/
MERGE INTO staging.SalesOrderDetail AS t
USING @IncrementalLoadSalesOrderDetail AS s
ON t.SalesOrderDetailID = s.SalesOrderDetailID
WHEN MATCHED THEN UPDATE SET
	t.SalesOrderID = s.SalesOrderID
    ,t.OrderQty = s.OrderQty
    ,t.ProductID = s.ProductID
    ,t.UnitPrice = s.UnitPrice
    ,t.UnitPriceDiscount = s.UnitPriceDiscount
    ,t.LineTotal = s.LineTotal
	,t.IngestionTimestamp = CURRENT_TIMESTAMP
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
	SalesOrderID
    ,SalesOrderDetailID
    ,OrderQty
    ,ProductID
    ,UnitPrice
    ,UnitPriceDiscount
    ,LineTotal
)
VALUES
(
	s.SalesOrderID
    ,s.SalesOrderDetailID
    ,s.OrderQty
    ,s.ProductID
    ,s.UnitPrice
    ,s.UnitPriceDiscount
    ,s.LineTotal
);
GO
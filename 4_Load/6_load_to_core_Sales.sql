/*
Load to Sales core table.
Updates according to SCD Type 1.
*/

MERGE INTO core.Sales AS t
USING
(
	SELECT
		SalesOrderID
		,a.AddressKey
		,c.CustomerKey
		,p.ProductKey
		,sm.ShipMethodKey
		,PurchaseOrderNumber
		,OrderDate
		,DueDate
		,ShipDate
		,UnitPrice
		,OrderQty
		,UnitPriceDiscount
		,LineTotal
		,SubTotal
		,TaxAmt
		,TaxPct
		,Freight
		,TotalDue
		,s.ShipMethod
		,IngestionTimestamp
		,ProcessedTimestamp
	FROM stagingtransformed.Sales AS s
	LEFT JOIN core.Address AS a ON s.ShipToAddressID = a.AddressID
	LEFT JOIN core.Customer AS c ON s.CustomerID = c.CustomerID
	LEFT JOIN core.Product AS p ON s.ProductID = p.ProductID
	LEFT JOIN core.ShipMethod AS sm ON s.ShipMethod = sm.ShipMethod
) AS s
ON t.SalesOrderID = t.SalesOrderID AND s.ProductKey = t.ProductKey
WHEN MATCHED THEN UPDATE SET
	t.AddressKey = s.AddressKey
	,t.CustomerKey = s.CustomerKey
	,t.ShipMethodKey = s.ShipMethodKey
	,t.PurchaseOrderNumber = s.PurchaseOrderNumber
	,t.OrderDate = s.OrderDate
	,t.DueDate = s.DueDate
	,t.ShipDate = s.ShipDate
	,t.UnitPrice = s.UnitPrice
	,t.OrderQty = s.OrderQty
	,t.UnitPriceDiscount = s.UnitPriceDiscount
	,t.LineTotal = s.LineTotal
	,t.SubTotal = s.SubTotal
	,t.TaxAmt = s.TaxAmt
	,t.TaxPct = s.TaxPct
	,t.Freight = s.Freight
	,t.TotalDue = s.TotalDue
	,t.UpdatedTimestamp = CURRENT_TIMESTAMP
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
	SalesOrderID
	,AddressKey
	,CustomerKey
	,ProductKey
	,ShipMethodKey
	,PurchaseOrderNumber
	,OrderDate
	,DueDate
	,ShipDate
	,UnitPrice
	,OrderQty
	,UnitPriceDiscount
	,LineTotal
	,SubTotal
	,TaxAmt
	,TaxPct
	,Freight
	,TotalDue
	,IngestionTimestamp
)
VALUES
(
	s.SalesOrderID
	,s.AddressKey
	,s.CustomerKey
	,s.ProductKey
	,s.ShipMethodKey
	,s.PurchaseOrderNumber
	,s.OrderDate
	,s.DueDate
	,s.ShipDate
	,s.UnitPrice
	,s.OrderQty
	,s.UnitPriceDiscount
	,s.LineTotal
	,s.SubTotal
	,s.TaxAmt
	,s.TaxPct
	,s.Freight
	,s.TotalDue
	,CURRENT_TIMESTAMP
);
GO


/*Insert new data from staging to staging transformed table*/

DECLARE @DistinctShipMethod TABLE(
	ShipMethod nvarchar(100)
);

INSERT INTO @DistinctShipMethod
SELECT
	DISTINCT(ShipMethod)
FROM staging.SalesOrderHeader;

INSERT INTO stagingtransformed.ShipMethod(ShipMethod)
SELECT
	ShipMethod
FROM
	(
		SELECT
			ShipMethod
		FROM @DistinctShipMethod
		EXCEPT
		SELECT
			ShipMethod
		FROM stagingtransformed.ShipMethod
	) AS Shipping;
GO
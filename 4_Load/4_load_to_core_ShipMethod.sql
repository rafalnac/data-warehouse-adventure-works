/*Load to dimension table.*/

INSERT INTO core.ShipMethod(ShipMethodID, ShipMethod)
SELECT
	ShipMethodID
	,ShipMethod
FROM stagingtransformed.ShipMethod AS s
WHERE NOT EXISTS(
	SELECT
		t.ShipMethodID
		,t.ShipMethod
	FROM core.ShipMethod AS t
	WHERE t.ShipMethodID = s.ShipMethodID
);

UPDATE t
SET
	t.ShipMethod = s.ShipMethod
FROM core.ShipMethod AS t
INNER JOIN [stagingtransformed].[ShipMethod] AS s
ON t.ShipMethodID = s.ShipMethodID;
GO

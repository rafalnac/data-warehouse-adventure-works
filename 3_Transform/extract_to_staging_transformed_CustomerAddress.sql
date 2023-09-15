/*Truncate staging table before load.*/
TRUNCATE TABLE stagingtransformed.CustomerAddress;

/*Insert data from staging to staging transformed table*/
INSERT INTO stagingtransformed.CustomerAddress(CustomerID, AddressID, AddressType, City, PostalCode, StateProvince, CountryRegion, IngestionTimestamp)
SELECT
	sca.CustomerID
    ,sca.AddressID
    ,sca.AddressType
	,sa.City
	,sa.PostalCode
	,sa.StateProvince
	,sa.CountryRegion
	,sca.IngestionTimestamp
FROM staging.CustomerAddress AS sca
LEFT JOIN staging.Address AS sa ON sca.AddressID = sa.AddressID;
GO
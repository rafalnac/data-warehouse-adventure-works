/*Truncate staging table before load.*/
TRUNCATE TABLE stagingtransformed.Address;

/*Insert into staging transformed table.*/
INSERT INTO stagingtransformed.Address(AddressID ,City ,StateProvince ,CountryRegion ,PostalCode ,IngestionTimestamp)
SELECT
	AddressID
    ,City
    ,StateProvince
    ,CountryRegion
    ,PostalCode
    ,IngestionTimestamp
FROM staging.Address;
GO
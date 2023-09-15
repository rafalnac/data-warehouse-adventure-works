/*Truncate staging table*/
TRUNCATE TABLE staging.Address;

/*Insert data from the source table into the staging table*/
INSERT INTO staging.Address(AddressID, City, StateProvince, CountryRegion, PostalCode)
SELECT
	AddressID
    ,City
    ,StateProvince
    ,CountryRegion
    ,PostalCode
FROM SalesLT.Address;
GO
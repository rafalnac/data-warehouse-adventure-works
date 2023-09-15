/*Truncate staging table*/
TRUNCATE TABLE staging.CustomerAddress;

/*Insert data from the source table into the staging table*/
SELECT
	CustomerID
    ,AddressID
    ,AddressType
FROM SalesLT.CustomerAddress;
GO
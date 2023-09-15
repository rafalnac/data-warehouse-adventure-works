/*Truncate staging table before load.*/
TRUNCATE TABLE stagingtransformed.Customer;

/*Insert into staging transformed table.*/
INSERT INTO stagingtransformed.Customer(CustomerID, Title, CustomerFullName, CompanyName, AssignedSalesPerson, IngestionTimestamp)
SELECT
	CustomerID
    ,COALESCE(Title, 'Not Provided') AS Title
	,TRIM(
		CASE
			WHEN MiddleName IS NULL THEN CONCAT(FirstName, ' ', LastName, ' ', Suffix)
			ELSE CONCAT(FirstName, ' ', MiddleName, ' ', LastName, ' ', Suffix)
		END
	)AS CustomerFullName
    ,CompanyName
	,RIGHT(SalesPerson, (LEN(SalesPerson) - CHARINDEX('\', SalesPerson))) AS AssignedSalesPerson
    ,IngestionTimestamp
FROM staging.Customer;
GO
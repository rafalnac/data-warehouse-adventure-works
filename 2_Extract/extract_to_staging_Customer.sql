/*Truncate staging table*/
TRUNCATE TABLE staging.Customer;

/*Insert data from the source table into the staging table*/
INSERT INTO staging.Customer(CustomerID, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, SalesPerson)
SELECT
	CustomerID
    ,Title
    ,FirstName
    ,MiddleName
    ,LastName
    ,Suffix
    ,CompanyName
    ,SalesPerson
FROM SalesLT.Customer;
GO
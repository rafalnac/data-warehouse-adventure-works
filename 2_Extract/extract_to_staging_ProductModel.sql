/*Truncate staging table*/
TRUNCATE TABLE staging.ProductModel;

/*Insert data from the source table into the staging table*/
INSERT INTO staging.ProductModel(ProductModelID, Name)
SELECT
	ProductModelID
    ,Name
FROM SalesLT.ProductModel;
GO
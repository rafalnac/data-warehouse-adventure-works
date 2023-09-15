/*Truncate staging table*/
TRUNCATE TABLE staging.ProductCategory;

/*Insert data from the source table into the staging table*/
INSERT INTO staging.ProductCategory(ProductCategoryID, Name)
SELECT
	ProductCategoryID
    ,Name
FROM SalesLT.ProductCategory;
GO
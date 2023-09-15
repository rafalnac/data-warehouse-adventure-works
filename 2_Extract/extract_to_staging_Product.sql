/*Truncate staging table*/
TRUNCATE TABLE staging.Product;

/*Insert data from the source table into the staging table*/
INSERT INTO staging.Product(ProductID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight,
ProductCategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate)
SELECT
	ProductID
    ,Name
    ,ProductNumber
    ,Color
    ,StandardCost
    ,ListPrice
    ,Size
    ,Weight
    ,ProductCategoryID
    ,ProductModelID
    ,SellStartDate
    ,SellEndDate
    ,DiscontinuedDate
FROM SalesLT.Product;
GO
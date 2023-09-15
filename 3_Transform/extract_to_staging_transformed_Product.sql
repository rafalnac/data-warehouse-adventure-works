/*Truncate staging table before load.*/
TRUNCATE TABLE stagingtransformed.Product;

/*Insert data from staging to staging transformed table*/
INSERT INTO stagingtransformed.Product(ProductID, Name, Category, Model, ProductNumber, Color, StandardCost ,ListPrice,
Size, Weight, SellStartDate, SellEndDate, DiscontinuedDate, IngestionTimestamp)
SELECT
	p.ProductID
    ,p.Name AS Name
	,pc.Name AS Category
	,pm.Name AS Model
    ,p.ProductNumber
    ,COALESCE(p.Color, 'Not provided') AS Color
    ,p.StandardCost
    ,p.ListPrice
    ,COALESCE(p.Size, 'Not provided') AS Size
    ,Weight
    ,CAST(p.SellStartDate AS date) AS SellStartDate
    ,CAST(p.SellEndDate AS date) AS SellEndDate
    ,CAST(p.DiscontinuedDate AS date) AS DiscontinuedDate
    ,p.IngestionTimestamp
FROM staging.Product AS p
LEFT JOIN staging.ProductCategory AS pc ON p.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN staging.ProductModel as pm ON p.ProductModelID = pm.ProductModelID;
GO
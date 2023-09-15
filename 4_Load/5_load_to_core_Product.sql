/*Load into dimension table - SCD Type 1.*/

MERGE INTO core.Product AS t
USING stagingtransformed.Product AS s
ON t.productID = s.productID
WHEN MATCHED THEN
UPDATE SET
    t.Name = s.Name
    ,t.Category = s.Category 
    ,t.Model = s.Model
    ,t.ProductNumber = s.ProductNumber
    ,t.Color = s.Color 
    ,t.StandardCost = s.StandardCost
    ,t.ListPrice = s.ListPrice
    ,t.Size = s.Size
    ,t.Weight = s.Weight
    ,t.SellStartDate = s.SellStartDate
    ,t.SellEndDate = s.SellEndDate
    ,t.DiscontinuedDate = s.DiscontinuedDate
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
	productID
	,Name
    ,Category
    ,Model
    ,ProductNumber
    ,Color
    ,StandardCost
    ,ListPrice
    ,Size
    ,Weight
    ,SellStartDate
    ,SellEndDate
    ,DiscontinuedDate
)
VALUES
(
	s.productID
	,s.Name
	,s.Category
	,s.Model
	,s.ProductNumber
	,s.Color
	,s.StandardCost
	,s.ListPrice
	,s.Size
	,s.Weight
	,s.SellStartDate
	,s.SellEndDate
	,s.DiscontinuedDate
);
SELECT * FROM core.Product;
GO
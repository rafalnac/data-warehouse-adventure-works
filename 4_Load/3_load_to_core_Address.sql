/*Load to dimension table - SCD Type 1.*/

MERGE INTO core.Address AS t
USING stagingtransformed.Address AS s
ON t.AddressID = s.AddressID
WHEN MATCHED THEN
UPDATE SET
	t.City = s.City
	,t.StateProvince = s.StateProvince
	,t.CountryRegion = s.StateProvince
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
	AddressID
    ,City
    ,StateProvince
    ,CountryRegion
    ,PostalCode
)
VALUES
(
	s.AddressID
    ,s.City
    ,s.StateProvince
    ,s.CountryRegion
    ,s.PostalCode
);
GO
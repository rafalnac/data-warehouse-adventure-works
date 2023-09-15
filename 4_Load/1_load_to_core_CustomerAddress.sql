/*SCD Type 2 Load into core.CustomerAddress table.*/

DECLARE @MergeOutputTable TABLE
(
	CustomerID int
	,AddressID int
	,AddressType nvarchar(50)
	,City nvarchar(30)
	,PostalCode nvarchar(30)
	,StateProvince nvarchar(50) 
	,CountryRegion nvarchar(50)
	,StartDate date
	,EndDate date
	,IsCurrent nchar(2)
);

INSERT INTO @MergeOutputTable(CustomerID, AddressID, AddressType, City, PostalCode, StateProvince, CountryRegion, StartDate, EndDate, IsCurrent)
SELECT
	CustomerID
	,AddressID
	,AddressType
	,City
	,PostalCode
	,StateProvince
	,CountryRegion
	,StartDate
	,EndDate
	,IsCurrent
FROM
(
MERGE INTO core.CustomerAddress AS T
USING stagingtransformed.CustomerAddress AS S
ON T.CustomerID = S.CustomerID AND T.AddressType = S.AddressType
WHEN MATCHED
	AND T.EndDate IS NULL
	AND(
		T.City <> S.City OR
		T.PostalCode <> S.PostalCode OR
		T.StateProvince <> S.StateProvince OR
		T.CountryRegion <> S.CountryRegion
	)
THEN UPDATE SET
	T.EndDate = GETDATE()
	,T.IsCurrent = 'N'
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
	CustomerID
	,AddressID
	,AddressType
	,City
	,PostalCode
	,StateProvince
	,CountryRegion
	,StartDate
	,EndDate
	,IsCurrent
)
VALUES
(
	S.CustomerID
	,S.AddressID
	,S.AddressType
	,S.City
	,S.PostalCode
	,S.StateProvince
	,S.CountryRegion
	,CAST(GETDATE() AS date)
	,NULL
	,'Y'
)
OUTPUT
	$action AS ActionType
	,S.CustomerID
	,S.AddressID
	,S.AddressType
	,S.City
	,S.PostalCode
	,S.StateProvince
	,S.CountryRegion
	,CAST(GETDATE() AS date) AS StartDate
	,NULL AS EndDate
	,'Y' AS IsCurrent
) AS MergeOutput
WHERE ActionType='UPDATE';


INSERT INTO core.CustomerAddress(CustomerID, AddressID, AddressType, City, PostalCode,
StateProvince, CountryRegion, StartDate, EndDate, IsCurrent)
SELECT
	CustomerID
	,AddressID
	,AddressType
	,City
	,PostalCode
	,StateProvince
	,CountryRegion
	,StartDate
	,EndDate
	,IsCurrent
FROM @MergeOutputTable;

/*
Insert negative values for CustomerAddressKey to handle null values
for tables referencing CustomerAddressKey as FOREIGN KEY andhave nulls.

CustomerAddressKey: -1
Customer in core.Customer table did not provided address.

core.Customer(CustomerAddressKey) REFERENCES core.CustomerAddress(CustomerAddressKey)
hence null values will appear in core.CustomerAddress(CustomerAddressKey).

Null values in core.CustomerAddress(CustomerAddressKey) are replaced by -1
to mach created key which handles occured null values.
*/
IF NOT EXISTS(SELECT CustomerAddressKey FROM core.CustomerAddress WHERE CustomerAddressKey = -1)
BEGIN

SET IDENTITY_INSERT core.CustomerAddress ON;

INSERT INTO core.CustomerAddress(CustomerAddressKey, CustomerID, AddressID, AddressType, City, PostalCode,
StateProvince, CountryRegion, StartDate, EndDate, IsCurrent)
VALUES
(
	-1
	,-1
	,-1,
	'Not provided'
	,'Not provided'
	,'Not provided'
	,'Not provided'
	,'Not provided'
	,CAST(GETDATE() AS date)
	,NULL
	,'Y'
);
SET IDENTITY_INSERT core.CustomerAddress OFF;
END;
GO
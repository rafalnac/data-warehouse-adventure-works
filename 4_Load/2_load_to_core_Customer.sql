/*SCD Type 2 load into core.Customer table*/

/*Declare temp table to store updated records to insert according to SCD Type 2.*/
DECLARE @OutputTable TABLE (
	CustomerID int
	,CustomerAddressKey int
	,CustomerFullName nvarchar(100)
	,CompanyName nvarchar(100)
	,AssignedSalesPerson nvarchar(100)
	,StartDate date
	,EndDate date
	,IsCurrent nchar(2)
)

/*Insert to temp table updated records from merge statement.*/
INSERT INTO @OutputTable(CustomerID, CustomerAddressKey, CustomerFullName, CompanyName, AssignedSalesPerson, StartDate, EndDate, IsCurrent)
SELECT
	CustomerID
	,CustomerAddressKey
	,CustomerFullName
	,CompanyName
	,AssignedSalesPerson
	,StartDate
	,EndDate
	,IsCurrent
FROM
(
/*Merge into dimension table.*/
MERGE INTO core.Customer AS t
USING
(
/*Get AddressKey for each customer.*/
	SELECT
		c.CustomerID
		,COALESCE(ca.CustomerAddressKey, -1) AS CustomerAddressKey /*Not All customers provided their address*/
		,c.CustomerFullName
		,c.CompanyName
		,c.AssignedSalesPerson
	FROM stagingtransformed.Customer AS c
	LEFT JOIN core.CustomerAddress AS ca ON c.CustomerID = ca.CustomerID
) AS s
ON t.CustomerID = s.CustomerID
WHEN MATCHED
	AND t.EndDate IS NULL
	AND(
		t.CustomerFullName <> s.CustomerFullName
		OR t.CompanyName <> s.CompanyName
		OR t.AssignedSalesPerson <> s.AssignedSalesPerson
	)
THEN UPDATE SET
	t.EndDate = CAST(GETDATE() AS date)
	,t.IsCurrent = 'N'
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
	CustomerID
	,CustomerAddressKey
	,CustomerFullName
	,CompanyName
	,AssignedSalesPerson
	,StartDate
	,EndDate
	,IsCurrent
)
VALUES
(
	s.CustomerID
	,s.CustomerAddressKey
	,s.CustomerFullName
	,s.CompanyName
	,s.AssignedSalesPerson
	,CAST(GETDATE() AS date)
	,NULL
	,'Y'
)
OUTPUT
	$Action AS ActionType
	,s.CustomerID
	,s.CustomerAddressKey
	,s.CustomerFullName
	,s.CompanyName
	,s.AssignedSalesPerson
	,CAST(GETDATE() AS date) AS StartDate
	,NULL AS EndDate
	,'Y' AS IsCurrent
) AS MergedOutput
WHERE ActionType = 'Update';

/*Insert updated records for updated customers.*/
INSERT INTO core.Customer(CustomerID, CustomerAddressKey, CustomerFullName, CompanyName, AssignedSalesPerson, StartDate, EndDate, IsCurrent)
SELECT
	CustomerID
	,CustomerAddressKey
	,CustomerFullName
	,CompanyName
	,AssignedSalesPerson
	,StartDate
	,EndDate
	,IsCurrent
FROM @OutputTable;
GO
/*Create schema for staging layer.*/
IF SCHEMA_ID('staging') IS NULL
	EXEC sys.sp_sqlexec N'CREATE SCHEMA staging';
GO

/*Create schema for staging transformed layer.*/
IF SCHEMA_ID('stagingtransformed') IS NULL
	EXEC sys.sp_sqlexec N'CREATE SCHEMA stagingtransformed';
GO

/*Create schema for core layer.*/
IF SCHEMA_ID('core') IS NULL
	EXEC sys.sp_sqlexec N'CREATE SCHEMA core';
GO
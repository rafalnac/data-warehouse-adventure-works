/*Adding Azure Data Factory system assigned managed identity as a user to Azure SQL Database*/
CREATE USER [adf-adw-dw] FROM EXTERNAL PROVIDER;

/*Grant permission to created user.*/
ALTER ROLE db_datareader ADD MEMBER [adf-adw-dw];
ALTER ROLE db_datawriter ADD MEMBER [adf-adw-dw];
ALTER ROLE db_owner ADD MEMBER [adf-adw-dw];

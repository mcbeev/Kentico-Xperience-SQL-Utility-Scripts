
/* For reference, show recovery models of all DBs */
SELECT [name], [recovery_model_desc] FROM sys.databases
GO 

/* Step 1 - Change Recovery Model to Simple */
ALTER DATABASE [Your Database Name Here] SET RECOVERY SIMPLE;
GO

/* Step 2 - Release the marked space to OS */
DECLARE @DataFile SYSNAME, @LogFile SYSNAME;

SELECT @DataFile = RTRIM(LTRIM(name)) FROM sys.database_files WHERE TYPE = 0;

SELECT @LogFile = RTRIM(LTRIM(name)) FROM sys.database_files WHERE TYPE = 1;

--DBCC Shrinkfile(@DataFile , 100); --If you want to shrink the data file too, uncomment this line
DBCC Shrinkfile(@LogFile , 100);

/* Step 3 - Change Recovery Model back to FULL */
ALTER DATABASE [Your Database Name Here] SET RECOVERY FULL;
GO 

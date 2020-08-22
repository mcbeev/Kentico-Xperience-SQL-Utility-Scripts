/* KenticoDeleteOMContact.v8.sql                */
/* Goal: Clear out OM_Contact in bulk        */
/* Description: Bulk delete OM_Contact data    */
/*    and all of the related FK data by date    */
/* Intended Verison: Kentico 8.x            */
/* Author: Brian McKeiver (mcbeev@gmail.com)*/
/* Revision: 1.0                            */
/* Comment: Removing 10k rows took ~ 8 secs    */

DECLARE @imax        INT
DECLARE @i            INT
DECLARE @cnt        INT
DECLARE @batchSize    INT
DECLARE @whereParam NVARCHAR(max)
DECLARE @StartDate    DATETIME
DECLARE @EndDate    DATETIME

--date range to remove data from, start small to make sure it works !!
--SET @StartDate = DATEADD(yyyy, -2, DATEADD(dd, 1, GETDATE()))
SET @StartDate = '2/14/2015'
--SET @EndDate = DATEADD(yyyy, -1, DATEADD(dd, 1, GETDATE()))
SET @EndDate = '2/14/2015'

--How many to delete at a time, be careful!
SET @batchSize = 10000

--used for mass delete param
SET  @whereParam = '(ContactEmail IS NULL) AND (ContactCreated BETWEEN '''+ CAST(@StartDate as varchar(20)) +''' AND '''+ CAST(@EndDate as varchar(20)) +''')'

--figure out how many times we need to loop to clear the data in bulk
SELECT @cnt = Count(ContactID) FROM OM_Contact WHERE OM_Contact.ContactCreated BETWEEN @StartDate AND @EndDate And ContactEmail IS NULL

PRINT 'Records found to delete based on searching ' + CAST(@StartDate as varchar(20)) + ' - ' + CAST(@EndDate as varchar(20)) + ' :'
PRINT @cnt
PRINT 'Starting to delete at: '+ CAST(GETDATE() as nvarchar)

--figure out how many times we need to loop to clear the data in bulk, 
-- and make sure we have 1 extra iteration in case of less than 100
SET  @imax = (@cnt / @batchSize) + 1

--loop counter
SET @i = 1 

SET NOCOUNT ON;

--release the kracken    
WHILE (@i <= @imax)
BEGIN
    
    EXEC [Proc_OM_Contact_MassDelete] @whereParam, @batchSize

    PRINT 'Deleted batch: '+ CAST(@i as nvarchar)
    SET @i = @i + 1
END

PRINT 'Finished to delete at: '+ CAST(GETDATE() as nvarchar)
PRINT 'Max Records deleted: ' + CAST(((@i - 1) * @batchSize) as nvarchar)
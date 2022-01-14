-------------------------------------------------------------------------------
-------- POST UPGRADE Kentico Xperience 12 to Kentico Xperience 13  -----------
-------- Table + Column Schema Check                               ------------
-- Instances of Kentico Xperience that started before KX 12 may have an old  --
-- Tables, Views, Index/Constraints/Functions, etc.  These should be updated,--
-- obsolete items removed, and items updated if they differ from a fresh     --
-- Kentico Xperience 13 installation.                                        --
--                                                                           --
-- INSTRUCTIONS: 
--  1. Have a fresh Kentico Xperience 13 database for comparison             --
--  2. Find and replace FRESH_XPERIENCEDB with the fresh Kentico 13 database --
--  3. Find and replace UPGRADED_XPERIENCEDB with the database you upgrade   --
--  4. Run the query                                                         --
--  5. Any table columns that show mean that the Column def differs and you  --
--       should update your upgraded database to match the fresh copy        --
--  6. Any tables that exist in one database vs the other should be either   --
--       added or removed, or no action taken if it's a custom element       --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

DECLARE @TableName nvarchar(100);
 
DECLARE CUR_TABLES CURSOR FAST_FORWARD FOR
    SELECT distinct TableName
    FROM  (
		SELECT TABLE_SCHEMA+'.'+TABLE_NAME as TableName FROM FRESH_XPERIENCEDB.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
		UNION ALL
		SELECT TABLE_SCHEMA+'.'+TABLE_NAME as TableName FROM UPGRADED_XPERIENCEDB.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
		) a
	order by TableName
 
OPEN CUR_TABLES
FETCH NEXT FROM CUR_TABLES INTO @TableName
 
WHILE @@FETCH_STATUS = 0
BEGIN

IF (EXISTS (SELECT * FROM FRESH_XPERIENCEDB.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA+'.'+TABLE_NAME = @TableName) and EXISTS (SELECT * FROM UPGRADED_XPERIENCEDB.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA+'.'+TABLE_NAME = @TableName))
BEGIN
	-- Exists in both, compare
if(EXISTS(
	SELECT @TableName as [Table], name, system_type_id, user_type_id,max_length, precision,scale, is_nullable, is_identity FROM FRESH_XPERIENCEDB.sys.columns
	WHERE object_id = OBJECT_ID('FRESH_XPERIENCEDB.'+@TableName)
	EXCEPT
	SELECT @TableName as [Table], name, system_type_id, user_type_id,max_length, precision,scale, is_nullable, is_identity FROM UPGRADED_XPERIENCEDB.sys.columns
	WHERE object_id = OBJECT_ID('UPGRADED_XPERIENCEDB.'+@TableName)
	)) 
	BEGIN
		-- Show differences
		SELECT @TableName as [Table], name, system_type_id, user_type_id,max_length, precision,scale, is_nullable, is_identity FROM FRESH_XPERIENCEDB.sys.columns
		WHERE object_id = OBJECT_ID('FRESH_XPERIENCEDB.'+@TableName)
		EXCEPT
	
		SELECT @TableName as [Table], name, system_type_id, user_type_id,max_length, precision,scale, is_nullable, is_identity FROM UPGRADED_XPERIENCEDB.sys.columns
		WHERE object_id = OBJECT_ID('UPGRADED_XPERIENCEDB.'+@TableName)
	end
END else begin
	-- Show which database it doesn't exist in
	Select case when EXISTS(SELECT * FROM FRESH_XPERIENCEDB.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' and TABLE_SCHEMA+'.'+TABLE_NAME = @TableName) then 'FRESH_XPERIENCEDB' else 'UPGRADED_XPERIENCEDB' end + '.'+@TableName as [No Match Table]
end
	
   FETCH NEXT FROM CUR_TABLES INTO @TableName
END
CLOSE CUR_TABLES
DEALLOCATE CUR_TABLES
GO



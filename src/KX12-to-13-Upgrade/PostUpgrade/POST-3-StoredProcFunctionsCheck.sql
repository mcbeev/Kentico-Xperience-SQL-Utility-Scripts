-------------------------------------------------------------------------------
-------- POST UPGRADE Kentico Xperience 12 to Kentico Xperience 13  -----------
-------- Function/Procedure Check                                  ------------
-- Instances of Kentico Xperience that started before KX 12 may have an old  --
-- Tables, Views, Index/Constraints/Functions, etc.  These should be updated,--
-- obsolete items removed, and items updated if they differ from a fresh     --
-- Kentico Xperience 13 installation.                                        --
--                                                                           --
-- INSTRUCTIONS: 
--  1. Have a fresh Kentico Xperience 13 database for comparison             --
--  2. Find and replace FRESH_XPERIENCEDB with the fresh Kentico 13 database --
--  3. Find and replace UPGRADED_XPERIENCEDB with the database you upgrade   --
--  4. Run the queries                                                       --
--  5. The First set show any Functions/Procs that need to be removed        --
--     Or added to the Upgraded database.                                    --
--  6. The second query compares the CONTENT of matching Functions/Procs     --
--     for these items...                                                    --
--     A. Find the corresponding element on the fresh Kentico Xperience 13   --
--        Database, then right click on it -> 'Script ___  as' -> Alter to ->--
--        Clipboard.
--     B. Paste into a window, ensure the DB Context is the upgraded database--
--     C. Run the generated code on your upgraded db (everything below the   --
--        'Using [FRESH_XPERIENCEDB] GO' portion                             --
--  7. Re-run the query to ensure fixed.                                     --
--                                                                           --
--  NOTE: The Function/Proc match check does a loose string comparison, they --
--    may be functionality identical but slightly different in syntax. Plus  --
--    the generated Alter statement may not match the original proc.  If you --
--    can't get a function/proc to match even after updating it, you can run --
--    the Alter Function/Proc on the Fresh Kentico Xperience 13 databaes so  --
--    it's text will match what you are updating on your upgraded one.       --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

-- Checks Views that are found in one but not the other
-- Can remove un-needed procs/functions, and add missing ones
SELECT 
  ROUTINE_NAME, 'Remove From UPGRADED_XPERIENCEDB Custom' as Instructions
FROM UPGRADED_XPERIENCEDB.INFORMATION_SCHEMA.ROUTINES
EXCEPT
SELECT 
  ROUTINE_NAME, 'Remove From UPGRADED_XPERIENCEDB Custom' as Instructions
FROM FRESH_XPERIENCEDB.INFORMATION_SCHEMA.ROUTINES

SELECT 
  ROUTINE_NAME, 'Add To UPGRADED_XPERIENCEDB' as Instructions
FROM FRESH_XPERIENCEDB.INFORMATION_SCHEMA.ROUTINES
EXCEPT
SELECT 
  ROUTINE_NAME, 'Add To UPGRADED_XPERIENCEDB' as Instructions
FROM UPGRADED_XPERIENCEDB.INFORMATION_SCHEMA.ROUTINES


-- Stored procs that differ in content
select * from (
SELECT 
  ROUTINE_NAME, LTRIM(RTRIM(Replace(Replace(Replace(REPLACE(ROUTINE_DEFINITION, '[dbo].',''),'   ',' '),CHAR(13), ' '),char(10), ' '))) as ROUTINE_DEFINITION, 'Update' as Instructions
FROM UPGRADED_XPERIENCEDB.INFORMATION_SCHEMA.ROUTINES where Routine_name in (Select Routine_name from FRESH_XPERIENCEDB.INFORMATION_SCHEMA.ROUTINES)
EXCEPT
SELECT 
  ROUTINE_NAME, LTRIM(RTRIM(Replace(Replace(Replace(REPLACE(ROUTINE_DEFINITION, '[dbo].',''),'   ',' '),CHAR(13), ' '),char(10), ' '))) as ROUTINE_DEFINITION, 'Update' as Instructions
FROM FRESH_XPERIENCEDB.INFORMATION_SCHEMA.ROUTINES
) combined order by Routine_Name
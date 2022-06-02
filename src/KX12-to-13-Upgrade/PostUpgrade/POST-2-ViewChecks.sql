-------------------------------------------------------------------------------
-------- POST UPGRADE Kentico Xperience 12 to Kentico Xperience 13  -----------
-------- View Check                                                ------------
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
--  5. Remove any Views that are not custom and seem to be obsolete          --
--  6. Add any Views that are missing from the Upgraded that are present on  --
--     fresh Kentico Xperience 13 database.  You can Right-click on the view --
--     and "Script View As -> Create To -> Clipboard, then paste and run in  --
--     the context of your Upgraded database                                 --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

-- Checks Views that are found in one but not the other

SELECT 
  TABLE_NAME as View_Name, 'Remove From UPGRADED_XPERIENCEDB' as Instructions
FROM UPGRADED_XPERIENCEDB.INFORMATION_SCHEMA.VIEWS
EXCEPT
SELECT 
  TABLE_NAME as View_Name, 'Remove From UPGRADED_XPERIENCEDB' as Instructions
FROM FRESH_XPERIENCEDB.INFORMATION_SCHEMA.VIEWS

SELECT 
  TABLE_NAME as View_Name, 'Add To UPGRADED_XPERIENCEDB' as Instructions
FROM FRESH_XPERIENCEDB.INFORMATION_SCHEMA.VIEWS
EXCEPT
SELECT 
  TABLE_NAME as View_Name, 'Add To UPGRADED_XPERIENCEDB' as Instructions
FROM UPGRADED_XPERIENCEDB.INFORMATION_SCHEMA.VIEWS


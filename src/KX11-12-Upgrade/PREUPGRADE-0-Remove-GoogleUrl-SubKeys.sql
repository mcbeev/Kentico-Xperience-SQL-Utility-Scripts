-------------------------------------------------------------------------------
-------- PRE UPGRADE Kentico 11 to Kentico 12                      ------------
-------- Settings Foreign Key Fix                                  ------------
-- Instances of Kentico Xperience that started before Kentico 10 may have    --
-- foreign key dependencies that will cause sql errors during upgrade.  This --
-- script should be ran just prior to running the upgrade script to foreign  --
-- key dependencies.                                                         --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

-- delete the children first.
DECLARE @categoryParentID int;
SET @categoryParentID = (SELECT TOP 1 [CategoryID] FROM [CMS_SettingsCategory] WHERE [CategoryName] = 'CMS.UrlShortening')
IF @categoryParentID IS NOT NULL BEGIN

DECLARE @categoryResourceID int;
SET @categoryResourceID = (SELECT TOP 1 [ResourceID] FROM [CMS_Resource] WHERE [ResourceGUID] = 'aafd78f2-91f7-47cc-bf0b-d1a048d9540a')
IF @categoryResourceID IS NOT NULL BEGIN

-- Delete children settings keys
delete from CMS_SettingsKey where KeyCategoryID in(select P.CategoryID from CMS_SettingsCategory P where [CategoryName] = 'CMS.UrlShortening.Googl' and P.CategoryParentID = @categoryParentID)

-- Deletes the actual key
DELETE FROM [CMS_SettingsCategory] WHERE [CategoryName] = 'CMS.UrlShortening.Googl' AND [CategoryParentID] = @categoryParentID
	
END

END


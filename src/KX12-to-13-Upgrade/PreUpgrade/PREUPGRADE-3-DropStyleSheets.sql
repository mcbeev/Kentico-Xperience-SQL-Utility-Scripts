-------------------------------------------------------------------------------
-------- PRE UPGRADE Kentico Xperience 12 to Kentico Xperience 13  ------------
-------- CSS Stylesheet Foreign Key Fix                            ------------
-- Instances of Kentico Xperience that started before KX 12 may have foreign --
-- key dependencies that will cause sql errors during upgrade.  This script  --
-- should be ran just prior to running the upgrade script to resolve UI      --
-- foreign key dependencies.                                                 --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

alter table CMS_CssStyleSheetSite
drop constraint FK_CMS_CssStylesheetSite_StylesheetID_CMS_CssStylesheet

delete from  CMS_CssStylesheetSite
delete from [CMS_CssStylesheet]

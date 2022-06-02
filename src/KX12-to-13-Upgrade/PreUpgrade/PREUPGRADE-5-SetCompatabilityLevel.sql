-------------------------------------------------------------------------------
-------- PRE UPGRADE Kentico Xperience 12 to Kentico Xperience 13  ------------
-------- Database Compatability Level Fix                          ------------
-- Instances of Kentico Xperience that started before KX 12 may have an older--
-- database compatabilty level, which will caues an error when the upgrade   --
-- tool attempts to use a function that only available at the 120 level.     --
--                                                                           --
--  INSTRUCTIONS: Replace MY_XPERIENCE_DATABASE with your database name      --
--                                                                           --

-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

ALTER DATABASE MY_XPERIENCE_DATABASE SET COMPATIBILITY_LEVEL = 120;
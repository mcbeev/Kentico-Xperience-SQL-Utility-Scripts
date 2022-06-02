-------------------------------------------------------------------------------
-------- PRE UPGRADE Kentico Xperience 12 to Kentico Xperience 13  ------------
-------- Database Compatability Level Fix                          ------------
-- Instances of Kentico Xperience that started before KX 12 may have an old  --
-- PM Module that will cause a foreign key error on the OM_Group updates     --
-- that occurr during the upgrade.  This drops the tables as the feature is  --
-- no longer supported.                                                      --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

drop table PM_ProjectTask
drop table PM_ProjectRolePermission
drop table PM_Project
drop table PM_ProjectStatus
drop table PM_ProjectTaskPriority
drop table PM_ProjectTaskStatus
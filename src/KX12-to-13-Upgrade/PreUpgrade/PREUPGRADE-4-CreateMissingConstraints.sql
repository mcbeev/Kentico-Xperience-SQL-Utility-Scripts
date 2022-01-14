-------------------------------------------------------------------------------
-------- PRE UPGRADE Kentico Xperience 12 to Kentico Xperience 13  ------------
-------- Missing Key Constraint Fix                                ------------
-- Instances of Kentico Xperience that started before KX 12 may have foreign --
-- key dependencies that will cause sql errors during upgrade.  This script  --
-- should be ran just prior to running the upgrade script to resolve UI      --
-- foreign key dependencies.                                                 --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

ALTER TABLE [dbo].[CMS_VersionHistory] ADD  CONSTRAINT [DEFAULT_CMS_VersionHistory_DocumentNamePath]  DEFAULT (N'') FOR [DocumentNamePath]
GO

ALTER TABLE [dbo].[CMS_Document] ADD  CONSTRAINT [DEFAULT_CMS_Document_DocumentInheritsStylesheet]  DEFAULT ((1)) FOR [DocumentInheritsStylesheet]
GO

ALTER TABLE [dbo].[Analytics_Statistics] ADD  CONSTRAINT [DEFAULT_Analytics_Statistics_StatisticsObjectCulture]  DEFAULT (N'') FOR [StatisticsObjectCulture]
GO

ALTER TABLE [dbo].[Analytics_Statistics] ADD  CONSTRAINT [DEFAULT_Analytics_Statistics_StatisticsObjectName]  DEFAULT (N'') FOR [StatisticsObjectName]
GO


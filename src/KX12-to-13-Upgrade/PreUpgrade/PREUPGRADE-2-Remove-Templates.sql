-------------------------------------------------------------------------------
-------- PRE UPGRADE Kentico Xperience 12 to Kentico Xperience 13  ------------
-------- Page Template Foreign Key Fix                             ------------
-- Instances of Kentico Xperience that started before KX 12 may have foreign --
-- key dependencies that will cause sql errors during upgrade.  This script  --
-- should be ran just prior to running the upgrade script to resolve UI      --
-- foreign key dependencies.                                                 --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

update CMS_Tree set NodeTemplateID = null
update CMS_Document set DocumentPageTemplateID = null
update CMS_Class set ClassDefaultPageTemplateID = null
DECLARE @oldTemplates TABLE (PageTemplateID int)
INSERT INTO @oldTemplates SELECT PageTemplateID FROM [CMS_PageTemplate] WHERE [PageTemplateType] IN ('portal', 'aspx', 'aspxportal')

DELETE FROM [CMS_MetaFile]
	WHERE [MetaFileObjectType] = 'cms.pagetemplate'
	AND MetaFileObjectID IN (SELECT PageTemplateID FROM @oldTemplates)
	
	delete from CMS_TemplateDeviceLayout where PageTemplateID in (
	select PT.PageTemplateID FROM [CMS_PageTemplate] PT
	WHERE PT.[PageTemplateID] IN (SELECT PageTemplateID FROM @oldTemplates)
	)

	delete from CMS_PageTemplateSite where PageTemplateID in (
	select PT.PageTemplateID FROM [CMS_PageTemplate] PT
	WHERE PT.[PageTemplateID] IN (SELECT PageTemplateID FROM @oldTemplates)
	)
DELETE FROM [CMS_PageTemplate]
	WHERE [PageTemplateID] IN (SELECT PageTemplateID FROM @oldTemplates)

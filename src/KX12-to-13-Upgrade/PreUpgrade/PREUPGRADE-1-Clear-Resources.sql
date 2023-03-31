-------------------------------------------------------------------------------
-------- PRE UPGRADE Kentico Xperience 12 to Kentico Xperience 13  ------------
-------- Resource Foreign Key Fix                                  ------------
-- Instances of Kentico Xperience that started before KX 12 may have foreign --
-- key dependencies that will cause sql errors during upgrade.  This script  --
-- should be ran just prior to running the upgrade script to resolve UI      --
-- foreign key dependencies.                                                 --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

DECLARE @Resources TABLE
(
  Identifier uniqueidentifier
);

INSERT INTO @Resources (Identifier)
VALUES
('913a8e05-207e-4116-83ed-1c35a499d654'), -- DancingGoat.Samples (PLATFORM-14731)
('65f419f4-00f1-4905-a344-fc5b94983097'), -- Community groups
('16ff5f79-b1c3-4142-bf28-e9fec523a10e'), -- Blogs (PLATFORM-16552)
('09642799-d831-4b69-a95d-28a9bdf496d9'), -- Bad words (PLATFORM-16577)
('69d64093-d17a-47e2-a08b-71800ac187b2'), -- Abuse reports (PLATFORM-16564)
('67c2d259-8f33-4c1f-b725-5eebcb332fcc'), -- Events booking (PLATFORM-16584)
('e2774a5e-1005-4911-877d-ad4af29a9976'), -- On-site editing (PLATFORM-15199)
('0011c831-2e12-45bf-87ed-6a17607659f8'), -- Message boards (PLATFORM-16582)
('0b5a5dd7-ce18-487a-96a3-a71434119b15'), -- Banned IPs (PLATFORM-14997)
('16e96e6c-f16f-49dc-a640-2357418668b8'), -- Forums (PLATFORM-16791)
('e673e837-394a-45f9-9591-9e75fe757763'), -- MVT (PLATFORM-16805)
('60976a10-849f-49fd-ae87-04688c7c1f80'), -- content personalization (PLATFORM-16807)
('944e7882-1698-4e87-9036-5d8cd4f98592'), -- Chat (PLATFORM-16661)
('c5f1114b-f87b-46bc-b169-7f8afaddc394'), -- Notifications (PLATFORM-16715)
('6a211ca9-a088-480d-b205-86af12b83935'), -- Device profiles (PLATFORM-16820)
('f1cc54a9-d5bb-4a69-bd8c-8918eb410656'), -- Community (PLATFORM-16710)
('69a6884d-789d-4732-bf7c-96da001050d8'), -- Banners (PLATFORM-16654)
('1235e27c-5b04-4024-9032-d10ea62cafbe')  -- Strands recommender (PLATFORM-16705)
;
DECLARE @elementCursor CURSOR;
          SET @elementCursor = CURSOR FOR SELECT [Identifier] FROM @Resources

          DECLARE @elementIdentifier uniqueidentifier;

OPEN @elementCursor

          FETCH NEXT FROM @elementCursor INTO @elementIdentifier;
          WHILE @@FETCH_STATUS = 0
          BEGIN
			
DELETE FROM [CMS_ResourceSite] WHERE [ResourceID] IN (Select R.ResourceID from CMS_Resource R where ResourceGUID =@elementIdentifier)
delete from CMS_Widget where WidgetWebPartID in (Select WebPartID from CMS_Webpart where WebPartResourceID = (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier))
delete from CMS_Webpart where WebPartResourceID = (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier)
delete from CMS_FormUserControl where UserControlResourceID in (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier)
delete from CMS_ScheduledTask where TaskResourceID in (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier)
delete from CMS_AlternativeForm where FormClassID in (select ClassID from CMS_Class where ClassResourceID in (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier))
delete from CMS_Query where ClassID in (select ClassID from CMS_Class where ClassResourceID in (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier))
delete from CMS_Class where ClassResourceID in (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier)
delete from CMS_RolePermission where PermissionID in (select P.PermissionID from  CMS_Permission P where ResourceID in (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier))

delete from CMS_Permission where ResourceID in (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier)
delete from CMS_SettingsKey where KeyCategoryID in  (select C3.CategoryID from CMS_SettingsCategory C3 where C3.CategoryParentID in (select C2.CategoryID from CMS_SettingsCategory C2 where C2.CategoryParentID in  (select C.CategoryID from CMS_SettingsCategory C where C.CategoryResourceID in  (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier))))
delete from CMS_SettingsKey where KeyCategoryID in  (select CategoryID from CMS_SettingsCategory where CategoryParentID in  (select C.CategoryID from CMS_SettingsCategory C where C.CategoryResourceID in  (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier)))
delete from CMS_SettingsKey where KeyCategoryID in  (select CategoryID from CMS_SettingsCategory where CategoryResourceID in  (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier))
delete from CMS_SettingsCategory where CategoryParentID in (select C2.CategoryID from CMS_SettingsCategory C2 where C2.CategoryParentID in   (select C.CategoryID from CMS_SettingsCategory C where C.CategoryResourceID in  (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier)))
delete from CMS_SettingsCategory where CategoryParentID in  (select C.CategoryID from CMS_SettingsCategory C where C.CategoryResourceID in  (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier))
delete from CMS_SettingsCategory where CategoryResourceID in  (Select R.REsourceID from CMS_Resource R where ResourceGUID =@elementIdentifier)

DELETE FROM [CMS_Resource] WHERE [ResourceGUID]  =@elementIdentifier
    

          FETCH NEXT FROM @elementCursor INTO @elementIdentifier;
          END


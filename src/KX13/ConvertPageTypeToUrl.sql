--------------------------------------------------------------------------------------------------------------------------
-----------  Page Type Converter for KX13 (by Trevor Fayas - github.com/kenticodevtrev  -------------
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
-- KX13 does not allow you to enable the URL feature on a page type through the UI.  If your page type is not a container
-- (if it is, use the ConvertContainerPageTypeToCoupledWIthurl script), and you simply need to enable Url / page builder
-- functionality, this script will do this and insert the appropriate UrlPaths into the CMS_PageUrlPath table.
--
-- This script assumes that the page types ABOVE these classes have Url Enabled, if not then you'll need to adjust the 
-- Page Url Path script to somehow account for it. 
--
-- Also this does not generate any staging tasks, so this will need to be run on each environment, followed by a System ->
-- Clear Cache and Restart Application.
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
---------------------------- ALWAYS BACK UP BEFORE RUNNING: Don't be that guy! -------------------------------------------
---------------------- Also in Kentico do a System -> Clear Cache / Restart Application after-----------------------------
--------------------------------------------------------------------------------------------------------------------------

Declare @ClassName nvarchar(100) = 'my.customclass'
declare @EnablePageBuilder bit = 0
declare @EnableMetaData bit = 1
declare @MakeMenuItemType bit = 0
declare @PrefixCulture bit = 0

-- Set Features
update CMS_Class set ClassHasURL = 1, ClassIsMenuItemType = @MakeMenuItemType, ClassURLPattern = '{% NodeAliasPath %}', ClassUsesPageBuilder = @EnablePageBuilder, ClassHasMetadata = @EnableMetaData where ClassName = @ClassName

-- Insert PageUrlPaths
INSERT INTO [dbo].[CMS_PageUrlPath]
           ([PageUrlPathGUID]
           ,[PageUrlPathCulture]
           ,[PageUrlPathNodeID]
           ,[PageUrlPathUrlPath]
           ,[PageUrlPathUrlPathHash]
           ,[PageUrlPathSiteID]
           ,[PageUrlPathLastModified])
		   select 
			NEWID() as [PageUrlPathGUID],
			DocumentCulture as [PageUrlPathCulture],
			NodeID as [PageUrlPathNodeID],
			case when @PrefixCulture = 1 then '/'+DocumentCulture+NodeAliasPath else NodeAliasPath end as [PageUrlPathUrlPath],
			CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', LOWER(case when @PrefixCulture = 1 then '/'+DocumentCulture+NodeAliasPath else NodeAliasPath end)), 2) as [PageUrlPathUrlPathHash],
			NodeSiteID as [PageUrlPathSiteID],
			GETDATE() AS [PageUrlPathLastModified]

			from View_CMS_Tree_Joined where ClassName = @ClassName
			order by NodeSiteID, NodeAliasPath
     
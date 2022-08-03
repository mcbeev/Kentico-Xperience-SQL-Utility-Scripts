--------------------------------------------------------------------------------------------------------------------------
-----------  Page Type Prep for KX12 to KX13 (Routing) (by Trevor Fayas - github.com/kenticodevtrev  ---------------------
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
-- When going from Kentico Xperience 12 to Kentico Xperience 13, Kentico automatically converts Page Types and 
-- enables certain features.  In Kentico Xperience 12, URL routing was not available except through the Dynamic
-- Routing module.  In Kentico Xperience 13, Url Routing is available.
--
-- During upgrade, Kentico looks through the Page Types and sees if the ClassUrlPattern is not null/empty in order
-- to determine which classes should have the URL Feature enabled.  With the Dynamic Routing module for KX12, if
-- the ClassURLPattern was empty, it ASSUMED the pattern was {% NodeAliasPath %}, and used this in generating urls.
-- 
-- Kentico Xperience 13 also handles URLs slightly differently, it does not include any Non-Url feature enabled
-- Page types in the URL generations.  So if you have a page with NodeAliasPath /Articles/2020/May/Hello, and the
-- 2020 and May elements are folders (or any page type without a ClassURLPattern), KX 12 will make the url 
-- /Articles/Hello instead of it's original URL of /Articles/2020/May/Hello
-- 
-- To Fix this, before your upgrade, you need to add the {% NodeAliasPath %} ClassUrlPattern to any class you want      
-- to have URLs, or any class that you want to be included in the url generation.  Below are some scripts to help this. 
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
---------------------------- ALWAYS BACK UP BEFORE RUNNING: Don't be that guy! -------------------------------------------
---------------------- Also in Kentico do a System -> Clear Cache / Restart Application after-----------------------------
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
-- This query shows all no-ClassUrlPattern Pages with children that do have a URL.  
-- During upgrade, these URLs will be 'broken' and no match the original urls.
-- INSTRUCTIONS: Run this, and take all ClassNames (with NeedsContainerConversion = 0) to the next query.  
--                             take all ClassNames (with NeedsContainerConversion = 1) and run the ConvertToCoupled-KX12.sql script with them
--------------------------------------------------------------------------------------------------------------------------
 select Case when ParentClass.ClassIsCoupledClass = 0 then 1 else 0 end as NeedsContainerConversion, * from View_CMS_Tree_Joined Parent 
 left join CMS_Class ParentClass on ParentClass.ClassID = Parent.NodeClassID
 where ClassIsDocumentType = 1 and nullif(ClassURLPattern, '') is null and ParentClass.Classname <> 'CMS.Root'
 and exists (
	select * from View_CMS_Tree_Joined Sub
	left join CMS_Class SubClass on SubClass.ClassID = Sub.NodeClassID
	where (SubClass.ClassIsDocumentType = 1 and nullif(SubClass.ClassURLPattern, '') is not null and SubClass.Classname <> 'CMS.Root') and Sub.NodeAliasPath like Parent.NodeAliasPath+'/%' and Sub.NodeSiteID = Parent.NodeSiteID
 ) order by Parent.ClassName, Parent.NodeSiteID, Parent.NodeAliasPath


 --------------------------------------------------------------------------------------------------------------------------
-- This query converts Portal Engine Page Types to Content Only Types
--------------------------------------------------------------------------------------------------------------------------
update CMS_Class set ClassURLPattern = '{% NodeAliasPath %}', ClassIsContentOnly = 1, ClassUrlPattern = '{% NodeAliasPath %}' where ClassIsDocumentType = 1 and ClassIsCoupledClass = 1 and COALESCE(ClassIsContentOnly, 0) = 0
 and ClassName in ('my.class')
 
--------------------------------------------------------------------------------------------------------------------------
-- This query simply adds the {% NodeAliasPath %} to the ClassURLPattern, take the classes from the previous query and plug them in here, assuming NeedsContainerConversion = 0
--------------------------------------------------------------------------------------------------------------------------
update CMS_Class set ClassURLPattern = '{% NodeAliasPath %}' where ClassIsDocumentType = 1 and ClassIsCoupledClass = 1 and Nullif(ClassURLPattern, '') is null
 and ClassName in ('my.class')


--------------------------------------------------------------------------------------------------------------------------
-- This query shows all remaining no-ClassUrlPattern Classes and if they have pages.
-- If these are not also updated (with the previous update query), then they will have URL feature disabled upon upgrade, and cannot easily be re-enabled.
-- INSTRUCTIONS: Run this, and ask yourself "Will there ever be any child pages in the future that will need this page type as part of the URL Structure?" 
--		If yes, then add the ClassURLPattern with the query above.
--		If no, then leave it, and it will not have the URL Feature enabled.
--------------------------------------------------------------------------------------------------------------------------
select case when exists (select 0 from View_CMS_Tree_Joined V where V.NodeClassID = ClassID) then 1 else 0 end as HasPages, * from CMS_CLass where ClassIsDocumentType = 1 and nullif(ClassURLPattern, '') is null and Classname <> 'CMS.Root'

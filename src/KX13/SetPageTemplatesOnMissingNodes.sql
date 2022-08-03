-------------------------------------------------------
----  Set Page Templates on Pages ---------------------
-------------------------------------------------------
---- If a page was not created when page templates ----
---- were available, you can use this to force set ----
---- the page template in the DB.  You will need to----
---- manually push pages if you have staging       ----
---- enabled, as well as publish any pages in edit ----
---- mode.                                         ----
-------------------------------------------------------
---- ALWAYS BACK UP BEFORE RUNNING                 ----
-------------------------------------------------------

declare @PageType nvarchar(100) = 'custom.mypage'
declare @TemplateIdentifier nvarchar(100) = 'custom.mypage_default'
declare @TemplatePropertiesJsonObj nvarchar(max) = 'null' 
declare @TemplatePropertiesJsonObjXmlEncoded nvarchar(max) = 'null'

-- Updates version history for the checked out version.  This doesn't impact the published version however.
update CMS_VersionHistory set NodeXML = REPLACE(NodeXML, '</DocumentCanBePublished>', '</DocumentCanBePublished><DocumentPageTemplateConfiguration>{"identifier":"'+@TemplateIdentifier+'","properties":'+@TemplatePropertiesJsonObjXmlEncoded+'}</DocumentPageTemplateConfiguration>') 
where VersionHistoryID in (
Select DocumentCheckedOutVersionHistoryID from View_CMS_Tree_Joined where ClassName = @PageType and DocumentPageTemplateConfiguration is null
) and CHARINDEX('DocumentPageTemplateConfiguration', NODEXML) <= 0

-- Sets the main table value as well
update D set D.DocumentPageTemplateConfiguration = '{"identifier":"'+@TemplateIdentifier+'","properties":'+@TemplatePropertiesJsonObj+'}' from CMS_Document D
left join CMS_Tree T on T.NOdeID = D.DocumentNOdeID
Left join CMS_Class C on C.CLassID = T.NodeCLassID where ClassName = @PageType and DocumentPageTemplateConfiguration is null
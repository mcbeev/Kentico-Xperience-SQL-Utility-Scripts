/* KenticoClearVersionHistoryAndAttachmentHistory.v11.sql	*/
/* Goal: Clean up data from Pages Tree			*/
/* Description: Truncates version history except the most recent. or checked out */
/* This is safer than totally clearing as if you push a page that has workflow */
/* but the version history is gone, then the staging module will not push */
/* Child objects, thus you could destroy any child relationships.  This prevents that. */
/* Be very careful with this one, there is no coming back	*/
/* Intended Kentico Verison: 11.x               */
/* Author: Trevor Fayas (tfayas@gmail.com)    */
/* Revision: 1.0                                */
/* Take a backup first! Don't be THAT guy!      */

-- Delets Version Attachment Binding which also deletes the attachment history
delete from CMS_VersionAttachment where VersionHistoryID in (
	select VH.VersionHistoryID from CMS_VersionHistory VH
	left join CMS_Document D on D.DocumentID = VH.DocumentID
	where 
	-- Don't select the current or published version histories
	D.DocumentCheckedOutVersionHistoryID <> VH.VersionHistoryID and
	D.DocumentPublishedVersionHistoryID  <> VH.VersionHistoryID
)

-- Delete the Workflow History
delete from CMS_WorkflowHistory where VersionHistoryID in (
	select VH.VersionHistoryID from CMS_VersionHistory VH
	left join CMS_Document D on D.DocumentID = VH.DocumentID
	where 
	-- Don't select the current or published version histories
	D.DocumentCheckedOutVersionHistoryID <> VH.VersionHistoryID and
	D.DocumentPublishedVersionHistoryID  <> VH.VersionHistoryID
)

-- Delete the version history
delete from CMS_VersionHistory where VersionHistoryID in (
	select VH.VersionHistoryID from CMS_VersionHistory VH
	left join CMS_Document D on D.DocumentID = VH.DocumentID
	where 
	-- Don't select the current or published version histories
	D.DocumentCheckedOutVersionHistoryID <> VH.VersionHistoryID and
	D.DocumentPublishedVersionHistoryID  <> VH.VersionHistoryID
)

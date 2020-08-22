/* KenticoClearVersionHistoryAndAttachmentHistory.v11.sql	*/
/* Goal: Clean up data from Pages Tree			*/
/* Description: Truncates all version history   */
/*  that can bloat a database. Be very careful	*/
/*  with this one, there is no coming back		*/
/* Intended Kentico Verison: 11.x               */
/* Author: Brian McKeiver (mcbeev@gmail.com)    */
/* Revision: 1.0                                */
/* Take a backup first! Don't be THAT guy!      */

TRUNCATE TABLE CMS_WorkflowHistory
GO

UPDATE CMS_Document SET 
	DocumentCheckedOutVersionHistoryID = NULL
	,DocumentPublishedVersionHistoryID = NULL
GO

TRUNCATE TABLE CMS_VersionAttachment
GO

DELETE FROM CMS_VersionHistory
GO

DELETE FROM CMS_AttachmentHistory
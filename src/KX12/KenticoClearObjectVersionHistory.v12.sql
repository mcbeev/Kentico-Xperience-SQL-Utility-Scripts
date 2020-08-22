/* KenticoClearObjectVersionHistory.v12.sql		*/
/* Goal: Clean up data from objects				*/
/* Description: Truncates all version history   */
/*  that can bloat a database. Be very careful	*/
/*  with this one, there is no coming back		*/
/* Intended Kentico Verison: 12.x               */
/* Author: Brian McKeiver (mcbeev@gmail.com)    */
/* Revision: 1.0                                */
/* Take a backup first! Don't be THAT guy!      */

UPDATE CMS_ObjectSettings
	SET ObjectCheckedOutVersionHistoryID = NULL
WHERE ObjectCheckedOutVersionHistoryID IS NOT NULL

GO

DELETE FROM CMS_ObjectVersionHistory

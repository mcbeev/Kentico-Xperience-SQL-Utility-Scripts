/* KenticoDeleteStagingDAta.v12.sql				*/
/* Goal: Clean up data from Content Staging		*/
/* Description: Truncates all Staging tasks		*/
/*  that can bloat a database. Be very careful	*/
/*  with this one, there is no coming back		*/
/* Intended Kentico Verison: 12.x               */
/* Author: Brian McKeiver (mcbeev@gmail.com)    */
/* Revision: 1.0                                */
/* Take a backup first! Don't be THAT guy!      */

TRUNCATE TABLE Staging_Synchronization

GO

DELETE FROM Staging_Task

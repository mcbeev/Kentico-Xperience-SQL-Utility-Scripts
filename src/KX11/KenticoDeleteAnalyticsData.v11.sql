/* KenticoDeleteAnalyticsData.v11.sql           */
/* Goal: Clear out Analytics_*                  */
/* Description: Truncates all rows in all       */
/*	Analytics_*                                 */
/* Intended Kentico Verison: 11.x               */
/* Author: Brian McKeiver (mcbeev@gmail.com)    */
/* Revision: 1.0                                */
/* Take a backup first! Don't be THAT guy!      */

TRUNCATE TABLE Analytics_DayHits
GO

TRUNCATE TABLE Analytics_ExitPages
GO

TRUNCATE TABLE Analytics_HourHits
GO

TRUNCATE TABLE Analytics_MonthHits
GO

TRUNCATE TABLE Analytics_WeekHits
GO

TRUNCATE TABLE Analytics_MonthHits
GO

TRUNCATE TABLE Analytics_YearHits
GO

DELETE FROM Analytics_Statistics


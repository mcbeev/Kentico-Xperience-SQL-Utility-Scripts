  
/* KenticoDeleteAnalyticsData-ByDays.v12.sql	*/
/* Goal: Clean up analytics data beyond a given # of days		*/
/* Description: Deletes individual Analytics Hits that are beyond the given */
/* number of days.  This way you can delete data that is older than XXX days. */
/* This can take a long time to run and isn't recommended you run while the site is */
/* Being hit.  On one site with over 50 million records beyond the date it took 40 minutes to run. */
/* Be very careful with this one, there is no coming back	*/
/* Intended Kentico Verison: 11.x               */
/* Author: Trevor Fayas (tfayas@gmail.com)    */
/* Revision: 1.0                                */
/* Take a backup first! Don't be THAT guy!      */


declare @DaysToKeep int = 548; /* MODIFY ME */
declare @CutOffDate datetime = null;

-- Creates the cut off point
set @CutOffDate = DATEADD(day, -1*@DaysToKeep, GETDATE())


-- Delete various Analytics data that have an end time that is earlier than the cut off date.  
-- DateDiff(day, '2020-01-15', '2020-01-01') would result in a negative number (Keep), 
-- where as DateDiff(day, '2019-12-30', '2020-01-01') would result in a negative number and should be deleted
delete from [Analytics_YearHits]
  where DATEDIFF(day, HitsEndTime, @CutOffDate) > 0

   delete from [Analytics_MonthHits]
  where DATEDIFF(day, HitsEndTime, @CutOffDate) > 0

  delete from [Analytics_WeekHits]
  where DATEDIFF(day, HitsEndTime, @CutOffDate) > 0

   delete from [Analytics_DayHits]
  where DATEDIFF(day, HitsEndTime, @CutOffDate) > 0

   delete from [Analytics_HourHits]
  where DATEDIFF(day, HitsEndTime, @CutOffDate) > 0

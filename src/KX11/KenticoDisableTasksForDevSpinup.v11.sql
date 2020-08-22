/* KenticoDisableTasksForDevSpinup.v11.sql    */
/* Goal: Create a safe dev instance from prod */
/* Description: Disable all scheduled tasks,  */
/*	remove SMTP server settings to ensure no  */
/*	emails go out, disable emails, and queue. */
/*  Run this after your restore the DB and    */
/*  before you fire up the application code   */
/* Intended Kentico Verison: 11.x             */
/* Author: Brian McKeiver (mcbeev@gmail.com)  */
/* Revision: 1.0                              */
/* Take a backup first! Don't be THAT guy!	  */

--Disable all Scheduled Tasks
UPDATE CMS_ScheduledTask SET TaskEnabled = 0

--Remove all SMTP Servers from Additional SMTP servers
TRUNCATE TABLE CMS_SMTPServerSite

--Update Settings app to blank out main SMTP Settings
UPDATE CMS_SettingsKey SET KeyValue = '' WHERE KeyName = 'CMSSMTPServer'
UPDATE CMS_SettingsKey SET KeyValue = '' WHERE KeyName = 'CMSSMTPServerPassword'
UPDATE CMS_SettingsKey SET KeyValue = '' WHERE KeyName = 'CMSSMTPServerUser'

--Update Settings app to disable email and email queue
UPDATE CMS_SettingsKey SET KeyValue = 'False' WHERE KeyName = 'CMSEmailsEnabled'
UPDATE CMS_SettingsKey SET KeyValue = 'False' WHERE KeyName = 'CMSEmailQueueEnabled'

--Disable all Content Staing Servers
UPDATE Staging_Server SET ServerEnabled = 0

--Disable all Web Farm Servers
UPDATE CMS_WebFarmServer SET ServerEnabled = 0

--Disable all Marketing Automation Processes
UPDATE CMS_Workflow SET WorkflowEnabled = 0 WHERE ([WorkflowType] = 3)

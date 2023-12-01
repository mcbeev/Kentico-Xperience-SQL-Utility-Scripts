-- Delete tables
-- MUST RUN MULTIPLE TIMES (like 3), as foreign keys prevent some tables from deleting, which will succeed the next time.
DECLARE @ObjectName nvarchar(500)

DECLARE CurName CURSOR FAST_FORWARD READ_ONLY
 FOR

 SELECT * from STRING_SPLIT(
-- Defined in CMS/App_Data/DBSeparation/tables.txt - IN REVERSE ORDER!
'CMS_ConsentAgreement
CMS_ConsentArchive
CMS_Consent
Newsletter_IssueContactGroup
Newsletter_ClickedLink
Newsletter_Link
Newsletter_OpenedEmail
OM_VisitorToContact
OM_Membership
OM_ScoreContactRule
OM_Rule
OM_Score
Personas_PersonaContactHistory
Personas_Persona
OM_ContactGroupMember
OM_ContactGroup
OM_ContactChangeRecalculationQueue
OM_ActivityRecalculationQueue
OM_Activity
OM_ActivityType
OM_AccountContact
OM_ContactRole
OM_Account
OM_AccountStatus
OM_Contact
OM_ContactStatus'
,CHAR(13)) 

OPEN CurName

 FETCH NEXT FROM CurName INTO @ObjectName

 WHILE @@FETCH_STATUS = 0
    BEGIN
		exec('DROP TABLE '+@ObjectName);
       
        FETCH NEXT FROM CurName INTO @ObjectName
    END

 CLOSE CurName
 DEALLOCATE CurName

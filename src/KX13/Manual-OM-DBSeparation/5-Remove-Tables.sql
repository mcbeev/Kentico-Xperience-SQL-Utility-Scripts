-- Delete tables
-- MUST RUN MULTIPLE TIMES (like 3), as foreign keys prevent some tables from deleting, which will succeed the next time.
DECLARE @ObjectName nvarchar(500)

DECLARE CurName CURSOR FAST_FORWARD READ_ONLY
 FOR

 SELECT name
from sys.objects s
WHERE type = 'U' and name not in 
(
-- Defined in CMS/App_Data/DBSeparation/tables.txt
'OM_ContactStatus',
'OM_Contact',
'OM_AccountStatus',
'OM_Account',
'OM_ContactRole',
'OM_AccountContact',
'OM_ActivityType',
'OM_Activity',
'OM_ActivityRecalculationQueue',
'OM_ContactChangeRecalculationQueue',
'OM_ContactGroup',
'OM_ContactGroupMember',
'Personas_Persona',
'Personas_PersonaContactHistory',
'OM_Score',
'OM_Rule',
'OM_ScoreContactRule',
'OM_Membership',
'OM_VisitorToContact',
'Newsletter_OpenedEmail',
'Newsletter_Link',
'Newsletter_ClickedLink',
'Newsletter_IssueContactGroup',
'CMS_Consent',
'CMS_ConsentArchive',
'CMS_ConsentAgreement'
) order by 
(
 SELECT 
   count(*)
FROM 
   sys.foreign_keys AS f
INNER JOIN 
   sys.foreign_key_columns AS fc 
      ON f.OBJECT_ID = fc.constraint_object_id
INNER JOIN 
   sys.tables t 
      ON t.OBJECT_ID = fc.referenced_object_id
WHERE 
   OBJECT_NAME (f.referenced_object_id) = s.name
   )

OPEN CurName

 FETCH NEXT FROM CurName INTO @ObjectName

 WHILE @@FETCH_STATUS = 0
    BEGIN
		exec('DROP TABLE '+@ObjectName);
       
        FETCH NEXT FROM CurName INTO @ObjectName
    END

 CLOSE CurName
 DEALLOCATE CurName

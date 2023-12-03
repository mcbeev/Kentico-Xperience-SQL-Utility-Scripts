-- Delete Functions from Main Table
DECLARE @ObjectName nvarchar(500)

DECLARE CurName CURSOR FAST_FORWARD READ_ONLY
 FOR

 SELECT * from STRING_SPLIT(
-- Defined in CMS/App_Data/DBSeparation/procedures_functions_views.txt - IN REVERSE ORDER!
'Proc_Personas_ReevaluateAllContacts
Proc_OM_ScoreContactRule_AddContacts
Proc_OM_Score_UpdateContactScore
Proc_OM_ContactGroupMember_UpdateMembersForAccount
Proc_OM_ContactGroupMember_RemoveContactsFromAccount
Proc_OM_ContactGroupMember_RemoveAccountContacts
Proc_OM_ContactGroupMember_AddContactToContactGroupsDynamic
Proc_OM_ContactGroupMember_AddContactsToContactGroupDynamic
Proc_OM_ContactGroupMember_AddContactIntoAccount
Proc_OM_Contact_RemoveCustomer
Proc_OM_Contact_MassDelete
Proc_OM_ContactChangeRecalculationQueue_FetchContactChanges
Proc_OM_ActivityRecalculationQueue_FetchActivityIDs
Proc_OM_Activity_BulkInsertActivities
Proc_OM_AccountContact_ContactsIntoAccount
Proc_OM_AccountContact_AccountsIntoContact
Proc_OM_Account_UpdatePrimaryContact
Proc_OM_Account_MassDelete'
,CHAR(13)) 

OPEN CurName

 FETCH NEXT FROM CurName INTO @ObjectName

 WHILE @@FETCH_STATUS = 0
    BEGIN
		exec('DROP PROCEDURE '+@ObjectName);
       
        FETCH NEXT FROM CurName INTO @ObjectName
    END

 CLOSE CurName
 DEALLOCATE CurName

-- Delete Functions from Main Table
DECLARE @ObjectName nvarchar(500)

DECLARE CurName CURSOR FAST_FORWARD READ_ONLY
 FOR

 SELECT * from STRING_SPLIT(
-- Defined in CMS/App_Data/DBSeparation/procedures_functions_views.txt - IN REVERSE ORDER!
'View_OM_ContactGroupMember_AccountJoined
View_OM_AccountContact_AccountJoined
View_OM_AccountContact_ContactJoined
View_OM_Account_Joined'
,CHAR(13)) 

OPEN CurName

 FETCH NEXT FROM CurName INTO @ObjectName

 WHILE @@FETCH_STATUS = 0
    BEGIN
		exec('DROP VIEW '+@ObjectName);
       
        FETCH NEXT FROM CurName INTO @ObjectName
    END

 CLOSE CurName
 DEALLOCATE CurName

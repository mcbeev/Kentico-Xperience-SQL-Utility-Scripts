DECLARE @ObjectName nvarchar(500)

DECLARE CurName CURSOR FAST_FORWARD READ_ONLY
 FOR

SELECT name
  FROM sys.sql_modules m 
INNER JOIN sys.objects o 
        ON m.object_id=o.object_id
WHERE type_desc like '%view%' and name not in 
(
-- Defined in CMS/App_Data/DBSeparation/procedures_functions_views.txt
'View_OM_Account_Joined',
'View_OM_AccountContact_ContactJoined',
'View_OM_AccountContact_AccountJoined',
'View_OM_ContactGroupMember_AccountJoined'
)

OPEN CurName

 FETCH NEXT FROM CurName INTO @ObjectName

 WHILE @@FETCH_STATUS = 0
    BEGIN
		exec('DROP VIEW '+@ObjectName);
       
        FETCH NEXT FROM CurName INTO @ObjectName
    END

 CLOSE CurName
 DEALLOCATE CurName

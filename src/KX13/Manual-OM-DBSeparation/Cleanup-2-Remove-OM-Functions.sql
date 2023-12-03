-- Delete Functions from Main Table
DECLARE @ObjectName nvarchar(500)

DECLARE CurName CURSOR FAST_FORWARD READ_ONLY
 FOR

 SELECT * from STRING_SPLIT(
-- Defined in CMS/App_Data/DBSeparation/procedures_functions_views.txt - IN REVERSE ORDER!
'Func_OM_Account_GetSubsidiaryOf
Func_OM_Account_GetSubsidiaries'
,CHAR(13)) 

OPEN CurName

 FETCH NEXT FROM CurName INTO @ObjectName

 WHILE @@FETCH_STATUS = 0
    BEGIN
		exec('DROP FUNCTION '+@ObjectName);
       
        FETCH NEXT FROM CurName INTO @ObjectName
    END

 CLOSE CurName
 DEALLOCATE CurName

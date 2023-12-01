DECLARE @ObjectName nvarchar(500)

DECLARE CurName CURSOR FAST_FORWARD READ_ONLY
 FOR

SELECT name
  FROM sys.sql_modules m 
INNER JOIN sys.objects o 
        ON m.object_id=o.object_id
WHERE type_desc like '%function%' and name not in 
(
-- Defined in CMS/App_Data/DBSeparation/procedures_functions_views.txt
'Func_OM_Account_GetSubsidiaries',
'Func_OM_Account_GetSubsidiaryOf'
)

OPEN CurName

 FETCH NEXT FROM CurName INTO @ObjectName

 WHILE @@FETCH_STATUS = 0
    BEGIN
		exec('DROP FUNCTION '+@ObjectName);
       
        FETCH NEXT FROM CurName INTO @ObjectName
    END

 CLOSE CurName
 DEALLOCATE CurName

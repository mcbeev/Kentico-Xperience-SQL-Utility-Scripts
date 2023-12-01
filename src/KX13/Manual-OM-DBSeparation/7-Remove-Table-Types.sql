-- Remove user defined table types
DECLARE @ObjectName nvarchar(500)

DECLARE CurName CURSOR FAST_FORWARD READ_ONLY
 FOR

select name from sys.types
where is_user_defined = 1 and name not in 
(
-- Defined in CMS/App_Data/DBSeparation/copy_types.txt
'Type_CMS_IntegerTable',
'Type_CMS_OrderedIntegerTable',
'Type_CMS_BigIntTable',
'Type_CMS_GuidTable',
'Type_CMS_StringTable',
'Type_OM_ActivityTable',
'Type_OM_ContactEmailTable',
'Type_OM_OrderedIntegerTable_DuplicatesAllowed'
)

OPEN CurName

 FETCH NEXT FROM CurName INTO @ObjectName

 WHILE @@FETCH_STATUS = 0
    BEGIN
		exec('DROP TYPE '+@ObjectName);
       
        FETCH NEXT FROM CurName INTO @ObjectName
    END

 CLOSE CurName
 DEALLOCATE CurName

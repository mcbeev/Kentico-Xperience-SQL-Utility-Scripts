-- Delete Foreign keys that the OM tables reference
DECLARE @FKTable nvarchar(500)
DECLARE @FKName nvarchar(500)

DECLARE CurName CURSOR FAST_FORWARD READ_ONLY
 FOR

 	select t.name as TableWithForeignKey, fk.name as FKname
from sys.foreign_key_columns as c
inner join sys.tables as t on c.parent_object_id = t.object_id
inner join sys.objects as fk on  c.constraint_object_id = fk.object_id
inner join sys.columns as col on c.parent_object_id = col.object_id and c.parent_column_id = col.column_id
inner join sys.tables as pkt on pkt.object_id =  c.referenced_object_id
inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc on tc.TABLE_NAME = pkt.name AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
inner join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu ON tc.CONSTRAINT_NAME = ccu.Constraint_name
where pkt.name in (
-- Defined in CMS/App_Data/DBSeparation/temporary_tables.txt (just the table name, not ID field)
'CMS_Country',
'CMS_State',
'CMS_User',
'CMS_Site',
'Newsletter_NewsletterIssue',
'Newsletter_Subscriber'
)

OPEN CurName

 FETCH NEXT FROM CurName INTO @FKTable, @FKName

 WHILE @@FETCH_STATUS = 0
    BEGIN
	exec('alter table ['+@FKTable+'] drop ['+@FKName+']')
       
        FETCH NEXT FROM CurName INTO @FKTable, @FKName
    END

 CLOSE CurName
 DEALLOCATE CurName

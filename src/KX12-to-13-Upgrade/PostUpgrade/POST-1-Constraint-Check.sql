-------------------------------------------------------------------------------
-------- POST UPGRADE Kentico Xperience 12 to Kentico Xperience 13  -----------
-------- Constraints/Index Check                                   ------------
-- Instances of Kentico Xperience that started before KX 12 may have an old  --
-- Tables, Views, Index/Constraints/Functions, etc.  These should be updated,--
-- obsolete items removed, and items updated if they differ from a fresh     --
-- Kentico Xperience 13 installation.                                        --
--                                                                           --
-- INSTRUCTIONS: 
--  1. Have a fresh Kentico Xperience 13 database for comparison             --
--  2. Find and replace FRESH_XPERIENCEDB with the fresh Kentico 13 database --
--  3. Find and replace UPGRADED_XPERIENCEDB with the database you upgrade   --
--  4. Run the query                                                         --
--  5. Any Constraints/Indexes identified show a different value, for these..--
--    A. Take any constraint that is on the normal Kentico 13 database,      --
--       right click and 'Script ___ as' -> Drop and Create -> To Clipboard  --
--    B. Paste this into a new window, and run in the DB context of your     --
--       Upgraded Database. Usually you just paste and execute the code below--
--       the "Using [FRESH_XPERIENCEDB] GO"                                  --
--                                                                           --
--  6. If the index doesn't exist in the Fresh Kentico Xperience 13 database,--
--     you can should be able to remove it from your upgraded instance.      --
--  7. Re-run till everything that should be resolved is resolved.           --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------


-- Combined
select distinct * from (

select * from (

select * from (
select table_view,
    object_type, 
    constraint_type,
    constraint_name,
    details
from (
    select schema_name(t.schema_id) + '.' + t.[name] as table_view, 
        case when t.[type] = 'U' then 'Table'
            when t.[type] = 'V' then 'View'
            end as [object_type],
        case when c.[type] = 'PK' then 'Primary key'
            when c.[type] = 'UQ' then 'Unique constraint'
            when i.[type] = 1 then 'Unique clustered index'
            when i.type = 2 then 'Unique index'
            end as constraint_type, 
        isnull(c.[name], i.[name]) as constraint_name,
        substring(column_names, 1, len(column_names)-1) as [details]
    from FRESH_XPERIENCEDB.sys.objects t
        left outer join FRESH_XPERIENCEDB.sys.indexes i
            on t.object_id = i.object_id
        left outer join FRESH_XPERIENCEDB.sys.key_constraints c
            on i.object_id = c.parent_object_id 
            and i.index_id = c.unique_index_id
       cross apply (select col.[name] + ', '
                        from FRESH_XPERIENCEDB.sys.index_columns ic
                            inner join FRESH_XPERIENCEDB.sys.columns col
                                on ic.object_id = col.object_id
                                and ic.column_id = col.column_id
                        where ic.object_id = t.object_id
                            and ic.index_id = i.index_id
                                order by col.column_id
                                for xml path ('') ) D (column_names)
    where is_unique = 1
    and t.is_ms_shipped <> 1
    union all 
    select schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
        'Table',
        'Foreign key',
        fk.name as fk_constraint_name,
        schema_name(pk_tab.schema_id) + '.' + pk_tab.name
    from FRESH_XPERIENCEDB.sys.foreign_keys fk
        inner join FRESH_XPERIENCEDB.sys.tables fk_tab
            on fk_tab.object_id = fk.parent_object_id
        inner join FRESH_XPERIENCEDB.sys.tables pk_tab
            on pk_tab.object_id = fk.referenced_object_id
        inner join FRESH_XPERIENCEDB.sys.foreign_key_columns fk_cols
            on fk_cols.constraint_object_id = fk.object_id
    union all
    select schema_name(t.schema_id) + '.' + t.[name],
        'Table',
        'Check constraint',
        con.[name] as constraint_name,
        con.[definition]
    from FRESH_XPERIENCEDB.sys.check_constraints con
        left outer join FRESH_XPERIENCEDB.sys.objects t
            on con.parent_object_id = t.object_id
        left outer join FRESH_XPERIENCEDB.sys.all_columns col
            on con.parent_column_id = col.column_id
            and con.parent_object_id = col.object_id
    union all
    select schema_name(t.schema_id) + '.' + t.[name],
        'Table',
        'Default constraint',
        con.[name],
        col.[name] + ' = ' + con.[definition]
    from FRESH_XPERIENCEDB.sys.default_constraints con
        left outer join FRESH_XPERIENCEDB.sys.objects t
            on con.parent_object_id = t.object_id
        left outer join FRESH_XPERIENCEDB.sys.all_columns col
            on con.parent_column_id = col.column_id
            and con.parent_object_id = col.object_id) a

			) orig
			EXCEPT
			select * from (
			select table_view,
    object_type, 
    constraint_type,
    constraint_name,
    details
from (
    select schema_name(t.schema_id) + '.' + t.[name] as table_view, 
        case when t.[type] = 'U' then 'Table'
            when t.[type] = 'V' then 'View'
            end as [object_type],
        case when c.[type] = 'PK' then 'Primary key'
            when c.[type] = 'UQ' then 'Unique constraint'
            when i.[type] = 1 then 'Unique clustered index'
            when i.type = 2 then 'Unique index'
            end as constraint_type, 
        isnull(c.[name], i.[name]) as constraint_name,
        substring(column_names, 1, len(column_names)-1) as [details]
    from UPGRADED_XPERIENCEDB.sys.objects t
        left outer join UPGRADED_XPERIENCEDB.sys.indexes i
            on t.object_id = i.object_id
        left outer join UPGRADED_XPERIENCEDB.sys.key_constraints c
            on i.object_id = c.parent_object_id 
            and i.index_id = c.unique_index_id
       cross apply (select col.[name] + ', '
                        from UPGRADED_XPERIENCEDB.sys.index_columns ic
                            inner join UPGRADED_XPERIENCEDB.sys.columns col
                                on ic.object_id = col.object_id
                                and ic.column_id = col.column_id
                        where ic.object_id = t.object_id
                            and ic.index_id = i.index_id
                                order by col.column_id
                                for xml path ('') ) D (column_names)
    where is_unique = 1
    and t.is_ms_shipped <> 1
    union all 
    select schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
        'Table',
        'Foreign key',
        fk.name as fk_constraint_name,
        schema_name(pk_tab.schema_id) + '.' + pk_tab.name
    from UPGRADED_XPERIENCEDB.sys.foreign_keys fk
        inner join UPGRADED_XPERIENCEDB.sys.tables fk_tab
            on fk_tab.object_id = fk.parent_object_id
        inner join UPGRADED_XPERIENCEDB.sys.tables pk_tab
            on pk_tab.object_id = fk.referenced_object_id
        inner join UPGRADED_XPERIENCEDB.sys.foreign_key_columns fk_cols
            on fk_cols.constraint_object_id = fk.object_id
    union all
    select schema_name(t.schema_id) + '.' + t.[name],
        'Table',
        'Check constraint',
        con.[name] as constraint_name,
        con.[definition]
    from UPGRADED_XPERIENCEDB.sys.check_constraints con
        left outer join UPGRADED_XPERIENCEDB.sys.objects t
            on con.parent_object_id = t.object_id
        left outer join UPGRADED_XPERIENCEDB.sys.all_columns col
            on con.parent_column_id = col.column_id
            and con.parent_object_id = col.object_id
    union all
    select schema_name(t.schema_id) + '.' + t.[name],
        'Table',
        'Default constraint',
        con.[name],
        col.[name] + ' = ' + con.[definition]
    from UPGRADED_XPERIENCEDB.sys.default_constraints con
        left outer join UPGRADED_XPERIENCEDB.sys.objects t
            on con.parent_object_id = t.object_id
        left outer join UPGRADED_XPERIENCEDB.sys.all_columns col
            on con.parent_column_id = col.column_id
            and con.parent_object_id = col.object_id) a
) other
) OrigToUpgraded

UNION ALL

select * from (
select * from (
select table_view,
    object_type, 
    constraint_type,
    constraint_name,
    details
from (
    select schema_name(t.schema_id) + '.' + t.[name] as table_view, 
        case when t.[type] = 'U' then 'Table'
            when t.[type] = 'V' then 'View'
            end as [object_type],
        case when c.[type] = 'PK' then 'Primary key'
            when c.[type] = 'UQ' then 'Unique constraint'
            when i.[type] = 1 then 'Unique clustered index'
            when i.type = 2 then 'Unique index'
            end as constraint_type, 
        isnull(c.[name], i.[name]) as constraint_name,
        substring(column_names, 1, len(column_names)-1) as [details]
    from UPGRADED_XPERIENCEDB.sys.objects t
        left outer join UPGRADED_XPERIENCEDB.sys.indexes i
            on t.object_id = i.object_id
        left outer join UPGRADED_XPERIENCEDB.sys.key_constraints c
            on i.object_id = c.parent_object_id 
            and i.index_id = c.unique_index_id
       cross apply (select col.[name] + ', '
                        from UPGRADED_XPERIENCEDB.sys.index_columns ic
                            inner join UPGRADED_XPERIENCEDB.sys.columns col
                                on ic.object_id = col.object_id
                                and ic.column_id = col.column_id
                        where ic.object_id = t.object_id
                            and ic.index_id = i.index_id
                                order by col.column_id
                                for xml path ('') ) D (column_names)
    where is_unique = 1
    and t.is_ms_shipped <> 1
    union all 
    select schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
        'Table',
        'Foreign key',
        fk.name as fk_constraint_name,
        schema_name(pk_tab.schema_id) + '.' + pk_tab.name
    from UPGRADED_XPERIENCEDB.sys.foreign_keys fk
        inner join UPGRADED_XPERIENCEDB.sys.tables fk_tab
            on fk_tab.object_id = fk.parent_object_id
        inner join UPGRADED_XPERIENCEDB.sys.tables pk_tab
            on pk_tab.object_id = fk.referenced_object_id
        inner join UPGRADED_XPERIENCEDB.sys.foreign_key_columns fk_cols
            on fk_cols.constraint_object_id = fk.object_id
    union all
    select schema_name(t.schema_id) + '.' + t.[name],
        'Table',
        'Check constraint',
        con.[name] as constraint_name,
        con.[definition]
    from UPGRADED_XPERIENCEDB.sys.check_constraints con
        left outer join UPGRADED_XPERIENCEDB.sys.objects t
            on con.parent_object_id = t.object_id
        left outer join UPGRADED_XPERIENCEDB.sys.all_columns col
            on con.parent_column_id = col.column_id
            and con.parent_object_id = col.object_id
    union all
    select schema_name(t.schema_id) + '.' + t.[name],
        'Table',
        'Default constraint',
        con.[name],
        col.[name] + ' = ' + con.[definition]
    from UPGRADED_XPERIENCEDB.sys.default_constraints con
        left outer join UPGRADED_XPERIENCEDB.sys.objects t
            on con.parent_object_id = t.object_id
        left outer join UPGRADED_XPERIENCEDB.sys.all_columns col
            on con.parent_column_id = col.column_id
            and con.parent_object_id = col.object_id) a

			) orig
			EXCEPT
			select * from (
			select table_view,
    object_type, 
    constraint_type,
    constraint_name,
    details
from (
    select schema_name(t.schema_id) + '.' + t.[name] as table_view, 
        case when t.[type] = 'U' then 'Table'
            when t.[type] = 'V' then 'View'
            end as [object_type],
        case when c.[type] = 'PK' then 'Primary key'
            when c.[type] = 'UQ' then 'Unique constraint'
            when i.[type] = 1 then 'Unique clustered index'
            when i.type = 2 then 'Unique index'
            end as constraint_type, 
        isnull(c.[name], i.[name]) as constraint_name,
        substring(column_names, 1, len(column_names)-1) as [details]
    from UPGRADED_XPERIENCEDB.sys.objects t
        left outer join UPGRADED_XPERIENCEDB.sys.indexes i
            on t.object_id = i.object_id
        left outer join UPGRADED_XPERIENCEDB.sys.key_constraints c
            on i.object_id = c.parent_object_id 
            and i.index_id = c.unique_index_id
       cross apply (select col.[name] + ', '
                        from UPGRADED_XPERIENCEDB.sys.index_columns ic
                            inner join UPGRADED_XPERIENCEDB.sys.columns col
                                on ic.object_id = col.object_id
                                and ic.column_id = col.column_id
                        where ic.object_id = t.object_id
                            and ic.index_id = i.index_id
                                order by col.column_id
                                for xml path ('') ) D (column_names)
    where is_unique = 1
    and t.is_ms_shipped <> 1
    union all 
    select schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
        'Table',
        'Foreign key',
        fk.name as fk_constraint_name,
        schema_name(pk_tab.schema_id) + '.' + pk_tab.name
    from UPGRADED_XPERIENCEDB.sys.foreign_keys fk
        inner join UPGRADED_XPERIENCEDB.sys.tables fk_tab
            on fk_tab.object_id = fk.parent_object_id
        inner join UPGRADED_XPERIENCEDB.sys.tables pk_tab
            on pk_tab.object_id = fk.referenced_object_id
        inner join UPGRADED_XPERIENCEDB.sys.foreign_key_columns fk_cols
            on fk_cols.constraint_object_id = fk.object_id
    union all
    select schema_name(t.schema_id) + '.' + t.[name],
        'Table',
        'Check constraint',
        con.[name] as constraint_name,
        con.[definition]
    from UPGRADED_XPERIENCEDB.sys.check_constraints con
        left outer join UPGRADED_XPERIENCEDB.sys.objects t
            on con.parent_object_id = t.object_id
        left outer join UPGRADED_XPERIENCEDB.sys.all_columns col
            on con.parent_column_id = col.column_id
            and con.parent_object_id = col.object_id
    union all
    select schema_name(t.schema_id) + '.' + t.[name],
        'Table',
        'Default constraint',
        con.[name],
        col.[name] + ' = ' + con.[definition]
    from UPGRADED_XPERIENCEDB.sys.default_constraints con
        left outer join UPGRADED_XPERIENCEDB.sys.objects t
            on con.parent_object_id = t.object_id
        left outer join UPGRADED_XPERIENCEDB.sys.all_columns col
            on con.parent_column_id = col.column_id
            and con.parent_object_id = col.object_id) a
) other
) UpgradedToOriginal
) Combined

order by table_view, constraint_type, constraint_name
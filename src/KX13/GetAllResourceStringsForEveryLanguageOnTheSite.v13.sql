
DECLARE @id INT
DECLARE @name NVARCHAR(100)
DECLARE @getid CURSOR

create table #TempResourceStrings (
	ResourceID int,
	ResourceKey nvarchar(150),
	ResourceLangCode nvarchar(5),
	ResourceName nvarchar(100),
	ResourceValue nvarchar(max)
)

SET @getid = CURSOR FOR
select StringID, StringKey
from CMS_ResourceString

OPEN @getid
FETCH NEXT
FROM @getid INTO @id, @name
WHILE @@FETCH_STATUS = 0
BEGIN
	insert into #TempResourceStrings (ResourceID, ResourceKey, ResourceLangCode, ResourceName, ResourceValue) 
	select @id, @name, c.CultureCode, c.CultureShortName, (select TranslationText from CMS_ResourceTranslation rt where c.CultureID = rt.TranslationCultureID AND rt.TranslationStringID = @id)
	from CMS_Culture c
		inner join CMS_SiteCulture sc on c.CultureID = sc.CultureID 
    FETCH NEXT
    FROM @getid INTO @id, @name
END

select *
from #TempResourceStrings
ORDER BY ResourceKey

drop table #TempResourceStrings
CLOSE @getid
DEALLOCATE @getid

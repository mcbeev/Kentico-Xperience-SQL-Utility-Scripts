--------------------------------------------------------------------------------------------------------------------------
-----------  Container to Coupled Page Type Converter for KX12 (by Trevor Fayas - github.com/kenticodevtrev  -------------
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
-- KX13 does not have Containered Page Types, generally (they exist but you can't create them).  
-- Coupled with this, many Containered page types (such as folders) in KX12 still were used as part of the URL structure
-- generation.  Since during the KX12 to KX13 upgrade, any page types with an empty or null ClassURLPattern have the URL
-- featured disabled and are not included thus in URL generation for any child elements, this can cause issues with old
-- URLs no longer existing.  An example is if you have a page with NodeAliasPath /Articles/2020/May/Hello, and the
-- 2020 and May elements are folders (or any page type without a ClassURLPattern), KX 12 will make the url 
-- /Articles/Hello instead of it's original URL of /Articles/2020/May/Hello
-- 
-- To Fix this, before your upgrade, you should convert Container Page Types to normal Content Only Coupled Page Types,
-- and have the ClassURLPattern set to {% NodeAliasPath %}.  This script does this for you, adding a "Name" Field and 
-- proper joining tables.
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
---------------------------- ALWAYS BACK UP BEFORE RUNNING: Don't be that guy! -------------------------------------------
---------------------- Also in Kentico do a System -> Clear Cache / Restart Application after-----------------------------
--------------------------------------------------------------------------------------------------------------------------

-- MODIFY THESE 3 ONLY
-- Example for class Generic.Folder
declare @Namespace nvarchar(100) = 'Generic'
declare @Name nvarchar(100) = 'Folder'
declare @EnsureUrlPattern bit = 1; -- Adds {% NodeAliasPath %} to the ClassURLPattern

-- DO NOT MODIFY BELOW
declare @ClassName nvarchar(200);
declare @TableName nvarchar(200);
declare @FormIDFieldGuid nvarchar(50);
declare @FormNameFieldGuid nvarchar(50);
declare @FormIDSearchFieldGuid nvarchar(50);
declare @FormNameSearchFieldGuid nvarchar(50);
set @ClassName = @Namespace+'.'+@Name
set @TableName = @Namespace+'_'+@Name
set @FormIDFieldGuid = LOWER(Convert(nvarchar(50), NewID()));
set @FormNameFieldGuid = LOWER(Convert(nvarchar(50), NewID()));
set @FormIDSearchFieldGuid = LOWER(Convert(nvarchar(50), NewID()));
set @FormNameSearchFieldGuid = LOWER(Convert(nvarchar(50), NewID()));

-- Update Class
update CMS_Class set
ClassIsDocumentType = 1,
ClassIsCoupledClass = 1,
ClassXmlSchema = '<?xml version="1.0" encoding="utf-8"?>
<xs:schema id="NewDataSet" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
  <xs:element name="NewDataSet" msdata:IsDataSet="true" msdata:UseCurrentLocale="true">
    <xs:complexType>
      <xs:choice minOccurs="0" maxOccurs="unbounded">
        <xs:element name="'+@TableName+'">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="'+@Name+'ID" msdata:ReadOnly="true" msdata:AutoIncrement="true" type="xs:int" />
              <xs:element name="Name">
                <xs:simpleType>
                  <xs:restriction base="xs:string">
                    <xs:maxLength value="200" />
                  </xs:restriction>
                </xs:simpleType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:choice>
    </xs:complexType>
    <xs:unique name="Constraint1" msdata:PrimaryKey="true">
      <xs:selector xpath=".//'+@TableName+'" />
      <xs:field xpath="Folder2ID" />
    </xs:unique>
  </xs:element>
</xs:schema>',
ClassFormDefinition = '<form version="2"><field column="'+@Name+'ID" columntype="integer" guid="'+@FormIDFieldGuid+'" isPK="true" publicfield="false"><properties><fieldcaption>'+@Name+'ID</fieldcaption></properties><settings><controlname>labelcontrol</controlname></settings></field><field column="Name" columnsize="200" columntype="text" guid="'+@FormNameFieldGuid+'" publicfield="false" visible="true"><properties><fieldcaption>Name</fieldcaption></properties><settings><AutoCompleteEnableCaching>False</AutoCompleteEnableCaching><AutoCompleteFirstRowSelected>False</AutoCompleteFirstRowSelected><AutoCompleteShowOnlyCurrentWordInCompletionListItem>False</AutoCompleteShowOnlyCurrentWordInCompletionListItem><controlname>TextBoxControl</controlname><FilterMode>False</FilterMode><Trim>False</Trim></settings></field></form>',
ClassNodeNameSource = 'Name',
ClassTableName = @TableName,
ClassShowTemplateSelection = null,
ClassIsMenuItemType = null,
ClassSearchTitleColumn = 'DocumentName',
ClassSearchContentColumn='DocumentContent',
ClassSearchCreationDateColumn = 'DocumentCreatedWhen', 
ClassSearchSettings = '<search><item azurecontent="True" azureretrievable="False" azuresearchable="True" content="True" id="'+@FormNameSearchFieldGuid+'" name="Name" searchable="False" tokenized="True" /><item azurecontent="False" azureretrievable="True" azuresearchable="False" content="False" id="'+@FormIDSearchFieldGuid+'" name="'+@Name+'ID" searchable="True" tokenized="False" /></search>',
ClassInheritsFromClassID = 0,
ClassSearchEnabled = 1,
ClassIsContentOnly = 1,
ClassURLPattern = case when @EnsureUrlPattern = 1 then '{% NodeAliasPath %}' else ClassURLPattern end
where ClassName = @ClassName

-- Create table
declare @CreateTable nvarchar(max);
set @CreateTable = '
CREATE TABLE [dbo].['+@TableName+'](
	['+@Name+'ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_'+@TableName+'] PRIMARY KEY CLUSTERED 
(
	['+@Name+'ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].['+@TableName+'] ADD  CONSTRAINT [DEFAULT_'+@TableName+'_Name]  DEFAULT (N'''') FOR [Name]'
exec(@CreateTable);

-- Populate joining table data, as well as generate the default url path entry based on nodealiaspath
declare @BindingAndVersionSQL nvarchar(max);

set @BindingAndVersionSQL = '
declare @ClassName nvarchar(200);
declare @TableName nvarchar(200);
declare @documentid int;
declare @documentname nvarchar(200);
declare @documentculture nvarchar(10);
declare @NodeID int;
declare @SiteID int;
declare @newrowid int;
set @ClassName = '''+@Namespace+'.'+@Name+'''
set @TableName = '''+@Namespace+'_'+@Name+'''
declare contenttable_cursor cursor for
 select * from (
  select
  COALESCE(D.DocumentID, NoCultureD.DocumentID) as DocumentID,
COALESCE(D.DocumentName, NoCultureD.DocumentName) as DocumentName,
 C.CultureCode,
NodeID, 
NodeSiteID
  from  CMS_Site S
    left join CMS_SiteCulture SC on SC.SiteID = S.SiteID
	left join CMS_Culture C on C.CultureID = SC.CultureID
	left join CMS_Tree on NodeSiteID = S.SiteID
	left join CMS_Class on ClassID = NodeClassID
	left outer join CMS_Document D on D.DocumentNodeID = NodeID and D.DocumentCulture = C.CultureCode
	left outer join CMS_Document NoCultureD on NoCultureD.DocumentNodeID = NodeID
	where ClassName = @ClassName
	) cultureAcross
	group by DocumentID, DocumentName, CultureCode, NodeID, NodeSiteID
	order by DocumentID
open contenttable_cursor
fetch next from contenttable_cursor into @documentid, @documentname, @documentculture, @NodeID, @SiteID
WHILE @@FETCH_STATUS = 0  BEGIN
	-- insert into binding table --
	INSERT INTO [dbo].['+@TableName+'] ([Name]) VALUES (@documentname)
	
	-- Update document --
	set @newrowid = SCOPE_IDENTITY();
	update CMS_Document set DocumentForeignKeyValue = @newrowid where DocumentID = @documentid
	
	-- update also history --
	update CMS_VersionHistory set NodeXML = replace(NodeXML, ''<DocumentID>''+CONVERT(nvarchar(10), @documentid)+''</DocumentID>'', ''<DocumentID>''+CONVERT(nvarchar(10), @documentid)+''</DocumentID><DocumentForeignKeyValue>''+CONVERT(nvarchar(10), @newrowid)+''</DocumentForeignKeyValue>'') where DocumentID = @documentid
	
	FETCH NEXT FROM contenttable_cursor into @documentid, @documentname, @documentculture, @NodeID, @SiteID
END
Close contenttable_cursor
DEALLOCATE contenttable_cursor'
exec(@BindingAndVersionSQL)

--------------------------------------------------------------------------------------------------------------------------
-----------  Container to Coupled Page Type Converter for KX13 (by Trevor Fayas - github.com/kenticodevtrev  -------------
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
-- Whlie it is best to fix this before upgrade, sometimes that's no longer an option.  This script will switch the Container
-- page type to a Coupled Page Type, create the binding tables, handle initial Url Generation.  If you need help 'cleaning'
-- up the URLs after you do this to try to fix existing issues, please contact tfayas@hbs.net, i have a script that can
-- rebuild the URLs in KX13.
--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
---------------------------- ALWAYS BACK UP BEFORE RUNNING: Don't be that guy! -------------------------------------------
---------------------- Also in Kentico do a System -> Clear Cache / Restart Application after-----------------------------
--------------------------------------------------------------------------------------------------------------------------

-- MODIFY THESE 4
declare @Namespace nvarchar(100) = 'Generic'
declare @Name nvarchar(100) = 'Folder'
declare @CulturePrefix bit = 1;
declare @NoPrefixOnDefaultCulture bit = 1;

-- Do not modify below
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
      <xs:field xpath="'+@Name+'ID" />
    </xs:unique>
  </xs:element>
</xs:schema>',
ClassFormDefinition = '<form version="2"><field column="'+@Name+'ID" columntype="integer" guid="'+@FormIDFieldGuid+'" isPK="true"><properties><fieldcaption>'+@Name+'ID</fieldcaption></properties></field><field column="Name" columnsize="200" columntype="text" guid="'+@FormNameFieldGuid+'" visible="true"><properties><fieldcaption>Name</fieldcaption></properties><settings><AutoCompleteEnableCaching>False</AutoCompleteEnableCaching><AutoCompleteFirstRowSelected>False</AutoCompleteFirstRowSelected><AutoCompleteShowOnlyCurrentWordInCompletionListItem>False</AutoCompleteShowOnlyCurrentWordInCompletionListItem><controlname>TextBoxControl</controlname><FilterMode>False</FilterMode><Trim>False</Trim></settings></field></form>',
ClassNodeNameSource = 'Name',
ClassTableName = @TableName,
ClassShowTemplateSelection = null,
ClassIsMenuItemType = null,
ClassSearchTitleColumn = 'DocumentName',
ClassSearchCreationDateColumn = 'DocumentCreatedWhen', 
ClassSearchSettings = '<search><item azurecontent="False" azureretrievable="True" azuresearchable="False" content="False" id="'+@FormIDSearchFieldGuid+'" name="'+@Name+'ID" searchable="True" tokenized="False" /><item azurecontent="True" azureretrievable="False" azuresearchable="True" content="True" id="'+@FormNameSearchFieldGuid+'" name="Name" searchable="False" tokenized="True" /></search>',
ClassSearchEnabled = 1,
ClassUsesPageBuilder = 0,
ClassIsNavigationItem = 0,
ClassHasURL = 1,
ClassHasMetadata = 0
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
declare @NodeGuidPostfix nvarchar(50);
declare @UrlPath nvarchar(500);
declare @UrlPathCulturePrefix nvarchar(50);
declare @UrlPathPostfix nvarchar(100);
declare @NodeID int;
declare @SiteID int;
declare @newrowid int;
declare @UrlExistingMatches int;
declare @UrlPathComplete nvarchar(500);

set @ClassName = '''+@Namespace+'.'+@Name+'''
set @TableName = '''+@Namespace+'_'+@Name+'''

declare contenttable_cursor cursor for

 select * from (
  select
  COALESCE(D.DocumentID, NoCultureD.DocumentID) as DocumentID,
COALESCE(D.DocumentName, NoCultureD.DocumentName) as DocumentName,
 C.CultureCode,
NodeID, 
NodeSiteID, 
RIGHT(NodeAliasPath, len(NodeAliasPath)-1) as UrlPath,
case when 1='+Convert(nvarchar(1), @CulturePrefix)+' and (0='+Convert(nvarchar(1), @NoPrefixOnDefaultCulture)+' or C.CultureCode <> SiteDefaultVisitorCulture) then C.CultureCode+''/'' else '''' end as CulturePrefix,
LOWER(''-''+REPLACE(Convert(nvarchar(100), NodeGuid),''-'', '''')) as NodeGuidPostfix
  from  CMS_Site S
    left join CMS_SiteCulture SC on SC.SiteID = S.SiteID
	left join CMS_Culture C on C.CultureID = SC.CultureID
	left join CMS_Tree on NodeSiteID = S.SiteID
	left join CMS_Class on ClassID = NodeClassID
	left outer join CMS_Document D on D.DocumentNodeID = NodeID and D.DocumentCulture = C.CultureCode
	left outer join CMS_Document NoCultureD on NoCultureD.DocumentNodeID = NodeID
	where ClassName = @ClassName
	) cultureAcross
	group by DocumentID, DocumentName, CultureCode, NodeID, NodeSiteID, UrlPath, CulturePrefix, NodeGuidpostFix
	order by UrlPath

open contenttable_cursor
fetch next from contenttable_cursor into @documentid, @documentname, @documentculture, @NodeID, @SiteID, @UrlPath, @UrlPathCulturePrefix, @UrlPathPostfix

WHILE @@FETCH_STATUS = 0  BEGIN

	-- insert into binding table --
	INSERT INTO [dbo].['+@TableName+'] ([Name]) VALUES (@documentname)
	
	-- Update document --
	set @newrowid = SCOPE_IDENTITY();
	update CMS_Document set DocumentForeignKeyValue = @newrowid where DocumentID = @documentid
	
	-- update also history --
	update CMS_VersionHistory set NodeXML = replace(NodeXML, ''<DocumentID>''+CONVERT(nvarchar(10), @documentid)+''</DocumentID>'', ''<DocumentID>''+CONVERT(nvarchar(10), @documentid)+''</DocumentID><DocumentForeignKeyValue>''+CONVERT(nvarchar(10), @newrowid)+''</DocumentForeignKeyValue>'') where DocumentID = @documentid
	
	---------------------------------
	-- Create initial UrlPagePaths --
	---------------------------------
	set @UrlPathComplete = @UrlPathCulturePrefix+@UrlPath;

	-- Add guid postfix if match on the page url path exists.
	set @UrlExistingMatches = (select count(*) from CMS_PageUrlPath where PageUrlPathUrlPath = @UrlPathCulturePrefix+@UrlPath)
	if @URLExistingMatches > 0 begin
		set @UrlPathComplete = @UrlPathComplete+@UrlPathPostfix
	end

	-- If conflict on alternative url, then handle as well
	set @UrlExistingMatches = (select count(*) from CMS_AlternativeUrl where CONVERT(NVARCHAR(64), HASHBYTES(''SHA2_256'', LOWER(AlternativeUrlUrl)), 2) = CONVERT(VARCHAR(64), HASHBYTES(''SHA2_256'', LOWER(@UrlPathComplete)), 2) and AlternativeUrlSiteID = @SiteID)
	if @URLExistingMatches > 0 begin
		set @UrlPathComplete = @UrlPathComplete+''-''+Convert(nvarchar(100), NewID())
	end

	INSERT INTO [dbo].[CMS_PageUrlPath]
           ([PageUrlPathGUID]
           ,[PageUrlPathCulture]
           ,[PageUrlPathNodeID]
           ,[PageUrlPathUrlPath]
           ,[PageUrlPathUrlPathHash]
           ,[PageUrlPathSiteID]
           ,[PageUrlPathLastModified])
     VALUES
           (NEWID()            
		   ,@documentculture
		   ,@NodeID
           ,@UrlPathComplete
           ,CONVERT(VARCHAR(64), HASHBYTES(''SHA2_256'', LOWER(@UrlPathComplete)), 2)
           ,@SiteID
           ,GETDATE())

	FETCH NEXT FROM contenttable_cursor into @documentid, @documentname, @documentculture, @NodeID, @SiteID, @UrlPath, @UrlPathCulturePrefix, @UrlPathPostfix
END
Close contenttable_cursor
DEALLOCATE contenttable_cursor'
exec(@BindingAndVersionSQL)
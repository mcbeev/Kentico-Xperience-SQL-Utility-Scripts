-------------------------------------------------------------------------------
-------- PRE UPGRADE Kentico Xperience 12 to Kentico Xperience 13  ------------
-------- UI Element Foreign Key Fix                                ------------
-- Instances of Kentico Xperience that started before KX 12 may have foreign --
-- key dependencies that will cause sql errors during upgrade.  This script  --
-- should be ran just prior to running the upgrade script to resolve UI      --
-- foreign key dependencies.                                                 --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------


          DECLARE @UIElements TABLE
          (
          Identifier uniqueidentifier
          );

          INSERT INTO @UIElements (Identifier)
          VALUES
          ('6b7eb9f5-9471-4f54-8944-f50ae15e03bb'), -- Remove Variants tab for content personalization (PLATFORM-15354)
          ('9e54b4da-4f2d-4491-a2d8-14cbb4e5fb24'), -- Remove Variants tab (PLATFORM-15312)
          ('1396d102-fcad-4b5d-bf80-fe945ff7b7c8'), -- Remove Persona tagging (CM-12683)
          ('b4004f19-d30f-422f-89a8-d60d5729f9ca'), -- Remove cms.file (PLATFORM-15236)
          ('d57a9cd2-5760-4573-99f1-04e8a8052b23'),
          ('773a0990-93a1-4375-907e-90e92a7c2a6b'),
          ('4b26978f-d069-4e20-a3e3-9c8ecaa67b55'), -- Remove sitemap support (PLATFORM-15183)
          ('facfa901-8cd4-41b0-854b-8beaf1b35a64'),
          ('912d9f65-02fd-42cb-a8b1-7f92b4e6dfe1'), -- Remove Template tab (PLATFORM-15135)
          ('21b7650b-f679-4227-a862-6b458acec104'),
          ('50f73376-9da6-465e-814b-2f701a2b6e36'),
          ('ad7d5ac2-c34d-4ec2-bc69-8ba584eb40ca'),
          ('afddc439-6216-4abb-bfd1-9300ba2ab5d8'),
          ('d46c2189-92f5-45b7-a34f-d21e8b342a67'),
          ('c7e0dd93-eac4-4567-8d1e-2dc845112c9f'),
          ('f4888178-fced-4854-81b6-e75ace98e80e'),
          ('fe219366-ce03-4d4f-a142-c036398a8ad3'),
          ('24ff71b5-2f83-4d93-acaa-d44ad230be41'),
          ('5bcc2097-7efa-49a7-9bb2-1c53b6bbbcc4'),
          ('555ea8b6-a655-4d82-89c8-168a63396d17'),
          ('b5a79666-a180-4be1-8dfb-fb297467edae'), -- Remove Online marketing section from General tab (PLATFORM-15096)
          ('8de24c03-0b37-40f1-9d16-417a97992d7a'), -- Remove Advanced section from General tab (PLATFORM-15095)
          ('e0892425-4454-4869-a31f-052af5b5fd5b'), -- Remove output cache fields (PLATFORM-15094)
          ('5ff31cb5-169b-424b-ad04-7acefea83542'), -- Remove custom etensions fields (PLATFORM-15091)
          ('ec3d79d1-6ba8-4ace-81eb-c73f846091b1'), -- Remove Analytics tab and sub-tabs (PLATFORM-15089)
          ('9692cedc-7b8c-4954-8bf4-aa136a038ae0'),
          ('73d4510b-7cee-4fc2-a49f-f840a56f0366'),
          ('f6413e96-fb74-40fa-bd7d-d987eee2ac3a'),
          ('993d8225-c9e9-48cd-ba70-d996d43155da'),
          ('ec7743a3-cee6-4873-bbe5-e9d4f130a081'),
          ('9b416d2a-72ff-437c-8e21-4c15cff785fb'), -- Remove Design tab and sub-tabs (PLATFORM-15058)
          ('2b4cef22-2b55-4915-bec2-c24ca254d61c'),
          ('5f30799d-4eb9-4002-b8e0-2387a526fa98'),
          ('f51d0a3f-852b-44ba-ba1e-74542b14f38a'),
          ('4958c021-feb5-4755-8d1a-9c67913ea453'),
          ('41f841fb-ae93-4d4d-a20a-05772efe2fa2'),
          ('550cf0ff-0b7f-42ab-989f-5373504a9890'),
          ('34172a4c-9104-4355-af2b-9da0c7c19386'),
          ('681fd60c-4998-41eb-8c10-91e03f0ce242'),
          ('68453d64-cbed-4917-9801-46e7f0d07676'),
          ('4c2fe72b-568a-4a4c-bb61-95dd3150aa39'),
          ('bc3aafb6-84dc-4ab0-87e7-36435ed42ad4'),
          ('aeb5cea7-da2c-4461-b594-bc52bc60b3f9'),
          ('49019e79-2e69-42fa-92be-0d744414ba6c'),
          ('beddc0cd-ceb3-4bd6-bb43-f9fb86bb38ac'),
          ('f854536c-307c-4b0e-ae64-52a48f31a3d8'),
          ('b30b9fc3-b193-4c6e-89ae-54c4f0fc7dcb'),
          ('8e525ca6-2573-46f6-84cd-59e0782bdbf2'),
          ('94fb8a06-d667-4741-a2ab-023ca918d3b6'),
          ('d7a93b63-c2e6-402a-9031-23475ded1f1c'),
          ('b9c0c264-2c24-4399-b5d4-5e9151ef7597'),
          ('c90240a4-5701-47f5-b29f-5ca84eb73eff'),
          ('7ee35791-5b19-456e-b5fb-f9c9a2908fd6'),
          ('40f0ce57-5ced-4394-ab20-f332655235de'),
          ('bc75c55b-4ba4-4a34-8a29-1a10facdfca0'), -- Remove DocumentUrlPath (PLATFORM-14965)
          ('ca81bd88-7e29-4e69-aa26-69b799573abe'), -- Master page tab (PLATFORM-14983)
          ('bf02c563-d83e-43ff-9991-7d87911b3056'), -- Page aliases (PLATFORM-15025)
          ('7aa16531-4f60-4aee-85df-89409c275610'), -- Page tab (PLATFORM-14690)
          ('ac5f7125-ec5e-4ed1-a400-de0676f46189'), -- Avatars (CM-12692)
          ('79deea0a-98a5-4df6-86b1-d5b7a859fc43'), -- Alternative URLs tab (PLATFORM-15503)
          ('f4a2df02-cf32-45c8-86e5-49432520f8ce'), -- Removed forms (PLATFORM-15603)
          ('46207f71-e9bf-4352-bc4d-1ce096411732'),
          ('0d7a48a0-1dae-493a-9d0b-f56a484f18de'),
          ('fcd48f9f-6283-4aaa-8fef-d5bf429d2142'),
          ('1cdc525c-aae2-4818-83d9-258c0d3b607c'),
          ('dcf0764b-72f2-4759-a143-1443f34bb337'),
          ('c7bb2f6f-7852-4487-ae52-f7b58ef72a6b'),
          ('51546812-c3da-40cb-8374-d779437c8ee6'),
          ('da79d75d-2bf7-427d-a6a4-011f6e194516'),
          ('01673678-c183-4785-acbf-cf4ef78e1dbd'), -- Remove Layout tab for page types (PLATFORM-15597)
          ('f837adb5-65d4-44f1-b2f1-92770d4d3162'), -- Remove Online Users from contact management (PLATFORM-15652)
          ('65b6dcb8-4e80-41ed-927e-6a747a9866db'),
          ('2ff9c4a7-19ef-4243-a10f-abc42a3dabbb'),
          ('70dc6207-8211-4c36-b58c-41958f833f5c'), -- Remove INLINE controls from WYSIWYG (CM-12914)
          ('a94ddf97-0b2c-4f74-9148-93c66c4e04a6'),
          ('60ccceff-1783-4239-bf23-6f03fe9eb61f'),
          ('fff72593-3e48-4979-bdf7-d4f7777fb038'),
          ('b4e584a0-fd5a-48f3-8d47-31c93f31618b'),
          ('b6a6e38d-465e-4719-a184-992c6e3f20d8'),
          ('2a65fe23-93d9-462f-ae1b-1b49133676b7'), -- Remove WebPart.Design element (PLATFORM-15649)
          ('5ed7c13f-1bc2-4504-a2fc-4c4be7513fd4'),
          ('251b022e-fc4e-4bb0-a6ec-60818fb7d2da'),
          ('e80b25ac-c61b-407b-9a43-b1a79a7055e4'),
          ('c4e5b361-f17d-4dca-934a-131b8d2bab86'),
          ('00cad23d-3b15-442a-9d0c-ac336478c97e'), -- Remove PageTemplateDeviceLayouts elements (PLATFORM-15987)
          ('ce87d8c9-3050-4b7a-b8ea-2f7821e7e6da'),
          ('c23d37da-c88a-463a-bac4-8401fcfc7883'),
          ('52b1b04e-0787-4932-a175-3daee7a7c42b'),
          ('714c267a-0ef3-4a08-9ac8-cd4dc412cfa0'),
          ('f1ce195f-6cea-4359-b19a-628d02d18e28'),
          ('99158ed5-3101-4e37-8121-309b1addc9cc'), -- Remove PageTemplate elements (PLATFORM-15986)
          ('34f28c89-2bd7-4fb7-b19f-ac8ec409e8f9'),
          ('d8570166-0f58-46a0-9659-423603ecb3b9'),
          ('b75fa37b-0611-4a7d-b0b5-8053a10629cf'),
          ('6e865cbc-fa69-4c3f-aef9-f8519d8b5688'), -- Remove On-line Marketing tabs in (Multi)Store configuration (PLATFORM-15983)
          ('8aa4c7a5-de53-4f0a-bb57-beed0c11fe80'),
          ('74615519-9fa1-492a-9e5d-e5adb12e1a8e'), -- Remove PageTemplates from Sites App (PLATFORM-16044)
          ('e587feb4-c356-4907-9efb-41d79ebd95b6'),
          ('c094677f-1a7b-4388-9f0f-dab906800e08'), -- Remove ABVariant (PLATFORM-15325)
          ('281a6791-6179-4a92-a86d-2fd410a19b45'),
          ('7dc5113e-991a-447c-8783-3d7e1472ebac'),
          ('f499da4c-efab-407c-ad89-b6ba99f71f8b'),
          ('ea681d2d-8f41-4b19-9dcf-bbccde6dc86b'), -- Remove SiteDomainAlias old UI (PLATFORM-16123)
          ('91a93923-df6b-4138-bc13-49ab28eec67d'),
          ('102f2747-b384-4776-80cc-655d2892d74e'), -- Removed aggregated views (PLATFORM-16201)
          ('ae98b2ff-26e0-4c6a-8e67-5ec8487ba3da'),
          ('2f7adb9f-bb4a-4f41-a53e-312a85b672bb'),
          ('d6a7f7f6-3009-478d-ae69-e9486bd51eb0'), -- Remove Report tab from Marketing Automation process (CM-13056)
          ('bd7fe72a-b2e2-4f3f-b880-1bb56582f524'), -- Remove Blogs (PLATFORM-16554)
          ('54eb846c-6048-4679-af6f-bfa1354c10e2'),
          ('5c77292d-92cc-4400-829d-66a158205110'),
          ('75691526-92b9-44ad-9788-c5885036e936'),
          ('c0536289-6aa5-4c86-8627-b91afc0ae7e5'),
          ('f9a3d08d-41bf-4922-b4a4-0b4110792785'),
          ('ab617598-21c4-4621-9fa1-bcdabf472579'), -- Remove abuse reports (PLATFORM-16566)
          ('60f7243c-64d1-4cce-8c93-ce4341a1b982'), -- Remove bad words (PLATFORM-16578)
          ('39e4ef11-67a9-4c95-b8d9-eca1888da932'),
          ('83811a53-08db-455c-ad99-7eaf3963fd37'),
          ('7c3ae191-3b32-41d8-bfce-7b28d3765b8e'),
          ('5bb05075-4f56-493a-8010-e41b25bc386f'),
          ('bb6226de-a2d9-4668-bd87-26e2eddb0cef'), -- Remove message boards (PLATFORM-16583)
          ('81baba69-3187-4efa-b72c-0193417b9d3f'),
          ('acf76596-b57c-4e1f-a77b-deea4130b2ec'),
          ('7e520518-c78f-4139-861d-3593a6b99784'),
          ('6d5fbafe-56b2-4e9a-ae8c-10da1be24b02'),
          ('a21b3f1e-99a7-467f-84df-917333330264'),
          ('f5512912-267c-4f53-8664-b387c32ccce4'),
          ('adbce010-8aa6-42d8-99e5-160032176cc6'),
          ('a81c0b81-28e9-4ed2-8f7e-ddbb7b3fd93e'),
          ('bc5e68ef-21fb-427c-8674-e6fe49bab83e'),
          ('e0460142-aa21-4c2c-81cf-178c42c4a86d'),
          ('216ce98b-8172-46f2-9c1e-b862a1414011'),
          ('2ac5ab8c-5fcf-4607-a9a8-c65b17bd4268'),
          ('768a3ad2-cf47-403b-83c3-1ee20fdf587e'),
          ('0ab9fbb4-8169-443b-8038-d13b5bdb2822'),
          ('fcab9deb-2b93-495f-8771-59393e29b008'),
          ('9957529b-0b4d-4ba6-9e12-a09a1ed1e65a'),
          ('12c1eb41-9b97-4477-9331-620a7fff2ecb'),
          ('4cd08eee-374b-4c82-84f8-8fd3dc091cb2'), -- Remove events (PLATFORM-16585)
          ('66068064-a270-4908-a20f-7c1013cb0301'),
          ('d826280d-23c7-4f2a-8efb-8f3b83df8393'),
          ('f0edfdd8-abfa-4c39-816a-5a40008bacf8'),
          ('c8d89c20-ab47-4e3a-a258-b08780446c3d'), -- Remove site offline mode, site bindings to polls, CSS stylesheets and web part containers (PLATFORM-15953)
          ('5c850d20-e93e-4edb-ace2-a9622f89241d'),
          ('caae294a-3431-4424-873a-7bb4fb03cdfc'),
          ('3b5e216e-2823-43bb-9c3d-c2a13a7c3723'),
          ('5d4aa6b6-93b8-4c7e-be30-8dfc74f5853e'), -- Web Analytics cleanup (PLATFORM-16206)
          ('96ae6b5b-a883-491b-a16d-2577e109dc23'),
          ('c9124c8d-d3e9-4f14-970d-57e6ad90d93a'),
          ('c86b3d64-87e5-4fbe-b498-8fd04c21549e'),
          ('5a32971f-607b-4bbe-b0ee-2e51e297e847'),
          ('f40d7df4-f29c-4554-8be7-0818a4429291'),
          ('2ef2d4a0-b2e3-4ede-bf72-c79e8be015e8'),
          ('7a09c17f-9960-403a-a4da-c77b1f3cf3a8'),
          ('ab290fd4-f707-45b8-944c-7e0f256f2be8'), -- Remove CSS app (PLATFORM-16591)
          ('2ca581af-450b-4617-88c1-6dc16c6c930e'),
          ('8494978e-4c28-40c8-9a6c-1f1c11cd9471'),
          ('7b0ce98c-4b39-4c16-9fb9-9d396fb9053e'),
          ('e7a7a816-117a-4cc9-b77f-6cf8c9b2aeaa'),
          ('756fe462-7e5e-498c-b0ce-6af7f7b41084'),
          ('c3a8ca8c-8a6a-42b4-b5a9-a8dafc93820b'), -- Remove CSS app (PLATFORM-15863)
          ('35f6778f-27ff-4420-94fa-12cfc0ea12e2'),
          ('8b198d0e-c384-4da7-97f2-4daa9edeae3b'),
          ('4440cc2c-e4ea-4955-be55-afb8c65f0bf7'), -- Remove MVT support (PLATFORM-15781)
          ('5824596e-f4a6-4d06-9621-3abe9181e9d7'),
          ('1b0c77d8-e09d-47ae-aeca-10cf43aa32d7'),
          ('a51d90f5-0ace-455a-a8cb-048454be53a3'),
          ('eaf9ce44-be29-409b-b2aa-e7b98b1c8ec2'),
          ('35f6778f-27ff-4420-94fa-12cfc0ea12e2'),
          ('8b198d0e-c384-4da7-97f2-4daa9edeae3b'),
          ('9ffd6c53-4c93-4137-b4eb-f948a48b683a'), -- Remove Badges (PLATFORM-16620)
          ('4931e81b-7b59-4340-a3d0-359fdbebb5de'),
          ('1a7b69ee-4f31-49d0-a7c4-a73d6e915df2'),
          ('141b0fa5-1ffe-4264-8a7b-f558e398d769'), -- Remove Forums (PLATFORM-16628)
          ('db250e18-f7c9-4eb9-8fd7-cacf80d8414b'),
          ('65bdec63-a802-4e38-97e3-3bb486eac2ba'),
          ('9921f272-9e5f-4467-8d42-76d0e1eabae0'),
          ('cf93caeb-3d56-46e3-ab74-c8168384ea73'),
          ('4f4a5812-7311-4e2c-aed4-c9ae84177efc'),
          ('767fef2f-5b2b-4e76-8e63-a6e8fdccb154'),
          ('df0a9a45-1983-4414-ade6-6c2ac398cd90'),
          ('ff02e464-a1d4-4f01-a0a7-ab6b2791b55c'),
          ('3bbd6057-122d-4fe2-81de-e0750ca9929c'),
          ('b1a545c3-b8d4-4112-b844-86f086194098'),
          ('df77b461-f1c5-45c0-8ac7-e0e80ca72eed'),
          ('cd638e2a-6ace-4e0c-85e0-14cc8a4ee1a5'),
          ('6e774946-e841-4e0e-9086-590efe2abfc3'),
          ('345f7685-1d34-4540-9d63-3bb6d7ee2bf9'),
          ('16774cdd-c2f7-4aaa-af9e-146ccb400f87'),
          ('634c7bc3-638b-4894-9d30-abb50d0261fb'),
          ('6acd5fa8-b28a-48e7-b439-b95eb5cda38e'),
          ('ae5f1d30-2fb0-40c7-9661-5b176dc3a536'),
          ('f245e6ec-d0f2-4e51-8546-a90d890eee63'),
          ('de463408-6153-447b-b7ac-785479d98087'),
          ('3ea3d682-147a-41ca-89db-419a029aa231'),
          ('9c372a01-21cc-418d-be86-8491ac3a2889'),
          ('79077afd-9f91-40fa-8926-7904f0e498f9'),
          ('5b75c243-132a-489e-a954-9725b9f1e87e'),
          ('265b0ee1-09c5-4c29-84d3-816f96960aae'),
          ('41ec9f5d-7569-454b-9af5-ddd7d39f4237'), -- Remove Navigation > Basic properties (PLATFORM-16611)
          ('48188299-29c3-45c8-92b6-d0a9bfc94418'), -- Web templates (PLATFORM-16588)
          ('324729ca-f2c7-4813-b7af-bc409a76e83b'),
          ('f95d0795-77d9-4047-ae4e-0b4616ff3b6d'),
          ('1c85c4b4-aeac-48bd-b02b-d25f67ff08a2'), -- Remove Polls (PLATFORM-15000)
          ('0b7c4fd1-b503-4ccb-a1d8-b50eeea704b6'),
          ('d37ed0ba-13e2-4907-8233-f3a1fcd06c6a'),
          ('52aa22a9-261e-4da1-af9b-3cae364773f4'),
          ('fbae4204-41f2-4a54-a13d-0dd705863209'),
          ('eb655ea1-9659-4120-a90e-6ef32deb0feb'),
          ('f758aa15-6888-4a7d-9dd8-10e306e9f7ad'),
          ('10209d17-6cd3-47d8-91b3-f718fa6c4000'),
          ('34dfa808-8f3e-47da-a465-b729ac959f69'),
          ('85372ca1-5f12-460c-9bd9-96b8f44029a5'),
          ('d37f6d82-131f-4195-b3ba-20c4bab56b71'),
          ('7a40f2e8-5f4e-45a7-af19-de2791c31206'),
          ('ef679cf1-ec6b-4590-bdcd-29bec5f07cf3'),
          ('3d90780f-f58b-4275-9ec6-165897095c82'),
          ('f04c3b54-ef8f-4acb-946a-3d1912228496'), -- Remove Banners (PLATFORM-15001)
          ('3bf5843e-ea8f-4d06-a0f5-fd9296ad798b'),
          ('ad39b67c-bb75-43f7-b7ea-3ad8850bb73b'),
          ('a0de1153-f314-4adc-b0ab-ba67ff1007e9'),
          ('edb610e5-fb99-457b-aefe-b7cd5787438e'),
          ('c48de8a2-2604-4d77-8e20-7eb2ce75733e'),
          ('d2456f97-8a79-48bb-9064-9fdacf97cfd6'),
          ('df982e11-1187-43ed-8c36-c2b15d5742fd'),
          ('d1341d4d-e94d-477b-a8c3-5af3cef52aff'),
          ('0712254E-BAB0-4CF1-9D2D-FEE5A1DB2BBB'), -- Remove Chat (PLATFORM-15006)
          ('D513547F-479E-407B-B063-8C7A966DF67D'),
          ('3B5A6663-B735-47A1-9AAB-F3EB00A99B96'),
          ('91628148-6EB3-4A7D-904A-1DA26928DD9F'),
          ('80014567-4648-485D-B937-410FEB3C51FE'),
          ('62B0ABE5-C34F-4770-83F2-BCED343A038F'),
          ('6E662840-BBAB-46A8-AAC7-90D9E1298EAC'),
          ('5302070C-C4CC-41CE-99B3-51473625289C'),
          ('743CF96B-D3DE-49F4-9049-5F4AD713EB91'),
          ('58FF5EAE-5DA0-4620-A73D-6D0D444E4F79'),
          ('639CB8EB-C204-4FFF-B823-0E8A74A71A67'),
          ('CB696D91-4951-4CF8-8A3F-D4F1AA853A3B'),
          ('FCD0F9BF-4A5D-4C2D-9061-14D79EA13B62'),
          ('F488432D-17FF-4030-BFBA-769B78DADBE9'),
          ('37C959EB-6673-4970-BC65-E76AF47943E6'),
          ('72b1e7b3-c6b9-4a18-afa1-3bb670fd61bb'), -- Pages app revision (PLATFORM-16610)
          ('1b319fa4-9f90-43f6-8f33-db3276b9ec99'),
          ('2C4BB770-3C04-48E4-BCA3-596A275BF63B'), -- Remove Conversions (PLATFORM-15002)
          ('7C283395-FEF5-4AD6-B47C-DDFE6E503E31'),
          ('2627E015-8B4D-43A7-8590-ECDD6AD43587'),
          ('ED89F99B-0BFE-4EFD-A754-2460718D69BE'),
          ('D12E3D37-51DF-4615-AC06-6C3DA2CFAFDC'),
          ('928C0610-9FC8-4944-B99F-E2E3AA0C6F10'),
          ('bf7d2d71-326e-421f-8848-8ddd0ff129b4'),  -- Remove API Examples (PLATFORM-15011)
          ('a15b1a8d-e08e-4d5b-a2bf-d0f04a4c379a'), -- Remove Transformations tab of Custom tables (PLATFORM-16677)
          ('184cefeb-c0f5-4502-ad73-55a5cabaa449'),
          ('a99830e2-a544-4554-861d-977afc23ce3e'),
          ('eda8c0ac-28ac-4be5-8c63-8d615b8b175d'), -- Remove Transformations tab of Module classes (PLATFORM-16677)
          ('2f4eff8c-a436-4410-a4c2-8548ea2a23c4'),
          ('e9f38fe6-663a-49ea-a478-2b04534800ba'),
          ('b27ad799-90db-47ab-9e60-bb01b25a7075'),
          ('b2bb8374-ee51-467b-892e-f636a26c91bf'), -- Remove Transformations tab within hierarchical transformations' UI (PLATFORM-16679)
          ('f17d7ef4-b4ba-4ccb-85b0-eae2b74c2725'), -- Remove Theme tab of Transformations (PLATFORM-16677)
          ('5c373307-436f-4d66-b48e-f9d2a075e8d4'), -- Remove Javascript files (PLATFORM-15013)
          ('09af764d-69f8-4525-805a-0d0a3f34fab3'), -- Remove Notifications (PLATFORM-15014)
          ('c84a6d2c-cc0d-4c2d-b915-c987d6a08a5f'),
          ('022b51fd-3dba-4a8c-a87b-ddc7db99e6c0'),
          ('bae01dd5-56b8-43b7-ae54-f2c682a37b6c'),
          ('07f40f20-077c-4e6c-bd25-15a349fd41c9'),
          ('b823c66b-987d-4cdb-94c9-1d32b137f284'),
          ('3674f51d-bf34-4a3b-a462-fc30c0a87e34'),
          ('52454895-9104-4024-b63e-5426977e86fb'),
          ('8aec5087-e75b-463d-9f2c-ee39be04c84b'),
          ('618ecd01-9db1-4b50-9c67-3d2d2663851d'),
          ('e9a854e5-8dc5-48b4-8df4-125c4d9cdabc'),
          ('7c117298-87c4-4f9d-9c77-393e93c29f28'),
          ('DF536424-1C20-4A5F-A9EF-C632F06F6336'),  -- Community groups
          ('91716FB1-BF2F-4CA6-92AB-F20BF348166D'),
          ('B189874F-0B3E-4680-A343-377409879A87'),
          ('9C73BFA6-BD54-4E7C-B2E3-1BB4455C5182'),
          ('1AA01C64-9413-46B3-8567-0DE33935FF7A'),
          ('D988CA19-D16F-44D9-B35C-2BF222ACC325'),
          ('B99C528E-D729-47F0-A3C4-839D0D910961'),
          ('320E0931-871A-4EAF-B369-CBA501ABB4A7'),
          ('1141571A-53F6-45A3-9E25-A841CB9E2251'),
          ('3F570F2C-E3DF-4608-ABF6-9A0A1E264113'),
          ('3463D612-60AC-4DB6-87E8-2A7731CE7511'),
          ('E03B1E03-9D27-48BF-9309-BE012A810EDA'),
          ('7CFC9C2F-9FAA-4BB8-94F1-FB890B31855C'),
          ('100B40E2-E0DE-4CDD-8D9A-B6AD3FACBB21'),
          ('9314ED30-17ED-4912-8DC2-D699D600EF21'),
          ('33CDA0EB-8013-4AED-888D-2DBC199C1906'),
          ('872a3765-bc7f-49e3-ad95-af19db23250e'),  -- Device profiles UI (PLATFORM-15012)
          ('28483db1-36bd-43ff-9b35-3abc1ca1abfd'),
          ('157be65c-8dfa-4990-a2ca-38030992ca69'),
          ('f709e8b6-9b6d-4a60-b608-a49c3e44a9a5'),
          ('b8256c2a-09f7-47ff-a26f-1d7542003736'),
          ('b510ca56-2963-4e39-ba4f-5a13a7457e21'),
          ('f350ee3c-242e-4591-a3ea-12a3d13bf438'),  -- On-site editing (PLATFORM-15199)
          ('931d00dd-440f-4c99-a7e5-678633e27f35'),
          ('02badb92-7a66-47a7-9c99-68e516d167ff'),
          ('9f9495ce-ca0e-4895-a49c-71a78692f966'),
          ('6c28e98f-c7b7-46dc-b9bb-8e5dd7a42d5a'),
          ('06328b52-19fb-4c32-8315-a9088468e29c'),
          ('e9c4120e-e506-4798-ac1d-a468854ceba3'),
          ('063236b5-6822-4f7a-a477-a80822debeb1'),
          ('585dba8e-25da-4345-a019-ed0bc096fae8'),
          ('7b169c33-ad0b-4813-af66-0f7ac3da6b83'),
          ('7a3216da-fa2e-4e26-9e32-ac5c67583d94'),
          ('158e437c-aaa3-460b-ad55-f053ed220d61'),
          ('651a9b2d-0b7a-4d9b-b87c-69259dc02397'),
          ('ea4e0eee-05e9-421a-8fcf-070a037356fb'),
          ('9bb73e7d-403b-45fd-9917-2d66117e4a4b'),
          ('fce2c698-6814-4eb5-9e3e-13b05438327d'),
          ('42ab6af5-8c68-4eae-990b-4cd26fd74ba8'),
          ('6a5e954e-b182-4d85-99c4-4d7006a9a3ed'),
          ('6abca888-a6e6-49d6-bb01-85aad206f860'),
          ('2ecd56ae-5dfe-4cb3-9da3-7e95455159f6'),
          ('14249b89-91e6-4463-bf03-c9e4e9feccbd'),  -- Web part containers (PLATFORM-15015)
          ('13faa3ef-8abe-42bc-bae7-0a70251fa480'),
          ('4c4423bc-f860-455c-9889-00f7574ace88'),
          ('d56ccc0c-ce73-42cf-b294-5a51192dc76c'),
          ('185cc0c8-0c9d-41bb-ba41-c129ca3e9157'),
          ('2edbae72-14c0-42f7-a8b4-2bdd4eb67ad3'),
          ('dd3dbea4-07b5-4905-b090-f7eca0dacdd8'),  -- Banned IPs (PLATFORM-14997)
          ('1c437eba-c14c-449c-9149-941a6d66f07a'),  -- Settings revision remove Debug - Requests, Output, View State sections (PLATFORM-15331)
          ('0dd2e710-722b-4e99-a874-d2478343a208'),
          ('ea3ee278-5939-440c-a014-63c0c1028bee')
          ;

          DELETE FROM [CMS_RoleApplication] WHERE [ElementID] IN (SELECT [ElementID] FROM [CMS_UIElement] WHERE [ElementGUID] IN (SELECT Identifier FROM @UIElements))
          DELETE FROM [CMS_RoleUIElement] WHERE [ElementID] IN (SELECT [ElementID] FROM [CMS_UIElement] WHERE [ElementGUID] IN (SELECT Identifier FROM @UIElements))

          DECLARE @elementCursor CURSOR;
          SET @elementCursor = CURSOR FOR SELECT [Identifier] FROM @UIElements

          DECLARE @elementIdentifier uniqueidentifier;

          OPEN @elementCursor

          FETCH NEXT FROM @elementCursor INTO @elementIdentifier;
          WHILE @@FETCH_STATUS = 0
          BEGIN
		  
			delete from CMS_UIElement where ElementParentID in (Select lvl1.ElementID from CMS_UIElement lvl1 where lvl1.ElementParentID in  (Select lvl2.ElementID from CMS_UIElement lvl2 where ElementParentID in (Select lvl3.ElementID from CMS_UIElement lvl3 where lvl3.ElementGUID = @elementIdentifier)))
			delete from CMS_UIElement where ElementParentID  in (Select lvl1.ElementID from CMS_UIElement lvl1 where lvl1.ElementParentID in (Select lvl2.ElementID from CMS_UIElement lvl2 where lvl2.ElementGUID = @elementIdentifier))
			delete from CMS_UIElement where ElementParentID in  (Select lvl1.ElementID from CMS_UIElement lvl1 where lvl1.ElementGUID = @elementIdentifier)
			delete from CMS_HelpTopic where HelpTopicUIElementID = (Select ElementID from CMS_UIElement where ElementGUID = @elementIdentifier)
			DELETE FROM [CMS_UIElement] WHERE [ElementGUID] = @elementIdentifier;

          FETCH NEXT FROM @elementCursor INTO @elementIdentifier;
          END

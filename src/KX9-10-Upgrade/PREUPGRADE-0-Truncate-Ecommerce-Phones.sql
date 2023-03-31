-------------------------------------------------------------------------------
-------- PRE UPGRADE Kentico 9 to Kentico 10                       ------------
-------- Ecommerce Address Fix                                     ------------
-- Instances of Kentico Xperience that started before Kentico 10 may have    --
-- foreign key dependencies that will cause sql errors during upgrade.  This --
-- script should be ran just prior to running the upgrade script to foreign  --
-- key dependencies.                                                 --
--                                                                           --
-- ALWAYS Backup before running these.  Don't be THAT Guy                    --
-- Author: Trevor Fayas, version 1.0.0                                       --
-------------------------------------------------------------------------------

UPDATE COM_Customer set CustomerPhone = LEFT(CustomerPhone, 26)  where Len(COALESCE(CustomerPhone, '')) > 26 
UPDATE COM_OrderAddress set AddressPhone = LEFT(AddressPhone, 26)  where Len(COALESCE(AddressPhone, '')) > 26
UPDATE COM_Address set AddressPhone = LEFT(AddressPhone, 26)  where Len(COALESCE(AddressPhone, '')) > 26
ALTER TABLE COM_Customer ALTER COLUMN CustomerPhone nvarchar(26) NULL
ALTER TABLE COM_OrderAddress ALTER COLUMN [AddressPhone] nvarchar(26) NULL
ALTER TABLE COM_Address ALTER COLUMN [AddressPhone] nvarchar(26) NULL
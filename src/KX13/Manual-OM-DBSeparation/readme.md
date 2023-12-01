# Database Separation (Manually, no downtime)

If you are leveraging Online Marketing features in KX13, it is often needed to separate the Online Marketing Database for high traffic sites in order to prevent degraded database performance.

Kentico provides [documentation and methods](https://docs.xperience.io/on-line-marketing-features/configuring-and-customizing-your-on-line-marketing-features/separating-the-contact-management-database) to do this, however it requires that the site go down, and has a risk of prolonged downtime.  It also doesn't allow copying of data for Azure.

These scripts provide a way to manually separate the database without downtime, and also solves issues the issue of keeping your marketing data in an Azure Environment.  

The only caveout is you will lose marketing data that occurs between the time you Clone the main database and when you push the new CMSOMConnectionString, if that concerns you then you will need to take your sites offline or disable online marketing during that time.

## How it works

Before I explain how this works, it's important to understand how the normal Kentico method works in database separation:

1. Turns off Scheduled Tasks
1. Sets a flag that causes your live site application to redirect all incoming requests to a `site down` type of page. (site goes 'offline')
1. Creates (or you create) a database with the correct Collation (`Latin1_General_CI_AS`, which hopefully is the collation of your database...)
1. Connects to the new OM Database
1. Creates Temporary Tables (`/CMS/App_Data/DBSeparation/temporary_tables.txt`) which the OM tables reference
1. Creates User Defined Table Types (`/CMS/App_Data/DBSeparation/copy_types.txt`)
1. Creates the OM tables (`/CMS/App_Data/DBSeparation/tables.txt` and `/CMS/App_Data/CMSInstall/SQL.zip/Objects/XXXX.xml`) in the database
1. Checks the existing CMS_Class on the OM Tables to add / update any fields that were customized by you and applies them to the om database tables
1. Adds Stored Procedures, Views, Functions (`/CMS/App_Data/DBSeparation/procedures_functions_views.txt`)
1. Strips Foreign Key constraints on the OM Tables from the Temporary Tables
1. Deletes the Temporary Tables
1. If possible (not on azure)...
    1. copies data over
    1. deletes the OM Tables from the main database (and related objects)
    1. If database supports linked servers, run `/CMS/App_Data/DBSeparation/linked_server.txt` with various `##VALUE##` replaced with the `Main` and `OM` database names


These scripts take the opposite approach.  Instead of creating the database, tables, and copying data it, it starts with a full database and removes the other items.

## Procedure

1. BACKUP YOUR MAIN DATABASE (Don't be that guy...)
1. Clone the main database (the clone will be the separated OM database), then on the cloned database...
1. Run `1-Remove-Procedures.sql`, if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/procedures_functions_views.txt`.
1. Run `2-Remove-View.sql`, if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/procedures_functions_views.txt`.
1. Run `3-Remove-OM-Foreign-Keys.sql`, if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/temporary_tables.txt`.
1. Run `4-Remove-Other-Foreign-Keys.sql`
1. Run `5-Remove-Tables.sql` (**multiple times till all tables gone**), if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/tables.txt`.
1. Run `6-Remove-Functions.sql`, if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/procedures_functions_views.txt`.
1. Run `7-Remove-Table-Types.sql`, if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/copy_types.txt`.

At this point, your copied OM database is ready to be pointed to.  These values will probably be done through CI/CD:

1. Add to your Admin solution the connection string `<add name="CMSOMConnectionString" connectionString="<the connection string to your OM database>"/>`
1. Add to your MVC Solution the connection string with the same name
    - .Net Core, in `appsettings.json`, under the `ConnectionStrings` object, add `"CMSOMConnectionString": "<the connection string to your OM database>"`
    - MVC 5 in your web.config's connection string add `<add name="CMSOMConnectionString" connectionString="<the connection string to your OM database>"/>`
1. Deploy your sites

### Minimize data loss

As noted, from the time you clone the database to the time you push up the `CMSOmConnectionString` connection string to your site/admin, any OM related data will be lost.

It is recommended that you prepare your CI/CD to deploy with the new connection strings, or possibly be ready to update and add the `CMSOmConnectionString` keys manually as soon as the procedure is complete.

## Clean up of Main Database

At this point, you can safetly clean up your main database.  It doesn't hurt anything to keep the OM tables in your main Database (although if you do, you should clear the data out), however it's recommended you remove them as any modifications to the table structures will only go to the separated database and may cause confusion.

1. Backup your MAIN Database (Don't be that guy...)
1. On the Main Database...
1. Run `Cleanup-1-Remove-OM-Tables.sql`, if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/tables.txt` **IN INVERSE ORDER**
1. Run `Cleanup-2-Remove-OM-Functions.sql`, if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/procedures_functions_views.txt` **IN INVERSE ORDER**
1. Run `Cleanup-3-Remove-OM-Views.sql`, if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/procedures_functions_views.txt` **IN INVERSE ORDER**
1. Run `Cleanup-4-Remove-OM-Stored-Procedures.sql`, if necessary updating the query with the contents of `/CMS/App_Data/DBSeparation/procedures_functions_views.txt` **IN INVERSE ORDER**

Your OM related tables are now removed from your main database.

## Optional Linking or Cross Query Setup

If your database supports Linked Servers and exists on the same server, and you wish to set up Linked Servers, you can run the `/CMS/App_Data/DBSeparation/linked_server.txt` on your **OM Separated Database**, replacing...

- `##BASESERVER##` with the server name of your main database
- `##BASEDATABASENAME##` with the database name of your main database
- `##BASEUSERNAME##` with the main database username
- `##BASEUSERPASS##` with the main database password

If you're on Azure and you want to utilize Elastic Queries (cross-database querying), see the bottom of [Kentico's documentation](https://docs.xperience.io/on-line-marketing-features/configuring-and-customizing-your-on-line-marketing-features/separating-the-contact-management-database) where it describes how to enable this feature.

## Final Notes

This was run on Kentico Xperience 13 hotfix 115, if the tables, foreign keys, or other related items are different in your hotfix of Kentico Xperience 13, please make sure to check the various `/CMS/App_Data/DBSeparation` text files and update the SQL files accordingly.

I am not responsible for any issues using this procedure may result in.  Please be sure to test this operation on a development copy of the site/database, and always be ready to roll back.
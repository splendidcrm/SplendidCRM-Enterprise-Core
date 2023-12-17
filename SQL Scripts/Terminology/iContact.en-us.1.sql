

print 'TERMINOLOGY iContact en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'iContact';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_ICONTACT_TITLE'                     , N'en-US', N'iContact', null, null, N'iContact &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_ICONTACT'                           , N'en-US', N'iContact', null, null, N'Configure iContact Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ICONTACT_SETTINGS'                         , N'en-US', N'iContact', null, null, N'iContact Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_API_APP_ID'                                , N'en-US', N'iContact', null, null, N'App ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_API_USERNAME'                              , N'en-US', N'iContact', null, null, N'API Username:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_API_PASSWORD'                              , N'en-US', N'iContact', null, null, N'API Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ICONTACT_ACCOUNT_ID'                       , N'en-US', N'iContact', null, null, N'iContact Account ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ICONTACT_CLIENT_FOLDER_ID'                 , N'en-US', N'iContact', null, null, N'iContact Client Folder ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ICONTACT_ENABLED'                          , N'en-US', N'iContact', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'iContact', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'iContact', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'iContact', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'iContact', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                              , N'en-US', N'iContact', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GET_ACCOUNT_BUTTON_LABEL'                  , N'en-US', N'iContact', null, null, N'Get Account';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'iContact', null, null, N'Connection successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT_RETRIEVED'                         , N'en-US', N'iContact', null, null, N'Account ID and Client Folder ID retrieved successfully.';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'iContact', null, null, N'iC';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ICONTACT'                                  , N'en-US', N'Import', null, null, N'iContact &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_ICONTACT_TITLE'                     , N'en-US', N'Import', null, null, N'You will first need to sign-in to iContact &reg; in order to connect and retrieve the contacts.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'iContact', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'iContact', null, null, N'<p>
In order to use iContact authentication or to allow the import of iContact contacts, 
you will need to create a iContact applicaton.  Once a iContact application has been created, 
you can provide the App ID, API Username and API Password below.</p>
<p>
For instructions on how to create a iContact application, please follow the 
<a href="http://www.icontact.com/developerportal/documentation/register-your-app/" target="_default">Instructions</a> on the iContact site. 
</p>
<p>Account ID and Client Folder ID be populated during the Get Account process.
</p>';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                , N'en-US', null, N'icontact_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                   , N'en-US', null, N'icontact_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                 , N'en-US', null, N'icontact_sync_direction'         ,   3, N'from crm only';

exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                         , N'en-US', null, N'icontact_sync_module'            ,   1, N'CRM Leads to iContact Contacts';
exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                      , N'en-US', null, N'icontact_sync_module'            ,   2, N'CRM Contacts to iContact Contacts';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'iContact'                                      , N'en-US', null, N'moduleList', 134, N'iContact';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ID'                                        , N'en-US', N'iContact', null, null, N'iContact ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREATEDATE'                                , N'en-US', N'iContact', null, null, N'Create Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LASTMODIFIEDDATE'                          , N'en-US', N'iContact', null, null, N'Last Modified Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL'                                     , N'en-US', N'iContact', null, null, N'Email:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PREFIX'                                    , N'en-US', N'iContact', null, null, N'Prefix:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRSTNAME'                                 , N'en-US', N'iContact', null, null, N'First Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LASTNAME'                                  , N'en-US', N'iContact', null, null, N'Last Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUFFIX'                                    , N'en-US', N'iContact', null, null, N'Suffix:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS'                                   , N'en-US', N'iContact', null, null, N'Street Address';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CITY'                                      , N'en-US', N'iContact', null, null, N'City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATE'                                     , N'en-US', N'iContact', null, null, N'State or Province:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ZIP'                                       , N'en-US', N'iContact', null, null, N'Zip:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRY'                                   , N'en-US', N'iContact', null, null, N'Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUSINESS'                                  , N'en-US', N'iContact', null, null, N'Business Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE'                                     , N'en-US', N'iContact', null, null, N'Phone Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FAX'                                       , N'en-US', N'iContact', null, null, N'Fax:';
GO

set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_iContact_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_iContact_en_us')
/
-- #endif IBM_DB2 */

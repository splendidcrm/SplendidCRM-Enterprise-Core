

print 'TERMINOLOGY ConstantContact en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'ConstantContact';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_CONSTANTCONTACT_TITLE'              , N'en-US', N'ConstantContact', null, null, N'ConstantContact &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_CONSTANTCONTACT'                    , N'en-US', N'ConstantContact', null, null, N'Configure ConstantContact Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONSTANTCONTACT_SETTINGS'                  , N'en-US', N'ConstantContact', null, null, N'ConstantContact Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                           , N'en-US', N'ConstantContact', null, null, N'ConstantContact Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                       , N'en-US', N'ConstantContact', null, null, N'ConstantContact Secret:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                        , N'en-US', N'ConstantContact', null, null, N'ConstantContact Access Token:';
-- 11/11/2019 Paul.  ConstantContact v3 API. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_REFRESH_TOKEN'                       , N'en-US', N'ConstantContact', null, null, N'ConstantContact Refresh Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONSTANTCONTACT_ENABLED'                   , N'en-US', N'ConstantContact', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'ConstantContact', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'ConstantContact', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'ConstantContact', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'ConstantContact', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                              , N'en-US', N'ConstantContact', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                    , N'en-US', N'ConstantContact', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFRESH_TOKEN_LABEL'                       , N'en-US', N'ConstantContact', null, null, N'Refresh Token';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'ConstantContact', null, null, N'Test successful.';
-- 11/10/2019 Paul.  Missing LBL_CONNECTION_SUCCESSFUL. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONNECTION_SUCCESSFUL'                     , N'en-US', N'ConstantContact', null, null, N'Connection successful';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONSTANTCONTACT'                           , N'en-US', N'Import', null, null, N'ConstantContact &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_CONSTANTCONTACT_TITLE'              , N'en-US', N'Import', null, null, N'You will first need to sign-in to ConstantContact &reg; in order to connect and retrieve the contacts.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'ConstantContact', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'ConstantContact', null, null, N'<p>
In order to use ConstantContact authentication, 
you will need to create a ConstantContact applicaton.  Once a ConstantContact application has been created, 
you can provide the PortalID, ClientID and the Secret key below.</p>
<p>
For instructions on how to create a ConstantContact application, please follow the 
<a href="http://developer.constantcontact.com/docs/developer-guides/api-documentation-index.html" target="_default">Instructions</a> on the ConstantContact site. 
</p>
<p>Access Token, Refresh Token and Token Expires will all be populated during the Authorize process.
</p>';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'ConstantContact', null, null, N'CoC';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                , N'en-US', null, N'constantcontact_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                   , N'en-US', null, N'constantcontact_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                 , N'en-US', null, N'constantcontact_sync_direction'         ,   3, N'from crm only';

exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                         , N'en-US', null, N'constantcontact_sync_module'            ,   1, N'CRM Leads to ConstantContact Contacts';
exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                      , N'en-US', null, N'constantcontact_sync_module'            ,   2, N'CRM Contacts/Accounts to ConstantContact Contacts/Companies';

-- 08/17/2016 Paul.  Add sync of prospect lists. 
exec dbo.spTERMINOLOGY_InsertOnly N'ConstantContact'                               , N'en-US', null, N'prospect_list_type_dom'                 ,   8, N'ConstantContact';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'ConstantContact'                               , N'en-US', null, N'moduleList', 135, N'ConstantContact';
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

call dbo.spTERMINOLOGY_ConstantContact_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_ConstantContact_en_us')
/
-- #endif IBM_DB2 */

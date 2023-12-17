

print 'TERMINOLOGY PhoneBurner en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'PhoneBurner';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CATEGORY'                                  , N'en-US', N'PhoneBurner', null, null, N'Category:'

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_PHONEBURNER_TITLE'                  , N'en-US', N'PhoneBurner', null, null, N'PhoneBurner &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_PHONEBURNER'                        , N'en-US', N'PhoneBurner', null, null, N'Configure PhoneBurner Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONEBURNER_SETTINGS'                      , N'en-US', N'PhoneBurner', null, null, N'PhoneBurner Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_PORTAL_ID'                           , N'en-US', N'PhoneBurner', null, null, N'PhoneBurner PortalID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                           , N'en-US', N'PhoneBurner', null, null, N'PhoneBurner ClientID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                       , N'en-US', N'PhoneBurner', null, null, N'PhoneBurner Secret Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                        , N'en-US', N'PhoneBurner', null, null, N'PhoneBurner Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_REFRESH_TOKEN'                       , N'en-US', N'PhoneBurner', null, null, N'PhoneBurner Refresh Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_EXPIRES_AT'                          , N'en-US', N'PhoneBurner', null, null, N'Access Token Expires:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONEBURNER_ENABLED'                       , N'en-US', N'PhoneBurner', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'PhoneBurner', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'PhoneBurner', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'PhoneBurner', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'PhoneBurner', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                              , N'en-US', N'PhoneBurner', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                    , N'en-US', N'PhoneBurner', null, null, N'Authorize PhoneBurner';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_AUTHORIZATION_EXPIRED'                     , N'en-US', N'PhoneBurner', null, null, N'Authorization Expired';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFRESH_TOKEN_LABEL'                       , N'en-US', N'PhoneBurner', null, null, N'Refresh Token';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'PhoneBurner', null, null, N'Connection successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'PhoneBurner', null, null, N'Pb';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BEGIN_DIAL_SESSION'                        , N'en-US', N'PhoneBurner', null, null, N'Begin Dial Session';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'PhoneBurner', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'PhoneBurner', null, null, N'<p>
In order to use PhoneBurner authentication or to allow the import of PhoneBurner contacts, 
you will need to create a PhoneBurner applicaton.  Once a PhoneBurner application has been created, 
you can provide the ClientID and the Secret key below.</p>
<p>
For instructions on how to create a PhoneBurner application, please follow the 
<a href="https://www.phoneburner.com/settings/developer/applications/" target="_default">Instructions</a> on the PhoneBurner site. 
</p>
<p>Access Token, Refresh Token and Token Expires will all be populated during the Authorize process.
</p>';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                , N'en-US', null, N'phoneburner_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                   , N'en-US', null, N'phoneburner_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                 , N'en-US', null, N'phoneburner_sync_direction'         ,   3, N'from crm only';

exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                         , N'en-US', null, N'phoneburner_sync_module'            ,   1, N'CRM Leads to PhoneBurner Contacts';
exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                      , N'en-US', null, N'phoneburner_sync_module'            ,   2, N'CRM Contacts/Accounts to PhoneBurner Contacts/Companies';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'PhoneBurner'                                       , N'en-US', null, N'moduleList', 161, N'PhoneBurner';
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

call dbo.spTERMINOLOGY_PhoneBurner_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_PhoneBurner_en_us')
/
-- #endif IBM_DB2 */

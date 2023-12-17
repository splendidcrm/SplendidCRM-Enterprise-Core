

print 'TERMINOLOGY Etsy en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'Etsy';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_ETSY_TITLE'                         , N'en-US', N'Etsy', null, null, N'Etsy &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_ETSY'                               , N'en-US', N'Etsy', null, null, N'Configure Etsy Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ETSY_SETTINGS'                             , N'en-US', N'Etsy', null, null, N'Etsy Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ETSY_SHOP_NAME'                            , N'en-US', N'Etsy', null, null, N'Etsy Shop Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ETSY_SHOP_ID'                              , N'en-US', N'Etsy', null, null, N'Etsy Shop ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                           , N'en-US', N'Etsy', null, null, N'OAuth Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                       , N'en-US', N'Etsy', null, null, N'OAuth Secret:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                        , N'en-US', N'Etsy', null, null, N'OAuth Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_REFRESH_TOKEN'                       , N'en-US', N'Etsy', null, null, N'OAuth Refresh Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ETSY_ENABLED'                              , N'en-US', N'Etsy', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'Etsy', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'Etsy', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'Etsy', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'Etsy', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                    , N'en-US', N'Etsy', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'Etsy', null, null, N'Test successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONNECTION_SUCCESSFUL'                     , N'en-US', N'Etsy', null, null, N'Connection successful';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ETSY'                                      , N'en-US', N'Import', null, null, N'Etsy &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_ETSY_TITLE'                         , N'en-US', N'Import', null, null, N'You will first need to sign-in to Etsy &reg; in order to connect and retrieve the contacts.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'Etsy', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'Etsy', null, null, N'<p>
In order to use Etsy authentication, 
you will need to create a Etsy applicaton.  Once a Etsy application has been created, 
you can provide the Etsy Key and the Secret key below.</p>
<p>
For instructions on how to create a Etsy application, please follow the 
<a href="https://www.etsy.com/developers/documentation/getting_started/api_basics" target="_default">Instructions</a> on the Etsy site. 
</p>
<p>Access Token, Refresh Token and Token Expires will all be populated during the Authorize process.
</p>';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                         , N'en-US', N'Etsy', null, null, N'Ets';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                  , N'en-US', null, N'Etsy_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                     , N'en-US', null, N'Etsy_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                   , N'en-US', null, N'Etsy_sync_direction'         ,   3, N'from crm only';

--exec dbo.spTERMINOLOGY_InsertOnly N'remote'                                        , N'en-US', null, N'sync_conflict_resolution'       ,   1, N'remote';
--exec dbo.spTERMINOLOGY_InsertOnly N'local'                                         , N'en-US', null, N'sync_conflict_resolution'       ,   2, N'local';

exec dbo.spTERMINOLOGY_InsertOnly N'Etsy'                                            , N'en-US', null, N'prospect_list_type_dom'         ,  11, N'Etsy';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'Etsy'                                            , N'en-US', null, N'moduleList'                     , 178, N'Etsy';
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

call dbo.spTERMINOLOGY_Etsy_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Etsy_en_us')
/
-- #endif IBM_DB2 */



print 'TERMINOLOGY Shopify en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'Shopify';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_SHOPIFY_TITLE'                      , N'en-US', N'Shopify', null, null, N'Shopify &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_SHOPIFY'                            , N'en-US', N'Shopify', null, null, N'Configure Shopify Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHOPIFY_SETTINGS'                          , N'en-US', N'Shopify', null, null, N'Shopify Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHOP_NAME'                                 , N'en-US', N'Shopify', null, null, N'Shop Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                           , N'en-US', N'Shopify', null, null, N'OAuth Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                       , N'en-US', N'Shopify', null, null, N'OAuth Secret:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                        , N'en-US', N'Shopify', null, null, N'OAuth Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHOPIFY_ENABLED'                           , N'en-US', N'Shopify', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'Shopify', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'Shopify', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'Shopify', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'Shopify', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                    , N'en-US', N'Shopify', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'Shopify', null, null, N'Test successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONNECTION_SUCCESSFUL'                     , N'en-US', N'Shopify', null, null, N'Connection successful';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHOPIFY'                                   , N'en-US', N'Import', null, null, N'Shopify &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_SHOPIFY_TITLE'                      , N'en-US', N'Import', null, null, N'You will first need to sign-in to Shopify &reg; in order to connect and retrieve the contacts.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'Shopify', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'Shopify', null, null, N'<p>
In order to use Shopify authentication, 
you will need to create a Shopify applicaton.  Once a Shopify application has been created, 
you can provide the Shopify Key and the Secret key below.</p>
<p>
For instructions on how to create a Shopify application, please follow the 
<a href="https://shopify.dev/apps/getting-started" target="_default">Instructions</a> on the Shopify site. 
</p>
<p>Access Token, Refresh Token and Token Expires will all be populated during the Authorize process.
</p>';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Shopify', null, null, N'Shp';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                , N'en-US', null, N'shopify_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                   , N'en-US', null, N'shopify_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                 , N'en-US', null, N'shopify_sync_direction'         ,   3, N'from crm only';

--exec dbo.spTERMINOLOGY_InsertOnly N'remote'                                        , N'en-US', null, N'sync_conflict_resolution'       ,   1, N'remote';
--exec dbo.spTERMINOLOGY_InsertOnly N'local'                                         , N'en-US', null, N'sync_conflict_resolution'       ,   2, N'local';

exec dbo.spTERMINOLOGY_InsertOnly N'Shopify'                                       , N'en-US', null, N'prospect_list_type_dom'         ,  10, N'Shopify';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'Shopify'                                       , N'en-US', null, N'moduleList'                     , 177, N'Shopify';
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

call dbo.spTERMINOLOGY_Shopify_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Shopify_en_us')
/
-- #endif IBM_DB2 */

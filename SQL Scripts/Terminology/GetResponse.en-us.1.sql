

print 'TERMINOLOGY GetResponse en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'GetResponse';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_GETRESPONSE_TITLE'                  , N'en-US', N'GetResponse', null, null, N'GetResponse &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_GETRESPONSE'                        , N'en-US', N'GetResponse', null, null, N'Configure GetResponse Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GETRESPONSE_SETTINGS'                      , N'en-US', N'GetResponse', null, null, N'GetResponse Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SECRET_API_KEY'                            , N'en-US', N'GetResponse', null, null, N'Secret API Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GETRESPONSE_ENABLED'                       , N'en-US', N'GetResponse', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'GetResponse', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'GetResponse', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'GetResponse', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'GetResponse', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                              , N'en-US', N'GetResponse', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'GetResponse', null, null, N'Connection successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'GetResponse', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'GetResponse', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CAMPAIGNS'                                 , N'en-US', N'GetResponse', null, null, N'Campaigns';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DEFAULT_CAMPAIGN_NAME'                     , N'en-US', N'GetResponse', null, null, N'Default Campaign:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'GetResponse', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'GetResponse', null, null, N'<p>
In order to use GetResponse authentication or to allow the import of GetResponse contacts, 
you will need to get the secret API key from the GetReponse Account Details area.
</p>';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'GetResponse', null, null, N'GR';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                , N'en-US', null, N'getresponse_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                   , N'en-US', null, N'getresponse_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                 , N'en-US', null, N'getresponse_sync_direction'         ,   3, N'from crm only';

exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                         , N'en-US', null, N'getresponse_sync_module'            ,   1, N'CRM Leads to GetResponse Contacts';
exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                      , N'en-US', null, N'getresponse_sync_module'            ,   2, N'CRM Contacts to GetResponse Contacts';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'GetResponse'                                      , N'en-US', null, N'moduleList', 136, N'GetResponse';
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

call dbo.spTERMINOLOGY_GetResponse_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_GetResponse_en_us')
/
-- #endif IBM_DB2 */

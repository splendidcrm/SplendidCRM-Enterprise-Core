

print 'TERMINOLOGY Watson en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'Watson';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_WATSON_TITLE'                           , N'en-US', N'Watson', null, null, N'Watson Campaign Automation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_WATSON'                                 , N'en-US', N'Watson', null, null, N'Configure Watson Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                           , N'en-US', N'Watson', null, null, N'IBM';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WATSON_SETTINGS'                               , N'en-US', N'Watson', null, null, N'Watson Settings';
-- 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
-- https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_REGION'                                  , N'en-US', N'Watson', null, null, N'Watson Region:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_POD_NUMBER'                              , N'en-US', N'Watson', null, null, N'Watson Pod Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                               , N'en-US', N'Watson', null, null, N'Watson Client ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                           , N'en-US', N'Watson', null, null, N'Watson Secret Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                            , N'en-US', N'Watson', null, null, N'Watson Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_REFRESH_TOKEN'                           , N'en-US', N'Watson', null, null, N'Watson Refresh Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_EXPIRES_AT'                              , N'en-US', N'Watson', null, null, N'Access Token Expires:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WATSON_ENABLED'                                , N'en-US', N'Watson', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                                , N'en-US', N'Watson', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                     , N'en-US', N'Watson', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                           , N'en-US', N'Watson', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                               , N'en-US', N'Watson', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                                  , N'en-US', N'Watson', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MERGE_FIELDS'                                  , N'en-US', N'Watson', null, null, N'Merge Fields:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                        , N'en-US', N'Watson', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFRESH_BUTTON_LABEL'                          , N'en-US', N'Watson', null, null, N'Refresh Token';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                               , N'en-US', N'Watson', null, null, N'Test successful.';
-- 11/10/2019 Paul.  Missing LBL_CONNECTION_SUCCESSFUL. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONNECTION_SUCCESSFUL'                         , N'en-US', N'Watson', null, null, N'Connection successful';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                          , N'en-US', N'Watson', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                     , N'en-US', N'Watson', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TYPE'                                          , N'en-US', N'Watson', null, null, N'Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TYPE'                                     , N'en-US', N'Watson', null, null, N'Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SIZE'                                          , N'en-US', N'Watson', null, null, N'Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SIZE'                                     , N'en-US', N'Watson', null, null, N'Size';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VISIBILITY'                                    , N'en-US', N'Watson', null, null, N'Visibility:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_VISIBILITY'                               , N'en-US', N'Watson', null, null, N'Visibility';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATABASES'                                     , N'en-US', N'Watson', null, null, N'Databases';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DEFAULT_DATABASE'                              , N'en-US', N'Watson', null, null, N'Default Database:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_INFORMATION'                              , N'en-US', N'Watson', null, null, N'List Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NUM_OPT_OUTS'                                  , N'en-US', N'Watson', null, null, N'Number of contacts opted-out:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NUM_UNDELIVERABLE'                             , N'en-US', N'Watson', null, null, N'Number of undeliverable contacts:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_DATABASE_ID'                            , N'en-US', N'Watson', null, null, N'Parent Database ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_NAME'                                   , N'en-US', N'Watson', null, null, N'Name of the associated parent:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORGANIZATION_ID'                               , N'en-US', N'Watson', null, null, N'Organization ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_ID'                                       , N'en-US', N'Watson', null, null, N'User ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_FOLDER_ID'                              , N'en-US', N'Watson', null, null, N'Folder ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_FOLDER'                                     , N'en-US', N'Watson', null, null, N'Entity is a folder:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FLAGGED_FOR_BACKUP'                            , N'en-US', N'Watson', null, null, N'Flagged to be exported:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUPPRESSION_LIST_ID'                           , N'en-US', N'Watson', null, null, N'Suppression List ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPT_IN_FORM_DEFINED'                           , N'en-US', N'Watson', null, null, N'Opt-In form exists:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPT_OUT_FORM_DEFINED'                          , N'en-US', N'Watson', null, null, N'Opt-Out form exists:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROFILE_FORM_DEFINED'                          , N'en-US', N'Watson', null, null, N'Profile form exists:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPT_IN_AUTOREPLY_DEFINED'                      , N'en-US', N'Watson', null, null, N'Opt-In Auto-reply exists:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROFILE_AUTOREPLY_DEFINED'                     , N'en-US', N'Watson', null, null, N'Edit Profile Auto-reply exists:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPTED_IN_DATE'                                 , N'en-US', N'Watson', null, null, N'Opted In:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPTED_OUT_DATE'                                , N'en-US', N'Watson', null, null, N'Opted Out:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WATSON'                                        , N'en-US', N'Import', null, null, N'Watson &reg; Campaign Automation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_WATSON_TITLE'                           , N'en-US', N'Import', null, null, N'You will first need to sign-in to Watson &reg; in order to connect and retrieve the contacts.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                                  , N'en-US', N'Watson', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                              , N'en-US', N'Watson', null, null, N'<p>
In order to use Watson authentication or to allow the import of Watson contacts, 
you will need to create a Watson applicaton.  Once a Watson application has been created, 
you can provide the ClientID and the Secret key below.  Make sure to specify the following landing page:<br />
~/Administration/Watson/OAuthLanding.aspx
</p>
';
GO

-- 02/01/2018 Paul.  Watson does not support bi-directional. 
--exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                    , N'en-US', null, N'watson_sync_direction'         ,   1, N'bi-directional';
--exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                       , N'en-US', null, N'watson_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                     , N'en-US', null, N'watson_sync_direction'         ,   3, N'from crm only';

exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                             , N'en-US', null, N'watson_sync_module'            ,   1, N'Leads';
exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                          , N'en-US', null, N'watson_sync_module'            ,   2, N'Contacts';
exec dbo.spTERMINOLOGY_InsertOnly N'Prospects'                                         , N'en-US', null, N'watson_sync_module'            ,   3, N'Targets';

exec dbo.spTERMINOLOGY_InsertOnly N'0'                                                 , N'en-US', null, N'watson_visibility'             ,   1, N'Private';
exec dbo.spTERMINOLOGY_InsertOnly N'1'                                                 , N'en-US', null, N'watson_visibility'             ,   2, N'Shared';

exec dbo.spTERMINOLOGY_InsertOnly N'0'                                                 , N'en-US', null, N'watson_list_type'              ,   2, N'Databases';
exec dbo.spTERMINOLOGY_InsertOnly N'1'                                                 , N'en-US', null, N'watson_list_type'              ,   2, N'Queries';
exec dbo.spTERMINOLOGY_InsertOnly N'2'                                                 , N'en-US', null, N'watson_list_type'              ,   2, N'Databases, Contact Lists and Queries';
exec dbo.spTERMINOLOGY_InsertOnly N'5'                                                 , N'en-US', null, N'watson_list_type'              ,   2, N'Test Lists';
exec dbo.spTERMINOLOGY_InsertOnly N'6'                                                 , N'en-US', null, N'watson_list_type'              ,   2, N'Seed Lists';
exec dbo.spTERMINOLOGY_InsertOnly N'13'                                                , N'en-US', null, N'watson_list_type'              ,   2, N'Suppression Lists';
exec dbo.spTERMINOLOGY_InsertOnly N'15'                                                , N'en-US', null, N'watson_list_type'              ,   2, N'Relational Tables';
exec dbo.spTERMINOLOGY_InsertOnly N'18'                                                , N'en-US', null, N'watson_list_type'              ,   2, N'Contact Lists';


-- select * from vwTERMINOLOGY where LIST_NAME = 'prospect_list_type_dom' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'Watson'                                            , N'en-US', null, N'prospect_list_type_dom'        ,   9, N'Watson';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'Watson'                                            , N'en-US', null, N'moduleList', 172, N'Watson';
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

call dbo.spTERMINOLOGY_Watson_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Watson_en_us')
/
-- #endif IBM_DB2 */

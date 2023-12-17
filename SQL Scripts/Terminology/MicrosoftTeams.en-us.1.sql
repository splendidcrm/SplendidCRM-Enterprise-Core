

print 'TERMINOLOGY MicrosoftTeams en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'MicrosoftTeams';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_MICROSOFTTEAMS_TITLE'               , N'en-US', N'MicrosoftTeams', null, null, N'Microsoft Teams &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_MICROSOFTTEAMS'                     , N'en-US', N'MicrosoftTeams', null, null, N'Configure Microsoft Teams Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MICROSOFTTEAMS_SETTINGS'                   , N'en-US', N'MicrosoftTeams', null, null, N'Microsoft Teams Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                           , N'en-US', N'MicrosoftTeams', null, null, N'Microsoft Teams ClientID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                       , N'en-US', N'MicrosoftTeams', null, null, N'Microsoft Teams Secret Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_DIRECTORY_TENANT_ID'                 , N'en-US', N'MicrosoftTeams', null, null, N'Directory Tenant ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                        , N'en-US', N'MicrosoftTeams', null, null, N'Microsoft Teams Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_REFRESH_TOKEN'                       , N'en-US', N'MicrosoftTeams', null, null, N'Microsoft Teams Refresh Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_EXPIRES_AT'                          , N'en-US', N'MicrosoftTeams', null, null, N'Access Token Expires:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MICROSOFTTEAMS_ENABLED'                    , N'en-US', N'MicrosoftTeams', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'MicrosoftTeams', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'MicrosoftTeams', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'MicrosoftTeams', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'MicrosoftTeams', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                              , N'en-US', N'MicrosoftTeams', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                    , N'en-US', N'MicrosoftTeams', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFRESH_TOKEN_LABEL'                       , N'en-US', N'MicrosoftTeams', null, null, N'Refresh Token';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'MicrosoftTeams', null, null, N'Connection successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEAMS'                                     , N'en-US', N'MicrosoftTeams', null, null, N'Teams';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CHANNELS'                                  , N'en-US', N'MicrosoftTeams', null, null, N'Channels';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CHATS'                                     , N'en-US', N'MicrosoftTeams', null, null, N'Chats';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ID'                                   , N'en-US', N'MicrosoftTeams', null, null, N'Id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'MicrosoftTeams', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'MicrosoftTeams', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MEMBERSHIP_TYPE'                      , N'en-US', N'MicrosoftTeams', null, null, N'Membership Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CREATED_DATE'                         , N'en-US', N'MicrosoftTeams', null, null, N'Created Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TEAM_NAME'                            , N'en-US', N'MicrosoftTeams', null, null, N'Team Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CHAT_TYPE'                            , N'en-US', N'MicrosoftTeams', null, null, N'Chart Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_UPDATED_DATE'                    , N'en-US', N'MicrosoftTeams', null, null, N'Last Updated Date';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'MicrosoftTeams', null, null, N'Hub';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MICROSOFTTEAMS'                            , N'en-US', N'Import', null, null, N'Microsoft Teams &reg;';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'MicrosoftTeams', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'MicrosoftTeams', null, null, N'<p>
In order to use Microsoft Teams authentication, 
you will need to create a Microsoft Azure Applicaton.  Once a Microsoft Azure Application has been created, 
you can provide the ClientID and the Secret key below.</p>
<p>
For instructions on how to create a Microsoft Azure Application, please follow the 
<a href="https://learn.microsoft.com/en-us/azure/healthcare-apis/register-application" target="_default">Instructions</a> on the Microsoft Azure site. 
</p>
<p>Access Token, Refresh Token and Token Expires will all be populated during the Authorize process.
</p>';
GO

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'MicrosoftTeams'                                       , N'en-US', null, N'moduleList', 179, N'MicrosoftTeams';
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

call dbo.spTERMINOLOGY_MicrosoftTeams_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_MicrosoftTeams_en_us')
/
-- #endif IBM_DB2 */

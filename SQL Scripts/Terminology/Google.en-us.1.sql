

print 'TERMINOLOGY Google en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'Google';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_GOOGLE_TITLE'                       , N'en-US', N'Google', null, null, N'Google Apps';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_GOOGLE'                             , N'en-US', N'Google', null, null, N'Manage Google Apps';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GOOGLE_APPS_ENABLED'                       , N'en-US', N'Google', null, null, N'Enable Google Apps:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_API_KEY'                             , N'en-US', N'Google', null, null, N'Google API Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                           , N'en-US', N'Google', null, null, N'Google Client ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                       , N'en-US', N'Google', null, null, N'Google Secret Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                        , N'en-US', N'Google', null, null, N'Google Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_REFRESH_TOKEN'                       , N'en-US', N'Google', null, null, N'Google Refresh Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_EXPIRES_AT'                          , N'en-US', N'Google', null, null, N'Access Token Expires:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_EXPIRES_IN'                          , N'en-US', N'Google', null, null, N'Access Token Expires In:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'Google', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                    , N'en-US', N'Google', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFRESH_TOKEN_LABEL'                       , N'en-US', N'Google', null, null, N'Refresh Token';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SMTP_SETTINGS'                        , N'en-US', N'Google', null, null, N'Test SMTP Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'Google', null, null, N'Connection successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_FAILED'                               , N'en-US', N'Google', null, null, N'Connection failed.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PUSH_NOTIFICATION_URL'                     , N'en-US', N'Google', null, null, N'Push Notification URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PUSH_NOTIFICATIONS'                        , N'en-US', N'Google', null, null, N'Enable Push Notifications:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_GROUPS'                               , N'en-US', N'Google', null, null, N'Groups';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_INSTRUCTIONS'                        , N'en-US', N'Google', null, null, N'<p>
In order to use Google authentication or to allow the import of Google contacts, 
you will need to create a Google applicaton.  Once a Google application has been created, you can provide the OAUTH keys below.</p>
<p>
For instructions on how to create a Google application, please use the 
<a href="https://console.developers.google.com/project/_/apiui/credential" target="_default">Google Developers Console</a>. 
</p>
<p>
You will need to create a project, create an API key, create an OAuth 2.0 client ID for a Web application and enable APIs for 
Calendar API, Gmail API, Contacts API and Google Maps JavaScript API. 
</p>
';

-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Google', null, null, N'Ggl';
GO

-- 08/02/2012 Paul.  Fix existing list name that previously pointed to Google. 
if exists(select * from vwTERMINOLOGY where NAME = N'OrdersLineItems' and LANG = 'en-US' and LIST_NAME = N'moduleList' and DISPLAY_NAME = N'Google') begin -- then
	print 'Fix existing list name that previously pointed to Google. ';
	update TERMINOLOGY
	   set DISPLAY_NAME      = N'Orders Line Items'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where NAME              = N'OrdersLineItems'
	   and LANG              = N'en-US'
	   and LIST_NAME         = N'moduleList'
	   and DISPLAY_NAME      = N'Google';
end -- if;

exec dbo.spTERMINOLOGY_InsertOnly N'Google'                               , N'en-US', null, N'moduleList',  99, N'Google';

GO

set nocount off;
GO

/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_Google_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Google_en_us')
/
-- #endif IBM_DB2 */



print 'TERMINOLOGY DuoUniversal en-us';
GO

set nocount on;
GO

-- 08/07/2025 Paul.  Add DuoUniversal. 
-- delete from TERMINOLOGY where MODULE_NAME = 'DuoUniversal';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_DUO_UNIVERSAL_TITLE'                , N'en-US', N'DuoUniversal', null, null, N'Duo 2-Factor Authentication';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_DUO_UNIVERSAL'                      , N'en-US', N'DuoUniversal', null, null, N'Manage Duo 2-Factor Authentication';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DUO_UNIVERSAL_SETTINGS'                    , N'en-US', N'DuoUniversal', null, null, N'DuoUniversal Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DUO_UNIVERSAL_ENABLED'                     , N'en-US', N'DuoUniversal', null, null, N'Enable Duo Universal:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'DuoUniversal', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CLIENT_ID'                                 , N'en-US', N'DuoUniversal', null, null, N'DuoUniversal Client ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CLIENT_SECRET'                             , N'en-US', N'DuoUniversal', null, null, N'DuoUniversal Secret Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_API_HOST_URL'                              , N'en-US', N'DuoUniversal', null, null, N'DuoUniversal API Host URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REDIRECT_URL'                              , N'en-US', N'DuoUniversal', null, null, N'Redirect URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'DuoUniversal', null, null, N'Connection successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_FAILED'                               , N'en-US', N'DuoUniversal', null, null, N'Connection failed.';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_LOGIN_SESSION_HAS_EXPIRED'                 , N'en-US', N'DuoUniversal', null, null, N'Login session has expired.';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_INVALID_SESSION_STATE'                     , N'en-US', N'DuoUniversal', null, null, N'Session state did not match the expected state.';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_LOGIN_DENIED'                              , N'en-US', N'DuoUniversal', null, null, N'Login denied.';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_NOT_CONFIGURED'                            , N'en-US', N'DuoUniversal', null, null, N'DuoUniversal is enabled but not configured.';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_FAILED_HEALTH_CHECK'                       , N'en-US', N'DuoUniversal', null, null, N'DuoUniversal failed health check.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'DuoUniversal', null, null, N'<p>
In order to use DuoUniversal 2-factor authentication, you will need to create a DuoUniversal applicaton
<a href="https://duo.com/docs/getting-started" target="_default">Getting Started with Duo</a>. 
</p>
<p>
You will need to create a Web SDK application, get the Client ID, Client Secret and API Host URL. 
</p>
';

-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'DuoUniversal', null, null, N'Duo';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'DuoUniversal'                                  , N'en-US', null, N'moduleList',  179, N'DuoUniversal';

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

call dbo.spTERMINOLOGY_DuoUniversal_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_DuoUniversal_en_us')
/
-- #endif IBM_DB2 */

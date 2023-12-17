

-- Terminology generated from database [SplendidCRM6_50] on 11/18/2010 11:26:05 PM.
print 'TERMINOLOGY SystemSyncLog en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERROR_TYPE'                                , N'en-US', N'SystemSyncLog', null, null, N'Error Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FILE_NAME'                                 , N'en-US', N'SystemSyncLog', null, null, N'File Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINE_NUMBER'                               , N'en-US', N'SystemSyncLog', null, null, N'Line Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ERROR_TYPE'                           , N'en-US', N'SystemSyncLog', null, null, N'Error Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FILE_NAME'                            , N'en-US', N'SystemSyncLog', null, null, N'File Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LINE_NUMBER'                          , N'en-US', N'SystemSyncLog', null, null, N'Line Number';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MACHINE'                              , N'en-US', N'SystemSyncLog', null, null, N'Machine';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MESSAGE'                              , N'en-US', N'SystemSyncLog', null, null, N'Message';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_METHOD'                               , N'en-US', N'SystemSyncLog', null, null, N'Method';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_REMOTE_URL'                           , N'en-US', N'SystemSyncLog', null, null, N'Remote URL';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_USER_ID'                              , N'en-US', N'SystemSyncLog', null, null, N'User ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MACHINE'                                   , N'en-US', N'SystemSyncLog', null, null, N'Machine:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MESSAGE'                                   , N'en-US', N'SystemSyncLog', null, null, N'Message:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_METHOD'                                    , N'en-US', N'SystemSyncLog', null, null, N'Method:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REMOTE_URL'                                , N'en-US', N'SystemSyncLog', null, null, N'Remote URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_ID'                                   , N'en-US', N'SystemSyncLog', null, null, N'User ID:';
-- 01/30/2014 Paul.  Correct the page title. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYSTEM_SYNC_LOG_TITLE'                     , N'en-US', N'SystemSyncLog', null, null, N'System Sync Log';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'SystemSyncLog', null, null, N'SSL';
-- 10/30/2020 Paul.  The React Client requires LBL_LIST_FORM_TITLE. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'SystemSyncLog', null, null, N'System Sync Log';

GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
-- 03/02/2019 Paul.  Missing term. 
exec dbo.spTERMINOLOGY_InsertOnly N'SystemSyncLog'                                 , N'en-US', null, N'moduleList'                        , 100, N'System Sync Log';

exec dbo.spTERMINOLOGY_InsertOnly N'Warning'                                       , N'en-US', null, N'system_log_type_dom'               ,   1, N'Warning';
exec dbo.spTERMINOLOGY_InsertOnly N'Error'                                         , N'en-US', null, N'system_log_type_dom'               ,   2, N'Error';
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

call dbo.spTERMINOLOGY_SystemSyncLog_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_SystemSyncLog_en_us')
/
-- #endif IBM_DB2 */

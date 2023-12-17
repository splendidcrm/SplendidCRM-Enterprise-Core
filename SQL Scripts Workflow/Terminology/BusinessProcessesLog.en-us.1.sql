

print 'TERMINOLOGY BusinessProcessesLog en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'BusinessProcessesLog';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_INSTANCE_ID'                          , N'en-US', N'BusinessProcessesLog', null, null, N'Instance ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EVENT_TIME'                           , N'en-US', N'BusinessProcessesLog', null, null, N'Event Time';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EVENT_TYPE'                           , N'en-US', N'BusinessProcessesLog', null, null, N'Event Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_RECORD_NUMBER'                        , N'en-US', N'BusinessProcessesLog', null, null, N'Record Number';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATE'                                , N'en-US', N'BusinessProcessesLog', null, null, N'State';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ACTIVITY'                             , N'en-US', N'BusinessProcessesLog', null, null, N'Activity';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ACTIVITY_NAME'                        , N'en-US', N'BusinessProcessesLog', null, null, N'Activity Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'BusinessProcessesLog', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_VIEW_RECORD'                               , N'en-US', N'BusinessProcessesLog', null, null, N'View Record';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_VIEW_LOG'                                  , N'en-US', N'BusinessProcessesLog', null, null, N'View Log';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'BusinessProcessesLog', null, null, N'Business Process Log';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'BusinessProcessesLog', null, null, N'BPl';

exec dbo.spTERMINOLOGY_InsertOnly N'BusinessProcessesLog'                          , N'en-US', null, N'moduleList'                        , 164, N'Business Processes Log';
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

call dbo.spTERMINOLOGY_BusinessProcessesLog_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_BusinessProcessesLog_en_us')
/
-- #endif IBM_DB2 */



-- Terminology generated from database [SplendidCRM6_50] on 11/18/2010 11:38:02 PM.
print 'TERMINOLOGY WorkflowEventLog en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AUDIT_ID'                             , N'en-US', N'WorkflowEventLog', null, null, N'Audit ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BASE_MODULE'                          , N'en-US', N'WorkflowEventLog', null, null, N'Base Module';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'WorkflowEventLog', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EVENT_ARG_TYPE_FULL_NAME'             , N'en-US', N'WorkflowEventLog', null, null, N'Event Arg Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EVENT_DATE_TIME'                      , N'en-US', N'WorkflowEventLog', null, null, N'Date Time';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'WorkflowEventLog', null, null, N'Workflow Event Log';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'WorkflowEventLog', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRACKING_WORKFLOW_EVENT'              , N'en-US', N'WorkflowEventLog', null, null, N'Event';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'WorkflowEventLog', null, null, N'WEv';
GO

-- 05/24/2021 Paul.  Missing label required by React client. 
-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' and LANG = 'en-US' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'WorkflowEventLog'                              , N'en-US', null, N'moduleList'                        , 176, N'Workflow Event Log';
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

call dbo.spTERMINOLOGY_WorkflowEventLog_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_WorkflowEventLog_en_us')
/
-- #endif IBM_DB2 */

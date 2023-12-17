

print 'SHORTCUTS BusinessProcesses';
-- delete SHORTCUTS
GO

set nocount on;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'BusinessProcesses';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'BusinessProcesses' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcesses', 'BusinessProcesses.LNK_NEW_BUSINESS_PROCESS'   , '~/Administration/BusinessProcesses/edit.aspx'        , 'CreateBusinessProcesses.gif'  , 1,  1, 'BusinessProcesses'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcesses', 'BusinessProcesses.LNK_BUSINESS_PROCESSES_LIST', '~/Administration/BusinessProcesses/default.aspx'     , 'BusinessProcesses.gif'        , 1,  2, 'BusinessProcesses'     , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcesses', 'BusinessProcessesLog.LBL_LIST_FORM_TITLE'     , '~/Administration/BusinessProcessesLog/default.aspx'  , 'BusinessProcessesLog.gif'     , 1,  3, 'BusinessProcessesLog'  , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcesses', 'Workflows.LNK_NEW_ALERT_TEMPLATE'             , '~/Administration/WorkflowAlertTemplates/edit.aspx'   , 'CreateAlertEmailTemplates.gif', 1,  4, 'WorkflowAlertTemplates', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcesses', 'Workflows.LNK_ALERT_TEMPLATES_LIST'           , '~/Administration/WorkflowAlertTemplates/default.aspx', 'AlertEmailTemplates.gif'      , 1,  5, 'WorkflowAlertTemplates', 'list';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'BusinessProcessesLog';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'BusinessProcessesLog' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcessesLog', 'BusinessProcesses.LNK_NEW_BUSINESS_PROCESS'   , '~/Administration/BusinessProcesses/edit.aspx'        , 'CreateBusinessProcesses.gif'  , 1,  1, 'BusinessProcesses'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcessesLog', 'BusinessProcesses.LNK_BUSINESS_PROCESSES_LIST', '~/Administration/BusinessProcesses/default.aspx'     , 'BusinessProcesses.gif'        , 1,  2, 'BusinessProcesses'     , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcessesLog', 'BusinessProcessesLog.LBL_LIST_FORM_TITLE'     , '~/Administration/BusinessProcessesLog/default.aspx'  , 'BusinessProcessesLog.gif'     , 1,  3, 'BusinessProcessesLog'  , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcessesLog', 'Workflows.LNK_NEW_ALERT_TEMPLATE'             , '~/Administration/WorkflowAlertTemplates/edit.aspx'   , 'CreateAlertEmailTemplates.gif', 1,  4, 'WorkflowAlertTemplates', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'BusinessProcessesLog', 'Workflows.LNK_ALERT_TEMPLATES_LIST'           , '~/Administration/WorkflowAlertTemplates/default.aspx', 'AlertEmailTemplates.gif'      , 1,  5, 'WorkflowAlertTemplates', 'list';
end -- if;
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

call dbo.spSHORTCUTS_BusinessProcesses()
/

call dbo.spSqlDropProcedure('spSHORTCUTS_BusinessProcesses')
/

-- #endif IBM_DB2 */


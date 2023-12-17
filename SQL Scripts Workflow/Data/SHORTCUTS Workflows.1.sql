

print 'SHORTCUTS Workflow';
-- delete SHORTCUTS
GO

set nocount on;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'Workflows';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Workflows' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Workflows', 'Workflows.LNK_NEW_WORKFLOW'        , '~/Administration/Workflows/edit.aspx'                , 'CreateWorkflowDefinition.gif' , 1,  1, 'Workflows'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Workflows', 'Workflows.LNK_WORKFLOWS_LIST'      , '~/Administration/Workflows/default.aspx'             , 'Workflow.gif'                 , 1,  2, 'Workflows'             , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Workflows', 'Workflows.LNK_NEW_ALERT_TEMPLATE'  , '~/Administration/WorkflowAlertTemplates/edit.aspx'   , 'CreateAlertEmailTemplates.gif', 1,  3, 'WorkflowAlertTemplates', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Workflows', 'Workflows.LNK_ALERT_TEMPLATES_LIST', '~/Administration/WorkflowAlertTemplates/default.aspx', 'AlertEmailTemplates.gif'      , 1,  4, 'WorkflowAlertTemplates', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Workflows', 'Workflows.LNK_WORKFLOWS_SEQUENCE'  , '~/Administration/Workflows/sequence.aspx'            , 'WorkflowSequence.gif'         , 1,  5, 'Workflows'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Workflows', 'Workflows.LNK_WORKFLOW_EVENT_LOG'  , '~/Administration/WorkflowEventLog/default.aspx'      , 'WorkflowEventLog.gif'         , 1,  6, 'Workflows'             , 'list';
end -- if;
GO

-- 04/04/2011 Paul.  We need shortcuts for the Alert Templates. 
-- delete from SHORTCUTS where MODULE_NAME = 'WorkflowAlertTemplates';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'WorkflowAlertTemplates' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertTemplates', 'Workflows.LNK_NEW_WORKFLOW'        , '~/Administration/Workflows/edit.aspx'                , 'CreateWorkflowDefinition.gif' , 1,  1, 'Workflows'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertTemplates', 'Workflows.LNK_WORKFLOWS_LIST'      , '~/Administration/Workflows/default.aspx'             , 'Workflow.gif'                 , 1,  2, 'Workflows'             , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertTemplates', 'Workflows.LNK_NEW_ALERT_TEMPLATE'  , '~/Administration/WorkflowAlertTemplates/edit.aspx'   , 'CreateAlertEmailTemplates.gif', 1,  3, 'WorkflowAlertTemplates', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertTemplates', 'Workflows.LNK_ALERT_TEMPLATES_LIST', '~/Administration/WorkflowAlertTemplates/default.aspx', 'AlertEmailTemplates.gif'      , 1,  4, 'WorkflowAlertTemplates', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertTemplates', 'Workflows.LNK_WORKFLOWS_SEQUENCE'  , '~/Administration/Workflows/sequence.aspx'            , 'WorkflowSequence.gif'         , 1,  5, 'Workflows'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertTemplates', 'Workflows.LNK_WORKFLOW_EVENT_LOG'  , '~/Administration/WorkflowEventLog/default.aspx'      , 'WorkflowEventLog.gif'         , 1,  6, 'Workflows'             , 'list';
end -- if;
GO

-- 12/21/2012 Paul.  We need shortcuts for the Alerts. 
-- delete from SHORTCUTS where MODULE_NAME = 'WorkflowAlertShells';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'WorkflowActionShells' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowActionShells', 'Workflows.LNK_NEW_WORKFLOW'        , '~/Administration/Workflows/edit.aspx'                , 'CreateWorkflowDefinition.gif' , 1,  1, 'Workflows'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowActionShells', 'Workflows.LNK_WORKFLOWS_LIST'      , '~/Administration/Workflows/default.aspx'             , 'Workflow.gif'                 , 1,  2, 'Workflows'             , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowActionShells', 'Workflows.LNK_NEW_ALERT_TEMPLATE'  , '~/Administration/WorkflowAlertTemplates/edit.aspx'   , 'CreateAlertEmailTemplates.gif', 1,  3, 'WorkflowAlertTemplates', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowActionShells', 'Workflows.LNK_ALERT_TEMPLATES_LIST', '~/Administration/WorkflowAlertTemplates/default.aspx', 'AlertEmailTemplates.gif'      , 1,  4, 'WorkflowAlertTemplates', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowActionShells', 'Workflows.LNK_WORKFLOWS_SEQUENCE'  , '~/Administration/Workflows/sequence.aspx'            , 'WorkflowSequence.gif'         , 1,  5, 'Workflows'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowActionShells', 'Workflows.LNK_WORKFLOW_EVENT_LOG'  , '~/Administration/WorkflowEventLog/default.aspx'      , 'WorkflowEventLog.gif'         , 1,  6, 'Workflows'             , 'list';
end -- if;
GO

-- 12/21/2012 Paul.  We need shortcuts for the Alerts. 
-- delete from SHORTCUTS where MODULE_NAME = 'WorkflowAlertShells';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'WorkflowAlertShells' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertShells', 'Workflows.LNK_NEW_WORKFLOW'        , '~/Administration/Workflows/edit.aspx'                , 'CreateWorkflowDefinition.gif' , 1,  1, 'Workflows'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertShells', 'Workflows.LNK_WORKFLOWS_LIST'      , '~/Administration/Workflows/default.aspx'             , 'Workflow.gif'                 , 1,  2, 'Workflows'             , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertShells', 'Workflows.LNK_NEW_ALERT_TEMPLATE'  , '~/Administration/WorkflowAlertTemplates/edit.aspx'   , 'CreateAlertEmailTemplates.gif', 1,  3, 'WorkflowAlertTemplates', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertShells', 'Workflows.LNK_ALERT_TEMPLATES_LIST', '~/Administration/WorkflowAlertTemplates/default.aspx', 'AlertEmailTemplates.gif'      , 1,  4, 'WorkflowAlertTemplates', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertShells', 'Workflows.LNK_WORKFLOWS_SEQUENCE'  , '~/Administration/Workflows/sequence.aspx'            , 'WorkflowSequence.gif'         , 1,  5, 'Workflows'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'WorkflowAlertShells', 'Workflows.LNK_WORKFLOW_EVENT_LOG'  , '~/Administration/WorkflowEventLog/default.aspx'      , 'WorkflowEventLog.gif'         , 1,  6, 'Workflows'             , 'list';
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

call dbo.spSHORTCUTS_Workflow()
/

call dbo.spSqlDropProcedure('spSHORTCUTS_Workflow')
/

-- #endif IBM_DB2 */


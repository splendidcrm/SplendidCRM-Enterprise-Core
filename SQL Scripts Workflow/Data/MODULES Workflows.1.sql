

print 'MODULES Workflow';
GO

set nocount on;
GO

-- 05/02/2010 Paul.  Add defaults for Exchange Folders and Exchange Create Parent. 
-- 12/06/2010 Paul.  Convert display name to use moduleList. 
-- 09/12/2011 Paul.  REST_ENABLED provides a way to enable/disable a module in the REST API. 

exec dbo.spMODULES_InsertOnly null, 'Workflows'             , '.moduleList.Workflows'                 , '~/Administration/Workflows/'             , 1, 0,  0, 0, 0, 0, 0, 1, 'WORKFLOW'                , 0, 0, 0, 0, 0, 0;
-- 03/09/2010 Paul.  Add WorkflowEventLog so that we can control access to it. 
exec dbo.spMODULES_InsertOnly null, 'WorkflowEventLog'      , 'Workflows.LBL_EVENTS_TITLE'            , '~/Administration/WorkflowEventLog/'      , 1, 0,  0, 0, 0, 0, 0, 1, 'WORKFLOW_RUN'            , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'WorkflowTriggerShells' , '.moduleList.WorkflowTriggerShells'     , '~/Administration/WorkflowTriggerShells/' , 1, 0,  0, 0, 0, 0, 0, 1, 'WORKFLOW_TRIGGER_SHELLS' , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'WorkflowAlertShells'   , '.moduleList.WorkflowAlertShells'       , '~/Administration/WorkflowAlertShells/'   , 1, 0,  0, 0, 0, 0, 0, 1, 'WORKFLOW_ALERT_SHELLS'   , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'WorkflowActionShells'  , '.moduleList.WorkflowActionShells'      , '~/Administration/WorkflowActionShells/'  , 1, 0,  0, 0, 0, 0, 0, 1, 'WORKFLOW_ACTION_SHELLS'  , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'WorkflowAlertTemplates', '.moduleList.WorkflowAlertTemplates'    , '~/Administration/WorkflowAlertTemplates/', 1, 0,  0, 0, 0, 0, 0, 1, 'WORKFLOW_ALERT_TEMPLATES', 0, 0, 0, 0, 0, 0;
GO

-- 07/31/2019 Paul.  DEFAULT_SORT is a new field for the React Client. 
if exists(select * from MODULES where MODULE_NAME = N'WorkflowEventLog' and DEFAULT_SORT is null) begin -- then
	print 'MODULES: Update DEFAULT_SORT defaults.';
	update MODULES
	   set DEFAULT_SORT        = 'DATE_ENTERED desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT is null
	   and MODULE_NAME in 
		( N'WorkflowEventLog'
		);
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

call dbo.spMODULES_Workflow()
/

call dbo.spSqlDropProcedure('spMODULES_Workflow')
/

-- #endif IBM_DB2 */


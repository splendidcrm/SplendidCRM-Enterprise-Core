

print 'SYSTEM_REST_TABLES Workflow';
-- delete from SYSTEM_REST_TABLES
--GO

set nocount on;
GO


exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'WORKFLOW_ALERT_TEMPLATES', 'vwWORKFLOW_ALERT_TEMPLATES', 'WorkflowAlertTemplates', null, 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'REPORTS'                 , 'vwREPORTS'                 , 'Reports'               , null, 0, null, 1, 0, null, 0;
-- 08/01/2016 Paul.  Need access to roles in BPMN. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'ACL_ROLES'               , 'vwACL_ROLES'               , 'ACLRoles'              , null, 0, null, 1, 0, null, 0;
-- 08/20/2016 Paul.  Add support for Processes module. 
--exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'PROCESSES'               , 'vwPROCESSES'               , 'Processes'             , null, 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwPROCESSES_Pending'     , 'vwPROCESSES_Pending'       , 'Processes'             , null, 0, null, 0, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwUSERS_ASSIGNED_TO_List', 'vwUSERS_ASSIGNED_TO_List'  , 'Users'                 , null, 0, null, 0, 0, null, 0;

-- 03/10/2021 Paul.  Instead of allowing access to all tables to an admin, require that the table be registerd and admin acces to module. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwWORKFLOW_RUN_EventLog'          , 'vwWORKFLOW_RUN_EventLog'          , 'WorkflowEventLog'      , null, 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwWORKFLOW_RUN'                   , 'vwWORKFLOW_RUN'                   , 'WorkflowEventLog'      , null, 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'WORKFLOW'                         , 'vwWORKFLOWS'                      , 'Workflows'             , null, 0, null, 1, 0, null, 0;
-- 04/15/2021 Paul.  Add WorkflowAlertShells for the React client. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'WORKFLOW_ALERT_SHELLS'            , 'vwWORKFLOW_ALERT_SHELLS'          , 'WorkflowAlertShells'   , null, 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'WORKFLOW_ACTION_SHELLS'           , 'vwWORKFLOW_ACTION_SHELLS'         , 'WorkflowActionShells'  , null, 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'WORKFLOW_TRIGGER_SHELLS'          , 'vwWORKFLOW_TRIGGER_SHELLS'        , 'WorkflowTriggerShells' , null, 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwWORKFLOW_ALERT_SHELLS'          , 'vwWORKFLOW_ALERT_SHELLS'          , 'Workflows'             , 'WorkflowAlertShells'   , 0, null, 1, 0, null, 1, 'PARENT_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwWORKFLOW_ACTION_SHELLS'         , 'vwWORKFLOW_ACTION_SHELLS'         , 'Workflows'             , 'WorkflowActionShells'  , 0, null, 1, 0, null, 1, 'PARENT_ID';
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwWORKFLOW_TRIGGER_SHELLS'        , 'vwWORKFLOW_TRIGGER_SHELLS'        , 'Workflows'             , 'WorkflowTriggerShells' , 0, null, 1, 0, null, 1, 'PARENT_ID';

exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwWWF_INSTANCE_EVENTS'            , 'vwWWF_INSTANCE_EVENTS'            , 'WorkflowEventLog'      , null, 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwBUSINESS_PROCESSES_RUN_EventLog', 'vwBUSINESS_PROCESSES_RUN_EventLog', 'BusinessProcessesLog'  , null, 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwWF4_INSTANCE_EVENTS'            , 'vwWF4_INSTANCE_EVENTS'            , 'BusinessProcessesLog'  , null, 0, null, 1, 0, null, 0;
-- 04/15/2021 Paul.  Enable workflow tables for precompile. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'BUSINESS_PROCESSES'               , 'vwBUSINESS_PROCESSES'             , 'BusinessProcesses'     , null, 0, null, 1, 0, null, 0;
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'vwBUSINESS_RULES'                 , 'vwBUSINESS_RULES'                 , 'BusinessRules'         , null, 0, null, 1, 0, null, 0;
-- 08/13/2021 Paul.  Eanble machine learning. 
exec dbo.spSYSTEM_REST_TABLES_InsertOnly null, 'MACHINE_LEARNING_MODELS'          , 'vwMACHINE_LEARNING_MODELS'        , 'MachineLearningModels' , null, 0, null, 1, 0, null, 0;
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

call dbo.spSYSTEM_REST_TABLES_Workflow()
/

call dbo.spSqlDropProcedure('spSYSTEM_REST_TABLES_Workflow')
/

-- #endif IBM_DB2 */




print 'DYNAMIC_BUTTONS Workflow';
GO

set nocount on;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'Workflows.DetailView'             , 'Workflows'             ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView'  , 'Workflows.EditView'               , 'Workflows'             ;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'WorkflowAlertShells.DetailView'   , 'WorkflowAlertShells'   ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'WorkflowActionShells.DetailView'  , 'WorkflowActionShells'  ;

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'WorkflowAlertShells.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'WorkflowAlertShells.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS WorkflowAlertShells.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'WorkflowAlertShells.EditView'    , 0, null              , null  , null              , null, 'Save'                    , null, '.LBL_SAVE_BUTTON_LABEL'                      , '.LBL_SAVE_BUTTON_TITLE'                      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'WorkflowAlertShells.EditView'    , 1, null              , null  , null              , null, 'Cancel'                  , null, '.LBL_CANCEL_BUTTON_LABEL'                    , '.LBL_CANCEL_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'WorkflowActionShells.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'WorkflowActionShells.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS WorkflowActionShells.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'WorkflowActionShells.EditView'   , 0, null              , null  , null              , null, 'Save'                    , null, '.LBL_SAVE_BUTTON_LABEL'                      , '.LBL_SAVE_BUTTON_TITLE'                      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'WorkflowActionShells.EditView'   , 1, null              , null  , null              , null, 'Cancel'                  , null, '.LBL_CANCEL_BUTTON_LABEL'                    , '.LBL_CANCEL_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'WorkflowAlertTemplates.DetailView', 'WorkflowAlertTemplates';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'WorkflowAlertTemplates.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'WorkflowAlertTemplates.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS WorkflowAlertTemplates.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'WorkflowAlertTemplates.EditView' , 0, null              , null  , null              , null, 'Save'                    , null, '.LBL_SAVE_BUTTON_LABEL'                      , '.LBL_SAVE_BUTTON_TITLE'                      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'WorkflowAlertTemplates.EditView' , 1, null              , null  , null              , null, 'Cancel'                  , null, '.LBL_CANCEL_BUTTON_LABEL'                    , '.LBL_CANCEL_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Workflows.WorkflowAlertShells' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Workflows.WorkflowAlertShells SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Workflows.WorkflowAlertShells', 0, 'Workflows', null, 'WorkflowAlertShells', null, 'WorkflowAlertShells.Create', null, '.LBL_NEW_BUTTON_LABEL', '.LBL_NEW_BUTTON_TITLE', null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Workflows.WorkflowActionShells' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Workflows.WorkflowActionShells SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Workflows.WorkflowActionShells', 0, 'Workflows', null, 'WorkflowActionShells', null, 'WorkflowActionShells.Create', null, '.LBL_NEW_BUTTON_LABEL', '.LBL_NEW_BUTTON_TITLE', null, null, null;
end -- if;
GO

-- 06/27/2010 Paul.  Add Schedule Report buttons. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Reports.ScheduleView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Reports.ScheduleView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.ScheduleView'            , 0, null              , null  , null              , null, 'Save'                    , null, '.LBL_SAVE_BUTTON_LABEL'                      , '.LBL_SAVE_BUTTON_TITLE'                      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.ScheduleView'            , 1, null              , null  , null              , null, 'Delete'                  , null, '.LBL_DELETE_BUTTON_LABEL'                    , '.LBL_DELETE_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'Reports.ScheduleView'            , 2, null              , null  , null              , null, 'Cancel'                  , null, '.LBL_CANCEL_BUTTON_LABEL'                    , '.LBL_CANCEL_BUTTON_TITLE'                    , null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_Workflow()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_Workflow')
/

-- #endif IBM_DB2 */




print 'DYNAMIC_BUTTONS ListView Workflow';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.ListView'
--GO

set nocount on;
GO


if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SimpleStorage.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'SimpleStorage.ListView', 0, 'SimpleStorage', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'WorkflowAlertShells.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'WorkflowAlertShells.ListView', 0, 'WorkflowAlertShells', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'WorkflowAlertTemplates.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'WorkflowAlertTemplates.ListView', 0, 'WorkflowAlertTemplates', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Workflows.ListView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Workflows.ListView', 0, 'Workflows', 'edit', null, null, 'Create', 'edit.aspx', null, '.LBL_CREATE_BUTTON_LABEL', '.LBL_CREATE_BUTTON_TITLE', null, null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_WorkflowListView()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_WorkflowListView')
/

-- #endif IBM_DB2 */


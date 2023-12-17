

print 'DYNAMIC_BUTTONS EditView BusinessProcesses';

set nocount on;
GO

-- 09/06/2021 Paul.  The React client needs buttons. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'BusinessProcesses.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'BusinessProcesses.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'BusinessProcesses.EditView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'                   , '.LBL_SAVE_BUTTON_TITLE'                   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'BusinessProcesses.EditView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'                 , '.LBL_CANCEL_BUTTON_TITLE'                 , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'BusinessProcesses.EditView', 2, null, 'edit', null, null, 'Import'      , null, 'BusinessProcesses.LBL_IMPORT_BUTTON_LABEL', 'BusinessProcesses.LBL_IMPORT_BUTTON_LABEL', null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_EditView_BusinessProcesses()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_EditView_BusinessProcesses')
/

-- #endif IBM_DB2 */


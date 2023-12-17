

print 'DYNAMIC_BUTTONS ReportRules';
GO

set nocount on;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'ReportRules.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ReportRules.EditView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ReportRules.EditView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'ReportRules.EditView'    , 0, 'ReportRules'   , 'edit', null              , null, 'Save'                    , null, '.LBL_SAVE_BUTTON_LABEL'        , '.LBL_SAVE_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel 'ReportRules.EditView'    , 1, 'ReportRules'   , 0;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupView', 'ReportRules.PopupView'     , 'ReportRules'     ;
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

call dbo.spDYNAMIC_BUTTONS_ReportRules()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_ReportRules')
/

-- #endif IBM_DB2 */


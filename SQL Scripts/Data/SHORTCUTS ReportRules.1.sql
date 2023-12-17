

print 'SHORTCUTS ReportRules';
-- delete SHORTCUTS
GO

set nocount on;
GO

-- 06/09/2011 Paul.  Include a link to the reports. 
-- delete from SHORTCUTS where MODULE_NAME = 'ReportRules';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'ReportRules' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'ReportRules'           , 'ReportRules.LBL_CREATE_BUTTON_LABEL'          , '~/Reports/ReportRules/edit.aspx'          , 'CreateRule.gif'       , 1,  1, 'ReportRules'       , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ReportRules'           , 'ReportRules.LNK_RULES'                        , '~/Reports/ReportRules/default.aspx'       , 'Rules.gif'            , 1,  2, 'ReportRules'       , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ReportRules'           , 'Reports.LNK_REPORTS'                          , '~/Reports/default.aspx'                   , 'Reports.gif'          , 1,  3, 'Reports'           , 'list';
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

call dbo.spSHORTCUTS_ReportRules()
/

call dbo.spSqlDropProcedure('spSHORTCUTS_ReportRules')
/

-- #endif IBM_DB2 */


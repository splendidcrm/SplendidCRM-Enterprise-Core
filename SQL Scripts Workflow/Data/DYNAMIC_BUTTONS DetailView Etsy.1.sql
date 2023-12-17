

print 'DYNAMIC_BUTTONS DetailView Etsy';

set nocount on;
GO

-- 03/11/2022 Paul.  Add Etsy. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Etsy.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Etsy.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Etsy.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Etsy.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Etsy.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Etsy.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Etsy.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_DetailView_Etsy()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailView_Etsy')
/

-- #endif IBM_DB2 */


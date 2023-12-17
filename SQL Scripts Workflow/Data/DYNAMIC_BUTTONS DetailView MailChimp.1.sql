

print 'DYNAMIC_BUTTONS DetailView MailChimp';

set nocount on;
GO

-- 04/04/2016 Paul.  Add MailChimp. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'MailChimp.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'MailChimp.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'MailChimp.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'MailChimp.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'MailChimp.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'MailChimp.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'MailChimp.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'MailChimp.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'MailChimp.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like 'EmailTemplates.DetailView.MailChimp';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'EmailTemplates.DetailView.MailChimp' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS EmailTemplates.DetailView.MailChimp';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'EmailTemplates.DetailView.MailChimp', 0, 'EmailTemplates', 'edit'  , null, null, 'Edit', 'edit.aspx?HID={0}', 'id', '.LBL_EDIT_BUTTON_LABEL', '.LBL_EDIT_BUTTON_TITLE', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'EmailTemplates.DetailView.MailChimp', 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'EmailTemplates.DetailView.MailChimp', 2, null, 0;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like 'EmailTemplates.ProspectLists.MailChimp';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProspectLists.DetailView.MailChimp' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ProspectLists.DetailView.MailChimp';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ProspectLists.DetailView.MailChimp', 0, 'EmailTemplates', 'edit'  , null, null, 'Edit', 'edit.aspx?HID={0}', 'id', '.LBL_EDIT_BUTTON_LABEL', '.LBL_EDIT_BUTTON_TITLE', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'ProspectLists.DetailView.MailChimp' , 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'ProspectLists.DetailView.MailChimp' , 2, null, 0;
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

call dbo.spDYNAMIC_BUTTONS_DetailView_MailChimp()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailView_MailChimp')
/

-- #endif IBM_DB2 */


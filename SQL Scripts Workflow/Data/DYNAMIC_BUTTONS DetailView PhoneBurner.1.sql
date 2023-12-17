

print 'DYNAMIC_BUTTONS DetailView PhoneBurner';

set nocount on;
GO

-- 04/04/2016 Paul.  Add PhoneBurner. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'PhoneBurner.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PhoneBurner.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'PhoneBurner.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'PhoneBurner.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'PhoneBurner.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'PhoneBurner.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'PhoneBurner.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PhoneBurner.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'PhoneBurner.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like 'Contacts.DetailView.PhoneBurner';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.DetailView.PhoneBurner' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.DetailView.PhoneBurner';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contacts.DetailView.PhoneBurner', 0, 'Contacts', 'edit'  , null, null, 'Edit', 'edit.aspx?HID={0}', 'id', '.LBL_EDIT_BUTTON_LABEL', '.LBL_EDIT_BUTTON_TITLE', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Contacts.DetailView.PhoneBurner', 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Contacts.DetailView.PhoneBurner', 2, null, 0;
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

call dbo.spDYNAMIC_BUTTONS_DetailView_PhoneBurner()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailView_PhoneBurner')
/

-- #endif IBM_DB2 */


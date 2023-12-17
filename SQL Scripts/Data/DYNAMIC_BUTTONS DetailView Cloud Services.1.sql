

print 'DYNAMIC_BUTTONS DetailView Cloud Services';

set nocount on;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.DetailView.iCloud' 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.DetailView.iCloud' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.DetailView.iCloud';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contacts.DetailView.iCloud'    , 0, 'Contacts', 'edit'  , null, null, 'Edit', 'edit.aspx?UID={0}', 'UID', '.LBL_EDIT_BUTTON_LABEL', '.LBL_EDIT_BUTTON_TITLE', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Contacts.DetailView.iCloud'    , 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Contacts.DetailView.iCloud'    , 2, null, 0;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.DetailView.Exchange' 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.DetailView.Exchange' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.DetailView.Exchange';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contacts.DetailView.Exchange'  , 0, 'Contacts', 'edit'  , null, null, 'Edit', 'edit.aspx?UID={0}', 'UID', '.LBL_EDIT_BUTTON_LABEL', '.LBL_EDIT_BUTTON_TITLE', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Contacts.DetailView.Exchange'  , 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Contacts.DetailView.Exchange'  , 2, null, 0;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.DetailView.GoogleApps' 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.DetailView.GoogleApps' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.DetailView.GoogleApps';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contacts.DetailView.GoogleApps', 0, 'Contacts', 'edit'  , null, null, 'Edit', 'edit.aspx?UID={0}', 'UID', '.LBL_EDIT_BUTTON_LABEL', '.LBL_EDIT_BUTTON_TITLE', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Contacts.DetailView.GoogleApps', 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Contacts.DetailView.GoogleApps', 2, null, 0;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Meetings.DetailView.iCloud' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Meetings.DetailView.iCloud';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Meetings.DetailView.iCloud'    , 0, 'Meetings', 'edit'  , null, null, 'Edit', 'edit.aspx?UID={0}', 'UID', '.LBL_EDIT_BUTTON_LABEL', '.LBL_EDIT_BUTTON_TITLE', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Meetings.DetailView.iCloud'    , 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Meetings.DetailView.iCloud'    , 2, null, 0;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Meetings.DetailView.Exchange' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Meetings.DetailView.Exchange';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Meetings.DetailView.Exchange'  , 0, 'Meetings', 'edit'  , null, null, 'Edit', 'edit.aspx?UID={0}', 'UID', '.LBL_EDIT_BUTTON_LABEL', '.LBL_EDIT_BUTTON_TITLE', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Meetings.DetailView.Exchange'  , 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Meetings.DetailView.Exchange'  , 2, null, 0;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Meetings.DetailView.GoogleApps' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Meetings.DetailView.GoogleApps';
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Meetings.DetailView.GoogleApps', 0, 'Meetings', 'edit'  , null, null, 'Edit', 'edit.aspx?UID={0}', 'UID', '.LBL_EDIT_BUTTON_LABEL', '.LBL_EDIT_BUTTON_TITLE', null, null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Meetings.DetailView.GoogleApps', 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Meetings.DetailView.GoogleApps', 2, null, 0;
end -- if;
GO

-- 04/26/2015 Paul.  Add HubSpot. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'HubSpot.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'HubSpot.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'HubSpot.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'HubSpot.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'HubSpot.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'HubSpot.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'HubSpot.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'HubSpot.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'HubSpot.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 05/01/2015 Paul.  Add iContact. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'iContact.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'iContact.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'iContact.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'iContact.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'iContact.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'iContact.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'iContact.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'iContact.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'iContact.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 05/01/2015 Paul.  Add ConstantContact. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'ConstantContact.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ConstantContact.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'ConstantContact.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'ConstantContact.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'ConstantContact.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'ConstantContact.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ConstantContact.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ConstantContact.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'ConstantContact.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 05/06/2015 Paul.  Add GetResponse. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'GetResponse.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'GetResponse.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'GetResponse.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'GetResponse.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'GetResponse.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'GetResponse.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'GetResponse.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'GetResponse.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'GetResponse.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 05/06/2015 Paul.  Add Marketo. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Marketo.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Marketo.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Marketo.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Marketo.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Marketo.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Marketo.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Marketo.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Marketo.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'Marketo.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 01/02/2023 Paul.  Add MicrosoftTeams. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'MicrosoftTeams.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'MicrosoftTeams.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'MicrosoftTeams.DetailView', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'MicrosoftTeams.DetailView', 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'MicrosoftTeams.DetailView', 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'MicrosoftTeams.DetailView', 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'MicrosoftTeams.DetailView', 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_DetailView_Cloud()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailView_Cloud')
/

-- #endif IBM_DB2 */


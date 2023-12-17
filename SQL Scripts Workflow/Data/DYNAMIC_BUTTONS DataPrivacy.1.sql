

print 'DYNAMIC_BUTTONS DataPrivacy';
GO

set nocount on;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView'  , 'DataPrivacy.EditView'  , 'DataPrivacy';
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.DetailView'
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS DataPrivacy.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      'DataPrivacy.DetailView', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'DataPrivacy.DetailView', 1, null, 1;  -- DetailView Cancel is only visible on mobile. 
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.DetailView.React'
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.DetailView.React' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS DataPrivacy.DetailView.React';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      'DataPrivacy.DetailView.React', 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'DataPrivacy.DetailView.React', 1, null, 1;  -- DetailView Cancel is only visible on mobile. 
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.DetailView.React', 2, null, null, 'DataPrivacy', 'edit', 'DataPrivacy.Complete', null, 'DataPrivacy.LBL_COMPLETE_BUTTON', 'DataPrivacy.LBL_COMPLETE_BUTTON', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.DetailView.React', 3, null, null, 'DataPrivacy', 'edit', 'DataPrivacy.Erase'   , null, 'DataPrivacy.LBL_ERASE_BUTTON'   , 'DataPrivacy.LBL_ERASE_BUTTON'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.DetailView.React', 4, null, null, 'DataPrivacy', 'edit', 'DataPrivacy.Reject'  , null, 'DataPrivacy.LBL_REJECT_BUTTON'  , 'DataPrivacy.LBL_REJECT_BUTTON'  , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DataPrivacy' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Accounts.DataPrivacy';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DataPrivacy' , 0, 'Accounts'   , 'edit', 'DataPrivacy', 'edit', 'DataPrivacy.Create', null, '.LBL_NEW_BUTTON_LABEL'   , '.LBL_NEW_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.DataPrivacy' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.DataPrivacy';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.DataPrivacy' , 0, 'Contacts'   , 'edit', 'DataPrivacy', 'edit', 'DataPrivacy.Create', null, '.LBL_NEW_BUTTON_LABEL'   , '.LBL_NEW_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Leads.DataPrivacy' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Leads.DataPrivacy';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Leads.DataPrivacy'    , 0, 'Leads'      , 'edit', 'DataPrivacy', 'edit', 'DataPrivacy.Create', null, '.LBL_NEW_BUTTON_LABEL'   , '.LBL_NEW_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Prospects.DataPrivacy' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Prospects.DataPrivacy';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Prospects.DataPrivacy', 0, 'Prospects'  , 'edit', 'DataPrivacy', 'edit', 'DataPrivacy.Create', null, '.LBL_NEW_BUTTON_LABEL'   , '.LBL_NEW_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DataPrivacy.ArchiveView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Accounts.DataPrivacy.ArchiveView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.DataPrivacy.ArchiveView' , 0, 'Accounts'   , 'edit', 'DataPrivacy', 'edit', 'DataPrivacy.Create', null, '.LBL_NEW_BUTTON_LABEL'   , '.LBL_NEW_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.DataPrivacy.ArchiveView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.DataPrivacy.ArchiveView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.DataPrivacy.ArchiveView' , 0, 'Contacts'   , 'edit', 'DataPrivacy', 'edit', 'DataPrivacy.Create', null, '.LBL_NEW_BUTTON_LABEL'   , '.LBL_NEW_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Leads.DataPrivacy.ArchiveView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Leads.DataPrivacy.ArchiveView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Leads.DataPrivacy.ArchiveView'    , 0, 'Leads'      , 'edit', 'DataPrivacy', 'edit', 'DataPrivacy.Create', null, '.LBL_NEW_BUTTON_LABEL'   , '.LBL_NEW_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Prospects.DataPrivacy.ArchiveView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Prospects.DataPrivacy.ArchiveView';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Prospects.DataPrivacy.ArchiveView', 0, 'Prospects'  , 'edit', 'DataPrivacy', 'edit', 'DataPrivacy.Create', null, '.LBL_NEW_BUTTON_LABEL'   , '.LBL_NEW_BUTTON_TITLE'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.Accounts' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'DataPrivacy.Accounts' , 1, 'DataPrivacy', 'edit', 'Contacts'   , 'list', 'AccountPopup();'   , null, '.LBL_SELECT_BUTTON_LABEL', '.LBL_SELECT_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.Accounts' , 2, 'DataPrivacy', 'view', 'Contacts'   , 'list', 'Accounts.Search'   , null, '.LBL_SEARCH_BUTTON_LABEL', '.LBL_SEARCH_BUTTON_TITLE', null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.Contacts' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'DataPrivacy.Contacts' , 1, 'DataPrivacy', 'edit', 'Contacts'   , 'list', 'ContactPopup();'   , null, '.LBL_SELECT_BUTTON_LABEL', '.LBL_SELECT_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.Contacts' , 2, 'DataPrivacy', 'view', 'Contacts'   , 'list', 'Contacts.Search'   , null, '.LBL_SEARCH_BUTTON_LABEL', '.LBL_SEARCH_BUTTON_TITLE', null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.Leads' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'DataPrivacy.Leads'    , 1, 'DataPrivacy', 'edit', 'Contacts'   , 'list', 'LeadPopup();'      , null, '.LBL_SELECT_BUTTON_LABEL', '.LBL_SELECT_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.Leads'    , 2, 'DataPrivacy', 'view', 'Contacts'   , 'list', 'Leads.Search'      , null, '.LBL_SEARCH_BUTTON_LABEL', '.LBL_SEARCH_BUTTON_TITLE', null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.Prospects' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'DataPrivacy.Prospects', 1, 'DataPrivacy', 'edit', 'Contacts'   , 'list', 'ProspectPopup();'  , null, '.LBL_SELECT_BUTTON_LABEL', '.LBL_SELECT_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.Prospects', 2, 'DataPrivacy', 'view', 'Contacts'   , 'list', 'Prospects.Search'  , null, '.LBL_SEARCH_BUTTON_LABEL', '.LBL_SEARCH_BUTTON_TITLE', null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.Accounts.ArchiveView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'DataPrivacy.Accounts.ArchiveView' , 1, 'DataPrivacy', 'edit', 'Contacts'   , 'list', 'AccountArchivedPopup();'   , null, '.LBL_SELECT_BUTTON_LABEL', '.LBL_SELECT_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.Accounts.ArchiveView' , 2, 'DataPrivacy', 'view', 'Contacts'   , 'list', 'Accounts.Search'   , null, '.LBL_SEARCH_BUTTON_LABEL', '.LBL_SEARCH_BUTTON_TITLE', null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.Contacts.ArchiveView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'DataPrivacy.Contacts.ArchiveView' , 1, 'DataPrivacy', 'edit', 'Contacts'   , 'list', 'ContactArchivedPopup();'   , null, '.LBL_SELECT_BUTTON_LABEL', '.LBL_SELECT_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.Contacts.ArchiveView' , 2, 'DataPrivacy', 'view', 'Contacts'   , 'list', 'Contacts.Search'   , null, '.LBL_SEARCH_BUTTON_LABEL', '.LBL_SEARCH_BUTTON_TITLE', null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.Leads.ArchiveView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'DataPrivacy.Leads.ArchiveView'    , 1, 'DataPrivacy', 'edit', 'Contacts'   , 'list', 'LeadArchivedPopup();'      , null, '.LBL_SELECT_BUTTON_LABEL', '.LBL_SELECT_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.Leads.ArchiveView'    , 2, 'DataPrivacy', 'view', 'Contacts'   , 'list', 'Leads.Search'      , null, '.LBL_SEARCH_BUTTON_LABEL', '.LBL_SEARCH_BUTTON_TITLE', null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.Prospects.ArchiveView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'DataPrivacy.Prospects.ArchiveView', 1, 'DataPrivacy', 'edit', 'Contacts'   , 'list', 'ProspectArchivedPopup();'  , null, '.LBL_SELECT_BUTTON_LABEL', '.LBL_SELECT_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'DataPrivacy.Prospects.ArchiveView', 2, 'DataPrivacy', 'view', 'Contacts'   , 'list', 'Prospects.Search'  , null, '.LBL_SEARCH_BUTTON_LABEL', '.LBL_SEARCH_BUTTON_TITLE', null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DetailView' and COMMAND_NAME = 'PersonalInfo' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPersonalInfo 'Accounts.DetailView', null, 'Accounts';
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.DetailView' and COMMAND_NAME = 'PersonalInfo' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPersonalInfo 'Contacts.DetailView', null, 'Contacts';
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Leads.DetailView' and COMMAND_NAME = 'PersonalInfo' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPersonalInfo 'Leads.DetailView', null, 'Leads';
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Prospects.DetailView' and COMMAND_NAME = 'PersonalInfo' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPersonalInfo 'Prospects.DetailView', null, 'Prospects';
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'DataPrivacy.PopupMultiSelect' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.PopupMultiSelect', 'DataPrivacy.PopupMultiSelect', 'DataPrivacy';
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

call dbo.spDYNAMIC_BUTTONS_DataPrivacy()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DataPrivacy')
/

-- #endif IBM_DB2 */


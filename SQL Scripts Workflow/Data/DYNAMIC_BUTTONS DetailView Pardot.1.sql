

print 'DYNAMIC_BUTTONS DetailView Pardot';

set nocount on;
GO

-- 04/04/2016 Paul.  Add Pardot. 
-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Pardot.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Pardot.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Pardot.DetailView'              , 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Pardot.DetailView'              , 1, null, null  , null, null, 'Test'       , null, '.LBL_TEST_BUTTON_LABEL'          , '.LBL_TEST_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Pardot.DetailView'              , 2, null, null  , null, null, 'Sync'       , null, '.LBL_SYNC_BUTTON_LABEL'          , '.LBL_SYNC_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Pardot.DetailView'              , 3, null, null  , null, null, 'SyncAll'    , null, '.LBL_SYNC_ALL_BUTTON_LABEL'      , '.LBL_SYNC_ALL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Pardot.DetailView'              , 4, null, null  , null, null, 'Log'        , '~/Administration/SystemSyncLog/default.aspx', null, 'Administration.LBL_SYSTEM_SYNC_LOG', 'Administration.LBL_SYSTEM_SYNC_LOG', null, null, null, null;
end else begin
	-- 02/24/2021 Paul.  The React client does not work well with ../.  It replaces with ~/ and that is not correct for admin pages. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Pardot.DetailView' and URL_FORMAT = '../SystemSyncLog/default.aspx' and DELETED = 0) begin -- then
		update DYNAMIC_BUTTONS
		   set URL_FORMAT        = '~/Administration/SystemSyncLog/default.aspx'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where VIEW_NAME         = 'Pardot.DetailView'
		   and URL_FORMAT        = '../SystemSyncLog/default.aspx'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DetailView.Pardot';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.DetailView.Pardot' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Accounts.DetailView.Pardot'     , 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Accounts.DetailView.Pardot'     , 1, null, 'edit', null, null, 'Duplicate'  , null, '.LBL_DUPLICATE_BUTTON_LABEL'     , '.LBL_DUPLICATE_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Accounts.DetailView.Pardot'     , 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Accounts.DetailView.Pardot'     , 3, null, 1;  -- DetailView Cancel is only visible on mobile. 
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Prospects.DetailView.Pardot';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Prospects.DetailView.Pardot' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Prospects.DetailView.Pardot'    , 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Prospects.DetailView.Pardot'    , 1, null, 'edit', null, null, 'Duplicate'  , null, '.LBL_DUPLICATE_BUTTON_LABEL'     , '.LBL_DUPLICATE_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Prospects.DetailView.Pardot'    , 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Prospects.DetailView.Pardot'    , 3, null, 1;  -- DetailView Cancel is only visible on mobile. 
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Campaigns.DetailView.Pardot';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Campaigns.DetailView.Pardot' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Campaigns.DetailView.Pardot'    , 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Campaigns.DetailView.Pardot'    , 1, null, 'edit', null, null, 'Duplicate'  , null, '.LBL_DUPLICATE_BUTTON_LABEL'     , '.LBL_DUPLICATE_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Campaigns.DetailView.Pardot'    , 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Campaigns.DetailView.Pardot'    , 3, null, 1;  -- DetailView Cancel is only visible on mobile. 
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Opportunities.DetailView.Pardot';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Opportunities.DetailView.Pardot' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Opportunities.DetailView.Pardot', 0, null, 'edit', null, null, 'Edit'       , null, '.LBL_EDIT_BUTTON_LABEL'          , '.LBL_EDIT_BUTTON_TITLE'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Opportunities.DetailView.Pardot', 1, null, 'edit', null, null, 'Duplicate'  , null, '.LBL_DUPLICATE_BUTTON_LABEL'     , '.LBL_DUPLICATE_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete     'Opportunities.DetailView.Pardot', 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel     'Opportunities.DetailView.Pardot', 3, null, 1;  -- DetailView Cancel is only visible on mobile. 
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

call dbo.spDYNAMIC_BUTTONS_DetailView_Pardot()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailView_Pardot')
/

-- #endif IBM_DB2 */


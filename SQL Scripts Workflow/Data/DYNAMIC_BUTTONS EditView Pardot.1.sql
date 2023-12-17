

print 'DYNAMIC_BUTTONS EditView Pardot';

set nocount on;
GO

-- 04/04/2016 Paul.  Add Pardot. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Pardot.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Pardot.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Pardot.ConfigView'            , 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Pardot.ConfigView'            , 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Pardot.ConfigView'            , 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'               , '.LBL_TEST_BUTTON_TITLE'               , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.EditView.Pardot';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.EditView.Pardot' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Accounts.EditView.Pardot'     , 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Accounts.EditView.Pardot'     , 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Prospects.EditView.Pardot';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Prospects.EditView.Pardot' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Prospects.EditView.Pardot'    , 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Prospects.EditView.Pardot'    , 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Campaigns.EditView.Pardot';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Campaigns.EditView.Pardot' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Campaigns.EditView.Pardot'    , 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Campaigns.EditView.Pardot'    , 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Opportunities.EditView.Pardot';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Opportunities.EditView.Pardot' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Opportunities.EditView.Pardot', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Opportunities.EditView.Pardot', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_EditView_Pardot()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_EditView_Pardot')
/

-- #endif IBM_DB2 */


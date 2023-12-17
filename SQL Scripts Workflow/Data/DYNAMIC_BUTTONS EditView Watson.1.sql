

print 'DYNAMIC_BUTTONS EditView Watson';

set nocount on;
GO

-- 01/22/2018 Paul.  Add Watson. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Watson.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Watson.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Watson.ConfigView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'               , '.LBL_SAVE_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Watson.ConfigView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'             , '.LBL_CANCEL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Watson.ConfigView', 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'               , '.LBL_TEST_BUTTON_TITLE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Watson.ConfigView', 3, null, null  , null, null, 'Authorize'   , null, 'Watson.LBL_AUTHORIZE_BUTTON_LABEL'    , 'Watson.LBL_AUTHORIZE_BUTTON_LABEL'    , null, 'return Authorize();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Watson.ConfigView', 4, null, null  , null, null, 'RefreshToken', null, 'Watson.LBL_REFRESH_BUTTON_LABEL'      , 'Watson.LBL_REFRESH_BUTTON_LABEL'      , null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_EditView_Watson()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_EditView_Watson')
/

-- #endif IBM_DB2 */


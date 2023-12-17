

print 'DYNAMIC_BUTTONS EditView PhoneBurner';

set nocount on;
GO

-- 04/04/2016 Paul.  Add PhoneBurner. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'PhoneBurner.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'PhoneBurner.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'PhoneBurner.ConfigView', 0, null, 'edit', null, null, 'Save'        , null, '.LBL_SAVE_BUTTON_LABEL'                , '.LBL_SAVE_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'PhoneBurner.ConfigView', 1, null, null  , null, null, 'Cancel'      , null, '.LBL_CANCEL_BUTTON_LABEL'              , '.LBL_CANCEL_BUTTON_TITLE'              , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'PhoneBurner.ConfigView', 2, null, null  , null, null, 'Test'        , null, '.LBL_TEST_BUTTON_LABEL'                , '.LBL_TEST_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'PhoneBurner.ConfigView', 3, null, null  , null, null, 'Authorize'   , null, 'PhoneBurner.LBL_AUTHORIZE_BUTTON_LABEL', 'PhoneBurner.LBL_AUTHORIZE_BUTTON_LABEL', null, 'return Authorize();', null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'PhoneBurner.ConfigView', 4, null, null  , null, null, 'RefreshToken', null, 'PhoneBurner.LBL_REFRESH_TOKEN_LABEL'   , 'PhoneBurner.LBL_REFRESH_TOKEN_LABEL'   , null, null, null;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView', 'Contacts.EditView.PhoneBurner'    , 'Contacts';
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

call dbo.spDYNAMIC_BUTTONS_EditView_PhoneBurner()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_EditView_PhoneBurner')
/

-- #endif IBM_DB2 */


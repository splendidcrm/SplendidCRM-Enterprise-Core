

print 'DYNAMIC_BUTTONS Avaya';
GO

set nocount on;
GO

-- 09/10/2013 Paul.  Add buttons for Avaya. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Avaya.DetailView' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Avaya.DetailView';
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    'Avaya.DetailView'              , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Avaya.DetailView'              , 1, 'Avaya', null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', null, null, null;
end -- if;
GO

-- 09/04/2013 Paul.  Add AvayaView. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Avaya.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Avaya.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Avaya.EditView', 0, null, 'edit', null, null, 'Save'     , null, '.LBL_SAVE_BUTTON_LABEL'        , '.LBL_SAVE_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Avaya.EditView', 1, null, null  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'      , '.LBL_CANCEL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Avaya.EditView', 2, null, null  , null, null, 'Test'     , null, 'Avaya.LBL_TEST_BUTTON_LABEL', 'Avaya.LBL_TEST_BUTTON_LABEL', null, null, null;
end -- if;
GO


-- 04/08/2019 Paul.  Add Avaya.ConfigView for React app.
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Avaya.ConfigView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Avaya.ConfigView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Avaya.ConfigView', 0, null, 'edit', null, null, 'Save'     , null, '.LBL_SAVE_BUTTON_LABEL'        , '.LBL_SAVE_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Avaya.ConfigView', 1, null, null  , null, null, 'Cancel'   , null, '.LBL_CANCEL_BUTTON_LABEL'      , '.LBL_CANCEL_BUTTON_TITLE'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton  'Avaya.ConfigView', 2, null, null  , null, null, 'Test'     , null, 'Avaya.LBL_TEST_BUTTON_LABEL', 'Avaya.LBL_TEST_BUTTON_LABEL', null, null, null;
end -- if;
GO


-- 09/10/2013 Paul.  Add buttons for Avaya. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Avaya.MassUpdate' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Avaya MassUpdate';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Avaya.MassUpdate'       , 0, 'Avaya'       , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
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

call dbo.spDYNAMIC_BUTTONS_Avaya()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_Avaya')
/

-- #endif IBM_DB2 */




print 'DYNAMIC_BUTTONS EditView.Portal';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.EditView.Portal';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.Notes.Portal';
--GO

set nocount on;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = '.EditView.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .EditView.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsSave       '.EditView.Portal'                       , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancelEdit '.EditView.Portal'                       , 1, null;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Portal', 'Bugs.EditView.Portal'        , 'Bugs'            ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Portal', 'Cases.EditView.Portal'       , 'Cases'           ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Portal', 'Contacts.EditView.Portal'    , 'Contacts'        ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Portal', 'Notes.EditView.Portal'       , 'Notes'           ;

exec dbo.spDYNAMIC_BUTTONS_InsButton   'Bugs.Notes.Portal' , 0, 'Bugs' , 'edit', 'Notes', 'edit', 'Notes.Create', null, 'Activities.LBL_NEW_NOTE_BUTTON_LABEL', 'Activities.LBL_NEW_NOTE_BUTTON_TITLE', null, null, null;
exec dbo.spDYNAMIC_BUTTONS_InsButton   'Cases.Notes.Portal', 0, 'Cases', 'edit', 'Notes', 'edit', 'Notes.Create', null, 'Activities.LBL_NEW_NOTE_BUTTON_LABEL', 'Activities.LBL_NEW_NOTE_BUTTON_TITLE', null, null, null;
GO

-- 03/07/2009 Paul.  We need to manually create the save button so that the Edit permission is not required. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.Registration.Portal';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.Registration.Portal' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts.Registration.Portal';
	exec dbo.spDYNAMIC_BUTTONS_InsButton     'Contacts.Registration.Portal', 0, null, null, null, null, 'Save'     , null, '.LBL_SAVE_BUTTON_LABEL'     , '.LBL_SAVE_BUTTON_TITLE'     , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancelEdit 'Contacts.Registration.Portal', 1, null;
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

call dbo.spDYNAMIC_BUTTONS_EditViewPortal()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_EditViewPortal')
/

-- #endif IBM_DB2 */


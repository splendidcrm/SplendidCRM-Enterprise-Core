

print 'DYNAMIC_BUTTONS Field Security';

set nocount on;
GO

-- 05/22/2018 Paul.  Export is now in position 4, so we need to move to position 5. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ACLRoles.DetailView' and COMMAND_NAME = 'FieldSecurity' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ACLRoles.DetailView Field Security';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'ACLRoles.DetailView'  , 5, 'ACLRoles', 'edit'  , null, null, 'FieldSecurity', null, 'ACLRoles.LBL_FIELD_SECURITY', 'ACLRoles.LBL_FIELD_SECURITY', null, null, null;
end -- if;
GO

-- 01/16/2010 Paul.  The FieldSecurity Cancel needs to be processed as a Command. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'ACLRoles.FieldSecurity';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ACLRoles.FieldSecurity' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ACLRoles.FieldSecurity';
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'ACLRoles.FieldSecurity', 0, null, null  , null, null, 'Save'  , null, '.LBL_SAVE_BUTTON_LABEL'  , '.LBL_SAVE_BUTTON_TITLE'  , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton 'ACLRoles.FieldSecurity', 1, null, null  , null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL', '.LBL_CANCEL_BUTTON_TITLE', null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_FieldSecurity()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_FieldSecurity')
/

-- #endif IBM_DB2 */


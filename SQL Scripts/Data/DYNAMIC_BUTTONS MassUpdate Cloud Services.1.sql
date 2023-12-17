

print 'DYNAMIC_BUTTONS MassUpdate Cloud Services';

set nocount on;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.MassUpdate.iCloud' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts MassUpdate.iCloud';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.MassUpdate.iCloud'    , 0, 'Contacts'      , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.MassUpdate.Exchange' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts MassUpdate.Exchange';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.MassUpdate.Exchange'  , 0, 'Contacts'      , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.MassUpdate.GoogleApps' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts MassUpdate.GoogleApps';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.MassUpdate.GoogleApps', 0, 'Contacts'      , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Meetings.MassUpdate.iCloud' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Meetings MassUpdate.iCloud';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Meetings.MassUpdate.iCloud'    , 0, 'Meetings'      , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Meetings.MassUpdate.Exchange' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Meetings MassUpdate.Exchange';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Meetings.MassUpdate.Exchange'  , 0, 'Meetings'      , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Meetings.MassUpdate.GoogleApps' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Meetings MassUpdate.GoogleApps';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Meetings.MassUpdate.GoogleApps', 0, 'Meetings'      , 'delete', null, null, 'MassDelete', null, '.LBL_DELETE'         , '.LBL_DELETE'         , null, 'if ( !ValidateOne() ) return false;', null;
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

call dbo.spDYNAMIC_BUTTONS_MassUpdate_Cloud()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_MassUpdate_Cloud')
/

-- #endif IBM_DB2 */


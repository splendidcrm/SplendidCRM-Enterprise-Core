

print 'MODULES Portal';
GO

set nocount on;
GO

if exists(select * from MODULES where PORTAL_ENABLED = 0 and MODULE_NAME = N'Home') begin -- then
	print 'Enable Home Portal';
	update MODULES
	   set PORTAL_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = N'Home'
	   and DELETED          = 0;
end -- if;

if exists(select * from MODULES where PORTAL_ENABLED = 0 and MODULE_NAME = N'Bugs') begin -- then
	print 'Enable Bugs Portal';
	update MODULES
	   set PORTAL_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = N'Bugs'
	   and DELETED          = 0;
end -- if;

if exists(select * from MODULES where PORTAL_ENABLED = 0 and MODULE_NAME = N'Cases') begin -- then
	print 'Enable Cases Portal';
	update MODULES
	   set PORTAL_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = N'Cases'
	   and DELETED          = 0;
end -- if;

if exists(select * from MODULES where PORTAL_ENABLED = 0 and MODULE_NAME = N'KBDocuments') begin -- then
	print 'Enable KBDocuments Portal';
	update MODULES
	   set PORTAL_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = N'KBDocuments'
	   and DELETED          = 0;
end -- if;

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

call dbo.spMODULES_Portal()
/

call dbo.spSqlDropProcedure('spMODULES_Portal')
/

-- #endif IBM_DB2 */


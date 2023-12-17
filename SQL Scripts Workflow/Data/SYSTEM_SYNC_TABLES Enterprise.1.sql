

print 'SYSTEM_SYNC_TABLES Enterprise';
-- delete from SYSTEM_SYNC_TABLES
--GO

set nocount on;
GO

-- 01/17/2010 Paul.  ACL_FIELDS is an Enterprise-only feature.  The Module Name is stored in the CATEGORY field. 
-- 08/23/2014 Paul.  ACLRoles and FieldValidators module names should be blank in order to sync. 
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACL_FIELDS'                    , 'ACL_FIELDS'                    , null                       , null                       , 1, 'CATEGORY'         , 1, 0, null, 0;
exec dbo.spSYSTEM_SYNC_TABLES_InsertOnly null, 'ACL_FIELDS_ALIASES'            , 'ACL_FIELDS_ALIASES'            , null                       , null                       , 1, 'ALIAS_MODULE_NAME', 1, 0, null, 0;
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

call dbo.spSYSTEM_SYNC_TABLES_Enterprise()
/

call dbo.spSqlDropProcedure('spSYSTEM_SYNC_TABLES_Enterprise')
/

-- #endif IBM_DB2 */


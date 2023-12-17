

print 'ACL_ACTIONS Enterprise';
GO

set nocount on;
GO

-- 12/17/2017 Paul.  Need to make sure that Enterprise modules get an archive action. 
exec dbo.spACL_ACTIONS_Initialize;
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

call dbo.spACL_ACTIONS_Enterprise()
/

call dbo.spSqlDropProcedure('spACL_ACTIONS_Enterprise')
/

-- #endif IBM_DB2 */


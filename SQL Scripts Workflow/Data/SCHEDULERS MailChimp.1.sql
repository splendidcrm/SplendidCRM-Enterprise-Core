

print 'SCHEDULERS MailChimp';
GO

set nocount on;
GO

-- 04/04/2016 Paul.  Add support for MailChimp. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with MailChimp'      , N'function::pollMailChimp'      , null, null, N'*::*::*::*::*', null, null, N'Inactive', 0;
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

call dbo.spSCHEDULERS_MailChimp()
/

call dbo.spSqlDropProcedure('spSCHEDULERS_MailChimp')
/

-- #endif IBM_DB2 */


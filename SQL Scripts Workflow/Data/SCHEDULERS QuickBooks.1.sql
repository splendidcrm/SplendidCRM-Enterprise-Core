

print 'SCHEDULERS QuickBooks';
GO

set nocount on;
GO

-- 05/13/2012 Paul.  Add support for QuickBooks. QuickBooks is very slow, so only sync once a day. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with QuickBooks at 11pm'               , N'function::pollQuickBooks'                              , null, null, N'0::23::*::*::*'   , null, null, N'Inactive', 0;
-- 02/02/2015 Paul.  Add support for QuickBooks Online. It is much faster, so we can sync hourly. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with QuickBooks Online hourly'         , N'function::pollQuickBooksOnline'                        , null, null, N'0::*::*::*::*'    , null, null, N'Inactive', 0;
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

call dbo.spSCHEDULERS_QuickBooks()
/

call dbo.spSqlDropProcedure('spSCHEDULERS_QuickBooks')
/

-- #endif IBM_DB2 */


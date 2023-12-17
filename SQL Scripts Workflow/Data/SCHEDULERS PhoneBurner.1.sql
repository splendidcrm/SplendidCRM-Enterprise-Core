

print 'SCHEDULERS PhoneBurner';
GO

set nocount on;
GO

-- 04/04/2016 Paul.  Add support for PhoneBurner. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with PhoneBurner'      , N'function::pollPhoneBurner'      , null, null, N'*::*::*::*::*', null, null, N'Inactive', 0;
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

call dbo.spSCHEDULERS_PhoneBurner()
/

call dbo.spSqlDropProcedure('spSCHEDULERS_PhoneBurner')
/

-- #endif IBM_DB2 */


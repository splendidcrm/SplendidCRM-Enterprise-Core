

print 'SCHEDULERS Professional';
GO

set nocount on;
GO

-- 03/11/2012 Paul.  Now that we have workflow events to update Exchange, we can reduce the sync event to once an hour. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with Exchange'    , N'function::pollExchangeSync', null, null, N'0::*::*::*::*', null, null, N'Inactive', 0;
-- 03/25/2011 Paul.  Add support for Google Apps. 
-- 09/15/2015 Paul.  Change to once per hour now that we support Google Channel Notifications. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with Google Apps' , N'function::pollGoogleSync'  , null, null, N'0::*::*::*::*', null, null, N'Inactive', 0;
-- 12/20/2011 Paul.  Add support for Apple iCloud. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with Apple iCloud', N'function::pollICloudSync'  , null, null, N'*::*::*::*::*', null, null, N'Inactive', 0;
-- 02/17/2018 Paul.  ModulesArchiveRules module to Professional. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Run all Archive Rules' , N'function::RunAllArchiveRules', null, null, N'0::4::1::*::*', null, null, N'Inactive', 0;
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

call dbo.spSCHEDULERS_Professional()
/

call dbo.spSqlDropProcedure('spSCHEDULERS_Professional')
/

-- #endif IBM_DB2 */


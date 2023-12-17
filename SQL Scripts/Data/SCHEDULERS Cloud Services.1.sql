

print 'SCHEDULERS Cloud Services';
GO

set nocount on;
GO

-- 04/27/2015 Paul.  Add support for HubSpot. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with HubSpot'        , N'function::pollHubSpot'        , null, null, N'*::*::*::*::*', null, null, N'Inactive', 0;
-- 05/01/2015 Paul.  Add support for iContact. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with iContact'       , N'function::polliContact'       , null, null, N'*::*::*::*::*', null, null, N'Inactive', 0;
-- 05/03/2015 Paul.  Add support for ConstantContact. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with ConstantContact', N'function::pollConstantContact', null, null, N'*::*::*::*::*', null, null, N'Inactive', 0;
-- 05/06/2015 Paul.  Add support for GetResponse. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with GetResponse'    , N'function::pollGetResponse'    , null, null, N'*::*::*::*::*', null, null, N'Inactive', 0;
-- 05/19/2015 Paul.  Add support for Marketo. Marketo does not have a way to get records after a specified date, so only run once an hour. 
exec dbo.spSCHEDULERS_InsertOnly null, N'Sync with Marketo'        , N'function::pollMarketo'        , null, null, N'0::*::*::*::*', null, null, N'Inactive', 0;
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

call dbo.spSCHEDULERS_CloudServices()
/

call dbo.spSqlDropProcedure('spSCHEDULERS_CloudServices')
/

-- #endif IBM_DB2 */


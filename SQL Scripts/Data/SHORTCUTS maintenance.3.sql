

set nocount on;
GO

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.
if exists(select * from SHORTCUTS where MODULE_NAME = 'TestPlans') begin -- then
	delete from SHORTCUTS 
	 where MODULE_NAME = 'TestPlans';
end -- if;
GO

if exists(select * from SHORTCUTS where MODULE_NAME = 'TestCases') begin -- then
	delete from SHORTCUTS 
	 where MODULE_NAME = 'TestCases';
end -- if;
GO

if exists(select * from SHORTCUTS where MODULE_NAME = 'TestRuns') begin -- then
	delete from SHORTCUTS 
	 where MODULE_NAME = 'TestRuns';
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

call dbo.spSHORTCUTS_maintenance()
/

call dbo.spSqlDropProcedure('spSHORTCUTS_maintenance')
/

-- #endif IBM_DB2 */


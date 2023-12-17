

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.
if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TestPlans.ListView') begin -- then
	delete from GRIDVIEWS_COLUMNS 
	 where GRID_NAME = 'TestPlans.ListView';
end -- if;
GO

if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TestCases.ListView') begin -- then
	delete from GRIDVIEWS_COLUMNS 
	 where GRID_NAME = 'TestCases.ListView';
end -- if;
GO

if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TestRuns.ListView') begin -- then
	delete from GRIDVIEWS_COLUMNS 
	 where GRID_NAME = 'TestRuns.ListView';
end -- if;
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

call dbo.spGRIDVIEWS_COLUMNS_maintenance()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_maintenance')
/

-- #endif IBM_DB2 */


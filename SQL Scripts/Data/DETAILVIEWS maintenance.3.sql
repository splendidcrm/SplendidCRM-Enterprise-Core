

if exists(select * from DETAILVIEWS where VIEW_NAME = 'vwEMAILTEMPLATES_Edit') begin -- then
	update DETAILVIEWS
	   set VIEW_NAME        = 'vwEMAIL_TEMPLATES_Edit'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'vwEMAILTEMPLATES_Edit';
end -- if;
GO

if exists(select * from DETAILVIEWS where VIEW_NAME = 'vwPROJECTTASKS_Edit') begin -- then
	update DETAILVIEWS
	   set VIEW_NAME        = 'vwPROJECT_TASKS_Edit'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'vwPROJECTTASKS_Edit';
end -- if;
GO

if exists(select * from DETAILVIEWS where VIEW_NAME = 'vwPROSPECTLISTS_Edit') begin -- then
	update DETAILVIEWS
	   set VIEW_NAME        = 'vwPROSPECT_LISTS_Edit'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'vwPROSPECTLISTS_Edit';
end -- if;
GO

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.
if exists(select * from DETAILVIEWS where NAME = 'TestPlans.DetailView') begin -- then
	delete from DETAILVIEWS 
	 where NAME = 'TestPlans.DetailView';
end -- if;
GO

if exists(select * from DETAILVIEWS where NAME = 'TestCases.DetailView') begin -- then
	delete from DETAILVIEWS 
	 where NAME = 'TestCases.DetailView';
end -- if;
GO

if exists(select * from DETAILVIEWS where NAME = 'TestRuns.DetailView') begin -- then
	delete from DETAILVIEWS 
	 where NAME = 'TestRuns.DetailView';
end -- if;
GO

-- 05/08/2007 Paul.  Correct name of Project view.  It should be vwPROJECTS_Edit. 
if exists(select * from DETAILVIEWS where VIEW_NAME = 'vwPROJECT_Edit') begin -- then
	update DETAILVIEWS
	   set VIEW_NAME         = 'vwPROJECTS_Edit'
	     , DATE_MODIFIED     = getdate()
	     , MODIFIED_USER_ID  = null
	 where VIEW_NAME         = 'vwPROJECT_Edit';
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

call dbo.spDETAILVIEWS_maintenance()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_maintenance')
/

-- #endif IBM_DB2 */


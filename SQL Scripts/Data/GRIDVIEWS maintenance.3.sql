

if exists(select * from GRIDVIEWS where VIEW_NAME = 'vwEMAILTEMPLATES_List') begin -- then
	update GRIDVIEWS
	   set VIEW_NAME        = 'vwEMAIL_TEMPLATES_List'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'vwEMAILTEMPLATES_List';
end -- if;
GO

if exists(select * from GRIDVIEWS where VIEW_NAME = 'vwPROJECTTASKS_List') begin -- then
	update GRIDVIEWS
	   set VIEW_NAME        = 'vwPROJECT_TASKS_List'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'vwPROJECTTASKS_List';
end -- if;
GO

if exists(select * from GRIDVIEWS where VIEW_NAME = 'vwPROSPECTLISTS_List') begin -- then
	update GRIDVIEWS
	   set VIEW_NAME        = 'vwPROSPECT_LISTS_List'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'vwPROSPECTLISTS_List';
end -- if;
GO

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.
if exists(select * from GRIDVIEWS where NAME = 'TestPlans.ListView') begin -- then
	delete from GRIDVIEWS 
	 where NAME = 'TestPlans.ListView';
end -- if;
GO

if exists(select * from GRIDVIEWS where NAME = 'TestCases.ListView') begin -- then
	delete from GRIDVIEWS 
	 where NAME = 'TestCases.ListView';
end -- if;
GO

if exists(select * from GRIDVIEWS where NAME = 'TestRuns.ListView') begin -- then
	delete from GRIDVIEWS 
	 where NAME = 'TestRuns.ListView';
end -- if;
GO

-- 05/07/2006 Paul.  Fix view name. 
if exists(select * from GRIDVIEWS where NAME = 'Project.ListView' and VIEW_NAME = 'vwPROJECT_List' and  DELETED = 0) begin -- then
	print 'Fix project view name.';
	update GRIDVIEWS
	   set VIEW_NAME        = 'vwPROJECTS_List'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'Project.ListView'
	   and VIEW_NAME        = 'vwPROJECT_List'
	   and DELETED          = 0;
end -- if;

-- 05/07/2006 Paul.  Fix module name. 
if exists(select * from GRIDVIEWS where NAME = 'ProjectTasks.ListView' and DELETED = 0) begin -- then
	print 'Fix project task module name.';
	update GRIDVIEWS
	   set NAME             = 'ProjectTask.ListView'
	     , MODULE_NAME      = 'ProjectTask'
	     , VIEW_NAME        = 'vwPROJECT_TASKS_List'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'ProjectTasks.ListView'
	   and DELETED          = 0;
end -- if;
GO

-- 12/28/2007 Paul.  Fix accoutns orders view name.
if exists(select * from GRIDVIEWS where NAME = 'Accounts.Orders' and VIEW_NAME = 'vwACCOUNTS_INVOICES' and  DELETED = 0) begin -- then
	print 'Fix accoutns orders view name.';
	update GRIDVIEWS
	   set VIEW_NAME        = 'vwACCOUNTS_ORDERS'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'Accounts.Orders'
	   and VIEW_NAME        = 'vwACCOUNTS_INVOICES'
	   and DELETED          = 0;
end -- if;
GO

-- 08/04/2019 Paul.  Correct view names. 
if exists(select * from GRIDVIEWS where NAME = 'SurveyThemes.ListView' and VIEW_NAME = 'vwSURVEY_THEMES_List') begin -- then
	if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'vwSURVEY_THEMES_List') begin -- then
		update GRIDVIEWS
		   set VIEW_NAME         = 'vwSURVEY_THEMES'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where NAME              = 'SurveyThemes.ListView'
		   and VIEW_NAME         = 'vwSURVEY_THEMES_List';
	end -- if;
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

call dbo.spGRIDVIEWS_maintenance()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_maintenance')
/

-- #endif IBM_DB2 */




if exists(select * from EDITVIEWS where VIEW_NAME = 'vwEMAILTEMPLATES_Edit') begin -- then
	update EDITVIEWS
	   set VIEW_NAME        = 'vwEMAIL_TEMPLATES_Edit'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'vwEMAILTEMPLATES_Edit';
end -- if;
GO

if exists(select * from EDITVIEWS where VIEW_NAME = 'vwPROJECTTASKS_Edit') begin -- then
	update EDITVIEWS
	   set VIEW_NAME        = 'vwPROJECT_TASKS_Edit'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'vwPROJECTTASKS_Edit';
end -- if;
GO

if exists(select * from EDITVIEWS where VIEW_NAME = 'vwPROSPECTLISTS_Edit') begin -- then
	update EDITVIEWS
	   set VIEW_NAME        = 'vwPROSPECT_LISTS_Edit'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where VIEW_NAME        = 'vwPROSPECTLISTS_Edit';
end -- if;
GO

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.
if exists(select * from EDITVIEWS where NAME = 'TestPlans.EditView') begin -- then
	delete from EDITVIEWS 
	 where NAME = 'TestPlans.EditView';
end -- if;
GO

if exists(select * from EDITVIEWS where NAME = 'TestCases.EditView') begin -- then
	delete from EDITVIEWS 
	 where NAME = 'TestCases.EditView';
end -- if;
GO

if exists(select * from EDITVIEWS where NAME = 'TestRuns.EditView') begin -- then
	delete from EDITVIEWS 
	 where NAME = 'TestRuns.EditView';
end -- if;
GO

-- 05/08/2007 Paul.  Correct name of Project view.  It should be vwPROJECTS_Edit. 
if exists(select * from EDITVIEWS where VIEW_NAME = 'vwPROJECT_Edit') begin -- then
	update EDITVIEWS
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

call dbo.spEDITVIEWS_maintenance()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_maintenance')
/

-- #endif IBM_DB2 */


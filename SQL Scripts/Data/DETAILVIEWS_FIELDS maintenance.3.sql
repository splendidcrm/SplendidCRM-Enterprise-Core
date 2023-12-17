

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.
if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TestPlans.DetailView') begin -- then
	delete from DETAILVIEWS_FIELDS 
	 where DETAIL_NAME = 'TestPlans.DetailView';
end -- if;
GO

if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TestCases.DetailView') begin -- then
	delete from DETAILVIEWS_FIELDS 
	 where DETAIL_NAME = 'TestCases.DetailView';
end -- if;
GO

if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TestRuns.DetailView') begin -- then
	delete from DETAILVIEWS_FIELDS 
	 where DETAIL_NAME = 'TestRuns.DetailView';
end -- if;
GO

-- 03/19/2009 Paul.  We need to clear fields when using Blank. 
if exists(select * from DETAILVIEWS_FIELDS where FIELD_TYPE = N'Blank' and DATA_FIELD is not null and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS: Cleanup Blank fields';
	update DETAILVIEWS_FIELDS
	   set DATA_LABEL         = null
	     , DATA_FIELD         = null
	     , DATA_FORMAT        = null
	     , URL_FIELD          = null
	     , URL_FORMAT         = null
	     , URL_TARGET         = null
	     , LIST_NAME          = null
	     , MODIFIED_USER_ID   = null
	     , DATE_MODIFIED      = getdate()
	 where FIELD_TYPE = N'Blank'
	   and DATA_FIELD is not null
	   and DELETED    = 0;
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

call dbo.spDETAILVIEWS_FIELDS_maintenance()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_maintenance')
/

-- #endif IBM_DB2 */


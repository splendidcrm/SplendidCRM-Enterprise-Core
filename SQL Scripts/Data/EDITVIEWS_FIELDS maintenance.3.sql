

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.
if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TestPlans.EditView') begin -- then
	delete from EDITVIEWS_FIELDS 
	 where EDIT_NAME = 'TestPlans.EditView';
end -- if;
GO

if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TestCases.EditView') begin -- then
	delete from EDITVIEWS_FIELDS 
	 where EDIT_NAME = 'TestCases.EditView';
end -- if;
GO

if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TestRuns.EditView') begin -- then
	delete from EDITVIEWS_FIELDS 
	 where EDIT_NAME = 'TestRuns.EditView';
end -- if;
GO

-- 03/19/2009 Paul.  We need to clear fields when using Blank. 
if exists(select * from EDITVIEWS_FIELDS where FIELD_TYPE = N'Blank' and DATA_FIELD is not null and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS: Cleanup Blank fields';
	update EDITVIEWS_FIELDS
	   set DATA_LABEL         = null
	     , DATA_FIELD         = null
	     , DISPLAY_FIELD      = null
	     , CACHE_NAME         = null
	     , DATA_REQUIRED      = null
	     , UI_REQUIRED        = null
	     , ONCLICK_SCRIPT     = null
	     , FORMAT_SCRIPT      = null
	     , FORMAT_TAB_INDEX   = null
	     , FORMAT_MAX_LENGTH  = null
	     , FORMAT_SIZE        = null
	     , FORMAT_ROWS        = null
	     , FORMAT_COLUMNS     = null
	     , ROWSPAN            = null
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

call dbo.spEDITVIEWS_FIELDS_maintenance()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_maintenance')
/

-- #endif IBM_DB2 */


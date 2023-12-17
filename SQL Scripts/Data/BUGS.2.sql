

if exists(select *
            from GRIDVIEWS_COLUMNS
           where GRID_NAME  = 'Bugs.ListView'
             and DATA_FIELD = 'RELEASE'
             ) begin -- then
	update GRIDVIEWS_COLUMNS
	   set DATA_FIELD      = 'FOUND_IN_RELEASE'
	     , SORT_EXPRESSION = 'FOUND_IN_RELEASE'
	 where GRID_NAME       = 'Bugs.ListView'
	   and DATA_FIELD      = 'RELEASE';
end -- if;
GO


if exists(select *
            from DETAILVIEWS_FIELDS
           where DETAIL_NAME = 'Bugs.DetailView'
             and DATA_FIELD  = 'RELEASE'
             ) begin -- then
	update DETAILVIEWS_FIELDS
	   set DATA_FIELD  = 'FOUND_IN_RELEASE'
	 where DETAIL_NAME = 'Bugs.DetailView'
	   and DATA_FIELD  = 'RELEASE';
end -- if;
GO

	
if exists(select *
            from EDITVIEWS_FIELDS
           where EDIT_NAME  = 'Bugs.EditView'
             and DATA_FIELD = 'RELEASE'
             ) begin -- then
	update EDITVIEWS_FIELDS
	   set DATA_FIELD  = 'FOUND_IN_RELEASE'
	 where EDIT_NAME   = 'Bugs.EditView'
	   and DATA_FIELD  = 'RELEASE';
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

call dbo.spBUGS_Defaults()
/

call dbo.spSqlDropProcedure('spBUGS_Defaults')
/

-- #endif IBM_DB2 */


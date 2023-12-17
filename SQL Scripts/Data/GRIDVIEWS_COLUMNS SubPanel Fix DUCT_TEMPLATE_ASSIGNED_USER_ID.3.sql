

set nocount on;
GO

-- 03/05/2022 Paul.  The issue resides in GRIDVIEWS_COLUMNS module.2.sql with right(replace(URL_FIELD, N'_ID', N'_'). 
if exists(select * from vwGRIDVIEWS_COLUMNS where URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SubPanel Fix DUCT_TEMPLATE_ASSIGNED_USER_ID';
	update GRIDVIEWS_COLUMNS
	   set URL_ASSIGNED_FIELD = null
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID'
	   and DELETED = 0;
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

call dbo.spGRIDVIEWS_COLUMNS_Fix_DUCT_TEMPLATE_ASSIGNED_USER_ID()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_Fix_DUCT_TEMPLATE_ASSIGNED_USER_ID')
/

-- #endif IBM_DB2 */


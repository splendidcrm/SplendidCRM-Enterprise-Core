

print 'GRIDVIEWS_COLUMNS ReportRules';
GO

set nocount on;
GO

-- 05/19/2021 Paul.  Correct GRIDVIEWS table name. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ReportRules.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ReportRules.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ReportRules.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'ReportRules.ListView', 'ReportRules', 'vwREPORT_RULES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ReportRules.ListView'       , 2, 'Rules.LBL_LIST_NAME'                      , 'NAME'                 , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID'         , '~/Reports/ReportRules/edit.aspx?id={0}', null, 'ReportRules', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ReportRules.ListView'       , 3, 'Rules.LBL_LIST_MODULE_NAME'               , 'MODULE_NAME'          , 'MODULE_NAME'     , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ReportRules.ListView'       , 4, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'        , 'DATE_MODIFIED'   , '20%';
end else begin
	if exists(select * from GRIDVIEWS where NAME = 'ReportRules.ListView' and VIEW_NAME = 'vwREPORTS_List' and DELETED = 0) begin -- then
		update GRIDVIEWS
		   set VIEW_NAME         = 'vwREPORT_RULES'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where NAME              = 'ReportRules.ListView'
		   and VIEW_NAME         = 'vwREPORTS_List'
		   and DELETED           = 0;
	end -- if;
	-- 05/19/2021 Paul.  ReportRules is not assigned. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ReportRules.ListView' and URL_ASSIGNED_FIELD is not null and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where GRID_NAME          = 'ReportRules.ListView'
		   and URL_ASSIGNED_FIELD is not null
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 05/19/2021 Paul.  Correct GRIDVIEWS table name. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ReportRules.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ReportRules.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ReportRules.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'ReportRules.PopupView', 'ReportRules', 'vwREPORT_RULES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ReportRules.PopupView'      , 1, 'Rules.LBL_LIST_NAME'                      , 'NAME'                 , 'NAME'            , '50%', 'listViewTdLinkS1', 'ID NAME'    , 'SelectReportRule(''{0}'', ''{1}'');', null, 'ReportRules', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ReportRules.PopupView'      , 2, 'Rules.LBL_LIST_MODULE_NAME'               , 'MODULE_NAME'          , 'MODULE_NAME'     , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ReportRules.PopupView'      , 3, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'        , 'DATE_MODIFIED'   , '20%';
end else begin
	if exists(select * from GRIDVIEWS where NAME = 'ReportRules.PopupView' and VIEW_NAME = 'vwREPORTS_List' and DELETED = 0) begin -- then
		update GRIDVIEWS
		   set VIEW_NAME         = 'vwREPORT_RULES'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where NAME              = 'ReportRules.PopupView'
		   and VIEW_NAME         = 'vwREPORTS_List'
		   and DELETED           = 0;
	end -- if;
	-- 05/19/2021 Paul.  ReportRules is not assigned. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ReportRules.PopupView' and URL_ASSIGNED_FIELD is not null and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where GRID_NAME          = 'ReportRules.PopupView'
		   and URL_ASSIGNED_FIELD is not null
		   and DELETED            = 0;
	end -- if;
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

call dbo.spGRIDVIEWS_COLUMNS_ReportRules()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ReportRules')
/

-- #endif IBM_DB2 */


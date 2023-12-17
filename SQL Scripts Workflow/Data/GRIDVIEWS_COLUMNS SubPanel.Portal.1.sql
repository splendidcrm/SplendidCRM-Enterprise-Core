

print 'GRIDVIEWS_COLUMNS SubPanel Portal';
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like '%.My%.Portal'
--GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Bugs.MyBugs.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Bugs.MyBugs.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Bugs.MyBugs.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Bugs.MyBugs.Portal', 'Bugs', 'vwBUGS_MyList';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.MyBugs.Portal'         , 0, 'Bugs.LBL_LIST_NUMBER'                     , 'BUG_NUMBER'                , 'BUG_NUMBER'                , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Bugs.MyBugs.Portal'         , 1, 'Bugs.LBL_LIST_SUBJECT'                    , 'NAME'                      , 'NAME'                      , '30%', 'listViewTdLinkS1', 'ID', '~/Bugs/view.aspx?id={0}', null, 'Bugs', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.MyBugs.Portal'         , 2, 'Bugs.LBL_LIST_STATUS'                     , 'STATUS'                    , 'STATUS'                    , '10%', 'bug_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.MyBugs.Portal'         , 3, 'Bugs.LBL_LIST_TYPE'                       , 'TYPE'                      , 'TYPE'                      , '10%', 'bug_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.MyBugs.Portal'         , 4, 'Bugs.LBL_LIST_PRIORITY'                   , 'PRIORITY'                  , 'PRIORITY'                  , '10%', 'bug_priority_dom';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.MyCases.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.MyCases.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Cases.MyCases.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Cases.MyCases.Portal', 'Cases', 'vwCASES_MyList';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.MyCases.Portal'       , 0, 'Cases.LBL_LIST_SUBJECT'                   , 'NAME'                      , 'NAME'                      , '60%', 'listViewTdLinkS1', 'ID'        , '~/Cases/view.aspx?id={0}'   , null, 'Cases', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.MyCases.Portal'       , 1, 'Cases.LBL_LIST_PRIORITY'                  , 'PRIORITY'                  , 'PRIORITY'                  , '20%', 'case_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.MyCases.Portal'       , 2, 'Cases.LBL_LIST_STATUS'                    , 'STATUS'                    , 'STATUS'                    , '20%', 'case_status_dom';
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

call dbo.spGRIDVIEWS_COLUMNS_SubPanelsPortal()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_SubPanelsPortal')
/

-- #endif IBM_DB2 */


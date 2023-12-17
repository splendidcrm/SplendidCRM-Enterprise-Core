

print 'GRIDVIEWS_COLUMNS Processes';
GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Processes.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Processes.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Processes.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly             'Processes.ListView', 'Processes', 'vwPROCESSES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Processes.ListView'     ,  0, 'Processes.LBL_LIST_PROCESS_NUMBER'       , 'PROCESS_NUMBER'       , 'PROCESS_NUMBER'       , '4%', 'listViewTdLinkS1', 'ID', '~/Processes/view.aspx?id={0}', null, 'Processes', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'Processes.ListView'     ,  1, 'Processes.LBL_LIST_PARENT_NAME'          , 'PARENT_NAME'          , 'PARENT_NAME'          , '20%', 'listViewTdLinkS1', 'PARENT_TYPE PARENT_ID', '~/{0}/view.aspx?id={1}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Processes.ListView'     ,  2, 'Processes.LBL_LIST_BUSINESS_PROCESS_NAME', 'BUSINESS_PROCESS_NAME', 'BUSINESS_PROCESS_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Processes.ListView'     ,  3, 'Processes.LBL_LIST_ACTIVITY_NAME'        , 'ACTIVITY_NAME'        , 'ACTIVITY_NAME'        , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Processes.ListView'     ,  4, 'Processes.LBL_LIST_STATUS'               , 'STATUS'               , 'STATUS'               , '10%', 'process_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'Processes.ListView'     ,  5, '.LBL_LIST_DATE_ENTERED'                  , 'DATE_ENTERED'         , 'DATE_ENTERED'         , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Processes.ListView'     ,  6, '.LBL_LIST_ASSIGNED_USER'                 , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Processes.ListView'     ,  7, 'Processes.LBL_LIST_PROCESS_USER_NAME'    , 'PROCESS_USER_NAME'    , 'PROCESS_USER_NAME'    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'Processes.ListView'     ,  8, 'Processes.LBL_LIST_PROCESS_OWNER_NAME'   , 'PROCESS_OWNER_NAME'   , 'PROCESS_OWNER_NAME'   , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Processes.ListView'     ,  9, null, '1%', 'ID', 'Preview', 'preview_inline';
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

call dbo.spGRIDVIEWS_COLUMNS_Processes()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_Processes')
/

-- #endif IBM_DB2 */


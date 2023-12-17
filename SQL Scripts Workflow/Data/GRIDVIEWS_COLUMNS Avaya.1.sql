

print 'GRIDVIEWS_COLUMNS Avaya';
GO

set nocount on;
GO

-- 12/03/2013 Paul.  Add layout for Avaya. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Avaya.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Avaya.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Avaya.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Avaya.ListView', 'Avaya', 'vwCALL_DETAIL_RECORDS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Avaya.ListView'     ,  1, 'Avaya.LBL_LIST_UNIQUEID'           , 'UNIQUEID'           , 'UNIQUEID'           , '5%', 'listViewTdLinkS1', 'ID', '~/Administration/Avaya/view.aspx?id={0}', null, 'Avaya', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Avaya.ListView'     ,  2, 'Avaya.LBL_LIST_CALLERID'           , 'CALLERID'           , 'CALLERID'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Avaya.ListView'     ,  3, 'Avaya.LBL_LIST_PARENT_NAME'        , 'PARENT_NAME'        , 'PARENT_NAME'        , '14%', 'listViewTdLinkS1', 'PARENT_TYPE PARENT_ID', '~/{0}/view.aspx?id={1}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Avaya.ListView'     ,  4, 'Avaya.LBL_LIST_START_TIME'         , 'START_TIME'         , 'START_TIME'         , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Avaya.ListView'     ,  5, 'Avaya.LBL_LIST_END_TIME'           , 'END_TIME'           , 'END_TIME'           , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Avaya.ListView'     ,  7, 'Avaya.LBL_LIST_DURATION'           , 'DURATION'           , 'DURATION'           , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Avaya.ListView'     ,  8, 'Avaya.LBL_LIST_SOURCE'             , 'SOURCE'             , 'SOURCE'             , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Avaya.ListView'     ,  9, 'Avaya.LBL_LIST_DESTINATION'        , 'DESTINATION'        , 'DESTINATION'        , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Avaya.ListView'     , 10, 'Avaya.LBL_LIST_DISPOSITION'        , 'DISPOSITION'        , 'DISPOSITION'        , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Avaya.ListView'     , 11, 'Avaya.LBL_LIST_AMA_FLAGS'          , 'AMA_FLAGS'          , 'AMA_FLAGS'          , '10%';
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

call dbo.spGRIDVIEWS_COLUMNS_Avaya()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_Avaya')
/

-- #endif IBM_DB2 */


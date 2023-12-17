

print 'GRIDVIEWS_COLUMNS Offline';

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Offline.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Offline.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Offline.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Offline.ListView', 'Offline', 'vwOFFLINE_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Offline.ListView', 0, 'Offline.LBL_LIST_MODULE_NAME'   , 'MODULE_NAME'   , 'MODULE_NAME'   , '40%', 'listViewTdLinkS1', 'MODULE_NAME', '~/Offline/default.aspx'  , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Offline.ListView', 1, 'Offline.LBL_LIST_CONFLICTS'     , 'CONFLICTS'     , 'CONFLICTS'     , '20%', 'listViewTdLinkS1', 'MODULE_NAME', '~/Conflicts/default.aspx', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Offline.ListView', 2, 'Offline.LBL_LIST_LOCAL_UPDATES' , 'LOCAL_UPDATES' , 'LOCAL_UPDATES' , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Offline.ListView', 3, 'Offline.LBL_LIST_REMOTE_UPDATES', 'REMOTE_UPDATES', 'REMOTE_UPDATES', '20%';
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

call dbo.spGRIDVIEWS_COLUMNS_Offline()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_Offline')
/

-- #endif IBM_DB2 */


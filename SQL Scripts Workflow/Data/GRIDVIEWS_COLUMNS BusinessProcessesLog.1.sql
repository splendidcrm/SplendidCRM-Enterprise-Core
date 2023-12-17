

print 'GRIDVIEWS_COLUMNS BusinessProcessesLog';
GO

set nocount on;
GO

-- 02/24/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcessesLog.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcessesLog.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS BusinessProcessesLog.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'BusinessProcessesLog.ListView' , 'BusinessProcessesLog', 'vwBUSINESS_PROCESSES_RUN_EventLog';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.ListView' , 0, '.LBL_LIST_DATE_ENTERED'                                  , 'DATE_ENTERED'                , 'DATE_ENTERED'                , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'BusinessProcessesLog.ListView' , 1, 'BusinessProcesses.LBL_LIST_NAME'                         , 'NAME'                        , 'NAME'                        , '20%', 'listViewTdLinkS1', 'BUSINESS_PROCESS_ID', '~/Administration/BusinessProcesses/view.aspx?ID={0}', null, 'BusinessProcesses', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.ListView' , 2, 'BusinessProcesses.LBL_LIST_STATUS'                       , 'STATUS'                      , 'STATUS'                      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.ListView' , 3, 'BusinessProcesses.LBL_LIST_START_DATE'                   , 'START_DATE'                  , 'START_DATE'                  , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.ListView' , 4, 'BusinessProcesses.LBL_LIST_END_DATE'                     , 'END_DATE'                    , 'END_DATE'                    , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.ListView' , 5, 'BusinessProcesses.LBL_LIST_DESCRIPTION'                  , 'DESCRIPTION'                 , 'DESCRIPTION'                 , '30%';
	--exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.ListView' , 6, 'BusinessProcesses.LBL_LIST_BUSINESS_PROCESS_INSTANCE_ID' , 'BUSINESS_PROCESS_INSTANCE_ID', 'BUSINESS_PROCESS_INSTANCE_ID', '20%';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcessesLog.ListView' and URL_ASSIGNED_FIELD = 'ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where GRID_NAME          = 'BusinessProcessesLog.ListView'
		   and URL_ASSIGNED_FIELD = 'ASSIGNED_USER_ID'
		   and DELETED            = 0;
	end -- if;
	-- 02/24/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'BusinessProcessesLog.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'BusinessProcessesLog.ListView', 'DATE_ENTERED', 'desc';
	end -- if;
end -- if;
GO

-- 03/11/2021 Paul.  The React client defaults to float number formatting. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcessesLog.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcessesLog.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS BusinessProcessesLog.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'BusinessProcessesLog.PopupView', 'BusinessProcessesLog', 'vwWF4_INSTANCE_EVENTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.PopupView', 0, 'BusinessProcessesLog.LBL_LIST_EVENT_TIME'                , 'EVENT_TIME'                  , 'EVENT_TIME'                  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.PopupView', 1, 'BusinessProcessesLog.LBL_LIST_EVENT_TYPE'                , 'EVENT_TYPE'                  , 'EVENT_TYPE'                  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.PopupView', 2, 'BusinessProcessesLog.LBL_LIST_RECORD_NUMBER'             , 'RECORD_NUMBER'               , 'RECORD_NUMBER'               , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.PopupView', 3, 'BusinessProcessesLog.LBL_LIST_STATE'                     , 'STATE'                       , 'STATE'                       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.PopupView', 4, 'BusinessProcessesLog.LBL_LIST_ACTIVITY'                  , 'ACTIVITY'                    , 'ACTIVITY'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.PopupView', 5, 'BusinessProcessesLog.LBL_LIST_ACTIVITY_NAME'             , 'ACTIVITY_NAME'               , 'ACTIVITY_NAME'               , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcessesLog.PopupView', 6, 'BusinessProcessesLog.LBL_LIST_DESCRIPTION'               , 'DESCRIPTION'                 , 'DESCRIPTION'                 , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'BusinessProcessesLog.PopupView', 0, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'BusinessProcessesLog.PopupView',  'RECORD_NUMBER', '{0:N0}';
end else begin
	-- 03/11/2021 Paul.  The React client defaults to float number formatting. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcessesLog.PopupView' and DATA_FIELD = 'RECORD_NUMBER' and DATA_FORMAT is null and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set DATA_FORMAT        = '{0:N0}'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where GRID_NAME          = 'BusinessProcessesLog.PopupView'
		   and DATA_FIELD         = 'RECORD_NUMBER'
		   and DATA_FORMAT        is null
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 04/15/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcesses.Events';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcesses.Events' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS BusinessProcesses.Events';
	exec dbo.spGRIDVIEWS_InsertOnly           'BusinessProcesses.Events'      , 'BusinessProcesses', 'vwBUSINESS_PROCESSES_RUN_EventLog', 'DATE_ENTERED', 'desc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcesses.Events'      , 0, '.LBL_LIST_DATE_ENTERED'                                  , 'DATE_ENTERED'                , 'DATE_ENTERED'                , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcesses.Events'      , 1, 'BusinessProcesses.LBL_LIST_STATUS'                       , 'STATUS'                      , 'STATUS'                      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcesses.Events'      , 2, 'BusinessProcesses.LBL_LIST_START_DATE'                   , 'START_DATE'                  , 'START_DATE'                  , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcesses.Events'      , 3, 'BusinessProcesses.LBL_LIST_END_DATE'                     , 'END_DATE'                    , 'END_DATE'                    , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcesses.Events'      , 4, 'BusinessProcesses.LBL_LIST_DESCRIPTION'                  , 'DESCRIPTION'                 , 'DESCRIPTION'                 , '50%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'BusinessProcesses.Events'      , 5, 'BusinessProcesses.LBL_LIST_BUSINESS_PROCESS_INSTANCE_ID' , 'BUSINESS_PROCESS_INSTANCE_ID', 'BUSINESS_PROCESS_INSTANCE_ID', '20%';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'BusinessProcesses.Events' and URL_ASSIGNED_FIELD = 'ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where GRID_NAME          = 'BusinessProcesses.Events'
		   and URL_ASSIGNED_FIELD = 'ASSIGNED_USER_ID'
		   and DELETED            = 0;
	end -- if;
	-- 04/15/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	-- select * from GRIDVIEWS where NAME = 'BusinessProcesses.Events'
	if exists(select * from GRIDVIEWS where NAME = 'BusinessProcesses.Events' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'BusinessProcesses.Events', 'DATE_ENTERED', 'desc';
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

call dbo.spGRIDVIEWS_COLUMNS_BusinessProcessesLog()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_BusinessProcessesLog')
/

-- #endif IBM_DB2 */


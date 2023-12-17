

print 'GRIDVIEWS_COLUMNS Workflows';
GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Workflows.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Workflows.ListView'             , 'Workflows', 'vwWORKFLOWS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Workflows.ListView'             , 0, 'Workflows.LBL_LIST_NAME'                         , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID', 'view.aspx?ID={0}', null, 'Workflows', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Workflows.ListView'             , 1, 'Workflows.LBL_LIST_TYPE'                         , 'TYPE'            , 'TYPE'            , '25%', 'workflow_type_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Workflows.ListView'             , 2, 'Workflows.LBL_LIST_BASE_MODULE'                  , 'BASE_MODULE'     , 'BASE_MODULE'     , '25%', 'WorkflowModules';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Workflows.ListView'             , 3, 'Workflows.LBL_LIST_STATUS'                       , 'STATUS'          , 'STATUS'          , '10%', 'workflow_status_dom';
end -- if;
GO

-- 07/26/2010 Paul.  New list that allows the first column to be a drag column. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.SequenceView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.SequenceView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Workflows.SequenceView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Workflows.SequenceView'         , 'Workflows', 'vwWORKFLOWS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Workflows.SequenceView'         , 1, 'Workflows.LBL_LIST_NAME'                         , 'NAME'            , 'NAME'            , '39%', 'listViewTdLinkS1', 'ID', 'view.aspx?ID={0}', null, 'Workflows', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Workflows.SequenceView'         , 2, 'Workflows.LBL_LIST_TYPE'                         , 'TYPE'            , 'TYPE'            , '25%', 'workflow_type_dom'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Workflows.SequenceView'         , 3, 'Workflows.LBL_LIST_BASE_MODULE'                  , 'BASE_MODULE'     , 'BASE_MODULE'     , '25%', 'WorkflowModules';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Workflows.SequenceView'         , 4, 'Workflows.LBL_LIST_STATUS'                       , 'STATUS'          , 'STATUS'          , '10%', 'workflow_status_dom';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.WorkflowTriggerShells';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.WorkflowTriggerShells' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Workflows.WorkflowTriggerShells';
	exec dbo.spGRIDVIEWS_InsertOnly           'Workflows.WorkflowTriggerShells', 'Workflows', 'vwWORKFLOW_TRIGGER_SHELLS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Workflows.WorkflowTriggerShells', 0, 'WorkflowTriggerShells.LBL_LIST_DESCRIPTION'      , 'DESCRIPTION'     , null              , '70%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Workflows.WorkflowTriggerShells', 1, 'WorkflowTriggerShells.LBL_LIST_VALUE'            , 'VALUE'           , null              , '30%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowAlertTemplates.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowAlertTemplates.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS WorkflowAlertTemplates.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'WorkflowAlertTemplates.ListView', 'WorkflowAlertTemplates', 'vwWORKFLOW_ALERT_TEMPLATES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'WorkflowAlertTemplates.ListView', 0, 'WorkflowAlertTemplates.LBL_LIST_NAME'            , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID', 'view.aspx?ID={0}', null, 'WorkflowAlertTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'WorkflowAlertTemplates.ListView', 1, 'WorkflowAlertTemplates.LBL_LIST_BASE_MODULE'     , 'BASE_MODULE'     , 'BASE_MODULE'     , '20%', 'WorkflowModules';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowAlertTemplates.ListView', 2, 'WorkflowAlertTemplates.LBL_LIST_FROM_ADDR'       , 'FROM_ADDR'       , 'FROM_ADDR'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowAlertTemplates.ListView', 3, 'WorkflowAlertTemplates.LBL_LIST_FROM_NAME'       , 'FROM_NAME'       , 'FROM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowAlertTemplates.ListView', 4, 'WorkflowAlertTemplates.LBL_LIST_SUBJECT'         , 'SUBJECT'         , 'SUBJECT'         , '20%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowAlertShells.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowAlertShells.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS WorkflowAlertShells.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'WorkflowAlertShells.ListView'   , 'WorkflowAlertShells', 'vwWORKFLOW_ALERT_SHELLS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'WorkflowAlertShells.ListView'   , 0, 'WorkflowAlertShells.LBL_LIST_NAME'               , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'ID', '~/Administration/WorkflowAlertShells/view.aspx?ID={0}', null, 'WorkflowAlertShells', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'WorkflowAlertShells.ListView'   , 1, 'WorkflowAlertShells.LBL_LIST_SOURCE_TYPE'        , 'SOURCE_TYPE'     , 'SOURCE_TYPE'     , '20%', 'workflow_source_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'WorkflowAlertShells.ListView'   , 2, 'WorkflowAlertShells.LBL_LIST_ALERT_TYPE'         , 'ALERT_TYPE'      , 'ALERT_TYPE'      , '20%', 'workflow_alert_type_dom';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.WorkflowAlertShells';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.WorkflowAlertShells' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Workflows.WorkflowAlertShells';
	exec dbo.spGRIDVIEWS_InsertOnly           'Workflows.WorkflowAlertShells'  , 'WorkflowAlertShells', 'vwWORKFLOW_ALERT_SHELLS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Workflows.WorkflowAlertShells'  , 0, 'WorkflowAlertShells.LBL_LIST_NAME'               , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'ID', '~/Administration/WorkflowAlertShells/edit.aspx?ID={0}', null, 'WorkflowAlertShells', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Workflows.WorkflowAlertShells'  , 1, 'WorkflowAlertShells.LBL_LIST_SOURCE_TYPE'        , 'SOURCE_TYPE'     , 'SOURCE_TYPE'     , '20%', 'workflow_source_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Workflows.WorkflowAlertShells'  , 2, 'WorkflowAlertShells.LBL_LIST_ALERT_TYPE'         , 'ALERT_TYPE'      , 'ALERT_TYPE'      , '20%', 'workflow_alert_type_dom';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.WorkflowActionShells';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.WorkflowActionShells' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Workflows.WorkflowActionShells';
	exec dbo.spGRIDVIEWS_InsertOnly           'Workflows.WorkflowActionShells' , 'WorkflowActionShells', 'vwWORKFLOW_ACTION_SHELLS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Workflows.WorkflowActionShells' , 0, 'WorkflowActionShells.LBL_LIST_NAME'              , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'ID', '~/Administration/WorkflowActionShells/edit.aspx?ID={0}', null, 'WorkflowActionShells', null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.Events';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Workflows.Events' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Workflows.Events';
	exec dbo.spGRIDVIEWS_InsertOnly           'Workflows.Events'               , 'Workflows', 'vwWORKFLOW_RUN';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Workflows.Events'               , 0, '.LBL_LIST_DATE_ENTERED'                          , 'DATE_ENTERED'        , 'DATE_ENTERED'        , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Workflows.Events'               , 1, 'Workflows.LBL_LIST_STATUS'                       , 'STATUS'              , 'STATUS'              , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Workflows.Events'               , 2, 'Workflows.LBL_LIST_START_DATE'                   , 'START_DATE'          , 'START_DATE'          , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Workflows.Events'               , 3, 'Workflows.LBL_LIST_END_DATE'                     , 'END_DATE'            , 'END_DATE'            , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Workflows.Events'               , 4, 'Workflows.LBL_LIST_DESCRIPTION'                  , 'DESCRIPTION'         , 'DESCRIPTION'         , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Workflows.Events'               , 5, 'Workflows.LBL_LIST_WORKFLOW_INSTANCE_ID'         , 'WORKFLOW_INSTANCE_ID', 'WORKFLOW_INSTANCE_ID', '20%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowEventLog.PopupView';
-- 12/03/2008 Paul.  We need the AUDIT_ID to debug workflows. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowEventLog.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS WorkflowEventLog.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'WorkflowEventLog.PopupView'     , 'WorkflowEventLog', 'vwWORKFLOW_RUN';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.PopupView'     , 0, 'WorkflowEventLog.LBL_LIST_NAME'                    , 'NAME'                    , 'NAME'                    , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.PopupView'     , 1, 'WorkflowEventLog.LBL_LIST_BASE_MODULE'             , 'BASE_MODULE'             , 'BASE_MODULE'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.PopupView'     , 2, 'WorkflowEventLog.LBL_LIST_EVENT_DATE_TIME'         , 'EVENT_DATE_TIME'         , 'EVENT_DATE_TIME'         , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.PopupView'     , 3, 'WorkflowEventLog.LBL_LIST_TRACKING_WORKFLOW_EVENT' , 'TRACKING_WORKFLOW_EVENT' , 'TRACKING_WORKFLOW_EVENT' , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.PopupView'     , 4, 'WorkflowEventLog.LBL_LIST_EVENT_ARG_TYPE_FULL_NAME', 'EVENT_ARG_TYPE_FULL_NAME', 'EVENT_ARG_TYPE_FULL_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.PopupView'     , 5, 'WorkflowEventLog.LBL_LIST_DESCRIPTION'             , 'DESCRIPTION'             , 'DESCRIPTION'             , '40%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.PopupView'     , 6, 'WorkflowEventLog.LBL_LIST_AUDIT_ID'                , 'AUDIT_ID'                , 'AUDIT_ID'                , '10%';
end else begin
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowEventLog.PopupView' and DATA_FIELD = 'AUDIT_ID' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.PopupView'     , 6, 'WorkflowEventLog.LBL_LIST_AUDIT_ID'                , 'AUDIT_ID'                , 'AUDIT_ID'                , '10%';
	end -- if;
end -- if;
GO

-- 02/24/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowEventLog.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowEventLog.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS WorkflowEventLog.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'WorkflowEventLog.ListView'      , 'WorkflowEventLog', 'vwWORKFLOW_RUN_EventLog', 'DATE_ENTERED', 'desc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.ListView'      , 0, '.LBL_LIST_DATE_ENTERED'                          , 'DATE_ENTERED'        , 'DATE_ENTERED'        , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'WorkflowEventLog.ListView'      , 1, 'Workflows.LBL_LIST_NAME'                         , 'NAME'                , 'NAME'                , '10%', 'listViewTdLinkS1', 'WORKFLOW_ID', '~/Administration/Workflows/view.aspx?ID={0}', null, 'Workflows', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.ListView'      , 2, 'Workflows.LBL_LIST_STATUS'                       , 'STATUS'              , 'STATUS'              , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.ListView'      , 3, 'Workflows.LBL_LIST_START_DATE'                   , 'START_DATE'          , 'START_DATE'          , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.ListView'      , 4, 'Workflows.LBL_LIST_END_DATE'                     , 'END_DATE'            , 'END_DATE'            , '12%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.ListView'      , 5, 'Workflows.LBL_LIST_DESCRIPTION'                  , 'DESCRIPTION'         , 'DESCRIPTION'         , '24%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowEventLog.ListView'      , 6, 'Workflows.LBL_LIST_WORKFLOW_INSTANCE_ID'         , 'WORKFLOW_INSTANCE_ID', 'WORKFLOW_INSTANCE_ID', '20%';
end else begin
	-- 02/24/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'WorkflowEventLog.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'WorkflowEventLog.ListView', 'DATE_ENTERED', 'desc';
	end -- if;
end -- if;
GO

-- 07/09/2016 Paul.  Business Processes needs a popup view. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowAlertTemplates.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'WorkflowAlertTemplates.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS WorkflowAlertTemplates.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'WorkflowAlertTemplates.PopupView', 'WorkflowAlertTemplates', 'vwWORKFLOW_ALERT_TEMPLATES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'WorkflowAlertTemplates.PopupView', 0, 'WorkflowAlertTemplates.LBL_LIST_NAME'           , 'NAME'            , 'NAME'            , '30%', 'PopupViewTdLinkS1', 'ID', 'view.aspx?ID={0}', null, 'WorkflowAlertTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'WorkflowAlertTemplates.PopupView', 1, 'WorkflowAlertTemplates.LBL_LIST_BASE_MODULE'    , 'BASE_MODULE'     , 'BASE_MODULE'     , '20%', 'moduleList';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowAlertTemplates.PopupView', 2, 'WorkflowAlertTemplates.LBL_LIST_FROM_ADDR'      , 'FROM_ADDR'       , 'FROM_ADDR'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowAlertTemplates.PopupView', 3, 'WorkflowAlertTemplates.LBL_LIST_FROM_NAME'      , 'FROM_NAME'       , 'FROM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'WorkflowAlertTemplates.PopupView', 4, 'WorkflowAlertTemplates.LBL_LIST_SUBJECT'        , 'SUBJECT'         , 'SUBJECT'         , '30%';
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

call dbo.spGRIDVIEWS_COLUMNS_Workflows()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_Workflows')
/

-- #endif IBM_DB2 */


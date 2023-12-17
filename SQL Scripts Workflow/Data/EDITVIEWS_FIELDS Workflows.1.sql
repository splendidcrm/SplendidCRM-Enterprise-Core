

print 'EDITVIEWS_FIELDS Workflows';
GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Workflows.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Workflows.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Workflows.EditView';
	exec dbo.spEDITVIEWS_InsertOnly          'Workflows.EditView'      , 'Workflows', 'vwWORKFLOWS_Edit', '15%', '35%';
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Workflows.EditView'      ,  0, 'Workflows.LBL_NAME'                     , 'NAME'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Workflows.EditView'      ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView'      ,  2, 'Workflows.LBL_TYPE'                     , 'TYPE'                       , 1, 1, 'workflow_type_dom'       , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView'      ,  3, 'Workflows.LBL_STATUS'                   , 'STATUS'                     , 1, 1, 'workflow_status_dom'     , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView'      ,  4, 'Workflows.LBL_BASE_MODULE'              , 'BASE_MODULE'                , 1, 1, 'WorkflowModules'         , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView'      ,  5, 'Workflows.LBL_RECORD_TYPE'              , 'RECORD_TYPE'                , 1, 1, 'workflow_record_type_dom', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView'      ,  6, 'Workflows.LBL_FIRE_ORDER'               , 'FIRE_ORDER'                 , 1, 1, 'workflow_fire_order_dom' , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Workflows.EditView'      ,  7, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Workflows.EditView'      ,  8, 'Workflows.LBL_DESCRIPTION'              , 'DESCRIPTION'                , 0, 2,   4, 60, 3;
end -- if;
GO

-- 06/03/2021 Paul.  Separate layout for timed workflow. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Workflows.EditView.Timed';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Workflows.EditView.Timed' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Workflows.EditView.Timed';
	exec dbo.spEDITVIEWS_InsertOnly          'Workflows.EditView.Timed'      , 'Workflows', 'vwWORKFLOWS_Edit', '15%', '35%';
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Workflows.EditView.Timed'      ,  0, 'Workflows.LBL_NAME'                     , 'NAME'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Workflows.EditView.Timed'      ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView.Timed'      ,  2, 'Workflows.LBL_TYPE'                     , 'TYPE'                       , 1, 1, 'workflow_type_dom'       , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView.Timed'      ,  3, 'Workflows.LBL_STATUS'                   , 'STATUS'                     , 1, 1, 'workflow_status_dom'     , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView.Timed'      ,  4, 'Workflows.LBL_BASE_MODULE'              , 'BASE_MODULE'                , 1, 1, 'WorkflowModules'         , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Workflows.EditView.Timed'      ,  5, 'Workflows.LBL_FREQUENCY_LIMIT'          , 'FREQUENCY_VALUE'            , 0, 1, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView.Timed'      ,  6, null                                     , 'FREQUENCY_INTERVAL'         , 1, 1, 'workflow_freq_limit_dom' , -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.EditView.Timed'      ,  7, 'Workflows.LBL_FIRE_ORDER'               , 'FIRE_ORDER'                 , 1, 1, 'workflow_fire_order_dom' , null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Workflows.EditView.Timed'      ,  8, 'Schedulers.LBL_INTERVAL'                , 'JOB_INTERVAL'               , 1, 1, 'CRON', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Workflows.EditView.Timed'      ,  9, 'Workflows.LBL_DESCRIPTION'              , 'DESCRIPTION'                , 0, 2,   4, 60, 3;
end -- if;
GO


-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Workflows.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Workflows.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Workflows.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly          'Workflows.SearchBasic'   , 'Workflows', 'vwWORKFLOWS', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Workflows.SearchBasic'   ,  0, 'Workflows.LBL_NAME'                     , 'NAME'                       , 0, null,  30, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.SearchBasic'   ,  1, 'Workflows.LBL_BASE_MODULE'              , 'BASE_MODULE'                , 0, null, 'WorkflowModules', null, 3;  -- DropdownList
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Workflows.SearchSequence';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Workflows.SearchSequence' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Workflows.SearchSequence';
	exec dbo.spEDITVIEWS_InsertOnly          'Workflows.SearchSequence', 'Workflows', 'vwWORKFLOWS', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Workflows.SearchSequence',  0, 'Workflows.LBL_BASE_MODULE'              , 'BASE_MODULE'                , 1, null, 'WorkflowModules', null, null;  -- ListBox
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowEventLog.SearchBasic'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowEventLog.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS WorkflowEventLog.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly          'WorkflowEventLog.SearchBasic' , 'Workflows', 'vwWORKFLOWS_RUN', '15%', '35%';
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'WorkflowEventLog.SearchBasic' ,  0, 'Workflows.LBL_NAME'                     , 'NAME'                       , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'WorkflowEventLog.SearchBasic' ,  1, 'Workflows.LBL_STATUS'                   , 'STATUS'                     , 0, 1,  60, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'WorkflowEventLog.SearchBasic' ,  2, '.LBL_DATE_ENTERED'                      , 'DATE_ENTERED'               , 0, null, 'DateRange'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'WorkflowEventLog.SearchBasic' ,  3, 'Workflows.LBL_DESCRIPTION'              , 'DESCRIPTION'                , 0, 1,   4, 60, null;
end -- if;
GO

-- 07/09/2016 Paul.  Business Processes needs a popup view. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowAlertTemplates.SearchBasic'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowAlertTemplates.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS WorkflowAlertTemplates.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly          'WorkflowAlertTemplates.SearchPopup', 'WorkflowAlertTemplates', 'vwWORKFLOW_ALERT_TEMPLATES', '15%', '35%';
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'WorkflowAlertTemplates.SearchPopup',  0, 'WorkflowAlertTemplates.LBL_LIST_NAME'           , 'NAME'                       , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'WorkflowAlertTemplates.SearchPopup',  1, 'WorkflowAlertTemplates.LBL_BASE_MODULE'         , 'BASE_MODULE'                , 0, null, 'WorkflowModules', null, 3;  -- DropdownList
end -- if;
GO


-- 03/12/2021 Paul.  Add layout for React Client only. 
-- delete EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowAlertTemplates.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowAlertTemplates.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS WorkflowAlertTemplates.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'WorkflowAlertTemplates.EditView' , 'WorkflowAlertTemplates', 'vwWORKFLOW_ALERT_TEMPLATES', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'WorkflowAlertTemplates.EditView' ,  0, 'WorkflowAlertTemplates.LBL_NAME'                , 'NAME'                       , 1, 1, 255, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'WorkflowAlertTemplates.EditView' ,  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'WorkflowAlertTemplates.EditView' ,  3, 'WorkflowAlertTemplates.LBL_FROM_NAME'           , 'FROM_NAME'                  , 0, 1, 100, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'WorkflowAlertTemplates.EditView' ,  4, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'WorkflowAlertTemplates.EditView' ,  5, 'WorkflowAlertTemplates.LBL_FROM_ADDR'           , 'FROM_ADDR'                  , 0, 1, 100, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'WorkflowAlertTemplates.EditView' ,  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'WorkflowAlertTemplates.EditView' ,  7, 'WorkflowAlertTemplates.LBL_DESCRIPTION'         , 'DESCRIPTION'                , 0, 1,   1, 90, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'WorkflowAlertTemplates.EditView' ,  8, 'WorkflowAlertTemplates.LBL_BASE_MODULE'         , 'BASE_MODULE'                , 1, 1, 'WorkflowModules', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'WorkflowAlertTemplates.EditView' ,  9, 'WorkflowAlertTemplates.LBL_RELATED_MODULE'      , 'RELATED'                    , 0, 1, 'WorkflowRelated', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'WorkflowAlertTemplates.EditView' , 10, null                                             , 'VariableName'               , 1, 1, 'WorkflowColumns', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'WorkflowAlertTemplates.EditView' , 11, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'WorkflowAlertTemplates.EditView' , 12, 'WorkflowAlertTemplates.LBL_INSERT_VARIABLE'     , 'VariableType'               , 1, 1, 'value_type', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'WorkflowAlertTemplates.EditView' , 13, null                                             , 'VariableText'               , 0, 1, 255, 50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsButton      'WorkflowAlertTemplates.EditView' , 14, 'WorkflowAlertTemplates.LBL_INSERT'              , 'VariableButton'             , 'InsertVariable', -1;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'WorkflowAlertTemplates.EditView' , 15, 'WorkflowAlertTemplates.LBL_SUBJECT'             , 'SUBJECT'                    , 0, 1,   1, 90, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsHtmlEditor  'WorkflowAlertTemplates.EditView' , 16, 'WorkflowAlertTemplates.LBL_BODY'                , 'BODY_HTML'                  , 0, 2, 200,900, 3;
end -- if;
GO

-- 06/11/2021 Paul.  BASE_MODULE is read only. 
if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowAlertShells.EditView' and DATA_FIELD = 'BASE_MODULE' and FIELD_TYPE = 'ListBox' and DELETED = 0) begin -- then
	delete EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowAlertShells.EditView';
end -- if;
-- 06/10/2021 Paul.  Add layout for React Client only. 
-- 06/19/2021 Paul.  Remove blank row before Alert Text. 
-- delete EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowAlertShells.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowAlertShells.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS WorkflowAlertShells.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'WorkflowAlertShells.EditView'    , 'WorkflowAlertShells', 'vwWORKFLOW_ALERT_SHELLS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'WorkflowAlertShells.EditView'    ,  0, 'WorkflowAlertShells.LBL_NAME'                   , 'NAME'                       , 1, 1, 255, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'WorkflowAlertShells.EditView'    ,  1, 'WorkflowAlertShells.LBL_BASE_MODULE'            , 'BASE_MODULE'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'WorkflowAlertShells.EditView'    ,  2, 'Teams.LBL_TEAM'                                 , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'               , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'WorkflowAlertShells.EditView'    ,  3, '.LBL_ASSIGNED_TO'                               , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'        , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'WorkflowAlertShells.EditView'    ,  4, 'WorkflowAlertShells.LBL_ALERT_TYPE'             , 'ALERT_TYPE'                 , 1, 1, 'workflow_alert_type_dom' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'WorkflowAlertShells.EditView'    ,  5, 'WorkflowAlertShells.LBL_SOURCE_TYPE'            , 'SOURCE_TYPE'                , 1, 1, 'workflow_source_type_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'WorkflowAlertShells.EditView'    ,  7, 'WorkflowAlertShells.LBL_ALERT_TEXT'             , 'ALERT_TEXT'                 , 0, 1,   4, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'WorkflowAlertShells.EditView'    ,  8, 'WorkflowAlertShells.LBL_CUSTOM_TEMPLATE'        , 'CUSTOM_TEMPLATE_ID'         , 1, 1, 'WorkflowAlertTemplates'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'WorkflowAlertShells.EditView'    ,  9, null;
end -- if;
GO

-- 06/10/2021 Paul.  Add layout for React Client only. 
-- delete EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowActionShells.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'WorkflowActionShells.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS WorkflowActionShells.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'WorkflowActionShells.EditView'   , 'WorkflowActionShells', 'vwWORKFLOW_ACTION_SHELLS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'WorkflowActionShells.EditView'   ,  0, 'WorkflowActionShells.LBL_NAME'                  , 'NAME'                       , 1, 1, 255, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'WorkflowActionShells.EditView'   ,  1, 'WorkflowActionShells.LBL_BASE_MODULE'           , 'BASE_MODULE'                , null;
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

call dbo.spEDITVIEWS_FIELDS_Workflows()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_Workflows')
/

-- #endif IBM_DB2 */


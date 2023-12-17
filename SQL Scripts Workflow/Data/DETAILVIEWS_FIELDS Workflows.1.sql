

print 'DETAILVIEWS_FIELDS Workflow';
GO

set nocount on;
GO

-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Workflows.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Workflows.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Workflows.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Workflows.DetailView'      , 'Workflows'      , 'vwWorkflows_Edit'      , '15%', '35%';
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Workflows.DetailView',  0, 'Workflows.LBL_NAME'                  , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Workflows.DetailView',  1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Workflows.DetailView',  2, 'Workflows.LBL_TYPE'                  , 'TYPE'                             , '{0}'        , 'workflow_type_dom'       , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Workflows.DetailView',  3, 'Workflows.LBL_STATUS'                , 'STATUS'                           , '{0}'        , 'workflow_status_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Workflows.DetailView',  4, 'Workflows.LBL_BASE_MODULE'           , 'BASE_MODULE'                      , '{0}'        , 'ReportingModules'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Workflows.DetailView',  5, 'Workflows.LBL_RECORD_TYPE'           , 'RECORD_TYPE'                      , '{0}'        , 'workflow_record_type_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Workflows.DetailView',  6, 'Workflows.LBL_FIRE_ORDER'            , 'FIRE_ORDER'                       , '{0}'        , 'workflow_fire_order_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Workflows.DetailView',  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Workflows.DetailView',  8, 'TextBox', 'Workflows.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'WorkflowAlertShells.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'WorkflowAlertShells.DetailView' and DELETED = 0) begin -- then 
	print 'DETAILVIEWS_FIELDS WorkflowAlertShells.DetailView'; 
	exec dbo.spDETAILVIEWS_InsertOnly 'WorkflowAlertShells.DetailView', 'WorkflowAlertShells', 'vwWORKFLOW_ALERT_SHELLS', '15%', '35%'; 
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowAlertShells.DetailView',  0, 'WorkflowAlertShells.LBL_NAME'                          , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'WorkflowAlertShells.DetailView',  1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'WorkflowAlertShells.DetailView',  2, 'WorkflowAlertShells.LBL_SOURCE_TYPE'                   , 'SOURCE_TYPE'                       , '{0}'        , 'workflow_source_type_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'WorkflowAlertShells.DetailView',  3, 'WorkflowAlertShells.LBL_ALERT_TYPE'                    , 'ALERT_TYPE'                        , '{0}'        , 'workflow_alert_type_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowAlertShells.DetailView',  4, 'WorkflowAlertShells.LBL_ALERT_TEXT'                    , 'ALERT_TEXT'                        , '{0}'        , 3;
end -- if;
GO

-- 10/13/2023 Paul.  Allow list of actions. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'WorkflowActionShells.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'WorkflowActionShells.DetailView' and DELETED = 0) begin -- then 
	print 'DETAILVIEWS_FIELDS WorkflowActionShells.DetailView'; 
	exec dbo.spDETAILVIEWS_InsertOnly 'WorkflowActionShells.DetailView', 'WorkflowActionShells', 'vwWORKFLOW_ACTION_SHELLS', '15%', '35%'; 
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowActionShells.DetailView',  0, 'WorkflowActionShells.LBL_NAME'                          , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowActionShells.DetailView',  1, 'WorkflowActionShells.LBL_ACTION_TYPE'                   , 'ACTION_TYPE'                       , '{0}'        , null;
end -- if;
GO

-- 05/10/2022 Paul.  The React Client requires TextBox to display HTML. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'WorkflowAlertTemplates.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'WorkflowAlertTemplates.DetailView' and DELETED = 0) begin -- then 
	print 'DETAILVIEWS_FIELDS WorkflowAlertTemplates.DetailView'; 
	exec dbo.spDETAILVIEWS_InsertOnly 'WorkflowAlertTemplates.DetailView', 'WorkflowAlertTemplates', 'vwWORKFLOW_ALERT_TEMPLATES', '15%', '35%'; 
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowAlertTemplates.DetailView',  0, 'WorkflowAlertTemplates.LBL_NAME'                          , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowAlertTemplates.DetailView',  1, '.LBL_DATE_MODIFIED'                                       , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowAlertTemplates.DetailView',  2, 'WorkflowAlertTemplates.LBL_DESCRIPTION'                   , 'DESCRIPTION'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowAlertTemplates.DetailView',  3, '.LBL_DATE_ENTERED'                                        , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowAlertTemplates.DetailView',  4, 'WorkflowAlertTemplates.LBL_FROM_NAME'                     , 'FROM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowAlertTemplates.DetailView',  5, 'WorkflowAlertTemplates.LBL_FROM_ADDR'                     , 'FROM_ADDR'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'WorkflowAlertTemplates.DetailView',  6, 'WorkflowAlertTemplates.LBL_BASE_MODULE'                   , 'BASE_MODULE'                      , '{0}'        , 'WorkflowModules' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'WorkflowAlertTemplates.DetailView',  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'WorkflowAlertTemplates.DetailView',  8, 'WorkflowAlertTemplates.LBL_SUBJECT'                       , 'SUBJECT'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'WorkflowAlertTemplates.DetailView',  9, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'WorkflowAlertTemplates.DetailView', 10, 'TextBox', 'WorkflowAlertTemplates.LBL_BODY_HTML'      , 'BODY_HTML', 'raw', null, null, null, null, 3, null;
end else begin
	-- 05/10/2022 Paul.  The React Client requires TextBox to display HTML. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'WorkflowAlertTemplates.DetailView' and DATA_FIELD = 'BODY_HTML' and FIELD_TYPE = 'String' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_TYPE        = 'TextBox'
		     , DATA_FORMAT       = 'raw'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where DETAIL_NAME       = 'WorkflowAlertTemplates.DetailView'
		   and DATA_FIELD        = 'BODY_HTML'
		   and FIELD_TYPE        = 'String'
		   and DELETED           = 0;
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

call dbo.spDETAILVIEWS_FIELDS_Workflow()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_Workflow')
/

-- #endif IBM_DB2 */


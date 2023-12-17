

print 'DETAILVIEWS_RELATIONSHIPS Enterprise';
GO

set nocount on;
GO

-- 10/13/2012 Paul.  Add table info for HTML5 Offline Client. 
-- 04/15/2021 Paul.  The React client requires table name and related fields. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Workflows.DetailView';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Workflows.DetailView' and MODULE_NAME = 'WorkflowTriggerShells' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Workflows.DetailView WorkflowTriggerShells';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Workflows.DetailView'      , 'WorkflowTriggerShells', 'Conditions',  0, 'WorkflowTriggerShells.LBL_MODULE_NAME'         , 'vwWORKFLOW_TRIGGER_SHELLS', 'PARENT_ID'  , 'DATE_ENTERED', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Workflows.DetailView'      , 'WorkflowAlertShells'  , 'Alerts'    ,  1, 'WorkflowAlertShells.LBL_MODULE_NAME'           , 'vwWORKFLOW_ALERT_SHELLS'  , 'PARENT_ID'  , 'DATE_ENTERED', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Workflows.DetailView'      , 'WorkflowActionShells' , 'Actions'   ,  2, 'WorkflowActionShells.LBL_MODULE_NAME'          , 'vwWORKFLOW_ACTION_SHELLS' , 'PARENT_ID'  , 'DATE_ENTERED', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Workflows.DetailView'      , 'Workflows'            , 'Events'    ,  3, 'Workflows.LBL_EVENTS_TITLE'                    , 'vwWORKFLOW_RUN'           , 'WORKFLOW_ID', 'DATE_ENTERED', 'desc';
end else begin
	-- 04/15/2021 Paul.  The React client requires table name and related fields. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Workflows.DetailView' and CONTROL_NAME = 'Conditions' and TABLE_NAME is null and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME         = 'vwWORKFLOW_TRIGGER_SHELLS'
		     , PRIMARY_FIELD      = 'PARENT_ID'
		     , SORT_FIELD         = 'DATE_ENTERED'
		     , SORT_DIRECTION     = 'asc'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where DETAIL_NAME        = 'Workflows.DetailView'
		   and CONTROL_NAME       = 'Conditions'
		   and TABLE_NAME         is null 
		   and DELETED            = 0;
	end -- if;
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Workflows.DetailView' and CONTROL_NAME = 'Alerts' and TABLE_NAME is null and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME         = 'vwWORKFLOW_ALERT_SHELLS'
		     , PRIMARY_FIELD      = 'PARENT_ID'
		     , SORT_FIELD         = 'DATE_ENTERED'
		     , SORT_DIRECTION     = 'asc'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where DETAIL_NAME        = 'Workflows.DetailView'
		   and CONTROL_NAME       = 'Alerts'
		   and TABLE_NAME         is null 
		   and DELETED            = 0;
	end -- if;
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Workflows.DetailView' and CONTROL_NAME = 'Actions' and TABLE_NAME is null and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME         = 'vwWORKFLOW_ACTION_SHELLS'
		     , PRIMARY_FIELD      = 'PARENT_ID'
		     , SORT_FIELD         = 'DATE_ENTERED'
		     , SORT_DIRECTION     = 'asc'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where DETAIL_NAME        = 'Workflows.DetailView'
		   and CONTROL_NAME       = 'Actions'
		   and TABLE_NAME         is null 
		   and DELETED            = 0;
	end -- if;
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Workflows.DetailView' and CONTROL_NAME = 'Events' and TABLE_NAME is null and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME         = 'vwWORKFLOW_RUN'
		     , PRIMARY_FIELD      = 'WORKFLOW_ID'
		     , SORT_FIELD         = 'DATE_ENTERED'
		     , SORT_DIRECTION     = 'desc'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where DETAIL_NAME        = 'Workflows.DetailView'
		   and CONTROL_NAME       = 'Events'
		   and TABLE_NAME         is null 
		   and DELETED            = 0;
	end -- if;
	-- 07/01/2021 Paul.  Correct sort direction. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Workflows.DetailView' and CONTROL_NAME = 'Events' and SORT_DIRECTION = 'asc' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set SORT_DIRECTION     = 'desc'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where DETAIL_NAME        = 'Workflows.DetailView'
		   and CONTROL_NAME       = 'Events'
		   and SORT_DIRECTION     = 'asc'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'WorkflowView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'       , 'WorkflowView',  9, 'Administration.LBL_WORKFLOW_TITLE'           , null, null, null, null;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_Workflow()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_Workflow')
/

-- #endif IBM_DB2 */


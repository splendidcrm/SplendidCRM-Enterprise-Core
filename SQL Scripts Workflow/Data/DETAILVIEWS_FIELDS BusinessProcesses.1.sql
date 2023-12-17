

print 'DETAILVIEWS_FIELDS BusinessProcesses';
GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'BusinessProcesses.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'BusinessProcesses.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS BusinessProcesses.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'BusinessProcesses.DetailView', 'BusinessProcesses', 'vwBUSINESS_PROCESSES_Edit', '15%', '35%';
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'BusinessProcesses.DetailView',  0, 'BusinessProcesses.LBL_NAME'          , 'NAME'                             , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'BusinessProcesses.DetailView',  1, 'BusinessProcesses.LBL_TYPE'          , 'TYPE'                             , '{0}'        , 'workflow_type_dom'       , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'BusinessProcesses.DetailView',  2, 'BusinessProcesses.LBL_STATUS'        , 'STATUS'                           , '{0}'        , 'workflow_status_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'BusinessProcesses.DetailView',  3, 'BusinessProcesses.LBL_BASE_MODULE'   , 'BASE_MODULE'                      , '{0}'        , 'WorkflowModules'         , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'BusinessProcesses.DetailView',  4, 'BusinessProcesses.LBL_RECORD_TYPE'   , 'RECORD_TYPE'                      , '{0}'        , 'workflow_record_type_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'BusinessProcesses.DetailView',  5, 'TextBox', 'BusinessProcesses.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3;
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

call dbo.spDETAILVIEWS_FIELDS_BusinessProcesses()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_BusinessProcesses')
/

-- #endif IBM_DB2 */


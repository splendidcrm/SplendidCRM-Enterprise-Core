

print 'DETAILVIEWS_RELATIONSHIPS BusinessProcesses';
GO

set nocount on;
GO

-- 04/15/2021 Paul.  The React client requires table name and related fields. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'BusinessProcesses.DetailView';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'BusinessProcesses.DetailView' and CONTROL_NAME = 'Events' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS BusinessProcesses.DetailView WorkflowTriggerShells';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'BusinessProcesses.DetailView', 'BusinessProcesses', 'Events',  0, 'BusinessProcesses.LBL_EVENTS_TITLE', 'vwBUSINESS_PROCESSES_RUN_EventLog', 'BUSINESS_PROCESS_ID', 'DATE_ENTERED', 'desc';
end else begin
	-- 04/15/2021 Paul.  The React client requires table name and related fields. 
	if exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'BusinessProcesses.DetailView' and CONTROL_NAME = 'Events' and (TABLE_NAME is null or PRIMARY_FIELD is null) and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set TABLE_NAME         = 'vwBUSINESS_PROCESSES_RUN_EventLog'
		     , PRIMARY_FIELD      = 'BUSINESS_PROCESS_ID'
		     , SORT_FIELD         = 'DATE_ENTERED'
		     , SORT_DIRECTION     = 'desc'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where DETAIL_NAME        = 'BusinessProcesses.DetailView'
		   and CONTROL_NAME       = 'Events'
		   and (TABLE_NAME is null or PRIMARY_FIELD is null)
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 06/24/2018 Paul.  There is not a separate BusinessProcessView. 
--if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'WorkflowView' and DELETED = 0) begin -- then
--	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView';
--	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView', 'Administration', 'BusinessProcessView', 10, 'Administration.LBL_BUSINESS_PROCESSES_TITLE', null, null, null, null;
--end -- if;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_BusinessProcesses()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_BusinessProcesses')
/

-- #endif IBM_DB2 */


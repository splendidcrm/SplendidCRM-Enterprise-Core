

print 'DETAILVIEWS_FIELDS Processes';
GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Processes.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Processes.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Processes.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Processes.DetailView', 'Processes', 'vwPROCESSES', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Processes.DetailView',  0, 'Processes.LBL_PROCESS_NUMBER'       , 'PROCESS_NUMBER'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Processes.DetailView',  1, 'Processes.LBL_BUSINESS_PROCESS_NAME', 'BUSINESS_PROCESS_NAME'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Processes.DetailView',  2, 'Processes.LBL_PARENT_NAME'          , 'PARENT_NAME'                           , '{0}', 'PARENT_TYPE PARENT_ID', '~/{0}/view.aspx?ID={1}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Processes.DetailView',  3, 'Processes.LBL_ACTIVITY_NAME'        , 'ACTIVITY_NAME'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Processes.DetailView',  4, 'Processes.LBL_STATUS'               , 'STATUS'                                , '{0}', 'process_status', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Processes.DetailView',  5, 'Processes.LBL_DURATION'             , 'DURATION_VALUE DURATION_UNITS'         , '{0} {1}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Processes.DetailView',  6, 'Processes.LBL_APPROVAL_DATE'        , 'APPROVAL_DATE'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Processes.DetailView',  7, 'Processes.LBL_APPROVAL_USER_NAME'   , 'APPROVAL_USER_NAME'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Processes.DetailView',  8, 'Processes.LBL_APPROVAL_VALUE'       , 'APPROVAL_VALUE'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Processes.DetailView',  9, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Processes.DetailView', 10, '.LBL_DATE_MODIFIED'                 , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Processes.DetailView', 11, '.LBL_DATE_ENTERED'                  , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
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

call dbo.spDETAILVIEWS_FIELDS_Processes()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_Processes')
/

-- #endif IBM_DB2 */


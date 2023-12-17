

print 'EDITVIEWS_FIELDS BusinessProcessesLog';
GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'BusinessProcessesLog.SearchBasic'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'BusinessProcessesLog.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS BusinessProcessesLog.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly          'BusinessProcessesLog.SearchBasic' , 'BusinessProcessesLog', 'vwBUSINESS_PROCESSES_RUN_EventLog', '15%', '35%';
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'BusinessProcessesLog.SearchBasic' ,  0, 'BusinessProcesses.LBL_NAME'              , 'NAME'                       , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'BusinessProcessesLog.SearchBasic' ,  1, 'BusinessProcesses.LBL_STATUS'            , 'STATUS'                     , 0, 1,  60, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'BusinessProcessesLog.SearchBasic' ,  2, '.LBL_DATE_ENTERED'                       , 'DATE_ENTERED'               , 0, null, 'DateRange'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'BusinessProcessesLog.SearchBasic' ,  3, 'BusinessProcesses.LBL_DESCRIPTION'       , 'DESCRIPTION'                , 0, 1,   4, 60, null;
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

call dbo.spEDITVIEWS_FIELDS_BusinessProcessesLog()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_BusinessProcessesLog')
/

-- #endif IBM_DB2 */


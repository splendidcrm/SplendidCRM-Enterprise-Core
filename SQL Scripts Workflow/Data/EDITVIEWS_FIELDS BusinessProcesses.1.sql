

print 'EDITVIEWS_FIELDS BusinessProcesses';
GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'BusinessProcesses.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'BusinessProcesses.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS BusinessProcesses.EditView';
	exec dbo.spEDITVIEWS_InsertOnly          'BusinessProcesses.EditView', 'BusinessProcesses', 'vwBUSINESS_PROCESSES_Edit', '15%', '35%';
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'BusinessProcesses.EditView',  0, 'BusinessProcesses.LBL_NAME'                     , 'NAME'                       , 1, 1, 100, 35, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'BusinessProcesses.EditView',  1, 'BusinessProcesses.LBL_TYPE'                     , 'TYPE'                       , 1, 1, 'workflow_type_dom'       , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'BusinessProcesses.EditView',  2, 'BusinessProcesses.LBL_STATUS'                   , 'STATUS'                     , 1, 1, 'workflow_status_dom'     , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'BusinessProcesses.EditView',  3, 'BusinessProcesses.LBL_BASE_MODULE'              , 'BASE_MODULE'                , 1, 1, 'WorkflowModules'         , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'BusinessProcesses.EditView',  4, 'BusinessProcesses.LBL_RECORD_TYPE'              , 'RECORD_TYPE'                , 1, 1, 'workflow_record_type_dom', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'BusinessProcesses.EditView',  5, 'BusinessProcesses.LBL_DESCRIPTION'              , 'DESCRIPTION'                , 0, 2,   4, 60, 3;
end -- if;
GO


-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'BusinessProcesses.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'BusinessProcesses.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS BusinessProcesses.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly          'BusinessProcesses.SearchBasic', 'BusinessProcesses', 'vwBUSINESS_PROCESSES', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'BusinessProcesses.SearchBasic',  0, 'BusinessProcesses.LBL_NAME'                  , 'NAME'                       , 0, null,  30, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'BusinessProcesses.SearchBasic',  1, 'BusinessProcesses.LBL_BASE_MODULE'           , 'BASE_MODULE'                , 0, null, 'WorkflowModules', null, 3;  -- DropdownList
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

call dbo.spEDITVIEWS_FIELDS_BusinessProcesses()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_BusinessProcesses')
/

-- #endif IBM_DB2 */




print 'EDITVIEWS_FIELDS Processes.SearchBasic';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Processes.SearchBasic';
--GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Processes.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Processes.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Processes.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Processes.SearchBasic', 'Processes', 'vwPROCESSES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Processes.SearchBasic',  0, 'Processes.LBL_PARENT_NAME'            , 'PARENT_NAME'                 , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Processes.SearchBasic',  1, '.LBL_DATE_ENTERED'                    , 'DATE_ENTERED'                , 0, null, 'DateRange'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'Processes.SearchBasic',  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Processes.SearchBasic',  3, '.LBL_ASSIGNED_TO'                     , 'ASSIGNED_USER_ID'            , 0, null, 'AssignedUser'       , null, 4;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Processes.SearchBasic',  4, 'Processes.LBL_LIST_PROCESS_USER_NAME' , 'PROCESS_USER_ID'             , 0, null, 'AssignedUser'       , null, 4;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Processes.SearchBasic',  5, 'Processes.LBL_LIST_PROCESS_OWNER_NAME', 'PROCESS_OWNER_ID'            , 0, null, 'AssignedUser'       , null, 4;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Processes.SelectUserView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Processes.SelectUserView' and DELETED = 0) begin -- then
	exec dbo.spEDITVIEWS_InsertOnly             'Processes.SelectUserView', 'Processes', 'vwPROCESSES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine    'Processes.SelectUserView',  0, 'Processes.LBL_PROCESS_NOTES'      , 'PROCESS_NOTES'                , 0, 2,   4, 60, 3;
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

call dbo.spEDITVIEWS_FIELDS_ProcessesSearchBasic()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_ProcessesSearchBasic')
/

-- #endif IBM_DB2 */


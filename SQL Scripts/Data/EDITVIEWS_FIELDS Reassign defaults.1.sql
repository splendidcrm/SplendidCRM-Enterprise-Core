

print 'EDITVIEWS_FIELDS Reassign defaults';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.Reassign'
--GO

set nocount on;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.Reassign' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.Reassign';
	exec dbo.spEDITVIEWS_InsertOnly          'Accounts.Reassign'     , 'Accounts', 'vwACCOUNTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Accounts.Reassign'     ,  0, 'Accounts.LBL_TYPE'                      , 'ACCOUNT_TYPE'           , 0, null, 'account_type_dom'    , null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Accounts.Reassign'     ,  1, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Bugs.Reassign' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Bugs.Reassign';
	exec dbo.spEDITVIEWS_InsertOnly          'Bugs.Reassign'         , 'Bugs', 'vwBUGS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Bugs.Reassign'         ,  0, 'Bugs.LBL_STATUS'                        , 'STATUS'                 , 0, null, 'bug_status_dom'      , null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Bugs.Reassign'         ,  1, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Calls.Reassign' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Calls.Reassign';
	exec dbo.spEDITVIEWS_InsertOnly          'Calls.Reassign'        , 'Calls', 'vwCALLS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Calls.Reassign'        ,  0, 'Calls.LBL_STATUS'                       , 'STATUS'                 , 0, null, 'call_status_dom'     , null, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Calls.Reassign'        ,  1, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Cases.Reassign' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Cases.Reassign';
	exec dbo.spEDITVIEWS_InsertOnly          'Cases.Reassign'        , 'Cases', 'vwCASES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Cases.Reassign'        ,  0, 'Cases.LBL_STATUS'                       , 'STATUS'                 , 0, null, 'case_status_dom'     , null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Cases.Reassign'        ,  1, 'Cases.LBL_PRIORITY'                     , 'PRIORITY'               , 0, null, 'case_priority_dom'   , null, 5;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.Reassign' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Opportunities.Reassign';
	exec dbo.spEDITVIEWS_InsertOnly          'Opportunities.Reassign', 'Opportunities', 'vwOPPORTUNITIES_Edit'     , '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Opportunities.Reassign',  0, 'Opportunities.LBL_SALES_STAGE'          , 'SALES_STAGE'            , 0, null, 'sales_stage_dom'     , null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Opportunities.Reassign',  1, 'Opportunities.LBL_TYPE'                 , 'OPPORTUNITY_TYPE'       , 0, null, 'opportunity_type_dom', null, 3;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Tasks.Reassign' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Tasks.Reassign';
	exec dbo.spEDITVIEWS_InsertOnly          'Tasks.Reassign'        , 'Tasks', 'vwTASKS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Tasks.Reassign'        ,  0, 'Tasks.LBL_STATUS'                       , 'STATUS'                 , 0, null, 'task_status_dom'     , null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Tasks.Reassign'        ,  1, null;
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

call dbo.spEDITVIEWS_FIELDS_ReassignDefaults()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_ReassignDefaults')
/

-- #endif IBM_DB2 */




print 'EDITVIEWS_FIELDS SearchBasic.Portal';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.SearchBasic.Portal';
--GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Bugs.SearchBasic.Portal';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Bugs.SearchBasic.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Bugs.SearchBasic.Portal';
	exec dbo.spEDITVIEWS_InsertOnly          'Bugs.SearchBasic.Portal'        , 'Bugs', 'vwBUGS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Bugs.SearchBasic.Portal'        ,  0, 'Bugs.LBL_BUG_NUMBER'                    , 'BUG_NUMBER'                 , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Bugs.SearchBasic.Portal'        ,  1, 'Bugs.LBL_SUBJECT'                       , 'NAME'                       , 0, null, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Bugs.SearchBasic.Portal'        ,  2, 'Bugs.LBL_RESOLUTION'                    , 'RESOLUTION'                 , 0, null, 'bug_resolution_dom'  , null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Bugs.SearchBasic.Portal'        ,  3, 'Bugs.LBL_STATUS'                        , 'STATUS'                     , 0, null, 'bug_status_dom'      , null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Bugs.SearchBasic.Portal'        ,  4, 'Bugs.LBL_DESCRIPTION'                   , 'DESCRIPTION'                , 0, null,  2,100, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Cases.SearchBasic.Portal';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Cases.SearchBasic.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Cases.SearchBasic.Portal';
	exec dbo.spEDITVIEWS_InsertOnly          'Cases.SearchBasic.Portal'       , 'Cases', 'vwCASES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Cases.SearchBasic.Portal'       ,  0, 'Cases.LBL_CASE_NUMBER'                  , 'CASE_NUMBER'                , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Cases.SearchBasic.Portal'       ,  1, 'Cases.LBL_SUBJECT'                      , 'NAME'                       , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Cases.SearchBasic.Portal'       ,  2, 'Cases.LBL_STATUS'                       , 'STATUS'                     , 0, null, 'case_status_dom'  , null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Cases.SearchBasic.Portal'       ,  3, 'Cases.LBL_PRIORITY'                     , 'PRIORITY'                   , 0, null, 'case_priority_dom', null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Cases.SearchBasic.Portal'       ,  4, 'Cases.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, null,  2,100, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Contacts.SearchBasic.Portal';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.SearchBasic.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.SearchBasic.Portal';
	exec dbo.spEDITVIEWS_InsertOnly          'Contacts.SearchBasic.Portal'    , 'Contacts', 'vwCONTACTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.SearchBasic.Portal'    ,  0, 'Contacts.LBL_FIRST_NAME'                , 'FIRST_NAME'                 , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.SearchBasic.Portal'    ,  1, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 0, null,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange    'Contacts.SearchBasic.Portal'    ,  2, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME', 'return SearchAccountPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.SearchBasic.Portal'    ,  3, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchBasic.Portal';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchBasic.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS KBDocuments.SearchBasic.Portal';
	exec dbo.spEDITVIEWS_InsertOnly             'KBDocuments.SearchBasic.Portal'   , 'KBDocuments', 'vwKBDOCUMENTS_List', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'KBDocuments.SearchBasic.Portal'   ,  0, 'KBDocuments.LBL_DESCRIPTION'            , 'DESCRIPTION'                , 0, null, 150, 80, null;
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

call dbo.spEDITVIEWS_FIELDS_SearchBasicPortal()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_SearchBasicPortal')
/

-- #endif IBM_DB2 */


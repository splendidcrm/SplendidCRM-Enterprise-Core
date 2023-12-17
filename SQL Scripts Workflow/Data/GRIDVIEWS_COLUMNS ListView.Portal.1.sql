

print 'GRIDVIEWS_COLUMNS ListView.Portal';
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like '%.Portal';
--GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like 'Bugs.ListView.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Bugs.ListView.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Bugs.ListView.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Bugs.ListView.Portal'              , 'Bugs', 'vwBUGS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.ListView.Portal'              , 1, 'Bugs.LBL_LIST_NUMBER'                     , 'BUG_NUMBER'      , 'BUG_NUMBER'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Bugs.ListView.Portal'              , 2, 'Bugs.LBL_LIST_SUBJECT'                    , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID'         , '~/Bugs/view.aspx?id={0}', null, 'Bugs', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.ListView.Portal'              , 3, 'Bugs.LBL_LIST_STATUS'                     , 'STATUS'          , 'STATUS'          , '15%', 'bug_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.ListView.Portal'              , 4, 'Bugs.LBL_LIST_TYPE'                       , 'TYPE'            , 'TYPE'            , '15%', 'bug_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.ListView.Portal'              , 5, 'Bugs.LBL_LIST_PRIORITY'                   , 'PRIORITY'        , 'PRIORITY'        , '15%', 'bug_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.ListView.Portal'              , 6, 'Bugs.LBL_LIST_RESOLUTION'                 , 'RESOLUTION'      , 'RESOLUTION'      , '15%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like 'Bugs.Notes.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Bugs.Notes.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Bugs.Notes.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Bugs.Notes.Portal'                 , 'Bugs', 'vwBUGS_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Bugs.Notes.Portal'                 , 1, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'   , 'ACTIVITY_NAME'   , '58%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.Notes.Portal'                 , 2, 'Activities.LBL_LIST_STATUS'               , 'STATUS'          , 'STATUS'          , '20%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Bugs.Notes.Portal'                 , 3, 'Activities.LBL_LIST_LAST_MODIFIED'        , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '20%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like 'Cases.ListView.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.ListView.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Cases.ListView.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Cases.ListView.Portal'             , 'Cases', 'vwCASES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.ListView.Portal'             , 1, 'Cases.LBL_LIST_NUMBER'                    , 'CASE_NUMBER'     , 'CASE_NUMBER'     , '10%', 'listViewTdLinkS1', 'ID'         , '~/Cases/view.aspx?id={0}'   , null, 'Cases'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.ListView.Portal'             , 2, 'Cases.LBL_LIST_SUBJECT'                   , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'ID'         , '~/Cases/view.aspx?id={0}'   , null, 'Cases'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Cases.ListView.Portal'             , 3, 'Cases.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.ListView.Portal'             , 4, 'Cases.LBL_LIST_PRIORITY'                  , 'PRIORITY'        , 'PRIORITY'        , '15%', 'case_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.ListView.Portal'             , 5, 'Cases.LBL_LIST_STATUS'                    , 'STATUS'          , 'STATUS'          , '15%', 'case_status_dom';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like 'Cases.Notes.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.Notes.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Cases.Notes.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Cases.Notes.Portal'                , 'Cases', 'vwCASES_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.Notes.Portal'                , 1, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'   , 'ACTIVITY_NAME'   , '58%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.Notes.Portal'                , 2, 'Activities.LBL_LIST_STATUS'               , 'STATUS'          , 'STATUS'          , '20%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Cases.Notes.Portal'                , 3, 'Activities.LBL_LIST_LAST_MODIFIED'        , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '20%', 'Date';
end -- if;
GO

-- 10/26/2009 Paul.  Assigned user and Team should not be displayed on the portal site. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like 'Contacts.ListView.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.Portal'          , 'Contacts'      , 'vwCONTACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.Portal'          , 1, 'Contacts.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '20%', 'listViewTdLinkS1', 'ID'         , '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Portal'          , 2, 'Contacts.LBL_LIST_TITLE'                  , 'TITLE'           , 'TITLE'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Portal'          , 3, 'Contacts.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Portal'          , 4, 'Contacts.LBL_LIST_PHONE'                  , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
end -- if;
GO

-- 10/26/2009 Paul.  Add Knowledge Base module. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.ListView.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS KBDocuments.ListView.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'KBDocuments.ListView.Portal'       , 'KBDocuments', 'vwKBDOCUMENTS_List'     ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBDocuments.ListView.Portal'       , 1, 'KBDocuments.LBL_LIST_NAME'                , 'NAME'                 , 'NAME'                 , '100%', 'listViewTdLinkS1', 'ID', '~/KBDocuments/view.aspx?id={0}', null, 'KBDocuments', null;
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

call dbo.spGRIDVIEWS_COLUMNS_ListViewPortal()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ListViewPortal')
/

-- #endif IBM_DB2 */


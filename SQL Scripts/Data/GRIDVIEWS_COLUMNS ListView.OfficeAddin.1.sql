

print 'GRIDVIEWS_COLUMNS ListView.OfficeAddin defaults';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.OfficeAddin'
--GO

set nocount on;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.OfficeAddin' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.ListView.OfficeAddin';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.ListView.OfficeAddin'     , 'Accounts'      , 'vwACCOUNTS_List'      ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.ListView.OfficeAddin'     , 1, 'Accounts.LBL_LIST_ACCOUNT_NAME'           , 'NAME'            , 'NAME'            , '35%', 'listViewTdLinkS1', 'ID'         , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.OfficeAddin'     , 2, 'Accounts.LBL_LIST_CITY'                   , 'CITY'            , 'CITY'            , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.OfficeAddin'     , 3, 'Accounts.LBL_LIST_PHONE'                  , 'PHONE'           , 'PHONE'           , '15%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Bugs.ListView.OfficeAddin' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Bugs.ListView.OfficeAddin';
	exec dbo.spGRIDVIEWS_InsertOnly           'Bugs.ListView.OfficeAddin'         , 'Bugs'          , 'vwBUGS_List'          ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.ListView.OfficeAddin'         , 1, 'Bugs.LBL_LIST_NUMBER'                     , 'BUG_NUMBER'      , 'BUG_NUMBER'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Bugs.ListView.OfficeAddin'         , 2, 'Bugs.LBL_LIST_SUBJECT'                    , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID'         , '~/Bugs/view.aspx?id={0}', null, 'Bugs', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.ListView.OfficeAddin'         , 3, 'Bugs.LBL_LIST_STATUS'                     , 'STATUS'          , 'STATUS'          , '10%', 'bug_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.ListView.OfficeAddin'         , 4, 'Bugs.LBL_LIST_TYPE'                       , 'TYPE'            , 'TYPE'            , '10%', 'bug_type_dom';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.ListView.OfficeAddin' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Cases.ListView.OfficeAddin';
	exec dbo.spGRIDVIEWS_InsertOnly           'Cases.ListView.OfficeAddin'        , 'Cases'         , 'vwCASES_List'         ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.ListView.OfficeAddin'        , 1, 'Cases.LBL_LIST_NUMBER'                    , 'CASE_NUMBER'     , 'CASE_NUMBER'     , '10%', 'listViewTdLinkS1', 'ID'         , '~/Cases/view.aspx?id={0}'   , null, 'Cases'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.ListView.OfficeAddin'        , 2, 'Cases.LBL_LIST_SUBJECT'                   , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID'         , '~/Cases/view.aspx?id={0}'   , null, 'Cases'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.ListView.OfficeAddin'        , 3, 'Cases.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.ListView.OfficeAddin'        , 4, 'Cases.LBL_LIST_PRIORITY'                  , 'PRIORITY'        , 'PRIORITY'        , '10%', 'case_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.ListView.OfficeAddin'        , 5, 'Cases.LBL_LIST_STATUS'                    , 'STATUS'          , 'STATUS'          , '10%', 'case_status_dom';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.OfficeAddin' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.OfficeAddin';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.OfficeAddin'     , 'Contacts'      , 'vwCONTACTS_List'      ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.OfficeAddin'     , 1, 'Contacts.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '20%', 'listViewTdLinkS1', 'ID'         , '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.OfficeAddin'     , 2, 'Contacts.LBL_LIST_TITLE'                  , 'TITLE'           , 'TITLE'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.OfficeAddin'     , 3, 'Contacts.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.OfficeAddin'     , 4, 'Contacts.LBL_LIST_PHONE'                  , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.ListView.OfficeAddin' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Leads.ListView.OfficeAddin';
	exec dbo.spGRIDVIEWS_InsertOnly           'Leads.ListView.OfficeAddin'        , 'Leads'         , 'vwLEADS_List'         ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.OfficeAddin'        , 1, 'Leads.LBL_LIST_NAME'                      , 'NAME'            , 'NAME'            , '25%', 'listViewTdLinkS1', 'ID'         , '~/Leads/view.aspx?id={0}', null, 'Leads', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Leads.ListView.OfficeAddin'        , 2, 'Leads.LBL_LIST_STATUS'                    , 'STATUS'          , 'STATUS'          , '10%', 'lead_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.OfficeAddin'        , 3, 'Leads.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.OfficeAddin'        , 4, 'Leads.LBL_LIST_EMAIL_ADDRESS'             , 'EMAIL1'          , 'EMAIL1'          , '10%', 'listViewTdLinkS1', 'EMAIL1'     , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.OfficeAddin'        , 5, 'Leads.LBL_LIST_PHONE'                     , 'PHONE_WORK'      , 'PHONE_WORK'      , '20%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.ListView.OfficeAddin' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.ListView.OfficeAddin';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.ListView.OfficeAddin', 'Opportunities' , 'vwOPPORTUNITIES_List' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.OfficeAddin', 1, 'Opportunities.LBL_LIST_OPPORTUNITY_NAME'  , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID'         , '~/Opportunities/view.aspx?id={0}', null, 'Opportunities', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.OfficeAddin', 2, 'Opportunities.LBL_LIST_ACCOUNT_NAME'      , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Opportunities.ListView.OfficeAddin', 3, 'Opportunities.LBL_LIST_SALES_STAGE'       , 'SALES_STAGE'     , 'SALES_STAGE'     , '10%', 'sales_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.ListView.OfficeAddin', 4, 'Opportunities.LBL_LIST_AMOUNT'            , 'AMOUNT_USDOLLAR' , 'AMOUNT_USDOLLAR' , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.ListView.OfficeAddin', 5, 'Opportunities.LBL_LIST_DATE_CLOSED'       , 'DATE_CLOSED'     , 'DATE_CLOSED'     , '10%', 'Date'    ;
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

call dbo.spGRIDVIEWS_COLUMNS_ListViewOfficeAddin()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ListViewOfficeAddin')
/

-- #endif IBM_DB2 */


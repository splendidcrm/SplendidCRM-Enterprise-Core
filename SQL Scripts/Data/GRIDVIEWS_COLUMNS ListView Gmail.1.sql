

print 'GRIDVIEWS_COLUMNS ListView Gmail';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.Gmail'
--GO

set nocount on;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.ListView.Gmail', 'Accounts', 'vwACCOUNTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.ListView.Gmail'          , 2, 'Accounts.LBL_LIST_ACCOUNT_NAME'           , 'NAME'                 , 'NAME'                 , '35%', 'listViewTdLinkS1', 'ID'         , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.Gmail'          , 3, 'Accounts.LBL_LIST_BILLING_ADDRESS_CITY'   , 'BILLING_ADDRESS_CITY' , 'BILLING_ADDRESS_CITY' , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.Gmail'          , 4, 'Accounts.LBL_LIST_BILLING_ADDRESS_STATE'  , 'BILLING_ADDRESS_STATE', 'BILLING_ADDRESS_STATE', '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.Gmail'          , 5, 'Accounts.LBL_LIST_PHONE'                  , 'PHONE_OFFICE'         , 'PHONE_OFFICE'         , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.Gmail'          , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.Gmail'          , 7, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Bugs.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Bugs.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Bugs.ListView.Gmail', 'Bugs', 'vwBUGS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.ListView.Gmail'              , 2, 'Bugs.LBL_LIST_NUMBER'                     , 'BUG_NUMBER'      , 'BUG_NUMBER'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Bugs.ListView.Gmail'              , 3, 'Bugs.LBL_LIST_SUBJECT'                    , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID'         , '~/Bugs/view.aspx?id={0}', null, 'Bugs', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.ListView.Gmail'              , 4, 'Bugs.LBL_LIST_STATUS'                     , 'STATUS'          , 'STATUS'          , '10%', 'bug_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.ListView.Gmail'              , 5, 'Bugs.LBL_LIST_TYPE'                       , 'TYPE'            , 'TYPE'            , '10%', 'bug_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Bugs.ListView.Gmail'              , 6, 'Bugs.LBL_LIST_PRIORITY'                   , 'PRIORITY'        , 'PRIORITY'        , '10%', 'bug_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.ListView.Gmail'              , 7, 'Bugs.LBL_LIST_RELEASE'                    , 'FOUND_IN_RELEASE', 'FOUND_IN_RELEASE', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.ListView.Gmail'              , 8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Bugs.ListView.Gmail'              , 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Cases.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Cases.ListView.Gmail', 'Cases', 'vwCASES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.ListView.Gmail'             , 2, 'Cases.LBL_LIST_NUMBER'                    , 'CASE_NUMBER'     , 'CASE_NUMBER'     , '10%', 'listViewTdLinkS1', 'ID'         , '~/Cases/view.aspx?id={0}'   , null, 'Cases'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.ListView.Gmail'             , 3, 'Cases.LBL_LIST_SUBJECT'                   , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID'         , '~/Cases/view.aspx?id={0}'   , null, 'Cases'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.ListView.Gmail'             , 4, 'Cases.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.ListView.Gmail'             , 5, 'Cases.LBL_LIST_PRIORITY'                  , 'PRIORITY'        , 'PRIORITY'        , '10%', 'case_priority_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Cases.ListView.Gmail'             , 6, 'Cases.LBL_LIST_STATUS'                    , 'STATUS'          , 'STATUS'          , '10%', 'case_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Cases.ListView.Gmail'             , 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Cases.ListView.Gmail'             , 8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
end -- if;
GO

-- 11/29/2010 Paul.  Add Email column. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.Gmail';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.ListView.Gmail', 'Contacts', 'vwCONTACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.Gmail'          , 2, 'Contacts.LBL_LIST_NAME'                   , 'NAME'            , 'NAME'            , '15%', 'listViewTdLinkS1', 'ID'         , '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Gmail'          , 3, 'Contacts.LBL_LIST_TITLE'                  , 'TITLE'           , 'TITLE'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.Gmail'          , 4, 'Contacts.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '15%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.ListView.Gmail'          , 5, 'Contacts.LBL_LIST_EMAIL_ADDRESS'          , 'EMAIL1'          , 'EMAIL1'          , '15%', 'listViewTdLinkS1', 'ID'         , '~/Emails/edit.aspx?PARENT_ID={0}'  , null, 'Emails'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Gmail'          , 6, 'Contacts.LBL_LIST_PHONE'                  , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.ListView.Gmail'          , 7, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Gmail'          , 8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '8%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.ListView.Gmail'          , 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Leads.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Leads.ListView.Gmail'         , 'Leads'         , 'vwLEADS_List'         ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.Gmail'             , 2, 'Leads.LBL_LIST_NAME'                      , 'NAME'            , 'NAME'            , '15%', 'listViewTdLinkS1', 'ID'         , '~/Leads/view.aspx?id={0}', null, 'Leads', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Leads.ListView.Gmail'             , 3, 'Leads.LBL_LIST_STATUS'                    , 'STATUS'          , 'STATUS'          , '15%', 'lead_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Gmail'             , 4, 'Leads.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.ListView.Gmail'             , 5, 'Leads.LBL_LIST_EMAIL_ADDRESS'             , 'EMAIL1'          , 'EMAIL1'          , '15%', 'listViewTdLinkS1', 'ID'         , '~/Emails/edit.aspx?PARENT_ID={0}'  , null, 'Emails'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Gmail'             , 6, 'Leads.LBL_LIST_PHONE'                     , 'PHONE_WORK'      , 'PHONE_WORK'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Gmail'             , 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '8%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.ListView.Gmail'             , 8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.ListView.Gmail', 'Opportunities', 'vwOPPORTUNITIES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.Gmail'     , 2, 'Opportunities.LBL_LIST_OPPORTUNITY_NAME'  , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID'         , '~/Opportunities/view.aspx?id={0}', null, 'Opportunities', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.ListView.Gmail'     , 3, 'Opportunities.LBL_LIST_ACCOUNT_NAME'      , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Opportunities.ListView.Gmail'     , 4, 'Opportunities.LBL_LIST_SALES_STAGE'       , 'SALES_STAGE'     , 'SALES_STAGE'     , '10%', 'sales_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.ListView.Gmail'     , 5, 'Opportunities.LBL_LIST_AMOUNT'            , 'AMOUNT_USDOLLAR' , 'AMOUNT_USDOLLAR' , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.ListView.Gmail'     , 6, 'Opportunities.LBL_LIST_DATE_CLOSED'       , 'DATE_CLOSED'     , 'DATE_CLOSED'     , '10%', 'Date'    ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.Gmail'     , 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.ListView.Gmail'     , 8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.ListView.Gmail', 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.Gmail'            , 2, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.Gmail'            , 3, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '25%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.Gmail'            , 4, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.ListView.Gmail'            , 5, 'Quotes.LBL_LIST_QUOTE_STAGE'              , 'QUOTE_STAGE'               , 'QUOTE_STAGE'               , '10%', 'quote_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.Gmail'            , 6, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.Gmail'            , 7, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Gmail'            , 8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Gmail'            , 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.ListView.Gmail', 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.Gmail'            , 2, 'Orders.LBL_LIST_ORDER_NUM'                , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.Gmail'            , 3, 'Orders.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '25%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.Gmail'            , 4, 'Orders.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.ListView.Gmail'            , 5, 'Orders.LBL_LIST_ORDER_STAGE'              , 'ORDER_STAGE'               , 'ORDER_STAGE'               , '10%', 'order_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.Gmail'            , 6, 'Orders.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.Gmail'            , 7, 'Orders.LBL_LIST_DATE_ORDER_DUE'           , 'DATE_ORDER_DUE'            , 'DATE_ORDER_DUE'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Gmail'            , 8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Gmail'            , 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.ListView.Gmail', 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.Gmail'          , 2, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'INVOICE_NUM'               , 'INVOICE_NUM'               , '10%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.Gmail'          , 3, 'Invoices.LBL_LIST_NAME'                   , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.Gmail'          , 4, 'Invoices.LBL_LIST_ACCOUNT_NAME'           , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '15%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.ListView.Gmail'          , 5, 'Invoices.LBL_LIST_INVOICE_STAGE'          , 'INVOICE_STAGE'             , 'INVOICE_STAGE'             , '10%', 'invoice_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.Gmail'          , 6, 'Invoices.LBL_LIST_AMOUNT'                 , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.Gmail'          , 7, 'Invoices.LBL_LIST_AMOUNT_DUE'             , 'AMOUNT_DUE_USDOLLAR'       , 'AMOUNT_DUE_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.Gmail'          , 8, 'Invoices.LBL_LIST_DUE_DATE'               , 'DUE_DATE'                  , 'DUE_DATE'                  , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Gmail'          , 9, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Gmail'          ,10, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.ListView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.ListView.Gmail', 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.ListView.Gmail'         , 2, 'Contracts.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '25%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.ListView.Gmail'         , 3, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}' , null, 'Accounts' , 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.ListView.Gmail'         , 4, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'          , 'STATUS'          , '15%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.ListView.Gmail'         , 5, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'      , 'START_DATE'      , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.ListView.Gmail'         , 6, 'Contracts.LBL_LIST_END_DATE'              , 'END_DATE'        , 'END_DATE'        , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView.Gmail'         , 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView.Gmail'         , 8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
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

call dbo.spGRIDVIEWS_COLUMNS_Gmail()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_Gmail')
/

-- #endif IBM_DB2 */




print 'GRIDVIEWS_COLUMNS Search Professional';
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like '%.Search';
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 08/24/2009 Paul.  Change TEAM_NAME to TEAM_SET_NAME. 
-- 08/28/2009 Paul.  Restore TEAM_NAME and expect it to be converted automatically when DynamicTeams is enabled. 
-- 07/08/2012 Paul.  Shift columns to make room for the Edit icon. 

-- 05/15/2016 Paul.  Add tags to list view. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Search' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.Search';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.Search', 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Search'         , 1, 'Contracts.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '25%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Search'         , 2, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}' , null, 'Accounts' , 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.Search'         , 3, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'          , 'STATUS'          , '20%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.Search'         , 4, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'      , 'START_DATE'      , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Contracts.Search'         , 5, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Search'         , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Search'         , 7, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
end else begin
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Search' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '5%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Contracts.Search'
		   and DATA_FIELD       in ('ASSIGNED_TO_NAME', 'TEAM_NAME')
		   and ITEMSTYLE_WIDTH  = '10%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Contracts.Search'          ,  5, '5%';
	end -- if;
end -- if;
GO

-- 08/03/2010 Paul.  Add global search to Quotes, Orders and Invoices.
-- 05/15/2016 Paul.  Add tags to list view. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Search'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Search' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Search';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Search', 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Search'                 , 1, 'Quotes.LBL_LIST_QUOTE_NUM'                  , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Search'                 , 2, 'Quotes.LBL_LIST_NAME'                       , 'NAME'                      , 'NAME'                      , '30%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Search'                 , 3, 'Quotes.LBL_LIST_ACCOUNT_NAME'               , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '25%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Search'                 , 4, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'           , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Search'                 , 5, 'Quotes.LBL_LIST_AMOUNT'                     , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Quotes.Search'                 , 6, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Search'                 , 7, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Search'                 , 8, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.Search', 5, null, null, 'right', null, null;
end else begin
	-- 07/08/2012 Paul.  Shift columns to make room for the Edit icon. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Search' and COLUMN_INDEX = 0 and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS Quotes.Search: Add space for Edit icon. ';
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX      = COLUMN_INDEX + 1
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where GRID_NAME         = 'Quotes.Search'
		   and DELETED           = 0;
	end -- if;
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Search' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '25%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Quotes.Search'
		   and DATA_FIELD       = 'BILLING_ACCOUNT_NAME'
		   and ITEMSTYLE_WIDTH  = '40%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Quotes.Search'                 , 6, '5%';
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Search'                 , 7, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '5%';
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Search'                 , 8, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
	end -- if;
end -- if;
GO

-- 05/15/2016 Paul.  Add tags to list view. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Search' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Search' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.Search';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.Search', 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Search'                 , 1, 'Orders.LBL_LIST_ORDER_NUM'                  , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'  , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Search'                 , 2, 'Orders.LBL_LIST_NAME'                       , 'NAME'                      , 'NAME'                      , '30%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'  , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Search'                 , 3, 'Orders.LBL_LIST_ACCOUNT_NAME'               , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '25%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.Search'                 , 4, 'Orders.LBL_LIST_DATE_ORDER_DUE'             , 'DATE_ORDER_DUE'            , 'DATE_ORDER_DUE'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.Search'                 , 5, 'Orders.LBL_LIST_AMOUNT'                     , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Orders.Search'                 , 6, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Search'                 , 7, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Search'                 , 8, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.Search', 5, null, null, 'right', null, null;
end else begin
	-- 07/08/2012 Paul.  Shift columns to make room for the Edit icon. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Search' and COLUMN_INDEX = 0 and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS Orders.Search: Add space for Edit icon. ';
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX      = COLUMN_INDEX + 1
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where GRID_NAME         = 'Orders.Search'
		   and DELETED           = 0;
	end -- if;
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Search' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '25%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Orders.Search'
		   and DATA_FIELD       = 'BILLING_ACCOUNT_NAME'
		   and ITEMSTYLE_WIDTH  = '40%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Orders.Search'                 , 6, '5%';
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Search'                 , 7, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '5%';
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Search'                 , 8, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
	end -- if;
end -- if;
GO

-- 05/15/2016 Paul.  Add tags to list view. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Search' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Search' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.Search';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.Search', 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Search'               , 1, 'Invoices.LBL_LIST_INVOICE_NUM'              , 'INVOICE_NUM'               , 'INVOICE_NUM'               , '10%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Search'               , 2, 'Invoices.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Search'               , 3, 'Invoices.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.Search'               , 4, 'Invoices.LBL_LIST_DUE_DATE'                 , 'DUE_DATE'                  , 'DUE_DATE'                  , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.Search'               , 5, 'Invoices.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.Search'               , 6, 'Invoices.LBL_LIST_AMOUNT_DUE'               , 'AMOUNT_DUE_USDOLLAR'       , 'AMOUNT_DUE_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Invoices.Search'               , 7, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Search'               , 8, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Search'               , 9, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.Search', 5, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.Search', 6, null, null, 'right', null, null;
end else begin
	-- 07/08/2012 Paul.  Shift columns to make room for the Edit icon. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Search' and COLUMN_INDEX = 0 and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS Invoices.Search: Add space for Edit icon. ';
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX      = COLUMN_INDEX + 1
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where GRID_NAME         = 'Invoices.Search'
		   and DELETED           = 0;
	end -- if;
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Search' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '20%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Invoices.Search'
		   and DATA_FIELD       = 'BILLING_ACCOUNT_NAME'
		   and ITEMSTYLE_WIDTH  = '30%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Invoices.Search'                 , 7, '10%';
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Search'                 , 8, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '5%';
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Search'                 , 9, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
	end -- if;
end -- if;
GO

-- 08/26/2010 Paul.  Add ability to search payments. 
-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.Search';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.Search' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.Search';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.Search', 'Payments', 'vwPAYMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.Search'               , 1, 'Payments.LBL_LIST_PAYMENT_NUM'              , 'PAYMENT_NUM'               , 'PAYMENT_NUM'               , '15%', 'listViewTdLinkS1', 'ID'        , '~/Payments/view.aspx?id={0}' , null, 'Payments', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.Search'               , 2, 'Payments.LBL_LIST_ACCOUNT_NAME'             , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Payments.Search'               , 3, 'Payments.LBL_LIST_PAYMENT_TYPE'             , 'PAYMENT_TYPE'              , 'PAYMENT_TYPE'              , '15%', 'payment_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Search'               , 4, 'Payments.LBL_LIST_CUSTOMER_REFERENCE'       , 'CUSTOMER_REFERENCE'        , 'CUSTOMER_REFERENCE'        , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.Search'               , 5, 'Payments.LBL_LIST_AMOUNT'                   , 'AMOUNT_USDOLLAR'           , 'AMOUNT_USDOLLAR'           , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.Search'               , 6, 'Payments.LBL_LIST_PAYMENT_DATE'             , 'PAYMENT_DATE'              , 'PAYMENT_DATE'              , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Payments.Search', 4, null, null, 'right', null, null;
end else begin
	-- 07/08/2012 Paul.  Shift columns to make room for the Edit icon. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.Search' and COLUMN_INDEX = 0 and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS Payments.Search: Add space for Edit icon. ';
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX      = COLUMN_INDEX + 1
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where GRID_NAME         = 'Payments.Search'
		   and DELETED           = 0;
	end -- if;
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
	/*
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.Search' and DATA_FIELD = 'PAYMENT_TYPE' and LIST_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		update GRIDVIEWS_COLUMNS
		   set LIST_NAME         = 'PaymentTypes'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where GRID_NAME         = 'Payments.Search'
		   and DATA_FIELD        = 'PAYMENT_TYPE'
		   and LIST_NAME         = 'payment_type_dom'
		   and DELETED           = 0;
	end -- if;
	*/
	-- 02/15/2015 Paul.  Customer Reference is not a list. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.Search' and DATA_FIELD = 'CUSTOMER_REFERENCE' and LIST_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set DELETED           = 1              
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where GRID_NAME         = 'Payments.Search'
		   and DATA_FIELD        = 'CUSTOMER_REFERENCE'
		   and LIST_NAME         = 'payment_type_dom'
		   and DELETED           = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Search'               , 4, 'Payments.LBL_LIST_CUSTOMER_REFERENCE'       , 'CUSTOMER_REFERENCE'        , 'CUSTOMER_REFERENCE'        , '20%';
	end -- if;
end -- if;
GO

-- 10/02/2010 Paul.  Add searching of OrdersLineItems. 
-- 10/18/2010 Paul.  Fix URL to Orders. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'OrdersLineItems.Search' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'OrdersLineItems.Search' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS OrdersLineItems.Search';
	exec dbo.spGRIDVIEWS_InsertOnly           'OrdersLineItems.Search', 'Orders', 'vwACCOUNTS_ORDERS_LINE_ITEMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'OrdersLineItems.Search'        , 1, 'Orders.LBL_LIST_ACCOUNT_NAME'               , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '15%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}'               , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'OrdersLineItems.Search'        , 2, 'Orders.LBL_BILLING_CONTACT_NAME'            , 'BILLING_CONTACT_NAME'      , 'BILLING_CONTACT_NAME'      , '15%', 'listViewTdLinkS1', 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?id={0}'               , null, 'Contacts', 'BILLING_CONTACT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'OrdersLineItems.Search'        , 3, 'Orders.LBL_LIST_ORDER_NUM'                  , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '10%', 'listViewTdLinkS1', 'ORDER_ID'           , '~/Orders/view.aspx?id={0}'                 , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'OrdersLineItems.Search'        , 4, 'Orders.LBL_LIST_ITEM_NAME'                  , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID'                 , '~/OrdersLineItems/view.aspx?id={0}'        , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'OrdersLineItems.Search'        , 5, 'Orders.LBL_LIST_ITEM_MFT_PART_NUM'          , 'MFT_PART_NUM'              , 'MFT_PART_NUM'              , '10%', 'listViewTdLinkS1', 'ID'                 , '~/OrdersLineItems/view.aspx?id={0}'        , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'OrdersLineItems.Search'        , 6, '.LBL_LIST_ASSIGNED_USER'                    , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'OrdersLineItems.Search'        , 7, 'Teams.LBL_LIST_TEAM'                        , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '10%';
end else begin
	-- 07/08/2012 Paul.  Shift columns to make room for the Edit icon. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'OrdersLineItems.Search' and COLUMN_INDEX = 0 and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS OrdersLineItems.Search: Add space for Edit icon. ';
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX      = COLUMN_INDEX + 1
		     , MODIFIED_USER_ID  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where GRID_NAME         = 'OrdersLineItems.Search'
		   and DELETED           = 0;
	end -- if;
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

call dbo.spGRIDVIEWS_COLUMNS_SearchProfessional()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_SearchProfessional')
/

-- #endif IBM_DB2 */


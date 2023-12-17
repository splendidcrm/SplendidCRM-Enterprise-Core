

print 'GRIDVIEWS_COLUMNS ListView.Mobile Professional';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.Mobile'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.ListView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.ListView.Mobile', 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.ListView.Mobile'         , 1, 'Contracts.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '25%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.ListView.Mobile'         , 2, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}' , null, 'Accounts' , 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.ListView.Mobile'         , 3, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'          , 'STATUS'          , '15%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.ListView.Mobile'         , 4, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'      , 'START_DATE'      , '10%', 'Date';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.ListView.Mobile' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'Products.ListView.Mobile', 'Products', 'vwPRODUCTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.ListView.Mobile'          , 1, 'Products.LBL_LIST_NAME'                   , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID'         , '~/Products/view.aspx?id={0}', null, 'Products', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.ListView.Mobile'          , 2, 'Products.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'        , 'ACCOUNT_NAME'        , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Products.ListView.Mobile'          , 3, 'Products.LBL_LIST_LIST_PRICE'             , 'DISCOUNT_USDOLLAR'   , 'DISCOUNT_USDOLLAR'   , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Products.ListView.Mobile'          , 4, 'Products.LBL_LIST_DATE_PURCHASED'         , 'DATE_PURCHASED'      , 'DATE_PURCHASED'      , '10%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView.Mobile' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView.Mobile' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.ListView.Mobile', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	-- 03/22/2013 Paul.  ASSIGNED_USER_ID does not apply to ProductTemplates. 
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTemplates.ListView.Mobile'  , 1, 'ProductTemplates.LBL_LIST_NAME'           , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID'         , '~/Administration/ProductTemplates/view.aspx?id={0}', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProductTemplates.ListView.Mobile'  , 2, 'ProductTemplates.LBL_LIST_STATUS'         , 'STATUS'              , 'STATUS'              , '10%', 'product_template_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Mobile'  , 3, 'ProductTemplates.LBL_LIST_QUANTITY'       , 'QUANTITY'            , 'QUANTITY'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView.Mobile'  , 4, 'ProductTemplates.LBL_LIST_BOOK_VALUE'     , 'DISCOUNT_USDOLLAR'   , 'DISCOUNT_USDOLLAR'   , '10%', 'Currency';
end else begin
	-- 03/22/2013 Paul.  ASSIGNED_USER_ID does not apply to ProductTemplates. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView.Mobile' and URL_ASSIGNED_FIELD = 'ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		print 'ASSIGNED_USER_ID does not apply to ProductTemplates.';
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , URL_MODULE         = 'ProductTemplates'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'ProductTemplates.ListView.Mobile'
		   and URL_ASSIGNED_FIELD = 'ASSIGNED_USER_ID'
		   and DELETED            = 0 ;
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.Mobile' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.ListView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.ListView.Mobile', 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.Mobile'            , 0, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'QUOTE_NUM'           , 'QUOTE_NUM'           , '10%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.Mobile'            , 1, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.Mobile'            , 2, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME', 'BILLING_ACCOUNT_NAME', '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.ListView.Mobile'            , 3, 'Quotes.LBL_LIST_QUOTE_STAGE'              , 'QUOTE_STAGE'         , 'QUOTE_STAGE'         , '10%', 'quote_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.Mobile'            , 4, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'      , 'TOTAL_USDOLLAR'      , '10%', 'Currency';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.ListView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.ListView.Mobile', 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.Mobile'            , 1, 'Orders.LBL_LIST_ORDER_NUM'                , 'ORDER_NUM'           , 'ORDER_NUM'           , '10%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.Mobile'            , 2, 'Orders.LBL_LIST_NAME'                     , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.Mobile'            , 3, 'Orders.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME', 'BILLING_ACCOUNT_NAME', '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.ListView.Mobile'            , 4, 'Orders.LBL_LIST_ORDER_STAGE'              , 'ORDER_STAGE'         , 'ORDER_STAGE'         , '10%', 'order_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.Mobile'            , 5, 'Orders.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'      , 'TOTAL_USDOLLAR'      , '10%', 'Currency';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.ListView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.ListView.Mobile', 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.Mobile'          , 1, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'INVOICE_NUM'         , 'INVOICE_NUM'         , '10%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.Mobile'          , 2, 'Invoices.LBL_LIST_NAME'                   , 'NAME'                , 'NAME'                , '20%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.Mobile'          , 3, 'Invoices.LBL_LIST_ACCOUNT_NAME'           , 'BILLING_ACCOUNT_NAME', 'BILLING_ACCOUNT_NAME', '15%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.Mobile'          , 4, 'Invoices.LBL_LIST_AMOUNT'                 , 'TOTAL_USDOLLAR'      , 'TOTAL_USDOLLAR'      , '10%', 'Currency';
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.ListView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.ListView.Mobile', 'Payments', 'vwPAYMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.ListView.Mobile'          , 1, 'Payments.LBL_LIST_PAYMENT_NUM'            , 'PAYMENT_NUM'         , 'PAYMENT_NUM'         , '10%', 'listViewTdLinkS1', 'ID'        , '~/Payments/view.aspx?id={0}' , null, 'Payments', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.ListView.Mobile'          , 2, 'Payments.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'        , 'ACCOUNT_NAME'        , '15%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Payments.ListView.Mobile'          , 3, 'Payments.LBL_LIST_PAYMENT_TYPE'           , 'PAYMENT_TYPE'        , 'PAYMENT_TYPE'        , '10%', 'payment_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView.Mobile'          , 4, 'Payments.LBL_LIST_AMOUNT'                 , 'AMOUNT_USDOLLAR'     , 'AMOUNT_USDOLLAR'     , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView.Mobile'          , 5, 'Payments.LBL_LIST_PAYMENT_DATE'           , 'PAYMENT_DATE'        , 'PAYMENT_DATE'        , '10%', 'Date';
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView.Mobile' and DATA_FIELD = 'PAYMENT_TYPE' and LIST_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
		--update GRIDVIEWS_COLUMNS
		--   set LIST_NAME         = 'PaymentTypes'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where GRID_NAME         = 'Payments.ListView.Mobile'
		--   and DATA_FIELD        = 'PAYMENT_TYPE'
		--   and LIST_NAME         = 'payment_type_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Forums.ListView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Forums.ListView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Forums.ListView.Mobile', 'Forums', 'vwFORUMS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Forums.ListView.Mobile'            , 0, 'Forums.LBL_LIST_TITLE'                    , 'TITLE'                      , 'TITLE'                      , '30%', 'listViewTdLinkS1', 'ID'            , 'view.aspx?id={0}'           , null, 'Forums', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Forums.ListView.Mobile'            , 1, 'Forums.LBL_LIST_LAST_THREAD_TITLE'        , 'LAST_THREAD_TITLE'          , 'LAST_THREAD_TITLE'          , '25%', 'listViewTdLinkS1', 'LAST_THREAD_ID', '~/Threads/view.aspx?id={0}' , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Forums.ListView.Mobile'            , 2, 'Forums.LBL_LIST_LAST_THREAD_CREATED_BY'   , 'LAST_THREAD_CREATED_BY_NAME', 'LAST_THREAD_CREATED_BY_NAME', '10%';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Forums.ListView.Mobile' and HEADER_TEXT = 'Forums.LBL_LIST_TITLE' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/04/2008 Paul.  Forums.Mobile have a title, not a name.
		print 'Forums.Mobile have a title, not a name.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'TITLE'
		     , SORT_EXPRESSION    = 'TITLE'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Forums.ListView.Mobile'
		   and HEADER_TEXT        = 'Forums.LBL_LIST_TITLE'
		   and DATA_FIELD         = 'NAME'
		   and URL_FIELD          = 'ID'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 12/29/2009 Paul.  Use global term LBL_LIST_CREATED_BY. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.ListView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Threads.ListView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Threads.ListView.Mobile', 'Forums', 'vwTHREADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Threads.ListView.Mobile'           , 0, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'               , null, '25%', 'listViewTdLinkS1', 'ID'          , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.ListView.Mobile'           , 1, '.LBL_LIST_CREATED_BY'                     , 'CREATED_BY_NAME'     , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Threads.ListView.Mobile'           , 2, 'Threads.LBL_LIST_LAST_POST_TITLE'         , 'LAST_POST_TITLE'     , null, '20%', 'listViewTdLinkS1', 'LAST_POST_ID', '~/Posts/view.aspx?id={0}'     , null, 'Posts'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.ListView.Mobile'           , 3, 'Threads.LBL_LIST_LAST_POST_CREATED_BY'    , 'LAST_POST_CREATED_BY_NAME', null, '10%';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.ListView.Mobile' and HEADER_TEXT = 'Threads.LBL_LIST_TITLE' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/04/2008 Paul.  Threasds.Mobile have a title, not a name.
		print 'Threads.Mobile have a title, not a name.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'TITLE'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Threads.ListView.Mobile'
		   and HEADER_TEXT        = 'Threads.LBL_LIST_TITLE'
		   and DATA_FIELD         = 'NAME'
		   and URL_FIELD          = 'ID'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.ListView.Mobile' and HEADER_TEXT = 'Threads.LBL_LIST_CREATED_BY' and DELETED = 0) begin -- then
		print 'Threads.ListView.Mobile: Use global term LBL_LIST_CREATED_BY.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT        = '.LBL_LIST_CREATED_BY'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Threads.ListView.Mobile'
		   and HEADER_TEXT        = 'Threads.LBL_LIST_CREATED_BY'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 12/29/2009 Paul.  Use global term LBL_LIST_CREATED_BY. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Posts.ListView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Posts.ListView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Posts.ListView.Mobile', 'Posts', 'vwTHREADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Posts.ListView.Mobile'             , 0, 'Posts.LBL_LIST_TITLE'                     , 'TITLE'                  , null, '60%', 'listViewTdLinkS1', 'ID'          , '~/Posts/view.aspx?id={0}'   , null, 'Posts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.ListView.Mobile'             , 1, '.LBL_LIST_CREATED_BY'                     , 'CREATED_BY_NAME'        , null, '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Posts.ListView.Mobile'             , 2, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , null, '15%', 'DateTime';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Posts.ListView.Mobile' and HEADER_TEXT = 'Posts.LBL_LIST_CREATED_BY' and DELETED = 0) begin -- then
		print 'Posts.ListView.Mobile: Use global term LBL_LIST_CREATED_BY.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT        = '.LBL_LIST_CREATED_BY'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Posts.ListView.Mobile'
		   and HEADER_TEXT        = 'Posts.LBL_LIST_CREATED_BY'
		   and DELETED            = 0;
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

call dbo.spGRIDVIEWS_COLUMNS_MobileProfessional()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_MobileProfessional')
/

-- #endif IBM_DB2 */


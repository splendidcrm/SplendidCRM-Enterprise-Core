

print 'GRIDVIEWS_COLUMNS SubPanel Professional';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME not like '%.ListView'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 06/08/2006 Paul.  Add Products. 
-- 12/28/2007 Paul.  Products now displays information from the ORDERS_LINE_ITEMS table, so some of the fields need to change. 
-- 01/02/2008 Paul.  Products needs to display line items and products.
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 06/07/2015 Paul.  Add Preview button. 

-- 02/14/2012 Paul.  Products link to OrdersLineItems, not products.  Products is the old table. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Products';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Products' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.Products';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.Products', 'Accounts', 'vwACCOUNTS_PRODUCTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Accounts.Products'               , 0, 'Orders.LBL_LIST_ORDER_STAGE'              , 'ORDER_STAGE'               , 'ORDER_STAGE'               , '10%', 'order_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Products'               , 1, 'Products.LBL_LIST_NAME'                   , 'PRODUCT_NAME'              , 'PRODUCT_NAME'              , '20%', 'listViewTdLinkS1', 'ID', '~/OrdersLineItems/view.aspx?id={0}', null, 'OrdersLineItems', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Products'               , 2, 'Products.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '15%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Products'               , 3, 'Products.LBL_LIST_CONTACT_NAME'           , 'CONTACT_NAME'              , 'CONTACT_NAME'              , '15%', 'listViewTdLinkS1', 'CONTACT_ID', '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Products'               , 4, 'Products.LBL_LIST_DATE_PURCHASED'         , 'DATE_PURCHASED'            , 'DATE_PURCHASED'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Products'               , 5, 'Orders.LBL_LIST_ITEM_EXTENDED_PRICE'      , 'EXTENDED_USDOLLAR'         , 'EXTENDED_USDOLLAR'         , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Products'             , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Products' and HEADER_TEXT = 'Products.LBL_LIST_NAME' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/02/2008 Paul.  The primary records will be from the orders line items. 
		print 'Accounts.Products needs to display line items and products.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'PRODUCT_NAME'
		     , SORT_EXPRESSION    = 'PRODUCT_NAME'
		     , URL_FIELD          = 'PRODUCT_ID'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Accounts.Products'
		   and HEADER_TEXT        = 'Products.LBL_LIST_NAME'
		   and DATA_FIELD         = 'NAME'
		   and URL_FIELD          = 'ID'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Products' and DATA_FIELD = 'DATE_SUPPORT_EXPIRES' and DELETED = 0) begin -- then
		print 'Drop DATE_SUPPORT_EXPIRES from product view.';
		update GRIDVIEWS_COLUMNS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Accounts.Products'
		   and DATA_FIELD       = 'DATE_SUPPORT_EXPIRES'
		   and DELETED          = 0 ;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Products' and DATA_FIELD = 'COST_USDOLLAR' and DELETED = 0) begin -- then
		print 'Change COST_USDOLLAR to EXTENDED_USDOLLAR in product view.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT      = 'Orders.LBL_LIST_ITEM_EXTENDED_PRICE'
		     , DATA_FIELD       = 'EXTENDED_USDOLLAR'
		     , SORT_EXPRESSION  = 'EXTENDED_USDOLLAR'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Accounts.Products'
		   and DATA_FIELD       = 'COST_USDOLLAR'
		   and DELETED          = 0 ;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Products' and DATA_FIELD = 'STATUS' and DELETED = 0) begin -- then
		print 'Change STATUS to SALES_STAGE in product view.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT      = 'Orders.LBL_LIST_ORDER_STAGE'
		     , DATA_FIELD       = 'ORDER_STAGE'
		     , SORT_EXPRESSION  = 'ORDER_STAGE'
		     , LIST_NAME        = 'order_stage_dom'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Accounts.Products'
		   and DATA_FIELD       = 'STATUS'
		   and DELETED          = 0 ;
	end -- if;
	-- 02/14/2012 Paul.  Products link to OrdersLineItems, not products.  Products is the old table. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Products' and URL_FIELD = 'PRODUCT_ID' and DELETED = 0) begin -- then
		print 'Change PRODUCT_ID to ID in product view.';
		update GRIDVIEWS_COLUMNS
		   set URL_FIELD        = 'ID'
		     , URL_FORMAT       = '~/OrdersLineItems/view.aspx?id={0}'
		     , URL_MODULE       = 'OrdersLineItems'
		     , MODULE_TYPE      = null   -- 02/15/2012 Paul.  MODULE_TYPE must be NULL, otherwise we will lookup the name using the DATA_FIELD. 
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Accounts.Products'
		   and URL_FIELD        = 'PRODUCT_ID'
		   and DELETED          = 0 ;
	end -- if;
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Products' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Products'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/21/2007 Paul.  DATA_FIELD should never be an ID field. 
if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Products' and DATA_FIELD = 'CONTACT_ID' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.Products: Fix CONTACT_NAME';
	update GRIDVIEWS_COLUMNS
	   set DATA_FIELD       = 'CONTACT_NAME'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where GRID_NAME        = 'Accounts.Products'
	   and DATA_FIELD       = 'CONTACT_ID'
	   and DELETED          = 0;
end -- if;
GO

-- 06/08/2006 Paul.  Add Quotes. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Quotes'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Quotes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.Quotes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.Quotes', 'Accounts', 'vwACCOUNTS_QUOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Quotes'                 , 0, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Quotes'                 , 1, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '40%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Quotes'                 , 2, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Quotes'                 , 3, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Quotes'               , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Quotes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Quotes'           , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/08/2006 Paul.  Add Contracts. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Contracts' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Contracts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.Contracts';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.Contracts', 'Accounts', 'vwACCOUNTS_CONTRACTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Contracts'              , 0, 'Contracts.LBL_LIST_NAME'                  , 'NAME'                         , 'NAME'                         , '25%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Contracts'              , 1, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'                 , 'ACCOUNT_NAME'                 , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}' , null, 'Accounts' , 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Contracts'              , 2, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'                   , 'START_DATE'                   , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Contracts'              , 3, 'Contracts.LBL_LIST_END_DATE'              , 'END_DATE'                     , 'END_DATE'                     , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Accounts.Contracts'              , 4, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'                       , 'STATUS'                       , '15%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Contracts'              , 5, 'Contracts.LBL_LIST_CONTRACT_VALUE'        , 'TOTAL_CONTRACT_VALUE_USDOLLAR', 'TOTAL_CONTRACT_VALUE_USDOLLAR', '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Contracts'            , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Contracts' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Contracts'        , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 02/13/2009 Paul.  Add contract activities.
-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Activities.Open' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.Activities.Open';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.Activities.Open', 'Contracts', 'vwCONTRACTS_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Activities.Open'           , 2, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'          , 'ACTIVITY_NAME'          , '20%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.Activities.Open'           , 3, 'Activities.LBL_LIST_STATUS'               , 'STATUS'                 , 'STATUS'                 , '10%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Activities.Open'           , 4, 'Activities.LBL_LIST_CONTACT'              , 'CONTACT_NAME'           , 'CONTACT_NAME'           , '20%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}'  , null, 'Contacts'  , 'CONTACT_ASSIGNED_USER_ID' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Activities.Open'           , 5, 'Activities.LBL_LIST_RELATED_TO'           , 'CONTRACT_NAME'          , 'CONTRACT_NAME'          , '20%', 'listViewTdLinkS1', 'CONTRACT_ID', '~/Contracts/view.aspx?id={0}' , null, 'Contracts' , 'CONTRACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.Activities.Open'           , 6, 'Activities.LBL_LIST_DUE_DATE'             , 'DATE_DUE'               , 'DATE_DUE'               , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Activities.Open'         , 7, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Activities.Open' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Activities.Open'     , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Activities.History' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.Activities.History';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.Activities.History', 'Contracts', 'vwCONTRACTS_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Activities.History'        , 1, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'          , 'ACTIVITY_NAME'          , '20%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.Activities.History'        , 2, 'Activities.LBL_LIST_STATUS'               , 'STATUS'                 , 'STATUS'                 , '10%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Activities.History'        , 3, 'Activities.LBL_LIST_CONTACT'              , 'CONTACT_NAME'           , 'CONTACT_NAME'           , '20%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}'  , null, 'Contacts'  , 'CONTACT_ASSIGNED_USER_ID' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Activities.History'        , 4, 'Activities.LBL_LIST_RELATED_TO'           , 'CONTRACT_NAME'          , 'CONTRACT_NAME'          , '20%', 'listViewTdLinkS1', 'CONTRACT_ID', '~/Contracts/view.aspx?id={0}' , null, 'Contracts' , 'CONTRACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.Activities.History'        , 5, 'Activities.LBL_LIST_LAST_MODIFIED'        , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Activities.History'      , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Activities.History' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Activities.History'  , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/08/2006 Paul.  Add Products. 
-- 04/28/2008 Paul.  Use ORDER_STAGE instead of STATUS. 
-- 02/14/2012 Paul.  Products link to OrdersLineItems, not products.  Products is the old table. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Products';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Products' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.Products';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.Products', 'Contacts', 'vwCONTACTS_PRODUCTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contacts.Products'               , 0, 'Orders.LBL_LIST_ORDER_STAGE'              , 'ORDER_STAGE'               , 'ORDER_STAGE'               , '10%', 'order_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Products'               , 1, 'Products.LBL_LIST_NAME'                   , 'PRODUCT_NAME'              , 'PRODUCT_NAME'              , '20%', 'listViewTdLinkS1', 'ID', '~/OrdersLineItems/view.aspx?id={0}', null, 'OrdersLineItems', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Products'               , 2, 'Products.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '15%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Products'               , 3, 'Products.LBL_LIST_CONTACT_NAME'           , 'CONTACT_NAME'              , 'ACCOUNT_NAME'              , '15%', 'listViewTdLinkS1', 'CONTACT_ID', '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Products'               , 4, 'Products.LBL_LIST_DATE_PURCHASED'         , 'DATE_PURCHASED'            , 'DATE_PURCHASED'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Products'               , 5, 'Products.LBL_LIST_COST'                   , 'COST_USDOLLAR'             , 'COST_USDOLLAR'             , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Products'               , 6, 'Products.LBL_LIST_DATE_SUPPORT_EXPIRES'   , 'DATE_SUPPORT_EXPIRES'      , 'DATE_SUPPORT_EXPIRES'      , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contacts.Products'             , 7, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Products' and DATA_FIELD = 'CONTACT_ID' and URL_FIELD = 'CONTACT_ID' and DELETED = 0) begin -- then
		-- 09/30/2008 Paul.  Fix contact name. 
		print 'Contacts.Products needs to fix the contact name.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'CONTACT_NAME'
		     , SORT_EXPRESSION    = 'CONTACT_NAME'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Contacts.Products'
		   and DATA_FIELD         = 'CONTACT_ID'
		   and URL_FIELD          = 'CONTACT_ID'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Products' and HEADER_TEXT = 'Products.LBL_LIST_NAME' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/02/2008 Paul.  The primary records will be from the orders line items. 
		-- 02/09/2008 Paul.  Fix header text so that update will proceed. 
		print 'Contacts.Products needs to display line items and products.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'PRODUCT_NAME'
		     , SORT_EXPRESSION    = 'PRODUCT_NAME'
		     , URL_FIELD          = 'PRODUCT_ID'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Contacts.Products'
		   and HEADER_TEXT        = 'Products.LBL_LIST_NAME'
		   and DATA_FIELD         = 'NAME'
		   and URL_FIELD          = 'ID'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Products' and DATA_FIELD = 'STATUS' and DELETED = 0) begin -- then
		print 'Change STATUS to SALES_STAGE in product view.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT      = 'Orders.LBL_LIST_ORDER_STAGE'
		     , DATA_FIELD       = 'ORDER_STAGE'
		     , SORT_EXPRESSION  = 'ORDER_STAGE'
		     , LIST_NAME        = 'order_stage_dom'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Contacts.Products'
		   and DATA_FIELD       = 'STATUS'
		   and DELETED          = 0 ;
	end -- if;
	-- 02/14/2012 Paul.  Products link to OrdersLineItems, not products.  Products is the old table. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Products' and URL_FIELD = 'PRODUCT_ID' and DELETED = 0) begin -- then
		print 'Change PRODUCT_ID to ID in product view.';
		update GRIDVIEWS_COLUMNS
		   set URL_FIELD        = 'ID'
		     , URL_FORMAT       = '~/OrdersLineItems/view.aspx?id={0}'
		     , URL_MODULE       = 'OrdersLineItems'
		     , MODULE_TYPE      = null   -- 02/15/2012 Paul.  MODULE_TYPE must be NULL, otherwise we will lookup the name using the DATA_FIELD. 
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Contacts.Products'
		   and URL_FIELD        = 'PRODUCT_ID'
		   and DELETED          = 0 ;
	end -- if;
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Products' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contacts.Products'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/08/2006 Paul.  Add Quotes. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Quotes'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Quotes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.Quotes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.Quotes', 'Contacts', 'vwCONTACTS_QUOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Quotes'                 , 0, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Quotes'                 , 1, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '40%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Quotes'                 , 2, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Quotes'                 , 3, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contacts.Quotes'               , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Quotes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contacts.Quotes'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 08/18/2010 Paul.  Add Contacts.Invoices relationship. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Invoices' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Invoices' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.Invoices';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.Invoices', 'Contacts', 'vwCONTACTS_INVOICES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Invoices'               , 0, 'Invoices.LBL_LIST_INVOICE_NUM'              , 'INVOICE_NUM'            , 'INVOICE_NUM'            , '10%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Invoices'               , 1, 'Invoices.LBL_LIST_NAME'                     , 'INVOICE_NAME'           , 'INVOICE_NAME'           , '30%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Invoices'               , 2, 'Invoices.LBL_LIST_DUE_DATE'                 , 'DUE_DATE'               , 'DUE_DATE'               , '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Invoices'               , 3, 'Invoices.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Invoices'               , 4, 'Invoices.LBL_LIST_AMOUNT_DUE'               , 'AMOUNT_DUE_USDOLLAR'    , 'AMOUNT_DUE_USDOLLAR'    , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Contacts.Invoices', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Contacts.Invoices', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contacts.Invoices'             , 5, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Invoices' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contacts.Invoices'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 01/16/2013 Paul.  Add Contacts.Orders relationship. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Orders' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Orders' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.Orders';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.Orders', 'Contacts', 'vwCONTACTS_ORDERS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Orders'                 , 0, 'Orders.LBL_LIST_ORDER_NUM'                  , 'ORDER_NUM'              , 'ORDER_NUM'              , '10%', 'listViewTdLinkS1', 'ORDER_ID', '~/Orders/view.aspx?id={0}', null, 'Orders', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Orders'                 , 1, 'Orders.LBL_LIST_NAME'                       , 'ORDER_NAME'             , 'ORDER_NAME'             , '30%', 'listViewTdLinkS1', 'ORDER_ID', '~/Orders/view.aspx?id={0}', null, 'Orders', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Orders'                 , 2, 'Orders.LBL_LIST_DATE_ORDER_DUE'             , 'DATE_ORDER_DUE'         , 'DATE_ORDER_DUE'         , '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Orders'                 , 3, 'Orders.LBL_LIST_AMOUNT'                     , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Contacts.Orders', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contacts.Orders'              , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Orders' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contacts.Orders'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 03/14/2016 Paul.  Allow a contract to be created from a Contact. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Contracts' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.Contracts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.Contracts';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.Contracts', 'Contacts', 'vwCONTACTS_CONTRACTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.Contracts'              , 0, 'Contracts.LBL_LIST_NAME'                  , 'NAME'                         , 'NAME'                         , '40%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Contracts'              , 1, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'                   , 'START_DATE'                   , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Contracts'              , 2, 'Contracts.LBL_LIST_END_DATE'              , 'END_DATE'                     , 'END_DATE'                     , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contacts.Contracts'              , 3, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'                       , 'STATUS'                       , '15%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.Contracts'              , 4, 'Contracts.LBL_LIST_CONTRACT_VALUE'        , 'TOTAL_CONTRACT_VALUE_USDOLLAR', 'TOTAL_CONTRACT_VALUE_USDOLLAR', '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contacts.Contracts'            , 5, null, '1%', 'ID', 'Preview', 'preview_inline';
end -- if;
GO

-- 06/08/2006 Paul.  Add Quotes. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Emails.Quotes'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Emails.Quotes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Emails.Quotes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Emails.Quotes', 'Emails', 'vwEMAILS_QUOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Emails.Quotes'                   , 0, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Emails.Quotes'                   , 1, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '40%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Emails.Quotes'                   , 2, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Emails.Quotes'                   , 3, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Emails.Quotes'                 , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Emails.Quotes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Emails.Quotes'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spGRIDVIEWS_COLUMNS_SubPanelsProfessional()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_SubPanelsProfessional')
/



Create Procedure dbo.spGRIDVIEWS_COLUMNS_SubPanelsProfessional()
language sql
  begin
-- #endif IBM_DB2 */

-- 06/08/2006 Paul.  Add Quotes. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.Quotes'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.Quotes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.Quotes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.Quotes', 'Opportunities', 'vwOPPORTUNITIES_QUOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.Quotes'            , 0, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.Quotes'            , 1, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '40%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.Quotes'            , 2, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.Quotes'            , 3, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Opportunities.Quotes'          , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.Quotes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Opportunities.Quotes'      , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/09/2006 Paul.  Add Contracts. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.Contracts' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.Contracts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.Contracts';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.Contracts', 'Opportunities', 'vwOPPORTUNITIES_CONTRACTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.Contracts'         , 0, 'Contracts.LBL_LIST_NAME'                  , 'NAME'                         , 'NAME'                         , '25%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.Contracts'         , 1, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'                 , 'ACCOUNT_NAME'                 , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}' , null, 'Accounts' , 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.Contracts'         , 2, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'                   , 'START_DATE'                   , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.Contracts'         , 3, 'Contracts.LBL_LIST_END_DATE'              , 'END_DATE'                     , 'END_DATE'                     , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Opportunities.Contracts'         , 4, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'                       , 'STATUS'                       , '15%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.Contracts'         , 5, 'Contracts.LBL_LIST_CONTRACT_VALUE'        , 'TOTAL_CONTRACT_VALUE_USDOLLAR', 'TOTAL_CONTRACT_VALUE_USDOLLAR', '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Opportunities.Contracts'       , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.Contracts' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Opportunities.Contracts'   , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/08/2006 Paul.  Add Quotes. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Project.Quotes'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Project.Quotes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Project.Quotes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Project.Quotes', 'Project', 'vwPROJECTS_QUOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Project.Quotes'                  , 0, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Project.Quotes'                  , 1, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '40%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Project.Quotes'                  , 2, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Project.Quotes'                  , 3, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Project.Quotes'                , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Project.Quotes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Project.Quotes'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Documents' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.Documents';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.Documents', 'Contracts', 'vwCONTRACTS_DOCUMENTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Documents'             , 0, 'Documents.LBL_LIST_DOCUMENT_NAME'        , 'DOCUMENT_NAME'           , 'DOCUMENT_NAME'           , '40%', 'listViewTdLinkS1', 'ID'         , '~/Documents/view.aspx?id={0}', null, 'Documents', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Documents'             , 1, 'Documents.LBL_LIST_IS_TEMPLATE'          , 'IS_TEMPLATE'             , 'IS_TEMPLATE'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Documents'             , 2, 'Documents.LBL_LIST_TEMPLATE_TYPE'        , 'TEMPLATE_TYPE'           , 'TEMPLATE_TYPE'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Documents'             , 3, 'Documents.LBL_LIST_SELECTED_REVISION'    , 'SELECTED_REVISION'       , 'SELECTED_REVISION'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Documents'             , 4, 'Documents.LBL_LIST_REVISION'             , 'REVISION'                , 'REVISION'                , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Documents'           , 5, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Documents' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Documents'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Notes'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Notes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.Notes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.Notes', 'Contracts', 'vwCONTRACTS_NOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Notes'                 , 0, 'Notes.LBL_LIST_SUBJECT'                   , 'NAME'                   , 'NAME'                   , '40%', 'listViewTdLinkS1', 'ID'         , '~/Notes/view.aspx?id={0}'   , null, 'Notes'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Notes'                 , 1, 'Notes.LBL_LIST_CONTACT_NAME'              , 'CONTACT_NAME'           , 'CONTACT_NAME'           , '10%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Notes'                 , 2, 'Notes.LBL_LIST_RELATED_TO'                , 'PARENT_NAME'            , 'PARENT_NAME'            , '10%', 'listViewTdLinkS1', 'PARENT_ID'  , '~/Parents/view.aspx?id={0}' , null, 'Parents' , 'PARENT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.Notes'                 , 3, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Notes'               , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Notes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Notes'           , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Contacts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.Contacts';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.Contacts', 'Contracts', 'vwCONTRACTS_CONTACTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Contacts'              , 0, 'Contacts.LBL_LIST_CONTACT_NAME'           , 'NAME'                   , 'NAME'                   , '25%', 'listViewTdLinkS1', 'ID', '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Contacts'              , 1, 'Contacts.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Contacts'              , 2, 'Contacts.LBL_LIST_EMAIL_ADDRESS'          , 'EMAIL1'                 , 'EMAIL1'                 , '25%', 'listViewTdLinkS1', 'EMAIL1'    , 'mailto:{0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Contacts'              , 3, 'Contacts.LBL_LIST_PHONE'                  , 'PHONE_WORK'             , 'PHONE_WORK'             , '15%';  --  ItemStyle-Wrap='false'
	-- MODIFIED_USER_ID, GRID_NAME, COLUMN_INDEX, ITEMSTYLE_WIDTH, ITEMSTYLE_CSSCLASS, ITEMSTYLE_HORIZONTAL_ALIGN, ITEMSTYLE_VERTICAL_ALIGN, ITEMSTYLE_WRAP
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Contracts.Contacts'        , 3, null, null, null, null, 0;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Contacts'            , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Contacts' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Contacts'        , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 01/02/2008 Paul.  Products needs to display line items and products.
-- 05/08/2008 Paul.  Remove STATUS from Contracts.Products.
-- 02/14/2012 Paul.  Products link to OrdersLineItems, not products.  Products is the old table. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Products';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Products' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.Products';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.Products', 'Contracts', 'vwCONTRACTS_PRODUCTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Products'              , 0, 'Products.LBL_LIST_NAME'                   , 'PRODUCT_NAME'              , 'PRODUCT_NAME'              , '20%', 'listViewTdLinkS1', 'ID', '~/OrdersLineItems/view.aspx?id={0}', null, 'OrdersLineItems', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Products'              , 1, 'Products.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '15%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Products'              , 2, 'Products.LBL_LIST_CONTACT_NAME'           , 'CONTACT_NAME'              , 'CONTACT_NAME'              , '15%', 'listViewTdLinkS1', 'CONTACT_ID', '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.Products'              , 3, 'Products.LBL_LIST_DATE_PURCHASED'         , 'DATE_PURCHASED'            , 'DATE_PURCHASED'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.Products'              , 4, 'Products.LBL_LIST_COST'                   , 'COST_USDOLLAR'             , 'COST_USDOLLAR'             , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.Products'              , 5, 'Products.LBL_LIST_DATE_SUPPORT_EXPIRES'   , 'DATE_SUPPORT_EXPIRES'      , 'DATE_SUPPORT_EXPIRES'      , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Products'            , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Products' and DATA_FIELD = 'CONTACT_ID' and URL_FIELD = 'CONTACT_ID' and DELETED = 0) begin -- then
		-- 09/30/2008 Paul.  Fix contact name. 
		print 'Contracts.Products needs to fix the contact name.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'CONTACT_NAME'
		     , SORT_EXPRESSION    = 'CONTACT_NAME'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Contracts.Products'
		   and DATA_FIELD         = 'CONTACT_ID'
		   and URL_FIELD          = 'CONTACT_ID'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Products' and HEADER_TEXT = 'Products.LBL_LIST_NAME' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/02/2008 Paul.  The primary records will be from the orders line items. 
		print 'Contracts.Products needs to display line items and products.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'PRODUCT_NAME'
		     , SORT_EXPRESSION    = 'PRODUCT_NAME'
		     , URL_FIELD          = 'PRODUCT_ID'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Contracts.Products'
		   and HEADER_TEXT        = 'Products.LBL_LIST_NAME'
		   and DATA_FIELD         = 'NAME'
		   and URL_FIELD          = 'ID'
		   and DELETED            = 0;
	end -- if;
	-- 05/08/2008 Paul.  Remove STATUS from Contracts.Products.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Products' and DATA_FIELD = 'STATUS' and DELETED = 0) begin -- then
		print 'Remove STATUS from Contracts.Products.';
		update GRIDVIEWS_COLUMNS
		   set DELETED            = 1
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Contracts.Products'
		   and DATA_FIELD         = 'STATUS'
		   and DELETED            = 0;
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX       = COLUMN_INDEX - 1
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Contracts.Products'
		   and COLUMN_INDEX       > 0
		   and DELETED            = 0;
	end -- if;
	-- 02/14/2012 Paul.  Products link to OrdersLineItems, not products.  Products is the old table. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Products' and URL_FIELD = 'PRODUCT_ID' and DELETED = 0) begin -- then
		print 'Change PRODUCT_ID to ID in product view.';
		update GRIDVIEWS_COLUMNS
		   set URL_FIELD        = 'ID'
		     , URL_FORMAT       = '~/OrdersLineItems/view.aspx?id={0}'
		     , URL_MODULE       = 'OrdersLineItems'
		     , MODULE_TYPE      = null   -- 02/15/2012 Paul.  MODULE_TYPE must be NULL, otherwise we will lookup the name using the DATA_FIELD. 
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Contracts.Products'
		   and URL_FIELD        = 'PRODUCT_ID'
		   and DELETED          = 0 ;
	end -- if;
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Products' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Products'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Quotes'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Quotes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.Quotes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.Quotes', 'Contracts', 'vwCONTRACTS_QUOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Quotes'                , 0, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.Quotes'                , 1, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '40%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.Quotes'                , 2, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.Quotes'                , 3, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Quotes'              , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Quotes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.Quotes'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 02/04/2012 Paul.  Add Documents relationship to Accounts, Contacts, Leads and Opportunities. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Documents.Contracts' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Documents.Contracts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Documents.Contracts';
	exec dbo.spGRIDVIEWS_InsertOnly           'Documents.Contracts', 'Documents', 'vwDOCUMENTS_CONTRACTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Documents.Contracts'             , 0, 'Contracts.LBL_LIST_NAME'                  , 'NAME'                         , 'NAME'                         , '20%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Documents.Contracts'             , 1, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'                 , 'ACCOUNT_NAME'                 , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}' , null, 'Accounts' , 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Documents.Contracts'             , 2, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'                   , 'START_DATE'                   , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Documents.Contracts'             , 3, 'Contracts.LBL_LIST_END_DATE'              , 'END_DATE'                     , 'END_DATE'                     , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Documents.Contracts'             , 4, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'                       , 'STATUS'                       , '10%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Documents.Contracts'             , 5, 'Contracts.LBL_LIST_CONTRACT_VALUE'        , 'TOTAL_CONTRACT_VALUE_USDOLLAR', 'TOTAL_CONTRACT_VALUE_USDOLLAR', '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Documents.Contracts'             , 6, 'Documents.LBL_LIST_SELECTED_REVISION'     , 'SELECTED_REVISION'            , 'SELECTED_REVISION'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Documents.Contracts'             , 7, 'Documents.LBL_LIST_REVISION'              , 'REVISION'                     , 'REVISION'                     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Documents.Contracts'           , 8, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Documents.Contracts' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Documents.Contracts'       , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.Notes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Products.Notes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Products.Notes', 'Products', 'vwPRODUCTS_NOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.Notes'                  , 0, 'Notes.LBL_LIST_SUBJECT'                   , 'NAME'                      , 'NAME'                      , '60%', 'listViewTdLinkS1', 'ID'         , '~/Notes/view.aspx?id={0}'   , null, 'Notes'   , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.Notes'                  , 1, 'Notes.LBL_LIST_CONTACT_NAME'              , 'CONTACT_NAME'              , 'CONTACT_NAME'              , '20%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Products.Notes'                  , 2, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'             , 'DATE_MODIFIED'             , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Products.Notes'                , 3, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.Notes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Products.Notes'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.RelatedProducts'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.RelatedProducts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Products.RelatedProducts';
	exec dbo.spGRIDVIEWS_InsertOnly           'Products.RelatedProducts', 'Products', 'vwPRODUCTS_RELATED_PRODUCTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.RelatedProducts'        , 1, 'Products.LBL_LIST_NAME'                   , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID'        , '~/Products/view.aspx?id={0}', null, 'Products', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.RelatedProducts'        , 2, 'Products.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '15%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.RelatedProducts'        , 3, 'Products.LBL_LIST_CONTACT_NAME'           , 'CONTACT_NAME'              , 'CONTACT_NAME'              , '15%', 'listViewTdLinkS1', 'CONTACT_ID', '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Products.RelatedProducts'        , 4, 'Products.LBL_LIST_DATE_PURCHASED'         , 'DATE_PURCHASED'            , 'DATE_PURCHASED'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Products.RelatedProducts'        , 5, 'Products.LBL_LIST_COST'                   , 'COST_USDOLLAR'             , 'COST_USDOLLAR'             , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Products.RelatedProducts'        , 6, 'Products.LBL_LIST_DATE_SUPPORT_EXPIRES'   , 'DATE_SUPPORT_EXPIRES'      , 'DATE_SUPPORT_EXPIRES'      , '10%', 'Date';
end else begin
	-- 05/09/2008 Paul.  Remove STATUS from Products.RelatedProducts.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.RelatedProducts' and DATA_FIELD = 'STATUS' and DELETED = 0) begin -- then
		print 'Remove STATUS from Products.RelatedProducts.';
		update GRIDVIEWS_COLUMNS
		   set DELETED            = 1
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Products.RelatedProducts'
		   and DATA_FIELD         = 'STATUS'
		   and DELETED            = 0;
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX       = COLUMN_INDEX - 1
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Products.RelatedProducts'
		   and COLUMN_INDEX       > 0
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 06/21/2007 Paul.  DATA_FIELD should never be an ID field. 
if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.RelatedProducts' and DATA_FIELD = 'CONTACT_ID' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Products.RelatedProducts: Fix CONTACT_NAME';
	update GRIDVIEWS_COLUMNS
	   set DATA_FIELD       = 'CONTACT_NAME'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where GRID_NAME        = 'Products.RelatedProducts'
	   and DATA_FIELD       = 'CONTACT_ID'
	   and DELETED          = 0;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Activities.Open' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Activities.Open';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Activities.Open', 'Quotes', 'vwQUOTES_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Activities.Open'          , 2, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'          , 'ACTIVITY_NAME'          , '20%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.Activities.Open'          , 3, 'Activities.LBL_LIST_STATUS'               , 'STATUS'                 , 'STATUS'                 , '10%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Activities.Open'          , 4, 'Activities.LBL_LIST_CONTACT'              , 'CONTACT_NAME'           , 'CONTACT_NAME'           , '20%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Activities.Open'          , 5, 'Activities.LBL_LIST_RELATED_TO'           , 'ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Activities.Open'          , 6, 'Activities.LBL_LIST_DUE_DATE'             , 'DATE_DUE'               , 'DATE_DUE'               , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Activities.Open'        , 7, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Activities.Open' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Activities.Open'    , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Activities.History' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Activities.History';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Activities.History', 'Quotes', 'vwQUOTES_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Activities.History'       , 1, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'          , 'ACTIVITY_NAME'          , '20%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.Activities.History'       , 2, 'Activities.LBL_LIST_STATUS'               , 'STATUS'                 , 'STATUS'                 , '10%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Activities.History'       , 3, 'Activities.LBL_LIST_CONTACT'              , 'CONTACT_NAME'           , 'CONTACT_NAME'           , '20%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Activities.History'       , 4, 'Activities.LBL_LIST_RELATED_TO'           , 'ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Activities.History'       , 5, 'Activities.LBL_LIST_LAST_MODIFIED'        , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Activities.History'     , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Activities.History' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Activities.History' , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Projects' and DELETED = 0) begin -- then
	print 'Rename Quotes.Projects to Quotes.Project.';
	update GRIDVIEWS_COLUMNS
	   set GRID_NAME         = 'Quotes.Project'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where GRID_NAME         = 'Quotes.Projects'
	   and DELETED           = 0;
end -- if;
GO

-- 12/04/2009 Paul.  We also need to correct the GRIDVIEWS table.  It is safer to delete, then re-insert to prevent duplicate entries. 
if exists(select * from GRIDVIEWS where NAME = 'Quotes.Projects' and DELETED = 0) begin -- then
	print 'Rename Quotes.Projects to Quotes.Project.';
	update GRIDVIEWS
	   set DELETED          = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'Quotes.Projects'
	   and DELETED          = 0;
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Project', 'Quotes', 'vwQUOTES_PROJECTS';
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Project' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Project';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Project', 'Quotes', 'vwQUOTES_PROJECTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Project'                  , 0, 'Project.LBL_LIST_NAME'                    , 'NAME'                   , 'NAME'                   , '23%', 'listViewTdLinkS1', 'ID', '~/Projects/view.aspx?id={0}', null, 'Project', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Project'                  , 1, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'       , 'ASSIGNED_TO_NAME'       , '23%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Project'                  , 2, 'Project.LBL_LIST_TOTAL_ESTIMATED_EFFORT'  , 'TOTAL_ESTIMATED_EFFORT' , 'TOTAL_ESTIMATED_EFFORT' , '23%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Project'                  , 3, 'Project.LBL_LIST_TOTAL_ACTUAL_EFFORT'     , 'TOTAL_ACTUAL_EFFORT'    , 'TOTAL_ACTUAL_EFFORT'    , '23%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Project'                , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Project' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Project'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Contracts' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Contracts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Contracts';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Contracts', 'Quotes', 'vwQUOTES_CONTRACTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Contracts'                , 0, 'Contracts.LBL_LIST_NAME'                  , 'NAME'                         , 'NAME'                         , '25%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Contracts'                , 1, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'                 , 'ACCOUNT_NAME'                 , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}' , null, 'Accounts' , 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Contracts'                , 2, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'                   , 'START_DATE'                   , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Contracts'                , 3, 'Contracts.LBL_LIST_END_DATE'              , 'END_DATE'                     , 'END_DATE'                     , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.Contracts'                , 4, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'                       , 'STATUS'                       , '15%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Contracts'                , 5, 'Contracts.LBL_LIST_CONTRACT_VALUE'        , 'TOTAL_CONTRACT_VALUE_USDOLLAR', 'TOTAL_CONTRACT_VALUE_USDOLLAR', '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Contracts'              , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Contracts' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Contracts'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 08/17/2010 Paul.  Add DISCOUNT_USDOLLAR. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.LineItems' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.LineItems' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.LineItems';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.LineItems', 'Quotes', 'vwQUOTES_LINE_ITEMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.LineItems'                , 0, 'Quotes.LBL_LIST_ITEM_QUANTITY'              , 'QUANTITY'               , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.LineItems'                , 1, 'Quotes.LBL_LIST_ITEM_NAME'                  , 'NAME'                   , null, '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.LineItems'                , 2, 'Quotes.LBL_LIST_ITEM_MFT_PART_NUM'          , 'MFT_PART_NUM'           , null, '15%', 'listViewTdLinkS1', 'PRODUCT_TEMPLATE_ID', '~/Products/ProductCatalog/view.aspx?id={0}', null, 'Products', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.LineItems'                , 3, 'Quotes.LBL_LIST_ITEM_COST_PRICE'            , 'COST_USDOLLAR'          , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.LineItems'                , 4, 'Quotes.LBL_LIST_ITEM_LIST_PRICE'            , 'LIST_USDOLLAR'          , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.LineItems'                , 5, 'Quotes.LBL_LIST_ITEM_UNIT_PRICE'            , 'UNIT_USDOLLAR'          , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.LineItems'                , 6, 'Quotes.LBL_LIST_ITEM_EXTENDED_PRICE'        , 'EXTENDED_USDOLLAR'      , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.LineItems'                , 7, 'Quotes.LBL_LIST_ITEM_DISCOUNT_PRICE'        , 'DISCOUNT_USDOLLAR'      , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems', 0, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems', 5, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems', 6, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems', 7, null, null, 'right', null, null;
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.LineItems' and DATA_FIELD = 'MFT_PART_NUM' and DATA_FORMAT = 'HyperLink' and URL_FORMAT = '~/ProductCatalog/view.aspx?id={0}' and DELETED = 0) begin -- then
		-- 02/04/2008 Paul.  New viewer for product catalog. 
		print 'Fix Quotes link to product catalog.';
		update GRIDVIEWS_COLUMNS
		   set URL_FORMAT       = '~/Products/ProductCatalog/view.aspx?id={0}'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Quotes.LineItems'
		   and DATA_FIELD       = 'MFT_PART_NUM'
		   and DATA_FORMAT      = 'HyperLink' 
		   and URL_FORMAT       = '~/ProductCatalog/view.aspx?id={0}'
		   and DELETED          = 0;
	end -- if;
	-- 08/17/2010 Paul.  Add DISCOUNT_USDOLLAR. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.LineItems' and DATA_FIELD = 'DISCOUNT_USDOLLAR' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.LineItems'                , 7, 'Quotes.LBL_LIST_ITEM_DISCOUNT_PRICE'        , 'DISCOUNT_USDOLLAR'      , null, '10%', 'Currency';
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems', 7, null, null, 'right', null, null;
	end -- if;
	-- 07/29/2019 Paul.  Correct invalid field. 
	if exists(select * from vwGRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.LineItems' and URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where GRID_NAME          = 'Quotes.LineItems'
		   and URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID'
		   and DELETED = 0;
	end -- if;
end -- if;
GO

-- 08/13/2007 Paul.  Change ACCOUNT_NAME to ORDER_NAME. 
-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Activities.Open' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.Activities.Open';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.Activities.Open', 'Orders', 'vwORDERS_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Activities.Open'          , 2, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'          , 'ACTIVITY_NAME'          , '20%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.Activities.Open'          , 3, 'Activities.LBL_LIST_STATUS'               , 'STATUS'                 , 'STATUS'                 , '10%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Activities.Open'          , 4, 'Activities.LBL_LIST_CONTACT'              , 'CONTACT_NAME'           , 'CONTACT_NAME'           , '20%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}'  , null, 'Contacts'  , 'CONTACT_ASSIGNED_USER_ID' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Activities.Open'          , 5, 'Activities.LBL_LIST_RELATED_TO'           , 'ORDER_NAME'             , 'ORDER_NAME'             , '20%', 'listViewTdLinkS1', 'ORDER_ID'   , '~/Orders/view.aspx?id={0}'    , null, 'Orders'    , 'ORDER_ASSIGNED_USER_ID'   ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.Activities.Open'          , 6, 'Activities.LBL_LIST_DUE_DATE'             , 'DATE_DUE'               , 'DATE_DUE'               , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.Activities.Open'        , 7, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 08/13/2007 Paul.  Change ACCOUNT_NAME to ORDER_NAME. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Activities.Open' and DATA_FIELD = 'ACCOUNT_NAME' and DELETED = 0) begin -- then
		print 'Fix Orders.Activities.Open.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'ORDER_NAME'
		     , URL_FIELD          = 'ORDER_ID'
		     , URL_FORMAT         = '~/Orders/view.aspx?id={0}'
		     , URL_MODULE         = 'Orders'
		     , URL_ASSIGNED_FIELD = 'ORDER_ASSIGNED_USER_ID'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Orders.Activities.Open'
		   and DATA_FIELD         = 'ACCOUNT_NAME'
		   and DELETED            = 0;
	end -- if;
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Activities.Open' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.Activities.Open'   , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 08/13/2007 Paul.  Change ACCOUNT_NAME to ORDER_NAME. 
-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Activities.History' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.Activities.History';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.Activities.History', 'Orders', 'vwORDERS_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Activities.History'       , 1, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'          , 'ACTIVITY_NAME'          , '20%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.Activities.History'       , 2, 'Activities.LBL_LIST_STATUS'               , 'STATUS'                 , 'STATUS'                 , '10%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Activities.History'       , 3, 'Activities.LBL_LIST_CONTACT'              , 'CONTACT_NAME'           , 'CONTACT_NAME'           , '20%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}'  , null, 'Contacts'  , 'CONTACT_ASSIGNED_USER_ID' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Activities.History'       , 4, 'Activities.LBL_LIST_RELATED_TO'           , 'ORDER_NAME'             , 'ORDER_NAME'             , '20%', 'listViewTdLinkS1', 'ORDER_ID'   , '~/Orders/view.aspx?id={0}'    , null, 'Orders'    , 'ORDER_ASSIGNED_USER_ID'   ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.Activities.History'       , 5, 'Activities.LBL_LIST_LAST_MODIFIED'        , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.Activities.History'     , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 08/13/2007 Paul.  Change ACCOUNT_NAME to ORDER_NAME. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Activities.History' and DATA_FIELD = 'ACCOUNT_NAME' and DELETED = 0) begin -- then
		print 'Fix Orders.Activities.History.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'ORDER_NAME'
		     , URL_FIELD          = 'ORDER_ID'
		     , URL_FORMAT         = '~/Orders/view.aspx?id={0}'
		     , URL_MODULE         = 'Orders'
		     , URL_ASSIGNED_FIELD = 'ORDER_ASSIGNED_USER_ID'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Orders.Activities.History'
		   and DATA_FIELD         = 'ACCOUNT_NAME'
		   and DELETED            = 0;
	end -- if;
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Activities.History' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.Activities.History'   , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Invoices' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Invoices' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.Invoices';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.Invoices', 'Payments', 'vwORDERS_INVOICES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Invoices'                 , 0, 'Invoices.LBL_LIST_INVOICE_NUM'              , 'INVOICE_NUM'            , 'INVOICE_NUM'            , '10%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Invoices'                 , 1, 'Invoices.LBL_LIST_NAME'                     , 'INVOICE_NAME'           , 'INVOICE_NAME'           , '30%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.Invoices'                 , 2, 'Invoices.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.Invoices'                 , 3, 'Invoices.LBL_LIST_AMOUNT_DUE'               , 'AMOUNT_DUE_USDOLLAR'    , 'AMOUNT_DUE_USDOLLAR'    , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.Invoices'                 , 4, '.LBL_LIST_CREATED'                          , 'DATE_ENTERED'           , 'DATE_ENTERED'           , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.Invoices'                 , 5, 'Invoices.LBL_LIST_DUE_DATE'                 , 'DUE_DATE'               , 'DUE_DATE'               , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.Invoices', 2, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.Invoices', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.Invoices'               , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Invoices' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.Invoices'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO


-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Activities.Open' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.Activities.Open';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.Activities.Open', 'Invoices', 'vwINVOICES_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Activities.Open'        , 2, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'          , 'ACTIVITY_NAME'          , '20%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.Activities.Open'        , 3, 'Activities.LBL_LIST_STATUS'               , 'STATUS'                 , 'STATUS'                 , '10%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Activities.Open'        , 4, 'Activities.LBL_LIST_CONTACT'              , 'CONTACT_NAME'           , 'CONTACT_NAME'           , '20%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Activities.Open'        , 5, 'Activities.LBL_LIST_RELATED_TO'           , 'ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.Activities.Open'        , 6, 'Activities.LBL_LIST_DUE_DATE'             , 'DATE_DUE'               , 'DATE_DUE'               , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.Activities.Open'      , 7, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Activities.Open' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.Activities.Open'   , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Activities.History' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.Activities.History';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.Activities.History', 'Invoices', 'vwINVOICES_ACTIVITIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Activities.History'     , 1, 'Activities.LBL_LIST_SUBJECT'              , 'ACTIVITY_NAME'          , 'ACTIVITY_NAME'          , '20%', 'listViewTdLinkS1', 'ACTIVITY_ID', '~/Activities/view.aspx?id={0}', null, 'Activities', 'ACTIVITY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.Activities.History'     , 2, 'Activities.LBL_LIST_STATUS'               , 'STATUS'                 , 'STATUS'                 , '10%', 'activity_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Activities.History'     , 3, 'Activities.LBL_LIST_CONTACT'              , 'CONTACT_NAME'           , 'CONTACT_NAME'           , '20%', 'listViewTdLinkS1', 'CONTACT_ID' , '~/Contacts/view.aspx?id={0}', null, 'Contacts', 'CONTACT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Activities.History'     , 4, 'Activities.LBL_LIST_RELATED_TO'           , 'ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.Activities.History'     , 5, 'Activities.LBL_LIST_LAST_MODIFIED'        , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.Activities.History'   , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Activities.History' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.Activities.History', -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 08/17/2010 Paul.  Add DISCOUNT_USDOLLAR. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.LineItems' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.LineItems' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.LineItems';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.LineItems', 'Invoices', 'vwINVOICES_LINE_ITEMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.LineItems'              , 0, 'Invoices.LBL_LIST_ITEM_QUANTITY'            , 'QUANTITY'               , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.LineItems'              , 1, 'Invoices.LBL_LIST_ITEM_NAME'                , 'NAME'                   , null, '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.LineItems'              , 2, 'Invoices.LBL_LIST_ITEM_MFT_PART_NUM'        , 'MFT_PART_NUM'           , null, '15%', 'listViewTdLinkS1', 'PRODUCT_TEMPLATE_ID', '~/Products/ProductCatalog/view.aspx?id={0}', null, 'Products', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.LineItems'              , 3, 'Invoices.LBL_LIST_ITEM_COST_PRICE'          , 'COST_USDOLLAR'          , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.LineItems'              , 4, 'Invoices.LBL_LIST_ITEM_LIST_PRICE'          , 'LIST_USDOLLAR'          , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.LineItems'              , 5, 'Invoices.LBL_LIST_ITEM_UNIT_PRICE'          , 'UNIT_USDOLLAR'          , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.LineItems'              , 6, 'Invoices.LBL_LIST_ITEM_EXTENDED_PRICE'      , 'EXTENDED_USDOLLAR'      , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.LineItems'              , 7, 'Invoices.LBL_LIST_ITEM_DISCOUNT_PRICE'      , 'DISCOUNT_USDOLLAR'      , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems', 0, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems', 5, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems', 6, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems', 7, null, null, 'right', null, null;
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.LineItems' and DATA_FIELD = 'MFT_PART_NUM' and DATA_FORMAT = 'HyperLink' and URL_FORMAT = '~/ProductCatalog/view.aspx?id={0}' and DELETED = 0) begin -- then
		-- 02/04/2008 Paul.  New viewer for product catalog. 
		print 'Fix Invoices link to product catalog.';
		update GRIDVIEWS_COLUMNS
		   set URL_FORMAT       = '~/Products/ProductCatalog/view.aspx?id={0}'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Invoices.LineItems'
		   and DATA_FIELD       = 'MFT_PART_NUM'
		   and DATA_FORMAT      = 'HyperLink' 
		   and URL_FORMAT       = '~/ProductCatalog/view.aspx?id={0}'
		   and DELETED          = 0;
	end -- if;
	-- 08/17/2010 Paul.  Add DISCOUNT_USDOLLAR. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.LineItems' and DATA_FIELD = 'DISCOUNT_USDOLLAR' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.LineItems'              , 7, 'Invoices.LBL_LIST_ITEM_DISCOUNT_PRICE'      , 'DISCOUNT_USDOLLAR'      , null, '10%', 'Currency';
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems', 7, null, null, 'right', null, null;
	end -- if;
	-- 07/29/2019 Paul.  Correct invalid field. 
	if exists(select * from vwGRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.LineItems' and URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where GRID_NAME          = 'Invoices.LineItems'
		   and URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.Invoices' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.Invoices' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.Invoices';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.Invoices', 'Payments', 'vwPAYMENTS_INVOICES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.Invoices'               , 0, 'Invoices.LBL_LIST_INVOICE_NUM'              , 'INVOICE_NUM'            , 'INVOICE_NUM'            , '10%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.Invoices'               , 1, 'Invoices.LBL_LIST_NAME'                     , 'INVOICE_NAME'           , 'INVOICE_NAME'           , '30%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.Invoices'               , 2, 'Invoices.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.Invoices'               , 3, 'Invoices.LBL_LIST_ALLOCATED'                , 'ALLOCATED_USDOLLAR'     , 'ALLOCATED_USDOLLAR'     , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.Invoices'               , 4, 'Invoices.LBL_LIST_AMOUNT_DUE'               , 'AMOUNT_DUE_USDOLLAR'    , 'AMOUNT_DUE_USDOLLAR'    , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Payments.Invoices', 2, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Payments.Invoices', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Payments.Invoices', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Payments.Invoices'             , 5, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.Invoices' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Payments.Invoices'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 06/07/2015 Paul.  Add Preview button. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Payments' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Payments' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.Payments';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.Payments', 'Payments', 'vwINVOICES_PAYMENTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Payments'               , 0, 'Payments.LBL_LIST_PAYMENT_NUM'              , 'PAYMENT_NUM'            , 'PAYMENT_NUM'            , '10%', 'listViewTdLinkS1', 'PAYMENT_ID', '~/Payments/view.aspx?id={0}' , null, 'Payments', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.Payments'               , 1, 'Payments.LBL_LIST_PAYMENT_TYPE'             , 'PAYMENT_TYPE'           , 'PAYMENT_TYPE'           , '15%', 'payment_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Payments'               , 2, 'Payments.LBL_LIST_CUSTOMER_REFERENCE'       , 'CUSTOMER_REFERENCE'     , 'CUSTOMER_REFERENCE'     , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.Payments'               , 3, 'Payments.LBL_LIST_AMOUNT'                   , 'AMOUNT_USDOLLAR'        , 'AMOUNT_USDOLLAR'        , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.Payments'               , 4, 'Payments.LBL_LIST_ALLOCATED'                , 'ALLOCATED_USDOLLAR'     , 'ALLOCATED_USDOLLAR'     , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.Payments'               , 5, 'Payments.LBL_LIST_PAYMENT_DATE'             , 'PAYMENT_DATE'           , 'PAYMENT_DATE'           , '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.Payments', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.Payments', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.Payments'             , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	--if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Payments' and DATA_FIELD = 'PAYMENT_TYPE' and LIST_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
	--	print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
		--update GRIDVIEWS_COLUMNS
		--   set LIST_NAME         = 'PaymentTypes'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where GRID_NAME         = 'Invoices.Payments'
		--   and DATA_FIELD        = 'PAYMENT_TYPE'
		--   and LIST_NAME         = 'payment_type_dom'
		--   and DELETED           = 0;
	--end -- if;
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Payments' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.Payments'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/28/2007 Paul.  Add DUE_DATE.
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Invoices' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Invoices' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.Invoices';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.Invoices', 'Accounts', 'vwACCOUNTS_INVOICES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Invoices'               , 0, 'Invoices.LBL_LIST_INVOICE_NUM'              , 'INVOICE_NUM'            , 'INVOICE_NUM'            , '10%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Invoices'               , 1, 'Invoices.LBL_LIST_NAME'                     , 'INVOICE_NAME'           , 'INVOICE_NAME'           , '30%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Invoices'               , 2, 'Invoices.LBL_LIST_DUE_DATE'                 , 'DUE_DATE'               , 'DUE_DATE'               , '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Invoices'               , 3, 'Invoices.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Invoices'               , 4, 'Invoices.LBL_LIST_AMOUNT_DUE'               , 'AMOUNT_DUE_USDOLLAR'    , 'AMOUNT_DUE_USDOLLAR'    , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Accounts.Invoices', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Accounts.Invoices', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Invoices'             , 5, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Invoices'               , 4, 'Invoices.LBL_LIST_DUE_DATE'                 , 'DUE_DATE'               , 'DUE_DATE'               , '20%', 'Date';
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Invoices' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Invoices'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 09/11/2007 Paul.  Add the Orders panel to the Accounts DetailView. 
-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Orders' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Orders' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.Orders';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.Orders', 'Accounts', 'vwACCOUNTS_ORDERS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Orders'                 , 0, 'Orders.LBL_LIST_ORDER_NUM'                  , 'ORDER_NUM'              , 'ORDER_NUM'              , '10%', 'listViewTdLinkS1', 'ORDER_ID', '~/Orders/view.aspx?id={0}', null, 'Orders', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Orders'                 , 1, 'Orders.LBL_LIST_NAME'                       , 'ORDER_NAME'             , 'ORDER_NAME'             , '30%', 'listViewTdLinkS1', 'ORDER_ID', '~/Orders/view.aspx?id={0}', null, 'Orders', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Orders'                 , 2, 'Orders.LBL_LIST_DATE_ORDER_DUE'             , 'DATE_ORDER_DUE'         , 'DATE_ORDER_DUE'         , '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Orders'                 , 3, 'Orders.LBL_LIST_AMOUNT'                     , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Accounts.Orders', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Orders'               , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Orders' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Orders'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 06/07/2015 Paul.  Add Preview button. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Payments' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Payments' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.Payments';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.Payments', 'Payments', 'vwACCOUNTS_PAYMENTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Payments'               , 0, 'Payments.LBL_LIST_PAYMENT_NUM'              , 'PAYMENT_NUM'            , 'PAYMENT_NUM'            , '10%', 'listViewTdLinkS1', 'PAYMENT_ID', '~/Payments/view.aspx?id={0}' , null, 'Payments', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Accounts.Payments'               , 1, 'Payments.LBL_LIST_PAYMENT_TYPE'             , 'PAYMENT_TYPE'           , 'PAYMENT_TYPE'           , '15%', 'payment_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.Payments'               , 2, 'Payments.LBL_LIST_CUSTOMER_REFERENCE'       , 'CUSTOMER_REFERENCE'     , 'CUSTOMER_REFERENCE'     , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Payments'               , 3, 'Payments.LBL_LIST_PAYMENT_DATE'             , 'PAYMENT_DATE'           , 'PAYMENT_DATE'           , '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Payments'               , 4, 'Payments.LBL_LIST_AMOUNT'                   , 'AMOUNT_USDOLLAR'        , 'AMOUNT_USDOLLAR'        , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Accounts.Payments', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Payments'             , 5, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	--if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Payments' and DATA_FIELD = 'PAYMENT_TYPE' and LIST_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
	--	print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
		--update GRIDVIEWS_COLUMNS
		--   set LIST_NAME         = 'PaymentTypes'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where GRID_NAME         = 'Accounts.Payments'
		--   and DATA_FIELD        = 'PAYMENT_TYPE'
		--   and LIST_NAME         = 'payment_type_dom'
		--   and DELETED           = 0;
	--end -- if;
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Payments' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Payments'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 02/13/2016 Paul.  Balance is not a valid module name.  It should be Accounts. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Balance' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.Balance';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.Balance', 'Accounts', 'vwACCOUNTS_BALANCE';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.Balance'               , 1, 'Payments.LBL_LIST_BALANCE_TYPE'             , 'BALANCE_TYPE'           , null, '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Balance'               , 2, 'Payments.LBL_LIST_BALANCE_DATE'             , 'BALANCE_DATE'           , null, '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Balance'               , 3, 'Payments.LBL_LIST_AMOUNT'                   , 'AMOUNT_USDOLLAR'        , null, '20%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Balance'               , 4, 'Payments.LBL_LIST_BALANCE'                  , 'BALANCE_USDOLLAR'       , null, '20%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Accounts.Balance', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Accounts.Balance', 4, null, null, 'right', null, null;
end -- if;

if exists(select * from GRIDVIEWS where NAME = 'Accounts.Balance' and MODULE_NAME = 'Balance') begin -- then
	update GRIDVIEWS
	   set MODULE_NAME       = 'Accounts'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where NAME              = 'Accounts.Balance'
	   and MODULE_NAME       = 'Balance';
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Invoices' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Invoices' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Invoices';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Invoices', 'Payments', 'vwQUOTES_INVOICES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Invoices'                 , 0, 'Invoices.LBL_LIST_INVOICE_NUM'              , 'INVOICE_NUM'            , 'INVOICE_NUM'            , '10%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Invoices'                 , 1, 'Invoices.LBL_LIST_NAME'                     , 'INVOICE_NAME'           , 'INVOICE_NAME'           , '30%', 'listViewTdLinkS1', 'INVOICE_ID', '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Invoices'                 , 2, 'Invoices.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Invoices'                 , 3, 'Invoices.LBL_LIST_AMOUNT_DUE'               , 'AMOUNT_DUE_USDOLLAR'    , 'AMOUNT_DUE_USDOLLAR'    , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Invoices'                 , 4, '.LBL_LIST_CREATED'                          , 'DATE_ENTERED'           , 'DATE_ENTERED'           , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Invoices'                 , 5, 'Invoices.LBL_LIST_DUE_DATE'                 , 'DUE_DATE'               , 'DUE_DATE'               , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.Invoices', 2, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.Invoices', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Invoices'               , 6, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Quotes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Accounts.Quotes'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Orders' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Orders' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Orders';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Orders', 'Payments', 'vwQUOTES_ORDERS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Orders'                   , 0, 'Orders.LBL_LIST_ORDER_NUM'                  , 'ORDER_NUM'              , 'ORDER_NUM'              , '10%', 'listViewTdLinkS1', 'ORDER_ID', '~/Orders/view.aspx?id={0}', null, 'Orders', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Orders'                   , 1, 'Orders.LBL_LIST_NAME'                       , 'ORDER_NAME'             , 'ORDER_NAME'             , '30%', 'listViewTdLinkS1', 'ORDER_ID', '~/Orders/view.aspx?id={0}', null, 'Orders', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Orders'                   , 2, 'Orders.LBL_LIST_AMOUNT'                     , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Orders'                   , 3, '.LBL_LIST_CREATED'                          , 'DATE_ENTERED'           , 'DATE_ENTERED'           , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.Orders'                   , 4, 'Orders.LBL_LIST_DATE_ORDER_DUE'             , 'DATE_ORDER_DUE'         , 'DATE_ORDER_DUE'         , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.Orders', 2, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Orders'                 , 5, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Orders' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Orders'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 05/12/2009 Paul.  Link to new line items editor. 
-- 08/17/2010 Paul.  Add DISCOUNT_USDOLLAR. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.LineItems' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.LineItems' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.LineItems';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.LineItems', 'Orders', 'vwORDERS_LINE_ITEMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.LineItems'                , 0, 'Orders.LBL_LIST_ITEM_QUANTITY'              , 'QUANTITY'               , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.LineItems'                , 1, 'Orders.LBL_LIST_ITEM_NAME'                  , 'NAME'                   , null, '20%', 'listViewTdLinkS1', 'ID'                 , '~/OrdersLineItems/view.aspx?id={0}'        , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.LineItems'                , 2, 'Orders.LBL_LIST_ITEM_MFT_PART_NUM'          , 'MFT_PART_NUM'           , null, '15%', 'listViewTdLinkS1', 'PRODUCT_TEMPLATE_ID', '~/Products/ProductCatalog/view.aspx?id={0}', null, 'Products', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.LineItems'                , 3, 'Orders.LBL_LIST_ITEM_COST_PRICE'            , 'COST_USDOLLAR'          , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.LineItems'                , 4, 'Orders.LBL_LIST_ITEM_LIST_PRICE'            , 'LIST_USDOLLAR'          , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.LineItems'                , 5, 'Orders.LBL_LIST_ITEM_UNIT_PRICE'            , 'UNIT_USDOLLAR'          , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.LineItems'                , 6, 'Orders.LBL_LIST_ITEM_EXTENDED_PRICE'        , 'EXTENDED_USDOLLAR'      , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.LineItems'                , 7, 'Orders.LBL_LIST_ITEM_DISCOUNT_PRICE'        , 'DISCOUNT_USDOLLAR'      , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems', 0, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems', 5, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems', 6, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems', 7, null, null, 'right', null, null;
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.LineItems' and DATA_FIELD = 'MFT_PART_NUM' and DATA_FORMAT = 'HyperLink' and URL_FORMAT = '~/ProductCatalog/view.aspx?id={0}' and DELETED = 0) begin -- then
		-- 02/04/2008 Paul.  New viewer for product catalog. 
		print 'Fix Orders link to product catalog.';
		update GRIDVIEWS_COLUMNS
		   set URL_FORMAT       = '~/Products/ProductCatalog/view.aspx?id={0}'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Orders.LineItems'
		   and DATA_FIELD       = 'MFT_PART_NUM'
		   and DATA_FORMAT      = 'HyperLink' 
		   and URL_FORMAT       = '~/ProductCatalog/view.aspx?id={0}'
		   and DELETED          = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.LineItems' and DATA_FIELD = 'NAME' and COLUMN_TYPE = 'BoundColumn' and DELETED = 0) begin -- then
		-- 05/12/2009 Paul.  Link to new line items editor. 
		print 'Orders.LineItems: Link to line items editor.';
		update GRIDVIEWS_COLUMNS
		   set COLUMN_TYPE      = 'TemplateColumn'
		     , DATA_FORMAT      = 'HyperLink'
		     , URL_FIELD        = 'ID'
		     , URL_FORMAT       = '~/OrdersLineItems/view.aspx?id={0}'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Orders.LineItems'
		   and DATA_FIELD       = 'NAME'
		   and COLUMN_TYPE      = 'BoundColumn'
		   and DELETED          = 0;
	end -- if;
	-- 08/17/2010 Paul.  Add DISCOUNT_USDOLLAR. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.LineItems' and DATA_FIELD = 'DISCOUNT_USDOLLAR' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.LineItems'                , 7, 'Orders.LBL_LIST_ITEM_DISCOUNT_PRICE'        , 'DISCOUNT_USDOLLAR'      , null, '10%', 'Currency';
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems', 7, null, null, 'right', null, null;
	end -- if;
	-- 07/29/2019 Paul.  Correct invalid field. 
	if exists(select * from vwGRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.LineItems' and URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where GRID_NAME          = 'Orders.LineItems'
		   and URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID'
		   and DELETED = 0;
	end -- if;
end -- if;
GO

-- 07/15/2007 Paul.  Add panel for threaded discussions. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.Threads' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.Threads';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.Threads', 'Accounts', 'vwACCOUNTS_THREADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.Threads'                , 0, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'                  , 'TITLE'                  , '75%', 'listViewTdLinkS1', 'ID'         , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Accounts.Threads'                , 1, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '25%', 'Date';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Bugs.Threads' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Bugs.Threads';
	exec dbo.spGRIDVIEWS_InsertOnly           'Bugs.Threads', 'Bugs', 'vwBUGS_THREADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Bugs.Threads'                    , 0, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'                  , 'TITLE'                  , '75%', 'listViewTdLinkS1', 'ID'         , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Bugs.Threads'                    , 1, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '25%', 'Date';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.Threads' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Cases.Threads';
	exec dbo.spGRIDVIEWS_InsertOnly           'Cases.Threads', 'Cases', 'vwCASES_THREADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.Threads'                   , 0, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'                  , 'TITLE'                  , '75%', 'listViewTdLinkS1', 'ID'         , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Cases.Threads'                   , 1, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '25%', 'Date';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.Threads' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Leads.Threads';
	exec dbo.spGRIDVIEWS_InsertOnly           'Leads.Threads', 'Leads', 'vwLEADS_THREADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.Threads'                   , 0, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'                  , 'TITLE'                  , '75%', 'listViewTdLinkS1', 'ID'         , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Leads.Threads'                   , 1, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '25%', 'Date';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Project.Threads' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Project.Threads';
	exec dbo.spGRIDVIEWS_InsertOnly           'Project.Threads', 'Project', 'vwPROJECT_THREADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Project.Threads'                 , 0, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'                  , 'TITLE'                  , '75%', 'listViewTdLinkS1', 'ID'         , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Project.Threads'                 , 1, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '25%', 'Date';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.Threads' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.Threads';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.Threads', 'Opportunities', 'vwOPPORTUNITIES_THREADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.Threads'           , 0, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'                  , 'TITLE'                  , '75%', 'listViewTdLinkS1', 'ID'         , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.Threads'           , 1, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '25%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Forums.Threads';
-- 12/29/2009 Paul.  Use global term LBL_LIST_CREATED_BY. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Forums.Threads' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Forums.Threads';
	exec dbo.spGRIDVIEWS_InsertOnly           'Forums.Threads', 'Forums', 'vwFORUMS_THREADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Forums.Threads'                  , 0, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'                  , 'TITLE'                  , '25%', 'listViewTdLinkS1', 'ID'          , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Forums.Threads'                  , 1, '.LBL_LIST_CREATED_BY'                     , 'CREATED_BY_NAME'        , 'CREATED_BY_NAME'        , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Forums.Threads'                  , 2, 'Threads.LBL_LIST_LAST_POST_TITLE'         , 'LAST_POST_TITLE'        , 'LAST_POST_TITLE'        , '20%', 'listViewTdLinkS1', 'LAST_POST_ID', '~/Posts/view.aspx?id={0}'     , null, 'Posts'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Forums.Threads'                  , 3, 'Threads.LBL_LIST_LAST_POST_CREATED_BY'    , 'LAST_POST_CREATED_BY_NAME', 'LAST_POST_CREATED_BY_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Forums.Threads'                  , 4, '.LBL_LIST_DATE_MODIFIED'                  , 'LAST_POST_DATE_MODIFIED', 'LAST_POST_DATE_MODIFIED', '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Forums.Threads'                  , 5, 'Threads.LBL_LIST_POSTCOUNT'               , 'POSTCOUNT'              , 'POSTCOUNT'              , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Forums.Threads'                  , 6, 'Threads.LBL_LIST_VIEW_COUNT'              , 'VIEW_COUNT'             , 'VIEW_COUNT'             , '10%';
end else begin
	-- 05/09/2008 Paul.  Forums.Threads: Correct URL_ASSIGNED_FIELD.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Forums.Threads' and URL_ASSIGNED_FIELD = 'LAST_POST_ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		print 'Forums.Threads: Correct URL_ASSIGNED_FIELD.';
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Forums.Threads'
		   and URL_ASSIGNED_FIELD = 'LAST_POST_ASSIGNED_USER_ID'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Forums.Threads' and HEADER_TEXT = 'Threads.LBL_LIST_CREATED_BY' and DELETED = 0) begin -- then
		print 'Forums.Threads: Use global term LBL_LIST_CREATED_BY.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT        = '.LBL_LIST_CREATED_BY'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Forums.Threads'
		   and HEADER_TEXT        = 'Threads.LBL_LIST_CREATED_BY'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME like '%.Threads' and HEADER_TEXT = 'Threads.LBL_LIST_TITLE' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
	print 'Threads have a TITLE field instead of a NAME field.';
	update GRIDVIEWS_COLUMNS
	   set DATA_FIELD       = 'TITLE'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where GRID_NAME        like '%.Threads'
	   and HEADER_TEXT      = 'Threads.LBL_LIST_TITLE'
	   and DATA_FIELD       = 'NAME'
	   and URL_FIELD        = 'ID'
	   and DELETED          = 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.Posts';
-- 12/29/2009 Paul.  Use global term LBL_LIST_CREATED_BY. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.Posts' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Threads.Posts';
	exec dbo.spGRIDVIEWS_InsertOnly           'Threads.Posts', 'Threads', 'vwTHREADS_POSTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Threads.Posts'                   , 0, 'Posts.LBL_LIST_TITLE'                     , 'TITLE'                  , 'TITLE'                  , '35%', 'listViewTdLinkS1', 'ID'          , '~/Posts/view.aspx?id={0}'     , null, 'Posts'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Threads.Posts'                   , 1, 'Posts.LBL_LIST_THREAD'                    , 'THREAD_TITLE'           , 'THREAD_TITLE'           , '35%', 'listViewTdLinkS1', 'THREAD_ID'   , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Posts'                   , 2, '.LBL_LIST_CREATED_BY'                     , 'CREATED_BY_NAME'        , 'CREATED_BY_NAME'        , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Posts'                   , 3, '.LBL_LIST_MODIFIED_BY'                    , 'MODIFIED_BY_NAME'       , 'MODIFIED_BY_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Threads.Posts'                   , 4, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , 'DATE_MODIFIED'          , '10%', 'DateTime';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.Posts' and HEADER_TEXT = 'Posts.LBL_LIST_TITLE' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/04/2008 Paul.  Threads have a TITLE field instead of a NAME field.
		print 'Threads have a TITLE field instead of a NAME field.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD       = 'TITLE'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Threads.Posts'
		   and HEADER_TEXT      = 'Posts.LBL_LIST_TITLE'
		   and DATA_FIELD       = 'NAME'
		   and URL_FIELD        = 'ID'
		   and DELETED          = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.Posts' and HEADER_TEXT = 'Posts.LBL_LIST_CREATED_BY' and DELETED = 0) begin -- then
		print 'Threads.Posts: Use global term LBL_LIST_CREATED_BY.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT        = '.LBL_LIST_CREATED_BY'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Threads.Posts'
		   and HEADER_TEXT        = 'Posts.LBL_LIST_CREATED_BY'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.Posts' and HEADER_TEXT = 'Posts.LBL_LIST_MODIFIED_BY' and DELETED = 0) begin -- then
		print 'Threads.Posts: Use global term LBL_LIST_MODIFIED_BY.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT        = '.LBL_LIST_MODIFIED_BY'
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Threads.Posts'
		   and HEADER_TEXT        = 'Posts.LBL_LIST_MODIFIED_BY'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 02/09/2008 Paul.  Add credit card management. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.CreditCards';
-- 02/25/2008 Paul.  Index should start with 0. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.CreditCards' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.CreditCards';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.CreditCards', 'CreditCards', 'vwACCOUNTS_CREDIT_CARDS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.CreditCards'          , 0, 'CreditCards.LBL_LIST_NAME'           , 'NAME'               , 'NAME'               , '50%', 'CreditCardsTdLinkS1', 'ID', '~/CreditCards/view.aspx?id={0}', null, 'CreditCards', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.CreditCards'          , 1, 'CreditCards.LBL_LIST_CARD_NUMBER'    , 'CARD_NUMBER_DISPLAY', 'CARD_NUMBER_DISPLAY', '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.CreditCards'          , 2, 'CreditCards.LBL_LIST_EXPIRATION_DATE', 'EXPIRATION_DATE'    , 'EXPIRATION_DATE'    , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.CreditCards'          , 3, 'CreditCards.LBL_LIST_IS_PRIMARY'     , 'IS_PRIMARY'         , 'IS_PRIMARY'         , '10%';
end -- if;
GO

-- 10/07/2010 Paul.  Add Contact field. 
-- 05/10/2013 Paul.  Don't need Account in list because Contacts.CreditCards is used in B2C. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.CreditCards';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.CreditCards' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contacts.CreditCards';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.CreditCards', 'CreditCards', 'vwCONTACTS_CREDIT_CARDS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.CreditCards'          , 0, 'CreditCards.LBL_LIST_NAME'           , 'NAME'               , 'NAME'               , '30%', 'CreditCardsTdLinkS1', 'ID'        , '~/CreditCards/view.aspx?id={0}', null, 'CreditCards', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.CreditCards'          , 1, 'CreditCards.LBL_LIST_CARD_NUMBER'    , 'CARD_NUMBER_DISPLAY', 'CARD_NUMBER_DISPLAY', '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.CreditCards'          , 2, 'CreditCards.LBL_LIST_EXPIRATION_DATE', 'EXPIRATION_DATE'    , 'EXPIRATION_DATE'    , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.CreditCards'          , 3, 'CreditCards.LBL_LIST_IS_PRIMARY'     , 'IS_PRIMARY'         , 'IS_PRIMARY'         , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.PaymentTransactions';
-- 02/25/2008 Paul.  Index should start with 0. 
-- 04/22/2008 Paul.  Add STATUS field.  It will be used to show the Refund Now link.
-- 04/22/2008 Paul.  The ERROR_MESSAGE field has much more useful information than the ERROR_CODE. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.PaymentTransactions' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.PaymentTransactions';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.PaymentTransactions', 'Payments', 'vwPAYMENTS_TRANSACTIONS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.PaymentTransactions'  , 0, 'Payments.LBL_LIST_NAME'              , 'CARD_NAME'          , 'CARD_NAME'          , '15%', 'CreditCardsTdLinkS1', 'CREDIT_CARD_ID', '~/CreditCards/view.aspx?id={0}', null, 'CreditCards', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PaymentTransactions'  , 1, 'Payments.LBL_LIST_CARD_NUMBER'       , 'CARD_NUMBER_DISPLAY', 'CARD_NUMBER_DISPLAY', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PaymentTransactions'  , 2, 'Payments.LBL_LIST_TRANSACTION_TYPE'  , 'TRANSACTION_TYPE'   , 'TRANSACTION_TYPE'   , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PaymentTransactions'  , 3, 'Payments.LBL_LIST_TRANSACTION_NUMBER', 'TRANSACTION_NUMBER' , 'TRANSACTION_NUMBER' , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.PaymentTransactions'  , 4, 'Payments.LBL_LIST_AMOUNT'            , 'AMOUNT'             , 'AMOUNT'             , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PaymentTransactions'  , 5, 'Payments.LBL_LIST_AUTHORIZATION_CODE', 'AUTHORIZATION_CODE' , 'AUTHORIZATION_CODE' , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PaymentTransactions'  , 6, 'Payments.LBL_LIST_ERROR_MESSAGE'     , 'ERROR_MESSAGE'      , 'ERROR_MESSAGE'      , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PaymentTransactions'  , 7, 'Payments.LBL_LIST_STATUS'            , 'STATUS'             , 'STATUS'             , '10%';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PaymentTransactions'  , 7, 'Payments.LBL_LIST_STATUS'            , 'STATUS'             , null, '10%';
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.PaymentTransactions' and DATA_FIELD = 'ERROR_CODE' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT      = 'Payments.LBL_LIST_ERROR_MESSAGE'
		     , DATA_FIELD       = 'ERROR_MESSAGE'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Payments.PaymentTransactions'
		   and DATA_FIELD       = 'ERROR_CODE'
		   and DELETED          = 0;
	end -- if;
end -- if;
GO

-- 04/05/2013 Paul.  The URL module should be ProductTemplates, not Products. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.RelatedProducts';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.RelatedProducts' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.RelatedProducts', 'ProductTemplates', 'vwPRODUCTS_RELATED_PRODUCTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTemplates.RelatedProducts', 0, 'ProductTemplates.LBL_LIST_NAME'           , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID'         , '~/Administration/ProductTemplates/view.aspx?id={0}', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.RelatedProducts', 1, 'ProductTemplates.LBL_LIST_TYPE'           , 'TYPE_NAME'           , 'TYPE_NAME'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.RelatedProducts', 2, 'ProductTemplates.LBL_LIST_CATEGORY'       , 'CATEGORY_NAME'       , 'CATEGORY_NAME'       , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProductTemplates.RelatedProducts', 3, 'ProductTemplates.LBL_LIST_STATUS'         , 'STATUS'              , 'STATUS'              , '10%', 'product_template_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.RelatedProducts', 4, 'ProductTemplates.LBL_LIST_QUANTITY'       , 'QUANTITY'            , 'QUANTITY'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.RelatedProducts', 5, 'ProductTemplates.LBL_LIST_LIST_PRICE'     , 'LIST_USDOLLAR'       , 'LIST_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.RelatedProducts', 6, 'ProductTemplates.LBL_LIST_BOOK_VALUE'     , 'DISCOUNT_USDOLLAR'   , 'DISCOUNT_USDOLLAR'   , '10%', 'Currency';
end else begin
	-- 04/05/2013 Paul.  The URL module should be ProductTemplates, not Products. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.RelatedProducts' and DATA_FIELD = 'NAME' and URL_MODULE = 'Products' and DELETED = 0) begin -- then
		print 'ProductTemplates.RelatedProducts: The URL module should be ProductTemplates, not Products. ';
		update GRIDVIEWS_COLUMNS
		   set URL_MODULE         = 'ProductTemplates'
		     , URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'ProductTemplates.RelatedProducts'
		   and DATA_FIELD         = 'NAME'
		   and URL_MODULE         = 'Products'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 08/05/2010 Paul.  Add views for Quotes, Orders Invoices and Cases. 
-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Cases' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Cases';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Cases', 'Quotes', 'vwQUOTES_CASES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Cases'                    , 0, 'Cases.LBL_LIST_NUMBER'                    , 'CASE_NUMBER'            , 'CASE_NUMBER'            , '25%', 'listViewTdLinkS1', 'ID'   , '~/Cases/view.aspx?id={0}', null, 'Cases', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Cases'                    , 1, 'Cases.LBL_LIST_SUBJECT'                   , 'NAME'                   , 'NAME'                   , '25%', 'listViewTdLinkS1', 'ID'   , '~/Cases/view.aspx?id={0}', null, 'Cases', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Cases'                    , 2, 'Cases.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.Cases'                    , 3, 'Cases.LBL_LIST_STATUS'                    , 'STATUS'                 , 'STATUS'                 , '15%', 'case_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Cases'                  , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Cases' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Cases'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Cases' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.Cases';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.Cases', 'Orders', 'vwORDERS_CASES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Cases'                    , 0, 'Cases.LBL_LIST_NUMBER'                    , 'CASE_NUMBER'            , 'CASE_NUMBER'            , '25%', 'listViewTdLinkS1', 'ID'   , '~/Cases/view.aspx?id={0}', null, 'Cases', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Cases'                    , 1, 'Cases.LBL_LIST_SUBJECT'                   , 'NAME'                   , 'NAME'                   , '25%', 'listViewTdLinkS1', 'ID'   , '~/Cases/view.aspx?id={0}', null, 'Cases', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.Cases'                    , 2, 'Cases.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.Cases'                    , 3, 'Cases.LBL_LIST_STATUS'                    , 'STATUS'                 , 'STATUS'                 , '15%', 'case_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.Cases'                  , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Cases' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.Cases'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Cases' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.Cases';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.Cases', 'Invoices', 'vwINVOICES_CASES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Cases'                  , 0, 'Cases.LBL_LIST_NUMBER'                    , 'CASE_NUMBER'            , 'CASE_NUMBER'            , '25%', 'listViewTdLinkS1', 'ID'   , '~/Cases/view.aspx?id={0}', null, 'Cases', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Cases'                  , 1, 'Cases.LBL_LIST_SUBJECT'                   , 'NAME'                   , 'NAME'                   , '25%', 'listViewTdLinkS1', 'ID'   , '~/Cases/view.aspx?id={0}', null, 'Cases', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.Cases'                  , 2, 'Cases.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.Cases'                  , 3, 'Cases.LBL_LIST_STATUS'                    , 'STATUS'                 , 'STATUS'                 , '15%', 'case_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.Cases'                , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Cases' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.Cases'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 11/04/2010 Paul.  Add dashlets for Quotes, Orders and Invoices. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.MyInvoices' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.MyInvoices' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.MyInvoices';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.MyInvoices', 'Invoices', 'vwINVOICES_MyList';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.MyInvoices'             , 0, 'Invoices.LBL_LIST_INVOICE_NUM'              , 'INVOICE_NUM'            , 'INVOICE_NUM'            , '10%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.MyInvoices'             , 1, 'Invoices.LBL_LIST_NAME'                     , 'NAME'                   , 'NAME'                   , '30%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.MyInvoices'             , 2, 'Invoices.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'   , 'BILLING_ACCOUNT_NAME'   , '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.MyInvoices'             , 3, 'Invoices.LBL_LIST_INVOICE_STAGE'            , 'INVOICE_STAGE'          , 'INVOICE_STAGE'          , '10%', 'invoice_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.MyInvoices'             , 4, 'Invoices.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.MyInvoices'             , 5, 'Invoices.LBL_LIST_AMOUNT_DUE'               , 'AMOUNT_DUE_USDOLLAR'    , 'AMOUNT_DUE_USDOLLAR'    , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.MyInvoices'             , 6, 'Invoices.LBL_LIST_DUE_DATE'                 , 'DUE_DATE'               , 'DUE_DATE'               , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.MyInvoices', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.MyInvoices', 5, null, null, 'right', null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.MyOrders' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.MyOrders' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.MyOrders';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.MyOrders', 'Orders', 'vwORDERS_MyList';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.MyOrders'                 , 0, 'Orders.LBL_LIST_ORDER_NUM'                  , 'ORDER_NUM'              , 'ORDER_NUM'              , '10%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'  , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.MyOrders'                 , 1, 'Orders.LBL_LIST_NAME'                       , 'NAME'                   , 'NAME'                   , '30%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'  , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.MyOrders'                 , 2, 'Orders.LBL_LIST_ACCOUNT_NAME'               , 'BILLING_ACCOUNT_NAME'   , 'BILLING_ACCOUNT_NAME'   , '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.MyOrders'                 , 3, 'Orders.LBL_LIST_ORDER_STAGE'                , 'ORDER_STAGE'            , 'ORDER_STAGE'            , '15%', 'order_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.MyOrders'                 , 4, 'Orders.LBL_LIST_AMOUNT'                     , 'TOTAL_USDOLLAR'         , 'TOTAL_USDOLLAR'         , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.MyOrders'                 , 5, 'Orders.LBL_LIST_DATE_ORDER_DUE'             , 'DATE_ORDER_DUE'         , 'DATE_ORDER_DUE'         , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.MyOrders', 4, null, null, 'right', null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.MyQuotes'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.MyQuotes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.MyQuotes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.MyQuotes', 'Quotes', 'vwQUOTES_MyList';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.MyQuotes'                 , 0, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.MyQuotes'                 , 1, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '30%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.MyQuotes'                 , 2, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.MyQuotes'                 , 3, 'Quotes.LBL_LIST_QUOTE_STAGE'              , 'QUOTE_STAGE'               , 'QUOTE_STAGE'               , '15%', 'quote_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.MyQuotes'                 , 4, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.MyQuotes'                 , 5, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.MyQuotes', 4, null, null, 'right', null, null;
end -- if;
GO

-- 06/21/2011 Paul.  Add views for KBDocuments.Cases. 
-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.Cases' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS KBDocuments.Cases';
	exec dbo.spGRIDVIEWS_InsertOnly           'KBDocuments.Cases', 'KBDocuments', 'vwKBDOCUMENTS_CASES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBDocuments.Cases'               , 0, 'Cases.LBL_LIST_NUMBER'                    , 'CASE_NUMBER'            , 'CASE_NUMBER'            , '25%', 'listViewTdLinkS1', 'ID'   , '~/Cases/view.aspx?id={0}', null, 'Cases', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBDocuments.Cases'               , 1, 'Cases.LBL_LIST_SUBJECT'                   , 'NAME'                   , 'NAME'                   , '25%', 'listViewTdLinkS1', 'ID'   , '~/Cases/view.aspx?id={0}', null, 'Cases', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBDocuments.Cases'               , 2, 'Cases.LBL_LIST_ACCOUNT_NAME'              , 'ACCOUNT_NAME'           , 'ACCOUNT_NAME'           , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'KBDocuments.Cases'               , 3, 'Cases.LBL_LIST_STATUS'                    , 'STATUS'                 , 'STATUS'                 , '15%', 'case_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'KBDocuments.Cases'             , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.Cases' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'KBDocuments.Cases'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 06/07/2015 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.KBDocuments';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.KBDocuments' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Cases.KBDocuments';
	exec dbo.spGRIDVIEWS_InsertOnly           'Cases.KBDocuments', 'KBDocuments', 'vwCASES_KBDOCUMENTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Cases.KBDocuments'               , 0, 'KBDocuments.LBL_LIST_NAME'                , 'NAME'                 , 'NAME'                 , '30', 'listViewTdLinkS1', 'ID', '~/KBDocuments/view.aspx?id={0}', null, 'KBDocuments', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Cases.KBDocuments'               , 1, 'KBDocuments.LBL_LIST_KBDOC_APPROVER_NAME' , 'KBDOC_APPROVER_NAME'  , 'KBDOC_APPROVER_NAME'  , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Cases.KBDocuments'               , 2, '.LBL_LIST_DATE_ENTERED'                   , 'DATE_ENTERED'         , 'DATE_ENTERED'         , '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Cases.KBDocuments'               , 3, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Cases.KBDocuments'               , 4, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Cases.KBDocuments'             , 5, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Cases.KBDocuments' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Cases.KBDocuments'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 09/09/2012 Paul.  Add Documents relationship to Bugs, Cases and Quotes. 
-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Documents' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Documents';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Documents', 'Quotes', 'vwQUOTES_DOCUMENTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.Documents'                , 0, 'Documents.LBL_LIST_DOCUMENT_NAME'        , 'DOCUMENT_NAME'           , 'DOCUMENT_NAME'           , '40%', 'listViewTdLinkS1', 'ID'         , '~/Documents/view.aspx?id={0}', null, 'Documents', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Documents'                , 1, 'Documents.LBL_LIST_IS_TEMPLATE'          , 'IS_TEMPLATE'             , 'IS_TEMPLATE'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Documents'                , 2, 'Documents.LBL_LIST_TEMPLATE_TYPE'        , 'TEMPLATE_TYPE'           , 'TEMPLATE_TYPE'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Documents'                , 3, 'Documents.LBL_LIST_SELECTED_REVISION'    , 'SELECTED_REVISION'       , 'SELECTED_REVISION'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Documents'                , 4, 'Documents.LBL_LIST_REVISION'             , 'REVISION'                , 'REVISION'                , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Documents'              , 5, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Documents' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.Documents'          , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 09/09/2012 Paul.  Add Documents relationship to Bugs, Cases and Quotes. 
-- 06/07/2015 Paul.  Add Preview button. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Documents.Quotes' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Documents.Quotes';
	exec dbo.spGRIDVIEWS_InsertOnly           'Documents.Quotes', 'Documents', 'vwDOCUMENTS_QUOTES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Documents.Quotes'                , 0, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'  , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Documents.Quotes'                , 1, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '40%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Documents.Quotes'                , 2, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Documents.Quotes'                , 3, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Documents.Quotes'              , 4, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 06/07/2015 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Documents.Quotes' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Documents.Quotes'            , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 05/31/2013 Paul.  Add Surveys module. 
-- 11/09/2018 Paul.  Align vertically. 
-- 11/20/2019 Paul.  Reduce NAME size to 10% as question body is 70%. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.SurveyPages';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.SurveyPages' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Surveys.SurveyPages';
	exec dbo.spGRIDVIEWS_InsertOnly           'Surveys.SurveyPages', 'SurveyPages', 'vwSURVEYS_SURVEY_PAGES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Surveys.SurveyPages'             , 1, 'SurveyPages.LBL_LIST_PAGE_NUMBER'         , 'PAGE_NUMBER'               , 'PAGE_NUMBER'               , '10%', 'listViewTdLinkS1', 'ID SURVEY_ID', '~/SurveyPages/view.aspx?id={0}&SURVEY_ID={1}', null, 'SurveyPages', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Surveys.SurveyPages'             , 2, 'SurveyPages.LBL_LIST_NAME'                , 'NAME'                      , 'NAME'                      , '10%', 'listViewTdLinkS1', 'ID SURVEY_ID', '~/SurveyPages/view.aspx?id={0}&SURVEY_ID={1}', null, 'SurveyPages', null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'Surveys.SurveyPages', 1, null, null, null, 'top', null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'Surveys.SurveyPages', 2, null, null, null, 'top', null;
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.SurveyPages' and URL_FORMAT = '~/SurveyPages/view.aspx?id={0}' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_FIELD          = 'ID SURVEY_ID'
		     , URL_FORMAT         = '~/SurveyPages/view.aspx?id={0}&SURVEY_ID={1}'
		     , URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Surveys.SurveyPages'
		   and URL_FORMAT         = '~/SurveyPages/view.aspx?id={0}'
		   and DELETED            = 0;
	end -- if;
	-- 11/09/2018 Paul.  Align vertically. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.SurveyPages' and ITEMSTYLE_VERTICAL_ALIGN is null and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'Surveys.SurveyPages', 1, null, null, null, 'top', null;
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'Surveys.SurveyPages', 2, null, null, null, 'top', null;
	end -- if;
	-- 11/20/2019 Paul.  Reduce NAME size to 10% as question body is 70%. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.SurveyPages' and DATA_FIELD = 'PAGE_NUMBER' and ITEMSTYLE_WIDTH = '15%' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH    = '10%'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Surveys.SurveyPages'
		   and DATA_FIELD         = 'PAGE_NUMBER'
		   and ITEMSTYLE_WIDTH    = '15%'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.SurveyPages' and DATA_FIELD = 'NAME' and ITEMSTYLE_WIDTH = '73%' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH    = '10%'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Surveys.SurveyPages'
		   and DATA_FIELD         = 'NAME'
		   and ITEMSTYLE_WIDTH    = '73%'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO


-- 06/22/2013 Paul.  Include the Survey Pgae so that a Question cancel will return to the page.
-- 11/09/2018 Paul.  Align vertically. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyPages.SurveyQuestions';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyPages.SurveyQuestions' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyPages.SurveyQuestions';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyPages.SurveyQuestions', 'SurveyQuestions', 'vwSURVEY_QUESTIONS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyPages.SurveyQuestions', 1, 'SurveyQuestions.LBL_LIST_QUESTION_NUMBER'  , 'QUESTION_NUMBER'      , 'QUESTION_NUMBER'      , '10%', 'listViewTdLinkS1', 'ID SURVEY_PAGE_ID', '~/SurveyQuestions/view.aspx?id={0}&SURVEY_PAGE_ID={1}', null, 'SurveyQuestions', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyPages.SurveyQuestions', 2, 'SurveyQuestions.LBL_LIST_DESCRIPTION'      , 'DESCRIPTION'          , 'DESCRIPTION'          , '40%', 'listViewTdLinkS1', 'ID SURVEY_PAGE_ID', '~/SurveyQuestions/view.aspx?id={0}&SURVEY_PAGE_ID={1}', null, 'SurveyQuestions', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyPages.SurveyQuestions', 3, 'SurveyQuestions.LBL_LIST_NAME'             , 'NAME'                 , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID SURVEY_PAGE_ID', '~/SurveyQuestions/view.aspx?id={0}&SURVEY_PAGE_ID={1}', null, 'SurveyQuestions', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'SurveyPages.SurveyQuestions', 4, 'SurveyQuestions.LBL_LIST_QUESTION_TYPE'    , 'QUESTION_TYPE'        , 'QUESTION_TYPE'        , '20%', 'survey_question_type';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyPages.SurveyQuestions', 1, null, null, null, 'top', null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyPages.SurveyQuestions', 2, null, null, null, 'top', null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyPages.SurveyQuestions', 3, null, null, null, 'top', null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyPages.SurveyQuestions', 4, null, null, null, 'top', null;
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyPages.SurveyQuestions' and URL_FORMAT = '~/SurveyQuestions/view.aspx?id={0}' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_FIELD          = 'ID SURVEY_PAGE_ID'
		     , URL_FORMAT         = '~/SurveyQuestions/view.aspx?id={0}&SURVEY_PAGE_ID={1}'
		     , URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'SurveyPages.SurveyQuestions'
		   and URL_FORMAT         = '~/SurveyQuestions/view.aspx?id={0}'
		   and DELETED            = 0;
	end -- if;
	-- 11/09/2018 Paul.  Align vertically. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyPages.SurveyQuestions' and ITEMSTYLE_VERTICAL_ALIGN is null and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyPages.SurveyQuestions', 1, null, null, null, 'top', null;
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyPages.SurveyQuestions', 2, null, null, null, 'top', null;
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyPages.SurveyQuestions', 3, null, null, null, 'top', null;
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyPages.SurveyQuestions', 4, null, null, null, 'top', null;
	end -- if;
end -- if;
GO

-- 08/11/2013 Paul.  Add link to Survey Page. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.Surveys';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.Surveys' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyQuestions.Surveys';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyQuestions.Surveys', 'Surveys', 'vwSURVEYS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.Surveys'    , 0, 'Surveys.LBL_LIST_NAME'                     , 'NAME'                 , 'NAME'                 , '60%', 'listViewTdLinkS1', 'ID', '~/Surveys/view.aspx?id={0}', null, 'Surveys', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.Surveys'    , 1, 'SurveyQuestions.LBL_LIST_QUESTION_NUMBER'  , 'QUESTION_NUMBER'      , 'QUESTION_NUMBER'      , '5%' , 'listViewTdLinkS1', 'SURVEY_PAGE_ID ID', '~/SurveyPages/view.aspx?id={0}&SURVEY_ID={1}', null, 'SurveyPages', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.Surveys'    , 2, 'SurveyQuestions.LBL_LIST_SURVEY_PAGE_NAME' , 'SURVEY_PAGE_NAME'     , 'SURVEY_PAGE_NAME'     , '10%', 'listViewTdLinkS1', 'SURVEY_PAGE_ID ID', '~/SurveyPages/view.aspx?id={0}&SURVEY_ID={1}', null, 'SurveyPages', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'SurveyQuestions.Surveys'    , 3, 'Surveys.LBL_LIST_STATUS'                   , 'STATUS'               , 'STATUS'               , '15%', 'survey_status_dom';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.Surveys' and DATA_FIELD = 'QUESTION_NUMBER' and COLUMN_TYPE = 'BoundColumn' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set DELETED            = 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'SurveyQuestions.Surveys'
		   and DATA_FIELD         = 'QUESTION_NUMBER'
		   and COLUMN_TYPE        = 'BoundColumn'
		   and DELETED            = 0;
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX       = COLUMN_INDEX + 1
		     , DATE_MODIFIED      = getdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'SurveyQuestions.Surveys'
		   and COLUMN_INDEX       > 1
		   and DELETED            = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.Surveys'    , 1, 'SurveyQuestions.LBL_LIST_QUESTION_NUMBER'  , 'QUESTION_NUMBER'      , 'QUESTION_NUMBER'      , '5%' , 'listViewTdLinkS1', 'SURVEY_PAGE_ID ID', '~/SurveyPages/view.aspx?id={0}&SURVEY_ID={1}', null, 'SurveyPages', 'ASSIGNED_USER_ID';
		exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.Surveys'    , 2, 'SurveyQuestions.LBL_LIST_SURVEY_PAGE_NAME' , 'SURVEY_PAGE_NAME'     , 'SURVEY_PAGE_NAME'     , '10%', 'listViewTdLinkS1', 'SURVEY_PAGE_ID ID', '~/SurveyPages/view.aspx?id={0}&SURVEY_ID={1}', null, 'SurveyPages', 'ASSIGNED_USER_ID';
	end -- if;
end -- if;
GO

-- 10/24/2014 Paul.  Add SurveyResults. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.SurveyResults' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'Contacts.SurveyResults', 'SurveyResults', 'vwCONTACTS_SURVEY_RESULTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contacts.SurveyResults'     , 0, 'SurveyResults.LBL_LIST_SURVEY_NAME'        , 'SURVEY_NAME'          , 'SURVEY_NAME'          , '55%', 'listViewTdLinkS1', 'ID', '~/SurveyResults/view.aspx?id={0}', null, 'SurveyResults', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contacts.SurveyResults'     , 1, 'SurveyResults.LBL_LIST_IS_COMPLETE'        , 'IS_COMPLETE'          , 'IS_COMPLETE'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.SurveyResults'     , 2, 'SurveyResults.LBL_LIST_START_DATE'         , 'START_DATE'           , 'START_DATE'           , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contacts.SurveyResults'     , 3, 'SurveyResults.LBL_LIST_SUBMIT_DATE'        , 'SUBMIT_DATE'          , 'SUBMIT_DATE'          , '15%', 'DateTime';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.SurveyResults' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'Leads.SurveyResults', 'SurveyResults', 'vwLEADS_SURVEY_RESULTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Leads.SurveyResults'        , 0, 'SurveyResults.LBL_LIST_SURVEY_NAME'        , 'SURVEY_NAME'          , 'SURVEY_NAME'          , '55%', 'listViewTdLinkS1', 'ID', '~/SurveyResults/view.aspx?id={0}', null, 'SurveyResults', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Leads.SurveyResults'        , 1, 'SurveyResults.LBL_LIST_IS_COMPLETE'        , 'IS_COMPLETE'          , 'IS_COMPLETE'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Leads.SurveyResults'        , 2, 'SurveyResults.LBL_LIST_START_DATE'         , 'START_DATE'           , 'START_DATE'           , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Leads.SurveyResults'        , 3, 'SurveyResults.LBL_LIST_SUBMIT_DATE'        , 'SUBMIT_DATE'          , 'SUBMIT_DATE'          , '15%', 'DateTime';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.SurveyResults' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'Prospects.SurveyResults', 'SurveyResults', 'vwPROSPECTS_SURVEY_RESULTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Prospects.SurveyResults'    , 0, 'SurveyResults.LBL_LIST_SURVEY_NAME'        , 'SURVEY_NAME'          , 'SURVEY_NAME'          , '55%', 'listViewTdLinkS1', 'ID', '~/SurveyResults/view.aspx?id={0}', null, 'SurveyResults', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Prospects.SurveyResults'    , 1, 'SurveyResults.LBL_LIST_IS_COMPLETE'        , 'IS_COMPLETE'          , 'IS_COMPLETE'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospects.SurveyResults'    , 2, 'SurveyResults.LBL_LIST_START_DATE'         , 'START_DATE'           , 'START_DATE'           , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Prospects.SurveyResults'    , 3, 'SurveyResults.LBL_LIST_SUBMIT_DATE'        , 'SUBMIT_DATE'          , 'SUBMIT_DATE'          , '15%', 'DateTime';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Users.SurveyResults' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'Users.SurveyResults', 'SurveyResults', 'vwUSERS_SURVEY_RESULTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Users.SurveyResults'        , 0, 'SurveyResults.LBL_LIST_SURVEY_NAME'        , 'SURVEY_NAME'          , 'SURVEY_NAME'          , '55%', 'listViewTdLinkS1', 'ID', '~/SurveyResults/view.aspx?id={0}', null, 'SurveyResults', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Users.SurveyResults'        , 1, 'SurveyResults.LBL_LIST_IS_COMPLETE'        , 'IS_COMPLETE'          , 'IS_COMPLETE'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Users.SurveyResults'        , 2, 'SurveyResults.LBL_LIST_START_DATE'         , 'START_DATE'           , 'START_DATE'           , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Users.SurveyResults'        , 3, 'SurveyResults.LBL_LIST_SUBMIT_DATE'        , 'SUBMIT_DATE'          , 'SUBMIT_DATE'          , '15%', 'DateTime';
end -- if;
GO

-- 11/05/2013 Paul.  Add Tweets to TwitterTracks. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'TwitterTracks.TwitterMessages';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TwitterTracks.TwitterMessages' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS TwitterTracks.TwitterMessages';
	exec dbo.spGRIDVIEWS_InsertOnly           'TwitterTracks.TwitterMessages', 'TwitterMessages', 'vwTWITTER_TRACK_MESSAGES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TwitterTracks.TwitterMessages'   ,  0, 'TwitterMessages.LBL_LIST_NAME'                , 'NAME'                , 'NAME'                , '40%', 'listViewTdLinkS1', 'ID'       , '~/TwitterMessages/view.aspx?id={0}', null, 'TwitterMessages', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'TwitterTracks.TwitterMessages'   ,  1, 'TwitterMessages.LBL_LIST_DATE_START'          , 'DATE_START'          , 'DATE_START'          , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TwitterTracks.TwitterMessages'   ,  2, 'TwitterMessages.LBL_LIST_TWITTER_SCREEN_NAME' , 'TWITTER_SCREEN_NAME' , 'TWITTER_SCREEN_NAME' , '10%', 'listViewTdLinkS1', 'TWITTER_SCREEN_NAME', 'http://twitter.com/{0}', 'TwitterUser', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TwitterTracks.TwitterMessages'   ,  3, 'TwitterMessages.LBL_LIST_RELATED_TO'          , 'PARENT_NAME'         , 'PARENT_NAME'         , '10%', 'listViewTdLinkS1', 'PARENT_ID', '~/Parents/view.aspx?id={0}', null, 'Parents', 'PARENT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TwitterTracks.TwitterMessages'   ,  4, 'TwitterMessages.LBL_LIST_IS_RETWEET'          , 'IS_RETWEET'          , 'IS_RETWEET'          , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TwitterTracks.TwitterMessages'   ,  5, 'TwitterMessages.LBL_LIST_ORIGINAL_SCREEN_NAME', 'ORIGINAL_SCREEN_NAME', 'ORIGINAL_SCREEN_NAME', '10%', 'listViewTdLinkS1', 'ORIGINAL_SCREEN_NAME', 'http://twitter.com/{0}', 'TwitterUser', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TwitterTracks.TwitterMessages'   ,  6, '.LBL_LIST_ASSIGNED_USER'                      , 'ASSIGNED_TO_NAME'    , 'ASSIGNED_TO_NAME'    , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TwitterTracks.TwitterMessages'   ,  7, 'Teams.LBL_LIST_TEAM'                          , 'TEAM_NAME'           , 'TEAM_NAME'           , '5%';
end -- if;
GO

-- 12/09/2015 Paul.  Add Opportunities Line Items.
-- 03/06/2016 Paul.  Change to Opportunities to make it easier to support HTML5. 
if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'RevenueLineItems.LineItems' and DELETED = 0) begin -- then
	update GRIDVIEWS
	   set NAME              = 'Opportunities.LineItems'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where NAME              = 'RevenueLineItems.LineItems'
	   and DELETED           = 0;
	update GRIDVIEWS_COLUMNS
	   set GRID_NAME         = 'Opportunities.LineItems'
	     , HEADER_TEXT       = replace(HEADER_TEXT, 'RevenueLineItems.', 'Opportunities.')
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where GRID_NAME         = 'RevenueLineItems.LineItems'
	   and DELETED           = 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.LineItems' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.LineItems' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Opportunities.LineItems';
	exec dbo.spGRIDVIEWS_InsertOnly           'Opportunities.LineItems', 'Opportunities', 'vwOPPORTUNITIES_LINE_ITEMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.LineItems'      ,  0, 'Opportunities.LBL_LIST_ITEM_QUANTITY'              , 'QUANTITY'               , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.LineItems'      ,  1, 'Opportunities.LBL_LIST_ITEM_NAME'                  , 'NAME'                   , null, '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Opportunities.LineItems'      ,  2, 'Opportunities.LBL_LIST_ITEM_MFT_PART_NUM'          , 'MFT_PART_NUM'           , null, '10%', 'listViewTdLinkS1', 'PRODUCT_TEMPLATE_ID', '~/Products/ProductCatalog/view.aspx?id={0}', null, 'Products', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.LineItems'      ,  3, 'Opportunities.LBL_LIST_ITEM_LIST_PRICE'            , 'LIST_USDOLLAR'          , null, '5%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.LineItems'      ,  4, 'Opportunities.LBL_LIST_ITEM_UNIT_PRICE'            , 'UNIT_USDOLLAR'          , null, '5%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.LineItems'      ,  5, 'Opportunities.LBL_LIST_ITEM_EXTENDED_PRICE'        , 'EXTENDED_USDOLLAR'      , null, '5%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.LineItems'      ,  6, 'Opportunities.LBL_LIST_ITEM_DISCOUNT_PRICE'        , 'DISCOUNT_USDOLLAR'      , null, '5%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Opportunities.LineItems'      ,  7, 'Opportunities.LBL_LIST_ITEM_DATE_CLOSED'           , 'DATE_CLOSED'            , null, '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Opportunities.LineItems'      ,  8, 'Opportunities.LBL_LIST_ITEM_OPPORTUNITY_TYPE'      , 'OPPORTUNITY_TYPE'       , null, '5%', 'opportunity_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Opportunities.LineItems'      ,  9, 'Opportunities.LBL_LIST_ITEM_LEAD_SOURCE'           , 'LEAD_SOURCE'            , null, '5%', 'lead_source_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.LineItems'      , 10, 'Opportunities.LBL_LIST_ITEM_NEXT_STEP'             , 'NEXT_STEP'              , null, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Opportunities.LineItems'      , 11, 'Opportunities.LBL_LIST_ITEM_SALES_STAGE'           , 'SALES_STAGE'            , null, '5%', 'sales_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Opportunities.LineItems'      , 12, 'Opportunities.LBL_LIST_ITEM_PROBABILITY'           , 'PROBABILITY'            , null, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Opportunities.LineItems', 0, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Opportunities.LineItems', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Opportunities.LineItems', 4, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Opportunities.LineItems', 5, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Opportunities.LineItems', 6, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Opportunities.LineItems', 7, null, null, 'right', null, null;
end else begin
	-- 07/29/2019 Paul.  Correct invalid field. 
	if exists(select * from vwGRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.LineItems' and URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where GRID_NAME          = 'Opportunities.LineItems'
		   and URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 12/16/2015 Paul.  Add Authorize.Net module. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.LineItems';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.LineItems' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS AuthorizeNet.LineItems';
	exec dbo.spGRIDVIEWS_InsertOnly 'AuthorizeNet.LineItems', 'AuthorizeNet', 'vwAuthorizeNet_LineItems';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.LineItems'          ,  0, 'AuthorizeNet.LBL_LIST_ITEM_QUANTITY'                  , 'quantity'                , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.LineItems'          ,  1, 'AuthorizeNet.LBL_LIST_ITEM_ITEM_ID'                   , 'itemId'                  , null, '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.LineItems'          ,  2, 'AuthorizeNet.LBL_LIST_ITEM_NAME'                      , 'name'                    , null, '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.LineItems'          ,  3, 'AuthorizeNet.LBL_LIST_ITEM_DESCRIPTION'               , 'description'             , null, '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'AuthorizeNet.LineItems'          ,  4, 'AuthorizeNet.LBL_LIST_ITEM_UNIT_PRICE'                , 'unitPrice'               , null, '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.LineItems'          ,  5, 'AuthorizeNet.LBL_LIST_ITEM_TAXABLE'                   , 'taxable'                 , null, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'AuthorizeNet.LineItems', 0, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'AuthorizeNet.LineItems', 4, null, null, 'right', null, null;
end -- if;
GO

-- 01/01/2017 Paul.  Add Regions. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.Regions';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.Regions' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Teams.Regions';
	exec dbo.spGRIDVIEWS_InsertOnly           'Teams.Regions', 'Regions', 'vwTEAMS_REGIONS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Teams.Regions'            , 0, 'Regions.LBL_LIST_NAME'                      , 'NAME'                   , 'NAME'                   , '95%', 'listViewTdLinkS1', 'ID', '~/Administration/Regions/view.aspx?id={0}', null, 'Regions', null;
end -- if;
GO

-- 09/12/2019 Paul.  Users.Teams for the React Client. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Users.Teams'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Users.Teams' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Users.Teams';
	exec dbo.spGRIDVIEWS_InsertOnly           'Users.Teams', 'Teams', 'vwUSERS_TEAM_MEMBERSHIPS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Users.Teams'              , 1, 'Teams.LBL_LIST_NAME'                        , 'TEAM_NAME'              , 'TEAM_NAME'                     , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Users.Teams'              , 2, 'Teams.LBL_LIST_DESCRIPTION'                 , 'DESCRIPTION'            , 'DESCRIPTION'                   , '60%';
end -- if;
GO

-- 06/26/2020 Paul.  Still seeing this invalid field DUCT_TEMPLATE_ASSIGNED_USER_ID. 
if exists(select * from vwGRIDVIEWS_COLUMNS where URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID' and DELETED = 0) begin -- then
	update GRIDVIEWS_COLUMNS
	   set URL_ASSIGNED_FIELD = null
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where URL_ASSIGNED_FIELD = 'DUCT_TEMPLATE_ASSIGNED_USER_ID'
	   and DELETED = 0;
end -- if;
GO

-- 10/16/2020 Paul.  Regions.Countries for the React Client. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Regions.Countries'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Regions.Countries' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Regions.Countries';
	exec dbo.spGRIDVIEWS_InsertOnly           'Regions.Countries', 'Regions', 'Regions.Countries';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Regions.Countries'        , 1, 'Regions.LBL_LIST_COUNTRY'                   , 'COUNTRY'                , 'COUNTRY'                       , '95%';
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

call dbo.spGRIDVIEWS_COLUMNS_SubPanelsProfessional()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_SubPanelsProfessional')
/

-- #endif IBM_DB2 */




print 'GRIDVIEWS_COLUMNS ListView Professional';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 01/01/2008 Paul.  Documents, CampaignTrackers, EmailMarketing, EmailTemplates, Employees and ProductTemplates
-- all do not have ASSIGNED_USER_ID fields.  Remove them so that no attempt will be made to filter on ASSIGNED_USER_ID.  
-- 11/17/2007 Paul.  Add spGRIDVIEWS_InsertOnly to simplify creation of Mobile views.
-- 09/08/2008 Paul.  Must use a comment block to allow Oracle migration to work properly. 
-- 08/24/2009 Paul.  Change TEAM_NAME to TEAM_SET_NAME. 
-- 08/28/2009 Paul.  Restore TEAM_NAME and expect it to be converted automatically when DynamicTeams is enabled. 
-- 01/13/2010 Paul.  Default to Assigned before Team. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 08/02/2010 Paul.  Add information hover. 
-- 08/02/2010 Paul.  Increase the first item so that the Edit link will be next to the checkbox. 

/*
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Roles.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Roles.ListView';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Roles.ListView'             , 0, 'Roles.LBL_NAME'                           , 'NAME'            , 'NAME'            , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/Roles/view.aspx?id={0}', null, 'Roles', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Roles.ListView'             , 1, 'Roles.LBL_DESCRIPTION'                    , 'DESCRIPTION'     , 'DESCRIPTION'     , '80%';
end -- if;
*/

-- 06/03/2006 Paul.  Add support for Contracts. 
-- 03/08/2014 Paul.  Add Preview button. 
-- 05/15/2016 Paul.  Add tags to list view. 
-- select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView' and DEFAULT_VIEW = 0 and DELETED = 0 order by COLUMN_INDEX;
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.ListView', 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.ListView'         ,  2, 'Contracts.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '20%', 'listViewTdLinkS1', 'ID'         , '~/Contracts/view.aspx?id={0}', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.ListView'         ,  3, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '20%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}' , null, 'Accounts' , 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.ListView'         ,  4, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'          , 'STATUS'          , '15%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.ListView'         ,  5, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'      , 'START_DATE'      , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.ListView'         ,  6, 'Contracts.LBL_LIST_END_DATE'              , 'END_DATE'        , 'END_DATE'        , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Contracts.ListView'         ,  7, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView'         ,  8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView'         ,  9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.ListView'       , 10, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Contracts.ListView', 2;
	exec dbo.spGRIDVIEWS_COLUMNS_InsField     'Contracts.ListView'         , 8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
	-- 03/08/2014 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Contracts.ListView'       , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '20%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Contracts.ListView'
		   and DATA_FIELD       in ('NAME', 'ACCOUNT_NAME')
		   and ITEMSTYLE_WIDTH  = '25%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Contracts.ListView'         ,  7, '10%';
	end -- if;
end -- if;
GO

-- 11/11/2007 Paul.  The label for list price is odd, but this version does not have the colon in the name. 
-- 12/28/2007 Paul.  Products now displays information from the ORDERS_LINE_ITEMS table, so some of the fields need to change. 
-- 05/12/2009 Paul.  Add link to order. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.ListView';
-- 01/02/2008 Paul.  Products needs to display line items and products.
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.ListView' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'Products.ListView', 'Products', 'vwPRODUCTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.ListView'          , 2, 'Products.LBL_LIST_NAME'                   , 'PRODUCT_NAME'        , 'PRODUCT_NAME'        , '25%', 'listViewTdLinkS1', 'ID'         , '~/OrdersLineItems/view.aspx?id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.ListView'          , 3, 'Products.LBL_LIST_ORDER_NAME'             , 'ORDER_NAME'          , 'ORDER_NAME'          , '25%', 'listViewTdLinkS1', 'ORDER_ID'   , '~/Orders/view.aspx?id={0}'  , null, 'Orders'  , 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.ListView'          , 4, 'Products.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'        , 'ACCOUNT_NAME'        , '25%', 'listViewTdLinkS1', 'ACCOUNT_ID' , '~/Accounts/view.aspx?id={0}', null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Products.ListView'          , 5, 'Orders.LBL_LIST_ORDER_STAGE'              , 'ORDER_STAGE'         , 'ORDER_STAGE'         , '10%', 'order_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.ListView'          , 6, 'Products.LBL_LIST_QUANTITY'               , 'QUANTITY'            , 'QUANTITY'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Products.ListView'          , 7, 'Orders.LBL_LIST_ITEM_EXTENDED_PRICE'      , 'EXTENDED_USDOLLAR'   , 'EXTENDED_USDOLLAR'   , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Products.ListView'          , 8, 'Products.LBL_LIST_DATE_PURCHASED'         , 'DATE_PURCHASED'      , 'DATE_PURCHASED'      , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.ListView'          , 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'           , 'TEAM_NAME'           , '10%';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Products.ListView', 2;
	exec dbo.spGRIDVIEWS_COLUMNS_InsField     'Products.ListView'          , 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'           , 'TEAM_NAME'           , '10%';
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.ListView' and HEADER_TEXT = 'Products.LBL_LIST_NAME' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/02/2008 Paul.  The primary records will be from the orders line items. 
		print 'Products needs to display line items and products.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'PRODUCT_NAME'
		     , SORT_EXPRESSION    = 'PRODUCT_NAME'
		     , URL_FIELD          = 'PRODUCT_ID'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Products.ListView'
		   and HEADER_TEXT        = 'Products.LBL_LIST_NAME'
		   and DATA_FIELD         = 'NAME'
		   and URL_FIELD          = 'ID'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.ListView' and DATA_FIELD = 'DATE_SUPPORT_EXPIRES' and DELETED = 0) begin -- then
		print 'Drop DATE_SUPPORT_EXPIRES from product view.';
		update GRIDVIEWS_COLUMNS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Products.ListView'
		   and DATA_FIELD       = 'DATE_SUPPORT_EXPIRES'
		   and DELETED          = 0 ;
	end -- if;
	-- 04/22/2008 Paul.  SORT_EXPRESSION was not fixed the last time we fixed DISCOUNT_USDOLLAR. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.ListView' and (DATA_FIELD = 'DISCOUNT_USDOLLAR' or SORT_EXPRESSION = 'DISCOUNT_USDOLLAR') and DELETED = 0) begin -- then
		print 'Change DISCOUNT_USDOLLAR to EXTENDED_USDOLLAR in product view.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT      = 'Orders.LBL_LIST_ITEM_EXTENDED_PRICE'
		     , DATA_FIELD       = 'EXTENDED_USDOLLAR'
		     , SORT_EXPRESSION  = 'EXTENDED_USDOLLAR'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Products.ListView'
		   and (DATA_FIELD      = 'DISCOUNT_USDOLLAR' or SORT_EXPRESSION = 'DISCOUNT_USDOLLAR')
		   and DELETED          = 0 ;
	end -- if;
	-- 04/22/2008 Paul.  SORT_EXPRESSION was not fixed the last time we fixed STATUS. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.ListView' and (DATA_FIELD = 'STATUS' or SORT_EXPRESSION = 'STATUS') and DELETED = 0) begin -- then
		print 'Change STATUS to SALES_STAGE in product view.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT      = 'Orders.LBL_LIST_ORDER_STAGE'
		     , DATA_FIELD       = 'ORDER_STAGE'
		     , SORT_EXPRESSION  = 'ORDER_STAGE'
		     , LIST_NAME        = 'order_stage_dom'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Products.ListView'
		   and (DATA_FIELD      = 'STATUS' or SORT_EXPRESSION = 'STATUS')
		   and DELETED          = 0 ;
	end -- if;

	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.ListView' and URL_FORMAT = '~/Products/view.aspx?id={0}' and DELETED = 0) begin -- then
		-- 05/12/2009 Paul.  Add link to order. 
		print 'Change Products to link to the order.';
		update GRIDVIEWS_COLUMNS
		   set URL_FIELD          = 'ID'
		     , URL_FORMAT         = '~/OrdersLineItems/view.aspx?id={0}'
		     , URL_MODULE         = null
		     , URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Products.ListView'
		   and URL_FORMAT         = '~/Products/view.aspx?id={0}'
		   and DELETED            = 0 ;

		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX     = COLUMN_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Products.ListView'
		   and COLUMN_INDEX     > 1
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.ListView'          , 3, 'Products.LBL_LIST_ORDER_NAME'             , 'ORDER_NAME'          , 'ORDER_NAME'          , '25%', 'listViewTdLinkS1', 'ORDER_ID'   , '~/Orders/view.aspx?id={0}'  , null, 'Orders'  , 'ACCOUNT_ASSIGNED_USER_ID';
	end -- if;
end -- if;
GO

-- 02/05/2014 Paul.  Add Teams to ProductTemplates. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.ListView', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	-- 05/08/2008 Paul.  ASSIGNED_USER_ID does not apply to ProductTemplates. 
	-- 03/22/2013 Paul.  URL_MODULE is ProductTemplates. 
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTemplates.ListView'  , 2, 'ProductTemplates.LBL_LIST_NAME'           , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID'         , '~/Administration/ProductTemplates/view.aspx?id={0}', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView'  , 3, 'ProductTemplates.LBL_LIST_TYPE'           , 'TYPE_NAME'           , 'TYPE_NAME'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView'  , 4, 'ProductTemplates.LBL_LIST_CATEGORY'       , 'CATEGORY_NAME'       , 'CATEGORY_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProductTemplates.ListView'  , 5, 'ProductTemplates.LBL_LIST_STATUS'         , 'STATUS'              , 'STATUS'              , '10%', 'product_template_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView'  , 6, 'ProductTemplates.LBL_LIST_QUANTITY'       , 'QUANTITY'            , 'QUANTITY'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView'  , 7, 'ProductTemplates.LBL_LIST_COST'           , 'COST_USDOLLAR'       , 'COST_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView'  , 8, 'ProductTemplates.LBL_LIST_LIST_PRICE'     , 'LIST_USDOLLAR'       , 'LIST_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView'  , 9, 'ProductTemplates.LBL_LIST_BOOK_VALUE'     , 'DISCOUNT_USDOLLAR'   , 'DISCOUNT_USDOLLAR'   , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView'  ,10, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'           , 'TEAM_NAME'           , '5%';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'ProductTemplates.ListView', 2;
	-- 05/08/2008 Paul.  ASSIGNED_USER_ID does not apply to ProductTemplates. 
	-- 03/22/2013 Paul.  URL_MODULE is ProductTemplates. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView' and URL_ASSIGNED_FIELD = 'ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		print 'ASSIGNED_USER_ID does not apply to ProductTemplates.';
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , URL_MODULE         = 'ProductTemplates'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'ProductTemplates.ListView'
		   and URL_ASSIGNED_FIELD = 'ASSIGNED_USER_ID'
		   and DELETED            = 0 ;
	end -- if;
	exec dbo.spGRIDVIEWS_COLUMNS_InsField     'ProductTemplates.ListView'  ,10, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'           , 'TEAM_NAME'           , '5%';
end -- if;
GO

-- 12/28/2007 Paul.  Fix the column index so that it does not start with 0. 
-- 03/08/2014 Paul.  Add Preview button. 
-- 05/15/2016 Paul.  Add tags to list view. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.ListView', 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView'            ,  2, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView'            ,  3, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView'            ,  4, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.ListView'            ,  5, 'Quotes.LBL_LIST_QUOTE_STAGE'              , 'QUOTE_STAGE'               , 'QUOTE_STAGE'               , '10%', 'quote_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView'            ,  6, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView'            ,  7, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Quotes.ListView'            ,  8, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView'            ,  9, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView'            , 10, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Quotes.ListView'            , 112, null, null, '1%', 'Quotes.LBL_PURCHASE_ORDER_NUM PURCHASE_ORDER_NUM Quotes.LBL_BILLING_ADDRESS BILLING_ADDRESS_STREET BILLING_ADDRESS_CITY BILLING_ADDRESS_STATE BILLING_ADDRESS_POSTALCODE BILLING_ADDRESS_COUNTRY Quotes.LBL_SHIPPING_ADDRESS SHIPPING_ADDRESS_STREET SHIPPING_ADDRESS_CITY SHIPPING_ADDRESS_STATE SHIPPING_ADDRESS_POSTALCODE SHIPPING_ADDRESS_COUNTRY Quotes.LBL_SUBTOTAL SUBTOTAL_USDOLLAR Quotes.LBL_TOTAL TOTAL_USDOLLAR', '<div class="ListViewInfoHover">
<b>{0}</b> {1}<br />
<b>{2}</b><br />
{3}<br />
{4}, {5} {6} {7}<br />
<b>{8}</b><br />
{9}<br />
{10}, {11} {12} {13}<br />
<br />
<b>{14}</b> {15:c}<br />
<b>{16}</b> {17:c}<br />
</div>', 'info_inline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.ListView'          ,11, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Quotes.ListView', 2;
	exec dbo.spGRIDVIEWS_COLUMNS_InsField     'Quotes.ListView'            , 9, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '5%';
	-- 06/20/2007 Paul.  Conversion to Oracle was having a problem with 'else if' and the exists clause. 
	-- 08/02/2010 Paul.  Removed the code as it is solved using ReserveIndex. 
	-- 03/08/2014 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Quotes.ListView'          , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '20%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Quotes.ListView'
		   and DATA_FIELD       = 'NAME'
		   and ITEMSTYLE_WIDTH  = '25%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Quotes.ListView'            ,  8, '5%';
	end -- if;
end -- if;
GO

-- 04/12/2016 Paul.  Add parent team and custom fields. 
-- 04/28/2016 Paul.  Rename parent to PARENT_ID. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.ListView'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Teams.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Teams.ListView', 'Teams', 'vwTEAMS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Teams.ListView'             , 1, 'Teams.LBL_LIST_NAME'                      , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID', '~/Administration/Teams/view.aspx?id={0}', null, 'Teams', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.ListView'             , 2, 'Teams.LBL_LIST_DESCRIPTION'               , 'DESCRIPTION'     , 'DESCRIPTION'     , '45%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.ListView'             , 3, 'Teams.LBL_LIST_PARENT_NAME'               , 'PARENT_NAME'     , 'PARENT_NAME'     , '20%';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Teams.ListView', 1;
	-- 04/12/2016 Paul.  Add parent team and custom fields. 
	-- 04/28/2016 Paul.  Rename parent to PARENT_ID. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.ListView' and DATA_FIELD = 'PARENT_TEAM_NAME' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD       = 'PARENT_NAME'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Teams.ListView'
		   and DATA_FIELD       = 'PARENT_TEAM_NAME'
		   and DELETED          = 0;
	end -- if;
	-- 02/22/2017 Paul.  Fix filter. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.ListView' and DATA_FIELD = 'PARENT_NAME' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.ListView'             , 3, 'Teams.LBL_LIST_PARENT_NAME'               , 'PARENT_NAME'     , 'PARENT_NAME'     , '20%';
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'TeamNotices.ListView'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TeamNotices.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS TeamNotices.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'TeamNotices.ListView', 'TeamNotices', 'vwTEAM_NOTICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TeamNotices.ListView'       , 2, 'TeamNotices.LBL_LIST_NAME'                , 'NAME'            , 'NAME'            , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/TeamNotices/edit.aspx?id={0}', null, 'TeamNotices', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TeamNotices.ListView'       , 3, 'TeamNotices.LBL_LIST_DESCRIPTION'         , 'DESCRIPTION'     , 'DESCRIPTION'     , '35%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'TeamNotices.ListView'       , 4, 'TeamNotices.LBL_LIST_STATUS'              , 'STATUS'          , 'STATUS'          , '10%', 'team_notice_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'TeamNotices.ListView'       , 5, 'TeamNotices.LBL_LIST_DATE_START'          , 'DATE_START'      , 'DATE_START'      , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'TeamNotices.ListView'       , 6, 'TeamNotices.LBL_LIST_DATE_END'            , 'DATE_END'        , 'DATE_END'        , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TeamNotices.ListView'       , 7, 'TeamNotices.LBL_LIST_TEAM'                , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'TeamNotices.ListView', 2;
end -- if;
GO

-- 07/18/2006 Paul.  Fix quotes links.  They were pointing to Contracts. 
if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView' and DATA_FIELD in ('QUOTE_NUM', 'NAME') and URL_FORMAT = '~/Contracts/view.aspx?id={0}' and DELETED = 0) begin -- then
	print 'Fix quotes links. ';
	update GRIDVIEWS_COLUMNS
	   set URL_FORMAT       = '~/Quotes/view.aspx?id={0}'
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = null
	 where GRID_NAME        = 'Quotes.ListView'
	   and DATA_FIELD       in ('QUOTE_NUM', 'NAME')
	   and URL_FORMAT       = '~/Contracts/view.aspx?id={0}'
	   and DELETED          = 0;
end -- if;
GO

-- 04/03/2007 Paul.  Add Orders module. 
-- 03/08/2014 Paul.  Add Preview button. 
-- 05/15/2016 Paul.  Add tags to list view. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.ListView', 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView'            ,  2, 'Orders.LBL_LIST_ORDER_NUM'                , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView'            ,  3, 'Orders.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView'            ,  4, 'Orders.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.ListView'            ,  5, 'Orders.LBL_LIST_ORDER_STAGE'              , 'ORDER_STAGE'               , 'ORDER_STAGE'               , '10%', 'order_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView'            ,  6, 'Orders.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView'            ,  7, 'Orders.LBL_LIST_DATE_ORDER_DUE'           , 'DATE_ORDER_DUE'            , 'DATE_ORDER_DUE'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Orders.ListView'            ,  8, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView'            ,  9, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView'            , 10, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Orders.ListView'            , 11, null, null, '1%', 'Orders.LBL_PURCHASE_ORDER_NUM PURCHASE_ORDER_NUM Orders.LBL_BILLING_ADDRESS BILLING_ADDRESS_STREET BILLING_ADDRESS_CITY BILLING_ADDRESS_STATE BILLING_ADDRESS_POSTALCODE BILLING_ADDRESS_COUNTRY Orders.LBL_SHIPPING_ADDRESS SHIPPING_ADDRESS_STREET SHIPPING_ADDRESS_CITY SHIPPING_ADDRESS_STATE SHIPPING_ADDRESS_POSTALCODE SHIPPING_ADDRESS_COUNTRY Orders.LBL_SUBTOTAL SUBTOTAL_USDOLLAR Orders.LBL_TOTAL TOTAL_USDOLLAR', '<div class="ListViewInfoHover">
<b>{0}</b> {1}<br />
<b>{2}</b><br />
{3}<br />
{4}, {5} {6} {7}<br />
<b>{8}</b><br />
{9}<br />
{10}, {11} {12} {13}<br />
<br />
<b>{14}</b> {15:c}<br />
<b>{16}</b> {17:c}<br />
</div>', 'info_inline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.ListView'          ,11, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Orders.ListView', 2;
	-- 06/20/2007 Paul.  Conversion to Oracle was having a problem with 'else if' and the exists clause. 
	-- 08/02/2010 Paul.  Removed the code as it is solved using ReserveIndex. 
	-- 03/08/2014 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Orders.ListView'          , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '20%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Orders.ListView'
		   and DATA_FIELD       = 'NAME'
		   and ITEMSTYLE_WIDTH  = '25%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Orders.ListView'            ,  8, '5%';
	end -- if;
end -- if;
GO

-- 04/11/2007 Paul.  Add Invoices module. 
-- 03/08/2014 Paul.  Add Preview button. 
-- 05/15/2016 Paul.  Add tags to list view. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.ListView', 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView'          ,  2, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'INVOICE_NUM'               , 'INVOICE_NUM'               , '5%' , 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView'          ,  3, 'Invoices.LBL_LIST_NAME'                   , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView'          ,  4, 'Invoices.LBL_LIST_ACCOUNT_NAME'           , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '15%', 'listViewTdLinkS1', 'BILLING_ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'BILLING_ACCOUNT_ASSIGNED_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.ListView'          ,  5, 'Invoices.LBL_LIST_INVOICE_STAGE'          , 'INVOICE_STAGE'             , 'INVOICE_STAGE'             , '10%', 'invoice_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView'          ,  6, 'Invoices.LBL_LIST_AMOUNT'                 , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView'          ,  7, 'Invoices.LBL_LIST_AMOUNT_DUE'             , 'AMOUNT_DUE_USDOLLAR'       , 'AMOUNT_DUE_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView'          ,  8, 'Invoices.LBL_LIST_DUE_DATE'               , 'DUE_DATE'                  , 'DUE_DATE'                  , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Invoices.ListView'          ,  9, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView'          , 10, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView'          , 11, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHover     'Invoices.ListView'          , 12, null, null, '1%', 'Invoices.LBL_PURCHASE_ORDER_NUM PURCHASE_ORDER_NUM Invoices.LBL_BILLING_ADDRESS BILLING_ADDRESS_STREET BILLING_ADDRESS_CITY BILLING_ADDRESS_STATE BILLING_ADDRESS_POSTALCODE BILLING_ADDRESS_COUNTRY Invoices.LBL_SHIPPING_ADDRESS SHIPPING_ADDRESS_STREET SHIPPING_ADDRESS_CITY SHIPPING_ADDRESS_STATE SHIPPING_ADDRESS_POSTALCODE SHIPPING_ADDRESS_COUNTRY Invoices.LBL_SUBTOTAL SUBTOTAL_USDOLLAR Invoices.LBL_TOTAL TOTAL_USDOLLAR', '<div class="ListViewInfoHover">
<b>{0}</b> {1}<br />
<b>{2}</b><br />
{3}<br />
{4}, {5} {6} {7}<br />
<b>{8}</b><br />
{9}<br />
{10}, {11} {12} {13}<br />
<br />
<b>{14}</b> {15:c}<br />
<b>{16}</b> {17:c}<br />
</div>', 'info_inline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.ListView'        ,12, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Invoices.ListView', 2;
	-- 03/08/2014 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Invoices.ListView'        , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '5%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Invoices.ListView'
		   and DATA_FIELD       = 'INVOICE_NUM'
		   and ITEMSTYLE_WIDTH  = '10%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Invoices.ListView'          ,  9, '5%';
	end -- if;
end -- if;
GO

-- 01/01/2008 Paul.  To follow the conventions, the accounts assigned field should be ACCOUNT_ASSIGNED_USER_ID. 
-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.ListView', 'Payments', 'vwPAYMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.ListView'          , 2, 'Payments.LBL_LIST_PAYMENT_NUM'            , 'PAYMENT_NUM'               , 'PAYMENT_NUM'               , '10%', 'listViewTdLinkS1', 'ID'        , '~/Payments/view.aspx?id={0}' , null, 'Payments', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.ListView'          , 3, 'Payments.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '15%', 'listViewTdLinkS1', 'ACCOUNT_ID', '~/Accounts/view.aspx?id={0}' , null, 'Accounts', 'ACCOUNT_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Payments.ListView'          , 4, 'Payments.LBL_LIST_PAYMENT_TYPE'           , 'PAYMENT_TYPE'              , 'PAYMENT_TYPE'              , '10%', 'payment_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView'          , 5, 'Payments.LBL_LIST_AMOUNT'                 , 'AMOUNT_USDOLLAR'           , 'AMOUNT_USDOLLAR'           , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView'          , 6, 'Payments.LBL_LIST_PAYMENT_DATE'           , 'PAYMENT_DATE'              , 'PAYMENT_DATE'              , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.ListView'          , 7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.ListView'          , 8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '5%';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Payments.ListView', 2;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView' and DATA_FIELD = 'ACCOUNT_NAME' and URL_MODULE = 'Accounts' and URL_ASSIGNED_FIELD = 'ACCOUNT_ASSIGNED_ID' and DELETED = 0) begin -- then
		print 'To follow the conventions, the accounts assigned field should be ACCOUNT_ASSIGNED_USER_ID.';
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = 'ACCOUNT_ASSIGNED_USER_ID'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Payments.ListView'
		   and DATA_FIELD         = 'ACCOUNT_NAME'
		   and URL_MODULE         = 'Accounts'
		   and URL_ASSIGNED_FIELD = 'ACCOUNT_ASSIGNED_ID'
		   and DELETED            = 0 ;
	end -- if;
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	/*
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView' and DATA_FIELD = 'PAYMENT_TYPE' and LIST_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
		update GRIDVIEWS_COLUMNS
		   set LIST_NAME         = 'PaymentTypes'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where GRID_NAME         = 'Payments.ListView'
		   and DATA_FIELD        = 'PAYMENT_TYPE'
		   and LIST_NAME         = 'payment_type_dom'
		   and DELETED           = 0;
	end -- if;
	*/
end -- if;
GO

-- 07/15/2007 Paul.  Add forums/threaded discussions.
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Forums.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Forums.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Forums.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Forums.ListView', 'Forums', 'vwFORUMS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Forums.ListView'            , 2, 'Forums.LBL_LIST_TITLE'                    , 'TITLE'                      , 'TITLE'                      , '30%', 'listViewTdLinkS1', 'ID'            , 'view.aspx?id={0}'           , null, 'Forums', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Forums.ListView'            , 3, 'Forums.LBL_LIST_LAST_THREAD_TITLE'        , 'LAST_THREAD_TITLE'          , 'LAST_THREAD_TITLE'          , '25%', 'listViewTdLinkS1', 'LAST_THREAD_ID', '~/Threads/view.aspx?id={0}' , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Forums.ListView'            , 4, 'Forums.LBL_LIST_LAST_THREAD_CREATED_BY'   , 'LAST_THREAD_CREATED_BY_NAME', 'LAST_THREAD_CREATED_BY_NAME', '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Forums.ListView'            , 5, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'              , 'DATE_MODIFIED'              , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Forums.ListView'            , 6, 'Forums.LBL_LIST_THREADCOUNT'              , 'THREADCOUNT'                , 'THREADCOUNT'                , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Forums.ListView'            , 7, 'Forums.LBL_LIST_THREADANDPOSTCOUNT'       , 'THREADANDPOSTCOUNT'         , 'THREADANDPOSTCOUNT'         , '10%';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Forums.ListView', 2;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Forums.ListView' and HEADER_TEXT = 'Forums.LBL_LIST_TITLE' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/04/2008 Paul.  Forums have a title, not a name.
		print 'Forums have a title, not a name.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'TITLE'
		     , SORT_EXPRESSION    = 'TITLE'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Forums.ListView'
		   and HEADER_TEXT        = 'Forums.LBL_LIST_TITLE'
		   and DATA_FIELD         = 'NAME'
		   and URL_FIELD          = 'ID'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.ListView';
-- 12/29/2009 Paul.  Use global term LBL_LIST_CREATED_BY. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Threads.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Threads.ListView', 'Threads', 'vwTHREADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Threads.ListView'           , 2, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'                  , null, '25%', 'listViewTdLinkS1', 'ID'          , '~/Threads/view.aspx?id={0}'   , null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.ListView'           , 3, '.LBL_LIST_CREATED_BY'                     , 'CREATED_BY_NAME'        , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Threads.ListView'           , 4, 'Threads.LBL_LIST_LAST_POST_TITLE'         , 'LAST_POST_TITLE'        , null, '20%', 'listViewTdLinkS1', 'LAST_POST_ID', '~/Posts/view.aspx?id={0}'     , null, 'Posts'  , null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.ListView'           , 5, 'Threads.LBL_LIST_LAST_POST_CREATED_BY'    , 'LAST_POST_CREATED_BY_NAME', null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Threads.ListView'           , 6, '.LBL_LIST_DATE_MODIFIED'                  , 'LAST_POST_DATE_MODIFIED', null, '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.ListView'           , 7, 'Threads.LBL_LIST_POSTCOUNT'               , 'POSTCOUNT'              , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.ListView'           , 8, 'Threads.LBL_LIST_VIEW_COUNT'              , 'VIEW_COUNT'             , null, '10%';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Threads.ListView', 2;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.ListView' and HEADER_TEXT = 'Threads.LBL_LIST_TITLE' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/04/2008 Paul.  Threads have a title, not a name.
		print 'Threads have a title, not a name.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'TITLE'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Threads.ListView'
		   and HEADER_TEXT        = 'Threads.LBL_LIST_TITLE'
		   and DATA_FIELD         = 'NAME'
		   and URL_FIELD          = 'ID'
		   and DELETED            = 0;
	end -- if;
	-- 05/09/2008 Paul.  Threads.ListView: Correct URL_ASSIGNED_FIELD.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.ListView' and URL_ASSIGNED_FIELD = 'LAST_POST_ASSIGNED_USER_ID' and DELETED = 0) begin -- then
		print 'Threads.ListView: Correct URL_ASSIGNED_FIELD.';
		update GRIDVIEWS_COLUMNS
		   set URL_ASSIGNED_FIELD = null
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Threads.ListView'
		   and URL_ASSIGNED_FIELD = 'LAST_POST_ASSIGNED_USER_ID'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.ListView' and HEADER_TEXT = 'Threads.LBL_LIST_CREATED_BY' and DELETED = 0) begin -- then
		print 'Threads.ListView: Use global term LBL_LIST_CREATED_BY.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT        = '.LBL_LIST_CREATED_BY'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Threads.ListView'
		   and HEADER_TEXT        = 'Threads.LBL_LIST_CREATED_BY'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Posts.ListView';
-- 12/29/2009 Paul.  Use global term LBL_LIST_CREATED_BY. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Posts.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Posts.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Posts.ListView', 'Posts', 'vwTHREADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Posts.ListView'             , 2, 'Posts.LBL_LIST_TITLE'                     , 'TITLE'                  , null, '60%', 'listViewTdLinkS1', 'ID'          , '~/Posts/view.aspx?id={0}'   , null, 'Posts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.ListView'             , 3, '.LBL_LIST_CREATED_BY'                     , 'CREATED_BY_NAME'        , null, '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Posts.ListView'             , 4, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'          , null, '15%', 'DateTime';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'Posts.ListView', 2;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Posts.ListView' and HEADER_TEXT = 'Posts.LBL_LIST_TITLE' and DATA_FIELD = 'NAME' and URL_FIELD = 'ID' and DELETED = 0) begin -- then
		-- 01/04/2008 Paul.  Posts have a title, not a name.
		print 'Posts have a title, not a name.';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD         = 'TITLE'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Posts.ListView'
		   and HEADER_TEXT        = 'Posts.LBL_LIST_TITLE'
		   and DATA_FIELD         = 'NAME'
		   and URL_FIELD          = 'ID'
		   and DELETED            = 0;
	end -- if;
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Posts.ListView' and HEADER_TEXT = 'Posts.LBL_LIST_CREATED_BY' and DELETED = 0) begin -- then
		print 'Posts.ListView: Use global term LBL_LIST_CREATED_BY.';
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT        = '.LBL_LIST_CREATED_BY'
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Posts.ListView'
		   and HEADER_TEXT        = 'Posts.LBL_LIST_CREATED_BY'
		   and DELETED            = 0;
	end -- if;
end -- if;
GO

-- 10/18/2009 Paul.  Add Knowledge Base module. 
-- 03/08/2014 Paul.  Add Preview button. 
-- 05/15/2016 Paul.  Add tags to list view. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS KBDocuments.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'KBDocuments.ListView'       , 'KBDocuments', 'vwKBDOCUMENTS_List'     ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBDocuments.ListView'       ,  2, 'KBDocuments.LBL_LIST_NAME'                , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID', '~/KBDocuments/view.aspx?id={0}', null, 'KBDocuments', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.ListView'       ,  3, 'KBDocuments.LBL_LIST_VIEW_FREQUENCY'      , 'VIEW_FREQUENCY'       , 'VIEW_FREQUENCY'       , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.ListView'       ,  4, 'KBDocuments.LBL_LIST_KBDOC_APPROVER_NAME' , 'KBDOC_APPROVER_NAME'  , 'KBDOC_APPROVER_NAME'  , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'KBDocuments.ListView'       ,  5, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'KBDocuments.ListView'       ,  6, '.LBL_LIST_DATE_ENTERED'                   , 'DATE_ENTERED'         , 'DATE_ENTERED'         , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.ListView'       ,  7, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.ListView'       ,  8, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'KBDocuments.ListView'     ,  9, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'KBDocuments.ListView', 2;
	-- 03/08/2014 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.ListView' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'KBDocuments.ListView'     , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.ListView' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '25%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'KBDocuments.ListView'
		   and DATA_FIELD       = 'NAME'
		   and ITEMSTYLE_WIDTH  = '35%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'KBDocuments.ListView'       ,  5, '10%';
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBTags.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBTags.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS KBTags.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'KBTags.ListView'            , 'KBTags', 'vwKBTAGS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBTags.ListView'            , 2, 'KBTags.LBL_LIST_TAG_NAME'                 , 'TAG_NAME'             , 'TAG_NAME'             , '30%', 'listViewTdLinkS1', 'ID'           , '~/KBDocuments/KBTags/view.aspx?id={0}', null, 'KBTags', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBTags.ListView'            , 3, 'KBTags.LBL_LIST_FULL_TAG_NAME'            , 'FULL_TAG_NAME'        , 'FULL_TAG_NAME'        , '30%', 'listViewTdLinkS1', 'ID'           , '~/KBDocuments/KBTags/view.aspx?id={0}', null, 'KBTags', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBTags.ListView'            , 4, 'KBTags.LBL_LIST_PARENT_TAG_NAME'          , 'PARENT_FULL_TAG_NAME' , 'PARENT_FULL_TAG_NAME' , '35%', 'listViewTdLinkS1', 'PARENT_TAG_ID', '~/KBDocuments/KBTags/view.aspx?id={0}', null, 'KBTags', null;
end else begin
	exec dbo.spGRIDVIEWS_COLUMNS_ReserveIndex null, 'KBTags.ListView', 2;
end -- if;
GO

-- 01/20/2010 Paul.  Add ability to search the new Audit Events table. 
-- 03/28/2019 Paul.  Move AuditEvents.ListView to default file for Community edition. 


-- 06/23/2010 Paul.  Most of the Report fields are manual, but Assigned User and Team are best automatic. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Reports.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Reports.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Reports.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Reports.ListView', 'Reports', 'vwREPORTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Reports.ListView'           , 5, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'        , 'DATE_MODIFIED'   , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Reports.ListView'           , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME', '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Reports.ListView'           , 7, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'            , 'TEAM_NAME'       , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Reports.ListView', 5, null, null, null, null, 0;
end -- if;
GO

-- 05/10/2018 Paul.  Add date, assigned and team to ReportDesigner. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ReportDesigner.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ReportDesigner.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'ReportDesigner.ListView', 'ReportDesigner', 'vwREPORTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ReportDesigner.ListView'    , 5, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'        , 'DATE_MODIFIED'   , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ReportDesigner.ListView'    , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME', '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ReportDesigner.ListView'    , 7, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'            , 'TEAM_NAME'       , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'ReportDesigner.ListView', 5, null, null, null, null, 0;
end -- if;
GO

-- 07/20/2010 Paul.  Regions. 
-- 09/16/2010 Paul.  Move Regions to Professional file. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Regions.ListView'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Regions.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Regions.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Regions.ListView', 'Regions', 'vwREGIONS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Regions.ListView'           , 1, 'Regions.LBL_NAME'                          , 'NAME'            , 'NAME'            , '80%', 'listViewTdLinkS1', 'ID', '~/Administration/Regions/view.aspx?id={0}', null, 'Regions', null;
end -- if;
GO

-- 09/16/2010 Paul.  Add support for multiple Payment Gateways.
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentGateway.ListView'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentGateway.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS PaymentGateway.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'PaymentGateway.ListView'    , 'PaymentGateway', 'vwPAYMENT_GATEWAYS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PaymentGateway.ListView'    , 1, 'PaymentGateway.LBL_LIST_NAME'             , 'NAME'            , 'NAME'            , '60%', 'listViewTdLinkS1', 'ID', '~/Administration/PaymentGateway/view.aspx?id={0}', null, 'PaymentGateway', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PaymentGateway.ListView'    , 2, 'PaymentGateway.LBL_LIST_GATEWAY'          , 'GATEWAY'         , 'GATEWAY'         , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PaymentGateway.ListView'    , 3, 'PaymentGateway.LBL_LIST_TEST_MODE'        , 'TEST_MODE'       , 'TEST_MODE'       , '10%';
end -- if;
GO

-- 09/26/2010 Paul.  Allow full editing. 
-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCategories.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCategories.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProductCategories.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductCategories.ListView', 'ProductCategories', 'vwPRODUCT_CATEGORIES', 'LIST_ORDER', 'asc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductCategories.ListView', 1, 'ProductCategories.LBL_LIST_NAME'         , 'NAME'               , 'NAME'                , '35%', 'listViewTdLinkS1', 'ID'       , '~/Administration/ProductCategories/view.aspx?id={0}', null, 'ProductCategories', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductCategories.ListView', 2, 'ProductCategories.LBL_LIST_PARENT_NAME'  , 'PARENT_NAME'        , 'PARENT_NAME'         , '20%', 'listViewTdLinkS1', 'PARENT_ID', '~/Administration/ProductCategories/view.aspx?id={0}', null, 'ProductCategories', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCategories.ListView', 3, 'ProductCategories.LBL_LIST_DESCRIPTION'  , 'DESCRIPTION'        , 'DESCRIPTION'         , '40%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCategories.ListView', 4, 'ProductCategories.LBL_LIST_ORDER'        , 'LIST_ORDER'         , 'LIST_ORDER'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'ProductCategories.ListView',  'LIST_ORDER', '{0:N0}';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCategories.ListView' and COLUMN_INDEX = 0 and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX       = COLUMN_INDEX + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'ProductCategories.ListView'
		   and DELETED            = 0;
	end -- if;
	-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCategories.ListView' and DATA_FIELD = 'LIST_ORDER' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'ProductCategories.ListView',  'LIST_ORDER', '{0:N0}';
	end -- if;
	-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'ProductCategories.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'ProductCategories.ListView', 'LIST_ORDER', 'asc';
	end -- if;
end -- if;
GO

-- 09/26/2010 Paul.  Allow full editing. 
-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTypes.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTypes.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProductTypes.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTypes.ListView', 'ProductTypes', 'vwPRODUCT_TYPES', 'LIST_ORDER', 'asc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTypes.ListView', 1, 'ProductTypes.LBL_LIST_NAME'         , 'NAME'               , 'NAME'                , '40%', 'listViewTdLinkS1', 'ID', '~/Administration/ProductTypes/view.aspx?id={0}', null, 'ProductTypes', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTypes.ListView', 2, 'ProductTypes.LBL_LIST_DESCRIPTION'  , 'DESCRIPTION'        , 'DESCRIPTION'         , '45%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTypes.ListView', 3, 'ProductTypes.LBL_LIST_ORDER'        , 'LIST_ORDER'         , 'LIST_ORDER'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'ProductTypes.ListView',  'LIST_ORDER', '{0:N0}';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTypes.ListView' and COLUMN_INDEX = 0 and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX       = COLUMN_INDEX + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'ProductTypes.ListView'
		   and DELETED            = 0;
	end -- if;
	-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTypes.ListView' and DATA_FIELD = 'LIST_ORDER' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'ProductTypes.ListView',  'LIST_ORDER', '{0:N0}';
	end -- if;
	-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'ProductTypes.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'ProductTypes.ListView', 'LIST_ORDER', 'asc';
	end -- if;
end -- if;
GO

-- 10/29/2011 Paul.  Add charts. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Charts.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Charts.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Charts.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Charts.ListView', 'Charts', 'vwCHARTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Charts.ListView'            , 5, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'        , 'DATE_MODIFIED'   , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Charts.ListView'            , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME', '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Charts.ListView'            , 7, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'            , 'TEAM_NAME'       , '5%';
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for TaxRates. 
-- 02/24/2015 Paul.  Add state for lookup. 
-- 04/07/2016 Paul.  Tax rates per team. 
-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'TaxRates.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TaxRates.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS TaxRates.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'TaxRates.ListView', 'TaxRates', 'vwTAX_RATES_List', 'LIST_ORDER', 'asc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TaxRates.ListView'    , 1, 'TaxRates.LBL_LIST_NAME'                 , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID', '~/Administration/TaxRates/view.aspx?id={0}', null, 'TaxRates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView'    , 2, 'TaxRates.LBL_LIST_VALUE'                , 'VALUE'                , 'VALUE'                , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView'    , 3, 'TaxRates.LBL_LIST_QUICKBOOKS_TAX_VENDOR', 'QUICKBOOKS_TAX_VENDOR', 'QUICKBOOKS_TAX_VENDOR', '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'TaxRates.ListView'    , 4, 'TaxRates.LBL_LIST_STATUS'               , 'STATUS'               , 'STATUS'               , '15%', 'tax_rate_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView'    , 5, 'TaxRates.LBL_LIST_ORDER'                , 'LIST_ORDER'           , 'LIST_ORDER'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView'    , 6, 'TaxRates.LBL_LIST_ADDRESS_STATE'        , 'ADDRESS_STATE'        , 'ADDRESS_STATE'        , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView'    , 7, 'Teams.LBL_LIST_TEAM'                    , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'TaxRates.ListView',  'LIST_ORDER', '{0:N0}';
end else begin
	-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TaxRates.ListView' and DATA_FIELD = 'LIST_ORDER' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'TaxRates.ListView',  'LIST_ORDER', '{0:N0}';
	end -- if;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView'    , 6, 'TaxRates.LBL_LIST_ADDRESS_STATE'        , 'ADDRESS_STATE'        , 'ADDRESS_STATE'        , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView'    , 7, 'Teams.LBL_LIST_TEAM'                    , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
	-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'TaxRates.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'TaxRates.ListView', 'LIST_ORDER', 'asc';
	end -- if;
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for Manufacturers. 
-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Manufacturers.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Manufacturers.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Manufacturers.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Manufacturers.ListView', 'Manufacturers', 'vwMANUFACTURERS', 'LIST_ORDER', 'asc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Manufacturers.ListView', 1, 'Manufacturers.LBL_LIST_NAME'            , 'NAME'                 , 'NAME'                 , '45%', 'listViewTdLinkS1', 'ID', '~/Administration/Manufacturers/view.aspx?id={0}', null, 'Manufacturers', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Manufacturers.ListView', 2, 'Manufacturers.LBL_LIST_STATUS'          , 'STATUS'               , 'STATUS'               , '25%', 'manufacturer_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Manufacturers.ListView', 3, 'Manufacturers.LBL_LIST_ORDER'           , 'LIST_ORDER'           , 'LIST_ORDER'           , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'Manufacturers.ListView',  'LIST_ORDER', '{0:N0}';
end else begin
	-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Manufacturers.ListView' and DATA_FIELD = 'LIST_ORDER' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'Manufacturers.ListView',  'LIST_ORDER', '{0:N0}';
	end -- if;
	-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'Manufacturers.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'Manufacturers.ListView', 'LIST_ORDER', 'asc';
	end -- if;
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for ContractTypes. 
-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ContractTypes.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ContractTypes.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ContractTypes.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'ContractTypes.ListView', 'ContractTypes', 'vwCONTRACT_TYPES', 'LIST_ORDER', 'asc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ContractTypes.ListView', 1, 'ContractTypes.LBL_LIST_NAME'            , 'NAME'                 , 'NAME'                 , '70%', 'listViewTdLinkS1', 'ID', '~/Administration/ContractTypes/view.aspx?id={0}', null, 'ContractTypes', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ContractTypes.ListView', 2, 'ContractTypes.LBL_LIST_ORDER'           , 'LIST_ORDER'           , 'LIST_ORDER'           , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'ContractTypes.ListView',  'LIST_ORDER', '{0:N0}';
end else begin
	-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ContractTypes.ListView' and DATA_FIELD = 'LIST_ORDER' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'ContractTypes.ListView',  'LIST_ORDER', '{0:N0}';
	end -- if;
	-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'ContractTypes.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'ContractTypes.ListView', 'LIST_ORDER', 'asc';
	end -- if;
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for Shippers. 
-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Shippers.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Shippers.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Shippers.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Shippers.ListView', 'Shippers', 'vwSHIPPERS', 'LIST_ORDER', 'asc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Shippers.ListView'     , 1, 'Shippers.LBL_LIST_NAME'                 , 'NAME'                 , 'NAME'                 , '45%', 'listViewTdLinkS1', 'ID', '~/Administration/Shippers/view.aspx?id={0}', null, 'Shippers', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Shippers.ListView'     , 2, 'Shippers.LBL_LIST_STATUS'               , 'STATUS'               , 'STATUS'               , '25%', 'shipper_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Shippers.ListView'     , 3, 'Shippers.LBL_LIST_ORDER'                , 'LIST_ORDER'           , 'LIST_ORDER'           , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'Shippers.ListView',  'LIST_ORDER', '{0:N0}';
end else begin
	-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Shippers.ListView' and DATA_FIELD = 'LIST_ORDER' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'Shippers.ListView',  'LIST_ORDER', '{0:N0}';
	end -- if;
	-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'Shippers.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'Shippers.ListView', 'LIST_ORDER', 'asc';
	end -- if;
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for Discounts. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Discounts.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Discounts.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Discounts.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Discounts.ListView', 'Discounts', 'vwDISCOUNTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Discounts.ListView'    , 1, 'Discounts.LBL_LIST_NAME'                , 'NAME'                 , 'NAME'                 , '45%', 'listViewTdLinkS1', 'ID', '~/Administration/Discounts/view.aspx?id={0}', null, 'Discounts', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Discounts.ListView'    , 2, 'Discounts.LBL_LIST_PRICING_FORMULA'     , 'PRICING_FORMULA'      , 'PRICING_FORMULA'      , '25%', 'pricing_formula_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Discounts.ListView'    , 3, 'Discounts.LBL_LIST_PRICING_FACTOR'      , 'PRICING_FACTOR'       , 'PRICING_FACTOR'       , '25%';
end -- if;
GO

-- 05/22/2013 Paul.  Add Surveys module. 
-- 03/08/2014 Paul.  Add Preview button. 
-- 05/15/2016 Paul.  Add tags to list view. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Surveys.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Surveys.ListView', 'Surveys', 'vwSURVEYS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Surveys.ListView'      ,  2, 'Surveys.LBL_LIST_NAME'                  , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID', '~/Surveys/view.aspx?id={0}', null, 'Surveys', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView'      ,  3, 'Surveys.LBL_LIST_RESPONSES'             , 'RESPONSES'            , 'RESPONSES'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView'      ,  4, 'Surveys.LBL_LIST_SURVEY_THEME_NAME'     , 'SURVEY_THEME_NAME'    , 'SURVEY_THEME_NAME'    , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Surveys.ListView'      ,  5, 'Surveys.LBL_LIST_STATUS'                , 'STATUS'               , 'STATUS'               , '10%', 'survey_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Surveys.ListView'      ,  6, 'Surveys.LBL_LIST_SURVEY_STYLE'          , 'SURVEY_STYLE'         , 'SURVEY_STYLE'         , '10%', 'survey_style_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Surveys.ListView'      ,  7, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView'      ,  8, '.LBL_LIST_ASSIGNED_USER'                , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView'      ,  9, 'Teams.LBL_LIST_TEAM'                    , 'TEAM_NAME'            , 'TEAM_NAME'            , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Surveys.ListView'    , 10, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.ListView' and DATA_FIELD = 'RESPONSES' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX       = COLUMN_INDEX + 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where GRID_NAME          = 'Surveys.ListView'
		   and COLUMN_INDEX       > 2
		   and DELETED            = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView'      , 3, 'Surveys.LBL_LIST_RESPONSES'             , 'RESPONSES'            , 'RESPONSES'            , '10%';
	end -- if;
	-- 03/08/2014 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.ListView' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'Surveys.ListView'         , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
	-- 05/15/2016 Paul.  Add tags to list view. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.ListView' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH  = '5%'
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = null
		 where GRID_NAME        = 'Surveys.ListView'
		   and DATA_FIELD       in ('RESPONSES', 'SURVEY_THEME_NAME')
		   and ITEMSTYLE_WIDTH  = '10%'
		   and DELETED          = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsTagSelect 'Surveys.ListView'      ,  7, '10%';
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyThemes.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyThemes.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyThemes.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyThemes.ListView', 'SurveyThemes', 'vwSURVEY_THEMES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyThemes.ListView' , 2, 'SurveyThemes.LBL_LIST_NAME'             , 'NAME'                 , 'NAME'                 , '90%', 'listViewTdLinkS1', 'ID', '~/Administration/SurveyThemes/view.aspx?id={0}', null, 'SurveyThemes', null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyPages.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyPages.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyPages.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyPages.ListView', 'SurveyPages', 'vwSURVEYS_SURVEY_PAGES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyPages.ListView'  , 2, 'SurveyPages.LBL_LIST_PAGE_NUMBER'       , 'PAGE_NUMBER'          , 'PAGE_NUMBER'          , '15%', 'listViewTdLinkS1', 'ID', '~/SurveyPages/view.aspx?id={0}', null, 'SurveyPages', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyPages.ListView'  , 3, 'SurveyPages.LBL_LIST_NAME'              , 'NAME'                 , 'NAME'                 , '75%', 'listViewTdLinkS1', 'ID', '~/SurveyPages/view.aspx?id={0}', null, 'SurveyPages', null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyQuestions.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyQuestions.ListView', 'SurveyQuestions', 'vwSURVEY_QUESTIONS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.ListView', 2, 'SurveyQuestions.LBL_LIST_DESCRIPTION'      , 'DESCRIPTION'          , 'DESCRIPTION'          , '35%', 'listViewTdLinkS1', 'ID', '~/SurveyQuestions/view.aspx?id={0}', null, 'SurveyQuestions', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.ListView', 3, 'SurveyQuestions.LBL_LIST_NAME'             , 'NAME'                 , 'NAME'                 , '15%', 'listViewTdLinkS1', 'ID', '~/SurveyQuestions/view.aspx?id={0}', null, 'SurveyQuestions', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'SurveyQuestions.ListView', 4, 'SurveyQuestions.LBL_LIST_QUESTION_TYPE'    , 'QUESTION_TYPE'        , 'QUESTION_TYPE'        , '10%', 'survey_question_type';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.ListView', 6, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.ListView', 7, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'            , 'TEAM_NAME'            , '15%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyResults.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyResults.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyResults.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyResults.ListView', 'SurveyResults', 'vwSURVEY_RESULTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyResults.ListView'  ,  2, 'SurveyResults.LBL_LIST_SURVEY_NAME'         , 'SURVEY_NAME'          , 'SURVEY_NAME'          , '10%', 'listViewTdLinkS1', 'SURVEY_ID', '~/Surveys/view.aspx?id={0}', null, 'Surveys', 'SURVEY_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyResults.ListView'  ,  3, 'SurveyResults.LBL_LIST_RESPONDANT'          , 'PARENT_NAME'          , 'PARENT_NAME'          , '10%', 'listViewTdLinkS1', 'PARENT_TYPE PARENT_ID', '~/{0}/view.aspx?id={1}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyResults.ListView'  ,  4, 'SurveyResults.LBL_LIST_SURVEY_QUESTION_NAME', 'SURVEY_QUESTION_NAME' , 'SURVEY_QUESTION_NAME' , '18%', 'listViewTdLinkS1', 'SURVEY_QUESTION_ID', '~/SurveyQuestions/view.aspx?id={0}', null, 'SurveyQuestions', 'QUESTION_ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.ListView'  ,  5, 'SurveyResults.LBL_LIST_IS_COMPLETE'         , 'IS_COMPLETE'          , 'IS_COMPLETE'          , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'SurveyResults.ListView'  ,  6, 'SurveyResults.LBL_LIST_DATE_ENTERED'        , 'DATE_ENTERED'         , 'DATE_ENTERED'         , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.ListView'  ,  7, 'SurveyResults.LBL_LIST_ANSWER_TEXT'         , 'ANSWER_TEXT'          , 'ANSWER_TEXT'          , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.ListView'  ,  8, 'SurveyResults.LBL_LIST_COLUMN_TEXT'         , 'COLUMN_TEXT'          , 'COLUMN_TEXT'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.ListView'  ,  9, 'SurveyResults.LBL_LIST_MENU_TEXT'           , 'MENU_TEXT'            , 'MENU_TEXT'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.ListView'  , 10, 'SurveyResults.LBL_LIST_OTHER_TEXT'          , 'OTHER_TEXT'           , 'OTHER_TEXT'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'SurveyResults.ListView', 6, null, null, null, null, 0;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'OutboundEmail.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'OutboundEmail.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS OutboundEmail.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'OutboundEmail.ListView', 'OutboundEmail', 'vwOUTBOUND_EMAILS_Edit';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'OutboundEmail.ListView', 1, 'OutboundEmail.LBL_LIST_NAME'            , 'NAME'                 , 'NAME'                 , '35%', 'listViewTdLinkS1', 'ID', '~/Administration/OutboundEmail/view.aspx?id={0}', null, 'OutboundEmail', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'OutboundEmail.ListView', 2, 'OutboundEmail.LBL_LIST_MAIL_SMTPSERVER' , 'MAIL_SMTPSERVER'      , 'MAIL_SMTPSERVER'      , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'OutboundEmail.ListView', 3, 'OutboundEmail.LBL_LIST_MAIL_SMTPUSER'   , 'MAIL_SMTPUSER'        , 'MAIL_SMTPUSER'        , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'OutboundEmail.ListView', 4, 'OutboundEmail.LBL_LIST_FROM_NAME'       , 'FROM_NAME'            , 'FROM_NAME'            , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'OutboundEmail.ListView', 5, 'OutboundEmail.LBL_LIST_FROM_ADDR'       , 'FROM_ADDR'            , 'FROM_ADDR'            , '15%';
end -- if;
GO

-- 09/10/2013 Paul.  Add layout for Asterisk. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Asterisk.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Asterisk.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Asterisk.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Asterisk.ListView', 'Asterisk', 'vwCALL_DETAIL_RECORDS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Asterisk.ListView'     ,  1, 'Asterisk.LBL_LIST_UNIQUEID'           , 'UNIQUEID'           , 'UNIQUEID'           , '5%', 'listViewTdLinkS1', 'ID', '~/Administration/Asterisk/view.aspx?id={0}', null, 'Asterisk', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Asterisk.ListView'     ,  2, 'Asterisk.LBL_LIST_CALLERID'           , 'CALLERID'           , 'CALLERID'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Asterisk.ListView'     ,  3, 'Asterisk.LBL_LIST_PARENT_NAME'        , 'PARENT_NAME'        , 'PARENT_NAME'        , '14%', 'listViewTdLinkS1', 'PARENT_TYPE PARENT_ID', '~/{0}/view.aspx?id={1}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Asterisk.ListView'     ,  4, 'Asterisk.LBL_LIST_START_TIME'         , 'START_TIME'         , 'START_TIME'         , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Asterisk.ListView'     ,  5, 'Asterisk.LBL_LIST_END_TIME'           , 'END_TIME'           , 'END_TIME'           , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Asterisk.ListView'     ,  7, 'Asterisk.LBL_LIST_DURATION'           , 'DURATION'           , 'DURATION'           , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Asterisk.ListView'     ,  8, 'Asterisk.LBL_LIST_SOURCE'             , 'SOURCE'             , 'SOURCE'             , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Asterisk.ListView'     ,  9, 'Asterisk.LBL_LIST_DESTINATION'        , 'DESTINATION'        , 'DESTINATION'        , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Asterisk.ListView'     , 10, 'Asterisk.LBL_LIST_DISPOSITION'        , 'DISPOSITION'        , 'DISPOSITION'        , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Asterisk.ListView'     , 11, 'Asterisk.LBL_LIST_AMA_FLAGS'          , 'AMA_FLAGS'          , 'AMA_FLAGS'          , '10%';
end -- if;
GO

-- 09/19/2013 Paul.  Add PayTrace module. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'PayTrace.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PayTrace.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS PayTrace.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly 'PayTrace.ListView', 'PayTrace', 'vwPayTrace_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PayTrace.ListView'     ,  1, 'PayTrace.LBL_LIST_TRANXID'            , 'TRANXID'            , 'TRANXID'            , '15%', 'listViewTdLinkS1', 'TRANXID', '~/Administration/PayTrace/view.aspx?TRANXID={0}', null, 'PayTrace', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'PayTrace.ListView'     ,  2, 'PayTrace.LBL_LIST_TRANXTYPE'          , 'TRANXTYPE'          , 'TRANXTYPE'          , '10%' , 'paytrace_transaction_type';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayTrace.ListView'     ,  3, 'PayTrace.LBL_LIST_STATUS'             , 'STATUSDESCRIPTION'  , 'STATUSDESCRIPTION'  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'PayTrace.ListView'     ,  4, 'PayTrace.LBL_LIST_WHEN'               , 'WHEN'               , 'WHEN'               , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PayTrace.ListView'     ,  5, 'PayTrace.LBL_LIST_BNAME'              , 'BNAME'              , 'BNAME'              , '15%', 'listViewTdLinkS1', 'CUSTID', '~/CreditCards/view.aspx?ID={0}', null, 'CreditCards', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayTrace.ListView'     ,  6, 'PayTrace.LBL_LIST_CC'                 , 'CC'                 , 'CC'                 , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'PayTrace.ListView'     ,  7, 'PayTrace.LBL_LIST_AMOUNT'             , 'AMOUNT'             , 'AMOUNT'             , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'PayTrace.ListView'     ,  8, 'PayTrace.LBL_LIST_TAX'                , 'TAX'                , 'TAX'                , '10%', 'Currency';
end -- if;
GO

-- 10/26/2013 Paul.  Add TwitterTracks module. 
-- 03/08/2014 Paul.  Add Preview button. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'TwitterTracks.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TwitterTracks.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS TwitterTracks.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'TwitterTracks.ListView', 'TwitterTracks', 'vwTWITTER_TRACKS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TwitterTracks.ListView',  2, 'TwitterTracks.LBL_LIST_NAME'               , 'NAME'               , 'NAME'               , '60%', 'listViewTdLinkS1', 'ID', '~/TwitterTracks/view.aspx?id={0}', null, 'TwitterTracks', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'TwitterTracks.ListView',  3, 'TwitterTracks.LBL_LIST_TYPE'               , 'TYPE'               , 'TYPE'               , '5%' , 'twitter_track_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'TwitterTracks.ListView',  4, 'TwitterTracks.LBL_LIST_STATUS'             , 'STATUS'             , 'STATUS'             , '5%' , 'twitter_track_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TwitterTracks.ListView',  5, '.LBL_LIST_ASSIGNED_USER'                   , 'ASSIGNED_TO_NAME'   , 'ASSIGNED_TO_NAME'   , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TwitterTracks.ListView',  6, 'Teams.LBL_LIST_TEAM'                       , 'TEAM_NAME'          , 'TEAM_NAME'          , '10%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TwitterTracks.ListView',  7, 'TwitterTracks.LBL_LOCATION'                , 'LOCATION'           , 'LOCATION'           , '10%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TwitterTracks.ListView',  8, 'TwitterTracks.LBL_LIST_TWITTER_SCREEN_NAME', 'TWITTER_SCREEN_NAME', 'TWITTER_SCREEN_NAME', '10%', 'listViewTdLinkS1', 'TWITTER_SCREEN_NAME', 'http://twitter.com/{0}', 'TwitterUser', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'TwitterTracks.ListView', 7, null, '1%', 'ID', 'Preview', 'preview_inline';
end else begin
	-- 03/08/2014 Paul.  Add Preview button. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TwitterTracks.ListView' and URL_FORMAT = 'Preview' and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_InsImageButton 'TwitterTracks.ListView'   , -1, null, '1%', 'ID', 'Preview', 'preview_inline';
	end -- if;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTypes.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTypes.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS PaymentTypes.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'PaymentTypes.ListView', 'PaymentTypes', 'vwPAYMENT_TYPES_List', 'LIST_ORDER', 'asc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PaymentTypes.ListView', 1, 'PaymentTypes.LBL_LIST_NAME'                 , 'NAME'                 , 'NAME'                 , '45%', 'listViewTdLinkS1', 'ID', '~/Administration/PaymentTypes/view.aspx?id={0}', null, 'PaymentTypes', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'PaymentTypes.ListView', 2, 'PaymentTypes.LBL_LIST_STATUS'               , 'STATUS'               , 'STATUS'               , '25%', 'payment_type_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PaymentTypes.ListView', 3, 'PaymentTypes.LBL_LIST_ORDER'                , 'LIST_ORDER'           , 'LIST_ORDER'           , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'PaymentTypes.ListView',  'LIST_ORDER', '{0:N0}';
end else begin
	-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTypes.ListView' and DATA_FIELD = 'LIST_ORDER' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'PaymentTypes.ListView',  'LIST_ORDER', '{0:N0}';
	end -- if;
	-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'PaymentTypes.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'PaymentTypes.ListView', 'LIST_ORDER', 'asc';
	end -- if;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTerms.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTerms.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS PaymentTerms.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'PaymentTerms.ListView', 'PaymentTerms', 'vwPAYMENT_TERMS_List', 'LIST_ORDER', 'asc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PaymentTerms.ListView', 1, 'PaymentTerms.LBL_LIST_NAME'                 , 'NAME'                 , 'NAME'                 , '45%', 'listViewTdLinkS1', 'ID', '~/Administration/PaymentTerms/view.aspx?id={0}', null, 'PaymentTerms', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'PaymentTerms.ListView', 2, 'PaymentTerms.LBL_LIST_STATUS'               , 'STATUS'               , 'STATUS'               , '25%', 'payment_term_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PaymentTerms.ListView', 3, 'PaymentTerms.LBL_LIST_ORDER'                , 'LIST_ORDER'           , 'LIST_ORDER'           , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'PaymentTerms.ListView',  'LIST_ORDER', '{0:N0}';
end else begin
	-- 02/22/2021 Paul.  Make use of new procedure spGRIDVIEWS_COLUMNS_UpdateFormat.
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTerms.ListView' and DATA_FIELD = 'LIST_ORDER' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateFormat null, 'PaymentTerms.ListView',  'LIST_ORDER', '{0:N0}';
	end -- if;
	-- 02/22/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'PaymentTerms.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'PaymentTerms.ListView', 'LIST_ORDER', 'asc';
	end -- if;
end -- if;
GO

-- 12/16/2015 Paul.  Add Authorize.Net module. 
-- 02/25/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS AuthorizeNet.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly 'AuthorizeNet.ListView', 'AuthorizeNet', 'vwAuthorizeNet_List', 'submitTimeUTC', 'desc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'AuthorizeNet.ListView'     ,  1, 'AuthorizeNet.LBL_LIST_TRANS_ID'           , 'transId'            , 'transId'            , '5%' , 'listViewTdLinkS1', 'transId', '~/Administration/AuthorizeNet/view.aspx?transId={0}', null, 'AuthorizeNet', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'AuthorizeNet.ListView'     ,  2, 'AuthorizeNet.LBL_LIST_SUBMIT_TIME_LOCAL'  , 'submitTimeLocal'    , 'submitTimeLocal'    , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.ListView'     ,  3, 'AuthorizeNet.LBL_LIST_BILLTO_FIRST_NAME'  , 'billTo_firstName'   , 'billTo_firstName'   , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.ListView'     ,  4, 'AuthorizeNet.LBL_LIST_BILLTO_LAST_NAME'   , 'billTo_lastName'    , 'billTo_lastName'    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.ListView'     ,  5, 'AuthorizeNet.LBL_LIST_ACCOUNT_TYPE'       , 'accountType'        , 'accountType'        , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.ListView'     ,  6, 'AuthorizeNet.LBL_LIST_ACCOUNT_NUMBER'     , 'accountNumber'      , 'accountNumber'      , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'AuthorizeNet.ListView'     ,  7, 'AuthorizeNet.LBL_LIST_SETTLE_AMOUNT'      , 'settleAmount'       , 'settleAmount'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.ListView'     ,  8, 'AuthorizeNet.LBL_LIST_TRANSACTION_STATUS' , 'transactionStatus'  , 'transactionStatus'  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'AuthorizeNet.ListView', 7, null, null, 'right', null, null;
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.ListView'     ,  9, 'AuthorizeNet.LBL_LIST_MARKET_TYPE'        , 'marketType'         , 'marketType'         , '10%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.ListView'     , 10, 'AuthorizeNet.LBL_LIST_PRODUCT'            , 'product'            , 'product'            , '10%';
--	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'AuthorizeNet.ListView'     , 11, 'AuthorizeNet.LBL_LIST_SUBMIT_TIME_UTC'    , 'submitTimeUTC'      , 'submitTimeUTC'      , '10%', 'DateTime';
end else begin
	-- 02/25/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'AuthorizeNet.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'AuthorizeNet.ListView', 'submitTimeUTC', 'desc';
	end -- if;
end -- if;
GO

-- 02/25/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.CustomerProfiles.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.CustomerProfiles.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS AuthorizeNet.CustomerProfiles.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly 'AuthorizeNet.CustomerProfiles.ListView', 'AuthorizeNet', 'vwAuthorizeNet_CustomerProfiles', 'email', 'asc';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'AuthorizeNet.CustomerProfiles.ListView'     ,  1, 'AuthorizeNet.LBL_LIST_CUSTOMER_PROFILE_ID' , 'customerProfileId'  , 'customerProfileId'  , '5%' , 'listViewTdLinkS1', 'customerProfileId', '~/Administration/AuthorizeNet/CustomerProfiles/view.aspx?customerProfileId={0}', null, 'AuthorizeNet', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ListView'     ,  2, 'AuthorizeNet.LBL_LIST_MERCHANT_CUSTOMER_ID', 'merchantCustomerId' , 'merchantCustomerId' , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ListView'     ,  3, 'AuthorizeNet.LBL_LIST_EMAIL'               , 'email'              , 'email'              , '40%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ListView'     ,  4, 'AuthorizeNet.LBL_LIST_DESCRIPTION'         , 'description'        , 'description'        , '40%';
end else begin
	-- 02/25/2021 Paul.  The React client needs a way to determine the default sort, besides NAME asc. 
	if exists(select * from GRIDVIEWS where NAME = 'AuthorizeNet.CustomerProfiles.ListView' and SORT_FIELD is null and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_UpdateSort null, 'AuthorizeNet.CustomerProfiles.ListView', 'email', 'asc';
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.CustomerProfiles.ShippingAddresses';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.CustomerProfiles.ShippingAddresses' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS AuthorizeNet.CustomerProfiles.ShippingAddresses';
	exec dbo.spGRIDVIEWS_InsertOnly 'AuthorizeNet.CustomerProfiles.ShippingAddresses', 'AuthorizeNet', 'vwAuthorizeNet_CustomerProfiles_ShippingAddresses';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ShippingAddresses',  0, 'AuthorizeNet.LBL_LIST_CUSTOMER_ADDRESS_ID'        , 'customerAddressId'            , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ShippingAddresses',  1, 'AuthorizeNet.LBL_LIST_FIRST_NAME'                 , 'firstName'                    , null, '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ShippingAddresses',  2, 'AuthorizeNet.LBL_LIST_LAST_NAME'                  , 'lastName'                     , null, '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ShippingAddresses',  3, 'AuthorizeNet.LBL_LIST_ADDRESS'                    , 'address'                      , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ShippingAddresses',  4, 'AuthorizeNet.LBL_LIST_CITY'                       , 'city'                         , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ShippingAddresses',  5, 'AuthorizeNet.LBL_LIST_STATE'                      , 'state'                        , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ShippingAddresses',  6, 'AuthorizeNet.LBL_LIST_ZIP'                        , 'zip'                          , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ShippingAddresses',  7, 'AuthorizeNet.LBL_LIST_PHONE_NUMBER'               , 'phoneNumber'                  , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.ShippingAddresses',  8, 'AuthorizeNet.LBL_LIST_EMAIL'                      , 'email'                        , null, '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.CustomerProfiles.PaymentProfiles';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'AuthorizeNet.CustomerProfiles.PaymentProfiles' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS AuthorizeNet.CustomerProfiles.PaymentProfiles';
	exec dbo.spGRIDVIEWS_InsertOnly 'AuthorizeNet.CustomerProfiles.PaymentProfiles', 'AuthorizeNet', 'vwAuthorizeNet_CustomerProfiles_PaymentProfiles';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.PaymentProfiles'  ,  0, 'AuthorizeNet.LBL_LIST_CUSTOMER_PAYMENT_PROFILE_ID', 'customerPaymentProfileId'     , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.PaymentProfiles'  ,  1, 'AuthorizeNet.LBL_LIST_BILLTO_FIRST_NAME'          , 'billTo_firstName'             , null, '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.PaymentProfiles'  ,  2, 'AuthorizeNet.LBL_LIST_BILLTO_LAST_NAME'           , 'billTo_lastName'              , null, '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.PaymentProfiles'  ,  3, 'AuthorizeNet.LBL_LIST_BILLTO_EMAIL'               , 'billTo_email'                 , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.PaymentProfiles'  ,  4, 'AuthorizeNet.LBL_LIST_CREDITCARD_CARD_TYPE'       , 'creditCard_cardType'          , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.PaymentProfiles'  ,  5, 'AuthorizeNet.LBL_LIST_CREDITCARD_CARD_NUMBER'     , 'creditCard_cardNumber'        , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.PaymentProfiles'  ,  6, 'AuthorizeNet.LBL_LIST_BANKACCOUNT_BANK_NAME'      , 'bankAccount_bankName'         , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.PaymentProfiles'  ,  7, 'AuthorizeNet.LBL_LIST_BANKACCOUNT_ACCOUNT_NUMBER' , 'bankAccount_accountNumber'    , null, '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'AuthorizeNet.CustomerProfiles.PaymentProfiles'  ,  8, 'AuthorizeNet.LBL_LIST_TOKEN_TOKEN_NUMBER'         , 'token_tokenNumber'            , null, '10%';
end -- if;
GO

-- 01/01/2016 Paul.  Move PayPal module to Professional. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'PayPal.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PayPal.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS PayPal.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly 'PayPal.ListView', 'PayPal', 'vwPayPal_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PayPal.ListView',  1, 'PayPal.LBL_LIST_TRANSACTION_ID'             , 'TRANSACTION_ID'             , 'TRANSACTION_ID'    , '15%', 'listViewTdLinkS1', 'TRANSACTION_ID', '~/Administration/PayPalTransactions/view.aspx?TransactionID={0}', null, 'PayPal', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'PayPal.ListView',  2, 'PayPal.LBL_LIST_TRANSACTION_TYPE'           , 'TRANSACTION_TYPE'           , 'TRANSACTION_TYPE'  , '8%' , 'paypal_transaction_type';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'PayPal.ListView',  3, 'PayPal.LBL_LIST_TRANSACTION_STATUS'         , 'TRANSACTION_STATUS'         , 'TRANSACTION_STATUS', '8%' , 'paypal_transaction_status';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'PayPal.ListView',  4, 'PayPal.LBL_LIST_TRANSACTION_DATE'           , 'TRANSACTION_DATE'           , 'TRANSACTION_DATE'  , '15%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayPal.ListView',  5, 'PayPal.LBL_LIST_PAYER'                      , 'PAYER'                      , 'PAYER'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayPal.ListView',  6, 'PayPal.LBL_LIST_PAYER_DISPLAY_NAME'         , 'PAYER_DISPLAY_NAME'         , 'PAYER_DISPLAY_NAME', '14%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayPal.ListView',  7, 'PayPal.LBL_LIST_GROSS_AMOUNT_CURRENCY'      , 'GROSS_AMOUNT_CURRENCY'      , null                , '1%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'PayPal.ListView',  8, 'PayPal.LBL_LIST_GROSS_AMOUNT'               , 'GROSS_AMOUNT'               , 'GROSS_AMOUNT'      , '9%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayPal.ListView',  9, 'PayPal.LBL_LIST_FEE_AMOUNT_CURRENCY'        , 'FEE_AMOUNT_CURRENCY'        , null                , '1%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'PayPal.ListView', 10, 'PayPal.LBL_LIST_FEE_AMOUNT'                 , 'FEE_AMOUNT'                 , 'FEE_AMOUNT'        , '9%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayPal.ListView', 11, 'PayPal.LBL_LIST_NET_AMOUNT_CURRENCY'        , 'NET_AMOUNT_CURRENCY'        , null                , '1%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'PayPal.ListView', 12, 'PayPal.LBL_LIST_NET_AMOUNT'                 , 'NET_AMOUNT'                 , 'NET_AMOUNT'        , '9%', 'Currency';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'PayPal.LineItems';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PayPal.LineItems' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS PayPal.LineItems';
	exec dbo.spGRIDVIEWS_InsertOnly 'PayPal.LineItems', 'PayPal', 'vwPayPal_LineItems';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayPal.LineItems', 0, 'PayPal.LBL_LIST_QUANTITY'             , 'QUANTITY'                  , null, '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayPal.LineItems', 1, 'PayPal.LBL_LIST_NUMBER'               , 'NUMBER'                    , null, '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayPal.LineItems', 2, 'PayPal.LBL_LIST_NAME'                 , 'NAME'                      , null, '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PayPal.LineItems', 3, ''                                     , 'AMOUNT_CURRENCY'           , null, '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'PayPal.LineItems', 4, 'PayPal.LBL_LIST_AMOUNT'               , 'AMOUNT'                    , null, '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'PayPal.LineItems', 5, 'PayPal.LBL_LIST_SALES_TAX'            , 'SALES_TAX'                 , null, '20%', 'Currency';
end -- if;
GO

-- 02/17/2018 Paul.  ModulesArchiveRules module to Professional. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ModulesArchiveRules.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ModulesArchiveRules.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ModulesArchiveRules.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'ModulesArchiveRules.ListView', 'ModulesArchiveRules', 'vwMODULES_ARCHIVE_RULES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ModulesArchiveRules.ListView', 2, 'ModulesArchiveRules.LBL_LIST_NAME'        , 'NAME'                 , 'NAME'            , '60%', 'listViewTdLinkS1', 'ID'         , '~/Administration/ModulesArchiveRules/edit.aspx?id={0}', null, 'ModulesArchiveRules', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ModulesArchiveRules.ListView', 3, 'ModulesArchiveRules.LBL_LIST_STATUS'      , 'STATUS'               , 'STATUS'          , '15%', 'archive_rule_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ModulesArchiveRules.ListView', 4, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'        , 'DATE_MODIFIED'   , '15%';
end -- if;
GO

-- 03/31/2021 Paul.  Add Exchange support to React Client. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Exchange.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Exchange.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Exchange.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Exchange.ListView', 'Exchange', 'vwUSERS_EXCHANGE';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Exchange.ListView', 2, 'Users.LBL_LIST_NAME'                 , 'NAME'                 , 'NAME'            , '23%', 'listViewTdLinkS1', 'ASSIGNED_USER_ID', '~/Administration/Exchange/view.aspx?id={0}', null, 'Exchange', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Exchange.ListView', 3, 'Users.LBL_LIST_USER_NAME'            , 'USER_NAME'            , 'USER_NAME'       , '23%', 'listViewTdLinkS1', 'ASSIGNED_USER_ID', '~/Administration/Exchange/view.aspx?id={0}', null, 'Exchange', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Exchange.ListView', 4, 'Users.LBL_LIST_EMAIL'                , 'EMAIL1'               , 'EMAIL1'          , '23%', 'listViewTdLinkS1', 'ASSIGNED_USER_ID', '~/Administration/Exchange/view.aspx?id={0}', null, 'Exchange', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Exchange.ListView', 5, 'Exchange.LBL_LIST_EXCHANGE_STATUS'   , 'STATUS'               , 'STATUS'          , '5%';
end -- if;
GO

-- 03/31/2021 Paul.  Add Exchange support to React Client. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Exchange.UserFolders';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Exchange.UserFolders' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Exchange.UserFolders';
	exec dbo.spGRIDVIEWS_InsertOnly           'Exchange.UserFolders', 'Exchange', 'vwUSERS_EXCHANGE';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Exchange.UserFolders', 0, 'Exchange.LBL_LIST_WELL_KNOWN_FOLDER', 'WELL_KNOWN_FOLDER'  , null              , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Exchange.UserFolders', 1, 'Exchange.LBL_LIST_MODULE_NAME'      , 'MODULE_NAME'        , null              , '40%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Exchange.UserFolders', 2, 'Exchange.LBL_LIST_PARENT_NAME'      , 'PARENT_NAME'        , null              , '30%';
end -- if;
GO

-- 04/29/2021 Paul.  Create view for MailMerge 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'MailMerge.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'MailMerge.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS MailMerge.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly           'MailMerge.ListView', 'MailMerge', 'vwLEADS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MailMerge.ListView', 0, 'MailMerge.LBL_LIST_MODULE_NAME'       , 'MODULE_NAME'       , null              , '16%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'MailMerge.ListView', 1, 'MailMerge.LBL_LIST_NAME'              , 'NAME'              , null              , '40%';
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

call dbo.spGRIDVIEWS_COLUMNS_Professional()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_Professional')
/

-- #endif IBM_DB2 */


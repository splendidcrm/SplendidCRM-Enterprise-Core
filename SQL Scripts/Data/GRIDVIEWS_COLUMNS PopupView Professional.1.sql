

print 'GRIDVIEWS_COLUMNS PopupView Professional';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.PopupView'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 08/24/2009 Paul.  Change TEAM_NAME to TEAM_SET_NAME. 
-- 08/28/2009 Paul.  Restore TEAM_NAME and expect it to be converted automatically when DynamicTeams is enabled. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.PopupView', 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.PopupView'         , 1, 'Contracts.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID NAME', 'SelectContract(''{0}'', ''{1}'');', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.PopupView'         , 2, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.PopupView'         , 3, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'          , 'STATUS'          , '20%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.PopupView'         , 4, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.PopupView'         , 5, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.PopupView', 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.PopupView'          , 1, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'INVOICE_NUM'               , 'INVOICE_NUM'               , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectInvoice(''{0}'', ''{1}'');', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.PopupView'          , 2, 'Invoices.LBL_LIST_NAME'                   , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID NAME', 'SelectInvoice(''{0}'', ''{1}'');', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.PopupView'          , 3, 'Invoices.LBL_LIST_ACCOUNT_NAME'           , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.PopupView'          , 4, 'Invoices.LBL_LIST_AMOUNT'                 , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.PopupView'          , 5, 'Invoices.LBL_LIST_AMOUNT_DUE'             , 'AMOUNT_DUE_USDOLLAR'       , 'AMOUNT_DUE_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.PopupView'          , 6, 'Invoices.LBL_LIST_DUE_DATE'               , 'DUE_DATE'                  , 'DUE_DATE'                  , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.PopupView'          , 7, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.PopupView'          , 8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.PopupView', 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.PopupView'            , 1, 'Orders.LBL_LIST_ORDER_NUM'                , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectOrder(''{0}'', ''{1}'');', null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.PopupView'            , 2, 'Orders.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '35%', 'listViewTdLinkS1', 'ID NAME', 'SelectOrder(''{0}'', ''{1}'');', null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.PopupView'            , 3, 'Orders.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.PopupView'            , 4, 'Orders.LBL_LIST_DATE_ORDER_DUE'           , 'DATE_ORDER_DUE'            , 'DATE_ORDER_DUE'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.PopupView'            , 5, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.PopupView'            , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.PopupView', 'Payments', 'vwPAYMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.PopupView'          , 1, 'Payments.LBL_LIST_PAYMENT_NUM'            , 'PAYMENT_NUM'               , 'PAYMENT_NUM'               , '10%', 'listViewTdLinkS1', 'ID PAYMENT_NUM', 'SelectPayment(''{0}'', ''{1}'');', null, 'Payments', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PopupView'          , 2, 'Payments.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.PopupView'          , 3, 'Payments.LBL_LIST_AMOUNT'                 , 'AMOUNT_USDOLLAR'           , 'AMOUNT_USDOLLAR'           , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.PopupView'          , 4, 'Payments.LBL_LIST_PAYMENT_DATE'           , 'PAYMENT_DATE'              , 'PAYMENT_DATE'              , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PopupView'          , 5, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PopupView'          , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '15%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.PopupView' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'Products.PopupView', 'Products', 'vwPRODUCTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.PopupView'          , 1, 'Products.LBL_LIST_NAME'                   , 'NAME'                , 'NAME'                , '50%', 'listViewTdLinkS1', 'ID NAME', 'SelectProduct(''{0}'', ''{1}'');', null, 'Products', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.PopupView'          , 2, 'Products.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'        , 'ACCOUNT_NAME'        , '40%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.PopupView'          , 3, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'           , 'TEAM_NAME'           , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCatalog.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCatalog.PopupView' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductCatalog.PopupView', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	-- 07/10/2010 Paul.  Sort the name by special field to allow for catalog options. 
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductCatalog.PopupView'  , 1, 'ProductTemplates.LBL_LIST_NAME'           , 'NAME'                , 'NAME_SORT'           , '25%', 'listViewTdLinkS1', 'ID NAME', 'SelectProductTemplate(''{0}'', ''{1}'');', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCatalog.PopupView'  , 2, 'ProductTemplates.LBL_LIST_TYPE'           , 'TYPE_NAME'           , 'TYPE_NAME'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCatalog.PopupView'  , 3, 'ProductTemplates.LBL_LIST_CATEGORY'       , 'CATEGORY_NAME'       , 'CATEGORY_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCatalog.PopupView'  , 4, 'ProductTemplates.LBL_LIST_MANUFACTURER'   , 'MANUFACTURER_NAME'   , 'MANUFACTURER_NAME'   , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProductCatalog.PopupView'  , 5, 'ProductTemplates.LBL_LIST_STATUS'         , 'STATUS'              , 'STATUS'              , '10%', 'product_template_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCatalog.PopupView'  , 6, 'ProductTemplates.LBL_LIST_QUANTITY'       , 'QUANTITY'            , 'QUANTITY'            , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductCatalog.PopupView'  , 7, 'ProductTemplates.LBL_LIST_COST'           , 'COST_USDOLLAR'       , 'COST_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductCatalog.PopupView'  , 8, 'ProductTemplates.LBL_LIST_LIST_PRICE'     , 'LIST_USDOLLAR'       , 'LIST_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductCatalog.PopupView'  , 9, 'ProductTemplates.LBL_LIST_BOOK_VALUE'     , 'DISCOUNT_USDOLLAR'   , 'DISCOUNT_USDOLLAR'   , '10%', 'Currency';
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCatalog.PopupView' and DATA_FIELD = 'NAME' and SORT_EXPRESSION = 'NAME' and DELETED = 0) begin -- then
		print 'ProductCatalog.PopupView: Sort NAME by a special field.';
		update GRIDVIEWS_COLUMNS
		   set SORT_EXPRESSION   = 'NAME_SORT'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where GRID_NAME         = 'ProductCatalog.PopupView'
		   and DATA_FIELD        = 'NAME'
		   and SORT_EXPRESSION   = 'NAME'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCategories.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCategories.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProductCategories.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductCategories.PopupView', 'ProductCategories', 'vwPRODUCT_CATEGORIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductCategories.PopupView', 1, 'ProductCategories.LBL_LIST_NAME'         , 'NAME'               , 'NAME'                , '40%', 'listViewTdLinkS1', 'ID NAME', 'SelectProductCategory(''{0}'', ''{1}'');', null, 'ProductCategories', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCategories.PopupView', 2, 'ProductCategories.LBL_LIST_DESCRIPTION'  , 'DESCRIPTION'        , 'DESCRIPTION'         , '60%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTypes.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTypes.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProductTypes.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTypes.PopupView', 'ProductTypes', 'vwPRODUCT_TYPES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTypes.PopupView', 1, 'ProductTypes.LBL_LIST_NAME'         , 'NAME'               , 'NAME'                , '40%', 'listViewTdLinkS1', 'ID NAME', 'SelectProductType(''{0}'', ''{1}'');', null, 'ProductTypes', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTypes.PopupView', 2, 'ProductTypes.LBL_LIST_DESCRIPTION'  , 'DESCRIPTION'        , 'DESCRIPTION'         , '60%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.PopupView' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.PopupView', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTemplates.PopupView'  , 1, 'ProductTemplates.LBL_LIST_NAME'           , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID NAME', 'SelectProductTemplate(''{0}'', ''{1}'');', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.PopupView'  , 2, 'ProductTemplates.LBL_LIST_MANUFACTURER'   , 'MANUFACTURER_NAME'   , 'MANUFACTURER_NAME'   , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.PopupView'  , 3, 'ProductTemplates.LBL_LIST_TYPE'           , 'TYPE_NAME'           , 'TYPE_NAME'           , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.PopupView'  , 4, 'ProductTemplates.LBL_LIST_CATEGORY'       , 'CATEGORY_NAME'       , 'CATEGORY_NAME'       , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProductTemplates.PopupView'  , 5, 'ProductTemplates.LBL_LIST_STATUS'         , 'STATUS'              , 'STATUS'              , '15%', 'product_template_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.PopupView'  , 6, 'ProductTemplates.LBL_LIST_QUANTITY'       , 'QUANTITY'            , 'QUANTITY'            , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Project.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Project.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Project.PopupView', 'Project', 'vwPROJECTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Project.PopupView'           , 1, 'Project.LBL_LIST_NAME'                    , 'NAME'            , 'NAME'            , '60%', 'listViewTdLinkS1', 'ID NAME', 'SelectProject(''{0}'', ''{1}'');', null, 'Project', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Project.PopupView'           , 2, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Project.PopupView'           , 3, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '20%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.PopupView', 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.PopupView'            , 0, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectQuote(''{0}'', ''{1}'');', null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.PopupView'            , 1, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '25%', 'listViewTdLinkS1', 'ID NAME', 'SelectQuote(''{0}'', ''{1}'');', null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.PopupView'            , 2, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.PopupView'            , 3, 'Quotes.LBL_LIST_QUOTE_STAGE'              , 'QUOTE_STAGE'               , 'QUOTE_STAGE'               , '15%', 'quote_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.PopupView'            , 4, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.PopupView'            , 5, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.PopupView'            , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Teams.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Teams.PopupView', 'Teams', 'vwTEAMS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Teams.PopupView'             , 1, 'Teams.LBL_LIST_NAME'                      , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'ID NAME', 'SelectTeam(''{0}'', ''{1}'');', null, 'Teams', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.PopupView'             , 2, 'Teams.LBL_LIST_DESCRIPTION'               , 'DESCRIPTION'     , 'DESCRIPTION'     , '60%';
end -- if;
GO

-- 04/12/2016 Paul.  Add ZipCode search. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.PopupZipCodeView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.PopupZipCodeView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Teams.PopupZipCodeView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Teams.PopupZipCodeView', 'Teams', 'vwTEAMS_ZIPCODES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Teams.PopupZipCodeView'      , 1, 'Teams.LBL_LIST_NAME'                      , 'NAME'            , 'NAME'            , '20%', 'listViewTdLinkS1', 'ID NAME', 'SelectTeam(''{0}'', ''{1}'');', null, 'Teams', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.PopupZipCodeView'      , 2, 'ZipCodes.LBL_LIST_ZIPCODE'                , 'ZIPCODE'         , 'ZIPCODE'         , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.PopupZipCodeView'      , 3, 'ZipCodes.LBL_LIST_CITY'                   , 'CITY'            , 'CITY'            , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.PopupZipCodeView'      , 4, 'ZipCodes.LBL_LIST_STATE'                  , 'STATE'           , 'STATE'           , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.PopupZipCodeView'      , 5, 'ZipCodes.LBL_LIST_COUNTRY'                , 'COUNTRY'         , 'COUNTRY'         , '20%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Threads.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Threads.PopupView', 'Project', 'vwTHREADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Threads.PopupView'           , 0, 'Threads.LBL_LIST_TITLE'                   , 'TITLE'           , 'TITLE'           , '75%', 'listViewTdLinkS1', 'ID TITLE', 'SelectThread(''{0}'', ''{1}'');', null, 'Threads', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Threads.PopupView'           , 1, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'   , 'DATE_MODIFIED'   , '25%', 'Date';
end -- if;
GO


if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'CreditCards.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS CreditCards.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'CreditCards.PopupView'     , 'CreditCards', 'vwCREDIT_CARDS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'CreditCards.PopupView'       , 1, 'CreditCards.LBL_LIST_NAME'                , 'NAME'               , null , '50%', 'listViewTdLinkS1', 'ID NAME', 'SelectCreditCard(''{0}'', ''{1}'');', null, 'CreditCards', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'CreditCards.PopupView'       , 2, 'CreditCards.LBL_LIST_CARD_NUMBER'         , 'CARD_NUMBER_DISPLAY', null , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'CreditCards.PopupView'       , 3, 'CreditCards.LBL_LIST_EXPIRATION_DATE'     , 'EXPIRATION_DATE'    , null , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'CreditCards.PopupView'       , 4, 'CreditCards.LBL_LIST_IS_PRIMARY'          , 'IS_PRIMARY'         , null , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBTags.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBTags.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS KBTags.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'KBTags.PopupView'           , 'KBTags', 'vwKBTAGS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBTags.PopupView'           , 1, 'KBTags.LBL_LIST_FULL_TAG_NAME'            , 'FULL_TAG_NAME'        , 'FULL_TAG_NAME'       , '50%', 'listViewTdLinkS1', 'ID TAG_NAME', 'SelectKBTag(''{0}'', ''{1}'');', null, 'KBTags', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBTags.PopupView'           , 2, 'KBTags.LBL_LIST_PARENT_TAG_NAME'          , 'PARENT_FULL_TAG_NAME' , 'PARENT_FULL_TAG_NAME', '45%';
end -- if;
GO

-- 07/12/2010 Paul.  Create Reports popup. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Reports.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Reports.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Reports.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Reports.PopupView', 'Reports', 'vwREPORTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Reports.PopupView'          , 1, 'Reports.LBL_LIST_REPORT_NAME'             , 'NAME'                 , null              , '50%', 'listViewTdLinkS1', 'ID NAME', 'SelectReport(''{0}'', ''{1}'');', null, 'Reports', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Reports.PopupView'          , 2, 'Reports.LBL_LIST_MODULE_NAME'             , 'MODULE_NAME'          , 'MODULE_NAME'     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Reports.PopupView'          , 3, 'Reports.LBL_LIST_REPORT_TYPE'             , 'REPORT_TYPE'          , 'REPORT_TYPE'     , '10%', 'dom_report_types';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Reports.PopupView'          , 4, '.LBL_LIST_DATE_MODIFIED'                  , 'DATE_MODIFIED'        , 'DATE_MODIFIED'   , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Reports.PopupView'          , 5, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME', '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Reports.PopupView'          , 6, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'            , 'TEAM_NAME'       , '15%';
end -- if;
GO

-- 08/15/2010 Paul.  Add discounts. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Discounts.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Discounts.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Discounts.PopupView', 'Discounts', 'vwDISCOUNTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Discounts.PopupView'         , 1, 'Discounts.LBL_LIST_NAME'                 , 'NAME'                 , null , '100%', 'listViewTdLinkS1', 'ID NAME', 'SelectDiscount(''{0}'', ''{1}'');', null, 'Discounts', null;
end -- if;
GO

-- 06/21/2011 Paul.  A KBDocument can be selected from a case. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS KBDocuments.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'KBDocuments.PopupView'      , 'KBDocuments', 'vwKBDOCUMENTS_List'     ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'KBDocuments.PopupView'      , 1, 'KBDocuments.LBL_LIST_NAME'                , 'NAME'                 , 'NAME'                 , '35%', 'listViewTdLinkS1', 'ID NAME', 'SelectKBDocument(''{0}'', ''{1}'');', null, 'KBDocuments'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.PopupView'      , 2, 'KBDocuments.LBL_LIST_VIEW_FREQUENCY'      , 'VIEW_FREQUENCY'       , 'VIEW_FREQUENCY'       , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.PopupView'      , 3, 'KBDocuments.LBL_LIST_KBDOC_APPROVER_NAME' , 'KBDOC_APPROVER_NAME'  , 'KBDOC_APPROVER_NAME'  , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'KBDocuments.PopupView'      , 4, '.LBL_LIST_DATE_ENTERED'                   , 'DATE_ENTERED'         , 'DATE_ENTERED'         , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.PopupView'      , 5, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.PopupView'      , 6, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'            , 'TEAM_NAME'            , '5%';
end -- if;
GO

-- 05/22/2013 Paul.  Add Surveys module. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Surveys.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Surveys.PopupView', 'Surveys', 'vwSURVEYS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Surveys.PopupView'     , 2, 'Surveys.LBL_LIST_NAME'                  , 'NAME'                 , 'NAME'                 , '25%', 'listViewTdLinkS1', 'ID NAME', 'SelectSurvey(''{0}'', ''{1}'');', null, 'Surveys', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.PopupView'     , 3, 'Surveys.LBL_LIST_RESPONSES'             , 'RESPONSES'            , 'RESPONSES'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.PopupView'     , 4, 'Surveys.LBL_LIST_SURVEY_THEME_NAME'     , 'SURVEY_THEME_NAME'    , 'SURVEY_THEME_NAME'    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Surveys.PopupView'     , 5, 'Surveys.LBL_LIST_STATUS'                , 'STATUS'               , 'STATUS'               , '10%', 'survey_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Surveys.PopupView'     , 6, 'Surveys.LBL_LIST_SURVEY_STYLE'          , 'SURVEY_STYLE'         , 'SURVEY_STYLE'         , '10%', 'survey_style_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.PopupView'     , 7, '.LBL_LIST_ASSIGNED_USER'                , 'ASSIGNED_TO_NAME'     , 'ASSIGNED_TO_NAME'     , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.PopupView'     , 8, 'Teams.LBL_LIST_TEAM'                    , 'TEAM_NAME'            , 'TEAM_NAME'            , '15%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyThemes.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyThemes.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyThemes.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyThemes.PopupView'     , 'SurveyThemes', 'vwSURVEY_THEMES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyThemes.PopupView'     , 1, 'SurveyThemes.LBL_LIST_NAME'               , 'NAME'                 , 'NAME'                 , '90%', 'listViewTdLinkS1', 'ID NAME', 'SelectSurveyTheme(''{0}'', ''{1}'');', null, 'SurveyThemes'  , null;
end -- if;
GO

-- 01/01/2016 Paul.  Add categories. 
-- 11/09/2018 Paul.  Align vertically. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyQuestions.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyQuestions.PopupView', 'SurveyQuestions', 'vwSURVEY_QUESTIONS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.PopupView', 1, 'SurveyQuestions.LBL_LIST_DESCRIPTION'      , 'DESCRIPTION'          , 'DESCRIPTION'          , '40%', 'listViewTdLinkS1', 'ID DESCRIPTION', 'SelectSurveyQuestion(''{0}'', ''{1}'');', null, 'SurveyQuestions', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyQuestions.PopupView', 2, 'SurveyQuestions.LBL_LIST_NAME'             , 'NAME'                 , 'NAME'                 , '15%', 'listViewTdLinkS1', 'ID DESCRIPTION', 'SelectSurveyQuestion(''{0}'', ''{1}'');', null, 'SurveyQuestions', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'SurveyQuestions.PopupView', 3, 'SurveyQuestions.LBL_LIST_QUESTION_TYPE'    , 'QUESTION_TYPE'        , 'QUESTION_TYPE'        , '20%', 'survey_question_type';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.PopupView', 4, 'SurveyQuestions.LBL_LIST_CATEGORIES'       , 'CATEGORIES'           , 'CATEGORIES'           , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyQuestions.PopupView', 1, null, null, null, 'top', null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyQuestions.PopupView', 2, null, null, null, 'top', null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyQuestions.PopupView', 3, null, null, null, 'top', null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyQuestions.PopupView', 4, null, null, null, 'top', null;
end else begin
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.PopupView' and URL_FIELD = 'ID NAME' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set URL_FIELD         = 'ID DESCRIPTION'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where GRID_NAME         = 'SurveyQuestions.PopupView'
		   and URL_FIELD         = 'ID NAME'
		   and DELETED           = 0;
	end -- if;
	-- 01/01/2016 Paul.  Add categories. 
	if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.PopupView' and DATA_FIELD = 'CATEGORIES' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH   = '40%'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where GRID_NAME         = 'SurveyQuestions.PopupView'
		   and DATA_FIELD        = 'DESCRIPTION'
		   and DELETED           = 0;
		update GRIDVIEWS_COLUMNS
		   set ITEMSTYLE_WIDTH   = '15%'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where GRID_NAME         = 'SurveyQuestions.PopupView'
		   and DATA_FIELD        = 'NAME'
		   and DELETED           = 0;
		exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.PopupView', 4, 'SurveyQuestions.LBL_LIST_CATEGORIES'       , 'CATEGORIES'           , 'CATEGORIES'           , '25%';
	end -- if;
	-- 11/09/2018 Paul.  Align vertically. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.PopupView' and ITEMSTYLE_VERTICAL_ALIGN is null and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyQuestions.PopupView', 1, null, null, null, 'top', null;
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyQuestions.PopupView', 2, null, null, null, 'top', null;
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyQuestions.PopupView', 3, null, null, null, 'top', null;
		exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle null, 'SurveyQuestions.PopupView', 4, null, null, null, 'top', null;
	end -- if;
end -- if;
GO

-- 07/03/2021 Paul.  Default sort for React client should be DESCRIPTION. 
if exists(select * from GRIDVIEWS where NAME = 'SurveyQuestions.PopupView' and SORT_FIELD is null and DELETED = 0) begin -- then
	update GRIDVIEWS
	   set SORT_FIELD        = 'DESCRIPTION'
	     , SORT_DIRECTION    = 'asc'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where NAME              = 'SurveyQuestions.PopupView'
	   and SORT_FIELD        is null
	   and DELETED           = 0;
end -- if;
GO

-- 12/29/2015 Paul.  Allow searching of Survey ResultsView. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyResults.RespondantsPopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyResults.RespondantsPopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyResults.RespondantsPopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyResults.RespondantsPopupView', 'SurveyResults', 'vwSURVEY_RESULTS_Edit';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SurveyResults.RespondantsPopupView', 1, 'SurveyResults.LBL_LIST_RESPONDANT'      , 'PARENT_NAME'          , 'PARENT_NAME'          , '50%', 'listViewTdLinkS1', 'PARENT_ID PARENT_NAME', 'SelectRespondant(''{0}'', ''{1}'');', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'SurveyResults.RespondantsPopupView', 3, 'SurveyResults.LBL_LIST_START_DATE'      , 'START_DATE'           , 'START_DATE'           , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'SurveyResults.RespondantsPopupView', 4, 'SurveyResults.LBL_LIST_SUBMIT_DATE'     , 'SUBMIT_DATE'          , 'SUBMIT_DATE'          , '15%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.RespondantsPopupView', 5, 'SurveyResults.LBL_LIST_IS_COMPLETE'     , 'IS_COMPLETE'          , 'IS_COMPLETE'          , '10%';
end -- if;
GO

-- 01/01/2017 Paul.  Add Regions popup. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Regions.PopupView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Regions.PopupView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Regions.PopupView';
	exec dbo.spGRIDVIEWS_InsertOnly           'Regions.PopupView', 'Regions', 'vwREGIONS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Regions.PopupView'          , 1, 'Regions.LBL_LIST_NAME'                     , 'NAME'            , 'NAME'            , '95%', 'listViewTdLinkS1', 'ID NAME', 'SelectRegion(''{0}'', ''{1}'');', null, 'Regions', null;
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

call dbo.spGRIDVIEWS_COLUMNS_PopupViewsProfessional()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_PopupViewsProfessional')
/

-- #endif IBM_DB2 */


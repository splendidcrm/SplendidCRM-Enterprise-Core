

print 'GRIDVIEWS_COLUMNS PopupView.Mobile Professional';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.PopupView.Mobile'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.PopupView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.PopupView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.PopupView.Mobile', 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.PopupView.Mobile'         , 1, 'Contracts.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID NAME', 'SelectContract(''{0}'', ''{1}'');', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.PopupView.Mobile'         , 2, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.PopupView.Mobile'         , 3, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'          , 'STATUS'          , '20%', 'contract_status_dom';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.PopupView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.PopupView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.PopupView.Mobile', 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.PopupView.Mobile'          , 1, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'INVOICE_NUM'               , 'INVOICE_NUM'               , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectInvoice(''{0}'', ''{1}'');', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.PopupView.Mobile'          , 2, 'Invoices.LBL_LIST_NAME'                   , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID NAME', 'SelectInvoice(''{0}'', ''{1}'');', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.PopupView.Mobile'          , 3, 'Invoices.LBL_LIST_ACCOUNT_NAME'           , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.PopupView.Mobile'          , 4, 'Invoices.LBL_LIST_AMOUNT'                 , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.PopupView.Mobile';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.PopupView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.PopupView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.PopupView.Mobile', 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.PopupView.Mobile'            , 1, 'Orders.LBL_LIST_ORDER_NUM'                , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectOrder(''{0}'', ''{1}'');', null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.PopupView.Mobile'            , 2, 'Orders.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '35%', 'listViewTdLinkS1', 'ID NAME', 'SelectOrder(''{0}'', ''{1}'');', null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.PopupView.Mobile'            , 3, 'Orders.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.PopupView.Mobile'            , 4, 'Orders.LBL_LIST_DATE_ORDER_DUE'           , 'DATE_ORDER_DUE'            , 'DATE_ORDER_DUE'            , '10%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.PopupView.Mobile';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.PopupView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.PopupView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.PopupView.Mobile', 'Payments', 'vwPAYMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.PopupView.Mobile'          , 1, 'Payments.LBL_LIST_PAYMENT_NUM'            , 'PAYMENT_NUM'               , 'PAYMENT_NUM'               , '10%', 'listViewTdLinkS1', 'ID PAYMENT_NUM', 'SelectPayment(''{0}'', ''{1}'');', null, 'Payments', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.PopupView.Mobile'          , 2, 'Payments.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'              , 'ACCOUNT_NAME'              , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.PopupView.Mobile'          , 3, 'Payments.LBL_LIST_AMOUNT'                 , 'AMOUNT_USDOLLAR'           , 'AMOUNT_USDOLLAR'           , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.PopupView.Mobile'          , 4, 'Payments.LBL_LIST_PAYMENT_DATE'           , 'PAYMENT_DATE'              , 'PAYMENT_DATE'              , '15%', 'Date';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.PopupView.Mobile' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'Products.PopupView.Mobile', 'Products', 'vwPRODUCTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Products.PopupView.Mobile'          , 1, 'Products.LBL_LIST_NAME'                   , 'NAME'                , 'NAME'                , '50%', 'listViewTdLinkS1', 'ID NAME', 'SelectProduct(''{0}'', ''{1}'');', null, 'Products', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.PopupView.Mobile'          , 2, 'Products.LBL_LIST_ACCOUNT_NAME'           , 'ACCOUNT_NAME'        , 'ACCOUNT_NAME'        , '40%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCatalog.PopupView.Mobile';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCatalog.PopupView.Mobile' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductCatalog.PopupView.Mobile', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductCatalog.PopupView.Mobile'  , 1, 'ProductTemplates.LBL_LIST_NAME'           , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID NAME', 'SelectProductTemplate(''{0}'', ''{1}'');', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCatalog.PopupView.Mobile'  , 2, 'ProductTemplates.LBL_LIST_MANUFACTURER'   , 'MANUFACTURER_NAME'   , 'MANUFACTURER_NAME'   , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductCatalog.PopupView.Mobile'  , 3, 'ProductTemplates.LBL_LIST_BOOK_VALUE'     , 'DISCOUNT_USDOLLAR'   , 'DISCOUNT_USDOLLAR'   , '10%', 'Currency';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCategories.PopupView.Mobile';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductCategories.PopupView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProductCategories.PopupView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductCategories.PopupView.Mobile', 'ProductCategories', 'vwPRODUCT_CATEGORIES';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductCategories.PopupView.Mobile', 1, 'ProductCategories.LBL_LIST_NAME'         , 'NAME'               , 'NAME'                , '40%', 'listViewTdLinkS1', 'ID NAME', 'SelectProductCategory(''{0}'', ''{1}'');', null, 'ProductCategories', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductCategories.PopupView.Mobile', 2, 'ProductCategories.LBL_LIST_DESCRIPTION'  , 'DESCRIPTION'        , 'DESCRIPTION'         , '60%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.PopupView.Mobile';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.PopupView.Mobile' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.PopupView.Mobile', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTemplates.PopupView.Mobile'  , 1, 'ProductTemplates.LBL_LIST_NAME'           , 'NAME'                , 'NAME'                , '25%', 'listViewTdLinkS1', 'ID NAME', 'SelectProductTemplate(''{0}'', ''{1}'');', null, 'ProductTemplates', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProductTemplates.PopupView.Mobile'  , 2, 'ProductTemplates.LBL_LIST_STATUS'         , 'STATUS'              , 'STATUS'              , '15%', 'product_template_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.PopupView.Mobile'  , 3, 'ProductTemplates.LBL_LIST_QUANTITY'       , 'QUANTITY'            , 'QUANTITY'            , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.PopupView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.PopupView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.PopupView.Mobile', 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.PopupView.Mobile'            , 0, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectQuote(''{0}'', ''{1}'');', null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.PopupView.Mobile'            , 1, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '25%', 'listViewTdLinkS1', 'ID NAME', 'SelectQuote(''{0}'', ''{1}'');', null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.PopupView.Mobile'            , 2, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.PopupView.Mobile'            , 3, 'Quotes.LBL_LIST_QUOTE_STAGE'              , 'QUOTE_STAGE'               , 'QUOTE_STAGE'               , '15%', 'quote_stage_dom';
end -- if;
GO

-- 01/25/2015 Paul.  Add Teams Mobile for Offline Client. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.PopupView.Mobile'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.PopupView.Mobile' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Teams.PopupView.Mobile';
	exec dbo.spGRIDVIEWS_InsertOnly           'Teams.PopupView.Mobile', 'Teams', 'vwTEAMS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Teams.PopupView.Mobile'             , 0, 'Teams.LBL_LIST_NAME'                      , 'NAME'            , 'NAME'            , '20%', 'listViewTdLinkS1', 'ID', '~/Administration/Teams/view.aspx?id={0}', null, 'Teams', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.PopupView.Mobile'             , 1, 'Teams.LBL_LIST_DESCRIPTION'               , 'DESCRIPTION'     , 'DESCRIPTION'     , '50%';
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

call dbo.spGRIDVIEWS_COLUMNS_PopupViewsMobileProfessional()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_PopupViewsMobileProfessional')
/

-- #endif IBM_DB2 */




print 'GRIDVIEWS_COLUMNS SubPanel Professional.Portal';
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like '%.LineItems.Portal'
--GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.MyInvoices.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.MyInvoices.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.MyInvoices.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.MyInvoices.Portal', 'Invoices', 'vwINVOICES_MyInvoices';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.MyInvoices.Portal' , 0, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'INVOICE_NUM'               , 'INVOICE_NUM'               , '10%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.MyInvoices.Portal' , 1, 'Invoices.LBL_LIST_NAME'                   , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.MyInvoices.Portal' , 2, 'Invoices.LBL_LIST_INVOICE_STAGE'          , 'INVOICE_STAGE'             , 'INVOICE_STAGE'             , '15%', 'invoice_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.MyInvoices.Portal' , 3, 'Invoices.LBL_LIST_AMOUNT'                 , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.MyInvoices.Portal' , 4, 'Invoices.LBL_LIST_DUE_DATE'               , 'DUE_DATE'                  , 'DUE_DATE'                  , '20%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.MyOrders.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.MyOrders.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.MyOrders.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.MyOrders.Portal', 'Orders', 'vwORDERS_MyOrders';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.MyOrders.Portal'     , 0, 'Orders.LBL_LIST_ORDER_NUM'                , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.MyOrders.Portal'     , 1, 'Orders.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.MyOrders.Portal'     , 2, 'Orders.LBL_LIST_ORDER_STAGE'              , 'ORDER_STAGE'               , 'ORDER_STAGE'               , '15%', 'order_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.MyOrders.Portal'     , 3, 'Orders.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.MyOrders.Portal'     , 4, 'Orders.LBL_LIST_DATE_ORDER_DUE'           , 'DATE_ORDER_DUE'            , 'DATE_ORDER_DUE'            , '20%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.MyQuotes.Portal' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.MyQuotes.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.MyQuotes.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.MyQuotes.Portal', 'Quotes', 'vwQUOTES_MyQuotes';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.MyQuotes.Portal'     , 0, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '10%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.MyQuotes.Portal'     , 1, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.MyQuotes.Portal'     , 2, 'Quotes.LBL_LIST_QUOTE_STAGE'              , 'QUOTE_STAGE'               , 'QUOTE_STAGE'               , '15%', 'quote_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.MyQuotes.Portal'     , 3, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.MyQuotes.Portal'     , 4, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '20%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.LineItems.Portal' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.LineItems.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.LineItems.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.LineItems.Portal', 'Quotes', 'vwQUOTES_LINE_ITEMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.LineItems.Portal'                , 0, 'Quotes.LBL_LIST_ITEM_QUANTITY'              , 'QUANTITY'               , null, '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.LineItems.Portal'                , 1, 'Quotes.LBL_LIST_ITEM_NAME'                  , 'NAME'                   , null, '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.LineItems.Portal'                , 2, 'Quotes.LBL_LIST_ITEM_MFT_PART_NUM'          , 'MFT_PART_NUM'           , null, '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.LineItems.Portal'                , 3, 'Quotes.LBL_LIST_ITEM_UNIT_PRICE'            , 'UNIT_USDOLLAR'          , null, '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.LineItems.Portal'                , 4, 'Quotes.LBL_LIST_ITEM_EXTENDED_PRICE'        , 'EXTENDED_USDOLLAR'      , null, '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems.Portal', 0, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems.Portal', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Quotes.LineItems.Portal', 4, null, null, 'right', null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.LineItems.Portal' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.LineItems.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.LineItems.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.LineItems.Portal', 'Invoices', 'vwINVOICES_LINE_ITEMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.LineItems.Portal'              , 0, 'Invoices.LBL_LIST_ITEM_QUANTITY'            , 'QUANTITY'               , null, '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.LineItems.Portal'              , 1, 'Invoices.LBL_LIST_ITEM_NAME'                , 'NAME'                   , null, '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.LineItems.Portal'              , 2, 'Invoices.LBL_LIST_ITEM_MFT_PART_NUM'        , 'MFT_PART_NUM'           , null, '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.LineItems.Portal'              , 3, 'Invoices.LBL_LIST_ITEM_UNIT_PRICE'          , 'UNIT_USDOLLAR'          , null, '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.LineItems.Portal'              , 4, 'Invoices.LBL_LIST_ITEM_EXTENDED_PRICE'      , 'EXTENDED_USDOLLAR'      , null, '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems.Portal', 0, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems.Portal', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Invoices.LineItems.Portal', 4, null, null, 'right', null, null;
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.LineItems.Portal' and DELETED = 0;
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.LineItems.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.LineItems.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.LineItems.Portal', 'Orders', 'vwORDERS_LINE_ITEMS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.LineItems.Portal'                , 0, 'Orders.LBL_LIST_ITEM_QUANTITY'              , 'QUANTITY'               , null, '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.LineItems.Portal'                , 1, 'Orders.LBL_LIST_ITEM_NAME'                  , 'NAME'                   , null, '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.LineItems.Portal'                , 2, 'Orders.LBL_LIST_ITEM_MFT_PART_NUM'          , 'MFT_PART_NUM'           , null, '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.LineItems.Portal'                , 3, 'Orders.LBL_LIST_ITEM_UNIT_PRICE'            , 'UNIT_USDOLLAR'          , null, '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.LineItems.Portal'                , 4, 'Orders.LBL_LIST_ITEM_EXTENDED_PRICE'        , 'EXTENDED_USDOLLAR'      , null, '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems.Portal', 0, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems.Portal', 3, null, null, 'right', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Orders.LineItems.Portal', 4, null, null, 'right', null, null;
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

call dbo.spGRIDVIEWS_COLUMNS_SubPanelsProfessionalPortal()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_SubPanelsProfessionalPortal')
/

-- #endif IBM_DB2 */


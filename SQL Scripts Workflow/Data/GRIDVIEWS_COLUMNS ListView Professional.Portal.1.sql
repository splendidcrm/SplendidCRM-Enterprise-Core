

print 'GRIDVIEWS_COLUMNS ListView Professional.Portal';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.ListView.Portal'
--GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView.Portal'
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.ListView.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.ListView.Portal', 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.ListView.Portal'         , 1, 'Contracts.LBL_LIST_NAME'                  , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Contracts/view.aspx?id={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.ListView.Portal'         , 2, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'                    , 'STATUS'                    , '20%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.ListView.Portal'         , 3, 'Contracts.LBL_LIST_START_DATE'            , 'START_DATE'                , 'START_DATE'                , '20%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.ListView.Portal'         , 4, 'Contracts.LBL_LIST_END_DATE'              , 'END_DATE'                  , 'END_DATE'                  , '20%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.Portal' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.ListView.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.ListView.Portal', 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.Portal'            , 1, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '15%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.Portal'            , 2, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Quotes/view.aspx?id={0}'   , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.ListView.Portal'            , 3, 'Quotes.LBL_LIST_QUOTE_STAGE'              , 'QUOTE_STAGE'               , 'QUOTE_STAGE'               , '15%', 'quote_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.Portal'            , 4, 'Quotes.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.Portal'            , 5, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '15%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.ListView.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.ListView.Portal', 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.Portal'            , 1, 'Orders.LBL_LIST_ORDER_NUM'                , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '15%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.ListView.Portal'            , 2, 'Orders.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '40%', 'listViewTdLinkS1', 'ID'                , '~/Orders/view.aspx?id={0}'   , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.ListView.Portal'            , 3, 'Orders.LBL_LIST_ORDER_STAGE'              , 'ORDER_STAGE'               , 'ORDER_STAGE'               , '15%', 'order_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.Portal'            , 4, 'Orders.LBL_LIST_AMOUNT'                   , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.Portal'            , 5, 'Orders.LBL_LIST_DATE_ORDER_DUE'           , 'DATE_ORDER_DUE'            , 'DATE_ORDER_DUE'            , '15%', 'Date';
end -- if;
GO

-- 04/11/2007 Paul.  Add Invoices module. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.ListView.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.ListView.Portal', 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.Portal'          , 1, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'INVOICE_NUM'               , 'INVOICE_NUM'               , '10%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.Portal'          , 2, 'Invoices.LBL_LIST_NAME'                   , 'NAME'                      , 'NAME'                      , '30%', 'listViewTdLinkS1', 'ID'                , '~/Invoices/view.aspx?id={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.ListView.Portal'          , 3, 'Invoices.LBL_LIST_INVOICE_STAGE'          , 'INVOICE_STAGE'             , 'INVOICE_STAGE'             , '15%', 'invoice_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.Portal'          , 4, 'Invoices.LBL_LIST_AMOUNT'                 , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.Portal'          , 5, 'Invoices.LBL_LIST_AMOUNT_DUE'             , 'AMOUNT_DUE_USDOLLAR'       , 'AMOUNT_DUE_USDOLLAR'       , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.Portal'          , 6, 'Invoices.LBL_LIST_DUE_DATE'               , 'DUE_DATE'                  , 'DUE_DATE'                  , '15%', 'Date';
end -- if;
GO

/*
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView.Portal';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView.Portal' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.ListView.Portal';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.ListView.Portal', 'Payments', 'vwPAYMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.ListView.Portal'          , 1, 'Payments.LBL_LIST_PAYMENT_NUM'            , 'PAYMENT_NUM'               , 'PAYMENT_NUM'               , '25%', 'listViewTdLinkS1', 'ID'        , '~/Payments/view.aspx?id={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Payments.ListView.Portal'          , 2, 'Payments.LBL_LIST_PAYMENT_TYPE'           , 'PAYMENT_TYPE'              , 'PAYMENT_TYPE'              , '25%', 'payment_type_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView.Portal'          , 3, 'Payments.LBL_LIST_AMOUNT'                 , 'AMOUNT_USDOLLAR'           , 'AMOUNT_USDOLLAR'           , '25%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView.Portal'          , 4, 'Payments.LBL_LIST_PAYMENT_DATE'           , 'PAYMENT_DATE'              , 'PAYMENT_DATE'              , '25%', 'Date';
end -- if;
*/
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

call dbo.spGRIDVIEWS_COLUMNS_ProfessionalPortal()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ProfessionalPortal')
/

-- #endif IBM_DB2 */




print 'GRIDVIEWS_COLUMNS PopupView Professional Gmail';
-- delete from GRIDVIEWS_COLUMNS -- where GRID_NAME like '%.PopupView.Gmail'
--GO

set nocount on;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.PopupView.Gmail', 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Contracts.PopupView.Gmail'         , 1, 'Contracts.LBL_LIST_NAME'                  , 'NAME'            , 'NAME'            , '30%', 'listViewTdLinkS1', 'ID NAME', 'SelectContract(''{0}'', ''{1}'');', null, 'Contracts', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.PopupView.Gmail'         , 2, 'Contracts.LBL_LIST_ACCOUNT_NAME'          , 'ACCOUNT_NAME'    , 'ACCOUNT_NAME'    , '30%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Contracts.PopupView.Gmail'         , 3, 'Contracts.LBL_LIST_STATUS'                , 'STATUS'          , 'STATUS'          , '20%', 'contract_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.PopupView.Gmail'         , 4, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'       , 'TEAM_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.PopupView.Gmail'         , 5, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME', 'ASSIGNED_TO_NAME', '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.PopupView.Gmail', 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.PopupView.Gmail'          , 1, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'INVOICE_NUM'               , 'INVOICE_NUM'               , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectInvoice(''{0}'', ''{1}'');', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.PopupView.Gmail'          , 2, 'Invoices.LBL_LIST_NAME'                   , 'NAME'                      , 'NAME'                      , '20%', 'listViewTdLinkS1', 'ID NAME', 'SelectInvoice(''{0}'', ''{1}'');', null, 'Invoices', 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.PopupView.Gmail'          , 3, 'Invoices.LBL_LIST_ACCOUNT_NAME'           , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.PopupView.Gmail'          , 4, 'Invoices.LBL_LIST_AMOUNT'                 , 'TOTAL_USDOLLAR'            , 'TOTAL_USDOLLAR'            , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.PopupView.Gmail'          , 5, 'Invoices.LBL_LIST_AMOUNT_DUE'             , 'AMOUNT_DUE_USDOLLAR'       , 'AMOUNT_DUE_USDOLLAR'       , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.PopupView.Gmail'          , 6, 'Invoices.LBL_LIST_DUE_DATE'               , 'DUE_DATE'                  , 'DUE_DATE'                  , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.PopupView.Gmail'          , 7, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.PopupView.Gmail'          , 8, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.PopupView.Gmail';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.PopupView.Gmail', 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.PopupView.Gmail'            , 1, 'Orders.LBL_LIST_ORDER_NUM'                , 'ORDER_NUM'                 , 'ORDER_NUM'                 , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectOrder(''{0}'', ''{1}'');', null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Orders.PopupView.Gmail'            , 2, 'Orders.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '35%', 'listViewTdLinkS1', 'ID NAME', 'SelectOrder(''{0}'', ''{1}'');', null, 'Orders'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.PopupView.Gmail'            , 3, 'Orders.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.PopupView.Gmail'            , 4, 'Orders.LBL_LIST_DATE_ORDER_DUE'           , 'DATE_ORDER_DUE'            , 'DATE_ORDER_DUE'            , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.PopupView.Gmail'            , 5, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.PopupView.Gmail'            , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.PopupView.Gmail', 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.PopupView.Gmail'            , 0, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'QUOTE_NUM'                 , 'QUOTE_NUM'                 , '10%', 'listViewTdLinkS1', 'ID NAME', 'SelectQuote(''{0}'', ''{1}'');', null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.PopupView.Gmail'            , 1, 'Quotes.LBL_LIST_NAME'                     , 'NAME'                      , 'NAME'                      , '25%', 'listViewTdLinkS1', 'ID NAME', 'SelectQuote(''{0}'', ''{1}'');', null, 'Quotes'  , 'ASSIGNED_USER_ID';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.PopupView.Gmail'            , 2, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'BILLING_ACCOUNT_NAME'      , 'BILLING_ACCOUNT_NAME'      , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.PopupView.Gmail'            , 3, 'Quotes.LBL_LIST_QUOTE_STAGE'              , 'QUOTE_STAGE'               , 'QUOTE_STAGE'               , '15%', 'quote_stage_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.PopupView.Gmail'            , 4, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'DATE_QUOTE_EXPECTED_CLOSED', 'DATE_QUOTE_EXPECTED_CLOSED', '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.PopupView.Gmail'            , 5, 'Teams.LBL_LIST_TEAM'                      , 'TEAM_NAME'                 , 'TEAM_NAME'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.PopupView.Gmail'            , 6, '.LBL_LIST_ASSIGNED_USER'                  , 'ASSIGNED_TO_NAME'          , 'ASSIGNED_TO_NAME'          , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Teams.PopupView.Gmail' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Teams.PopupView.Gmail';
	exec dbo.spGRIDVIEWS_InsertOnly           'Teams.PopupView.Gmail', 'Teams', 'vwTEAMS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Teams.PopupView.Gmail'             , 1, 'Teams.LBL_LIST_NAME'                      , 'NAME'            , 'NAME'            , '40%', 'listViewTdLinkS1', 'ID NAME', 'SelectTeam(''{0}'', ''{1}'');', null, 'Teams', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Teams.PopupView.Gmail'             , 2, 'Teams.LBL_LIST_DESCRIPTION'               , 'DESCRIPTION'     , 'DESCRIPTION'     , '60%';
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

call dbo.spGRIDVIEWS_COLUMNS_PopupViewsProfessionalGmail()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_PopupViewsProfessionalGmail')
/

-- #endif IBM_DB2 */


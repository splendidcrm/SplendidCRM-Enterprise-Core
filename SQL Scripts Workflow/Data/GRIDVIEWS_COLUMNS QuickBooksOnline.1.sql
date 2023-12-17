

print 'GRIDVIEWS_COLUMNS QuickBooksOnline';
GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.QuickBooksOnline';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Accounts.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Accounts.ListView.QuickBooksOnline';
	exec dbo.spGRIDVIEWS_InsertOnly           'Accounts.ListView.QuickBooksOnline', 'Accounts', 'vwACCOUNTS_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.ListView.QuickBooksOnline', 2, '.LBL_LIST_ID'                             , 'Id'                        , 'Id'                        , '5%' , 'listViewTdLinkS1', 'Id', '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Accounts.ListView.QuickBooksOnline', 3, 'Accounts.LBL_LIST_ACCOUNT_NAME'           , 'Name'                      , 'Name'                      , '25%', 'listViewTdLinkS1', 'Id', '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooksOnline', 4, 'Accounts.LBL_LIST_EMAIL1'                 , 'PrimaryEmailAddr'          , 'PrimaryEmailAddr'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooksOnline', 5, 'Accounts.LBL_LIST_PHONE'                  , 'PrimaryPhone'              , 'PrimaryPhone'              , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooksOnline', 6, 'Accounts.LBL_LIST_DESCRIPTION'            , 'Notes'                     , 'Notes'                     , '24%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooksOnline', 7, 'Accounts.LBL_LIST_BILLING_ADDRESS_CITY'   , 'BillingCity'               , 'BillingCity'               , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Accounts.ListView.QuickBooksOnline', 8, 'Accounts.LBL_LIST_BILLING_ADDRESS_STATE'  , 'BillingState'              , 'BillingState'              , '10%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView.QuickBooksOnline';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.ListView.QuickBooksOnline';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.ListView.QuickBooksOnline', 'Invoices', 'vwINVOICES_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.QuickBooksOnline', 2, '.LBL_LIST_ID'                             , 'Id'                        , 'Id'                        , '5%' , 'listViewTdLinkS1', 'Id'      , '~/Invoices/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.QuickBooksOnline', 3, 'Invoices.LBL_LIST_INVOICE_NUM'            , 'DocNumber'                 , 'DocNumber'                 , '10%', 'listViewTdLinkS1', 'Id'      , '~/Invoices/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.QuickBooksOnline', 4, 'Invoices.LBL_LIST_DESCRIPTION'            , 'CustomerMemo'              , 'CustomerMemo'              , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Invoices.ListView.QuickBooksOnline', 5, 'Invoices.LBL_LIST_ACCOUNT_NAME'           , 'CustomerName'              , 'CustomerName'              , '20%', 'listViewTdLinkS1', 'Customer', '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.QuickBooksOnline', 6, 'Invoices.LBL_LIST_AMOUNT'                 , 'TotalAmt'                  , 'TotalAmt'                  , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.QuickBooksOnline', 7, 'Invoices.LBL_LIST_AMOUNT_DUE'             , 'Balance'                   , 'Balance'                   , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.QuickBooksOnline', 8, 'Invoices.LBL_LIST_DUE_DATE'               , 'DueDate'                   , 'DueDate'                   , '15%', 'Date';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.QuickBooksOnline';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.ListView.QuickBooksOnline';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.ListView.QuickBooksOnline'  , 'Quotes', 'vwQUOTES_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.QuickBooksOnline'  , 2, '.LBL_LIST_ID'                             , 'Id'                        , 'Id'                        , '5%' , 'listViewTdLinkS1', 'Id'      , '~/Quotes/QuickBooks/view.aspx?QID={0}'  , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.QuickBooksOnline'  , 3, 'Quotes.LBL_LIST_QUOTE_NUM'                , 'DocNumber'                 , 'DocNumber'                 , '10%', 'listViewTdLinkS1', 'Id'      , '~/Quotes/QuickBooks/view.aspx?QID={0}'  , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.QuickBooksOnline'  , 4, 'Quotes.LBL_LIST_DESCRIPTION'              , 'CustomerMemo'              , 'CustomerMemo'              , '20%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Quotes.ListView.QuickBooksOnline'  , 5, 'Quotes.LBL_LIST_ACCOUNT_NAME'             , 'CustomerName'              , 'CustomerName'              , '20%', 'listViewTdLinkS1', 'Customer', '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.QuickBooksOnline'  , 6, 'Quotes.LBL_LIST_PAYMENT_TERMS'            , 'SalesTerm'                 , 'SalesTerm'                 , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.QuickBooksOnline'  , 7, 'Quotes.LBL_LIST_AMOUNT'                   , 'TotalAmt'                  , 'TotalAmt'                  , '15%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.QuickBooksOnline'  , 8, 'Quotes.LBL_LIST_DATE_VALID_UNTIL'         , 'ExpirationDate'            , 'ExpirationDate'            , '15%', 'Date';
end -- if;
GO

-- 02/01/2015 Paul.  Shippers, TaxRates and ProductTemplates. 
-- 02/01/2015 Paul.  QuickBooks Online does not support ShipMethod. 
-- 04/08/2015 Paul.  Remove commented-out Shippers.ListView.QuickBooks to simplify migration to Oracle. 

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'TaxRates.ListView.QuickBooksOnline';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TaxRates.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS TaxRates.ListView.QuickBooksOnline';
	exec dbo.spGRIDVIEWS_InsertOnly           'TaxRates.ListView.QuickBooksOnline', 'TaxRates', 'vwTAX_RATES_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TaxRates.ListView.QuickBooksOnline'        , 2, '.LBL_LIST_ID'                           , 'Id'                       , 'Id'                        , '5%' , 'listViewTdLinkS1', 'Id', '~/Administration/TaxRates/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TaxRates.ListView.QuickBooksOnline'        , 3, 'TaxRates.LBL_LIST_NAME'                 , 'Name'                     , 'Name'                      , '20%', 'listViewTdLinkS1', 'Id', '~/Administration/TaxRates/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView.QuickBooksOnline'        , 3, 'TaxRates.LBL_LIST_VALUE'                , 'RateValue'                , 'RateValue'                 , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView.QuickBooksOnline'        , 4, 'TaxRates.LBL_LIST_QUICKBOOKS_TAX_VENDOR', 'Agency'                   , 'Agency'                    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView.QuickBooksOnline'        , 5, 'TaxRates.LBL_LIST_STATUS'               , 'Active'                   , 'Active'                    , '15%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxRates.ListView.QuickBooksOnline'        , 6, 'TaxRates.LBL_LIST_DESCRIPTION'          , 'Description'              , 'Description'               , '25%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'TaxCodes.ListView.QuickBooksOnline';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'TaxCodes.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS TaxCodes.ListView.QuickBooksOnline';
	exec dbo.spGRIDVIEWS_InsertOnly           'TaxCodes.ListView.QuickBooksOnline', 'TaxRates', 'vwTAX_CODES_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TaxCodes.ListView.QuickBooksOnline'        , 2, '.LBL_LIST_ID'                           , 'Id'                       , 'Id'                        , '5%' , 'listViewTdLinkS1', 'Id', '~/Administration/TaxRates/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'TaxCodes.ListView.QuickBooksOnline'        , 3, 'TaxRates.LBL_LIST_NAME'                 , 'Name'                     , 'Name'                      , '20%', 'listViewTdLinkS1', 'Id', '~/Administration/TaxRates/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxCodes.ListView.QuickBooksOnline'        , 4, 'TaxRates.LBL_LIST_QUICKBOOKS_TAX_VENDOR', 'TaxCodeTaxRate'           , 'TaxCodeTaxRate'            , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxCodes.ListView.QuickBooksOnline'        , 5, 'TaxRates.LBL_LIST_STATUS'               , 'Active'                   , 'Active'                    , '25%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'TaxCodes.ListView.QuickBooksOnline'        , 6, 'TaxRates.LBL_LIST_DESCRIPTION'          , 'Description'              , 'Description'               , '25%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTypes.ListView.QuickBooksOnline';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTypes.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS PaymentTypes.ListView.QuickBooksOnline';
	exec dbo.spGRIDVIEWS_InsertOnly           'PaymentTypes.ListView.QuickBooksOnline'    , 'PaymentTypes', 'vwPAYMENT_TYPES_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PaymentTypes.ListView.QuickBooksOnline'    , 2, 'PaymentTypes.LBL_LIST_NAME'             , 'Id'                       , 'Id'                        , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/PaymentTypes/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PaymentTypes.ListView.QuickBooksOnline'    , 3, 'PaymentTypes.LBL_LIST_NAME'             , 'Name'                     , 'Name'                      , '65%', 'listViewTdLinkS1', 'ID', '~/Administration/PaymentTypes/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PaymentTypes.ListView.QuickBooksOnline'    , 4, 'PaymentTypes.LBL_LIST_STATUS'           , 'Active'                   , 'Active'                    , '25%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTerms.ListView.QuickBooksOnline';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'PaymentTerms.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS PaymentTerms.ListView.QuickBooksOnline';
	exec dbo.spGRIDVIEWS_InsertOnly           'PaymentTerms.ListView.QuickBooksOnline'    , 'PaymentTerms', 'vwPAYMENT_TERMS_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PaymentTerms.ListView.QuickBooksOnline'    , 2, 'PaymentTerms.LBL_LIST_NAME'             , 'Id'                       , 'Id'                        , '5%' , 'listViewTdLinkS1', 'ID', '~/Administration/PaymentTerms/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'PaymentTerms.ListView.QuickBooksOnline'    , 3, 'PaymentTerms.LBL_LIST_NAME'             , 'Name'                     , 'Name'                      , '65%', 'listViewTdLinkS1', 'ID', '~/Administration/PaymentTerms/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'PaymentTerms.ListView.QuickBooksOnline'    , 4, 'PaymentTerms.LBL_LIST_STATUS'           , 'Active'                   , 'Active'                    , '25%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView.QuickBooksOnline' 
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.ListView.QuickBooksOnline', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTemplates.ListView.QuickBooksOnline',  2, '.LBL_LIST_ID'                                , 'Id'                        , 'Id'                        , '5%' , 'listViewTdLinkS1', 'Id', '~/Administration/ProductTemplates/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'ProductTemplates.ListView.QuickBooksOnline',  3, 'ProductTemplates.LBL_LIST_NAME'              , 'Name'                      , 'Name'                      , '10%', 'listViewTdLinkS1', 'Id', '~/Administration/ProductTemplates/QuickBooks/view.aspx?QID={0}', null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooksOnline',  4, 'ProductTemplates.LBL_LIST_DESCRIPTION'       , 'Description'               , 'Description'               , '15';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooksOnline',  5, 'ProductTemplates.LBL_LIST_TYPE'              , 'Type'                      , 'Type'                      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooksOnline',  6, 'ProductTemplates.LBL_LIST_QUICKBOOKS_ACCOUNT', 'IncomeAccount'             , 'IncomeAccount'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooksOnline',  7, 'ProductTemplates.LBL_LIST_STATUS'            , 'Active'                    , 'Active'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooksOnline',  8, 'ProductTemplates.LBL_LIST_QUANTITY'          , 'QtyOnHand'                 , 'QtyOnHand'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView.QuickBooksOnline',  9, 'ProductTemplates.LBL_LIST_LIST_PRICE'        , 'UnitPrice'                 , 'UnitPrice'                 , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView.QuickBooksOnline', 10, 'ProductTemplates.LBL_LIST_COST_PRICE'        , 'PurchaseCost'              , 'PurchaseCost'              , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.QuickBooksOnline', 11, 'ProductTemplates.LBL_LIST_TAX_CLASS'         , 'Taxable'                   , 'Taxable'                   , '5%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'ProductTemplates.ListView.QuickBooksOnline', 12, '.LBL_LIST_DATE_MODIFIED'                     , 'TimeModified'              , 'TimeModified'              , '5%', 'DateTime';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView.QuickBooksOnline';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.ListView.QuickBooksOnline';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.ListView.QuickBooksOnline', 'Payments', 'vwPAYMENTS_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.ListView.QuickBooksOnline',  2, '.LBL_LIST_ID'                             , 'Id'                        , 'Id'                        , '5%' , 'listViewTdLinkS1', 'Id'      , '~/Payments/QuickBooks/view.aspx?QID={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.ListView.QuickBooksOnline',  3, 'Payments.LBL_LIST_PAYMENT_NUM'            , 'PrivateNote'               , 'PrivateNote'               , '10%', 'listViewTdLinkS1', 'Id'      , '~/Payments/QuickBooks/view.aspx?QID={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'Payments.ListView.QuickBooksOnline',  4, 'Payments.LBL_LIST_ACCOUNT_NAME'           , 'CustomerName'              , 'CustomerName'              , '15%', 'listViewTdLinkS1', 'Customer', '~/Accounts/QuickBooks/view.aspx?QID={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.ListView.QuickBooksOnline',  5, 'Payments.LBL_LIST_PAYMENT_TYPE'           , 'PaymentMethod'             , 'PaymentMethod'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView.QuickBooksOnline',  6, 'Payments.LBL_LIST_AMOUNT'                 , 'TotalAmt'                  , 'TotalAmt'                  , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView.QuickBooksOnline',  7, 'Payments.LBL_LIST_PAYMENT_DATE'           , 'TxnDate'                   , 'TxnDate'                   , '10%', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.ListView.QuickBooksOnline',  8, 'Payments.LBL_LIST_DEPOSIT_ACCOUNT'        , 'DepositToAccount'          , 'TxnDate'                   , '5%';
end -- if;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'CreditMemos.ListView.QuickBooksOnline';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'CreditMemos.ListView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS CreditMemos.ListView.QuickBooksOnline';
	exec dbo.spGRIDVIEWS_InsertOnly           'CreditMemos.ListView.QuickBooksOnline', 'Payments', 'vwCREDIT_MEMOS_QBOnline';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'CreditMemos.ListView.QuickBooksOnline',  2, '.LBL_LIST_ID'                             , 'Id'                        , 'Id'                        , '5%' , 'listViewTdLinkS1', 'Id'      , '~/Payments/CreditMemos/QuickBooks/view.aspx?QID={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'CreditMemos.ListView.QuickBooksOnline',  3, 'Payments.LBL_LIST_PAYMENT_NUM'            , 'DocNumber'                 , 'DocNumber'                 , '10%', 'listViewTdLinkS1', 'Id'      , '~/Payments/CreditMemos/QuickBooks/view.aspx?QID={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'CreditMemos.ListView.QuickBooksOnline',  4, 'Payments.LBL_LIST_ACCOUNT_NAME'           , 'CustomerName'              , 'CustomerName'              , '15%', 'listViewTdLinkS1', 'Customer', '~/Accounts/QuickBooks/view.aspx?QID={0}' , null, null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'CreditMemos.ListView.QuickBooksOnline',  5, 'Payments.LBL_LIST_PAYMENT_TYPE'           , 'PaymentMethod'             , 'PaymentMethod'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'CreditMemos.ListView.QuickBooksOnline',  6, 'Payments.LBL_LIST_AMOUNT'                 , 'TotalAmt'                  , 'TotalAmt'                  , '10%', 'Currency';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'CreditMemos.ListView.QuickBooksOnline',  7, 'Payments.LBL_LIST_PAYMENT_DATE'           , 'TxnDate'                   , 'TxnDate'                   , '10%', 'Date';
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

call dbo.spGRIDVIEWS_COLUMNS_QBOnline()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_QBOnline')
/

-- #endif IBM_DB2 */


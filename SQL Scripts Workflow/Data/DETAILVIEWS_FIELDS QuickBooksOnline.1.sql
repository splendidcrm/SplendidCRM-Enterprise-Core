

print 'DETAILVIEWS_FIELDS QuickBooksOnline';
GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME like '%.DetailView.QuickBooksOnline';

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Accounts.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'Accounts.DetailView.QuickBooksOnline', 'Accounts', 'vwACCOUNTS_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline',  0, '.LBL_ID'                         , 'Id'                               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline',  1, 'Accounts.LBL_WEBSITE'            , 'WebAddr'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline',  2, 'Accounts.LBL_ACCOUNT_NAME'       , 'Name'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline',  3, 'Contacts.LBL_MOBILE_PHONE'       , 'Mobile'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline',  4, 'Accounts.LBL_PHONE'              , 'PrimaryPhone'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline',  5, 'Accounts.LBL_FAX'                , 'Fax'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.QuickBooksOnline',  6, 'Accounts.LBL_EMAIL'              , 'PrimaryEmailAddr'                 , '{0}', 'PrimaryEmailAddr'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline',  7, 'Accounts.LBL_OTHER_PHONE'        , 'AlternatePhone'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline',  8, '.LBL_DATE_MODIFIED'              , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline',  9, '.LBL_DATE_ENTERED'               , 'TimeCreated'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline', 10, 'Contacts.LBL_PRIMARY_ADDRESS'    , 'BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry'      , '{0}<br />{1}<br />{2}, {3} {4}<br />{5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooksOnline', 11, 'Contacts.LBL_ALTERNATE_ADDRESS'  , 'ShippingLine1 ShippingLine2 ShippingCity ShippingState ShippingPostalCode ShippingCountry', '{0}<br />{1}<br />{2}, {3} {4}<br />{5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Accounts.DetailView.QuickBooksOnline', 12, 'TextBox', 'Accounts.LBL_DESCRIPTION', 'Notes', null, null, null, null, null, 3, null;
end -- if;
GO

-- 06/22/2014 Paul.  Treat contacts just like accounts. Both point to customers. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contacts.DetailView.QuickBooksOnline', 'Contacts', 'vwCONTACTS_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline',  0, '.LBL_ID'                         , 'Id'                               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline',  1, 'Accounts.LBL_WEBSITE'            , 'WebAddr'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline',  2, 'Contacts.LBL_FIRST_NAME'         , 'FirstName'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline',  3, 'Contacts.LBL_LAST_NAME'          , 'LastName'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline',  4, 'Contacts.LBL_PHONE'              , 'PrimaryPhone'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline',  5, 'Contacts.LBL_MOBILE_PHONE'       , 'Mobile'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.QuickBooksOnline',  6, 'Contacts.LBL_EMAIL1'             , 'PrimaryEmailAddr'                 , '{0}', 'PrimaryEmailAddr'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline',  7, 'Contacts.LBL_FAX_PHONE'          , 'Fax'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline',  8, '.LBL_DATE_MODIFIED'              , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline',  9, '.LBL_DATE_ENTERED'               , 'TimeCreated'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline', 10, 'Contacts.LBL_PRIMARY_ADDRESS'    , 'BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry'      , '{0}<br />{1}<br />{2}, {3} {4}<br />{5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooksOnline', 11, 'Contacts.LBL_ALTERNATE_ADDRESS'  , 'ShippingLine1 ShippingLine2 ShippingCity ShippingState ShippingPostalCode ShippingCountry', '{0}<br />{1}<br />{2}, {3} {4}<br />{5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contacts.DetailView.QuickBooksOnline', 12, 'TextBox', 'Contacts.LBL_DESCRIPTION', 'Notes', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.DetailView.QuickBooksOnline', 'Invoices', 'vwINVOICES_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline',  0, '.LBL_ID'                           , 'Id'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline',  1, 'Invoices.LBL_DESCRIPTION'          , 'CustomerMemo'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline',  2, 'Invoices.LBL_INVOICE_NUM'          , 'DocNumber'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline',  3, 'Invoices.LBL_DUE_DATE'             , 'DueDate'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline',  4, 'Invoices.LBL_LIST_AMOUNT'          , 'TotalAmt'                          , '{0:c}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline',  5, 'Invoices.LBL_LIST_AMOUNT_DUE'      , 'Balance'                           , '{0:c}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline',  6, '.LBL_DATE_ENTERED'                 , 'TimeCreated'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline',  7, '.LBL_DATE_MODIFIED'                , 'TimeModified'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.QuickBooksOnline',  8, 'Invoices.LBL_BILLING_ACCOUNT_NAME' , 'CustomerName'                      , '{0}', 'Customer', '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.DetailView.QuickBooksOnline',  9, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline', 10, 'Invoices.LBL_BILLING_ADDRESS'      , 'BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry'      , '{0}<br />{1}<br />{2}, {3} {4}<br />{5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooksOnline', 11, 'Invoices.LBL_SHIPPING_ADDRESS'     , 'ShippingLine1 ShippingLine2 ShippingCity ShippingState ShippingPostalCode ShippingCountry', '{0}<br />{1}<br />{2}, {3} {4}<br />{5}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.SummaryView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.SummaryView.QuickBooksOnline', 'Invoices', 'vwINVOICES_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.QuickBooksOnline',  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.QuickBooksOnline',  1, 'Invoices.LBL_SUBTOTAL'            , 'Subtotal'                           , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.QuickBooksOnline',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.QuickBooksOnline',  3, 'Invoices.LBL_TAX'                 , 'Tax'                                , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.QuickBooksOnline',  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.QuickBooksOnline',  5, 'Invoices.LBL_TOTAL'               , 'Amount'                             , '{0:c}'      , null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.DetailView.QuickBooksOnline'   , 'Quotes', 'vwQuotes_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   ,  0, '.LBL_ID'                         , 'Id'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   ,  1, 'Quotes.LBL_DESCRIPTION'          , 'CustomerMemo'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   ,  2, 'Quotes.LBL_QUOTE_NUM'            , 'DocNumber'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   ,  3, 'Quotes.LBL_DUE_DATE'             , 'DueDate'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   ,  4, 'Quotes.LBL_LIST_AMOUNT'          , 'TotalAmt'                          , '{0:c}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   ,  5, 'Quotes.LBL_PAYMENT_TERMS'        , 'TxnStatus'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   ,  6, 'Quotes.LBL_DATE_VALID_UNTIL'     , 'ExpirationDate'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   ,  7, '.LBL_DATE_ENTERED'               , 'TimeCreated'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   ,  8, '.LBL_DATE_MODIFIED'              , 'TimeModified'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.QuickBooksOnline'   ,  9, 'Quotes.LBL_BILLING_ACCOUNT_NAME' , 'CustomerName'                      , '{0}', 'CustomerId' , '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.DetailView.QuickBooksOnline'   , 10, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   , 11, 'Quotes.LBL_BILLING_ADDRESS'      , 'BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry'      , '{0}<br />{1}<br />{2}, {3} {4}<br />{5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooksOnline'   , 12, 'Quotes.LBL_SHIPPING_ADDRESS'     , 'ShippingLine1 ShippingLine2 ShippingCity ShippingState ShippingPostalCode ShippingCountry', '{0}<br />{1}<br />{2}, {3} {4}<br />{5}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.SummaryView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.SummaryView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.SummaryView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.SummaryView.QuickBooksOnline', 'Quotes', 'vwQuotes_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.QuickBooksOnline',  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.QuickBooksOnline',  1, 'Quotes.LBL_SUBTOTAL'            , 'Subtotal'                           , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.QuickBooksOnline',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.QuickBooksOnline',  3, 'Quotes.LBL_TAX'                 , 'Tax'                                , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.QuickBooksOnline',  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.QuickBooksOnline',  5, 'Quotes.LBL_TOTAL'               , 'TotalAmount'                        , '{0:c}'      , null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TaxRates.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TaxRates.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS TaxRates.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'TaxRates.DetailView.QuickBooksOnline', 'TaxRates', 'vwTAX_RATES_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooksOnline',  0, '.LBL_ID'                           , 'Id'                               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooksOnline',  1, 'TaxRates.LBL_STATUS'               , 'Active'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooksOnline',  2, 'TaxRates.LBL_NAME'                 , 'Name'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooksOnline',  3, 'TaxRates.LBL_VALUE'                , 'RateValue'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooksOnline',  4, 'TaxRates.LBL_QUICKBOOKS_TAX_VENDOR', 'Agency'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'TaxRates.DetailView.QuickBooksOnline',  5, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooksOnline',  6, '.LBL_DATE_MODIFIED'                , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooksOnline',  7, '.LBL_DATE_ENTERED'                 , 'TimeCreated'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'TaxRates.DetailView.QuickBooksOnline',  8, 'TextBox', 'TaxRates.LBL_DESCRIPTION', 'Description', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TaxCodes.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TaxCodes.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS TaxCodes.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'TaxCodes.DetailView.QuickBooksOnline', 'TaxRates', 'vwTAX_CODES_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooksOnline',  0, '.LBL_ID'                           , 'Id'                               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxCodes.DetailView.QuickBooksOnline',  1, 'TaxRates.LBL_STATUS'               , 'Active'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxCodes.DetailView.QuickBooksOnline',  2, 'TaxRates.LBL_NAME'                 , 'Name'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxCodes.DetailView.QuickBooksOnline',  3, 'TaxRates.LBL_QUICKBOOKS_TAX_VENDOR', 'TaxRateRef'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxCodes.DetailView.QuickBooksOnline',  4, '.LBL_DATE_MODIFIED'                , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxCodes.DetailView.QuickBooksOnline',  5, '.LBL_DATE_ENTERED'                 , 'TimeCreated'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'TaxCodes.DetailView.QuickBooksOnline',  6, 'TextBox', 'TaxRates.LBL_DESCRIPTION', 'Description', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ProductTemplates.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'ProductTemplates.DetailView.QuickBooksOnline', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  0, 'ProductTemplates.LBL_NAME'                 , 'Name'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  1, 'ProductTemplates.LBL_DESCRIPTION'          , 'Description'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  2, 'ProductTemplates.LBL_TYPE'                 , 'Type'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  3, 'ProductTemplates.LBL_QUICKBOOKS_ACCOUNT'   , 'IncomeAccount'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  4, 'ProductTemplates.LBL_STATUS'               , 'Active'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  5, 'ProductTemplates.LBL_QUANTITY'             , 'QtyOnHand'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  6, 'ProductTemplates.LBL_LIST_PRICE'           , 'UnitPrice'                        , '{0:c}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  7, 'ProductTemplates.LBL_COST_PRICE'           , 'PurchaseCost'                     , '{0:c}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  8, 'ProductTemplates.LBL_TAX_CLASS'            , 'Taxable'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline',  9, '.LBL_DATE_MODIFIED'                        , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooksOnline', 10, '.LBL_DATE_ENTERED'                         , 'TimeCreated'                      , '{0}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PaymentTypes.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PaymentTypes.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS PaymentTypes.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'PaymentTypes.DetailView.QuickBooksOnline', 'PaymentTypes', 'vwPAYMENT_TYPES_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentTypes.DetailView.QuickBooksOnline',  0, 'PaymentTypes.LBL_NAME'             , 'Name'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentTypes.DetailView.QuickBooksOnline',  1, 'PaymentTypes.LBL_STATUS'           , 'Active'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentTypes.DetailView.QuickBooksOnline',  2, '.LBL_DATE_MODIFIED'                , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentTypes.DetailView.QuickBooksOnline',  3, '.LBL_DATE_ENTERED'                 , 'TimeCreated'                      , '{0}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Payments.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'Payments.DetailView.QuickBooksOnline', 'Payments', 'vwPAYMENTS_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.QuickBooksOnline',  0, 'Payments.LBL_AMOUNT'                       , 'TotalAmt'                         , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.QuickBooksOnline',  1, 'Payments.LBL_PAYMENT_DATE'                 , 'TxnDate'                          , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Payments.DetailView.QuickBooksOnline',  2, 'Payments.LBL_ACCOUNT_NAME'                 , 'CustomerName'                     , '{0}'        , 'Customer' , '~/Accounts/QuickBooks/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.QuickBooksOnline',  3, 'Payments.LBL_PAYMENT_TYPE'                 , 'PaymentMethod'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.QuickBooksOnline',  4, '.LBL_DATE_MODIFIED'                        , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.QuickBooksOnline',  5, '.LBL_DATE_ENTERED'                         , 'TimeCreated'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.QuickBooksOnline',  6, 'Payments.LBL_DEPOSIT_ACCOUNT'              , 'DepositToAccount'                 , '{0}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'CreditMemos.DetailView.QuickBooksOnline';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'CreditMemos.DetailView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS CreditMemos.DetailView.QuickBooksOnline';
	exec dbo.spDETAILVIEWS_InsertOnly          'CreditMemos.DetailView.QuickBooksOnline', 'Payments', 'vwCREDIT_MEMOS_QBOnline', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditMemos.DetailView.QuickBooksOnline',  0, 'Payments.LBL_AMOUNT'                       , 'TotalAmt'                         , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditMemos.DetailView.QuickBooksOnline',  1, 'Payments.LBL_PAYMENT_DATE'                 , 'TxnDate'                          , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'CreditMemos.DetailView.QuickBooksOnline',  2, 'Payments.LBL_ACCOUNT_NAME'                 , 'CustomerName'                     , '{0}'        , 'Customer' , '~/Accounts/QuickBooks/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditMemos.DetailView.QuickBooksOnline',  3, 'Payments.LBL_PAYMENT_TYPE'                 , 'PaymentMethod'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditMemos.DetailView.QuickBooksOnline',  4, '.LBL_DATE_MODIFIED'                        , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditMemos.DetailView.QuickBooksOnline',  5, '.LBL_DATE_ENTERED'                         , 'TimeCreated'                      , '{0}', null;
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

call dbo.spDETAILVIEWS_FIELDS_QBOnline()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_QBOnline')
/

-- #endif IBM_DB2 */


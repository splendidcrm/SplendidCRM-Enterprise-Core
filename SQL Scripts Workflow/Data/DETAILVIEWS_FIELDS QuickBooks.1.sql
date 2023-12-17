

print 'DETAILVIEWS_FIELDS QuickBooks';
GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Accounts.DetailView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'Accounts.DetailView.QuickBooks', 'Accounts', 'vwACCOUNTS_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooks',  0, 'Accounts.LBL_ACCOUNT_NAME'       , 'Name'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooks',  1, '.moduleListSingular.Contacts'    , 'Contact'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooks',  2, 'Accounts.LBL_PHONE'              , 'Phone'                            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooks',  3, 'Accounts.LBL_FAX'                , 'Fax'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.QuickBooks',  4, 'Accounts.LBL_EMAIL'              , 'Email'                            , '{0}', 'EMAIL1'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooks',  5, 'Accounts.LBL_OTHER_PHONE'        , 'AlternatePhone'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooks',  6, '.LBL_DATE_MODIFIED'              , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooks',  7, '.LBL_DATE_ENTERED'               , 'TimeCreated'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooks',  8, 'Accounts.LBL_BILLING_ADDRESS'    , 'BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry'      , '{0}<br />{1}<br />{2}, {3} {4} {5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.QuickBooks',  9, 'Accounts.LBL_SHIPPING_ADDRESS'   , 'ShippingLine1 ShippingLine2 ShippingCity ShippingState ShippingPostalCode ShippingCountry', '{0}<br />{1}<br />{2}, {3} {4} {5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Accounts.DetailView.QuickBooks', 10, 'TextBox', 'Accounts.LBL_DESCRIPTION', 'Notes', null, null, null, null, null, 3, null;
end -- if;
GO

-- 06/22/2014 Paul.  Treat contacts just like accounts. Both point to customers. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contacts.DetailView.QuickBooks', 'Contacts', 'vwCONTACTS_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooks',  0, 'Contacts.LBL_FIRST_NAME'         , 'FirstName'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooks',  1, 'Contacts.LBL_LAST_NAME'          , 'LastName'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooks',  2, 'Contacts.LBL_PHONE'              , 'Phone'                            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooks',  3, 'Contacts.LBL_FAX_PHONE'          , 'Fax'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.QuickBooks',  4, 'Contacts.LBL_EMAIL1'             , 'Email'                            , '{0}', 'EMAIL1'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooks',  5, 'Contacts.LBL_OTHER_PHONE'        , 'AlternatePhone'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooks',  6, '.LBL_DATE_MODIFIED'              , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooks',  7, '.LBL_DATE_ENTERED'               , 'TimeCreated'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooks',  8, 'Contacts.LBL_PRIMARY_ADDRESS'    , 'BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry'      , '{0}<br />{1}<br />{2}, {3} {4} {5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.QuickBooks',  9, 'Contacts.LBL_ALTERNATE_ADDRESS'  , 'ShippingLine1 ShippingLine2 ShippingCity ShippingState ShippingPostalCode ShippingCountry', '{0}<br />{1}<br />{2}, {3} {4} {5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contacts.DetailView.QuickBooks', 10, 'TextBox', 'Contacts.LBL_DESCRIPTION', 'Notes', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.DetailView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.DetailView.QuickBooks', 'Invoices', 'vwINVOICES_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooks',  0, 'Invoices.LBL_NAME'                 , 'ReferenceNumber'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.DetailView.QuickBooks',  1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooks',  2, 'Invoices.LBL_INVOICE_STAGE'        , 'IsPending'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooks',  3, 'Invoices.LBL_PAYMENT_TERMS'        , 'Terms'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooks',  4, 'Invoices.LBL_DUE_DATE'             , 'DueDate'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooks',  5, 'Invoices.LBL_PURCHASE_ORDER_NUM'   , 'POnumber'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooks',  6, '.LBL_DATE_ENTERED'                 , 'TimeCreated'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooks',  7, '.LBL_DATE_MODIFIED'                , 'TimeModified'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.QuickBooks',  8, 'Invoices.LBL_BILLING_ACCOUNT_NAME' , 'CustomerName'                      , '{0}', 'CustomerId' , '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.DetailView.QuickBooks',  9, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooks', 10, 'Invoices.LBL_BILLING_ADDRESS'      , 'BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry'      , '{0}<br />{1}<br />{2}, {3} {4} {5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.QuickBooks', 11, 'Invoices.LBL_SHIPPING_ADDRESS'     , 'ShippingLine1 ShippingLine2 ShippingCity ShippingState ShippingPostalCode ShippingCountry', '{0}<br />{1}<br />{2}, {3} {4} {5}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.SummaryView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.SummaryView.QuickBooks', 'Invoices', 'vwINVOICES_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.QuickBooks',  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.QuickBooks',  1, 'Invoices.LBL_SUBTOTAL'            , 'Subtotal'                           , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.QuickBooks',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.QuickBooks',  3, 'Invoices.LBL_TAX'                 , 'Tax'                                , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.QuickBooks',  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.QuickBooks',  5, 'Invoices.LBL_TOTAL'               , 'Amount'                             , '{0:c}'      , null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.DetailView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.DetailView.QuickBooks', 'Orders', 'vwOrders_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.QuickBooks',  0, 'Orders.LBL_NAME'                   , 'ReferenceNumber'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.DetailView.QuickBooks',  1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.QuickBooks',  2, 'Orders.LBL_DATE_ORDER_SHIPPED'     , 'ShipDate'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.QuickBooks',  3, 'Orders.LBL_PAYMENT_TERMS'          , 'Terms'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.QuickBooks',  4, 'Orders.LBL_DATE_ORDER_DUE'         , 'DueDate'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.QuickBooks',  5, 'Orders.LBL_PURCHASE_ORDER_NUM'     , 'POnumber'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.QuickBooks',  6, '.LBL_DATE_ENTERED'                 , 'TimeCreated'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.QuickBooks',  7, '.LBL_DATE_MODIFIED'                , 'TimeModified'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.QuickBooks',  8, 'Orders.LBL_BILLING_ACCOUNT_NAME'   , 'CustomerName'                      , '{0}', 'CustomerId' , '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.DetailView.QuickBooks',  9, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.QuickBooks', 10, 'Orders.LBL_BILLING_ADDRESS'        , 'BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry'      , '{0}<br />{1}<br />{2}, {3} {4} {5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.QuickBooks', 11, 'Orders.LBL_SHIPPING_ADDRESS'       , 'ShippingLine1 ShippingLine2 ShippingCity ShippingState ShippingPostalCode ShippingCountry', '{0}<br />{1}<br />{2}, {3} {4} {5}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.SummaryView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.SummaryView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.SummaryView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.SummaryView.QuickBooks', 'Orders', 'vwOrders_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.QuickBooks',  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.QuickBooks',  1, 'Orders.LBL_SUBTOTAL'            , 'Subtotal'                           , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.QuickBooks',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.QuickBooks',  3, 'Orders.LBL_TAX'                 , 'Tax'                                , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.QuickBooks',  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.QuickBooks',  5, 'Orders.LBL_TOTAL'               , 'TotalAmount'                        , '{0:c}'      , null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.DetailView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.DetailView.QuickBooks', 'Quotes', 'vwQuotes_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooks',  0, 'Quotes.LBL_NAME'                   , 'ReferenceNumber'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooks',  1, 'Quotes.LBL_PAYMENT_TERMS'          , 'Terms'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooks',  2, 'Quotes.LBL_DATE_VALID_UNTIL'       , 'Date'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooks',  3, 'Quotes.LBL_PURCHASE_ORDER_NUM'     , 'POnumber'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooks',  4, '.LBL_DATE_ENTERED'                 , 'TimeCreated'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooks',  5, '.LBL_DATE_MODIFIED'                , 'TimeModified'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.QuickBooks',  6, 'Quotes.LBL_BILLING_ACCOUNT_NAME'   , 'CustomerName'                      , '{0}', 'CustomerId' , '~/Accounts/QuickBooks/view.aspx?QID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.DetailView.QuickBooks',  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.QuickBooks',  8, 'Quotes.LBL_BILLING_ADDRESS'        , 'BillingLine1 BillingLine2 BillingCity BillingState BillingPostalCode BillingCountry'      , '{0}<br />{1}<br />{2}, {3} {4} {5}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.DetailView.QuickBooks',  9, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.SummaryView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.SummaryView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.SummaryView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.SummaryView.QuickBooks', 'Quotes', 'vwQuotes_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.QuickBooks',  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.QuickBooks',  1, 'Quotes.LBL_SUBTOTAL'            , 'Subtotal'                           , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.QuickBooks',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.QuickBooks',  3, 'Quotes.LBL_TAX'                 , 'Tax'                                , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.QuickBooks',  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.QuickBooks',  5, 'Quotes.LBL_TOTAL'               , 'TotalAmount'                        , '{0:c}'      , null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TaxRates.DetailView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TaxRates.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS TaxRates.DetailView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'TaxRates.DetailView.QuickBooks', 'TaxRates', 'vwTAX_RATES_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooks',  0, 'TaxRates.LBL_NAME'                 , 'Name'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooks',  1, 'TaxRates.LBL_VALUE'                , 'RateValue'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooks',  2, 'TaxRates.LBL_QUICKBOOKS_TAX_VENDOR', 'Agency'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooks',  3, 'TaxRates.LBL_STATUS'               , 'Active'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooks',  4, '.LBL_DATE_MODIFIED'                , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView.QuickBooks',  5, '.LBL_DATE_ENTERED'                 , 'TimeCreated'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'TaxRates.DetailView.QuickBooks',  6, 'TextBox', 'TaxRates.LBL_DESCRIPTION', 'Description', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView.QuickBooks';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView.QuickBooks' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ProductTemplates.DetailView.QuickBooks';
	exec dbo.spDETAILVIEWS_InsertOnly          'ProductTemplates.DetailView.QuickBooks', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_QuickBooks', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  0, 'ProductTemplates.LBL_NAME'                 , 'Name'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  1, 'ProductTemplates.LBL_DESCRIPTION'          , 'Description'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  2, 'ProductTemplates.LBL_TYPE'                 , 'Type'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  3, 'ProductTemplates.LBL_QUICKBOOKS_ACCOUNT'   , 'IncomeAccount'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  4, 'ProductTemplates.LBL_STATUS'               , 'Active'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  5, 'ProductTemplates.LBL_QUANTITY'             , 'QtyOnHand'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  6, 'ProductTemplates.LBL_LIST_PRICE'           , 'UnitPrice'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  7, 'ProductTemplates.LBL_COST_PRICE'           , 'PurchaseCost'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  8, 'ProductTemplates.LBL_TAX_CLASS'            , 'Taxable'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks',  9, '.LBL_DATE_MODIFIED'                        , 'TimeModified'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.QuickBooks', 10, '.LBL_DATE_ENTERED'                         , 'TimeCreated'                      , '{0}', null;
end -- if;
GO

-- 02/24/2021 Paul.  Add support for React client. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'QuickBooks.ConfigView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'QuickBooks.ConfigView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS QuickBooks.ConfigView';
	exec dbo.spDETAILVIEWS_InsertOnly            'QuickBooks.ConfigView', 'QuickBooks', 'vwCONFIG_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      ,  0, 'QuickBooks.LBL_ENABLED'                 , 'QuickBooks.Enabled'               , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      ,  1, 'QuickBooks.LBL_VERBOSE_STATUS'          , 'QuickBooks.VerboseStatus'         , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList   'QuickBooks.ConfigView'      ,  2, 'QuickBooks.LBL_QUICKBOOKS_APP'          , 'QuickBooks.AppMode'               , '{0}', 'quickbooks_app_mode', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  3, 'QuickBooks.LBL_REMOTE_USER'             , 'QuickBooks.RemoteUser'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  4, 'QuickBooks.LBL_REMOTE_URL'              , 'QuickBooks.RemoteURL'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  5, 'QuickBooks.LBL_REMOTE_PASSWORD'         , 'QuickBooks.RemotePassword'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  6, 'QuickBooks.LBL_REMOTE_APPLICATION'      , 'QuickBooks.RemoteApplicationName' , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  7, 'QuickBooks.LBL_OAUTH_COMPANY_ID'        , 'QuickBooks.OAuthCompanyID'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  8, 'QuickBooks.LBL_OAUTH_COUNTRY_CODE'      , 'QuickBooks.OAuthCountryCode'      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  9, 'QuickBooks.LBL_OAUTH_CLIENT_ID'         , 'QuickBooks.OAuthClientID'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 10, 'QuickBooks.LBL_OAUTH_ACCESS_TOKEN'      , 'QuickBooks.OAuthAccessToken'      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 11, 'QuickBooks.LBL_OAUTH_CLIENT_SECRET'     , 'QuickBooks.OAuthClientSecret'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 12, 'QuickBooks.LBL_OAUTH_ACCESS_SECRET'     , 'QuickBooks.OAuthAccessTokenSecret', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 13, 'QuickBooks.LBL_OAUTH_VERIFIER'          , 'QuickBooks.OAuthVerifier'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 14, 'QuickBooks.LBL_OAUTH_EXPIRES_AT'        , 'QuickBooks.OAuthExpiresAt'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList   'QuickBooks.ConfigView'      , 15, 'QuickBooks.LBL_DIRECTION'               , 'QuickBooks.Direction'             , '{0}', 'quickbooks_sync_direction', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList   'QuickBooks.ConfigView'      , 16, 'QuickBooks.LBL_CONFLICT_RESOLUTION'     , 'QuickBooks.ConflictResolution'    , '{0}', 'sync_conflict_resolution' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 17, 'QuickBooks.LBL_SYNC_QUOTES'             , 'QuickBooks.SyncQuotes'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 18, 'QuickBooks.LBL_SYNC_ORDERS'             , 'QuickBooks.SyncOrders'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 19, 'QuickBooks.LBL_SYNC_INVOICES'           , 'QuickBooks.SyncInvoices'          , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 20, 'QuickBooks.LBL_SYNC_PAYMENTS'           , 'QuickBooks.SyncPayments'          , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 21, 'QuickBooks.LBL_PAYMENTS_DEPOSIT_ACCOUNT', 'QuickBooks.PaymentsDepositAccount', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 22, 'QuickBooks.LBL_SYNC_CREDIT_MEMOS'       , 'QuickBooks.SyncCreditMemos'       , null;
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

call dbo.spDETAILVIEWS_FIELDS_QuickBooks()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_QuickBooks')
/

-- #endif IBM_DB2 */


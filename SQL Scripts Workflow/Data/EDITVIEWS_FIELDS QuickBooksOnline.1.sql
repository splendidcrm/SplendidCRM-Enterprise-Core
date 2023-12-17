

print 'EDITVIEWS_FIELDS QuickBooksOnline';
GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'Accounts.EditView.QuickBooksOnline', 'Accounts', 'vwACCOUNTS_QBOnline', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline',  0, 'Accounts.LBL_ACCOUNT_NAME'              , 'Name'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline',  1, '.moduleListSingular.Contacts'           , 'Contact'                    , 0, 2,  41, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline',  2, 'Accounts.LBL_PHONE'                     , 'Phone'                      , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline',  3, 'Accounts.LBL_FAX'                       , 'Fax'                        , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline',  4, 'Accounts.LBL_EMAIL'                     , 'Email'                      , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline',  5, 'Accounts.LBL_OTHER_PHONE'               , 'AlternatePhone'             , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Accounts.EditView.QuickBooksOnline',  6;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline',  7, 'Accounts.LBL_BILLING_ADDRESS_STREET'    , 'BillingLine1'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline',  8, 'Accounts.LBL_SHIPPING_ADDRESS_STREET'   , 'ShippingLine1'              , 0, 4, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline',  9, null                                     , 'BillingLine2'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 10, null                                     , 'ShippingLine2'              , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 11, null                                     , 'BillingLine3'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 12, null                                     , 'ShippingLine3'              , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 13, 'Accounts.LBL_CITY'                      , 'BillingCity'                , 0, 3, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 14, 'Accounts.LBL_CITY'                      , 'ShippingCity'               , 0, 4, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 15, 'Accounts.LBL_STATE'                     , 'BillingState'               , 0, 3, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 16, 'Accounts.LBL_STATE'                     , 'ShippingState'              , 0, 4, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 17, 'Accounts.LBL_POSTAL_CODE'               , 'BillingPostalCode'          , 0, 3,  30, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 18, 'Accounts.LBL_POSTAL_CODE'               , 'ShippingPostalCode'         , 0, 4,  30, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 19, 'Accounts.LBL_COUNTRY'                   , 'BillingCountry'             , 0, 3, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooksOnline', 20, 'Accounts.LBL_COUNTRY'                   , 'ShippingCountry'            , 0, 4, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Accounts.EditView.QuickBooksOnline', 21;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditView.QuickBooksOnline', 22, 'Accounts.LBL_DESCRIPTION'               , 'Notes'                      , 0, 5,   8, 60, 3;

	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Accounts.EditView.QuickBooksOnline',  4, 'Email Address'                          , 'Email'                      , '.ERR_INVALID_EMAIL_ADDRESS';
end -- if;
GO

-- 06/22/2014 Paul.  Treat contacts just like accounts. Both point to customers. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'Contacts.EditView.QuickBooksOnline', 'Contacts', 'vwCONTACTS_QBOnline', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline',  0, 'Contacts.LBL_FIRST_NAME'                , 'FirstName'                  , 0, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline',  1, 'Contacts.LBL_LAST_NAME'                 , 'LastName'                   , 1, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline',  2, 'Contacts.LBL_PHONE'                     , 'Phone'                      , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline',  3, 'Contacts.LBL_FAX_PHONE'                 , 'Fax'                        , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline',  4, 'Contacts.LBL_EMAIL1'                    , 'Email'                      , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline',  5, 'Contacts.LBL_OTHER_PHONE'               , 'AlternatePhone'             , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Contacts.EditView.QuickBooksOnline',  6;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline',  7, 'Contacts.LBL_PRIMARY_ADDRESS_STREET'    , 'BillingLine1'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline',  8, 'Contacts.LBL_ALT_ADDRESS_STREET'        , 'ShippingLine1'              , 0, 4, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline',  9, null                                     , 'BillingLine2'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 10, null                                     , 'ShippingLine2'              , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 11, null                                     , 'BillingLine3'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 12, null                                     , 'ShippingLine3'              , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 13, 'Contacts.LBL_CITY'                      , 'BillingCity'                , 0, 3, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 14, 'Contacts.LBL_CITY'                      , 'ShippingCity'               , 0, 4, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 15, 'Contacts.LBL_STATE'                     , 'BillingState'               , 0, 3, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 16, 'Contacts.LBL_STATE'                     , 'ShippingState'              , 0, 4, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 17, 'Contacts.LBL_POSTAL_CODE'               , 'BillingPostalCode'          , 0, 3,  30, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 28, 'Contacts.LBL_POSTAL_CODE'               , 'ShippingPostalCode'         , 0, 4,  30, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 29, 'Contacts.LBL_COUNTRY'                   , 'BillingCountry'             , 0, 3, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooksOnline', 20, 'Contacts.LBL_COUNTRY'                   , 'ShippingCountry'            , 0, 4, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditView.QuickBooksOnline', 22, 'Contacts.LBL_DESCRIPTION'               , 'Notes'                      , 0, 5,   8, 60, null;

	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Contacts.EditView.QuickBooksOnline',  4, 'Email Address'                          , 'Email'                      , '.ERR_INVALID_EMAIL_ADDRESS';
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditView.QuickBooksOnline', 'Invoices', 'vwInvoices_QBOnline', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline',  0, 'Invoices.LBL_INVOICE_NUM'               , 'DocNumber'                  , 0, 1,  11, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline',  1, 'Invoices.LBL_DESCRIPTION'               , 'CustomerMemo'               , 0, 1,  11, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline',  2, 'Invoices.LBL_BILLING_ACCOUNT_NAME'      , 'Customer'                   , 1, 1,  11, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.QuickBooksOnline',  3, 'Invoices.LBL_DUE_DATE'                  , 'DueDate'                    , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline',  4, 'Invoices.LBL_BILLING_ADDRESS_STREET'    , 'BillingLine1'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline',  5, 'Invoices.LBL_SHIPPING_ADDRESS_STREET'   , 'ShippingLine1'              , 0, 4,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline',  6, null                                     , 'BillingLine2'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline',  7, null                                     , 'ShippingLine2'              , 0, 4,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline',  8, null                                     , 'BillingLine3'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline',  9, null                                     , 'ShippingLine3'              , 0, 4,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline', 10, 'Invoices.LBL_CITY'                      , 'BillingCity'                , 0, 3,  31, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline', 11, 'Invoices.LBL_CITY'                      , 'ShippingCity'               , 0, 4,  31, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline', 12, 'Invoices.LBL_STATE'                     , 'BillingState'               , 0, 3,  21, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline', 13, 'Invoices.LBL_STATE'                     , 'ShippingState'              , 0, 4,  21, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline', 14, 'Invoices.LBL_POSTAL_CODE'               , 'BillingPostalCode'          , 0, 3,  13, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline', 15, 'Invoices.LBL_POSTAL_CODE'               , 'ShippingPostalCode'         , 0, 4,  13, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline', 16, 'Invoices.LBL_COUNTRY'                   , 'BillingCountry'             , 0, 3,  31, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooksOnline', 17, 'Invoices.LBL_COUNTRY'                   , 'ShippingCountry'            , 0, 4,  31, 15, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditView.QuickBooksOnline'  , 'Quotes', 'vwQUOTES_QBOnline', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  ,  0, 'Quotes.LBL_INVOICE_NUM'                 , 'DocNumber'                  , 0, 1,  11, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  ,  1, 'Quotes.LBL_DESCRIPTION'                 , 'CustomerMemo'               , 0, 1,  11, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  ,  2, 'Quotes.LBL_BILLING_ACCOUNT_NAME'        , 'Customer'                   , 1, 1,  11, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.QuickBooksOnline'  ,  3, 'Quotes.LBL_DUE_DATE'                    , 'DueDate'                    , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  ,  4, 'Quotes.LBL_BILLING_ADDRESS_STREET'      , 'BillingLine1'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  ,  5, 'Quotes.LBL_SHIPPING_ADDRESS_STREET'     , 'ShippingLine1'              , 0, 4,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  ,  6, null                                     , 'BillingLine2'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  ,  7, null                                     , 'ShippingLine2'              , 0, 4,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  ,  8, null                                     , 'BillingLine3'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  ,  9, null                                     , 'ShippingLine3'              , 0, 4,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  , 10, 'Quotes.LBL_CITY'                        , 'BillingCity'                , 0, 3,  31, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  , 11, 'Quotes.LBL_CITY'                        , 'ShippingCity'               , 0, 4,  31, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  , 12, 'Quotes.LBL_STATE'                       , 'BillingState'               , 0, 3,  21, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  , 13, 'Quotes.LBL_STATE'                       , 'ShippingState'              , 0, 4,  21, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  , 14, 'Quotes.LBL_POSTAL_CODE'                 , 'BillingPostalCode'          , 0, 3,  13, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  , 15, 'Quotes.LBL_POSTAL_CODE'                 , 'ShippingPostalCode'         , 0, 4,  13, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  , 16, 'Quotes.LBL_COUNTRY'                     , 'BillingCountry'             , 0, 3,  31, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooksOnline'  , 17, 'Quotes.LBL_COUNTRY'                     , 'ShippingCountry'            , 0, 4,  31, 15, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'TaxRates.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TaxRates.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS TaxRates.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'TaxRates.EditView.QuickBooksOnline', 'TaxRates', 'vwTAX_RATES_QBOnline', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView.QuickBooksOnline',  0, 'TaxRates.LBL_NAME'                      , 'Name'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView.QuickBooksOnline',  1, 'TaxRates.LBL_VALUE'                     , 'RateValue'                  , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView.QuickBooksOnline',  2, 'TaxRates.LBL_QUICKBOOKS_TAX_VENDOR'     , 'Agency'                     , 0, 1,  20, 40, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'TaxRates.EditView.QuickBooksOnline',  3, 'TaxRates.LBL_STATUS'                    , 'Active'                     , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView.QuickBooksOnline',  4, 'TaxRates.LBL_DESCRIPTION'               , 'Description'                , 0, 1, 100, 100, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'TaxCodes.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TaxCodes.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS TaxCodes.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'TaxCodes.EditView.QuickBooksOnline', 'TaxRates', 'vwTAX_CODES_QBOnline', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxCodes.EditView.QuickBooksOnline',  0, 'TaxRates.LBL_NAME'                      , 'Name'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxCodes.EditView.QuickBooksOnline',  1, 'TaxRates.LBL_QUICKBOOKS_TAX_VENDOR'     , 'Agency'                     , 0, 1,  20, 40, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'TaxCodes.EditView.QuickBooksOnline',  2, 'TaxRates.LBL_STATUS'                    , 'Active'                     , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'TaxCodes.EditView.QuickBooksOnline',  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxCodes.EditView.QuickBooksOnline',  4, 'TaxRates.LBL_DESCRIPTION'               , 'Description'                , 0, 1, 100, 100, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTemplates.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'ProductTemplates.EditView.QuickBooksOnline', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_QBOnline', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooksOnline',  0, 'ProductTemplates.LBL_NAME'                      , 'Name'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooksOnline',  1, 'ProductTemplates.LBL_DESCRIPTION'               , 'Description'                , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooksOnline',  2, 'ProductTemplates.LBL_TYPE'                      , 'Type'                       , 0, 1,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooksOnline',  3, 'ProductTemplates.LBL_QUICKBOOKS_TAX_VENDOR'     , 'IncomeAccount'              , 0, 1,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProductTemplates.EditView.QuickBooksOnline',  4, 'ProductTemplates.LBL_STATUS'                    , 'Active'                     , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooksOnline',  5, 'ProductTemplates.LBL_QUANTITY'                  , 'QtyOnHand'                  , 0, 1,  20, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooksOnline',  6, 'ProductTemplates.LBL_LIST_PRICE'                , 'UnitPrice'                  , 0, 1,  20, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooksOnline',  7, 'ProductTemplates.LBL_COST_PRICE'                , 'PurchaseCost'               , 0, 1,  20, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProductTemplates.EditView.QuickBooksOnline',  8, 'ProductTemplates.LBL_TAX_CLASS'                 , 'Taxable'                    , 0, 1, 'CheckBox'           , null, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentTypes.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentTypes.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS PaymentTypes.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'PaymentTypes.EditView.QuickBooksOnline', 'PaymentTypes', 'vwPAYMENT_TYPES_QBOnline', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PaymentTypes.EditView.QuickBooksOnline',  0, 'PaymentTypes.LBL_NAME'                      , 'Name'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'PaymentTypes.EditView.QuickBooksOnline',  1, 'PaymentTypes.LBL_STATUS'                    , 'Active'                     , 0, 1, 'CheckBox'           , null, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Payments.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'Payments.EditView.QuickBooksOnline', 'Payments', 'vwPAYMENTS_QBOnline', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView.QuickBooksOnline',  0, 'Payments.LBL_AMOUNT'                    , 'TotalAmt'                   , 1, 1,  10, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Payments.EditView.QuickBooksOnline',  1, 'Payments.LBL_PAYMENT_DATE'              , 'TxnDate'                    , 1, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView.QuickBooksOnline',  2, 'Payments.LBL_ACCOUNT_NAME'              , 'Customer'                   , 1, 2,  10, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView.QuickBooksOnline',  3, 'Payments.LBL_PAYMENT_TYPE'              , 'PaymentMethod'              , 1, 1,  10, 35, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'CreditMemos.EditView.QuickBooksOnline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'CreditMemos.EditView.QuickBooksOnline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS CreditMemos.EditView.QuickBooksOnline';
	exec dbo.spEDITVIEWS_InsertOnly            'CreditMemos.EditView.QuickBooksOnline', 'Payments', 'vwCREDIT_MEMOS_QBOnline', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditMemos.EditView.QuickBooksOnline',  0, 'Payments.LBL_AMOUNT'                    , 'TotalAmt'                   , 1, 1,  10, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'CreditMemos.EditView.QuickBooksOnline',  1, 'Payments.LBL_PAYMENT_DATE'              , 'TxnDate'                    , 1, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditMemos.EditView.QuickBooksOnline',  2, 'Payments.LBL_ACCOUNT_NAME'              , 'Customer'                   , 1, 2,  10, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditMemos.EditView.QuickBooksOnline',  3, 'Payments.LBL_PAYMENT_TYPE'              , 'PaymentMethod'              , 1, 1,  10, 35, null;
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

call dbo.spEDITVIEWS_FIELDS_QBOnline()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_QBOnline')
/

-- #endif IBM_DB2 */


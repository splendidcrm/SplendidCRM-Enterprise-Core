

print 'EDITVIEWS_FIELDS QuickBooks';
GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditView.QuickBooks';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.EditView.QuickBooks';
	exec dbo.spEDITVIEWS_InsertOnly            'Accounts.EditView.QuickBooks', 'Accounts', 'vwACCOUNTS_QuickBooks', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks',  0, 'Accounts.LBL_ACCOUNT_NAME'              , 'Name'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks',  1, '.moduleListSingular.Contacts'           , 'Contact'                    , 0, 2,  41, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks',  2, 'Accounts.LBL_PHONE'                     , 'Phone'                      , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks',  3, 'Accounts.LBL_FAX'                       , 'Fax'                        , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks',  4, 'Accounts.LBL_EMAIL'                     , 'Email'                      , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks',  5, 'Accounts.LBL_OTHER_PHONE'               , 'AlternatePhone'             , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Accounts.EditView.QuickBooks',  6;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks',  7, 'Accounts.LBL_BILLING_ADDRESS_STREET'    , 'BillingLine1'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks',  8, 'Accounts.LBL_SHIPPING_ADDRESS_STREET'   , 'ShippingLine1'              , 0, 4, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks',  9, null                                     , 'BillingLine2'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 10, null                                     , 'ShippingLine2'              , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 11, null                                     , 'BillingLine3'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 12, null                                     , 'ShippingLine3'              , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 13, 'Accounts.LBL_CITY'                      , 'BillingCity'                , 0, 3, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 14, 'Accounts.LBL_CITY'                      , 'ShippingCity'               , 0, 4, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 15, 'Accounts.LBL_STATE'                     , 'BillingState'               , 0, 3, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 16, 'Accounts.LBL_STATE'                     , 'ShippingState'              , 0, 4, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 17, 'Accounts.LBL_POSTAL_CODE'               , 'BillingPostalCode'          , 0, 3,  30, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 18, 'Accounts.LBL_POSTAL_CODE'               , 'ShippingPostalCode'         , 0, 4,  30, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 19, 'Accounts.LBL_COUNTRY'                   , 'BillingCountry'             , 0, 3, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.QuickBooks', 20, 'Accounts.LBL_COUNTRY'                   , 'ShippingCountry'            , 0, 4, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Accounts.EditView.QuickBooks', 21;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditView.QuickBooks', 22, 'Accounts.LBL_DESCRIPTION'               , 'Notes'                      , 0, 5,   8, 60, 3;

	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Accounts.EditView.QuickBooks',  4, 'Email Address'                          , 'Email'                      , '.ERR_INVALID_EMAIL_ADDRESS';
end -- if;
GO

-- 06/22/2014 Paul.  Treat contacts just like accounts. Both point to customers. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.QuickBooks';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.EditView.QuickBooks';
	exec dbo.spEDITVIEWS_InsertOnly            'Contacts.EditView.QuickBooks', 'Contacts', 'vwCONTACTS_QuickBooks', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks',  0, 'Contacts.LBL_FIRST_NAME'                , 'FirstName'                  , 0, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks',  1, 'Contacts.LBL_LAST_NAME'                 , 'LastName'                   , 1, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks',  2, 'Contacts.LBL_PHONE'                     , 'Phone'                      , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks',  3, 'Contacts.LBL_FAX_PHONE'                 , 'Fax'                        , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks',  4, 'Contacts.LBL_EMAIL1'                    , 'Email'                      , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks',  5, 'Contacts.LBL_OTHER_PHONE'               , 'AlternatePhone'             , 0, 2,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Contacts.EditView.QuickBooks',  6;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks',  7, 'Contacts.LBL_PRIMARY_ADDRESS_STREET'    , 'BillingLine1'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks',  8, 'Contacts.LBL_ALT_ADDRESS_STREET'        , 'ShippingLine1'              , 0, 4, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks',  9, null                                     , 'BillingLine2'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 10, null                                     , 'ShippingLine2'              , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 11, null                                     , 'BillingLine3'               , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 12, null                                     , 'ShippingLine3'              , 0, 3, 500, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 13, 'Contacts.LBL_CITY'                      , 'BillingCity'                , 0, 3, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 14, 'Contacts.LBL_CITY'                      , 'ShippingCity'               , 0, 4, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 15, 'Contacts.LBL_STATE'                     , 'BillingState'               , 0, 3, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 16, 'Contacts.LBL_STATE'                     , 'ShippingState'              , 0, 4, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 17, 'Contacts.LBL_POSTAL_CODE'               , 'BillingPostalCode'          , 0, 3,  30, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 28, 'Contacts.LBL_POSTAL_CODE'               , 'ShippingPostalCode'         , 0, 4,  30, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 29, 'Contacts.LBL_COUNTRY'                   , 'BillingCountry'             , 0, 3, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.QuickBooks', 20, 'Contacts.LBL_COUNTRY'                   , 'ShippingCountry'            , 0, 4, 255, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditView.QuickBooks', 22, 'Contacts.LBL_DESCRIPTION'               , 'Notes'                      , 0, 5,   8, 60, null;

	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Contacts.EditView.QuickBooks',  4, 'Email Address'                          , 'Email'                      , '.ERR_INVALID_EMAIL_ADDRESS';
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.QuickBooks';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditView.QuickBooks';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditView.QuickBooks', 'Invoices', 'vwInvoices_QuickBooks', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks',  0, 'Invoices.LBL_NAME'                      , 'ReferenceNumber'            , 1, 1,  11, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Invoices.EditView.QuickBooks',  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.QuickBooks',  2, 'Invoices.LBL_INVOICE_STAGE'             , 'IsPending'                  , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView.QuickBooks',  3, 'Invoices.LBL_PAYMENT_TERMS'             , 'Terms'                      , 0, 1, 'PaymentTerms'       , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.QuickBooks',  4, 'Invoices.LBL_DUE_DATE'                  , 'DueDate'                    , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks',  5, 'Invoices.LBL_PURCHASE_ORDER_NUM'        , 'POnumber'                   , 0, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Invoices.EditView.QuickBooks',  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Invoices.EditView.QuickBooks',  7, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks',  8, 'Invoices.LBL_BILLING_ADDRESS_STREET'    , 'BillingLine1'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks',  9, 'Invoices.LBL_SHIPPING_ADDRESS_STREET'   , 'ShippingLine1'              , 0, 4,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 10, null                                     , 'BillingLine2'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 11, null                                     , 'ShippingLine2'              , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 12, null                                     , 'BillingLine3'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 13, null                                     , 'ShippingLine3'              , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 14, 'Invoices.LBL_CITY'                      , 'BillingCity'                , 0, 3,  31, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 15, 'Invoices.LBL_CITY'                      , 'ShippingCity'               , 0, 4,  31, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 16, 'Invoices.LBL_STATE'                     , 'BillingState'               , 0, 3,  21, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 17, 'Invoices.LBL_STATE'                     , 'ShippingState'              , 0, 4,  21, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 18, 'Invoices.LBL_POSTAL_CODE'               , 'BillingPostalCode'          , 0, 3,  13, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 19, 'Invoices.LBL_POSTAL_CODE'               , 'ShippingPostalCode'         , 0, 4,  13, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 20, 'Invoices.LBL_COUNTRY'                   , 'BillingCountry'             , 0, 3,  31, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.QuickBooks', 21, 'Invoices.LBL_COUNTRY'                   , 'ShippingCountry'            , 0, 4,  31, 15, null;
end else begin
	-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.QuickBooks' and DATA_FIELD = 'Terms' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update EDITVIEWS_FIELDS
		   set CACHE_NAME        = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Invoices.EditView.QuickBooks'
		   and DATA_FIELD        = 'Terms'
		   and CACHE_NAME        = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.QuickBooks';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditView.QuickBooks';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditView.QuickBooks', 'Orders', 'vwOrders_QuickBooks', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks',  0, 'Orders.LBL_NAME'                        , 'ReferenceNumber'            , 1, 1,  11, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditView.QuickBooks',  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.QuickBooks',  2, 'Orders.LBL_DATE_ORDER_SHIPPED'          , 'ShipDate'                   , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView.QuickBooks',  3, 'Orders.LBL_PAYMENT_TERMS'               , 'Terms'                      , 0, 1, 'PaymentTerms'       , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.QuickBooks',  4, 'Orders.LBL_DUE_DATE'                    , 'DueDate'                    , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks',  5, 'Orders.LBL_PURCHASE_ORDER_NUM'          , 'POnumber'                   , 0, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditView.QuickBooks',  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditView.QuickBooks',  7, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks',  8, 'Orders.LBL_BILLING_ADDRESS_STREET'      , 'BillingLine1'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks',  9, 'Orders.LBL_SHIPPING_ADDRESS_STREET'     , 'ShippingLine1'              , 0, 4,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 10, null                                     , 'BillingLine2'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 11, null                                     , 'ShippingLine2'              , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 12, null                                     , 'BillingLine3'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 13, null                                     , 'ShippingLine3'              , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 14, 'Orders.LBL_CITY'                        , 'BillingCity'                , 0, 3,  31, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 15, 'Orders.LBL_CITY'                        , 'ShippingCity'               , 0, 4,  31, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 16, 'Orders.LBL_STATE'                       , 'BillingState'               , 0, 3,  21, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 17, 'Orders.LBL_STATE'                       , 'ShippingState'              , 0, 4,  21, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 18, 'Orders.LBL_POSTAL_CODE'                 , 'BillingPostalCode'          , 0, 3,  13, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 19, 'Orders.LBL_POSTAL_CODE'                 , 'ShippingPostalCode'         , 0, 4,  13, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 20, 'Orders.LBL_COUNTRY'                     , 'BillingCountry'             , 0, 3,  31, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.QuickBooks', 21, 'Orders.LBL_COUNTRY'                     , 'ShippingCountry'            , 0, 4,  31, 15, null;
end else begin
	-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.QuickBooks' and DATA_FIELD = 'Terms' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update EDITVIEWS_FIELDS
		   set CACHE_NAME        = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Orders.EditView.QuickBooks'
		   and DATA_FIELD        = 'Terms'
		   and CACHE_NAME        = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/04/2014 Paul.  Test data is conflicting with insert, so include ReferenceNumber in filter. 
-- 02/04/2014 Paul.  ShippingLine3 was used multiple times. 
-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.QuickBooks';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.QuickBooks' and DATA_FIELD = 'ReferenceNumber' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditView.QuickBooks';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditView.QuickBooks', 'Quotes', 'vwQuotes_QuickBooks', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks',  0, 'Quotes.LBL_NAME'                        , 'ReferenceNumber'            , 1, 1,  11, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.QuickBooks',  1, 'Quotes.LBL_PAYMENT_TERMS'               , 'Terms'                      , 0, 1, 'PaymentTerms'       , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.QuickBooks',  2, 'Quotes.LBL_DATE_VALID_UNTIL'            , 'Date'                       , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks',  3, 'Quotes.LBL_PURCHASE_ORDER_NUM'          , 'POnumber'                   , 0, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView.QuickBooks',  4, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView.QuickBooks',  5, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks',  6, 'Quotes.LBL_BILLING_ADDRESS_STREET'      , 'BillingLine1'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks',  7, 'Quotes.LBL_SHIPPING_ADDRESS_STREET'     , 'ShippingLine1'              , 0, 4,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks',  8, null                                     , 'BillingLine2'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks',  9, null                                     , 'ShippingLine2'              , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 10, null                                     , 'BillingLine3'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 11, null                                     , 'ShippingLine3'              , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 12, 'Quotes.LBL_CITY'                        , 'BillingCity'                , 0, 3,  31, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 13, 'Quotes.LBL_CITY'                        , 'ShippingCity'               , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 14, 'Quotes.LBL_STATE'                       , 'BillingState'               , 0, 3,  21, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 15, 'Quotes.LBL_STATE'                       , 'ShippingState'              , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 16, 'Quotes.LBL_POSTAL_CODE'                 , 'BillingPostalCode'          , 0, 3,  13, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 17, 'Quotes.LBL_POSTAL_CODE'                 , 'ShippingPostalCode'         , 0, 3,  41, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 18, 'Quotes.LBL_COUNTRY'                     , 'BillingCountry'             , 0, 3,  31, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 19, 'Quotes.LBL_COUNTRY'                     , 'ShippingCountry'            , 0, 3,  41, 25, null;
end else begin
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.QuickBooks' and DATA_FIELD = 'ShippingLine3' and FIELD_INDEX > 11 and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DELETED            = 1
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = null
		 where EDIT_NAME          = 'Quotes.EditView.QuickBooks'
		   and DATA_FIELD         = 'ShippingLine3'
		   and FIELD_INDEX        >= 13
		   and DEFAULT_VIEW       = 0
		   and DELETED            = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 11, null                                     , 'ShippingLine3'              , 0, 3,  41, 25, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 12, 'Quotes.LBL_CITY'                        , 'BillingCity'                , 0, 3,  31, 25, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 13, 'Quotes.LBL_CITY'                        , 'ShippingCity'               , 0, 3,  41, 25, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 14, 'Quotes.LBL_STATE'                       , 'BillingState'               , 0, 3,  21, 15, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 15, 'Quotes.LBL_STATE'                       , 'ShippingState'              , 0, 3,  41, 25, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 16, 'Quotes.LBL_POSTAL_CODE'                 , 'BillingPostalCode'          , 0, 3,  13, 15, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 17, 'Quotes.LBL_POSTAL_CODE'                 , 'ShippingPostalCode'         , 0, 3,  41, 25, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 18, 'Quotes.LBL_COUNTRY'                     , 'BillingCountry'             , 0, 3,  31, 15, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.QuickBooks', 19, 'Quotes.LBL_COUNTRY'                     , 'ShippingCountry'            , 0, 3,  41, 25, null;
	end -- if;
	-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.QuickBooks' and DATA_FIELD = 'Terms' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update EDITVIEWS_FIELDS
		   set CACHE_NAME        = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Quotes.EditView.QuickBooks'
		   and DATA_FIELD        = 'Terms'
		   and CACHE_NAME        = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'TaxRates.EditView.QuickBooks';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TaxRates.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS TaxRates.EditView.QuickBooks';
	exec dbo.spEDITVIEWS_InsertOnly            'TaxRates.EditView.QuickBooks', 'TaxRates', 'vwTAX_RATES_QuickBooks', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView.QuickBooks',  0, 'TaxRates.LBL_NAME'                      , 'Name'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView.QuickBooks',  1, 'TaxRates.LBL_VALUE'                     , 'RateValue'                  , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView.QuickBooks',  2, 'TaxRates.LBL_QUICKBOOKS_TAX_VENDOR'     , 'Agency'                     , 0, 1,  20, 40, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'TaxRates.EditView.QuickBooks',  3, 'TaxRates.LBL_STATUS'                    , 'Active'                     , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView.QuickBooks',  4, 'TaxRates.LBL_DESCRIPTION'               , 'Description'                , 0, 1, 100, 100, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView.QuickBooks';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView.QuickBooks' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTemplates.EditView.QuickBooks';
	exec dbo.spEDITVIEWS_InsertOnly            'ProductTemplates.EditView.QuickBooks', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_QuickBooks', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooks',  0, 'ProductTemplates.LBL_NAME'                      , 'Name'                       , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooks',  1, 'ProductTemplates.LBL_DESCRIPTION'               , 'Description'                , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooks',  2, 'ProductTemplates.LBL_TYPE'                      , 'Type'                       , 0, 1,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooks',  3, 'ProductTemplates.LBL_QUICKBOOKS_ACCOUNT'        , 'IncomeAccount'              , 0, 1,  20, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProductTemplates.EditView.QuickBooks',  4, 'ProductTemplates.LBL_STATUS'                    , 'Active'                     , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooks',  5, 'ProductTemplates.LBL_QUANTITY'                  , 'QtyOnHand'                  , 0, 1,  20, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooks',  6, 'ProductTemplates.LBL_LIST_PRICE'                , 'UnitPrice'                  , 0, 1,  20, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.QuickBooks',  7, 'ProductTemplates.LBL_COST_PRICE'                , 'PurchaseCost'               , 0, 1,  20, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProductTemplates.EditView.QuickBooks',  8, 'ProductTemplates.LBL_TAX_CLASS'                 , 'Taxable'                    , 0, 1, 'CheckBox'           , null, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'QuickBooks.ConfigView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'QuickBooks.ConfigView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS QuickBooks.ConfigView';
	exec dbo.spEDITVIEWS_InsertOnly            'QuickBooks.ConfigView', 'QuickBooks', 'vwCONFIG_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      ,  0, 'QuickBooks.LBL_ENABLED'                 , 'QuickBooks.Enabled'               , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      ,  1, 'QuickBooks.LBL_VERBOSE_STATUS'          , 'QuickBooks.VerboseStatus'         , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'QuickBooks.ConfigView'      ,  2, 'QuickBooks.LBL_QUICKBOOKS_APP'          , 'QuickBooks.AppMode'               , 0, 1, 'quickbooks_app_mode', 3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  3, 'QuickBooks.LBL_REMOTE_USER'             , 'QuickBooks.RemoteUser'            , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  4, 'QuickBooks.LBL_REMOTE_URL'              , 'QuickBooks.RemoteURL'             , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  5, 'QuickBooks.LBL_REMOTE_PASSWORD'         , 'QuickBooks.RemotePassword'        , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  6, 'QuickBooks.LBL_REMOTE_APPLICATION'      , 'QuickBooks.RemoteApplicationName' , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  7, 'QuickBooks.LBL_OAUTH_COMPANY_ID'        , 'QuickBooks.OAuthCompanyID'        , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  8, 'QuickBooks.LBL_OAUTH_COUNTRY_CODE'      , 'QuickBooks.OAuthCountryCode'      , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      ,  9, 'QuickBooks.LBL_OAUTH_CLIENT_ID'         , 'QuickBooks.OAuthClientID'         , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 10, 'QuickBooks.LBL_OAUTH_ACCESS_TOKEN'      , 'QuickBooks.OAuthAccessToken'      , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 11, 'QuickBooks.LBL_OAUTH_CLIENT_SECRET'     , 'QuickBooks.OAuthClientSecret'     , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 12, 'QuickBooks.LBL_OAUTH_ACCESS_SECRET'     , 'QuickBooks.OAuthAccessTokenSecret', 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 13, 'QuickBooks.LBL_OAUTH_VERIFIER'          , 'QuickBooks.OAuthVerifier'         , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 14, 'QuickBooks.LBL_OAUTH_EXPIRES_AT'        , 'QuickBooks.OAuthExpiresAt'        , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'QuickBooks.ConfigView'      , 15, 'QuickBooks.LBL_DIRECTION'               , 'QuickBooks.Direction'             , 1, 1, 'quickbooks_sync_direction', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'QuickBooks.ConfigView'      , 16, 'QuickBooks.LBL_CONFLICT_RESOLUTION'     , 'QuickBooks.ConflictResolution'    , 0, 1, 'sync_conflict_resolution' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 17, 'QuickBooks.LBL_SYNC_QUOTES'             , 'QuickBooks.SyncQuotes'            , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 18, 'QuickBooks.LBL_SYNC_ORDERS'             , 'QuickBooks.SyncOrders'            , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 19, 'QuickBooks.LBL_SYNC_INVOICES'           , 'QuickBooks.SyncInvoices'          , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 20, 'QuickBooks.LBL_SYNC_PAYMENTS'           , 'QuickBooks.SyncPayments'          , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'QuickBooks.ConfigView'      , 21, 'QuickBooks.LBL_PAYMENTS_DEPOSIT_ACCOUNT', 'QuickBooks.PaymentsDepositAccount', 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'QuickBooks.ConfigView'      , 22, 'QuickBooks.LBL_SYNC_CREDIT_MEMOS'       , 'QuickBooks.SyncCreditMemos'       , 0, 1, null, null, null;
	update EDITVIEWS_FIELDS
	   set FIELD_TYPE        = 'Radio'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where EDIT_NAME         = 'QuickBooks.ConfigView'
	   and DATA_FIELD        = 'QuickBooks.AppMode'
	   and DELETED           = 0;
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

call dbo.spEDITVIEWS_FIELDS_QuickBooks()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_QuickBooks')
/

-- #endif IBM_DB2 */




print 'EDITVIEWS_FIELDS EditView.Inline Professional';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.EditView.Inline'
--GO

set nocount on;
GO

-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView.Inline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView.Inline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.EditView.Inline';
	exec dbo.spEDITVIEWS_InsertOnly            'Contracts.EditView.Inline', 'Contracts', 'vwCONTRACTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Inline'      ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                        , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Inline'      ,  1, 'Contracts.LBL_STATUS'                   , 'STATUS'                      , 1, 1, 'contract_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Inline'      ,  2, 'Contracts.LBL_REFERENCE_CODE'           , 'REFERENCE_CODE'              , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline'      ,  3, 'Contracts.LBL_START_DATE'               , 'START_DATE'                  , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Inline'      ,  4, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                  , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline'      ,  5, 'Contracts.LBL_END_DATE'                 , 'END_DATE'                    , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Inline'      ,  6, 'Contracts.LBL_OPPORTUNITY_NAME'         , 'OPPORTUNITY_ID'              , 0, 1, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Inline'      ,  7, 'Contracts.LBL_CURRENCY'                 , 'CURRENCY_ID'                 , 0, 1, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Inline'      ,  8, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'            , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Inline'      ,  9, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                     , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Inline'      , 10, 'Contracts.LBL_CONTRACT_VALUE'           , 'TOTAL_CONTRACT_VALUE'        , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline'      , 11, 'Contracts.LBL_COMPANY_SIGNED_DATE'      , 'COMPANY_SIGNED_DATE'         , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline'      , 12, 'Contracts.LBL_EXPIRATION_NOTICE'        , 'EXPIRATION_NOTICE'           , 0, 1, 'DateTimeEdit'       , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline'      , 13, 'Contracts.LBL_CUSTOMER_SIGNED_DATE'     , 'CUSTOMER_SIGNED_DATE'        , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Inline'      , 14, 'Contracts.LBL_TYPE'                     , 'TYPE_ID'                     , 0, 1, 'ContractTypes'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Contracts.EditView.Inline'      , 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contracts.EditView.Inline'      , 16, 'Contracts.LBL_DESCRIPTION'              , 'DESCRIPTION'                 , 0, 1,   4, 80, 3;
end -- if;
GO

-- 04/20/2010 Paul.  Use an alternate view for Accounts Inline Edit as Account field is not needed. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView.Inline.Accounts';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView.Inline.Accounts' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.EditView.Inline.Accounts';
	exec dbo.spEDITVIEWS_InsertOnly            'Contracts.EditView.Inline.Accounts', 'Contracts', 'vwCONTRACTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Inline.Accounts'      ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                        , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Inline.Accounts'      ,  1, 'Contracts.LBL_STATUS'                   , 'STATUS'                      , 1, 1, 'contract_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Inline.Accounts'      ,  2, 'Contracts.LBL_REFERENCE_CODE'           , 'REFERENCE_CODE'              , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline.Accounts'      ,  3, 'Contracts.LBL_START_DATE'               , 'START_DATE'                  , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Contracts.EditView.Inline.Accounts'      ,  4, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline.Accounts'      ,  5, 'Contracts.LBL_END_DATE'                 , 'END_DATE'                    , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Inline.Accounts'      ,  6, 'Contracts.LBL_OPPORTUNITY_NAME'         , 'OPPORTUNITY_ID'              , 0, 1, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Inline.Accounts'      ,  7, 'Contracts.LBL_CURRENCY'                 , 'CURRENCY_ID'                 , 0, 1, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Inline.Accounts'      ,  8, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'            , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Inline.Accounts'      ,  9, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                     , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Inline.Accounts'      , 10, 'Contracts.LBL_CONTRACT_VALUE'           , 'TOTAL_CONTRACT_VALUE'        , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline.Accounts'      , 11, 'Contracts.LBL_COMPANY_SIGNED_DATE'      , 'COMPANY_SIGNED_DATE'         , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline.Accounts'      , 12, 'Contracts.LBL_EXPIRATION_NOTICE'        , 'EXPIRATION_NOTICE'           , 0, 1, 'DateTimeEdit'       , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Inline.Accounts'      , 13, 'Contracts.LBL_CUSTOMER_SIGNED_DATE'     , 'CUSTOMER_SIGNED_DATE'        , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Inline.Accounts'      , 14, 'Contracts.LBL_TYPE'                     , 'TYPE_ID'                     , 0, 1, 'ContractTypes'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Contracts.EditView.Inline.Accounts'      , 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contracts.EditView.Inline.Accounts'      , 16, 'Contracts.LBL_DESCRIPTION'              , 'DESCRIPTION'                 , 0, 1,   4, 80, 3;
end -- if;
GO

-- 03/05/2011 Paul.  Allow inline creation of Ivoices, Oders and Quotes.
-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Inline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Inline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditView.Inline';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditView.Inline', 'Invoices', 'vwINVOICES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Inline'       ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Inline'       ,  1, 'Invoices.LBL_PURCHASE_ORDER_NUM'        , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView.Inline'       ,  2, 'Invoices.LBL_INVOICE_STAGE'             , 'INVOICE_STAGE'              , 1, 1, 'invoice_stage_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.Inline'       ,  3, 'Invoices.LBL_DUE_DATE'                  , 'DUE_DATE'                   , 0, 1, 'DatePicker'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView.Inline'       ,  4, 'Invoices.LBL_PAYMENT_TERMS'             , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Invoices.EditView.Inline'       ,  5, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Inline'       ,  6, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'    , 'Users'   , null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Inline'       ,  7, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'           , 'Teams'   , null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Inline'       ,  8, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 1, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Inline'       ,  9, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME', 'Contacts', null;
end else begin
	-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Inline' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Invoices.EditView.Inline'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Inline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Inline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditView.Inline';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditView.Inline', 'Orders', 'vwORDERS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Inline'         ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Inline'         ,  1, 'Orders.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView.Inline'         ,  2, 'Orders.LBL_ORDER_STAGE'                 , 'ORDER_STAGE'                , 1, 1, 'order_stage_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.Inline'         ,  3, 'Orders.LBL_DATE_ORDER_DUE'              , 'DATE_ORDER_DUE'             , 0, 1, 'DatePicker'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView.Inline'         ,  4, 'Orders.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.Inline'         ,  5, 'Orders.LBL_DATE_ORDER_SHIPPED'          , 'DATE_ORDER_SHIPPED'         , 0, 1, 'DatePicker'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Inline'         ,  6, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'    , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Inline'         ,  7, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'           , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Inline'         ,  8, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 1, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Inline'         ,  9, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 1, 'BILLING_CONTACT_NAME', 'Contacts', null;
end else begin
	-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Inline' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Orders.EditView.Inline'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Inline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Inline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditView.Inline';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditView.Inline', 'Quotes', 'vwQUOTES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Inline'         ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Inline'         ,  1, 'Quotes.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.Inline'         ,  2, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 1, 1, 'quote_stage_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Inline'         ,  3, 'Quotes.LBL_DATE_VALID_UNTIL'            , 'DATE_QUOTE_EXPECTED_CLOSED' , 1, 1, 'DatePicker'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.Inline'         ,  4, 'Quotes.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Inline'         ,  5, 'Quotes.LBL_ORIGINAL_PO_DATE'            , 'ORIGINAL_PO_DATE'           , 0, 1, 'DatePicker'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Inline'         ,  6, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'    , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Inline'         ,  7, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'           , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Inline'         ,  8, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 1, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Inline'         ,  9, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 1, 'BILLING_CONTACT_NAME', 'Contacts', null;
end else begin
	-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Inline' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Quotes.EditView.Inline'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView.Inline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView.Inline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Payments.EditView.Inline';
	exec dbo.spEDITVIEWS_InsertOnly            'Payments.EditView.Inline', 'Payments', 'vwPAYMENTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView.Inline'       ,  0, 'Payments.LBL_AMOUNT'                    , 'AMOUNT'                     , 1, 1,  10, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView.Inline'       ,  1, 'Payments.LBL_BANK_FEE'                  , 'BANK_FEE'                   , 0, 1,  10, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.EditView.Inline'       ,  2, 'Payments.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Payments.EditView.Inline'       ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Payments.EditView.Inline'       ,  4, 'Payments.LBL_CURRENCY'                  , 'CURRENCY_ID'                , 1, 1, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView.Inline'       ,  5, 'Payments.LBL_CUSTOMER_REFERENCE'        , 'CUSTOMER_REFERENCE'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Payments.EditView.Inline'       ,  6, 'Payments.LBL_PAYMENT_DATE'              , 'PAYMENT_DATE'               , 1, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Payments.EditView.Inline'       ,  7, 'Payments.LBL_PAYMENT_NUM'               , 'PAYMENT_NUM'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Payments.EditView.Inline'       ,  8, 'Payments.LBL_PAYMENT_TYPE'              , 'PAYMENT_TYPE'               , 1, 1, 'payment_type_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Payments.EditView.Inline'       ,  9, 'Payments.LBL_CREDIT_CARD_NAME'          , 'CREDIT_CARD_ID'             , 0, 1, 'CREDIT_CARD_NAME'   , 'return CreditCardPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.EditView.Inline'       , 10, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.EditView.Inline'       , 11, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Payments.EditView.Inline'       , 12, 'Payments.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 1,   4, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Payments.EditView.Inline', 'ACCOUNT_ID' , '1';
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView.Inline' and DATA_FIELD = 'PAYMENT_TYPE' and CACHE_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTypes'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Payments.EditView.Inline'
		--   and DATA_FIELD        = 'PAYMENT_TYPE'
		--   and CACHE_NAME        = 'payment_type_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.EditView.Inline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.EditView.Inline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Products.EditView.Inline';
	exec dbo.spEDITVIEWS_InsertOnly            'Products.EditView.Inline', 'Products', 'vwPRODUCTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Products.EditView.Inline'       ,  0, 'Products.LBL_NAME'                      , 'PRODUCT_TEMPLATE_ID'        , 1, 1, 'NAME'               , 'return ProductCatalogPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.EditView.Inline'       ,  1, 'Products.LBL_STATUS'                    , 'STATUS'                     , 1, 1, 'product_status_dom' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.EditView.Inline'       ,  2, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.EditView.Inline'       ,  3, 'Contracts.LBL_CONTACT_NAME'             , 'CONTACT_ID'                 , 1, 1, 'CONTACT_NAME'       , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.EditView.Inline'       ,  4, 'Products.LBL_QUANTITY'                  , 'QUANTITY'                   , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.EditView.Inline'       ,  5, 'Products.LBL_DATE_PURCHASED'            , 'DATE_PURCHASED'             , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.EditView.Inline'       ,  6, 'Products.LBL_DATE_SUPPORT_STARTS'       , 'DATE_SUPPORT_STARTS'        , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.EditView.Inline'       ,  7, 'Products.LBL_DATE_SUPPORT_EXPIRES'      , 'DATE_SUPPORT_EXPIRES'       , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick  null, 'Products.EditView.Inline', 'CONTACT_ID' , 'return ContactPopup();';
end -- if;
GO

-- 05/31/2013 Paul.  Add Surveys module. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyPages.EditView.Inline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyPages.EditView.Inline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyPages.EditView.Inline';
	exec dbo.spEDITVIEWS_InsertOnly            'SurveyPages.EditView.Inline', 'SurveyPages', 'vwSURVEY_PAGES_Edit', '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyPages.EditView.Inline'    ,  0, 'SurveyPages.LBL_NAME'                         , 'NAME'                        , 0, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyPages.EditView.Inline'    ,  1, 'SurveyPages.LBL_QUESTION_RANDOMIZATION'       , 'QUESTION_RANDOMIZATION'      , 0, 1, 'survey_page_randomization', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyPages.EditView.Inline'    ,  2, 'SurveyPages.LBL_DESCRIPTION'                  , 'DESCRIPTION'                 , 0, 3,   3, 80, 3;
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

call dbo.spEDITVIEWS_FIELDS_InlineProfessional()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_InlineProfessional')
/

-- #endif IBM_DB2 */


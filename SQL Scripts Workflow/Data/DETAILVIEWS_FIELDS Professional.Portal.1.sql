

print 'DETAILVIEWS_FIELDS Professional.Portal';
--delete from DETAILVIEWS_FIELDS where DETAIL_NAME like '%.DetailView.Portal'
--GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contracts.DetailView.Portal'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contracts.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contracts.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contracts.DetailView.Portal', 'Contracts', 'vwCONTRACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Portal',  0, 'Contracts.LBL_NAME'                , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Portal',  1, 'Contracts.LBL_START_DATE'          , 'START_DATE'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Portal',  2, 'Contracts.LBL_REFERENCE_CODE'      , 'REFERENCE_CODE'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Portal',  3, 'Contracts.LBL_END_DATE'            , 'END_DATE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Contracts.DetailView.Portal',  4, 'Contracts.LBL_STATUS'              , 'STATUS'                           , '{0}'        , 'contract_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Portal',  5, 'Contracts.LBL_COMPANY_SIGNED_DATE' , 'COMPANY_SIGNED_DATE'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Portal',  6, 'Contracts.LBL_CONTRACT_VALUE'      , 'TOTAL_CONTRACT_VALUE'             , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Portal',  7, 'Contracts.LBL_CUSTOMER_SIGNED_DATE', 'CUSTOMER_SIGNED_DATE'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Portal',  8, 'Contracts.LBL_EXPIRATION_NOTICE'   , 'EXPIRATION_NOTICE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Portal',  9, 'Contracts.LBL_TYPE'                , 'TYPE'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contracts.DetailView.Portal', 10, 'TextBox', 'Contracts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.Portal'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.DetailView.Portal', 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   ,  0, 'Quotes.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   ,  1, 'Quotes.LBL_QUOTE_NUM'             , 'QUOTE_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView.Portal'   ,  2, 'Quotes.LBL_QUOTE_STAGE'           , 'QUOTE_STAGE'                       , '{0}'        , 'quote_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   ,  3, 'Quotes.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   ,  4, 'Quotes.LBL_DATE_VALID_UNTIL'      , 'DATE_QUOTE_EXPECTED_CLOSED'        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView.Portal'   ,  5, 'Quotes.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'PaymentTerms'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   ,  6, 'Quotes.LBL_ORIGINAL_PO_DATE'      , 'ORIGINAL_PO_DATE'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.DetailView.Portal'   ,  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   ,  8, 'Quotes.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   ,  9, 'Quotes.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   , 10, 'Quotes.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   , 11, 'Quotes.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   , 12, 'Quotes.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Portal'   , 13, 'Quotes.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Quotes.DetailView.Portal'   , 14, 'TextBox', 'Quotes.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.Portal' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME         = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Quotes.DetailView.Portal'
		   and DATA_FIELD        = 'PAYMENT_TERMS'
		   and LIST_NAME         = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.Portal'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.SummaryView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.SummaryView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.SummaryView.Portal', 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Portal'  ,  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Portal'  ,  1, 'Quotes.LBL_SUBTOTAL'              , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Portal'  ,  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Portal'  ,  3, 'Quotes.LBL_DISCOUNT'              , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Portal'  ,  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Portal'  ,  5, 'Quotes.LBL_SHIPPING'              , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Portal'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Portal'  ,  7, 'Quotes.LBL_TAX'                   , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Portal'  ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Portal'  ,  9, 'Quotes.LBL_TOTAL'                 , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.DetailView.Portal', 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   ,  0, 'Orders.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   ,  1, 'Orders.LBL_ORDER_NUM'             , 'ORDER_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView.Portal'   ,  2, 'Orders.LBL_ORDER_STAGE'           , 'ORDER_STAGE'                       , '{0}'        , 'order_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   ,  3, 'Orders.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   ,  4, 'Orders.LBL_DATE_ORDER_DUE'        , 'DATE_ORDER_DUE'                    , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView.Portal'   ,  5, 'Orders.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'PaymentTerms'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   ,  6, 'Orders.LBL_DATE_ORDER_SHIPPED'    , 'DATE_ORDER_SHIPPED'                , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.DetailView.Portal'   ,  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   ,  8, 'Orders.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   ,  9, 'Orders.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   , 10, 'Orders.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   , 11, 'Orders.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   , 12, 'Orders.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Portal'   , 13, 'Orders.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Orders.DetailView.Portal'   , 14, 'TextBox', 'Orders.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.Portal' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME         = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Orders.DetailView.Portal'
		   and DATA_FIELD        = 'PAYMENT_TERMS'
		   and LIST_NAME         = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.SummaryView.Portal';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.SummaryView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.SummaryView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.SummaryView.Portal', 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Portal'  ,  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Portal'  ,  1, 'Orders.LBL_SUBTOTAL'              , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Portal'  ,  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Portal'  ,  3, 'Orders.LBL_DISCOUNT'              , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Portal'  ,  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Portal'  ,  5, 'Orders.LBL_SHIPPING'              , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Portal'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Portal'  ,  7, 'Orders.LBL_TAX'                   , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Portal'  ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Portal'  ,  9, 'Orders.LBL_TOTAL'                 , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.DetailView.Portal', 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' ,  0, 'Invoices.LBL_NAME'                 , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' ,  1, 'Invoices.LBL_INVOICE_NUM'          , 'INVOICE_NUM'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView.Portal' ,  2, 'Invoices.LBL_INVOICE_STAGE'        , 'INVOICE_STAGE'                     , '{0}'        , 'invoice_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Portal' ,  3, 'Invoices.LBL_QUOTE_NAME'           , 'QUOTE_NAME'                        , '{0}'        , 'QUOTE_ID'       , '~/Quotes/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView.Portal' ,  4, 'Invoices.LBL_PAYMENT_TERMS'        , 'PAYMENT_TERMS'                     , '{0}'        , 'PaymentTerms'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Portal' ,  5, 'Invoices.LBL_ORDER_NAME'           , 'ORDER_NAME'                        , '{0}'        , 'ORDER_ID'       , '~/Orders/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' ,  6, 'Invoices.LBL_DUE_DATE'             , 'DUE_DATE'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' ,  7, 'Invoices.LBL_PURCHASE_ORDER_NUM'   , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' ,  8, 'Invoices.LBL_BILLING_CONTACT_NAME' , 'BILLING_CONTACT_NAME'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' ,  9, 'Invoices.LBL_SHIPPING_CONTACT_NAME', 'SHIPPING_CONTACT_NAME'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' , 10, 'Invoices.LBL_BILLING_ACCOUNT_NAME' , 'BILLING_ACCOUNT_NAME'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' , 11, 'Invoices.LBL_SHIPPING_ACCOUNT_NAME', 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' , 12, 'Invoices.LBL_BILLING_ADDRESS'      , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Portal' , 13, 'Invoices.LBL_SHIPPING_ADDRESS'     , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Invoices.DetailView.Portal' , 14, 'TextBox', 'Invoices.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.Portal' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME         = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Invoices.DetailView.Portal'
		   and DATA_FIELD        = 'PAYMENT_TERMS'
		   and LIST_NAME         = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView.Portal';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.SummaryView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.SummaryView.Portal', 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Portal',  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Portal',  1, 'Invoices.LBL_SUBTOTAL'            , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Portal',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Portal',  3, 'Invoices.LBL_DISCOUNT'            , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Portal',  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Portal',  5, 'Invoices.LBL_SHIPPING'            , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Portal',  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Portal',  7, 'Invoices.LBL_TAX'                 , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Portal',  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Portal',  9, 'Invoices.LBL_TOTAL'               , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO

/*
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView.Portal';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Payments.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Payments.DetailView.Portal', 'Payments', 'vwPAYMENTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Portal' ,  0, 'Payments.LBL_AMOUNT'               , 'AMOUNT_USDOLLAR'                   , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Payments.DetailView.Portal' ,  1, 'Payments.LBL_ACCOUNT_NAME'         , 'ACCOUNT_NAME'                      , '{0}'        , 'ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Portal' ,  2, 'Payments.LBL_PAYMENT_DATE'         , 'PAYMENT_DATE'                      , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Portal' ,  3, 'Payments.LBL_CUSTOMER_REFERENCE'   , 'CUSTOMER_REFERENCE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Payments.DetailView.Portal' ,  4, 'Payments.LBL_PAYMENT_TYPE'         , 'PAYMENT_TYPE'                      , '{0}'        , 'payment_type_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Portal' ,  5, 'Payments.LBL_PAYMENT_NUM'          , 'PAYMENT_NUM'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Payments.DetailView.Portal' ,  6, 'TextBox', 'Payments.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
*/
GO

/*
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.SummaryView.Portal';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.SummaryView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Payments.SummaryView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Payments.SummaryView.Portal', 'Invoices', 'vwPAYMENTS_Edit', '25%', '75%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.SummaryView.Portal',  0, 'Payments.LBL_ALLOCATED'             , 'TOTAL_ALLOCATED_USDOLLAR'         , '{0:c}'      , null;
end -- if;
*/
GO

/*
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'CreditCards.DetailView.Portal' and DELETED = 0) begin -- then 
	print 'DETAILVIEWS_FIELDS CreditCards.DetailView.Portal'; 
	exec dbo.spDETAILVIEWS_InsertOnly 'CreditCards.DetailView.Portal', 'CreditCards', 'vwCREDIT_CARDS_Edit', '15%', '35%', null; 
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  0, 'CreditCards.LBL_NAME'                          , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  1, 'CreditCards.LBL_CARD_TYPE'                     , 'CARD_TYPE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  2, 'CreditCards.LBL_CARD_NUMBER'                   , 'CARD_NUMBER_DISPLAY'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  3, 'CreditCards.LBL_EXPIRATION_DATE'               , 'EXPIRATION_MONTH EXPIRATION_YEAR'  , '{0}/{1}'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  4, 'CreditCards.LBL_IS_PRIMARY'                    , 'IS_PRIMARY'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  5, 'CreditCards.LBL_ADDRESS_STREET'                , 'ADDRESS_STREET'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  6, 'CreditCards.LBL_ADDRESS_CITY'                  , 'ADDRESS_CITY'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  7, 'CreditCards.LBL_ADDRESS_STATE'                 , 'ADDRESS_STATE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  8, 'CreditCards.LBL_ADDRESS_POSTALCODE'            , 'ADDRESS_POSTALCODE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView.Portal' ,  9, 'CreditCards.LBL_ADDRESS_COUNTRY'               , 'ADDRESS_COUNTRY'                   , '{0}'        , null;
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

call dbo.spDETAILVIEWS_FIELDS_ProfessionalPortal()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_ProfessionalPortal')
/

-- #endif IBM_DB2 */


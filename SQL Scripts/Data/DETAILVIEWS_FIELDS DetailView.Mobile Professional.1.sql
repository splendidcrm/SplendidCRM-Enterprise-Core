

print 'DETAILVIEWS_FIELDS DetailView Professional';
--delete from DETAILVIEWS_FIELDS where DETAIL_NAME like '%.DetailView.Mobile'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 09/14/2008 Paul.  DB2 does not work well with optional parameters. 
-- 08/24/2009 Paul.  Change TEAM_NAME to TEAM_SET_NAME. 
-- 08/28/2009 Paul.  Restore TEAM_NAME and expect it to be converted automatically when DynamicTeams is enabled. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contracts.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contracts.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contracts.DetailView.Mobile', 'Contracts', 'vwCONTRACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile',  0, 'Contracts.LBL_NAME'                , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile',  1, 'Contracts.LBL_START_DATE'          , 'START_DATE'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile',  2, 'Contracts.LBL_REFERENCE_CODE'      , 'REFERENCE_CODE'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile',  3, 'Contracts.LBL_END_DATE'            , 'END_DATE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contracts.DetailView.Mobile',  4, 'Contracts.LBL_ACCOUNT_NAME'        , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'          , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Contracts.DetailView.Mobile',  5, 'Contracts.LBL_STATUS'              , 'STATUS'                           , '{0}'        , 'contract_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contracts.DetailView.Mobile',  6, 'Contracts.LBL_OPPORTUNITY_NAME'    , 'OPPORTUNITY_NAME'                 , '{0}'        , 'OPPORTUNITY_ID'      , '~/Opportunities/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile',  7, 'Contracts.LBL_COMPANY_SIGNED_DATE' , 'COMPANY_SIGNED_DATE'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile',  8, 'Contracts.LBL_CONTRACT_VALUE'      , 'TOTAL_CONTRACT_VALUE'             , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile',  9, 'Contracts.LBL_CUSTOMER_SIGNED_DATE', 'CUSTOMER_SIGNED_DATE'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile', 10, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile', 11, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile', 12, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile', 13, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Mobile', 14, 'Contracts.LBL_EXPIRATION_NOTICE'   , 'EXPIRATION_NOTICE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Contracts.DetailView.Mobile', 15, 'Contracts.LBL_TYPE'                , 'TYPE'                             , '{0}'        , 'ContractTypes' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contracts.DetailView.Mobile', 16, 'TextBox', 'Contracts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Products.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Products.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Products.DetailView.Mobile', 'Products', 'vwPRODUCTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' ,  0, 'Products.LBL_NAME'                , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.DetailView.Mobile' ,  1, 'Products.LBL_STATUS'              , 'STATUS'                            , '{0}'        , 'product_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Products.DetailView.Mobile' ,  2, 'Products.LBL_ACCOUNT_NAME'        , 'ACCOUNT_NAME'                      , '{0}'        , 'ACCOUNT_ID'         , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Products.DetailView.Mobile' ,  3, 'Products.LBL_CONTACT_NAME'        , 'CONTACT_NAME'                      , '{0}'        , 'CONTACT_ID'         , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Products.DetailView.Mobile' ,  4, 'Products.LBL_QUOTE_NAME'          , 'QUOTE_NAME'                        , '{0}'        , 'QUOTE_ID'           , '~/Quotes/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' ,  5, 'Products.LBL_DATE_PURCHASED'      , 'DATE_PURCHASED'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' ,  6, 'Products.LBL_QUANTITY'            , 'QUANTITY'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' ,  7, 'Products.LBL_DATE_SUPPORT_STARTS' , 'DATE_SUPPORT_STARTS'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView.Mobile' ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' ,  9, 'Products.LBL_DATE_SUPPORT_EXPIRES', 'DATE_SUPPORT_EXPIRES'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 10, 'Products.LBL_CURRENCY'            , 'CURRENCY_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView.Mobile' , 11, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 12, 'Products.LBL_COST_PRICE'          , 'COST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView.Mobile' , 13, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 14, 'Products.LBL_LIST_PRICE'          , 'LIST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 15, 'Products.LBL_BOOK_VALUE'          , 'BOOK_VALUE'                        , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 16, 'Products.LBL_DISCOUNT_PRICE'      , 'DISCOUNT_USDOLLAR'                 , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 17, 'Products.LBL_BOOK_VALUE_DATE'     , 'BOOK_VALUE_DATE'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView.Mobile' , 18, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView.Mobile' , 19, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 20, 'Products.LBL_WEBSITE'             , 'WEBSITE'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.DetailView.Mobile' , 21, 'Products.LBL_TAX_CLASS'           , 'TAX_CLASS'                         , '{0}'        , 'tax_class_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 22, 'Products.LBL_MANUFACTURER'        , 'MANUFACTURER_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 23, 'Products.LBL_WEIGHT'              , 'WEIGHT'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 24, 'Products.LBL_MFT_PART_NUM'        , 'MFT_PART_NUM'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 25, 'Products.LBL_CATEGORY'            , 'CATEGORY_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 26, 'Products.LBL_VENDOR_PART_NUM'     , 'VENDOR_PART_NUM'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 27, 'Products.LBL_TYPE'                , 'TYPE_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 28, 'Products.LBL_SERIAL_NUMBER'       , 'SERIAL_NUMBER'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView.Mobile' , 29, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 30, 'Products.LBL_ASSET_NUMBER'        , 'ASSET_NUMBER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView.Mobile' , 31, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 32, 'Products.LBL_SUPPORT_NAME'        , 'SUPPORT_NAME'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 33, 'Products.LBL_SUPPORT_CONTACT'     , 'SUPPORT_CONTACT'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView.Mobile' , 34, 'Products.LBL_SUPPORT_DESCRIPTION' , 'SUPPORT_DESCRIPTION'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.DetailView.Mobile' , 35, 'Products.LBL_SUPPORT_TERM'        , 'SUPPORT_TERM'                      , '{0}'        , 'support_term_dom'   , null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ProductTemplates.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'ProductTemplates.DetailView.Mobile', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' ,  0, 'ProductTemplates.LBL_NAME'                , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'ProductTemplates.DetailView.Mobile' ,  1, 'ProductTemplates.LBL_STATUS'              , 'STATUS'                            , '{0}'        , 'product_template_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' ,  2, 'ProductTemplates.LBL_WEBSITE'             , 'WEBSITE'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' ,  3, 'ProductTemplates.LBL_DATE_AVAILABLE'      , 'DATE_AVAILABLE'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'ProductTemplates.DetailView.Mobile' ,  4, 'ProductTemplates.LBL_TAX_CLASS'           , 'TAX_CLASS'                         , '{0}'        , 'tax_class_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' ,  5, 'ProductTemplates.LBL_QUANTITY'            , 'QUANTITY'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView.Mobile' ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView.Mobile' ,  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' ,  8, 'ProductTemplates.LBL_MANUFACTURER'        , 'MANUFACTURER_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' ,  9, 'ProductTemplates.LBL_WEIGHT'              , 'WEIGHT'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 10, 'ProductTemplates.LBL_MFT_PART_NUM'        , 'MFT_PART_NUM'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 11, 'ProductTemplates.LBL_CATEGORY'            , 'CATEGORY_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 12, 'ProductTemplates.LBL_VENDOR_PART_NUM'     , 'VENDOR_PART_NUM'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 13, 'ProductTemplates.LBL_TYPE'                , 'TYPE_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView.Mobile' , 14, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView.Mobile' , 15, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 16, 'ProductTemplates.LBL_CURRENCY'            , 'CURRENCY_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 17, 'ProductTemplates.LBL_SUPPORT_NAME'        , 'SUPPORT_NAME'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 18, 'ProductTemplates.LBL_COST_PRICE'          , 'COST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 19, 'ProductTemplates.LBL_SUPPORT_CONTACT'     , 'SUPPORT_CONTACT'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 20, 'ProductTemplates.LBL_LIST_PRICE'          , 'LIST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 21, 'ProductTemplates.LBL_SUPPORT_DESCRIPTION' , 'SUPPORT_DESCRIPTION'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView.Mobile' , 22, 'ProductTemplates.LBL_DISCOUNT_PRICE'      , 'DISCOUNT_USDOLLAR'                 , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'ProductTemplates.DetailView.Mobile' , 23, 'ProductTemplates.LBL_SUPPORT_TERM'        , 'SUPPORT_TERM'                      , '{0}'        , 'support_term_dom'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'ProductTemplates.DetailView.Mobile' , 24, 'ProductTemplates.LBL_PRICING_FORMULA'     , 'PRICING_FORMULA'                   , '{0}'        , 'pricing_formula_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView.Mobile' , 25, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView.Mobile' , 26, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView.Mobile' , 27, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'ProductTemplates.DetailView.Mobile' , 28, 'TextBox', 'ProductTemplates.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_term_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.DetailView.Mobile', 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   ,  0, 'Quotes.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   ,  2, 'Quotes.LBL_QUOTE_NUM'             , 'QUOTE_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView.Mobile'   ,  3, 'Quotes.LBL_QUOTE_STAGE'           , 'QUOTE_STAGE'                       , '{0}'        , 'quote_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   ,  4, 'Quotes.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'      , 'DATE_QUOTE_EXPECTED_CLOSED'        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView.Mobile'   ,  6, 'Quotes.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   ,  7, 'Quotes.LBL_ORIGINAL_PO_DATE'      , 'ORIGINAL_PO_DATE'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   , 10, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   , 11, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Mobile'   , 12, 'Quotes.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Mobile'   , 13, 'Quotes.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Mobile'   , 14, 'Quotes.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Mobile'   , 15, 'Quotes.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   , 16, 'Quotes.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Mobile'   , 17, 'Quotes.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Quotes.DetailView.Mobile'   , 18, 'TextBox', 'Quotes.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.Mobile' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update DETAILVIEWS_FIELDS
		--   set LIST_NAME         = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where DETAIL_NAME       = 'Quotes.DetailView.Mobile'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and LIST_NAME         = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.SummaryView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.SummaryView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.SummaryView.Mobile', 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Mobile'  ,  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Mobile'  ,  1, 'Quotes.LBL_SUBTOTAL'              , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Mobile'  ,  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Mobile'  ,  3, 'Quotes.LBL_DISCOUNT'              , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Mobile'  ,  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Mobile'  ,  5, 'Quotes.LBL_SHIPPING'              , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Mobile'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Mobile'  ,  7, 'Quotes.LBL_TAX'                   , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.Mobile'  ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.Mobile'  ,  9, 'Quotes.LBL_TOTAL'                 , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_term_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.DetailView.Mobile', 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   ,  0, 'Orders.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   ,  1, 'Orders.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   ,  2, 'Orders.LBL_ORDER_NUM'             , 'ORDER_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView.Mobile'   ,  3, 'Orders.LBL_ORDER_STAGE'           , 'ORDER_STAGE'                       , '{0}'        , 'order_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   ,  4, 'Orders.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   ,  5, 'Orders.LBL_DATE_ORDER_DUE'        , 'DATE_ORDER_DUE'                    , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView.Mobile'   ,  6, 'Orders.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'    , 'DATE_ORDER_SHIPPED'                , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   , 10, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   , 11, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Mobile'   , 12, 'Orders.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Mobile'   , 13, 'Orders.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Mobile'   , 14, 'Orders.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Mobile'   , 15, 'Orders.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   , 16, 'Orders.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Mobile'   , 17, 'Orders.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Orders.DetailView.Mobile'   , 18, 'TextBox', 'Orders.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.Mobile' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update DETAILVIEWS_FIELDS
		--   set LIST_NAME         = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where DETAIL_NAME       = 'Orders.DetailView.Mobile'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and LIST_NAME         = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.SummaryView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.SummaryView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.SummaryView.Mobile', 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Mobile'  ,  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Mobile'  ,  1, 'Orders.LBL_SUBTOTAL'              , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Mobile'  ,  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Mobile'  ,  3, 'Orders.LBL_DISCOUNT'              , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Mobile'  ,  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Mobile'  ,  5, 'Orders.LBL_SHIPPING'              , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Mobile'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Mobile'  ,  7, 'Orders.LBL_TAX'                   , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.Mobile'  ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.Mobile'  ,  9, 'Orders.LBL_TOTAL'                 , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_term_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.DetailView.Mobile', 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' ,  0, 'Invoices.LBL_NAME'                 , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Mobile' ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'     , 'OPPORTUNITY_NAME'                  , '{0}'        , 'OPPORTUNITY_ID' , '~/Opportunities/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' ,  2, 'Invoices.LBL_INVOICE_NUM'          , 'INVOICE_NUM'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView.Mobile' ,  3, 'Invoices.LBL_INVOICE_STAGE'        , 'INVOICE_STAGE'                     , '{0}'        , 'invoice_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Mobile' ,  4, 'Invoices.LBL_QUOTE_NAME'           , 'QUOTE_NAME'                        , '{0}'        , 'QUOTE_ID'       , '~/Quotes/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView.Mobile' ,  5, 'Invoices.LBL_PAYMENT_TERMS'        , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Mobile' ,  6, 'Invoices.LBL_ORDER_NAME'           , 'ORDER_NAME'                        , '{0}'        , 'ORDER_ID'       , '~/Orders/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' ,  7, 'Invoices.LBL_DUE_DATE'             , 'DUE_DATE'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.DetailView.Mobile' ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' ,  9, 'Invoices.LBL_PURCHASE_ORDER_NUM'   , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' , 10, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' , 11, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' , 12, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' , 13, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Mobile' , 14, 'Invoices.LBL_BILLING_CONTACT_NAME' , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Mobile' , 15, 'Invoices.LBL_SHIPPING_CONTACT_NAME', 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Mobile' , 16, 'Invoices.LBL_BILLING_ACCOUNT_NAME' , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Mobile' , 17, 'Invoices.LBL_SHIPPING_ACCOUNT_NAME', 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' , 18, 'Invoices.LBL_BILLING_ADDRESS'      , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Mobile' , 19, 'Invoices.LBL_SHIPPING_ADDRESS'     , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Invoices.DetailView.Mobile' , 20, 'TextBox', 'Invoices.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.Mobile' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update DETAILVIEWS_FIELDS
		--   set LIST_NAME         = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where DETAIL_NAME       = 'Invoices.DetailView.Mobile'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and LIST_NAME         = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.SummaryView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.SummaryView.Mobile', 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Mobile',  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Mobile',  1, 'Invoices.LBL_SUBTOTAL'            , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Mobile',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Mobile',  3, 'Invoices.LBL_DISCOUNT'            , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Mobile',  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Mobile',  5, 'Invoices.LBL_SHIPPING'            , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Mobile',  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Mobile',  7, 'Invoices.LBL_TAX'                 , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.Mobile',  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.Mobile',  9, 'Invoices.LBL_TOTAL'               , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO


-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Payments.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Payments.DetailView.Mobile', 'Payments', 'vwPAYMENTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Mobile' ,  0, 'Payments.LBL_AMOUNT'               , 'AMOUNT_USDOLLAR'                   , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Payments.DetailView.Mobile' ,  1, 'Payments.LBL_ACCOUNT_NAME'         , 'ACCOUNT_NAME'                      , '{0}'        , 'ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Mobile' ,  2, 'Payments.LBL_PAYMENT_DATE'         , 'PAYMENT_DATE'                      , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Mobile' ,  3, 'Payments.LBL_CUSTOMER_REFERENCE'   , 'CUSTOMER_REFERENCE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Payments.DetailView.Mobile' ,  4, 'Payments.LBL_PAYMENT_TYPE'         , 'PAYMENT_TYPE'                      , '{0}'        , 'payment_type_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Mobile' ,  5, 'Payments.LBL_PAYMENT_NUM'          , 'PAYMENT_NUM'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Mobile' ,  6, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView.Mobile' ,  7, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Payments.DetailView.Mobile' ,  8, 'TextBox', 'Payments.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView.Mobile' and DATA_FIELD = 'PAYMENT_TYPE' and LIST_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
		--update DETAILVIEWS_FIELDS
		--   set LIST_NAME         = 'PaymentTypes'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where DETAIL_NAME       = 'Payments.DetailView.Mobile'
		--   and DATA_FIELD        = 'PAYMENT_TYPE'
		--   and LIST_NAME         = 'payment_type_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.SummaryView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Payments.SummaryView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Payments.SummaryView.Mobile', 'Invoices', 'vwPAYMENTS_Edit', '25%', '75%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.SummaryView.Mobile',  0, 'Payments.LBL_ALLOCATED'             , 'TOTAL_ALLOCATED_USDOLLAR'         , '{0:c}'      , null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Forums.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Forums.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_InsertOnly          'Forums.DetailView.Mobile', 'Forums', 'vwFORUMS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView.Mobile'   ,  0, 'Forums.LBL_TITLE'                  , 'TITLE'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView.Mobile'   ,  1, 'Forums.LBL_CATEGORY'               , 'CATEGORY'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView.Mobile'   ,  2, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Forums.DetailView.Mobile'   ,  3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView.Mobile'   ,  4, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView.Mobile'   ,  5, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Forums.DetailView.Mobile'   ,  6, 'TextBox', 'Forums.LBL_DESCRIPTION' , 'DESCRIPTION', null, null, null, null, null, 3, null;
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

call dbo.spDETAILVIEWS_FIELDS_MobileProfessional()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_MobileProfessional')
/

-- #endif IBM_DB2 */


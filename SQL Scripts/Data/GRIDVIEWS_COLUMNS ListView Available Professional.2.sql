

print 'GRIDVIEWS_COLUMNS ListView Available Professional';
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like '%.ListView.Available'
--GO

set nocount on;
GO


if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.ListView.Available' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.ListView.Available';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.ListView.Available'        , 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView.Available'       , null, 'Contracts.LBL_LIST_REFERENCE_CODE'                    , 'REFERENCE_CODE'             , 'REFERENCE_CODE'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView.Available'       , null, 'Contracts.LBL_LIST_OPPORTUNITY_NAME'                  , 'OPPORTUNITY_NAME'           , 'OPPORTUNITY_NAME'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView.Available'       , null, 'Contracts.LBL_LIST_COMPANY_SIGNED_DATE'               , 'COMPANY_SIGNED_DATE'        , 'COMPANY_SIGNED_DATE'        , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView.Available'       , null, 'Contracts.LBL_LIST_TOTAL_CONTRACT_VALUE'              , 'TOTAL_CONTRACT_VALUE'       , 'TOTAL_CONTRACT_VALUE'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView.Available'       , null, 'Contracts.LBL_LIST_CUSTOMER_SIGNED_DATE'              , 'CUSTOMER_SIGNED_DATE'       , 'CUSTOMER_SIGNED_DATE'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.ListView.Available'       , null, '.LBL_LIST_DATE_MODIFIED'                              , 'DATE_MODIFIED'              , 'DATE_MODIFIED'              , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Contracts.ListView.Available'       , null, '.LBL_LIST_DATE_ENTERED'                               , 'DATE_ENTERED'               , 'DATE_ENTERED'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView.Available'       , null, 'Contracts.LBL_LIST_EXPIRATION_NOTICE'                 , 'EXPIRATION_NOTICE'          , 'EXPIRATION_NOTICE'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.ListView.Available'       , null, 'Contracts.LBL_LIST_TYPE'                              , 'TYPE'                       , 'TYPE'                       , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.ListView.Available' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.ListView.Available';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.ListView.Available'        , 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_OPPORTUNITY_NAME'                   , 'OPPORTUNITY_NAME'           , 'OPPORTUNITY_NAME'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_QUOTE_NAME'                         , 'QUOTE_NAME'                 , 'QUOTE_NAME'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_PAYMENT_TERMS'                      , 'PAYMENT_TERMS'              , 'PAYMENT_TERMS'              , '10%', 'payment_terms_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_ORDER_NAME'                         , 'ORDER_NAME'                 , 'ORDER_NAME'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_SHIP_DATE'                          , 'SHIP_DATE'                  , 'SHIP_DATE'                  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_PURCHASE_ORDER_NUM'                 , 'PURCHASE_ORDER_NUM'         , 'PURCHASE_ORDER_NUM'         , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.Available'        , null, '.LBL_LIST_DATE_ENTERED'                               , 'DATE_ENTERED'               , 'DATE_ENTERED'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Invoices.ListView.Available'        , null, '.LBL_LIST_DATE_MODIFIED'                              , 'DATE_MODIFIED'              , 'DATE_MODIFIED'              , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_BILLING_CONTACT_NAME'               , 'BILLING_CONTACT_NAME'       , 'BILLING_CONTACT_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_SHIPPING_CONTACT_NAME'              , 'SHIPPING_CONTACT_NAME'      , 'SHIPPING_CONTACT_NAME'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_SHIPPING_ACCOUNT_NAME'              , 'SHIPPING_ACCOUNT_NAME'      , 'SHIPPING_ACCOUNT_NAME'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_BILLING_ADDRESS_HTML'               , 'BILLING_ADDRESS_HTML'       , 'BILLING_ADDRESS_HTML'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.ListView.Available'        , null, 'Invoices.LBL_LIST_SHIPPING_ADDRESS_HTML'              , 'SHIPPING_ADDRESS_HTML'      , 'SHIPPING_ADDRESS_HTML'      , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.ListView.Available' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS KBDocuments.ListView.Available';
	exec dbo.spGRIDVIEWS_InsertOnly           'KBDocuments.ListView.Available'     , 'KBDocuments', 'vwKBDOCUMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.ListView.Available'     , null, 'KBDocuments.LBL_LIST_REVISION'                        , 'REVISION'                   , 'REVISION'                   , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'KBDocuments.ListView.Available'     , null, 'KBDocuments.LBL_LIST_STATUS'                          , 'STATUS'                     , 'STATUS'                     , '10%', 'kbdocument_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.ListView.Available'     , null, 'KBDocuments.LBL_LIST_ACTIVE_DATE'                     , 'ACTIVE_DATE'                , 'ACTIVE_DATE'                , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.ListView.Available'     , null, 'KBDocuments.LBL_LIST_EXP_DATE'                        , 'EXP_DATE'                   , 'EXP_DATE'                   , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.ListView.Available' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.ListView.Available';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.ListView.Available'          , 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_OPPORTUNITY_NAME'                     , 'OPPORTUNITY_NAME'           , 'OPPORTUNITY_NAME'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_PURCHASE_ORDER_NUM'                   , 'PURCHASE_ORDER_NUM'         , 'PURCHASE_ORDER_NUM'         , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_PAYMENT_TERMS'                        , 'PAYMENT_TERMS'              , 'PAYMENT_TERMS'              , '10%', 'payment_terms_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_DATE_ORDER_SHIPPED'                   , 'DATE_ORDER_SHIPPED'         , 'DATE_ORDER_SHIPPED'         , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.Available'          , null, '.LBL_LIST_DATE_ENTERED'                               , 'DATE_ENTERED'               , 'DATE_ENTERED'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Orders.ListView.Available'          , null, '.LBL_LIST_DATE_MODIFIED'                              , 'DATE_MODIFIED'              , 'DATE_MODIFIED'              , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_BILLING_CONTACT_NAME'                 , 'BILLING_CONTACT_NAME'       , 'BILLING_CONTACT_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_SHIPPING_CONTACT_NAME'                , 'SHIPPING_CONTACT_NAME'      , 'SHIPPING_CONTACT_NAME'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_SHIPPING_ACCOUNT_NAME'                , 'SHIPPING_ACCOUNT_NAME'      , 'SHIPPING_ACCOUNT_NAME'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_BILLING_ADDRESS_HTML'                 , 'BILLING_ADDRESS_HTML'       , 'BILLING_ADDRESS_HTML'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_SHIPPING_ADDRESS_HTML'                , 'SHIPPING_ADDRESS_HTML'      , 'SHIPPING_ADDRESS_HTML'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.ListView.Available'          , null, 'Orders.LBL_LIST_START_DATE_C'                         , 'START_DATE_C'               , 'START_DATE_C'               , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.ListView.Available' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.ListView.Available';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.ListView.Available'        , 'Payments', 'vwPAYMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.ListView.Available'        , null, 'Payments.LBL_LIST_BANK_FEE_USDOLLAR'                  , 'BANK_FEE_USDOLLAR'          , 'BANK_FEE_USDOLLAR'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.ListView.Available'        , null, 'Payments.LBL_LIST_CUSTOMER_REFERENCE'                 , 'CUSTOMER_REFERENCE'         , 'CUSTOMER_REFERENCE'         , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView.Available'        , null, '.LBL_LIST_DATE_MODIFIED'                              , 'DATE_MODIFIED'              , 'DATE_MODIFIED'              , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Payments.ListView.Available'        , null, '.LBL_LIST_DATE_ENTERED'                               , 'DATE_ENTERED'               , 'DATE_ENTERED'               , '10%', 'DateTime';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.ListView.Available' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS ProductTemplates.ListView.Available';
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.ListView.Available'        , 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_WEBSITE'                    , 'WEBSITE'                    , 'WEBSITE'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_DATE_AVAILABLE'             , 'DATE_AVAILABLE'             , 'DATE_AVAILABLE'             , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_TAX_CLASS'                  , 'TAX_CLASS'                  , 'TAX_CLASS'                  , '10%', 'tax_class_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_MINIMUM_QUANTITY'           , 'MINIMUM_QUANTITY'           , 'MINIMUM_QUANTITY'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_MAXIMUM_QUANTITY'           , 'MAXIMUM_QUANTITY'           , 'MAXIMUM_QUANTITY'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_LIST_ORDER'                 , 'LIST_ORDER'                 , 'LIST_ORDER'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_MANUFACTURER_NAME'          , 'MANUFACTURER_NAME'          , 'MANUFACTURER_NAME'          , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_WEIGHT'                     , 'WEIGHT'                     , 'WEIGHT'                     , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_MFT_PART_NUM'               , 'MFT_PART_NUM'               , 'MFT_PART_NUM'               , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_VENDOR_PART_NUM'            , 'VENDOR_PART_NUM'            , 'VENDOR_PART_NUM'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_MINIMUM_OPTIONS'            , 'MINIMUM_OPTIONS'            , 'MINIMUM_OPTIONS'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_MAXIMUM_OPTIONS'            , 'MAXIMUM_OPTIONS'            , 'MAXIMUM_OPTIONS'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_CURRENCY_NAME'              , 'CURRENCY_NAME'              , 'CURRENCY_NAME'              , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_SUPPORT_NAME'               , 'SUPPORT_NAME'               , 'SUPPORT_NAME'               , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_SUPPORT_CONTACT'            , 'SUPPORT_CONTACT'            , 'SUPPORT_CONTACT'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_SUPPORT_DESCRIPTION'        , 'SUPPORT_DESCRIPTION'        , 'SUPPORT_DESCRIPTION'        , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_SUPPORT_TERM'               , 'SUPPORT_TERM'               , 'SUPPORT_TERM'               , '10%', 'support_term_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_DISCOUNT_NAME'              , 'DISCOUNT_NAME'              , 'DISCOUNT_NAME'              , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_PRICING_FORMULA'            , 'PRICING_FORMULA'            , 'PRICING_FORMULA'            , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.ListView.Available', null, 'ProductTemplates.LBL_LIST_PRICING_FACTOR'             , 'PRICING_FACTOR'             , 'PRICING_FACTOR'             , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.ListView.Available' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.ListView.Available';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.ListView.Available'          , 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Available'          , null, 'Quotes.LBL_LIST_OPPORTUNITY_NAME'                     , 'OPPORTUNITY_NAME'           , 'OPPORTUNITY_NAME'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Available'          , null, 'Quotes.LBL_LIST_PURCHASE_ORDER_NUM'                   , 'PURCHASE_ORDER_NUM'         , 'PURCHASE_ORDER_NUM'         , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Quotes.ListView.Available'          , null, 'Quotes.LBL_LIST_PAYMENT_TERMS'                        , 'PAYMENT_TERMS'              , 'PAYMENT_TERMS'              , '10%', 'payment_terms_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Available'          , null, 'Quotes.LBL_LIST_ORIGINAL_PO_DATE'                     , 'ORIGINAL_PO_DATE'           , 'ORIGINAL_PO_DATE'           , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.Available'          , null, '.LBL_LIST_DATE_ENTERED'                               , 'DATE_ENTERED'               , 'DATE_ENTERED'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Quotes.ListView.Available'          , null, '.LBL_LIST_DATE_MODIFIED'                              , 'DATE_MODIFIED'              , 'DATE_MODIFIED'              , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Available'          , null, 'Quotes.LBL_LIST_BILLING_CONTACT_NAME'                 , 'BILLING_CONTACT_NAME'       , 'BILLING_CONTACT_NAME'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Available'          , null, 'Quotes.LBL_LIST_SHIPPING_CONTACT_NAME'                , 'SHIPPING_CONTACT_NAME'      , 'SHIPPING_CONTACT_NAME'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Available'          , null, 'Quotes.LBL_LIST_SHIPPING_ACCOUNT_NAME'                , 'SHIPPING_ACCOUNT_NAME'      , 'SHIPPING_ACCOUNT_NAME'      , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Available'          , null, 'Quotes.LBL_LIST_BILLING_ADDRESS_HTML'                 , 'BILLING_ADDRESS_HTML'       , 'BILLING_ADDRESS_HTML'       , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.ListView.Available'          , null, 'Quotes.LBL_LIST_SHIPPING_ADDRESS_HTML'                , 'SHIPPING_ADDRESS_HTML'      , 'SHIPPING_ADDRESS_HTML'      , '10%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Surveys.ListView.Available' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Surveys.ListView.Available';
	exec dbo.spGRIDVIEWS_InsertOnly           'Surveys.ListView.Available'        , 'Surveys', 'vwSURVEYS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView.Available'         , null, 'Surveys.LBL_LIST_ASSIGNED_TO'                         , 'ASSIGNED_TO'                , 'ASSIGNED_TO'                , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Surveys.ListView.Available'         , null, 'Surveys.LBL_LIST_PAGE_RANDOMIZATION'                  , 'PAGE_RANDOMIZATION'         , 'PAGE_RANDOMIZATION'         , '10%', 'survey_page_randomization';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Surveys.ListView.Available'         , null, '.LBL_LIST_DATE_MODIFIED'                              , 'DATE_MODIFIED'              , 'DATE_MODIFIED'              , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Surveys.ListView.Available'         , null, '.LBL_LIST_DATE_ENTERED'                               , 'DATE_ENTERED'               , 'DATE_ENTERED'               , '10%', 'DateTime';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView.Available'         , null, 'Surveys.LBL_LIST_SURVEY_URL'                          , 'SURVEY_URL'                 , 'SURVEY_URL'                 , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView.Available'         , null, 'Surveys.LBL_LIST_DESCRIPTION'                         , 'DESCRIPTION'                , 'DESCRIPTION'                , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate 'Surveys.ListView.Available'         , null, 'Surveys.LBL_LIST_LOOP_SURVEY'                         , 'LOOP_SURVEY'                , 'LOOP_SURVEY'                , '10%', 'CheckBox';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList 'Surveys.ListView.Available'         , null, 'Surveys.LBL_LIST_SURVEY_TARGET_ASSIGNMENT'            , 'SURVEY_TARGET_ASSIGNMENT'   , 'SURVEY_TARGET_ASSIGNMENT'   , '10%', 'survey_target_assignment_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView.Available'         , null, 'Surveys.LBL_LIST_TIMEOUT'                             , 'TIMEOUT'                    , 'TIMEOUT'                    , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Surveys.ListView.Available'         , null, 'Surveys.LBL_LIST_SURVEY_TARGET_MODULE'                , 'SURVEY_TARGET_MODULE'       , 'SURVEY_TARGET_MODULE'       , '10%';
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

call dbo.spGRIDVIEWS_COLUMNS_ListViewsAvailPro()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ListViewsAvailPro')
/

-- #endif IBM_DB2 */


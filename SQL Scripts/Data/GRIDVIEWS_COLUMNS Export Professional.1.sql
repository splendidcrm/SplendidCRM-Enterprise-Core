

print 'GRIDVIEWS_COLUMNS ListView Professional';
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like '%.Export'
--GO

set nocount on;
GO

-- 05/24/2020 Paul.  Correct for global terms for DATE_ENTERED, DATE_MODIFIED, TEAM_NAME, ASSIGNED_TO_NAME, CREATED_BY_NAME, MODIFIED_BY_NAME

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contracts.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Contracts.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'Contracts.Export'        , 'Contracts', 'vwCONTRACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        ,  1, 'Contracts.LBL_LIST_NAME'                           , 'NAME'                         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        ,  2, 'Contracts.LBL_LIST_REFERENCE_CODE'                 , 'REFERENCE_CODE'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        ,  3, 'Contracts.LBL_LIST_STATUS'                         , 'STATUS'                       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        ,  4, 'Contracts.LBL_LIST_TYPE'                           , 'TYPE'                         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        ,  5, 'Contracts.LBL_LIST_START_DATE'                     , 'START_DATE'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        ,  6, 'Contracts.LBL_LIST_END_DATE'                       , 'END_DATE'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        ,  7, 'Contracts.LBL_LIST_COMPANY_SIGNED_DATE'            , 'COMPANY_SIGNED_DATE'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        ,  8, 'Contracts.LBL_LIST_CUSTOMER_SIGNED_DATE'           , 'CUSTOMER_SIGNED_DATE'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        ,  9, 'Contracts.LBL_LIST_EXPIRATION_NOTICE'              , 'EXPIRATION_NOTICE'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 10, 'Contracts.LBL_LIST_CURRENCY_NAME'                  , 'CURRENCY_NAME'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 11, 'Contracts.LBL_LIST_CURRENCY_SYMBOL'                , 'CURRENCY_SYMBOL'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 12, 'Contracts.LBL_LIST_CURRENCY_CONVERSION_RATE'       , 'CURRENCY_CONVERSION_RATE'     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 13, 'Contracts.LBL_LIST_TOTAL_CONTRACT_VALUE'           , 'TOTAL_CONTRACT_VALUE'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 14, 'Contracts.LBL_LIST_TOTAL_CONTRACT_VALUE_USDOLLAR'  , 'TOTAL_CONTRACT_VALUE_USDOLLAR', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 15, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 16, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 17, 'Contracts.LBL_LIST_DESCRIPTION'                    , 'DESCRIPTION'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 18, 'Contracts.LBL_LIST_ACCOUNT_NAME'                   , 'ACCOUNT_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 19, 'Contracts.LBL_LIST_OPPORTUNITY_NAME'               , 'OPPORTUNITY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 20, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 21, '.LBL_LIST_ASSIGNED_TO_NAME'                        , 'ASSIGNED_TO_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 22, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Contracts.Export'        , 23, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Products.Export' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'Products.Export'         , 'Products', 'vwPRODUCTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         ,  1, 'Products.LBL_LIST_PRODUCT_NAME'                    , 'PRODUCT_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         ,  2, 'Products.LBL_LIST_LINE_ITEM_TYPE'                  , 'LINE_ITEM_TYPE'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         ,  3, 'Products.LBL_LIST_POSITION'                        , 'POSITION'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         ,  4, 'Products.LBL_LIST_NAME'                            , 'NAME'                         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         ,  5, 'Products.LBL_LIST_MFT_PART_NUM'                    , 'MFT_PART_NUM'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         ,  6, 'Products.LBL_LIST_VENDOR_PART_NUM'                 , 'VENDOR_PART_NUM'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         ,  7, 'Products.LBL_LIST_TAX_CLASS'                       , 'TAX_CLASS'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         ,  8, 'Products.LBL_LIST_QUANTITY'                        , 'QUANTITY'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         ,  9, 'Products.LBL_LIST_COST_PRICE'                      , 'COST_PRICE'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 10, 'Products.LBL_LIST_COST_USDOLLAR'                   , 'COST_USDOLLAR'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 11, 'Products.LBL_LIST_LIST_PRICE'                      , 'LIST_PRICE'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 12, 'Products.LBL_LIST_LIST_USDOLLAR'                   , 'LIST_USDOLLAR'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 13, 'Products.LBL_LIST_UNIT_PRICE'                      , 'UNIT_PRICE'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 14, 'Products.LBL_LIST_UNIT_USDOLLAR'                   , 'UNIT_USDOLLAR'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 15, 'Products.LBL_LIST_EXTENDED_PRICE'                  , 'EXTENDED_PRICE'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 16, 'Products.LBL_LIST_EXTENDED_USDOLLAR'               , 'EXTENDED_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 17, 'Products.LBL_LIST_DESCRIPTION'                     , 'DESCRIPTION'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 18, 'Products.LBL_LIST_ORDER_NAME'                      , 'ORDER_NAME'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 19, 'Products.LBL_LIST_ORDER_STAGE'                     , 'ORDER_STAGE'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 20, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 21, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 22, 'Products.LBL_LIST_DATE_PURCHASED'                  , 'DATE_PURCHASED'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 23, 'Products.LBL_LIST_DATE_SUPPORT_EXPIRES'            , 'DATE_SUPPORT_EXPIRES'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 24, 'Products.LBL_LIST_DATE_SUPPORT_STARTS'             , 'DATE_SUPPORT_STARTS'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 25, 'Products.LBL_LIST_MANUFACTURER_NAME'               , 'MANUFACTURER_NAME'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 26, 'Products.LBL_LIST_CATEGORY_NAME'                   , 'CATEGORY_NAME'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 27, 'Products.LBL_LIST_TYPE_NAME'                       , 'TYPE_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 28, 'Products.LBL_LIST_CURRENCY_NAME'                   , 'CURRENCY_NAME'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 29, 'Products.LBL_LIST_CURRENCY_SYMBOL'                 , 'CURRENCY_SYMBOL'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 30, 'Products.LBL_LIST_CURRENCY_CONVERSION_RATE'        , 'CURRENCY_CONVERSION_RATE'     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 31, 'Products.LBL_LIST_ACCOUNT_NAME'                    , 'ACCOUNT_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 32, 'Products.LBL_LIST_CONTACT_NAME'                    , 'CONTACT_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 33, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 34, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 35, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Products.Export'         , 36, 'Products.LBL_LIST_BILLING_TYPE_C'                  , 'BILLING_TYPE_C'               , null, null;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'ProductTemplates.Export' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_InsertOnly           'ProductTemplates.Export'  , 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' ,  1, 'ProductTemplates.LBL_LIST_NAME'                    , 'NAME'                         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' ,  2, 'ProductTemplates.LBL_LIST_STATUS'                  , 'STATUS'                       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' ,  3, 'ProductTemplates.LBL_LIST_QUANTITY'                , 'QUANTITY'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' ,  4, 'ProductTemplates.LBL_LIST_DATE_AVAILABLE'          , 'DATE_AVAILABLE'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' ,  5, 'ProductTemplates.LBL_LIST_DATE_COST_PRICE'         , 'DATE_COST_PRICE'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' ,  6, 'ProductTemplates.LBL_LIST_WEBSITE'                 , 'WEBSITE'                      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' ,  7, 'ProductTemplates.LBL_LIST_MFT_PART_NUM'            , 'MFT_PART_NUM'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' ,  8, 'ProductTemplates.LBL_LIST_VENDOR_PART_NUM'         , 'VENDOR_PART_NUM'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' ,  9, 'ProductTemplates.LBL_LIST_TAX_CLASS'               , 'TAX_CLASS'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 10, 'ProductTemplates.LBL_LIST_WEIGHT'                  , 'WEIGHT'                       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 11, 'ProductTemplates.LBL_LIST_MINIMUM_OPTIONS'         , 'MINIMUM_OPTIONS'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 12, 'ProductTemplates.LBL_LIST_MAXIMUM_OPTIONS'         , 'MAXIMUM_OPTIONS'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 13, 'ProductTemplates.LBL_LIST_CURRENCY_NAME'           , 'CURRENCY_NAME'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 14, 'ProductTemplates.LBL_LIST_CURRENCY_SYMBOL'         , 'CURRENCY_SYMBOL'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 15, 'ProductTemplates.LBL_LIST_CURRENCY_CONVERSION_RATE', 'CURRENCY_CONVERSION_RATE'     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 16, 'ProductTemplates.LBL_LIST_COST_PRICE'              , 'COST_PRICE'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 17, 'ProductTemplates.LBL_LIST_COST_USDOLLAR'           , 'COST_USDOLLAR'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 18, 'ProductTemplates.LBL_LIST_LIST_PRICE'              , 'LIST_PRICE'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 19, 'ProductTemplates.LBL_LIST_LIST_USDOLLAR'           , 'LIST_USDOLLAR'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 20, 'ProductTemplates.LBL_LIST_DISCOUNT_PRICE'          , 'DISCOUNT_PRICE'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 21, 'ProductTemplates.LBL_LIST_DISCOUNT_USDOLLAR'       , 'DISCOUNT_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 22, 'ProductTemplates.LBL_LIST_PRICING_FORMULA'         , 'PRICING_FORMULA'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 23, 'ProductTemplates.LBL_LIST_PRICING_FACTOR'          , 'PRICING_FACTOR'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 24, 'ProductTemplates.LBL_LIST_SUPPORT_NAME'            , 'SUPPORT_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 25, 'ProductTemplates.LBL_LIST_SUPPORT_CONTACT'         , 'SUPPORT_CONTACT'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 26, 'ProductTemplates.LBL_LIST_SUPPORT_DESCRIPTION'     , 'SUPPORT_DESCRIPTION'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 27, 'ProductTemplates.LBL_LIST_SUPPORT_TERM'            , 'SUPPORT_TERM'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 28, 'ProductTemplates.LBL_LIST_ACCOUNT_NAME'            , 'ACCOUNT_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 29, 'ProductTemplates.LBL_LIST_MANUFACTURER_NAME'       , 'MANUFACTURER_NAME'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 30, 'ProductTemplates.LBL_LIST_CATEGORY_NAME'           , 'CATEGORY_NAME'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 31, 'ProductTemplates.LBL_LIST_TYPE_NAME'               , 'TYPE_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 32, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 33, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 34, 'ProductTemplates.LBL_LIST_DESCRIPTION'             , 'DESCRIPTION'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 35, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 36, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 37, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'ProductTemplates.Export' , 38, '.LBL_LIST_DISCOUNT_NAME'                           , 'DISCOUNT_NAME'                , null, null;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Quotes.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Quotes.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'Quotes.Export'           , 'Quotes', 'vwQUOTES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           ,  1, 'Quotes.LBL_LIST_QUOTE_NUM'                         , 'QUOTE_NUM'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           ,  2, 'Quotes.LBL_LIST_NAME'                              , 'NAME'                         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           ,  3, 'Quotes.LBL_LIST_QUOTE_TYPE'                        , 'QUOTE_TYPE'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           ,  4, 'Quotes.LBL_LIST_PAYMENT_TERMS'                     , 'PAYMENT_TERMS'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           ,  5, 'Quotes.LBL_LIST_ORDER_STAGE'                       , 'ORDER_STAGE'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           ,  6, 'Quotes.LBL_LIST_QUOTE_STAGE'                       , 'QUOTE_STAGE'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           ,  7, 'Quotes.LBL_LIST_PURCHASE_ORDER_NUM'                , 'PURCHASE_ORDER_NUM'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           ,  8, 'Quotes.LBL_LIST_ORIGINAL_PO_DATE'                  , 'ORIGINAL_PO_DATE'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           ,  9, 'Quotes.LBL_LIST_DATE_QUOTE_CLOSED'                 , 'DATE_QUOTE_CLOSED'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 10, 'Quotes.LBL_LIST_DATE_QUOTE_EXPECTED_CLOSED'        , 'DATE_QUOTE_EXPECTED_CLOSED'   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 11, 'Quotes.LBL_LIST_DATE_ORDER_SHIPPED'                , 'DATE_ORDER_SHIPPED'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 12, 'Quotes.LBL_LIST_SHOW_LINE_NUMS'                    , 'SHOW_LINE_NUMS'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 13, 'Quotes.LBL_LIST_CALC_GRAND_TOTAL'                  , 'CALC_GRAND_TOTAL'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 14, 'Quotes.LBL_LIST_EXCHANGE_RATE'                     , 'EXCHANGE_RATE'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 15, 'Quotes.LBL_LIST_SUBTOTAL'                          , 'SUBTOTAL'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 16, 'Quotes.LBL_LIST_SUBTOTAL_USDOLLAR'                 , 'SUBTOTAL_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 17, 'Quotes.LBL_LIST_DISCOUNT'                          , 'DISCOUNT'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 18, 'Quotes.LBL_LIST_DISCOUNT_USDOLLAR'                 , 'DISCOUNT_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 19, 'Quotes.LBL_LIST_SHIPPING'                          , 'SHIPPING'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 20, 'Quotes.LBL_LIST_SHIPPING_USDOLLAR'                 , 'SHIPPING_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 21, 'Quotes.LBL_LIST_TAX'                               , 'TAX'                          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 22, 'Quotes.LBL_LIST_TAX_USDOLLAR'                      , 'TAX_USDOLLAR'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 23, 'Quotes.LBL_LIST_TOTAL'                             , 'TOTAL'                        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 24, 'Quotes.LBL_LIST_TOTAL_USDOLLAR'                    , 'TOTAL_USDOLLAR'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 25, 'Quotes.LBL_LIST_BILLING_ADDRESS_STREET'            , 'BILLING_ADDRESS_STREET'       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 26, 'Quotes.LBL_LIST_BILLING_ADDRESS_CITY'              , 'BILLING_ADDRESS_CITY'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 27, 'Quotes.LBL_LIST_BILLING_ADDRESS_STATE'             , 'BILLING_ADDRESS_STATE'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 28, 'Quotes.LBL_LIST_BILLING_ADDRESS_POSTALCODE'        , 'BILLING_ADDRESS_POSTALCODE'   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 29, 'Quotes.LBL_LIST_BILLING_ADDRESS_COUNTRY'           , 'BILLING_ADDRESS_COUNTRY'      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 30, 'Quotes.LBL_LIST_SHIPPING_ADDRESS_STREET'           , 'SHIPPING_ADDRESS_STREET'      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 31, 'Quotes.LBL_LIST_SHIPPING_ADDRESS_CITY'             , 'SHIPPING_ADDRESS_CITY'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 32, 'Quotes.LBL_LIST_SHIPPING_ADDRESS_STATE'            , 'SHIPPING_ADDRESS_STATE'       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 33, 'Quotes.LBL_LIST_SHIPPING_ADDRESS_POSTALCODE'       , 'SHIPPING_ADDRESS_POSTALCODE'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 34, 'Quotes.LBL_LIST_SHIPPING_ADDRESS_COUNTRY'          , 'SHIPPING_ADDRESS_COUNTRY'     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 35, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 36, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 37, 'Quotes.LBL_LIST_DESCRIPTION'                       , 'DESCRIPTION'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 38, 'Quotes.LBL_LIST_BILLING_ACCOUNT_NAME'              , 'BILLING_ACCOUNT_NAME'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 39, 'Quotes.LBL_LIST_SHIPPING_ACCOUNT_NAME'             , 'SHIPPING_ACCOUNT_NAME'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 40, 'Quotes.LBL_LIST_BILLING_CONTACT_NAME'              , 'BILLING_CONTACT_NAME'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 41, 'Quotes.LBL_LIST_SHIPPING_CONTACT_NAME'             , 'SHIPPING_CONTACT_NAME'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 42, 'Quotes.LBL_LIST_OPPORTUNITY_NAME'                  , 'OPPORTUNITY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 43, 'Quotes.LBL_LIST_LEAD_SOURCE'                       , 'LEAD_SOURCE'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 44, 'Quotes.LBL_LIST_NEXT_STEP'                         , 'NEXT_STEP'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 45, 'Quotes.LBL_LIST_TAXRATE_NAME'                      , 'TAXRATE_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 46, 'Quotes.LBL_LIST_TAXRATE_VALUE'                     , 'TAXRATE_VALUE'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 47, 'Quotes.LBL_LIST_SHIPPER_NAME'                      , 'SHIPPER_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 48, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 49, 'Quotes.LBL_LIST_CURRENCY_NAME'                     , 'CURRENCY_NAME'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 50, 'Quotes.LBL_LIST_CURRENCY_SYMBOL'                   , 'CURRENCY_SYMBOL'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 51, '.LBL_LIST_ASSIGNED_TO_NAME'                        , 'ASSIGNED_TO_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 52, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 53, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Quotes.Export'           , 54, 'Quotes.LBL_LIST_ACCOUNT_NAME'                      , 'ACCOUNT_NAME'                 , null, null;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Orders.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Orders.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'Orders.Export'           , 'Orders', 'vwORDERS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           ,  1, 'Orders.LBL_LIST_ORDER_NUM'                         , 'ORDER_NUM'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           ,  2, 'Orders.LBL_LIST_NAME'                              , 'NAME'                         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           ,  3, 'Orders.LBL_LIST_PAYMENT_TERMS'                     , 'PAYMENT_TERMS'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           ,  4, 'Orders.LBL_LIST_ORDER_STAGE'                       , 'ORDER_STAGE'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           ,  5, 'Orders.LBL_LIST_PURCHASE_ORDER_NUM'                , 'PURCHASE_ORDER_NUM'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           ,  6, 'Orders.LBL_LIST_ORIGINAL_PO_DATE'                  , 'ORIGINAL_PO_DATE'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           ,  7, 'Orders.LBL_LIST_DATE_ORDER_DUE'                    , 'DATE_ORDER_DUE'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           ,  8, 'Orders.LBL_LIST_DATE_ORDER_SHIPPED'                , 'DATE_ORDER_SHIPPED'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           ,  9, 'Orders.LBL_LIST_SHOW_LINE_NUMS'                    , 'SHOW_LINE_NUMS'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 10, 'Orders.LBL_LIST_CALC_GRAND_TOTAL'                  , 'CALC_GRAND_TOTAL'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 11, 'Orders.LBL_LIST_EXCHANGE_RATE'                     , 'EXCHANGE_RATE'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 12, 'Orders.LBL_LIST_SUBTOTAL'                          , 'SUBTOTAL'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 13, 'Orders.LBL_LIST_SUBTOTAL_USDOLLAR'                 , 'SUBTOTAL_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 14, 'Orders.LBL_LIST_DISCOUNT'                          , 'DISCOUNT'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 15, 'Orders.LBL_LIST_DISCOUNT_USDOLLAR'                 , 'DISCOUNT_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 16, 'Orders.LBL_LIST_SHIPPING'                          , 'SHIPPING'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 17, 'Orders.LBL_LIST_SHIPPING_USDOLLAR'                 , 'SHIPPING_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 18, 'Orders.LBL_LIST_TAX'                               , 'TAX'                          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 19, 'Orders.LBL_LIST_TAX_USDOLLAR'                      , 'TAX_USDOLLAR'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 20, 'Orders.LBL_LIST_TOTAL'                             , 'TOTAL'                        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 21, 'Orders.LBL_LIST_TOTAL_USDOLLAR'                    , 'TOTAL_USDOLLAR'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 22, 'Orders.LBL_LIST_BILLING_ADDRESS_STREET'            , 'BILLING_ADDRESS_STREET'       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 23, 'Orders.LBL_LIST_BILLING_ADDRESS_CITY'              , 'BILLING_ADDRESS_CITY'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 24, 'Orders.LBL_LIST_BILLING_ADDRESS_STATE'             , 'BILLING_ADDRESS_STATE'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 25, 'Orders.LBL_LIST_BILLING_ADDRESS_POSTALCODE'        , 'BILLING_ADDRESS_POSTALCODE'   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 26, 'Orders.LBL_LIST_BILLING_ADDRESS_COUNTRY'           , 'BILLING_ADDRESS_COUNTRY'      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 27, 'Orders.LBL_LIST_SHIPPING_ADDRESS_STREET'           , 'SHIPPING_ADDRESS_STREET'      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 28, 'Orders.LBL_LIST_SHIPPING_ADDRESS_CITY'             , 'SHIPPING_ADDRESS_CITY'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 29, 'Orders.LBL_LIST_SHIPPING_ADDRESS_STATE'            , 'SHIPPING_ADDRESS_STATE'       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 30, 'Orders.LBL_LIST_SHIPPING_ADDRESS_POSTALCODE'       , 'SHIPPING_ADDRESS_POSTALCODE'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 31, 'Orders.LBL_LIST_SHIPPING_ADDRESS_COUNTRY'          , 'SHIPPING_ADDRESS_COUNTRY'     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 32, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 33, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 34, 'Orders.LBL_LIST_DESCRIPTION'                       , 'DESCRIPTION'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 35, 'Orders.LBL_LIST_BILLING_ACCOUNT_NAME'              , 'BILLING_ACCOUNT_NAME'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 36, 'Orders.LBL_LIST_SHIPPING_ACCOUNT_NAME'             , 'SHIPPING_ACCOUNT_NAME'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 37, 'Orders.LBL_LIST_BILLING_CONTACT_NAME'              , 'BILLING_CONTACT_NAME'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 38, 'Orders.LBL_LIST_SHIPPING_CONTACT_NAME'             , 'SHIPPING_CONTACT_NAME'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 39, 'Orders.LBL_LIST_OPPORTUNITY_NAME'                  , 'OPPORTUNITY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 40, 'Orders.LBL_LIST_LEAD_SOURCE'                       , 'LEAD_SOURCE'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 41, 'Orders.LBL_LIST_NEXT_STEP'                         , 'NEXT_STEP'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 42, 'Orders.LBL_LIST_QUOTE_NAME'                        , 'QUOTE_NAME'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 43, 'Orders.LBL_LIST_QUOTE_NUM'                         , 'QUOTE_NUM'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 44, 'Orders.LBL_LIST_TAXRATE_NAME'                      , 'TAXRATE_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 45, 'Orders.LBL_LIST_TAXRATE_VALUE'                     , 'TAXRATE_VALUE'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 46, 'Orders.LBL_LIST_SHIPPER_NAME'                      , 'SHIPPER_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 47, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 48, 'Orders.LBL_LIST_CURRENCY_NAME'                     , 'CURRENCY_NAME'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 49, 'Orders.LBL_LIST_CURRENCY_SYMBOL'                   , 'CURRENCY_SYMBOL'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 50, '.LBL_LIST_ASSIGNED_TO_NAME'                        , 'ASSIGNED_TO_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 51, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 52, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 53, 'Orders.LBL_LIST_BILLING_FREQUENCY_C'               , 'BILLING_FREQUENCY_C'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Orders.Export'           , 54, 'Orders.LBL_LIST_ACCOUNT_NAME'                      , 'ACCOUNT_NAME'                 , null, null;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Invoices.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Invoices.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'Invoices.Export'          , 'Invoices', 'vwINVOICES_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         ,  1, 'Invoices.LBL_LIST_INVOICE_NUM'                     , 'INVOICE_NUM'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         ,  2, 'Invoices.LBL_LIST_NAME'                            , 'NAME'                         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         ,  3, 'Invoices.LBL_LIST_PAYMENT_TERMS'                   , 'PAYMENT_TERMS'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         ,  4, 'Invoices.LBL_LIST_INVOICE_STAGE'                   , 'INVOICE_STAGE'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         ,  5, 'Invoices.LBL_LIST_PURCHASE_ORDER_NUM'              , 'PURCHASE_ORDER_NUM'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         ,  6, 'Invoices.LBL_LIST_DUE_DATE'                        , 'DUE_DATE'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         ,  7, 'Invoices.LBL_LIST_SHOW_LINE_NUMS'                  , 'SHOW_LINE_NUMS'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         ,  8, 'Invoices.LBL_LIST_CALC_GRAND_TOTAL'                , 'CALC_GRAND_TOTAL'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         ,  9, 'Invoices.LBL_LIST_EXCHANGE_RATE'                   , 'EXCHANGE_RATE'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 10, 'Invoices.LBL_LIST_SUBTOTAL'                        , 'SUBTOTAL'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 11, 'Invoices.LBL_LIST_SUBTOTAL_USDOLLAR'               , 'SUBTOTAL_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 12, 'Invoices.LBL_LIST_DISCOUNT'                        , 'DISCOUNT'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 13, 'Invoices.LBL_LIST_DISCOUNT_USDOLLAR'               , 'DISCOUNT_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 14, 'Invoices.LBL_LIST_SHIPPING'                        , 'SHIPPING'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 15, 'Invoices.LBL_LIST_SHIPPING_USDOLLAR'               , 'SHIPPING_USDOLLAR'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 16, 'Invoices.LBL_LIST_TAX'                             , 'TAX'                          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 17, 'Invoices.LBL_LIST_TAX_USDOLLAR'                    , 'TAX_USDOLLAR'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 18, 'Invoices.LBL_LIST_TOTAL'                           , 'TOTAL'                        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 19, 'Invoices.LBL_LIST_TOTAL_USDOLLAR'                  , 'TOTAL_USDOLLAR'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 20, 'Invoices.LBL_LIST_AMOUNT_DUE'                      , 'AMOUNT_DUE'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 21, 'Invoices.LBL_LIST_AMOUNT_DUE_USDOLLAR'             , 'AMOUNT_DUE_USDOLLAR'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 22, 'Invoices.LBL_LIST_BILLING_ADDRESS_STREET'          , 'BILLING_ADDRESS_STREET'       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 23, 'Invoices.LBL_LIST_BILLING_ADDRESS_CITY'            , 'BILLING_ADDRESS_CITY'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 24, 'Invoices.LBL_LIST_BILLING_ADDRESS_STATE'           , 'BILLING_ADDRESS_STATE'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 25, 'Invoices.LBL_LIST_BILLING_ADDRESS_POSTALCODE'      , 'BILLING_ADDRESS_POSTALCODE'   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 26, 'Invoices.LBL_LIST_BILLING_ADDRESS_COUNTRY'         , 'BILLING_ADDRESS_COUNTRY'      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 27, 'Invoices.LBL_LIST_SHIPPING_ADDRESS_STREET'         , 'SHIPPING_ADDRESS_STREET'      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 28, 'Invoices.LBL_LIST_SHIPPING_ADDRESS_CITY'           , 'SHIPPING_ADDRESS_CITY'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 29, 'Invoices.LBL_LIST_SHIPPING_ADDRESS_STATE'          , 'SHIPPING_ADDRESS_STATE'       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 30, 'Invoices.LBL_LIST_SHIPPING_ADDRESS_POSTALCODE'     , 'SHIPPING_ADDRESS_POSTALCODE'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 31, 'Invoices.LBL_LIST_SHIPPING_ADDRESS_COUNTRY'        , 'SHIPPING_ADDRESS_COUNTRY'     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 32, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 33, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 34, 'Invoices.LBL_LIST_DESCRIPTION'                     , 'DESCRIPTION'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 35, 'Invoices.LBL_LIST_BILLING_ACCOUNT_NAME'            , 'BILLING_ACCOUNT_NAME'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 36, 'Invoices.LBL_LIST_SHIPPING_ACCOUNT_NAME'           , 'SHIPPING_ACCOUNT_NAME'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 37, 'Invoices.LBL_LIST_BILLING_CONTACT_NAME'            , 'BILLING_CONTACT_NAME'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 38, 'Invoices.LBL_LIST_SHIPPING_CONTACT_NAME'           , 'SHIPPING_CONTACT_NAME'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 39, 'Invoices.LBL_LIST_OPPORTUNITY_NAME'                , 'OPPORTUNITY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 40, 'Invoices.LBL_LIST_LEAD_SOURCE'                     , 'LEAD_SOURCE'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 41, 'Invoices.LBL_LIST_NEXT_STEP'                       , 'NEXT_STEP'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 42, 'Invoices.LBL_LIST_QUOTE_NAME'                      , 'QUOTE_NAME'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 43, 'Invoices.LBL_LIST_QUOTE_NUM'                       , 'QUOTE_NUM'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 44, 'Invoices.LBL_LIST_ORDER_NAME'                      , 'ORDER_NAME'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 45, 'Invoices.LBL_LIST_ORDER_NUM'                       , 'ORDER_NUM'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 46, 'Invoices.LBL_LIST_TAXRATE_NAME'                    , 'TAXRATE_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 47, 'Invoices.LBL_LIST_TAXRATE_VALUE'                   , 'TAXRATE_VALUE'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 48, 'Invoices.LBL_LIST_SHIPPER_NAME'                    , 'SHIPPER_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 49, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 50, 'Invoices.LBL_LIST_CURRENCY_NAME'                   , 'CURRENCY_NAME'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 51, 'Invoices.LBL_LIST_CURRENCY_SYMBOL'                 , 'CURRENCY_SYMBOL'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 52, '.LBL_LIST_ASSIGNED_TO_NAME'                        , 'ASSIGNED_TO_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 53, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 54, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Invoices.Export'         , 55, 'Invoices.LBL_LIST_ACCOUNT_NAME'                    , 'ACCOUNT_NAME'                 , null, null;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Payments.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Payments.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'Payments.Export'         , 'Payments', 'vwPAYMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         ,  1, 'Payments.LBL_LIST_NAME'                            , 'NAME'                         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         ,  2, 'Payments.LBL_LIST_PAYMENT_NUM'                     , 'PAYMENT_NUM'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         ,  3, 'Payments.LBL_LIST_PAYMENT_TYPE'                    , 'PAYMENT_TYPE'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         ,  4, 'Payments.LBL_LIST_PAYMENT_DATE'                    , 'PAYMENT_DATE'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         ,  5, 'Payments.LBL_LIST_CUSTOMER_REFERENCE'              , 'CUSTOMER_REFERENCE'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         ,  6, 'Payments.LBL_LIST_EXCHANGE_RATE'                   , 'EXCHANGE_RATE'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         ,  7, 'Payments.LBL_LIST_AMOUNT'                          , 'AMOUNT'                       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         ,  8, 'Payments.LBL_LIST_AMOUNT_USDOLLAR'                 , 'AMOUNT_USDOLLAR'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         ,  9, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 10, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 11, 'Payments.LBL_LIST_DESCRIPTION'                     , 'DESCRIPTION'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 12, 'Payments.LBL_LIST_ACCOUNT_NAME'                    , 'ACCOUNT_NAME'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 13, 'Payments.LBL_LIST_CREDIT_CARD_NAME'                , 'CREDIT_CARD_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 14, 'Payments.LBL_LIST_CREDIT_CARD_NUMBER'              , 'CREDIT_CARD_NUMBER'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 15, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 16, 'Payments.LBL_LIST_TOTAL_ALLOCATED_USDOLLAR'        , 'TOTAL_ALLOCATED_USDOLLAR'     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 17, '.LBL_LIST_ASSIGNED_TO_NAME'                        , 'ASSIGNED_TO_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 18, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 19, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 20, 'Payments.LBL_LIST_BANK_FEE'                        , 'BANK_FEE'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Payments.Export'         , 21, 'Payments.LBL_LIST_BANK_FEE_USDOLLAR'               , 'BANK_FEE_USDOLLAR'            , null, null;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Threads.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Threads.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'Threads.Export'          , 'Threads', 'vwTHREADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          ,  1, 'Threads.LBL_LIST_TITLE'                            , 'TITLE'                        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          ,  2, 'Threads.LBL_LIST_IS_STICKY'                        , 'IS_STICKY'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          ,  3, 'Threads.LBL_LIST_POSTCOUNT'                        , 'POSTCOUNT'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          ,  4, 'Threads.LBL_LIST_VIEW_COUNT'                       , 'VIEW_COUNT'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          ,  5, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          ,  6, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          ,  7, 'Threads.LBL_LIST_DESCRIPTION_HTML'                 , 'DESCRIPTION_HTML'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          ,  8, 'Threads.LBL_LIST_FORUM_TITLE'                      , 'FORUM_TITLE'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          ,  9, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          , 10, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          , 11, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          , 12, 'Threads.LBL_LIST_LAST_POST_TITLE'                  , 'LAST_POST_TITLE'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          , 13, 'Threads.LBL_LIST_LAST_POST_CREATED_BY'             , 'LAST_POST_CREATED_BY'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          , 14, 'Threads.LBL_LIST_LAST_POST_DATE_MODIFIED'          , 'LAST_POST_DATE_MODIFIED'      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Threads.Export'          , 15, 'Threads.LBL_LIST_LAST_POST_CREATED_BY_NAME'        , 'LAST_POST_CREATED_BY_NAME'    , null, null;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Posts.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Posts.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'Posts.Export'            , 'Posts', 'vwTHREADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.Export'            ,  1, 'Posts.LBL_LIST_TITLE'                              , 'TITLE'                        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.Export'            ,  2, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.Export'            ,  3, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.Export'            ,  4, 'Posts.LBL_LIST_THREAD_TITLE'                       , 'THREAD_TITLE'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.Export'            ,  5, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.Export'            ,  6, 'Posts.LBL_LIST_DESCRIPTION_HTML'                   , 'DESCRIPTION_HTML'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.Export'            ,  7, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'Posts.Export'            ,  8, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'KBDocuments.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS KBDocuments.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'KBDocuments.Export'      , 'KBDocuments', 'vwKBDOCUMENTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      ,  1, 'KBDocuments.LBL_LIST_NAME'                         , 'NAME'                         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      ,  2, 'KBDocuments.LBL_LIST_ACTIVE_DATE'                  , 'ACTIVE_DATE'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      ,  3, 'KBDocuments.LBL_LIST_EXP_DATE'                     , 'EXP_DATE'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      ,  4, 'KBDocuments.LBL_LIST_STATUS'                       , 'STATUS'                       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      ,  5, 'KBDocuments.LBL_LIST_REVISION'                     , 'REVISION'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      ,  6, '.LBL_LIST_DATE_ENTERED'                            , 'DATE_ENTERED'                 , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      ,  7, '.LBL_LIST_DATE_MODIFIED'                           , 'DATE_MODIFIED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      ,  8, 'KBDocuments.LBL_LIST_IS_EXTERNAL_ARTICLE'          , 'IS_EXTERNAL_ARTICLE'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      ,  9, 'KBDocuments.LBL_LIST_HAS_ATTACHMENTS'              , 'HAS_ATTACHMENTS'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      , 10, 'KBDocuments.LBL_LIST_KBTAG_NAME'                   , 'KBTAG_NAME'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      , 11, '.LBL_LIST_TEAM_NAME'                               , 'TEAM_NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      , 12, 'KBDocuments.LBL_LIST_KBDOC_APPROVER_NAME'          , 'KBDOC_APPROVER_NAME'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      , 13, 'KBDocuments.LBL_LIST_DESCRIPTION'                  , 'DESCRIPTION'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      , 14, 'KBDocuments.LBL_LIST_KBTAG_SET_LIST'               , 'KBTAG_SET_LIST'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      , 15, '.LBL_LIST_ASSIGNED_TO_NAME'                        , 'ASSIGNED_TO_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      , 16, '.LBL_LIST_CREATED_BY_NAME'                         , 'CREATED_BY_NAME'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      , 17, '.LBL_LIST_MODIFIED_BY_NAME'                        , 'MODIFIED_BY_NAME'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'KBDocuments.Export'      , 18, 'KBDocuments.LBL_LIST_VIEW_FREQUENCY'               , 'VIEW_FREQUENCY'               , null, null;
end -- if;
GO

-- 01/11/2019 Paul.  DESCRIPTION was renamed to SURVEY_QUESTION_NAME. 
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyResults.Export';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyResults.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyResults.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyResults.Export', 'SurveyResults', 'vwSURVEY_RESULTS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.Export'    ,  2, 'SurveyResults.LBL_LIST_SURVEY_NAME'               , 'SURVEY_NAME'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.Export'    ,  3, 'SurveyResults.LBL_LIST_SURVEY_QUESTION_NAME'      , 'SURVEY_QUESTION_NAME'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.Export'    ,  4, 'SurveyResults.LBL_LIST_IS_COMPLETE'               , 'IS_COMPLETE'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.Export'    ,  5, '.LBL_LIST_DATE_ENTERED'                           , 'DATE_ENTERED'                  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.Export'    ,  6, 'SurveyResults.LBL_LIST_ANSWER_TEXT'               , 'ANSWER_TEXT'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.Export'    ,  7, 'SurveyResults.LBL_LIST_COLUMN_TEXT'               , 'COLUMN_TEXT'                   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.Export'    ,  8, 'SurveyResults.LBL_LIST_MENU_TEXT'                 , 'MENU_TEXT'                     , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.Export'    ,  9, 'SurveyResults.LBL_LIST_OTHER_TEXT'                , 'OTHER_TEXT'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyResults.Export'    , 10, 'SurveyResults.LBL_LIST_WEIGHT'                    , 'WEIGHT'                        , null, null;
end else begin
	-- 01/11/2019 Paul.  DESCRIPTION was renamed to SURVEY_QUESTION_NAME. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyResults.Export' and DATA_FIELD = 'DESCRIPTION' and DELETED = 0) begin -- then
		print 'GRIDVIEWS_COLUMNS SurveyResults.Export: DESCRIPTION was renamed to SURVEY_QUESTION_NAME';
		update GRIDVIEWS_COLUMNS
		   set DATA_FIELD        = 'SURVEY_QUESTION_NAME'
		     , HEADER_TEXT       = 'LBL_LIST_SURVEY_QUESTION_NAME'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where GRID_NAME         = 'SurveyResults.Export'
		   and DATA_FIELD        = 'DESCRIPTION'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 01/02/2016 Paul.  Provide a way to import survey questions. 
-- 05/24/2020 Paul.  Correct header text labels. 
-- select '	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     ''SurveyQuestions.Export''  , 10, ''SurveyResults.LBL_LIST_' + replace(ColumnName, '@', '') + '''' + Space(24 - len(replace(ColumnName, '@', ''))) + ', ''' + replace(ColumnName, '@', '') + '''' + Space(24 - len(replace(ColumnName, '@', ''))) + ', null, null;' from vwSqlColumns where ObjectName = 'spSURVEY_QUESTIONS_Update' and ColumnName not in ('@ID', '@MODIFIED_USER_ID', '@ASSIGNED_USER_ID', '@TEAM_ID', '@TEAM_SET_LIST')
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.Export';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.Export' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SurveyQuestions.Export';
	exec dbo.spGRIDVIEWS_InsertOnly           'SurveyQuestions.Export'  , 'SurveyQuestions', 'vwSURVEY_QUESTIONS';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  ,  2, 'SurveyQuestions.LBL_LIST_NAME'                    , 'NAME'                    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  ,  3, 'SurveyQuestions.LBL_LIST_DESCRIPTION'             , 'DESCRIPTION'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  ,  4, 'SurveyQuestions.LBL_LIST_QUESTION_TYPE'           , 'QUESTION_TYPE'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  ,  5, 'SurveyQuestions.LBL_LIST_DISPLAY_FORMAT'          , 'DISPLAY_FORMAT'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  ,  6, 'SurveyQuestions.LBL_LIST_ANSWER_CHOICES'          , 'ANSWER_CHOICES'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  ,  7, 'SurveyQuestions.LBL_LIST_COLUMN_CHOICES'          , 'COLUMN_CHOICES'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  ,  8, 'SurveyQuestions.LBL_LIST_FORCED_RANKING'          , 'FORCED_RANKING'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  ,  9, 'SurveyQuestions.LBL_LIST_INVALID_DATE_MESSAGE'    , 'INVALID_DATE_MESSAGE'    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 10, 'SurveyQuestions.LBL_LIST_INVALID_NUMBER_MESSAGE'  , 'INVALID_NUMBER_MESSAGE'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 11, 'SurveyQuestions.LBL_LIST_NA_ENABLED'              , 'NA_ENABLED'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 12, 'SurveyQuestions.LBL_LIST_NA_LABEL'                , 'NA_LABEL'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 13, 'SurveyQuestions.LBL_LIST_OTHER_ENABLED'           , 'OTHER_ENABLED'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 14, 'SurveyQuestions.LBL_LIST_OTHER_LABEL'             , 'OTHER_LABEL'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 15, 'SurveyQuestions.LBL_LIST_OTHER_HEIGHT'            , 'OTHER_HEIGHT'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 16, 'SurveyQuestions.LBL_LIST_OTHER_WIDTH'             , 'OTHER_WIDTH'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 17, 'SurveyQuestions.LBL_LIST_OTHER_AS_CHOICE'         , 'OTHER_AS_CHOICE'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 18, 'SurveyQuestions.LBL_LIST_OTHER_ONE_PER_ROW'       , 'OTHER_ONE_PER_ROW'       , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 19, 'SurveyQuestions.LBL_LIST_OTHER_REQUIRED_MESSAGE'  , 'OTHER_REQUIRED_MESSAGE'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 20, 'SurveyQuestions.LBL_LIST_OTHER_VALIDATION_TYPE'   , 'OTHER_VALIDATION_TYPE'   , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 21, 'SurveyQuestions.LBL_LIST_OTHER_VALIDATION_MIN'    , 'OTHER_VALIDATION_MIN'    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 22, 'SurveyQuestions.LBL_LIST_OTHER_VALIDATION_MAX'    , 'OTHER_VALIDATION_MAX'    , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 23, 'SurveyQuestions.LBL_LIST_OTHER_VALIDATION_MESSAGE', 'OTHER_VALIDATION_MESSAGE', null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 24, 'SurveyQuestions.LBL_LIST_REQUIRED'                , 'REQUIRED'                , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 25, 'SurveyQuestions.LBL_LIST_REQUIRED_TYPE'           , 'REQUIRED_TYPE'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 26, 'SurveyQuestions.LBL_LIST_REQUIRED_RESPONSES_MIN'  , 'REQUIRED_RESPONSES_MIN'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 27, 'SurveyQuestions.LBL_LIST_REQUIRED_RESPONSES_MAX'  , 'REQUIRED_RESPONSES_MAX'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 28, 'SurveyQuestions.LBL_LIST_REQUIRED_MESSAGE'        , 'REQUIRED_MESSAGE'        , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 29, 'SurveyQuestions.LBL_LIST_VALIDATION_TYPE'         , 'VALIDATION_TYPE'         , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 30, 'SurveyQuestions.LBL_LIST_VALIDATION_MIN'          , 'VALIDATION_MIN'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 31, 'SurveyQuestions.LBL_LIST_VALIDATION_MAX'          , 'VALIDATION_MAX'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 32, 'SurveyQuestions.LBL_LIST_VALIDATION_MESSAGE'      , 'VALIDATION_MESSAGE'      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 33, 'SurveyQuestions.LBL_LIST_VALIDATION_SUM_ENABLED'  , 'VALIDATION_SUM_ENABLED'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 34, 'SurveyQuestions.LBL_LIST_VALIDATION_NUMERIC_SUM'  , 'VALIDATION_NUMERIC_SUM'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 35, 'SurveyQuestions.LBL_LIST_VALIDATION_SUM_MESSAGE'  , 'VALIDATION_SUM_MESSAGE'  , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 36, 'SurveyQuestions.LBL_LIST_RANDOMIZE_TYPE'          , 'RANDOMIZE_TYPE'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 37, 'SurveyQuestions.LBL_LIST_RANDOMIZE_NOT_LAST'      , 'RANDOMIZE_NOT_LAST'      , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 38, 'SurveyQuestions.LBL_LIST_SIZE_WIDTH'              , 'SIZE_WIDTH'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 39, 'SurveyQuestions.LBL_LIST_SIZE_HEIGHT'             , 'SIZE_HEIGHT'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 40, 'SurveyQuestions.LBL_LIST_BOX_WIDTH'               , 'BOX_WIDTH'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 41, 'SurveyQuestions.LBL_LIST_BOX_HEIGHT'              , 'BOX_HEIGHT'              , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 41, 'SurveyQuestions.LBL_LIST_COLUMN_WIDTH'            , 'COLUMN_WIDTH'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 42, 'SurveyQuestions.LBL_LIST_PLACEMENT'               , 'PLACEMENT'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 43, 'SurveyQuestions.LBL_LIST_SPACING_LEFT'            , 'SPACING_LEFT'            , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 44, 'SurveyQuestions.LBL_LIST_SPACING_TOP'             , 'SPACING_TOP'             , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 45, 'SurveyQuestions.LBL_LIST_SPACING_RIGHT'           , 'SPACING_RIGHT'           , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 46, 'SurveyQuestions.LBL_LIST_SPACING_BOTTOM'          , 'SPACING_BOTTOM'          , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 47, 'SurveyQuestions.LBL_LIST_IMAGE_URL'               , 'IMAGE_URL'               , null, null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SurveyQuestions.Export'  , 48, 'SurveyQuestions.LBL_LIST_CATEGORIES'              , 'CATEGORIES'              , null, null;
end else begin
	-- 05/24/2020 Paul.  Correct header text labels. 
	if exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SurveyQuestions.Export' and HEADER_TEXT like 'SurveyResults.%' and DELETED = 0) begin -- then
		update GRIDVIEWS_COLUMNS
		   set HEADER_TEXT       = replace(HEADER_TEXT, 'SurveyResults', 'SurveyQuestions')
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where GRID_NAME         = 'SurveyQuestions.Export'
		   and HEADER_TEXT       like 'SurveyResults.%'
		   and DELETED           =  0;
	end -- if;
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

call dbo.spGRIDVIEWS_COLUMNS_ExportPro()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_ExportPro')
/

-- #endif IBM_DB2 */


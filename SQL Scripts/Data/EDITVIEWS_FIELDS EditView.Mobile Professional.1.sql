

print 'EDITVIEWS_FIELDS EditView.Mobile Professional';
--delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.EditView.Mobile'
--GO

set nocount on;
GO

-- 11/17/2007 Paul.  Add spEDITVIEWS_InsertOnly to simplify creation of Mobile views.
-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 09/08/2008 Paul.  Must use a comment block to allow Oracle migration to work properly. 
-- 09/14/2008 Paul.  DB2 does not work well with optional parameters. 
-- 08/24/2009 Paul.  Change TEAM_NAME to TEAM_SET_NAME. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 

/*
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Roles.EditView.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Roles.EditView.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Roles.EditView.Mobile'         , 'Roles'         , 'vwROLES_Edit'         , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Roles.EditView.Mobile'          ,  0, 'Roles.LBL_NAME'                         , 'NAME'                       , 1, 1, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView.Mobile'          ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView.Mobile'          ,  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView.Mobile'          ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Roles.EditView.Mobile'          ,  4, 'Roles.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 3,   8, 90, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView.Mobile'          ,  5, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView.Mobile'          ,  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView.Mobile'          ,  7, null;
end -- if;
--GO
*/

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.EditView.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Contracts.EditView.Mobile', 'Contracts', 'vwCONTRACTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Mobile'      ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Mobile'      ,  1, 'Contracts.LBL_STATUS'                   , 'STATUS'                     , 1, 2, 'contract_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Mobile'      ,  2, 'Contracts.LBL_REFERENCE_CODE'           , 'REFERENCE_CODE'             , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Mobile'      ,  3, 'Contracts.LBL_START_DATE'               , 'START_DATE'                 , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Mobile'      ,  4, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Mobile'      ,  5, 'Contracts.LBL_END_DATE'                 , 'END_DATE'                   , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Mobile'      ,  6, 'Contracts.LBL_OPPORTUNITY_NAME'         , 'OPPORTUNITY_ID'             , 0, 1, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Mobile'      ,  7, 'Contracts.LBL_CURRENCY'                 , 'CURRENCY_ID'                , 0, 2, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Mobile'      ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Mobile'      ,  9, 'Contracts.LBL_CONTRACT_VALUE'           , 'TOTAL_CONTRACT_VALUE'       , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Mobile'      , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Mobile'      , 11, 'Contracts.LBL_COMPANY_SIGNED_DATE'      , 'COMPANY_SIGNED_DATE'        , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Mobile'      , 12, 'Contracts.LBL_EXPIRATION_NOTICE'        , 'EXPIRATION_NOTICE'          , 0, 1, 'DateTimeEdit'       , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Mobile'      , 13, 'Contracts.LBL_CUSTOMER_SIGNED_DATE'     , 'CUSTOMER_SIGNED_DATE'       , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Mobile'      , 14, 'Contracts.LBL_TYPE'                     , 'TYPE'                       , 0, 2, 'ContractTypes'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Contracts.EditView.Mobile'      , 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contracts.EditView.Mobile'      , 16, 'Contracts.LBL_DESCRIPTION'              , 'DESCRIPTION'                , 0, 3,   8, 80, 3;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Contracts.EditView.Mobile'      ,  4, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Contracts.EditView.Mobile'      ,  6, 'Contracts.LBL_OPPORTUNITY_NAME'         , 'OPPORTUNITY_ID'             , 0, 1, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Contracts.EditView.Mobile'      , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
end -- if;
GO

-- 05/01/2013 Paul.  Convert the ChangeButton to a ModulePopup. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.EditView.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Products.EditView.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Products.EditView.Mobile', 'Products', 'vwPRODUCTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.EditView.Mobile'       ,  0, 'Products.LBL_NAME'                      , 'PRODUCT_TEMPLATE_ID'        , 1, 1, 'NAME'               , 'ProductCatalog', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.EditView.Mobile'       ,  1, 'Products.LBL_STATUS'                    , 'STATUS'                     , 1, 2, 'product_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.EditView.Mobile'       ,  2, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.EditView.Mobile'       ,  3, 'Contracts.LBL_CONTACT_NAME'             , 'CONTACT_ID'                 , 1, 2, 'CONTACT_NAME'       , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.EditView.Mobile'       ,  4, 'Products.LBL_QUANTITY'                  , 'QUANTITY'                   , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.EditView.Mobile'       ,  5, 'Products.LBL_DATE_PURCHASED'            , 'DATE_PURCHASED'             , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.EditView.Mobile'       ,  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.EditView.Mobile'       ,  7, 'Products.LBL_DATE_SUPPORT_STARTS'       , 'DATE_SUPPORT_STARTS'        , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.EditView.Mobile'       ,  8, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.EditView.Mobile'       ,  9, 'Products.LBL_DATE_SUPPORT_EXPIRES'      , 'DATE_SUPPORT_EXPIRES'       , 0, 2, 'DatePicker'         , null, null, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Products.EditView.Mobile'       ,  0, 'Products.LBL_NAME'                      , 'PRODUCT_TEMPLATE_ID'        , 1, 1, 'NAME'               , 'ProductCatalog', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Products.EditView.Mobile'       ,  2, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Products.EditView.Mobile'       ,  3, 'Contracts.LBL_CONTACT_NAME'             , 'CONTACT_ID'                 , 1, 2, 'CONTACT_NAME'       , 'Contacts', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.CostView.Mobile' and DELETED = 0) begin -- then
	exec dbo.spEDITVIEWS_InsertOnly            'Products.CostView.Mobile', 'Products', 'vwPRODUCTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.CostView.Mobile',  0, 'Products.LBL_CURRENCY'                  , 'CURRENCY_ID'                , 1, 1, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.CostView.Mobile',  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.CostView.Mobile',  2, 'Products.LBL_COST_PRICE'                , 'COST_PRICE'                 , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.CostView.Mobile',  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.CostView.Mobile',  4, 'Products.LBL_LIST_PRICE'                , 'LIST_PRICE'                 , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.CostView.Mobile',  5, 'Products.LBL_BOOK_VALUE'                , 'BOOK_VALUE'                 , 1, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.CostView.Mobile',  6, 'Products.LBL_DISCOUNT_PRICE'            , 'DISCOUNT_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.CostView.Mobile',  7, 'Products.LBL_BOOK_VALUE_DATE'           , 'BOOK_VALUE_DATE'            , 0, 2, 'DatePicker'         , null, null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.MftView.Mobile' and DELETED = 0) begin -- then
	exec dbo.spEDITVIEWS_InsertOnly            'Products.MftView.Mobile', 'Products', 'vwPRODUCTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView.Mobile' ,  0, 'Products.LBL_WEBSITE'                   , 'WEBSITE'                    , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.MftView.Mobile' ,  1, 'Products.LBL_TAX_CLASS'                 , 'TAX_CLASS'                  , 0, 2, 'tax_class_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.MftView.Mobile' ,  2, 'Products.LBL_MANUFACTURER'              , 'MANUFACTURER_ID'            , 0, 1, 'Manufacturers'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView.Mobile' ,  3, 'Products.LBL_WEIGHT'                    , 'WEIGHT'                     , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView.Mobile' ,  4, 'Products.LBL_MFT_PART_NUM'              , 'MFT_PART_NUM'               , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.MftView.Mobile' ,  5, 'Products.LBL_CATEGORY'                  , 'CATEGORY_ID'                , 1, 2, 'CATEGORY_NAME'     , 'ProductCategories', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView.Mobile' ,  6, 'Products.LBL_VENDOR_PART_NUM'           , 'VENDOR_PART_NUM'            , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.MftView.Mobile' ,  7, 'Products.LBL_TYPE'                      , 'TYPE_ID'                    , 0, 2, 'ProductTypes'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView.Mobile' ,  8, 'Products.LBL_SERIAL_NUMBER'             , 'SERIAL_NUMBER'              , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.MftView.Mobile' ,  9, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView.Mobile' , 10, 'Products.LBL_ASSET_NUMBER'              , 'ASSET_NUMBER'               , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.MftView.Mobile' , 11, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Products.MftView.Mobile' , 12, 'Products.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 1,   8, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.MftView.Mobile' , 13, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.MftView.Mobile' , 14, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView.Mobile' , 15, 'Products.LBL_SUPPORT_NAME'              , 'SUPPORT_NAME'               , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView.Mobile' , 16, 'Products.LBL_SUPPORT_CONTACT'           , 'SUPPORT_CONTACT'            , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView.Mobile' , 17, 'Products.LBL_SUPPORT_DESCRIPTION'       , 'SUPPORT_DESCRIPTION'        , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.MftView.Mobile' , 18, 'Products.LBL_SUPPORT_TERM'              , 'SUPPORT_TERM'               , 0, 2, 'support_term_dom'   , null, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Products.MftView.Mobile' ,  5, 'Products.LBL_CATEGORY'                  , 'CATEGORY_ID'                , 1, 2, 'CATEGORY_NAME'     , 'ProductCategories', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTemplates.EditView.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'ProductTemplates.EditView.Mobile', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' ,  0, 'ProductTemplates.LBL_NAME'                , 'NAME'                   , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView.Mobile' ,  1, 'ProductTemplates.LBL_STATUS'              , 'STATUS'                 , 1, 2, 'product_template_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ProductTemplates.EditView.Mobile' ,  2, 'ProductTemplates.LBL_CATEGORY'            , 'CATEGORY_ID'            , 1, 1, 'CATEGORY_NAME'      , 'ProductCategories', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView.Mobile' ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' ,  4, 'ProductTemplates.LBL_WEBSITE'             , 'WEBSITE'                , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProductTemplates.EditView.Mobile' ,  5, 'ProductTemplates.LBL_DATE_AVAILABLE'      , 'DATE_AVAILABLE'         , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView.Mobile' ,  6, 'ProductTemplates.LBL_TAX_CLASS'           , 'TAX_CLASS'              , 0, 1, 'tax_class_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' ,  7, 'ProductTemplates.LBL_QUANTITY'            , 'QUANTITY'               , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView.Mobile' ,  8, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView.Mobile' ,  9, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView.Mobile' , 10, 'ProductTemplates.LBL_MANUFACTURER'        , 'MANUFACTURER_ID'        , 0, 1, 'Manufacturers'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' , 11, 'ProductTemplates.LBL_WEIGHT'              , 'WEIGHT'                 , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' , 12, 'ProductTemplates.LBL_MFT_PART_NUM'        , 'MFT_PART_NUM'           , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView.Mobile' , 13, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' , 14, 'ProductTemplates.LBL_VENDOR_PART_NUM'     , 'VENDOR_PART_NUM'        , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView.Mobile' , 15, 'ProductTemplates.LBL_TYPE'                , 'TYPE_ID'                , 0, 2, 'ProductTypes'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView.Mobile' , 16, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView.Mobile' , 17, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView.Mobile' , 18, 'ProductTemplates.LBL_CURRENCY'            , 'CURRENCY_ID'            , 1, 1, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' , 19, 'ProductTemplates.LBL_SUPPORT_NAME'        , 'SUPPORT_NAME'           , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' , 20, 'ProductTemplates.LBL_COST_PRICE'          , 'COST_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' , 21, 'ProductTemplates.LBL_SUPPORT_CONTACT'     , 'SUPPORT_CONTACT'        , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' , 22, 'ProductTemplates.LBL_LIST_PRICE'          , 'LIST_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' , 23, 'ProductTemplates.LBL_SUPPORT_DESCRIPTION' , 'SUPPORT_DESCRIPTION'    , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView.Mobile' , 24, 'ProductTemplates.LBL_DISCOUNT_PRICE'      , 'DISCOUNT_PRICE'         , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView.Mobile' , 25, 'ProductTemplates.LBL_SUPPORT_TERM'        , 'SUPPORT_TERM'           , 0, 2, 'support_term_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView.Mobile' , 26, 'ProductTemplates.LBL_PRICING_FORMULA'     , 'PRICING_FORMULA'        , 1, 1, 'pricing_formula_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView.Mobile' , 27, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView.Mobile' , 28, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView.Mobile' , 29, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'ProductTemplates.EditView.Mobile' , 30, 'ProductTemplates.LBL_DESCRIPTION'         , 'DESCRIPTION'            , 0, 3,   8, 80, 3;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'ProductTemplates.EditView.Mobile' ,  2, 'ProductTemplates.LBL_CATEGORY'            , 'CATEGORY_ID'            , 1, 1, 'CATEGORY_NAME'      , 'ProductCategories', null;
end -- if;
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
-- 05/01/2013 Paul.  Convert Change to ModulePopup. 
-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- 04/13/2016 Paul.  Add ZipCode lookup. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditView.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditView.Mobile', 'Quotes', 'vwQUOTES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Mobile'         ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Mobile'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditView.Mobile'         ,  2, 'Quotes.LBL_QUOTE_NUM'                   , 'QUOTE_NUM'                  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.Mobile'         ,  3, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 1, 2, 'quote_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Mobile'         ,  4, 'Quotes.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Mobile'         ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'            , 'DATE_QUOTE_EXPECTED_CLOSED' , 1, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.Mobile'         ,  6, 'Quotes.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Mobile'         ,  7, 'Quotes.LBL_ORIGINAL_PO_DATE'            , 'ORIGINAL_PO_DATE'           , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Mobile'         ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView.Mobile'         ,  9, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Mobile'         , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView.Mobile'         , 11, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Quotes.EditView.Mobile'         , 12;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Mobile'         , 13, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Mobile'         , 14, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Mobile'         , 15, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Mobile'         , 16, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Mobile'         , 17, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditView.Mobile'         , 18, 'Quotes.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditView.Mobile'         , 19, 'Quotes.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Mobile'         , 20, 'Quotes.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Mobile'         , 21, 'Quotes.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Mobile'         , 22, 'Quotes.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Mobile'         , 23, 'Quotes.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Quotes.EditView.Mobile'         , 24, 'Quotes.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Quotes.EditView.Mobile'         , 25, 'Quotes.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Mobile'         , 26, 'Quotes.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Mobile'         , 27, 'Quotes.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 05/01/2013 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Mobile', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Mobile', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditView.Mobile', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditView.Mobile', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 05/01/2013 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Mobile', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Mobile', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditView.Mobile'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditView.Mobile'         , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress.Mobile' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_MergeView      'Quotes.EditView.Mobile', 'Quotes.EditAddress.Mobile', 'Quotes.LBL_BILLING_TITLE', 'Quotes.LBL_SHIPPING_TITLE';
	end -- if;
	-- 05/01/2013 Paul.  Convert Change to ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditView.Mobile'      ,  0, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditView.Mobile'      ,  2, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditView.Mobile'      ,  3, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditView.Mobile'      ,  4, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Mobile' and DATA_FIELD = 'BILLING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Mobile', 'BILLING_ACCOUNT_ID' , '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Mobile' and DATA_FIELD = 'SHIPPING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Mobile', 'SHIPPING_ACCOUNT_ID', '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Mobile' and DATA_FIELD = 'BILLING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Quotes.EditView.Mobile', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Mobile' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Quotes.EditView.Mobile', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Mobile' and DATA_FIELD = 'BILLING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Mobile', 'BILLING_CONTACT_ID' , '1,1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Mobile' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Mobile', 'SHIPPING_CONTACT_ID', '1,1';
	end -- if;
	-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Mobile' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Quotes.EditView.Mobile'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Quotes.EditView.Mobile', 'BILLING_ADDRESS_POSTALCODE';
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Quotes.EditView.Mobile', 'SHIPPING_ADDRESS_POSTALCODE';
end -- if;
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
/*
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditAddress.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditAddress.Mobile', 'Quotes', 'vwQUOTES_Edit', '15%', '30%', null;
	-- 08/29/2009 Paul.  Don't convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Quotes.EditAddress.Mobile'      ,  0, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'return BillingAccountPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditAddress.Mobile'      ,  1, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Quotes.EditAddress.Mobile'      ,  2, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'return ShippingAccountPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Quotes.EditAddress.Mobile'      ,  3, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'return BillingContactPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Quotes.EditAddress.Mobile'      ,  4, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'return ShippingContactPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditAddress.Mobile'      ,  5, 'Quotes.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditAddress.Mobile'      ,  6, 'Quotes.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Mobile'      ,  7, 'Quotes.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Mobile'      ,  8, 'Quotes.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Mobile'      ,  9, 'Quotes.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Mobile'      , 10, 'Quotes.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Mobile'      , 11, 'Quotes.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Mobile'      , 12, 'Quotes.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Mobile'      , 13, 'Quotes.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress.Mobile'      , 14, 'Quotes.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
end -- if;
*/
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditDescription.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditDescription.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditDescription.Mobile', 'Quotes', 'vwQUOTES_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditDescription.Mobile'  ,  0, 'Quotes.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
end -- if;
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
-- 05/01/2013 Paul.  Convert Change to ModulePopup. 
-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- 04/13/2016 Paul.  Add ZipCode lookup. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditView.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditView.Mobile', 'Orders', 'vwORDERS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Mobile'         ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Mobile'         ,  1, 'Orders.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Orders.EditView.Mobile'         ,  2, 'Orders.LBL_ORDER_NUM'                   , 'ORDER_NUM'                  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView.Mobile'         ,  3, 'Orders.LBL_ORDER_STAGE'                 , 'ORDER_STAGE'                , 1, 2, 'ORDER_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Mobile'         ,  4, 'Orders.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.Mobile'         ,  5, 'Orders.LBL_DATE_ORDER_DUE'              , 'DATE_ORDER_DUE'             , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView.Mobile'         ,  6, 'Orders.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.Mobile'         ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'          , 'DATE_ORDER_SHIPPED'         , 1, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Mobile'         ,  8, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Mobile'         ,  9, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Orders.EditView.Mobile'         , 10;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Mobile'         , 11, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.Mobile'         , 12, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Mobile'         , 13, 'Orders.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Mobile'         , 14, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Mobile'         , 15, 'Orders.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditView.Mobile'         , 16, 'Orders.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditView.Mobile'         , 17, 'Orders.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Mobile'         , 18, 'Orders.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Mobile'         , 19, 'Orders.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Mobile'         , 20, 'Orders.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Mobile'         , 21, 'Orders.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Orders.EditView.Mobile'         , 22, 'Orders.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Orders.EditView.Mobile'         , 23, 'Orders.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Mobile'         , 24, 'Orders.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Mobile'         , 25, 'Orders.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 05/01/2013 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Mobile', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Mobile', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Orders.EditView.Mobile', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Orders.EditView.Mobile', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 05/01/2013 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Mobile', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Mobile', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditView.Mobile'         ,  1, 'Orders.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditView.Mobile'         ,  8, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditAddress.Mobile' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_MergeView      'Orders.EditView.Mobile', 'Orders.EditAddress.Mobile', 'Orders.LBL_BILLING_TITLE', 'Orders.LBL_SHIPPING_TITLE';
	end -- if;
	-- 05/01/2013 Paul.  Convert Change to ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditView.Mobile'      ,  0, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditView.Mobile'      ,  2, 'Orders.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditView.Mobile'      ,  3, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditView.Mobile'      ,  4, 'Orders.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Mobile' and DATA_FIELD = 'BILLING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Mobile', 'BILLING_ACCOUNT_ID' , '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Mobile' and DATA_FIELD = 'SHIPPING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Mobile', 'SHIPPING_ACCOUNT_ID', '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Mobile' and DATA_FIELD = 'BILLING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Orders.EditView.Mobile', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Mobile' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Orders.EditView.Mobile', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Mobile' and DATA_FIELD = 'BILLING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Mobile', 'BILLING_CONTACT_ID' , '1,1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Mobile' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Mobile', 'SHIPPING_CONTACT_ID', '1,1';
	end -- if;
	-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Mobile' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Orders.EditView.Mobile'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Orders.EditView.Mobile', 'BILLING_ADDRESS_POSTALCODE';
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Orders.EditView.Mobile', 'SHIPPING_ADDRESS_POSTALCODE';
end -- if;
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
/*
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditAddress.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditAddress.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditAddress.Mobile', 'Orders', 'vwORDERS_Edit', '15%', '30%', null;
	-- 08/29/2009 Paul.  Don't convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Orders.EditAddress.Mobile'      ,  0, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'return BillingAccountPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditAddress.Mobile'      ,  1, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Orders.EditAddress.Mobile'      ,  2, 'Orders.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'return ShippingAccountPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Orders.EditAddress.Mobile'      ,  3, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'return BillingContactPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Orders.EditAddress.Mobile'      ,  4, 'Orders.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'return ShippingContactPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditAddress.Mobile'      ,  5, 'Orders.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditAddress.Mobile'      ,  6, 'Orders.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditAddress.Mobile'      ,  7, 'Orders.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditAddress.Mobile'      ,  8, 'Orders.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditAddress.Mobile'      ,  9, 'Orders.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditAddress.Mobile'      , 10, 'Orders.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditAddress.Mobile'      , 11, 'Orders.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditAddress.Mobile'      , 12, 'Orders.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditAddress.Mobile'      , 13, 'Orders.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditAddress.Mobile'      , 14, 'Orders.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
end -- if;
*/
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditDescription.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditDescription.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditDescription.Mobile', 'Orders', 'vwORDERS_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditDescription.Mobile'  ,  0, 'Orders.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
end -- if;
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
-- 05/01/2013 Paul.  Convert Change to ModulePopup. 
-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- 04/13/2016 Paul.  Add ZipCode lookup. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditView.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditView.Mobile', 'Invoices', 'vwINVOICES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Mobile'       ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Mobile'       ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'          , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView.Mobile'       ,  2, 'Invoices.LBL_INVOICE_NUM'               , 'INVOICE_NUM'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView.Mobile'       ,  3, 'Invoices.LBL_INVOICE_STAGE'             , 'INVOICE_STAGE'              , 1, 2, 'invoice_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView.Mobile'       ,  4, 'Invoices.LBL_QUOTE_NAME'                , 'QUOTE_NAME'                 , null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView.Mobile'       ,  5, 'Invoices.LBL_AMOUNT_DUE'                , 'AMOUNT_DUE_USDOLLAR'        , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Mobile'       ,  6, 'Invoices.LBL_PURCHASE_ORDER_NUM'        , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.Mobile'       ,  7, 'Invoices.LBL_DUE_DATE'                  , 'DUE_DATE'                   , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Invoices.EditView.Mobile'       ,  8, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView.Mobile'       ,  9, 'Invoices.LBL_PAYMENT_TERMS'             , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Mobile'       , 10, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Mobile'       , 11, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Invoices.EditView.Mobile'       , 12;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Mobile'       , 13, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.Mobile'       , 14, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Mobile'       , 15, 'Invoices.LBL_ACCOUNT'                   , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Mobile'       , 16, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Mobile'       , 17, 'Invoices.LBL_CONTACT'                   , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditView.Mobile'       , 18, 'Invoices.LBL_STREET'                    , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditView.Mobile'       , 19, 'Invoices.LBL_STREET'                    , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Mobile'       , 20, 'Invoices.LBL_CITY'                      , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Mobile'       , 21, 'Invoices.LBL_CITY'                      , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Mobile'       , 22, 'Invoices.LBL_STATE'                     , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Mobile'       , 23, 'Invoices.LBL_STATE'                     , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Invoices.EditView.Mobile'       , 24, 'Invoices.LBL_POSTAL_CODE'               , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Invoices.EditView.Mobile'       , 25, 'Invoices.LBL_POSTAL_CODE'               , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Mobile'       , 26, 'Invoices.LBL_COUNTRY'                   , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Mobile'       , 27, 'Invoices.LBL_COUNTRY'                   , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 05/01/2013 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Mobile', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Mobile', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditView.Mobile', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditView.Mobile', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 05/01/2013 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Mobile', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Mobile', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditView.Mobile'       ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'          , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditView.Mobile'       , 11, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress.Mobile' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_MergeView      'Invoices.EditView.Mobile', 'Invoices.EditAddress.Mobile', 'Invoices.LBL_BILLING_TITLE', 'Invoices.LBL_SHIPPING_TITLE';
	end -- if;
	-- 05/01/2013 Paul.  Convert Change to ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditView.Mobile'    ,  0, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditView.Mobile'    ,  2, 'Invoices.LBL_ACCOUNT'                   , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditView.Mobile'    ,  3, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditView.Mobile'    ,  4, 'Invoices.LBL_CONTACT'                   , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Mobile' and DATA_FIELD = 'BILLING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Mobile', 'BILLING_ACCOUNT_ID' , '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Mobile' and DATA_FIELD = 'SHIPPING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Mobile', 'SHIPPING_ACCOUNT_ID', '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Mobile' and DATA_FIELD = 'BILLING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Invoices.EditView.Mobile', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Mobile' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Invoices.EditView.Mobile', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Mobile' and DATA_FIELD = 'BILLING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Mobile', 'BILLING_CONTACT_ID' , '1,1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Mobile' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Mobile', 'SHIPPING_CONTACT_ID', '1,1';
	end -- if;
	-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Mobile' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Invoices.EditView.Mobile'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Invoices.EditView.Mobile', 'BILLING_ADDRESS_POSTALCODE';
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Invoices.EditView.Mobile', 'SHIPPING_ADDRESS_POSTALCODE';
end -- if;
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
/*
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditAddress.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditAddress.Mobile', 'Invoices', 'vwINVOICES_Edit', '15%', '30%', null;
	-- 08/29/2009 Paul.  Don't convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Invoices.EditAddress.Mobile'    ,  0, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'return BillingAccountPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditAddress.Mobile'    ,  1, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Invoices.EditAddress.Mobile'    ,  2, 'Invoices.LBL_ACCOUNT'                   , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'return ShippingAccountPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Invoices.EditAddress.Mobile'    ,  3, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'return BillingContactPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Invoices.EditAddress.Mobile'    ,  4, 'Invoices.LBL_CONTACT'                   , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'return ShippingContactPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditAddress.Mobile'    ,  5, 'Invoices.LBL_STREET'                    , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditAddress.Mobile'    ,  6, 'Invoices.LBL_STREET'                    , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress.Mobile'    ,  7, 'Invoices.LBL_CITY'                      , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress.Mobile'    ,  8, 'Invoices.LBL_CITY'                      , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress.Mobile'    ,  9, 'Invoices.LBL_STATE'                     , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress.Mobile'    , 10, 'Invoices.LBL_STATE'                     , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress.Mobile'    , 11, 'Invoices.LBL_POSTAL_CODE'               , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress.Mobile'    , 12, 'Invoices.LBL_POSTAL_CODE'               , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress.Mobile'    , 13, 'Invoices.LBL_COUNTRY'                   , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress.Mobile'    , 14, 'Invoices.LBL_COUNTRY'                   , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
end -- if;
*/
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditDescription.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditDescription.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditDescription.Mobile', 'Invoices', 'vwINVOICES_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditDescription.Mobile'  ,  0, 'Invoices.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
end -- if;
GO

-- 05/01/2013 Paul.  Convert Change to ModulePopup. 
-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView.Mobile';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Payments.EditView.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Payments.EditView.Mobile', 'Payments', 'vwPAYMENTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView.Mobile'       ,  0, 'Payments.LBL_AMOUNT'                    , 'AMOUNT'                     , 1, 1,  10, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.EditView.Mobile'       ,  1, 'Payments.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 1, 2, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Payments.EditView.Mobile'       ,  2, 'Payments.LBL_CURRENCY'                  , 'CURRENCY_ID'                , 1, 1, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView.Mobile'       ,  3, 'Payments.LBL_CUSTOMER_REFERENCE'        , 'CUSTOMER_REFERENCE'         , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Payments.EditView.Mobile'       ,  4, 'Payments.LBL_PAYMENT_DATE'              , 'PAYMENT_DATE'               , 1, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Payments.EditView.Mobile'       ,  5, 'Payments.LBL_PAYMENT_NUM'               , 'PAYMENT_NUM'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Payments.EditView.Mobile'       ,  6, 'Payments.LBL_PAYMENT_TYPE'              , 'PAYMENT_TYPE'               , 1, 1, 'payment_type_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Payments.EditView.Mobile'       ,  7, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.EditView.Mobile'       ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.EditView.Mobile'       ,  9, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Payments.EditView.Mobile'       , 10, 'Payments.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 5,   8, 60, 3;
	-- 05/01/2013 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Payments.EditView.Mobile', 'ACCOUNT_ID' , '1';
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Payments.EditView.Mobile'       ,  9, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 05/01/2013 Paul.  Convert the ChangeButton to a ModulePopup. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView.Mobile' and DATA_FIELD = 'ACCOUNT_ID' and FIELD_TYPE = 'ChangeButton' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Payments.EditView.Mobile'       ,  1, 'Payments.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 1, 2, 'ACCOUNT_NAME'       , 'Accounts', null;
		-- 05/01/2013 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Payments.EditView.Mobile', 'ACCOUNT_ID' , '1';
	end -- if;
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView.Mobile' and DATA_FIELD = 'PAYMENT_TYPE' and CACHE_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTypes'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Payments.EditView.Mobile'
		--   and DATA_FIELD        = 'PAYMENT_TYPE'
		--   and CACHE_NAME        = 'payment_type_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Forums.EditView.Mobile' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Forums.EditView.Mobile';
	exec dbo.spEDITVIEWS_InsertOnly            'Forums.EditView.Mobile', 'Forums', 'vwFORUMS_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Forums.EditView.Mobile'          ,  0, 'Forums.LBL_TITLE'                      , 'TITLE'                      , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Forums.EditView.Mobile'          ,  1, 'Forums.LBL_CATEGORY'                   , 'CATEGORY'                   , 1, 2, 'ForumTopics', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Forums.EditView.Mobile'          ,  2, 'Teams.LBL_TEAM'                        , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Forums.EditView.Mobile'          ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Forums.EditView.Mobile'          ,  4, 'Forums.LBL_DESCRIPTION'                , 'DESCRIPTION'                , 0, 1,   4, 60, null;
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

call dbo.spEDITVIEWS_FIELDS_MobileProfessional()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_MobileProfessional')
/

-- #endif IBM_DB2 */


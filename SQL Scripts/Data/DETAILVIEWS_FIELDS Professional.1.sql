

print 'DETAILVIEWS_FIELDS Professional';
--delete from DETAILVIEWS_FIELDS where DETAIL_NAME like '%.DetailView'
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 09/08/2008 Paul.  Must use a comment block to allow Oracle migration to work properly. 
-- 09/14/2008 Paul.  DB2 does not work well with optional parameters. 
-- 08/24/2009 Paul.  Change TEAM_NAME to TEAM_SET_NAME. 
-- 08/28/2009 Paul.  Restore TEAM_NAME and expect it to be converted automatically when DynamicTeams is enabled. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 

/*
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Roles.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Roles.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Roles.DetailView'         , 'Roles'         , 'vwROLES_Edit'         , '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Roles.DetailView'   ,  0, 'Roles.LBL_NAME'                  , 'NAME'                             , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Roles.DetailView'   ,  1, 'TextBox', 'Roles.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
--GO
*/


-- 06/03/2006 Paul.  Add support for Contracts. 
-- 11/30/2007 Paul.  Change TYPE to unique identifier and rename to TYPE_ID. Use type name directly instead of as a list.
-- 05/14/2016 Paul.  Add Tags module. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contracts.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contracts.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contracts.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contracts.DetailView', 'Contracts', 'vwCONTRACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView',  0, 'Contracts.LBL_NAME'                , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView',  1, 'Contracts.LBL_START_DATE'          , 'START_DATE'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView',  2, 'Contracts.LBL_REFERENCE_CODE'      , 'REFERENCE_CODE'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView',  3, 'Contracts.LBL_END_DATE'            , 'END_DATE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contracts.DetailView',  4, 'Contracts.LBL_ACCOUNT_NAME'        , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'          , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Contracts.DetailView',  5, 'Contracts.LBL_STATUS'              , 'STATUS'                           , '{0}'        , 'contract_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contracts.DetailView',  6, 'Contracts.LBL_OPPORTUNITY_NAME'    , 'OPPORTUNITY_NAME'                 , '{0}'        , 'OPPORTUNITY_ID'      , '~/Opportunities/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView',  7, 'Contracts.LBL_COMPANY_SIGNED_DATE' , 'COMPANY_SIGNED_DATE'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView',  8, 'Contracts.LBL_CONTRACT_VALUE'      , 'TOTAL_CONTRACT_VALUE'             , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView',  9, 'Contracts.LBL_CUSTOMER_SIGNED_DATE', 'CUSTOMER_SIGNED_DATE'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView', 10, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView', 11, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView', 12, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView', 13, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView', 14, 'Contracts.LBL_EXPIRATION_NOTICE'   , 'EXPIRATION_NOTICE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView', 15, 'Contracts.LBL_TYPE'                , 'TYPE'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsTags      'Contracts.DetailView', 16, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Contracts.DetailView', 17, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contracts.DetailView', 16, 'TextBox', 'Contracts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	exec dbo.spDETAILVIEWS_FIELDS_CnvBound     'Contracts.DetailView', 10, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                        , '{0}'        , null;

	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contracts.DetailView' and DATA_FIELD = 'TYPE' and LIST_NAME = 'ContractTypes' and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS Contracts.DetailView: Use type name directly instead of as a list.';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME        = null
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where DETAIL_NAME      = 'Contracts.DetailView'
		   and DATA_FIELD       = 'TYPE'
		   and LIST_NAME        = 'ContractTypes'
		   and DELETED          = 0;
	end -- if;
	-- 05/14/2016 Paul.  Add Tags module. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contracts.DetailView' and DATA_FIELD = 'TAG_SET_NAME' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where DETAIL_NAME       = 'Contracts.DetailView'
		   and FIELD_INDEX      >= 16
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsTags       'Contracts.DetailView', 16, null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Contracts.DetailView', 17, null;
	end -- if;
end -- if;
GO

-- 06/05/2006 Paul.  Add support for Products. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Products.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Products.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Products.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Products.DetailView', 'Products', 'vwPRODUCTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' ,  0, 'Products.LBL_NAME'                , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.DetailView' ,  1, 'Products.LBL_STATUS'              , 'STATUS'                            , '{0}'        , 'product_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Products.DetailView' ,  2, 'Products.LBL_ACCOUNT_NAME'        , 'ACCOUNT_NAME'                      , '{0}'        , 'ACCOUNT_ID'         , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Products.DetailView' ,  3, 'Products.LBL_CONTACT_NAME'        , 'CONTACT_NAME'                      , '{0}'        , 'CONTACT_ID'         , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Products.DetailView' ,  4, 'Products.LBL_QUOTE_NAME'          , 'QUOTE_NAME'                        , '{0}'        , 'QUOTE_ID'           , '~/Quotes/view.aspx?ID={0}'  , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' ,  5, 'Products.LBL_DATE_PURCHASED'      , 'DATE_PURCHASED'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' ,  6, 'Products.LBL_QUANTITY'            , 'QUANTITY'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' ,  7, 'Products.LBL_DATE_SUPPORT_STARTS' , 'DATE_SUPPORT_STARTS'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView' ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' ,  9, 'Products.LBL_DATE_SUPPORT_EXPIRES', 'DATE_SUPPORT_EXPIRES'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 10, 'Products.LBL_CURRENCY'            , 'CURRENCY_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView' , 11, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 12, 'Products.LBL_COST_PRICE'          , 'COST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView' , 13, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 14, 'Products.LBL_LIST_PRICE'          , 'LIST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 15, 'Products.LBL_BOOK_VALUE'          , 'BOOK_VALUE'                        , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 16, 'Products.LBL_DISCOUNT_PRICE'      , 'DISCOUNT_USDOLLAR'                 , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 17, 'Products.LBL_BOOK_VALUE_DATE'     , 'BOOK_VALUE_DATE'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView' , 18, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView' , 19, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 20, 'Products.LBL_WEBSITE'             , 'WEBSITE'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.DetailView' , 21, 'Products.LBL_TAX_CLASS'           , 'TAX_CLASS'                         , '{0}'        , 'tax_class_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 22, 'Products.LBL_MANUFACTURER'        , 'MANUFACTURER_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 23, 'Products.LBL_WEIGHT'              , 'WEIGHT'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 24, 'Products.LBL_MFT_PART_NUM'        , 'MFT_PART_NUM'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 25, 'Products.LBL_CATEGORY'            , 'CATEGORY_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 26, 'Products.LBL_VENDOR_PART_NUM'     , 'VENDOR_PART_NUM'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 27, 'Products.LBL_TYPE'                , 'TYPE_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 28, 'Products.LBL_SERIAL_NUMBER'       , 'SERIAL_NUMBER'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView' , 29, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 30, 'Products.LBL_ASSET_NUMBER'        , 'ASSET_NUMBER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.DetailView' , 31, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 32, 'Products.LBL_SUPPORT_NAME'        , 'SUPPORT_NAME'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 33, 'Products.LBL_SUPPORT_CONTACT'     , 'SUPPORT_CONTACT'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.DetailView' , 34, 'Products.LBL_SUPPORT_DESCRIPTION' , 'SUPPORT_DESCRIPTION'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.DetailView' , 35, 'Products.LBL_SUPPORT_TERM'        , 'SUPPORT_TERM'                      , '{0}'        , 'support_term_dom'   , null;
end -- if;
GO

-- 07/10/2010 Paul.  Add Options fields. 
-- 10/21/2015 Paul.  Add min and max order fields for published data. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ProductTemplates.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'ProductTemplates.DetailView', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' ,  0, 'ProductTemplates.LBL_NAME'                , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'ProductTemplates.DetailView' ,  1, 'ProductTemplates.LBL_STATUS'              , 'STATUS'                            , '{0}'        , 'product_template_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' ,  2, 'ProductTemplates.LBL_WEBSITE'             , 'WEBSITE'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' ,  3, 'ProductTemplates.LBL_DATE_AVAILABLE'      , 'DATE_AVAILABLE'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'ProductTemplates.DetailView' ,  4, 'ProductTemplates.LBL_TAX_CLASS'           , 'TAX_CLASS'                         , '{0}'        , 'tax_class_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' ,  5, 'ProductTemplates.LBL_QUANTITY'            , 'QUANTITY'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' ,  6, 'ProductTemplates.LBL_MINIMUM_QUANTITY'    , 'MINIMUM_QUANTITY'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' ,  7, 'ProductTemplates.LBL_MAXIMUM_QUANTITY'    , 'MAXIMUM_QUANTITY'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView' ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' ,  9, 'ProductTemplates.LBL_LIST_ORDER'          , 'LIST_ORDER'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 10, 'ProductTemplates.LBL_MANUFACTURER'        , 'MANUFACTURER_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 11, 'ProductTemplates.LBL_WEIGHT'              , 'WEIGHT'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 12, 'ProductTemplates.LBL_MFT_PART_NUM'        , 'MFT_PART_NUM'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 13, 'ProductTemplates.LBL_CATEGORY'            , 'CATEGORY_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 14, 'ProductTemplates.LBL_VENDOR_PART_NUM'     , 'VENDOR_PART_NUM'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 15, 'ProductTemplates.LBL_TYPE'                , 'TYPE_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 16, 'ProductTemplates.LBL_MINIMUM_OPTIONS'     , 'MINIMUM_OPTIONS'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 17, 'ProductTemplates.LBL_MAXIMUM_OPTIONS'     , 'MAXIMUM_OPTIONS'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView' , 18, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView' , 19, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 20, 'ProductTemplates.LBL_CURRENCY'            , 'CURRENCY_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 21, 'ProductTemplates.LBL_SUPPORT_NAME'        , 'SUPPORT_NAME'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 22, 'ProductTemplates.LBL_COST_PRICE'          , 'COST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 23, 'ProductTemplates.LBL_SUPPORT_CONTACT'     , 'SUPPORT_CONTACT'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 24, 'ProductTemplates.LBL_LIST_PRICE'          , 'LIST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 25, 'ProductTemplates.LBL_SUPPORT_DESCRIPTION' , 'SUPPORT_DESCRIPTION'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 26, 'ProductTemplates.LBL_DISCOUNT_PRICE'      , 'DISCOUNT_USDOLLAR'                 , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'ProductTemplates.DetailView' , 27, 'ProductTemplates.LBL_SUPPORT_TERM'        , 'SUPPORT_TERM'                      , '{0}'        , 'support_term_dom'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 28, 'ProductTemplates.LBL_DISCOUNT_NAME'       , 'DISCOUNT_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView' , 29, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 30, 'ProductTemplates.LBL_PRICING_FORMULA'     , 'PRICING_FORMULA'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 31, 'ProductTemplates.LBL_PRICING_FACTOR'      , 'PRICING_FACTOR'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'ProductTemplates.DetailView' , 32, 'TextBox', 'ProductTemplates.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 07/10/2010 Paul.  Add Options fields. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView' and DATA_FIELD = 'MINIMUM_OPTIONS' and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS ProductTemplates.DetailView: Add options fields.';
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'ProductTemplates.DetailView'
		   and FIELD_INDEX      >= 14
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 14, 'ProductTemplates.LBL_MINIMUM_OPTIONS'     , 'MINIMUM_OPTIONS'                   , '{0}'        , null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 15, 'ProductTemplates.LBL_MAXIMUM_OPTIONS'     , 'MAXIMUM_OPTIONS'                   , '{0}'        , null;
	end -- if;
	-- 08/
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView' and DATA_FIELD = 'DISCOUNT_NAME' and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS ProductTemplates.DetailView: Change PRICING_FORMULA to DISCOUNT.';
		update DETAILVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'ProductTemplates.DetailView'
		   and DATA_FIELD        = 'PRICING_FORMULA'
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 26, 'ProductTemplates.LBL_DISCOUNT_NAME'       , 'DISCOUNT_NAME'                     , '{0}'        , null;
	end -- if;
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView' and DATA_FIELD = 'PRICING_FORMULA' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'ProductTemplates.DetailView'
		   and FIELD_TYPE        = 'Blank'
		   and FIELD_INDEX      in (28, 29)
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 28, 'ProductTemplates.LBL_PRICING_FORMULA'     , 'PRICING_FORMULA'                   , '{0}'        , null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' , 29, 'ProductTemplates.LBL_PRICING_FACTOR'      , 'PRICING_FACTOR'                    , '{0}'        , null;
	end -- if;
	-- 10/21/2015 Paul.  Add min and max order fields for published data. 
	exec dbo.spDETAILVIEWS_FIELDS_CnvBound     'ProductTemplates.DetailView' ,  6, 'ProductTemplates.LBL_MINIMUM_QUANTITY'    , 'MINIMUM_QUANTITY'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_CnvBound     'ProductTemplates.DetailView' ,  7, 'ProductTemplates.LBL_MAXIMUM_QUANTITY'    , 'MAXIMUM_QUANTITY'                  , '{0}'        , null;
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTemplates.DetailView' and DATA_FIELD = 'LIST_ORDER' and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS ProductTemplates.DetailView: Add options fields.';
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'ProductTemplates.DetailView'
		   and FIELD_INDEX      >= 8
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductTemplates.DetailView' ,  8, null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTemplates.DetailView' ,  9, 'ProductTemplates.LBL_LIST_ORDER'          , 'LIST_ORDER'                        , '{0}'        , null;
	end -- if;
end -- if;
GO

-- 02/04/2008 Paul.  Provide a catalog viewer. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Products.ProductCatalog' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Products.ProductCatalog';
	exec dbo.spDETAILVIEWS_InsertOnly          'Products.ProductCatalog', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' ,  0, 'ProductTemplates.LBL_NAME'                , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.ProductCatalog' ,  1, 'ProductTemplates.LBL_STATUS'              , 'STATUS'                            , '{0}'        , 'product_template_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' ,  2, 'ProductTemplates.LBL_WEBSITE'             , 'WEBSITE'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' ,  3, 'ProductTemplates.LBL_DATE_AVAILABLE'      , 'DATE_AVAILABLE'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.ProductCatalog' ,  4, 'ProductTemplates.LBL_TAX_CLASS'           , 'TAX_CLASS'                         , '{0}'        , 'tax_class_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' ,  5, 'ProductTemplates.LBL_QUANTITY'            , 'QUANTITY'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.ProductCatalog' ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.ProductCatalog' ,  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' ,  8, 'ProductTemplates.LBL_MANUFACTURER'        , 'MANUFACTURER_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' ,  9, 'ProductTemplates.LBL_WEIGHT'              , 'WEIGHT'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' , 10, 'ProductTemplates.LBL_MFT_PART_NUM'        , 'MFT_PART_NUM'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' , 11, 'ProductTemplates.LBL_CATEGORY'            , 'CATEGORY_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' , 12, 'ProductTemplates.LBL_VENDOR_PART_NUM'     , 'VENDOR_PART_NUM'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' , 13, 'ProductTemplates.LBL_TYPE'                , 'TYPE_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.ProductCatalog' , 14, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.ProductCatalog' , 15, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' , 16, 'ProductTemplates.LBL_SUPPORT_NAME'        , 'SUPPORT_NAME'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' , 17, 'ProductTemplates.LBL_SUPPORT_CONTACT'     , 'SUPPORT_CONTACT'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Products.ProductCatalog' , 18, 'ProductTemplates.LBL_SUPPORT_DESCRIPTION' , 'SUPPORT_DESCRIPTION'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.ProductCatalog' , 19, 'ProductTemplates.LBL_SUPPORT_TERM'        , 'SUPPORT_TERM'                      , '{0}'        , 'support_term_dom'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Products.ProductCatalog' , 20, 'ProductTemplates.LBL_PRICING_FORMULA'     , 'PRICING_FORMULA'                   , '{0}'        , 'pricing_formula_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Products.ProductCatalog' , 21, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Products.ProductCatalog' , 22, 'TextBox', 'ProductTemplates.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- 05/14/2016 Paul.  Add Tags module. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.DetailView', 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   ,  0, 'Quotes.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   ,  2, 'Quotes.LBL_QUOTE_NUM'             , 'QUOTE_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView'   ,  3, 'Quotes.LBL_QUOTE_STAGE'           , 'QUOTE_STAGE'                       , '{0}'        , 'quote_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   ,  4, 'Quotes.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'      , 'DATE_QUOTE_EXPECTED_CLOSED'        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView'   ,  6, 'Quotes.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   ,  7, 'Quotes.LBL_ORIGINAL_PO_DATE'      , 'ORIGINAL_PO_DATE'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   , 10, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   , 11, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsTags      'Quotes.DetailView'   , 12, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.DetailView'   , 13, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView'   , 14, 'Quotes.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView'   , 15, 'Quotes.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView'   , 16, 'Quotes.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView'   , 17, 'Quotes.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   , 18, 'Quotes.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView'   , 19, 'Quotes.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Quotes.DetailView'   , 20, 'TextBox', 'Quotes.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	exec dbo.spDETAILVIEWS_FIELDS_CnvBound     'Quotes.DetailView'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
	/*
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME         = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Quotes.DetailView'
		   and DATA_FIELD        = 'PAYMENT_TERMS'
		   and LIST_NAME         = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
	*/
	-- 05/14/2016 Paul.  Add Tags module. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView' and DATA_FIELD = 'TAG_SET_NAME' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where DETAIL_NAME       = 'Quotes.DetailView'
		   and FIELD_INDEX      >= 12
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsTags       'Quotes.DetailView', 12, null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Quotes.DetailView', 13, null;
	end -- if;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.SummaryView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.SummaryView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.SummaryView', 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView'  ,  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView'  ,  1, 'Quotes.LBL_SUBTOTAL'              , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView'  ,  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView'  ,  3, 'Quotes.LBL_DISCOUNT'              , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView'  ,  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView'  ,  5, 'Quotes.LBL_SHIPPING'              , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView'  ,  7, 'Quotes.LBL_TAX'                   , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView'  ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView'  ,  9, 'Quotes.LBL_TOTAL'                 , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO

-- 10/15/2006 Paul.  Add support for Teams. 
-- 04/12/2016 Paul.  Add parent team and custom fields. 
-- 04/28/2016 Paul.  Rename parent to PARENT_ID. 
-- 11/11/2020 Paul.  React requires full url in format. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Teams.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Teams.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Teams.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Teams.DetailView', 'Teams', 'vwTEAMS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Teams.DetailView'    ,  0, 'Teams.LBL_NAME'                  , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Teams.DetailView'    ,  1, 'Teams.LBL_PARENT_NAME'           , 'PARENT_NAME'                      , '{0}'        , 'PARENT_ID' , '~/Administration/Teams/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Teams.DetailView'    ,  2, 'TextBox', 'Teams.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 04/12/2016 Paul.  Add parent team and custom fields. 
	-- 04/28/2016 Paul.  Rename parent to PARENT_ID. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Teams.DetailView' and DATA_FIELD = 'PARENT_TEAM_NAME' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set DATA_FIELD        = 'PARENT_NAME'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Teams.DetailView'
		   and DATA_FIELD        = 'PARENT_TEAM_NAME'
		   and DELETED           = 0;
	end -- if;
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Teams.DetailView' and DATA_FIELD = 'PARENT_NAME' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Teams.DetailView'
		   and FIELD_INDEX      >= 1
		   and DELETED           = 0;
		update DETAILVIEWS_FIELDS
		   set COLSPAN           = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Teams.DetailView'
		   and DATA_FIELD        = 'NAME'
		   and COLSPAN           = 3
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Teams.DetailView'    ,  1, 'Teams.LBL_PARENT_NAME'           , 'PARENT_NAME'                      , '{0}'        , 'PARENT_ID' , '~/Administration/Teams/view.aspx?ID={0}', null, null;
	end -- if;

	-- 11/11/2020 Paul.  React requires full url in format. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Teams.DetailView' and DATA_FIELD = 'PARENT_NAME' and URL_FORMAT = 'view.aspx?ID={0}' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set URL_FORMAT        = '~/Administration/Teams/view.aspx?ID={0}'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Teams.DetailView'
		   and DATA_FIELD        = 'PARENT_NAME'
		   and URL_FORMAT        = 'view.aspx?ID={0}'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 10/15/2006 Paul.  Add support for Team Notices. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TeamNotices.DetailView'
-- 01/01/2008 Paul.  We should not need to fix descriptions on a clean install. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TeamNotices.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS TeamNotices.DetailView';
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TeamNotices.DetailView'    ,  0, 'TeamNotices.LBL_DATE_START'             , 'DATE_START'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TeamNotices.DetailView'    ,  1, 'TeamNotices.LBL_TEAM'                   , 'TEAM_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TeamNotices.DetailView'    ,  2, 'TeamNotices.LBL_DATE_END'               , 'DATE_END'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'TeamNotices.DetailView'    ,  3, 'TeamNotices.LBL_STATUS'                 , 'STATUS'                     , '{0}'        , 'team_notice_status_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TeamNotices.DetailView'    ,  4, 'TeamNotices.LBL_NAME'                   , 'NAME'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'TeamNotices.DetailView'    ,  5, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'TeamNotices.DetailView'    ,  6, 'TextBox', 'TeamNotices.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'TeamNotices.DetailView'    ,  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TeamNotices.DetailView'    ,  8, 'TeamNotices.LBL_URL_TITLE'              , 'URL_TITLE'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'TeamNotices.DetailView'    ,  9, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TeamNotices.DetailView'    , 10, 'TeamNotices.LBL_URL'                    , 'URL'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'TeamNotices.DetailView'    , 11, null;
end -- if;
GO

-- 04/03/2007 Paul.  Add Orders module. 
-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- 05/14/2016 Paul.  Add Tags module. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.DetailView', 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   ,  0, 'Orders.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   ,  1, 'Orders.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   ,  2, 'Orders.LBL_ORDER_NUM'             , 'ORDER_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView'   ,  3, 'Orders.LBL_ORDER_STAGE'           , 'ORDER_STAGE'                       , '{0}'        , 'order_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   ,  4, 'Orders.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   ,  5, 'Orders.LBL_DATE_ORDER_DUE'        , 'DATE_ORDER_DUE'                    , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView'   ,  6, 'Orders.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'    , 'DATE_ORDER_SHIPPED'                , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   , 10, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   , 11, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsTags      'Orders.DetailView'   , 12, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.DetailView'   , 13, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView'   , 14, 'Orders.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView'   , 15, 'Orders.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView'   , 16, 'Orders.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView'   , 17, 'Orders.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   , 18, 'Orders.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView'   , 19, 'Orders.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Orders.DetailView'   , 20, 'TextBox', 'Orders.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
	/*
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME         = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Orders.DetailView'
		   and DATA_FIELD        = 'PAYMENT_TERMS'
		   and LIST_NAME         = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
	*/
	-- 05/14/2016 Paul.  Add Tags module. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView' and DATA_FIELD = 'TAG_SET_NAME' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where DETAIL_NAME       = 'Orders.DetailView'
		   and FIELD_INDEX      >= 12
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsTags       'Orders.DetailView', 12, null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Orders.DetailView', 13, null;
	end -- if;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.SummaryView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.SummaryView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.SummaryView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.SummaryView', 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView'  ,  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView'  ,  1, 'Orders.LBL_SUBTOTAL'              , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView'  ,  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView'  ,  3, 'Orders.LBL_DISCOUNT'              , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView'  ,  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView'  ,  5, 'Orders.LBL_SHIPPING'              , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView'  ,  7, 'Orders.LBL_TAX'                   , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView'  ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView'  ,  9, 'Orders.LBL_TOTAL'                 , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO

-- 05/12/2009 Paul.  
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'OrdersLineItems.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'OrdersLineItems.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS OrdersLineItems.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'OrdersLineItems.DetailView', 'Orders', 'vwORDERS_LINE_ITEMS_Detail', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView',  0, 'Orders.LBL_ITEM_NAME'                     , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'OrdersLineItems.DetailView',  1, 'Orders.LBL_ITEM_TAX_CLASS'                , 'TAX_CLASS'                         , '{0}'        , 'tax_class_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView',  2, 'Orders.LBL_ITEM_MFT_PART_NUM'             , 'MFT_PART_NUM'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView',  3, 'Orders.LBL_ITEM_VENDOR_PART_NUM'          , 'VENDOR_PART_NUM'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView',  4, 'Orders.LBL_ITEM_QUANTITY'                 , 'QUANTITY'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'OrdersLineItems.DetailView',  5, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView',  6, 'Orders.LBL_ITEM_COST_PRICE'               , 'COST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView',  7, 'Orders.LBL_ITEM_LIST_PRICE'               , 'LIST_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView',  8, 'Orders.LBL_ITEM_UNIT_PRICE'               , 'UNIT_USDOLLAR'                     , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView',  9, 'Orders.LBL_ITEM_EXTENDED_PRICE'           , 'EXTENDED_USDOLLAR'                 , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 10, '.LBL_DATE_ENTERED'                        , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 11, '.LBL_DATE_MODIFIED'                       , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'OrdersLineItems.DetailView', 12, 'TextBox', 'Orders.LBL_ITEM_DESCRIPTION'   , 'DESCRIPTION', null, null, null, null, null, 3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'OrdersLineItems.DetailView', 13, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'OrdersLineItems.DetailView', 14, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 15, 'Products.LBL_SERIAL_NUMBER'               , 'SERIAL_NUMBER'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 16, 'Products.LBL_ASSET_NUMBER'                , 'ASSET_NUMBER'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 17, 'Orders.LBL_DATE_ORDER_SHIPPED'            , 'DATE_ORDER_SHIPPED'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 18, 'Products.LBL_DATE_SUPPORT_EXPIRES'        , 'DATE_SUPPORT_EXPIRES'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 19, 'Products.LBL_DATE_SUPPORT_STARTS'         , 'DATE_SUPPORT_STARTS'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 20, 'Products.LBL_SUPPORT_NAME'                , 'SUPPORT_NAME'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 21, 'Products.LBL_SUPPORT_CONTACT'             , 'SUPPORT_CONTACT'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'OrdersLineItems.DetailView', 22, 'Products.LBL_SUPPORT_TERM'                , 'SUPPORT_TERM'                      , '{0}', 'support_term_dom'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'OrdersLineItems.DetailView', 23, 'TextBox', 'Products.LBL_SUPPORT_DESCRIPTION', 'SUPPORT_DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 06/02/2009 Paul.  Fix OrdersLineItems.DetailView to use vwORDERS_LINE_ITEMS_Detail.
	if exists(select * from DETAILVIEWS where NAME = 'OrdersLineItems.DetailView' and VIEW_NAME <> 'vwORDERS_LINE_ITEMS_Detail' and DELETED = 0) begin -- then
		print 'DETAILVIEWS: Fix OrdersLineItems.DetailView to use vwORDERS_LINE_ITEMS_Detail.';
		update DETAILVIEWS
		   set VIEW_NAME =  'vwORDERS_LINE_ITEMS_Detail'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where NAME      =  'OrdersLineItems.DetailView'
		   and VIEW_NAME <> 'vwORDERS_LINE_ITEMS_Detail'
		   and DELETED   = 0;
	end -- if;
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'OrdersLineItems.DetailView' and DATA_FIELD = 'SERIAL_NUMBER' and DELETED = 0) begin -- then
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'OrdersLineItems.DetailView', 13, null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'OrdersLineItems.DetailView', 14, null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 15, 'Products.LBL_SERIAL_NUMBER'               , 'SERIAL_NUMBER'                     , '{0}', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 16, 'Products.LBL_ASSET_NUMBER'                , 'ASSET_NUMBER'                      , '{0}', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 17, 'Orders.LBL_DATE_ORDER_SHIPPED'            , 'DATE_ORDER_SHIPPED'                , '{0}', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 18, 'Products.LBL_DATE_SUPPORT_EXPIRES'        , 'DATE_SUPPORT_EXPIRES'              , '{0}', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 19, 'Products.LBL_DATE_SUPPORT_STARTS'         , 'DATE_SUPPORT_STARTS'               , '{0}', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 20, 'Products.LBL_SUPPORT_NAME'                , 'SUPPORT_NAME'                      , '{0}', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OrdersLineItems.DetailView', 21, 'Products.LBL_SUPPORT_CONTACT'             , 'SUPPORT_CONTACT'                   , '{0}', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'OrdersLineItems.DetailView', 22, 'Products.LBL_SUPPORT_TERM'                , 'SUPPORT_TERM'                      , '{0}', 'support_term_dom'   , null;
		exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'OrdersLineItems.DetailView', 23, 'TextBox', 'Products.LBL_SUPPORT_DESCRIPTION', 'SUPPORT_DESCRIPTION', null, null, null, null, null, 3, null;
	end -- if;
end -- if;
GO

-- 04/11/2007 Paul.  Add Invoices module. 
-- 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- 05/14/2016 Paul.  Add Tags module. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.DetailView', 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' ,  0, 'Invoices.LBL_NAME'                 , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView' ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'     , 'OPPORTUNITY_NAME'                  , '{0}'        , 'OPPORTUNITY_ID' , '~/Opportunities/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' ,  2, 'Invoices.LBL_INVOICE_NUM'          , 'INVOICE_NUM'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView' ,  3, 'Invoices.LBL_INVOICE_STAGE'        , 'INVOICE_STAGE'                     , '{0}'        , 'invoice_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView' ,  4, 'Invoices.LBL_QUOTE_NAME'           , 'QUOTE_NAME'                        , '{0}'        , 'QUOTE_ID'       , '~/Quotes/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView' ,  5, 'Invoices.LBL_PAYMENT_TERMS'        , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView' ,  6, 'Invoices.LBL_ORDER_NAME'           , 'ORDER_NAME'                        , '{0}'        , 'ORDER_ID'       , '~/Orders/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' ,  7, 'Invoices.LBL_DUE_DATE'             , 'DUE_DATE'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' ,  7, 'Invoices.LBL_SHIP_DATE'            , 'SHIP_DATE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' ,  9, 'Invoices.LBL_PURCHASE_ORDER_NUM'   , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' , 10, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' , 11, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' , 12, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' , 13, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsTags      'Invoices.DetailView' , 14, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.DetailView' , 15, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView' , 16, 'Invoices.LBL_BILLING_CONTACT_NAME' , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView' , 17, 'Invoices.LBL_SHIPPING_CONTACT_NAME', 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView' , 18, 'Invoices.LBL_BILLING_ACCOUNT_NAME' , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView' , 19, 'Invoices.LBL_SHIPPING_ACCOUNT_NAME', 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' , 20, 'Invoices.LBL_BILLING_ADDRESS'      , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView' , 21, 'Invoices.LBL_SHIPPING_ADDRESS'     , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Invoices.DetailView' , 22, 'TextBox', 'Invoices.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
	exec dbo.spDETAILVIEWS_FIELDS_CnvBound     'Invoices.DetailView' ,  7, 'Invoices.LBL_SHIP_DATE'            , 'SHIP_DATE'                         , '{0}'        , null;
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
	/*
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME         = 'PaymentTerms'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Invoices.DetailView'
		   and DATA_FIELD        = 'PAYMENT_TERMS'
		   and LIST_NAME         = 'payment_terms_dom'
		   and DELETED           = 0;
	end -- if;
	*/
	-- 05/14/2016 Paul.  Add Tags module. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView' and DATA_FIELD = 'TAG_SET_NAME' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where DETAIL_NAME       = 'Invoices.DetailView'
		   and FIELD_INDEX      >= 14
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsTags       'Invoices.DetailView', 14, null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Invoices.DetailView', 15, null;
	end -- if;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.SummaryView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.SummaryView', 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView',  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView',  1, 'Invoices.LBL_SUBTOTAL'            , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView',  3, 'Invoices.LBL_DISCOUNT'            , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView',  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView',  5, 'Invoices.LBL_SHIPPING'            , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView',  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView',  7, 'Invoices.LBL_TAX'                 , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView',  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView',  9, 'Invoices.LBL_TOTAL'               , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO


-- 08/26/2010 Paul.  We need a bank fee field to allow for a difference between allocated and received payment. 
-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 02/22/2015 Paul.  Add DATE_MODIFIED and DATE_ENTERED. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Payments.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Payments.DetailView', 'Payments', 'vwPAYMENTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' ,  0, 'Payments.LBL_AMOUNT'               , 'AMOUNT_USDOLLAR'                   , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' ,  1, 'Payments.LBL_BANK_FEE'             , 'BANK_FEE_USDOLLAR'                 , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Payments.DetailView' ,  2, 'Payments.LBL_ACCOUNT_NAME'         , 'ACCOUNT_NAME'                      , '{0}'        , 'ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Payments.DetailView' ,  3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' ,  4, 'Payments.LBL_PAYMENT_DATE'         , 'PAYMENT_DATE'                      , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' ,  5, 'Payments.LBL_CUSTOMER_REFERENCE'   , 'CUSTOMER_REFERENCE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Payments.DetailView' ,  6, 'Payments.LBL_PAYMENT_TYPE'         , 'PAYMENT_TYPE'                      , '{0}'        , 'payment_type_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' ,  7, 'Payments.LBL_PAYMENT_NUM'          , 'PAYMENT_NUM'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' ,  8, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' ,  9, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' , 10, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' , 11, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Payments.DetailView' , 12, 'TextBox', 'Payments.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView' and DATA_FIELD = 'BANK_FEE_USDOLLAR' and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS Payments.DetailView: Add BANK_FEE_USDOLLAR.';
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Payments.DetailView'
		   and FIELD_INDEX      >= 1
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' ,  1, 'Payments.LBL_BANK_FEE'             , 'BANK_FEE_USDOLLAR'                 , '{0:c}'      , null;
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Payments.DetailView'
		   and FIELD_INDEX      >= 3
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Payments.DetailView' ,  3, null;
	end -- if;
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
	/*
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView' and DATA_FIELD = 'PAYMENT_TYPE' and LIST_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		update DETAILVIEWS_FIELDS
		   set LIST_NAME         = 'PaymentTypes'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Payments.DetailView'
		   and DATA_FIELD        = 'PAYMENT_TYPE'
		   and LIST_NAME         = 'payment_type_dom'
		   and DELETED           = 0;
	end -- if;
	*/
	-- 02/22/2015 Paul.  Add DATE_MODIFIED and DATE_ENTERED. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.DetailView' and DATA_FIELD like 'DATE_MODIFIED%' and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS Payments.DetailView: Add DATE_MODIFIED.';
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' , -1, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.DetailView' , -1, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	end -- if;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.SummaryView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Payments.SummaryView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Payments.SummaryView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Payments.SummaryView', 'Invoices', 'vwPAYMENTS_Edit', '25%', '75%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Payments.SummaryView',  0, 'Payments.LBL_ALLOCATED'             , 'TOTAL_ALLOCATED_USDOLLAR'         , '{0:c}'      , null;
end -- if;
GO

-- 07/07/2007 Paul.  Convert to TextBox to take advantage of new code that converts \r\n to <br />.
-- 05/14/2016 Paul.  This is old but still valid for upgrades.  Reduce usage by filtering by Orders.DetailView. 
if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView'  and FIELD_TYPE = 'String' and DATA_FIELD = 'DESCRIPTION') begin -- then
	print 'Fix DETAILVIEWS_FIELDS: Convert to TextBox to take advantage of new code that converts \r\n to <br />.';
	update DETAILVIEWS_FIELDS
	   set FIELD_TYPE       = 'TextBox'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where FIELD_TYPE       = 'String'
	   and (1 = 0
	        or (DETAIL_NAME = 'Accounts.DetailView'         and DATA_LABEL = 'Accounts.LBL_DESCRIPTION'         and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Roles.DetailView'            and DATA_LABEL = 'Roles.LBL_DESCRIPTION'            and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Bugs.DetailView'             and DATA_LABEL = 'Bugs.LBL_DESCRIPTION'             and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Bugs.DetailView'             and DATA_LABEL = 'Bugs.LBL_WORK_LOG'                and DATA_FIELD = 'WORK_LOG'   )
	        or (DETAIL_NAME = 'Calls.DetailView'            and DATA_LABEL = 'Calls.LBL_DESCRIPTION'            and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Cases.DetailView'            and DATA_LABEL = 'Cases.LBL_DESCRIPTION'            and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Cases.DetailView'            and DATA_LABEL = 'Cases.LBL_RESOLUTION'             and DATA_FIELD = 'RESOLUTION' )
	        or (DETAIL_NAME = 'Contacts.DetailView'         and DATA_LABEL = 'Contacts.LBL_DESCRIPTION'         and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Emails.DetailView'           and DATA_LABEL = 'Emails.LBL_BODY'                  and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'EmailTemplates.DetailView'   and DATA_LABEL = 'EmailTemplates.LBL_DESCRIPTION'   and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Employees.DetailView'        and DATA_LABEL = 'Employees.LBL_NOTES'              and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Leads.DetailView'            and DATA_LABEL = 'Leads.LBL_DESCRIPTION'            and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Meetings.DetailView'         and DATA_LABEL = 'Meetings.LBL_DESCRIPTION'         and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Opportunities.DetailView'    and DATA_LABEL = 'Opportunities.LBL_DESCRIPTION'    and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Project.DetailView'          and DATA_LABEL = 'Project.LBL_DESCRIPTION'          and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'ProjectTask.DetailView'      and DATA_LABEL = 'ProjectTask.LBL_DESCRIPTION'      and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'ProspectLists.DetailView'    and DATA_LABEL = 'ProspectLists.LBL_DESCRIPTION'    and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Prospects.DetailView'        and DATA_LABEL = 'Prospects.LBL_DESCRIPTION'        and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Users.DetailView'            and DATA_LABEL = 'Users.LBL_NOTES'                  and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Tasks.DetailView'            and DATA_LABEL = 'Tasks.LBL_DESCRIPTION'            and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'TestPlans.DetailView'        and DATA_LABEL = 'TestPlans.LBL_DESCRIPTION'        and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'TestCases.DetailView'        and DATA_LABEL = 'TestCases.LBL_DESCRIPTION'        and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'TestCases.DetailView'        and DATA_LABEL = 'TestCases.LBL_EXPECTED_RESULTS'   and DATA_FIELD = 'EXPECTED_RESULTS')
	        or (DETAIL_NAME = 'ACLRoles.DetailView'         and DATA_LABEL = 'ACLRoles.LBL_DESCRIPTION'         and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Contracts.DetailView'        and DATA_LABEL = 'Contracts.LBL_DESCRIPTION'        and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'ProductTemplates.DetailView' and DATA_LABEL = 'ProductTemplates.LBL_DESCRIPTION' and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Quotes.DetailView'           and DATA_LABEL = 'Quotes.LBL_DESCRIPTION'           and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Teams.DetailView'            and DATA_LABEL = 'Teams.LBL_DESCRIPTION'            and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Orders.DetailView'           and DATA_LABEL = 'Orders.LBL_DESCRIPTION'           and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Invoices.DetailView'         and DATA_LABEL = 'Invoices.LBL_DESCRIPTION'         and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'Payments.DetailView'         and DATA_LABEL = 'Payments.LBL_DESCRIPTION'         and DATA_FIELD = 'DESCRIPTION')
	        or (DETAIL_NAME = 'TeamNotices.DetailView'      and DATA_LABEL = 'TeamNotices.LBL_DESCRIPTION'      and DATA_FIELD = 'DESCRIPTION')
	       );
end -- if;
GO

-- 07/15/2007 Paul.  Add forums/threaded discussions.
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Forums.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Forums.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Forums.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Forums.DetailView', 'Forums', 'vwFORUMS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView'   ,  0, 'Forums.LBL_TITLE'                  , 'TITLE'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView'   ,  1, 'Forums.LBL_CATEGORY'               , 'CATEGORY'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView'   ,  2, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Forums.DetailView'   ,  3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView'   ,  4, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Forums.DetailView'   ,  5, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Forums.DetailView'   ,  6, 'TextBox', 'Forums.LBL_DESCRIPTION' , 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- 02/09/2008 Paul.  Add credit card management. 
-- 12/16/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
-- 09/02/2008 Paul.  Credit card expiration should be just month and year. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'CreditCards.DetailView' and DELETED = 0) begin -- then 
	print 'DETAILVIEWS_FIELDS CreditCards.DetailView'; 
	exec dbo.spDETAILVIEWS_InsertOnly 'CreditCards.DetailView', 'CreditCards', 'vwCREDIT_CARDS_Edit', '15%', '35%', null; 
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  0, 'CreditCards.LBL_NAME'                          , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  1, 'CreditCards.LBL_CARD_TYPE'                     , 'CARD_TYPE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  2, 'CreditCards.LBL_CARD_NUMBER'                   , 'CARD_NUMBER_DISPLAY'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  3, 'CreditCards.LBL_EXPIRATION_DATE'               , 'EXPIRATION_MONTH EXPIRATION_YEAR'  , '{0}/{1}'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  4, 'CreditCards.LBL_IS_PRIMARY'                    , 'IS_PRIMARY'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  5, 'CreditCards.LBL_ADDRESS_STREET'                , 'ADDRESS_STREET'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  6, 'CreditCards.LBL_ADDRESS_CITY'                  , 'ADDRESS_CITY'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  7, 'CreditCards.LBL_ADDRESS_STATE'                 , 'ADDRESS_STATE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  8, 'CreditCards.LBL_ADDRESS_POSTALCODE'            , 'ADDRESS_POSTALCODE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' ,  9, 'CreditCards.LBL_ADDRESS_COUNTRY'               , 'ADDRESS_COUNTRY'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' , 10, 'CreditCards.LBL_EMAIL'                         , 'EMAIL'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' , 11, 'CreditCards.LBL_PHONE'                         , 'PHONE'                             , '{0}'        , null;
end else begin
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'CreditCards.DetailView' and DATA_FIELD = 'EXPIRATION_DATE' and DELETED = 0) begin -- then
		print 'DETAILVIEWS_FIELDS CreditCards.DetailView: Credit card expiration should be just month and year. ';
		update DETAILVIEWS_FIELDS
		   set DATA_FIELD       = 'EXPIRATION_MONTH EXPIRATION_YEAR'
		     , DATA_FORMAT      = '{0}/{1}'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where DETAIL_NAME      = 'CreditCards.DetailView'
		   and DATA_FIELD       = 'EXPIRATION_DATE'
		   and DELETED          = 0;
	end -- if;
	-- 12/16/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' , 10, 'CreditCards.LBL_EMAIL'                         , 'EMAIL'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'CreditCards.DetailView' , 11, 'CreditCards.LBL_PHONE'                         , 'PHONE'                             , '{0}'        , null;
end -- if;
GO

-- 10/18/2009 Paul.  Add Knowledge Base module. 
-- 05/14/2016 Paul.  Add Tags module. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'KBDocuments.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'KBDocuments.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS KBDocuments.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'KBDocuments.DetailView', 'KBDocuments'     , 'vwKBDOCUMENTS_Edit'     , '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView',  0, 'KBDocuments.LBL_NAME'             , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView',  1, 'KBDocuments.LBL_REVISION'         , 'REVISION'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'KBDocuments.DetailView',  4, 'KBDocuments.LBL_STATUS'           , 'STATUS'                           , '{0}'        , 'kbdocument_status_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView',  5, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView',  8, 'KBDocuments.LBL_ACTIVE_DATE'      , 'ACTIVE_DATE'                      , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView',  9, 'KBDocuments.LBL_EXP_DATE'         , 'EXP_DATE'                         , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsTags      'KBDocuments.DetailView', 10, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'KBDocuments.DetailView', 11, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'KBDocuments.DetailView', 12, 'TextBox', 'KBDocuments.LBL_DESCRIPTION', 'DESCRIPTION', '10,90', null, null, null, null, 3, null;
end else begin
	-- 05/14/2016 Paul.  Add Tags module. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'KBDocuments.DetailView' and DATA_FIELD = 'TAG_SET_NAME' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where DETAIL_NAME       = 'KBDocuments.DetailView'
		   and FIELD_INDEX      >= 10
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsTags       'KBDocuments.DetailView', 10, null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'KBDocuments.DetailView', 11, null;
	end -- if;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'KBTags.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'KBTags.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS KBTags.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'KBTags.DetailView'     , 'KBTags', 'vwKBTAGS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBTags.DetailView'     ,  0, 'KBTags.LBL_TAG_NAME'              , 'TAG_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'KBTags.DetailView'     ,  1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBTags.DetailView'     ,  2, 'KBTags.LBL_FULL_TAG_NAME'         , 'FULL_TAG_NAME'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'KBTags.DetailView'     ,  3, null;
end -- if;
GO

-- 09/04/2010 Paul.  Create full editing for ProductCategories. 
-- 09/26/2010 Paul.  Change default layout to use two columns. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductCategories.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductCategories.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ProductCategories.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'ProductCategories.DetailView', 'ProductCategories', 'vwPRODUCT_CATEGORIES', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductCategories.DetailView',  0, 'ProductCategories.LBL_NAME'           , 'NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductCategories.DetailView',  1, 'ProductCategories.LBL_ORDER'          , 'LIST_ORDER'            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'ProductCategories.DetailView',  2, 'ProductCategories.LBL_PARENT'         , 'PARENT_NAME'           , '{0}'        , 'PARENT_ID'          , '~/Administration/ProductCategories/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'ProductCategories.DetailView',  3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductCategories.DetailView',  4, 'ProductCategories.LBL_DESCRIPTION'    , 'DESCRIPTION'           , '{0}'        , 3;
end -- if;
GO

-- 09/04/2010 Paul.  Create full editing for ProductTypes. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTypes.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProductTypes.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ProductTypes.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'ProductTypes.DetailView', 'ProductTypes', 'vwPRODUCT_TYPES', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTypes.DetailView',  0, 'ProductTypes.LBL_NAME'           , 'NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTypes.DetailView',  1, 'ProductTypes.LBL_ORDER'          , 'LIST_ORDER'            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ProductTypes.DetailView',  2, 'ProductTypes.LBL_DESCRIPTION'    , 'DESCRIPTION'           , '{0}'        , 3;
end -- if;
GO

-- 07/20/2010 Paul.  Regions. 
-- 09/16/2010 Paul.  Move Regions to Professional file. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Regions.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Regions.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Regions.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Regions.DetailView'  , 'Regions', 'vwREGIONS', '15%', '85%', 1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Regions.DetailView'  ,  0, 'Regions.LBL_NAME'                  , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Regions.DetailView'  ,  1, 'TextBox', 'Regions.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- 09/16/2010 Paul.  Add support for multiple Payment Gateways.
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PaymentGateway.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PaymentGateway.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS PaymentGateway.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'PaymentGateway.DetailView', 'PaymentGateway', 'vwPAYMENT_GATEWAYS', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentGateway.DetailView',  0, 'PaymentGateway.LBL_NAME'                  , 'NAME'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentGateway.DetailView',  1, 'PaymentGateway.LBL_GATEWAY'               , 'GATEWAY'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentGateway.DetailView',  2, 'PaymentGateway.LBL_LOGIN'                 , 'LOGIN'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentGateway.DetailView',  3, 'PaymentGateway.LBL_TEST_MODE'             , 'TEST_MODE'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'PaymentGateway.DetailView',  4, 'TextBox', 'PaymentGateway.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- 03/25/2011 Paul.  Add support for Google Apps. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Users.GoogleAppsOptions';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Users.GoogleAppsOptions' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Users.GoogleAppsOptions';
	exec dbo.spDETAILVIEWS_InsertOnly          'Users.GoogleAppsOptions'  , 'Users', 'vwUSERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Users.GoogleAppsOptions'  ,  0, 'Users.LBL_GOOGLEAPPS_SYNC_CONTACTS'       , 'GOOGLEAPPS_SYNC_CONTACTS'   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Users.GoogleAppsOptions'  ,  1, 'Users.LBL_GOOGLEAPPS_SYNC_CALENDAR'       , 'GOOGLEAPPS_SYNC_CALENDAR'   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Users.GoogleAppsOptions'  ,  2, 'Users.LBL_GOOGLEAPPS_USERNAME'            , 'GOOGLEAPPS_USERNAME'        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Users.GoogleAppsOptions'  ,  3, null;
end -- if;
GO

-- 12/13/2011 Paul.  Add support for Apple iCloud. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Users.iCloudOptions';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Users.iCloudOptions' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Users.iCloudOptions';
	exec dbo.spDETAILVIEWS_InsertOnly          'Users.iCloudOptions'  , 'Users', 'vwUSERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Users.iCloudOptions'  ,  0, 'Users.LBL_ICLOUD_SYNC_CONTACTS'       , 'ICLOUD_SYNC_CONTACTS'   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Users.iCloudOptions'  ,  1, 'Users.LBL_ICLOUD_SYNC_CALENDAR'       , 'ICLOUD_SYNC_CALENDAR'   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Users.iCloudOptions'  ,  2, 'Users.LBL_ICLOUD_USERNAME'            , 'ICLOUD_USERNAME'        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Users.iCloudOptions'  ,  3, null;
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for TaxRates. 
-- 02/24/2015 Paul.  Add state for lookup. 
-- 04/07/2016 Paul.  Tax rates per team. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TaxRates.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TaxRates.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS TaxRates.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'TaxRates.DetailView', 'TaxRates', 'vwTAX_RATES_Edit', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView',  0, 'TaxRates.LBL_NAME'                 , 'NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'TaxRates.DetailView',  1, 'TaxRates.LBL_STATUS'               , 'STATUS'               , '{0}'        , 'tax_rate_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView',  2, 'TaxRates.LBL_VALUE'                , 'VALUE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView',  3, 'TaxRates.LBL_ORDER'                , 'LIST_ORDER'           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView',  4, 'TaxRates.LBL_QUICKBOOKS_TAX_VENDOR', 'QUICKBOOKS_TAX_VENDOR', '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView',  5, 'TaxRates.LBL_ADDRESS_STATE'        , 'ADDRESS_STATE'        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView',  6, 'TaxRates.LBL_DESCRIPTION'          , 'DESCRIPTION'          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView',  7, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'            , '{0}'        , null;
end else begin
	-- 04/07/2016 Paul.  Tax rates per team. 
	exec dbo.spDETAILVIEWS_FIELDS_CnvBound     'TaxRates.DetailView',  5, 'TaxRates.LBL_ADDRESS_STATE'        , 'ADDRESS_STATE'        , '{0}'        , null;
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TaxRates.DetailView' and DATA_FIELD ='TEAM_NAME' and DELETED = 0) begin -- then
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TaxRates.DetailView',  7, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'            , '{0}'        , null;
		update DETAILVIEWS_FIELDS
		   set COLSPAN           = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where DETAIL_NAME       = 'TaxRates.DetailView'
		   and DATA_FIELD        = 'DESCRIPTION'
		   and COLSPAN           = 3
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for Manufacturers. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Manufacturers.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Manufacturers.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Manufacturers.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Manufacturers.DetailView', 'Manufacturers', 'vwMANUFACTURERS', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Manufacturers.DetailView',  0, 'Manufacturers.LBL_NAME'       , 'NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Manufacturers.DetailView',  1, 'Manufacturers.LBL_STATUS'     , 'STATUS'               , '{0}'        , 'manufacturer_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Manufacturers.DetailView',  2, 'Manufacturers.LBL_ORDER'      , 'LIST_ORDER'           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Manufacturers.DetailView',  3, null;
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for Discounts. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Shippers.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Shippers.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Shippers.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Shippers.DetailView', 'Shippers', 'vwSHIPPERS', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Shippers.DetailView'     ,  0, 'Shippers.LBL_NAME'            , 'NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Shippers.DetailView'     ,  1, 'Shippers.LBL_STATUS'          , 'STATUS'               , '{0}'        , 'shippers_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Shippers.DetailView'     ,  2, 'Shippers.LBL_ORDER'           , 'LIST_ORDER'           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Shippers.DetailView'     ,  3, null;
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for ContractTypes. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ContractTypes.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ContractTypes.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ContractTypes.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'ContractTypes.DetailView', 'ContractTypes', 'vwCONTRACT_TYPES', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ContractTypes.DetailView',  0, 'ContractTypes.LBL_NAME'       , 'NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'ContractTypes.DetailView',  1, 'ContractTypes.LBL_ORDER'      , 'LIST_ORDER'           , '{0}'        , null;
end -- if;
GO

-- 06/02/2012 Paul.  Create full editing for Discounts. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Discounts.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Discounts.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Discounts.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Discounts.DetailView', 'Discounts', 'vwDISCOUNTS', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Discounts.DetailView'    ,  0, 'Discounts.LBL_NAME'           , 'NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Discounts.DetailView'    ,  1, 'Discounts.LBL_PRICING_FORMULA', 'PRICING_FORMULA'      , '{0}'        , 'pricing_formula_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Discounts.DetailView'    ,  2, 'Discounts.LBL_PRICING_FACTOR' , 'PRICING_FACTOR'       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Discounts.DetailView'    ,  3, null;
end -- if;
GO

-- 11/12/2018 Paul.  Add custom styles field to allow any style change. 
-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'SurveyThemes.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'SurveyThemes.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS SurveyThemes.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'SurveyThemes.DetailView', 'SurveyThemes', 'vwSURVEY_THEMES_Edit', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' ,  0, 'SurveyThemes.LBL_NAME'                        , 'NAME'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' ,  1, 'SurveyThemes.LBL_SURVEY_FONT_FAMILY'          , 'SURVEY_FONT_FAMILY'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' ,  2, 'SurveyThemes.LBL_LOGO_BACKGROUND'             , 'LOGO_BACKGROUND'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' ,  3, 'SurveyThemes.LBL_SURVEY_BACKGROUND'           , 'SURVEY_BACKGROUND'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' ,  4, 'SurveyThemes.LBL_REQUIRED_TEXT_COLOR'         , 'REQUIRED_TEXT_COLOR'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'SurveyThemes.DetailView' ,  5, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' ,  6;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' ,  7, 'SurveyThemes.LBL_SURVEY_TITLE', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' ,  8, 'SurveyThemes.LBL_SURVEY_TITLE_TEXT_COLOR'     , 'SURVEY_TITLE_TEXT_COLOR'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' ,  9, 'SurveyThemes.LBL_SURVEY_TITLE_FONT_SIZE'      , 'SURVEY_TITLE_FONT_SIZE'      , '{0}', 'font_size_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 10, 'SurveyThemes.LBL_SURVEY_TITLE_FONT_STYLE'     , 'SURVEY_TITLE_FONT_STYLE'     , '{0}', 'font_style_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 11, 'SurveyThemes.LBL_SURVEY_TITLE_FONT_WEIGHT'    , 'SURVEY_TITLE_FONT_WEIGHT'    , '{0}', 'font_weight_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 12, 'SurveyThemes.LBL_SURVEY_TITLE_DECORATION'     , 'SURVEY_TITLE_DECORATION'     , '{0}', 'text_decoration_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 13, 'SurveyThemes.LBL_SURVEY_TITLE_BACKGROUND'     , 'SURVEY_TITLE_BACKGROUND'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 14;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' , 15, 'SurveyThemes.LBL_PAGE_TITLE', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 16, 'SurveyThemes.LBL_PAGE_TITLE_TEXT_COLOR'       , 'PAGE_TITLE_TEXT_COLOR'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 17, 'SurveyThemes.LBL_PAGE_TITLE_FONT_SIZE'        , 'PAGE_TITLE_FONT_SIZE'        , '{0}', 'font_size_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 18, 'SurveyThemes.LBL_PAGE_TITLE_FONT_STYLE'       , 'PAGE_TITLE_FONT_STYLE'       , '{0}', 'font_style_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 19, 'SurveyThemes.LBL_PAGE_TITLE_FONT_WEIGHT'      , 'PAGE_TITLE_FONT_WEIGHT'      , '{0}', 'font_weight_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 20, 'SurveyThemes.LBL_PAGE_TITLE_DECORATION'       , 'PAGE_TITLE_DECORATION'       , '{0}', 'text_decoration_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 21, 'SurveyThemes.LBL_PAGE_TITLE_BACKGROUND'       , 'PAGE_TITLE_BACKGROUND'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 22;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' , 23, 'SurveyThemes.LBL_PAGE_DESCRIPTION', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 24, 'SurveyThemes.LBL_PAGE_DESCRIPTION_TEXT_COLOR' , 'PAGE_DESCRIPTION_TEXT_COLOR' , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 25, 'SurveyThemes.LBL_PAGE_DESCRIPTION_FONT_SIZE'  , 'PAGE_DESCRIPTION_FONT_SIZE'  , '{0}', 'font_size_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 26, 'SurveyThemes.LBL_PAGE_DESCRIPTION_FONT_STYLE' , 'PAGE_DESCRIPTION_FONT_STYLE' , '{0}', 'font_style_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 27, 'SurveyThemes.LBL_PAGE_DESCRIPTION_FONT_WEIGHT', 'PAGE_DESCRIPTION_FONT_WEIGHT', '{0}', 'font_weight_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 28, 'SurveyThemes.LBL_PAGE_DESCRIPTION_DECORATION' , 'PAGE_DESCRIPTION_DECORATION' , '{0}', 'text_decoration_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 29, 'SurveyThemes.LBL_PAGE_DESCRIPTION_BACKGROUND' , 'PAGE_DESCRIPTION_BACKGROUND' , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 30;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' , 31, 'SurveyThemes.LBL_PAGE_BACKGROUND', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 32, 'SurveyThemes.LBL_PAGE_BACKGROUND_IMAGE'       , 'PAGE_BACKGROUND_IMAGE'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 33, 'SurveyThemes.LBL_PAGE_BACKGROUND_POSITION'    , 'PAGE_BACKGROUND_POSITION'    , '{0}', 'page_background_position', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 34, 'SurveyThemes.LBL_PAGE_BACKGROUND_REPEAT'      , 'PAGE_BACKGROUND_REPEAT'      , '{0}', 'page_background_repeat'  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 35, 'SurveyThemes.LBL_PAGE_BACKGROUND_SIZE'        , 'PAGE_BACKGROUND_SIZE'        , '{0}', 'page_background_size'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 36;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' , 37, 'SurveyThemes.LBL_QUESTION_HEADING', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 38, 'SurveyThemes.LBL_QUESTION_HEADING_TEXT_COLOR' , 'QUESTION_HEADING_TEXT_COLOR' , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 39, 'SurveyThemes.LBL_QUESTION_HEADING_FONT_SIZE'  , 'QUESTION_HEADING_FONT_SIZE'  , '{0}', 'font_size_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 40, 'SurveyThemes.LBL_QUESTION_HEADING_FONT_STYLE' , 'QUESTION_HEADING_FONT_STYLE' , '{0}', 'font_style_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 41, 'SurveyThemes.LBL_QUESTION_HEADING_FONT_WEIGHT', 'QUESTION_HEADING_FONT_WEIGHT', '{0}', 'font_weight_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 42, 'SurveyThemes.LBL_QUESTION_HEADING_DECORATION' , 'QUESTION_HEADING_DECORATION' , '{0}', 'text_decoration_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 43, 'SurveyThemes.LBL_QUESTION_HEADING_BACKGROUND' , 'QUESTION_HEADING_BACKGROUND' , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 44;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' , 45, 'SurveyThemes.LBL_QUESTION_CHOICE', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 46, 'SurveyThemes.LBL_QUESTION_CHOICE_TEXT_COLOR'  , 'QUESTION_CHOICE_TEXT_COLOR'  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 47, 'SurveyThemes.LBL_QUESTION_CHOICE_FONT_SIZE'   , 'QUESTION_CHOICE_FONT_SIZE'   , '{0}', 'font_size_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 48, 'SurveyThemes.LBL_QUESTION_CHOICE_FONT_STYLE'  , 'QUESTION_CHOICE_FONT_STYLE'  , '{0}', 'font_style_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 49, 'SurveyThemes.LBL_QUESTION_CHOICE_FONT_WEIGHT' , 'QUESTION_CHOICE_FONT_WEIGHT' , '{0}', 'font_weight_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 50, 'SurveyThemes.LBL_QUESTION_CHOICE_DECORATION'  , 'QUESTION_CHOICE_DECORATION'  , '{0}', 'text_decoration_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 51, 'SurveyThemes.LBL_QUESTION_CHOICE_BACKGROUND'  , 'QUESTION_CHOICE_BACKGROUND'  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 52;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' , 53, 'SurveyThemes.LBL_PROGRESS_BAR', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 54, 'SurveyThemes.LBL_PROGRESS_BAR_PAGE_WIDTH'     , 'PROGRESS_BAR_PAGE_WIDTH'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 55, 'SurveyThemes.LBL_PROGRESS_BAR_COLOR'          , 'PROGRESS_BAR_COLOR'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 56, 'SurveyThemes.LBL_PROGRESS_BAR_BORDER_COLOR'   , 'PROGRESS_BAR_BORDER_COLOR'   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 57, 'SurveyThemes.LBL_PROGRESS_BAR_BORDER_WIDTH'   , 'PROGRESS_BAR_BORDER_WIDTH'   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 58, 'SurveyThemes.LBL_PROGRESS_BAR_TEXT_COLOR'     , 'PROGRESS_BAR_TEXT_COLOR'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 59, 'SurveyThemes.LBL_PROGRESS_BAR_FONT_SIZE'      , 'PROGRESS_BAR_FONT_SIZE'      , '{0}', 'font_size_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 60, 'SurveyThemes.LBL_PROGRESS_BAR_FONT_STYLE'     , 'PROGRESS_BAR_FONT_STYLE'     , '{0}', 'font_style_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 61, 'SurveyThemes.LBL_PROGRESS_BAR_FONT_WEIGHT'    , 'PROGRESS_BAR_FONT_WEIGHT'    , '{0}', 'font_weight_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 62, 'SurveyThemes.LBL_PROGRESS_BAR_DECORATION'     , 'PROGRESS_BAR_DECORATION'     , '{0}', 'text_decoration_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 63, 'SurveyThemes.LBL_PROGRESS_BAR_BACKGROUND'     , 'PROGRESS_BAR_BACKGROUND'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 64;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' , 65, 'SurveyThemes.LBL_ERROR', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 66, 'SurveyThemes.LBL_ERROR_TEXT_COLOR'            , 'ERROR_TEXT_COLOR'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 67, 'SurveyThemes.LBL_ERROR_FONT_SIZE'             , 'ERROR_FONT_SIZE'             , '{0}', 'font_size_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 68, 'SurveyThemes.LBL_ERROR_FONT_STYLE'            , 'ERROR_FONT_STYLE'            , '{0}', 'font_style_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 69, 'SurveyThemes.LBL_ERROR_FONT_WEIGHT'           , 'ERROR_FONT_WEIGHT'           , '{0}', 'font_weight_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 70, 'SurveyThemes.LBL_ERROR_DECORATION'            , 'ERROR_DECORATION'            , '{0}', 'text_decoration_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 71, 'SurveyThemes.LBL_ERROR_BACKGROUND'            , 'ERROR_BACKGROUND'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 72;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' , 73, 'SurveyThemes.LBL_EXIT_LINK', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 74, 'SurveyThemes.LBL_EXIT_LINK_TEXT_COLOR'        , 'EXIT_LINK_TEXT_COLOR'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 75, 'SurveyThemes.LBL_EXIT_LINK_FONT_SIZE'         , 'EXIT_LINK_FONT_SIZE'         , '{0}', 'font_size_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 76, 'SurveyThemes.LBL_EXIT_LINK_FONT_STYLE'        , 'EXIT_LINK_FONT_STYLE'        , '{0}', 'font_style_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 77, 'SurveyThemes.LBL_EXIT_LINK_FONT_WEIGHT'       , 'EXIT_LINK_FONT_WEIGHT'       , '{0}', 'font_weight_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 78, 'SurveyThemes.LBL_EXIT_LINK_DECORATION'        , 'EXIT_LINK_DECORATION'        , '{0}', 'text_decoration_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 79, 'SurveyThemes.LBL_EXIT_LINK_BACKGROUND'        , 'EXIT_LINK_BACKGROUND'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 80;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 81, '.LBL_DATE_MODIFIED'                           , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 82, '.LBL_DATE_ENTERED'                            , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 83, 'SurveyThemes.LBL_DESCRIPTION'                 , 'DESCRIPTION'                 , '{0}', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 84;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 85, 'SurveyThemes.LBL_CUSTOM_STYLES'               , 'CUSTOM_STYLES'               , '{0}', 3;
end else begin
	-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'SurveyThemes.DetailView' and DATA_FIELD = 'PAGE_BACKGROUND_IMAGE' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 6
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'SurveyThemes.DetailView'
		   and FIELD_INDEX       >= 31
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'SurveyThemes.DetailView' , 31, 'SurveyThemes.LBL_PAGE_BACKGROUND', 3;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 32, 'SurveyThemes.LBL_PAGE_BACKGROUND_IMAGE'       , 'PAGE_BACKGROUND_IMAGE'       , '{0}', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 33, 'SurveyThemes.LBL_PAGE_BACKGROUND_POSITION'    , 'PAGE_BACKGROUND_POSITION'    , '{0}', 'page_background_position', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 34, 'SurveyThemes.LBL_PAGE_BACKGROUND_REPEAT'      , 'PAGE_BACKGROUND_REPEAT'      , '{0}', 'page_background_repeat'  , null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyThemes.DetailView' , 35, 'SurveyThemes.LBL_PAGE_BACKGROUND_SIZE'        , 'PAGE_BACKGROUND_SIZE'        , '{0}', 'page_background_size'    , null;
		exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 36;
	end -- if;
	-- 11/12/2018 Paul.  Add custom styles field to allow any style change. 
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'SurveyThemes.DetailView' , 84;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyThemes.DetailView' , 85, 'SurveyThemes.LBL_CUSTOM_STYLES'               , 'CUSTOM_STYLES'               , '{0}', 3;
end -- if;
GO

-- 05/22/2013 Paul.  Add Surveys module. 
-- 01/01/2016 Paul.  Catalin wants to force page navigation for each question, just like mobile navigation. 
-- 05/14/2016 Paul.  Add Tags module. 
-- 07/28/2018 Paul.  Add Kiosk mode fields. 
-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Surveys.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Surveys.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Surveys.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Surveys.DetailView'      , 'Surveys', 'vwSURVEYS_Edit', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      ,  0, 'Surveys.LBL_NAME'                    , 'NAME'                                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      ,  1, 'Surveys.LBL_SURVEY_THEME_NAME'       , 'SURVEY_THEME_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Surveys.DetailView'      ,  2, 'Surveys.LBL_STATUS'                  , 'STATUS'                                , '{0}'        , 'survey_status_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      ,  3, '.LBL_ASSIGNED_TO'                    , 'ASSIGNED_TO'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Surveys.DetailView'      ,  4, 'Surveys.LBL_PAGE_RANDOMIZATION'      , 'PAGE_RANDOMIZATION'                    , '{0}'        , 'survey_page_randomization', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      ,  5, 'Teams.LBL_TEAM'                      , 'TEAM_NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Surveys.DetailView'      ,  6, 'Surveys.LBL_SURVEY_STYLE'            , 'SURVEY_STYLE'                          , '{0}'        , 'survey_style_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsTags      'Surveys.DetailView'      ,  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      ,  8, '.LBL_DATE_MODIFIED'                  , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      ,  9, '.LBL_DATE_ENTERED'                   , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      , 10, 'Surveys.LBL_SURVEY_URL'              , 'SURVEY_URL'                            , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      , 11, 'Surveys.LBL_DESCRIPTION'             , 'DESCRIPTION'                           , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'Surveys.DetailView'      , 12;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'Surveys.DetailView'      , 13, 'Surveys.LBL_KIOSK_PROPERTIES'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Surveys.DetailView'      , 14, 'Surveys.LBL_LOOP_SURVEY'             , 'LOOP_SURVEY'                           , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Surveys.DetailView'      , 15, 'Surveys.LBL_SURVEY_TARGET_ASSIGNMENT', 'SURVEY_TARGET_ASSIGNMENT'              , '{0}'        , 'survey_target_assignment_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      , 16, 'Surveys.LBL_TIMEOUT'                 , 'TIMEOUT'                               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      , 17, 'Surveys.LBL_SURVEY_TARGET_MODULE'    , 'SURVEY_TARGET_MODULE'                  , '{0}'        , null;
end else begin
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Surveys.DetailView' and DATA_FIELD = 'SURVEY_URL' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Surveys.DetailView'
		   and DATA_FIELD        = 'DESCRIPTION'
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      ,  8, 'Surveys.LBL_SURVEY_URL'        , 'SURVEY_URL'                            , '{0}'        , 3;
	end -- if;
	-- 01/01/2016 Paul.  Catalin wants to force page navigation for each question, just like mobile navigation. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Surveys.DetailView' and DATA_FIELD = 'SURVEY_STYLE' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Surveys.DetailView'
		   and FIELD_INDEX      >= 6
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Surveys.DetailView'      ,  8, 'Surveys.LBL_SURVEY_STYLE'      , 'SURVEY_STYLE'                          , '{0}'        , 'survey_style_dom', null;
		exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Surveys.DetailView'      ,  9, null;
	end -- if;
	-- 05/14/2016 Paul.  Add Tags module. 
	exec dbo.spDETAILVIEWS_FIELDS_CnvTags   'Surveys.DetailView' , 7, null;
	-- 07/28/2018 Paul.  Add Kiosk mode fields. 
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'Surveys.DetailView'      , 12;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader    'Surveys.DetailView'      , 13, 'Surveys.LBL_KIOSK_PROPERTIES'    , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Surveys.DetailView'      , 14, 'Surveys.LBL_LOOP_SURVEY'         , 'LOOP_SURVEY'                           , null;
	--exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      , 15, 'Surveys.LBL_EXIT_CODE'           , 'EXIT_CODE'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Surveys.DetailView'      , 16, 'Surveys.LBL_TIMEOUT'             , 'TIMEOUT'                               , '{0}'        , null;
	-- 09/30/2018 Paul.  Add survey record creation to survey. 
	exec dbo.spDETAILVIEWS_FIELDS_CnvBound     'Surveys.DetailView'      , 17, 'Surveys.LBL_SURVEY_TARGET_MODULE', 'SURVEY_TARGET_MODULE'                  , '{0}'        , null;
	-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
	if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Surveys.DetailView' and DATA_FIELD = 'SURVEY_TARGET_ASSIGNMENT' and DELETED = 0) begin -- then
		update DETAILVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where DETAIL_NAME       = 'Surveys.DetailView'
		   and DATA_FIELD        = 'EXIT_CODE'
		   and DELETED           = 0;
		exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Surveys.DetailView'      , 15, 'Surveys.LBL_SURVEY_TARGET_ASSIGNMENT', 'SURVEY_TARGET_ASSIGNMENT'              , '{0}'        , 'survey_target_assignment_dom', null;
	end -- if;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'SurveyPages.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'SurveyPages.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS SurveyPages.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'SurveyPages.DetailView', 'SurveyPages', 'vwSURVEY_PAGES_Edit', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'SurveyPages.DetailView'  ,  0, 'SurveyPages.LBL_SURVEY_NAME'                  , 'SURVEY_NAME'                           , '{0}'        , 'SURVEY_ID', '~/Surveys/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyPages.DetailView'  ,  1, 'SurveyPages.LBL_PAGE_NUMBER'                  , 'PAGE_NUMBER'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyPages.DetailView'  ,  2, 'SurveyPages.LBL_NAME'                         , 'NAME'                                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'SurveyPages.DetailView'  ,  3, 'SurveyPages.LBL_QUESTION_RANDOMIZATION'       , 'QUESTION_RANDOMIZATION'                , '{0}'        , 'survey_question_randomization', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyPages.DetailView'  ,  4, '.LBL_DATE_MODIFIED'                           , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyPages.DetailView'  ,  5, '.LBL_DATE_ENTERED'                            , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'SurveyPages.DetailView'  ,  6, 'SurveyPages.LBL_DESCRIPTION'                  , 'DESCRIPTION'                           , '{0}'        , 3;
end -- if;
GO

-- 04/20/2016 Paul.  Add team management to Outbound Emails. 
-- 01/17/2017 Paul.  SENDTYPE can now be Office 365 or Gmail. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'OutboundEmail.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'OutboundEmail.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS OutboundEmail.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'OutboundEmail.DetailView', 'OutboundEmail', 'vwOUTBOUND_EMAILS_Edit', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OutboundEmail.DetailView',  0, 'OutboundEmail.LBL_NAME'                       , 'NAME'                                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OutboundEmail.DetailView',  1, 'Teams.LBL_TEAM'                               , 'TEAM_NAME'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OutboundEmail.DetailView',  2, 'OutboundEmail.LBL_MAIL_SMTPSERVER'            , 'MAIL_SMTPSERVER'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OutboundEmail.DetailView',  3, 'OutboundEmail.LBL_MAIL_SMTPPORT'              , 'MAIL_SMTPPORT'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'OutboundEmail.DetailView',  4, 'OutboundEmail.LBL_MAIL_SMTPAUTH_REQ'          , 'MAIL_SMTPAUTH_REQ'                     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'OutboundEmail.DetailView',  5, 'OutboundEmail.LBL_MAIL_SMTPSSL'               , 'MAIL_SMTPSSL'                          , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OutboundEmail.DetailView',  6, 'OutboundEmail.LBL_MAIL_SMTPUSER'              , 'MAIL_SMTPUSER'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OutboundEmail.DetailView',  7, 'OutboundEmail.LBL_MAIL_SENDTYPE'              , 'MAIL_SENDTYPE'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OutboundEmail.DetailView',  8, 'OutboundEmail.LBL_FROM_NAME'                  , 'FROM_NAME'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'OutboundEmail.DetailView',  9, 'OutboundEmail.LBL_FROM_ADDR'                  , 'FROM_ADDR'                             , '{0}', null;
end else begin
	-- 04/20/2016 Paul.  Add team management to Outbound Emails. 
	exec dbo.spDETAILVIEWS_FIELDS_CnvBound     'OutboundEmail.DetailView',  1, 'Teams.LBL_TEAM'                               , 'TEAM_NAME'                             , '{0}', null;
	-- 01/17/2017 Paul.  SENDTYPE can now be Office 365 or Gmail. 
	exec dbo.spDETAILVIEWS_FIELDS_CnvBound     'OutboundEmail.DetailView',  7, 'OutboundEmail.LBL_MAIL_SENDTYPE'              , 'MAIL_SENDTYPE'                         , '{0}', null;
end -- if;
GO

-- 09/10/2013 Paul.  Add layout for Asterisk. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Asterisk.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Asterisk.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Asterisk.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Asterisk.DetailView', 'Asterisk', 'vwCALL_DETAIL_RECORDS', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     ,  0, 'Asterisk.LBL_UNIQUEID'                        , 'UNIQUEID'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     ,  1, 'Asterisk.LBL_START_TIME'                      , 'START_TIME'                            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Asterisk.DetailView'     ,  2, 'Asterisk.LBL_PARENT_NAME'                     , 'PARENT_NAME'                           , '{0}', 'PARENT_ID', '~/Calls/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     ,  3, 'Asterisk.LBL_ANSWER_TIME'                     , 'ANSWER_TIME'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     ,  4, 'Asterisk.LBL_DURATION'                        , 'DURATION'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     ,  5, 'Asterisk.LBL_END_TIME'                        , 'END_TIME'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     ,  6, 'Asterisk.LBL_BILLABLE_SECONDS'                , 'BILLABLE_SECONDS'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Asterisk.DetailView'     ,  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     ,  8, 'Asterisk.LBL_CALLERID'                        , 'CALLERID'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     ,  9, 'Asterisk.LBL_DESTINATION'                     , 'DESTINATION'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     , 10, 'Asterisk.LBL_SOURCE'                          , 'SOURCE'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     , 11, 'Asterisk.LBL_DESTINATION_CONTEXT'             , 'DESTINATION_CONTEXT'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     , 12, 'Asterisk.LBL_SOURCE_CHANNEL'                  , 'SOURCE_CHANNEL'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     , 13, 'Asterisk.LBL_DESTINATION_CHANNEL'             , 'DESTINATION_CHANNEL'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     , 14, 'Asterisk.LBL_DISPOSITION'                     , 'DISPOSITION'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     , 15, 'Asterisk.LBL_AMA_FLAGS'                       , 'AMA_FLAGS'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     , 16, 'Asterisk.LBL_LAST_APPLICATION'                , 'LAST_APPLICATION'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     , 17, 'Asterisk.LBL_USER_FIELD'                      , 'USER_FIELD'                            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Asterisk.DetailView'     , 18, 'Asterisk.LBL_LAST_DATA'                       , 'LAST_DATA'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Asterisk.DetailView'     , 19, null;
end -- if;
GO

-- 09/19/2013 Paul.  Add PayTrace module. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PayTrace.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PayTrace.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS PayTrace.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly 'PayTrace.DetailView', 'PayTrace', 'vwPayTrace_Edit', '15%', '35%', 2;

	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     ,  0, 'PayTrace.LBL_TRANXID'                         , 'TRANXID'                               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     ,  1, 'PayTrace.LBL_CC'                              , 'CC'                                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     ,  2, 'PayTrace.LBL_TRANXTYPE'                       , 'TRANXTYPE'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     ,  3, 'PayTrace.LBL_EXPIRATION_DATE'                 , 'EXPMNTH EXPYR'                         , '{0}/{1}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     ,  4, 'PayTrace.LBL_AMOUNT'                          , 'AMOUNT'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     ,  5, 'PayTrace.LBL_TAX'                             , 'TAX'                                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'PayTrace.DetailView'     ,  6;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     ,  7, 'PayTrace.LBL_WHEN'                            , 'WHEN'                                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     ,  8, 'PayTrace.LBL_SETTLED'                         , 'SETTLED'                               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     ,  9, 'PayTrace.LBL_STATUS'                          , 'STATUS'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 10, 'PayTrace.LBL_STATUSDESCRIPTION'               , 'STATUSDESCRIPTION'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 11, 'PayTrace.LBL_USER'                            , 'USER'                                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 12, 'PayTrace.LBL_IP'                              , 'IP'                                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 13, 'PayTrace.LBL_APPROVAL'                        , 'APPROVAL'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 14, 'PayTrace.LBL_APPMSG'                          , 'APPMSG'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 15, 'PayTrace.LBL_AVSRESPONSE'                     , 'AVSRESPONSE'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 16, 'PayTrace.LBL_CSCRESPONSE'                     , 'CSCRESPONSE'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'PayTrace.DetailView'     , 17;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 18, 'PayTrace.LBL_INVOICE'                         , 'INVOICE'                               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 19, 'PayTrace.LBL_METHOD'                          , 'METHOD'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 20, 'PayTrace.LBL_CUSTREF'                         , 'CUSTREF'                               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'PayTrace.DetailView'     , 21, 'PayTrace.LBL_CUSTID'                          , 'CUSTID'                                , '{0}', 'CREDIT_CARD_ID', '~/CreditCards/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 22, 'PayTrace.LBL_DESCRIPTION'                     , 'DESCRIPTION'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 23, 'PayTrace.LBL_EMAIL'                           , 'EMAIL'                                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'PayTrace.DetailView'     , 24;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 25, 'PayTrace.LBL_BNAME'                           , 'BNAME'                                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 26, 'PayTrace.LBL_BADDRESS'                        , 'BADDRESS BADDRESS2'                    , '{0}<br/>{1}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 27, 'PayTrace.LBL_BCITY'                           , 'BCITY'                                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 28, 'PayTrace.LBL_BSTATE'                          , 'BSTATE'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 29, 'PayTrace.LBL_BZIP'                            , 'BZIP'                                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 30, 'PayTrace.LBL_BCOUNTRY'                        , 'BCOUNTRY'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'PayTrace.DetailView'     , 31;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 32, 'PayTrace.LBL_SNAME'                           , 'SNAME'                                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 33, 'PayTrace.LBL_SADDRESS'                        , 'SADDRESS SADDRESS2'                    , '{0}<br/>{1}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 34, 'PayTrace.LBL_SCITY'                           , 'SCITY'                                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 35, 'PayTrace.LBL_SSTATE'                          , 'SSTATE'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 36, 'PayTrace.LBL_SZIP'                            , 'SZIP'                                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 37, 'PayTrace.LBL_SCOUNTRY'                        , 'SCOUNTRY'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayTrace.DetailView'     , 38, 'PayTrace.LBL_SCOUNTY'                         , 'SCOUNTY'                               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PayTrace.DetailView'     , 39, null;
end -- if;
GO

-- 10/26/2013 Paul.  Add TwitterTracks module.
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TwitterTracks.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'TwitterTracks.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS TwitterTracks.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'TwitterTracks.DetailView', 'TwitterTracks', 'vwTWITTER_TRACKS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView',  0, 'TwitterTracks.LBL_NAME'                       , 'NAME'                                  , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'TwitterTracks.DetailView',  1, 'TwitterTracks.LBL_TYPE'                       , 'TYPE'                                  , '{0}'        , 'twitter_track_type_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'TwitterTracks.DetailView',  2, 'TwitterTracks.LBL_STATUS'                     , 'STATUS'                                , '{0}'        , 'twitter_track_status_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView',  3, 'Teams.LBL_TEAM'                               , 'TEAM_NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView',  4, '.LBL_DATE_MODIFIED'                           , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView',  5, '.LBL_ASSIGNED_TO'                             , 'ASSIGNED_TO_NAME'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView',  6, '.LBL_DATE_ENTERED'                            , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView',  7, 'TwitterTracks.LBL_LOCATION'                   , 'LOCATION'                              , '{0}'        , null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'TwitterTracks.DetailView',  8, 'TwitterTracks.LBL_TWITTER_SCREEN_NAME'        , 'TWITTER_SCREEN_NAME'                   , '{0}'        , null;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PaymentTypes.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PaymentTypes.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS PaymentTypes.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'PaymentTypes.DetailView', 'PaymentTypes', 'vwPAYMENT_TYPES', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentTypes.DetailView'     ,  0, 'PaymentTypes.LBL_NAME'            , 'NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'PaymentTypes.DetailView'     ,  1, 'PaymentTypes.LBL_STATUS'          , 'STATUS'               , '{0}'        , 'payment_type_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentTypes.DetailView'     ,  2, 'PaymentTypes.LBL_ORDER'           , 'LIST_ORDER'           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PaymentTypes.DetailView'     ,  3, null;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PaymentTerms.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PaymentTerms.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS PaymentTerms.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'PaymentTerms.DetailView', 'PaymentTerms', 'vwPAYMENT_TYPES', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentTerms.DetailView'     ,  0, 'PaymentTerms.LBL_NAME'            , 'NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'PaymentTerms.DetailView'     ,  1, 'PaymentTerms.LBL_STATUS'          , 'STATUS'               , '{0}'        , 'payment_term_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PaymentTerms.DetailView'     ,  2, 'PaymentTerms.LBL_ORDER'           , 'LIST_ORDER'           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PaymentTerms.DetailView'     ,  3, null;
end -- if;
GO

-- 12/18/2015 Paul.  Add AuthorizeNet module. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'AuthorizeNet.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'AuthorizeNet.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS AuthorizeNet.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly 'AuthorizeNet.DetailView', 'AuthorizeNet', 'vwAuthorizeNet_Transactions', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     ,  0, 'AuthorizeNet.LBL_TRANS_ID'                    , 'transId'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'AuthorizeNet.DetailView'     ,  1, 'AuthorizeNet.LBL_REFTRANS_ID'                 , 'refTransId'               , '{0}', 'refTransId', 'view.aspx?transId={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     ,  2, 'AuthorizeNet.LBL_SUBMIT_TIME_UTC'             , 'submitTimeUTC'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     ,  3, 'AuthorizeNet.LBL_SUBMIT_TIME_LOCAL'           , 'submitTimeLocal'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     ,  4, 'AuthorizeNet.LBL_TRANSACTION_TYPE'            , 'transactionType'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     ,  5, 'AuthorizeNet.LBL_TRANSACTION_STATUS'          , 'transactionStatus'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     ,  6, 'AuthorizeNet.LBL_RESPONSE_CODE'               , 'responseCode'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     ,  7, 'AuthorizeNet.LBL_RESPONSE_REASON_CODE'        , 'responseReasonCode'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     ,  8, 'AuthorizeNet.LBL_RESPONSE_REASON_DESCRIPTION' , 'responseReasonDescription', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     ,  9, 'AuthorizeNet.LBL_AUTH_CODE'                   , 'authCode'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 10, 'AuthorizeNet.LBL_AVS_RESPONSE'                , 'AVSResponse'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 11, 'AuthorizeNet.LBL_BATCH_ID'                    , 'batchId'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 12, 'AuthorizeNet.LBL_SETTLEMENT_TIME_UTC'         , 'settlementTimeUTC'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 13, 'AuthorizeNet.LBL_SETTLEMENT_TIME_LOCAL'       , 'settlementTimeLocal'      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 14, 'AuthorizeNet.LBL_SETTLEMENT_STATE'            , 'settlementState'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 15, 'AuthorizeNet.LBL_AUTH_AMOUNT'                 , 'authAmount'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 16, 'AuthorizeNet.LBL_SETTLE_AMOUNT'               , 'settleAmount'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 17, 'AuthorizeNet.LBL_TAX_EXEMPT'                  , 'taxExempt'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 18, 'AuthorizeNet.LBL_RECURRING_BILLING'           , 'recurringBilling'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 19, 'AuthorizeNet.LBL_PRODUCT'                     , 'product'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 20, 'AuthorizeNet.LBL_MARKET_TYPE'                 , 'marketType'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'AuthorizeNet.DetailView'     , 21, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'AuthorizeNet.DetailView'     , 22;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'AuthorizeNet.DetailView'     , 23, 'AuthorizeNet.LBL_CUSTOMER_ID'                 , 'customer_id'              , '{0}', 'customer_id', 'CustomerProfiles\view.aspx?customerProfileId={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 24, 'AuthorizeNet.LBL_CUSTOMER_EMAIL'              , 'customer_email'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 25, 'AuthorizeNet.LBL_BILLTO_FIRST_NAME'           , 'billTo_firstName'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 26, 'AuthorizeNet.LBL_BILLTO_LAST_NAME'            , 'billTo_lastName'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 27, 'AuthorizeNet.LBL_BILLTO_ADDRESS'              , 'billTo_address'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 28, 'AuthorizeNet.LBL_BILLTO_CITY'                 , 'billTo_city'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 29, 'AuthorizeNet.LBL_BILLTO_STATE'                , 'billTo_state'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 30, 'AuthorizeNet.LBL_BILLTO_ZIP'                  , 'billTo_zip'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 31, 'AuthorizeNet.LBL_BILLTO_COUNTRY'              , 'billTo_country'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 32, 'AuthorizeNet.LBL_CUSTOMER_TYPE'               , 'customer_type'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator 'AuthorizeNet.DetailView'     , 33;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 34, 'AuthorizeNet.LBL_TOKEN_TOKEN_SOURCE'          , 'token_tokenSource'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 35, 'AuthorizeNet.LBL_CREDITCARD_CARD_TYPE'        , 'creditCard_cardType'      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 36, 'AuthorizeNet.LBL_TOKEN_TOKEN_NUMBER'          , 'token_tokenNumber'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 37, 'AuthorizeNet.LBL_CREDITCARD_CARD_NUMBER'      , 'creditCard_cardNumber'    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 38, 'AuthorizeNet.LBL_TOKEN_EXPIRATION_DATE'       , 'token_expirationDate'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 39, 'AuthorizeNet.LBL_CREDITCARD_EXPIRATION_DATE'  , 'creditCard_expirationDate', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 40, 'AuthorizeNet.LBL_BANKACCOUNT_NAME_ON_ACCOUNT' , 'bankAccount_nameOnAccount', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 41, 'AuthorizeNet.LBL_BANKACCOUNT_BANK_NAME'       , 'bankAccount_bankName'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 42, 'AuthorizeNet.LBL_BANKACCOUNT_ROUTING_NUMBER'  , 'bankAccount_routingNumber', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 43, 'AuthorizeNet.LBL_BANKACCOUNT_ACCOUNT_TYPE'    , 'bankAccount_accountType'  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 44, 'AuthorizeNet.LBL_BANKACCOUNT_ACCOUNT_NUMBER'  , 'bankAccount_accountNumber', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.DetailView'     , 45, 'AuthorizeNet.LBL_BANKACCOUNT_ECHECK_TYPE'     , 'bankAccount_echeckType'   , '{0}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'AuthorizeNet.CustomerProfiles..DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'AuthorizeNet.CustomerProfiles.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS AuthorizeNet.CustomerProfiles.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly 'AuthorizeNet.CustomerProfiles.DetailView', 'AuthorizeNet', 'vwAuthorizeNet_CustomerProfiles', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.CustomerProfiles.DetailView',  0, 'AuthorizeNet.LBL_CUSTOMER_PROFILE_ID' , 'customerProfileId'    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.CustomerProfiles.DetailView',  1, 'AuthorizeNet.LBL_MERCHANT_CUSTOMER_ID', 'merchantCustomerId'   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.CustomerProfiles.DetailView',  2, 'AuthorizeNet.LBL_EMAIL'               , 'email'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'AuthorizeNet.CustomerProfiles.DetailView',  3, 'AuthorizeNet.LBL_DESCRIPTION'         , 'description'          , '{0}', null;
end -- if;
GO

-- 01/01/2016 Paul.  Move PayPal module to Professional. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PayPal.DetailView'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PayPal.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS PayPal.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly 'PayPal.DetailView', 'PayPal', 'vwPayPal_Edit', '15%', '35%', 2;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  0, 'PayPal.LBL_TRANSACTION_ID'                , 'TRANSACTION_ID'                                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  1, 'PayPal.LBL_PARENT_TRANSACTION_ID'         , 'PARENT_TRANSACTION_ID'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  2, 'PayPal.LBL_TRANSACTION_TYPE'              , 'TRANSACTION_TYPE'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  3, 'PayPal.LBL_RECEIPT_ID'                    , 'RECEIPT_ID'                                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  4, 'PayPal.LBL_PAYMENT_TYPE'                  , 'PAYMENT_TYPE'                                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  5, 'PayPal.LBL_PAYMENT_DATE'                  , 'PAYMENT_DATE'                                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  6, 'PayPal.LBL_GROSS_AMOUNT'                  , 'GROSS_AMOUNT_CURRENCY GROSS_AMOUNT'            , '{0} {1}'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  7, 'PayPal.LBL_FEE_AMOUNT'                    , 'FEE_AMOUNT_CURRENCY FEE_AMOUNT'                , '{0} {1}'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  8, 'PayPal.LBL_SETTLE_AMOUNT'                 , 'SETTLE_AMOUNT_CURRENCY SETTLE_AMOUNT'          , '{0} {1}'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView',  9, 'PayPal.LBL_TAX_AMOUNT'                    , 'TAX_AMOUNT_CURRENCY TAX_AMOUNT'                , '{0} {1}'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 10, 'PayPal.LBL_EXCHANGE_RATE'                 , 'EXCHANGE_RATE'                                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 11, 'PayPal.LBL_SALES_TAX'                     , 'SALES_TAX'                                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 12, 'PayPal.LBL_PAYMENT_STATUS'                , 'PAYMENT_STATUS'                                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 13, 'PayPal.LBL_REASON_CODE'                   , 'REASON_CODE'                                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 14, 'PayPal.LBL_PENDING_REASON'                , 'PENDING_REASON'                                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 15, 'PayPal.LBL_INVOICE_ID'                    , 'INVOICE_ID'                                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 16, 'PayPal.LBL_MEMO'                          , 'MEMO'                                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 17, 'PayPal.LBL_CUSTOM'                        , 'CUSTOM'                                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 18, 'PayPal.LBL_AUCTION_BUYER_ID'              , 'AUCTION_BUYER_ID'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 19, 'PayPal.LBL_AUCTION_CLOSING_DATE'          , 'AUCTION_CLOSING_DATE'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 20, 'PayPal.LBL_AUCTION_MULTI_ITEM'            , 'AUCTION_MULTI_ITEM'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PayPal.DetailView', 21, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PayPal.DetailView', 22, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PayPal.DetailView', 23, null;

	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 24, 'PayPal.LBL_PAYER'                         , 'PAYER'                                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 25, 'PayPal.LBL_PAYER_ID'                      , 'PAYER_ID'                                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 26, 'PayPal.LBL_PAYER_STATUS'                  , 'PAYER_STATUS'                                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 27, 'PayPal.LBL_PAYER_SALUATION'               , 'PAYER_SALUATION'                               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 28, 'PayPal.LBL_PAYER_FIRST_NAME'              , 'PAYER_FIRST_NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 29, 'PayPal.LBL_PAYER_LAST_NAME'               , 'PAYER_LAST_NAME'                               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 30, 'PayPal.LBL_PAYER_MIDDLE_NAME'             , 'PAYER_MIDDLE_NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 31, 'PayPal.LBL_PAYER_SUFFIX'                  , 'PAYER_SUFFIX'                                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 33, 'PayPal.LBL_PAYER_BUSINESS'                , 'PAYER_BUSINESS'                                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 32, 'PayPal.LBL_PAYER_PHONE'                   , 'PAYER_PHONE'                                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 35, 'PayPal.LBL_PAYER_ADDRESS_OWNER'           , 'PAYER_ADDRESS_OWNER'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 36, 'PayPal.LBL_PAYER_ADDRESS_STATUS'          , 'PAYER_ADDRESS_STATUS'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 37, 'PayPal.LBL_PAYER_ADDRESS_NAME'            , 'PAYER_ADDRESS_NAME'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PayPal.DetailView', 38, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 39, 'PayPal.LBL_PAYER_ADDRESS_STREET1'         , 'PAYER_ADDRESS_STREET1'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 40, 'PayPal.LBL_PAYER_ADDRESS_STREET2'         , 'PAYER_ADDRESS_STREET2'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 41, 'PayPal.LBL_PAYER_ADDRESS_CITY'            , 'PAYER_ADDRESS_CITY'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 42, 'PayPal.LBL_PAYER_ADDRESS_STATE'           , 'PAYER_ADDRESS_STATE'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 43, 'PayPal.LBL_PAYER_ADDRESS_COUNTRY'         , 'PAYER_ADDRESS_COUNTRY'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 44, 'PayPal.LBL_PAYER_ADDRESS_COUNTRY_NAME'    , 'PAYER_ADDRESS_COUNTRY_NAME'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 45, 'PayPal.LBL_PAYER_ADDRESS_POSTAL_CODE'     , 'PAYER_ADDRESS_POSTAL_CODE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 46, 'PayPal.LBL_PAYER_ADDRESS_PHONE'           , 'PAYER_ADDRESS_PHONE'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PayPal.DetailView', 47, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PayPal.DetailView', 48, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 49, 'PayPal.LBL_PAYER_ADDRESS_INTL_NAME'       , 'PAYER_ADDRESS_INTL_NAME'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 50, 'PayPal.LBL_PAYER_ADDRESS_INTL_STATE'      , 'PAYER_ADDRESS_INTL_STATE'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'PayPal.DetailView', 51, 'PayPal.LBL_PAYER_ADDRESS_INTL_STREET'     , 'PAYER_ADDRESS_INTL_STREET'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'PayPal.DetailView', 52, null;
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

call dbo.spDETAILVIEWS_FIELDS_Professional()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_Professional')
/

-- #endif IBM_DB2 */




print 'SHORTCUTS Professional';
-- delete SHORTCUTS
GO

set nocount on;
GO

-- 12/23/2007 Paul.  Use a separate IF for each module. 
-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 09/08/2008 Paul.  Must use a comment block to allow Oracle migration to work properly. 
/*

if not exists (select * from SHORTCUTS where MODULE_NAME = 'Roles' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Roles'                 , 'Roles.LNK_NEW_ROLE'                    , '~/Administration/Roles/edit.aspx'       , 'CreateRoles.gif'         , 1,  1, 'Roles', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Roles'                 , 'Roles.LNK_ROLES'                       , '~/Administration/Roles/default.aspx'    , 'Roles.gif'               , 1,  2, 'Roles', 'list';
end -- if;

*/
-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.


-- 03/03/2008 Paul.  Allow import into ProductTemplates. 
-- 06/02/2012 Paul.  Add Create links. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'ProductTemplates' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'ProductTemplates.LNK_NEW_PRODUCT_TEMPLATE'    , '~/Administration/ProductTemplates/edit.aspx'            , 'CreateProducts.gif'   , 1,  1, 'ProductTemplates'  , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'ProductTemplates.LNK_PRODUCT_TEMPLATE_LIST'   , '~/Administration/ProductTemplates/default.aspx'         , 'ProductTemplates.gif' , 1,  2, 'ProductTemplates'  , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'Manufacturers.LNK_NEW_MANUFACTURER'           , '~/Administration/Manufacturers/edit.aspx'               , 'Manufacturers.gif'    , 1,  3, 'Manufacturers'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'Manufacturers.LNK_MANUFACTURER_LIST'          , '~/Administration/Manufacturers/default.aspx'            , 'Manufacturers.gif'    , 1,  4, 'Manufacturers'     , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'ProductCategories.LNK_NEW_PRODUCT_CATEGORY'   , '~/Administration/ProductCategories/edit.aspx'           , 'ProductCategories.gif', 1,  5, 'ProductCategories' , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'ProductCategories.LNK_PRODUCT_CATEGORIES_LIST', '~/Administration/ProductCategories/default.aspx'        , 'ProductCategories.gif', 1,  6, 'ProductCategories' , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'ProductTypes.LNK_NEW_PRODUCT_TYPE'            , '~/Administration/ProductTypes/edit.aspx'                , 'ProductTypes.gif'     , 1,  7, 'ProductTypes'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'ProductTypes.LNK_PRODUCT_TYPE_LIST'           , '~/Administration/ProductTypes/default.aspx'             , 'ProductTypes.gif'     , 1,  8, 'ProductTypes'      , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , '.LBL_IMPORT'                                  , '~/Administration/ProductTemplates/import.aspx'          , 'Import.gif'           , 1,  9, 'ProductTemplates'  , 'import';
end else begin
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'ProductCategories.LNK_NEW_PRODUCT_CATEGORY'   , '~/Administration/ProductCategories/edit.aspx'           , 'ProductCategories.gif', 1,  null, 'ProductCategories' , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'Manufacturers.LNK_NEW_MANUFACTURER'           , '~/Administration/Manufacturers/edit.aspx'               , 'Manufacturers.gif'    , 1,  null, 'Manufacturers'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTemplates'      , 'ProductTypes.LNK_NEW_PRODUCT_TYPE'            , '~/Administration/ProductTypes/edit.aspx'                , 'ProductTypes.gif'     , 1,  null, 'ProductTypes'      , 'edit';
	-- 09/04/2010 Paul.  Fix SHORTCUT_MODULE. 
	if exists(select * from SHORTCUTS where MODULE_NAME = 'ProductTemplates' and SHORTCUT_MODULE = 'Product_Categories' and DELETED = 0) begin -- then
		update SHORTCUTS
		   set SHORTCUT_MODULE   = 'ProductCategories'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'ProductTemplates'
		   and SHORTCUT_MODULE   = 'Product_Categories'
		   and DELETED = 0;
	end -- if;
	if exists(select * from SHORTCUTS where MODULE_NAME = 'ProductTemplates' and SHORTCUT_MODULE = 'Product_Types' and DELETED = 0) begin -- then
		update SHORTCUTS
		   set SHORTCUT_MODULE   = 'ProductTypes'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'ProductTemplates'
		   and SHORTCUT_MODULE   = 'Product_Types'
		   and DELETED = 0;
	end -- if;
end -- if;
GO

-- 06/02/2012 Paul.  Add Create links. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'ProductTypes' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'ProductTemplates.LNK_NEW_PRODUCT_TEMPLATE'    , '~/Administration/ProductTemplates/edit.aspx'            , 'CreateProducts.gif'   , 1,  1, 'ProductTemplates'  , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'ProductTemplates.LNK_PRODUCT_TEMPLATE_LIST'   , '~/Administration/ProductTemplates/default.aspx'         , 'ProductTemplates.gif' , 1,  2, 'ProductTemplates'  , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'Manufacturers.LNK_NEW_MANUFACTURER'           , '~/Administration/Manufacturers/edit.aspx'               , 'Manufacturers.gif'    , 1,  3, 'Manufacturers'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'Manufacturers.LNK_MANUFACTURER_LIST'          , '~/Administration/Manufacturers/default.aspx'            , 'Manufacturers.gif'    , 1,  4, 'Manufacturers'     , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'ProductCategories.LNK_NEW_PRODUCT_CATEGORY'   , '~/Administration/ProductCategories/edit.aspx'           , 'ProductCategories.gif', 1,  5, 'ProductCategories' , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'ProductCategories.LNK_PRODUCT_CATEGORIES_LIST', '~/Administration/ProductCategories/default.aspx'        , 'ProductCategories.gif', 1,  6, 'ProductCategories' , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'ProductTypes.LNK_NEW_PRODUCT_TYPE'            , '~/Administration/ProductTypes/edit.aspx'                , 'ProductTypes.gif'     , 1,  7, 'ProductTypes'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'ProductTypes.LNK_PRODUCT_TYPE_LIST'           , '~/Administration/ProductTypes/default.aspx'             , 'ProductTypes.gif'     , 1,  8, 'ProductTypes'      , 'list';
end else begin
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'ProductCategories.LNK_NEW_PRODUCT_CATEGORY'   , '~/Administration/ProductCategories/edit.aspx'           , 'ProductCategories.gif', 1,  null, 'ProductCategories' , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'Manufacturers.LNK_NEW_MANUFACTURER'           , '~/Administration/Manufacturers/edit.aspx'               , 'Manufacturers.gif'    , 1,  null, 'Manufacturers'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductTypes'          , 'ProductTypes.LNK_NEW_PRODUCT_TYPE'            , '~/Administration/ProductTypes/edit.aspx'                , 'ProductTypes.gif'     , 1,  null, 'ProductTypes'      , 'edit';
	-- 09/04/2010 Paul.  Fix SHORTCUT_MODULE. 
	if exists(select * from SHORTCUTS where MODULE_NAME = 'ProductTypes' and SHORTCUT_MODULE = 'Product_Categories' and DELETED = 0) begin -- then
		update SHORTCUTS
		   set SHORTCUT_MODULE   = 'ProductCategories'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'ProductTypes'
		   and SHORTCUT_MODULE   = 'Product_Categories'
		   and DELETED = 0;
	end -- if;
	if exists(select * from SHORTCUTS where MODULE_NAME = 'ProductTypes' and SHORTCUT_MODULE = 'Product_Types' and DELETED = 0) begin -- then
		update SHORTCUTS
		   set SHORTCUT_MODULE   = 'ProductTypes'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'ProductTypes'
		   and SHORTCUT_MODULE   = 'Product_Types'
		   and DELETED = 0;
	end -- if;
end -- if;
GO

-- 09/04/2010 Paul.  Move the Product Category creation to the shortcuts. 
-- 06/02/2012 Paul.  Add Create links. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'ProductCategories' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductTemplates.LNK_NEW_PRODUCT_TEMPLATE'    , '~/Administration/ProductTemplates/edit.aspx'            , 'CreateProducts.gif'   , 1,  1, 'ProductTemplates'  , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductTemplates.LNK_PRODUCT_TEMPLATE_LIST'   , '~/Administration/ProductTemplates/default.aspx'         , 'ProductTemplates.gif' , 1,  2, 'ProductTemplates'  , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'Manufacturers.LNK_NEW_MANUFACTURER'           , '~/Administration/Manufacturers/edit.aspx'               , 'Manufacturers.gif'    , 1,  3, 'Manufacturers'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'Manufacturers.LNK_MANUFACTURER_LIST'          , '~/Administration/Manufacturers/default.aspx'            , 'Manufacturers.gif'    , 1,  4, 'Manufacturers'     , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductCategories.LNK_NEW_PRODUCT_CATEGORY'   , '~/Administration/ProductCategories/edit.aspx'           , 'ProductCategories.gif', 1,  5, 'ProductCategories' , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductCategories.LNK_PRODUCT_CATEGORIES_LIST', '~/Administration/ProductCategories/default.aspx'        , 'ProductCategories.gif', 1,  6, 'ProductCategories' , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductTypes.LNK_NEW_PRODUCT_TYPE'            , '~/Administration/ProductTypes/edit.aspx'                , 'ProductTypes.gif'     , 1,  7, 'ProductTypes'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductTypes.LNK_PRODUCT_TYPE_LIST'           , '~/Administration/ProductTypes/default.aspx'             , 'ProductTypes.gif'     , 1,  8, 'ProductTypes'      , 'list';
end else begin
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'Manufacturers.LNK_NEW_MANUFACTURER'           , '~/Administration/Manufacturers/edit.aspx'               , 'Manufacturers.gif'    , 1,  null, 'Manufacturers'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductCategories.LNK_NEW_PRODUCT_CATEGORY'   , '~/Administration/ProductCategories/edit.aspx'           , 'ProductCategories.gif', 1,  null, 'ProductCategories' , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductCategories.LNK_PRODUCT_CATEGORIES_LIST', '~/Administration/ProductCategories/default.aspx'        , 'ProductCategories.gif', 1,  null, 'ProductCategories' , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductTypes.LNK_NEW_PRODUCT_TYPE'            , '~/Administration/ProductTypes/edit.aspx'                , 'ProductTypes.gif'     , 1,  null, 'ProductTypes'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ProductCategories'     , 'ProductTypes.LNK_PRODUCT_TYPE_LIST'           , '~/Administration/ProductTypes/default.aspx'             , 'ProductTypes.gif'     , 1,  null, 'ProductTypes'      , 'list';
	-- 09/04/2010 Paul.  Fix SHORTCUT_MODULE. 
	if exists(select * from SHORTCUTS where MODULE_NAME = 'ProductCategories' and SHORTCUT_MODULE = 'Product_Categories' and DELETED = 0) begin -- then
		update SHORTCUTS
		   set SHORTCUT_MODULE   = 'ProductCategories'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'ProductCategories'
		   and SHORTCUT_MODULE   = 'Product_Categories'
		   and DELETED = 0;
	end -- if;
	if exists(select * from SHORTCUTS where MODULE_NAME = 'ProductCategories' and SHORTCUT_MODULE = 'Product_Types' and DELETED = 0) begin -- then
		update SHORTCUTS
		   set SHORTCUT_MODULE   = 'ProductTypes'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'ProductCategories'
		   and SHORTCUT_MODULE   = 'Product_Types'
		   and DELETED = 0;
	end -- if;
end -- if;
GO

-- 06/02/2012 Paul.  Add Create links. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Manufacturers' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'ProductTemplates.LNK_NEW_PRODUCT_TEMPLATE'    , '~/Administration/ProductTemplates/edit.aspx'            , 'CreateProducts.gif'   , 1,  1, 'ProductTemplates'  , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'ProductTemplates.LNK_PRODUCT_TEMPLATE_LIST'   , '~/Administration/ProductTemplates/default.aspx'         , 'ProductTemplates.gif' , 1,  2, 'ProductTemplates'  , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'Manufacturers.LNK_NEW_MANUFACTURER'           , '~/Administration/Manufacturers/edit.aspx'               , 'Manufacturers.gif'    , 1,  3, 'Manufacturers'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'Manufacturers.LNK_MANUFACTURER_LIST'          , '~/Administration/Manufacturers/default.aspx'            , 'Manufacturers.gif'    , 1,  4, 'Manufacturers'     , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'ProductCategories.LNK_NEW_PRODUCT_CATEGORY'   , '~/Administration/ProductCategories/edit.aspx'           , 'ProductCategories.gif', 1,  5, 'Product_Categories', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'ProductCategories.LNK_PRODUCT_CATEGORIES_LIST', '~/Administration/ProductCategories/default.aspx'        , 'ProductCategories.gif', 1,  6, 'Product_Categories', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'ProductTypes.LNK_NEW_PRODUCT_TYPE'            , '~/Administration/ProductTypes/edit.aspx'                , 'ProductTypes.gif'     , 1,  7, 'ProductTypes'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'ProductTypes.LNK_PRODUCT_TYPE_LIST'           , '~/Administration/ProductTypes/default.aspx'             , 'ProductTypes.gif'     , 1,  8, 'ProductTypes'      , 'list';
end else begin
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'ProductCategories.LNK_NEW_PRODUCT_CATEGORY'   , '~/Administration/ProductCategories/edit.aspx'           , 'ProductCategories.gif', 1,  null, 'Product_Categories', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'Manufacturers.LNK_NEW_MANUFACTURER'           , '~/Administration/Manufacturers/edit.aspx'               , 'Manufacturers.gif'    , 1,  null, 'Manufacturers'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Manufacturers'         , 'ProductTypes.LNK_NEW_PRODUCT_TYPE'            , '~/Administration/ProductTypes/edit.aspx'                , 'ProductTypes.gif'     , 1,  null, 'ProductTypes'      , 'edit';
	if exists(select * from SHORTCUTS where MODULE_NAME = 'Manufacturers' and SHORTCUT_MODULE = 'Product_Types' and DELETED = 0) begin -- then
		update SHORTCUTS
		   set SHORTCUT_MODULE   = 'ProductTypes'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'Manufacturers'
		   and SHORTCUT_MODULE   = 'Product_Types'
		   and DELETED = 0;
	end -- if;
end -- if;
GO

-- 06/02/2012 Paul.  Add Create links. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Shippers' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Shippers'              , 'Shippers.LNK_NEW_SHIPPER'                     , '~/Administration/Shippers/edit.aspx'                    , 'Shippers.gif'         , 1,  1, 'Shippers'          , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Shippers'              , 'Shippers.LNK_SHIPPER_LIST'                    , '~/Administration/Shippers/default.aspx'                 , 'Shippers.gif'         , 1,  2, 'Shippers'          , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Shippers'              , 'TaxRates.LNK_NEW_TAX_RATE'                    , '~/Administration/TaxRates/edit.aspx'                    , 'TaxRates.gif'         , 1,  3, 'TaxRates'          , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Shippers'              , 'TaxRates.LNK_TAX_RATE_LIST'                   , '~/Administration/TaxRates/default.aspx'                 , 'TaxRates.gif'         , 1,  4, 'TaxRates'          , 'list';
end else begin
	exec dbo.spSHORTCUTS_InsertOnly null, 'Shippers'              , 'Shippers.LNK_NEW_SHIPPER'                     , '~/Administration/Shippers/edit.aspx'                    , 'Shippers.gif'         , 1,  null, 'Shippers'          , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Shippers'              , 'TaxRates.LNK_NEW_TAX_RATE'                    , '~/Administration/TaxRates/edit.aspx'                    , 'TaxRates.gif'         , 1,  null, 'TaxRates'          , 'edit';
end -- if;
GO

-- 06/02/2012 Paul.  Add Create links. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'TaxRates' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'TaxRates'              , 'Shippers.LNK_NEW_SHIPPER'                     , '~/Administration/Shippers/edit.aspx'                    , 'Shippers.gif'         , 1,  1, 'Shippers'          , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TaxRates'              , 'Shippers.LNK_SHIPPER_LIST'                    , '~/Administration/Shippers/default.aspx'                 , 'Shippers.gif'         , 1,  2, 'Shippers'          , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TaxRates'              , 'TaxRates.LNK_NEW_TAX_RATE'                    , '~/Administration/TaxRates/edit.aspx'                    , 'TaxRates.gif'         , 1,  3, 'TaxRates'          , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TaxRates'              , 'TaxRates.LNK_TAX_RATE_LIST'                   , '~/Administration/TaxRates/default.aspx'                 , 'TaxRates.gif'         , 1,  4, 'TaxRates'          , 'list';
end else begin
	exec dbo.spSHORTCUTS_InsertOnly null, 'TaxRates'              , 'Shippers.LNK_NEW_SHIPPER'                     , '~/Administration/Shippers/edit.aspx'                    , 'Shippers.gif'         , 1,  null, 'Shippers'          , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TaxRates'              , 'TaxRates.LNK_NEW_TAX_RATE'                    , '~/Administration/TaxRates/edit.aspx'                    , 'TaxRates.gif'         , 1,  null, 'TaxRates'          , 'edit';
end -- if;
GO

-- 06/02/2012 Paul.  Add Create links. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'ContractTypes' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'ContractTypes'         , 'ContractTypes.LNK_NEW_CONTRACT_TYPE'          , '~/Administration/ContractTypes/edit.aspx'               , 'Contracts.gif'        , 1,  1, 'ContractTypes'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ContractTypes'         , 'ContractTypes.LNK_CONTRACT_TYPE_LIST'         , '~/Administration/ContractTypes/default.aspx'            , 'Contracts.gif'        , 1,  2, 'ContractTypes'     , 'list';
end else begin
	exec dbo.spSHORTCUTS_InsertOnly null, 'ContractTypes'         , 'ContractTypes.LNK_NEW_CONTRACT_TYPE'          , '~/Administration/ContractTypes/edit.aspx'               , 'Contracts.gif'        , 1,  null, 'ContractTypes'     , 'edit';
end -- if;
GO

-- 06/02/2012 Paul.  Add Discounts shortcuts. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Discounts' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Discounts'             , 'Discounts.LNK_NEW_DISCOUNT'                   , '~/Administration/Discounts/edit.aspx'                   , 'Discounts.gif'        , 1,  1, 'Discounts'         , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Discounts'             , 'Discounts.LNK_DISCOUNT_LIST'                  , '~/Administration/Discounts/default.aspx'                , 'Discounts.gif'        , 1,  2, 'Discounts'         , 'list';
end -- if;
GO

/*

-- delete from SHORTCUTS where MODULE_NAME = 'Forecasts'
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Forecasts' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Forecasts'             , 'Forecasts.LNK_FORECAST_LIST'                  , '~/Forecasts/default.aspx'                , 'Forecasts.gif'        , 1,  1, 'Forecasts'         , 'list';
end -- if;
--GO

*/

-- 12/18/2015 Paul.  Change target module to ActivityStream so that we can disable on Portal. 

-- delete from SHORTCUTS where MODULE_NAME = 'Quotes'
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Quotes' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Quotes'                , 'Quotes.LNK_NEW_QUOTE'                         , '~/Quotes/edit.aspx'                      , 'CreateQuotes.gif'     , 1,  1, 'Quotes'            , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Quotes'                , 'Quotes.LNK_QUOTE_LIST'                        , '~/Quotes/default.aspx'                   , 'Quotes.gif'           , 1,  2, 'Quotes'            , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Quotes'                , '.LNK_ACTIVITY_STREAM'                         , '~/Quotes/stream.aspx'                    , 'ActivityStream.gif'   , 1,  3, 'ActivityStream'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Quotes'                , 'Quotes.LNK_ARCHIVED_QUOTES'                   , '~/Quotes/default.aspx?ArchiveView=1'     , 'Quotes.gif'           , 1,  4, 'Quotes'            , 'archive';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'Contracts'
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Contracts' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Contracts'             , 'Contracts.LNK_NEW_CONTRACT'                   , '~/Contracts/edit.aspx'                   , 'CreateContracts.gif'  , 1,  1, 'Contracts'         , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Contracts'             , 'Contracts.LNK_CONTRACT_LIST'                  , '~/Contracts/default.aspx'                , 'Contracts.gif'        , 1,  2, 'Contracts'         , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Contracts'             , '.LNK_ACTIVITY_STREAM'                         , '~/Contracts/stream.aspx'                 , 'ActivityStream.gif'   , 1,  3, 'ActivityStream'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Contracts'             , 'Contracts.LNK_ARCHIVED_CONTRACTS'             , '~/Contracts/default.aspx?ArchiveView=1'  , 'Contracts.gif'        , 1,  4, 'Contracts'         , 'archive';
end -- if;
GO

-- 05/21/2009 Paul.  Products Create is old and no longer applies.  The products table is a searchable view of Orders Line Items. 
-- delete from SHORTCUTS where MODULE_NAME = 'Products'
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Products' and DELETED = 0) begin -- then
--	exec dbo.spSHORTCUTS_InsertOnly null, 'Products'              , 'Products.LNK_NEW_PRODUCT'                     , '~/Products/edit.aspx'                    , 'CreateProducts.gif'   , 1,  1, 'Products'          , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Products'              , 'Products.LNK_PRODUCT_LIST'                    , '~/Products/default.aspx'                 , 'Products.gif'         , 1,  2, 'Products'          , 'list';
end else begin
	if exists(select * from SHORTCUTS where MODULE_NAME = 'Products' and RELATIVE_PATH = '~/Products/edit.aspx' and DELETED = 0) begin -- then
		print 'Remove Products.Create shortcut.';
		update SHORTCUTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where MODULE_NAME      = 'Products'
		   and RELATIVE_PATH    = '~/Products/edit.aspx'
		   and DELETED          = 0;
	end -- if;
end -- if;
GO

/*
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Reports' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Reports.LNK_REPORTS'                          , '~/Reports/default.aspx'                          , 'Reports.gif'             , 1,  1, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Accounts.LNK_REPORTS'                         , '~/Reports/default.aspx?MODULE_NAME=Accounts'     , 'AccountReports.gif'      , 1,  2, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Contacts.LNK_REPORTS'                         , '~/Reports/default.aspx?MODULE_NAME=Contacts'     , 'ContactReports.gif'      , 1,  3, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Leads.LNK_REPORTS'                            , '~/Reports/default.aspx?MODULE_NAME=Leads'        , 'LeadReports.gif'         , 1,  4, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Opportunities.LNK_REPORTS'                    , '~/Reports/default.aspx?MODULE_NAME=Opportunities', 'OpportunityReports.gif'  , 1,  5, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Quotes.LNK_REPORTS'                           , '~/Reports/default.aspx?MODULE_NAME=Quotes'       , 'QuoteReports.gif'        , 1,  6, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Cases.LNK_REPORTS'                            , '~/Reports/default.aspx?MODULE_NAME=Cases'        , 'CaseReports.gif'         , 1,  7, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Bugs.LNK_REPORTS'                             , '~/Reports/default.aspx?MODULE_NAME=Bugs'         , 'BugReports.gif'          , 1,  8, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Calls.LNK_REPORTS'                            , '~/Reports/default.aspx?MODULE_NAME=Calls'        , 'CallReports.gif'         , 1,  9, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Meetings.LNK_REPORTS'                         , '~/Reports/default.aspx?MODULE_NAME=Meetings'     , 'MeetingReports.gif'      , 1, 10, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Tasks.LNK_REPORTS'                            , '~/Reports/default.aspx?MODULE_NAME=Tasks'        , 'TaskReports.gif'         , 1, 11, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Emails.LNK_REPORTS'                           , '~/Reports/default.aspx?MODULE_NAME=Emails'       , 'EmailReports.gif'        , 1, 12, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Forecasts.LNK_REPORTS'                        , '~/Reports/default.aspx?MODULE_NAME=Forecasts'    , 'ForecastReports.gif'     , 0, 13, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'ProjectTask.LNK_REPORTS'                      , '~/Reports/default.aspx?MODULE_NAME=ProjectTask'  , 'TaskReports.gif'         , 1, 14, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Prospects.LNK_REPORTS'                        , '~/Reports/default.aspx?MODULE_NAME=Prospects'    , 'Reports.gif'             , 1, 15, 'Reports', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Contracts.LNK_REPORTS'                        , '~/Reports/default.aspx?MODULE_NAME=Contracts'    , 'ContractReports.gif'     , 1, 16, 'Reports', 'list';
end -- if;
*/
-- 06/23/2010 Paul.  Delete all previous Reports shortcuts before adding the new style. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Reports' and RELATIVE_PATH = '~/Reports/import.aspx' and DELETED = 0) begin -- then
	update SHORTCUTS
	   set DELETED          = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'Reports'
	   and DELETED          = 0;
end -- if;
GO

-- 06/09/2011 Paul.  Include a link to the rules. 
-- delete from SHORTCUTS where MODULE_NAME = 'Reports';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Reports' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Reports.LBL_CREATE_BUTTON_LABEL'              , '~/Reports/edit.aspx'                      , 'CreateReport.gif'     , 1,  1, 'Reports'           , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'Reports.LNK_REPORTS'                          , '~/Reports/default.aspx'                   , 'Reports.gif'          , 1,  2, 'Reports'           , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , '.LBL_IMPORT'                                  , '~/Reports/import.aspx'                    , 'Import.gif'           , 1,  3, 'Reports'           , 'import';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'ReportRules.LNK_RULES'                        , '~/Reports/ReportRules/default.aspx'       , 'Rules.gif'            , 1,  4, 'ReportRules'       , 'list';
end else begin
	exec dbo.spSHORTCUTS_InsertOnly null, 'Reports'               , 'ReportRules.LNK_RULES'                        , '~/Reports/ReportRules/default.aspx'       , 'Rules.gif'            , 1,  4, 'ReportRules'       , 'list';
end -- if;
GO

-- 12/21/2014 Paul.  Treat report designer as a separate module. 
-- delete from SHORTCUTS where MODULE_NAME = 'ReportDesigner';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'ReportDesigner' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'ReportDesigner'        , 'Reports.LBL_CREATE_BUTTON_LABEL'              , '~/ReportDesigner/edit.aspx'               , 'CreateReport.gif'     , 1,  1, 'ReportDesigner'    , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ReportDesigner'        , 'Reports.LNK_REPORTS'                          , '~/ReportDesigner/default.aspx'            , 'Reports.gif'          , 1,  2, 'ReportDesigner'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ReportDesigner'        , '.LBL_IMPORT'                                  , '~/ReportDesigner/import.aspx'             , 'Import.gif'           , 1,  3, 'ReportDesigner'    , 'import';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ReportDesigner'        , 'ReportRules.LNK_RULES'                        , '~/Reports/ReportRules/default.aspx'       , 'Rules.gif'            , 1,  4, 'ReportRules'       , 'list';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'Teams';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Teams' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Teams'                 , 'Teams.LNK_NEW_TEAM'                           , '~/Administration/Teams/edit.aspx'         , 'CreateTeams.gif'      , 1,  1, 'Teams'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Teams'                 , 'Teams.LNK_TEAM_LIST'                          , '~/Administration/Teams/default.aspx'      , 'Teams.gif'            , 1,  2, 'Teams'             , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Teams'                 , 'TeamNotices.LNK_TEAM_NOTICE_LIST'             , '~/Administration/TeamNotices/default.aspx', 'Teams.gif'            , 1,  3, 'TeamNotices'       , 'list';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'TeamNotices';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'TeamNotices' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'TeamNotices'           , 'Teams.LNK_NEW_TEAM'                           , '~/Administration/Teams/edit.aspx'         , 'CreateTeams.gif'      , 1,  1, 'Teams'             , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TeamNotices'           , 'Teams.LNK_TEAM_LIST'                          , '~/Administration/Teams/default.aspx'      , 'Teams.gif'            , 1,  2, 'Teams'             , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TeamNotices'           , 'TeamNotices.LNK_TEAM_NOTICE_LIST'             , '~/Administration/TeamNotices/default.aspx', 'Teams.gif'            , 1,  3, 'TeamNotices'       , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TeamNotices'           , 'TeamNotices.LNK_NEW_TEAM_NOTICE'              , '~/Administration/TeamNotices/edit.aspx'   , 'CreateTeams.gif'      , 1,  4, 'TeamNotices'       , 'edit';
end -- if;
GO

-- 04/03/2007 Paul.  Add Orders module. 
-- delete from SHORTCUTS where MODULE_NAME = 'Orders';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Orders' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Orders'                , 'Orders.LNK_NEW_ORDER'                  , '~/Orders/edit.aspx'                     , 'CreateOrders.gif'        , 1,  1, 'Orders', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Orders'                , 'Orders.LNK_ORDER_LIST'                 , '~/Orders/default.aspx'                  , 'Orders.gif'              , 1,  2, 'Orders', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Orders'                , '.LNK_ACTIVITY_STREAM'                  , '~/Orders/stream.aspx'                   , 'ActivityStream.gif'      , 1,  3, 'ActivityStream'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Orders'                , 'Orders.LNK_ARCHIVED_ORDERS'            , '~/Orders/default.aspx?ArchiveView=1'    , 'Orders.gif'              , 1,  4, 'Orders', 'archive';
end -- if;
GO

-- 04/11/2007 Paul.  Add Invoices module. 
-- delete from SHORTCUTS where MODULE_NAME = 'Invoices';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Invoices' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Invoices'              , 'Invoices.LNK_NEW_INVOICE'              , '~/Invoices/edit.aspx'                   , 'CreateInvoices.gif'      , 1,  1, 'Invoices', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Invoices'              , 'Invoices.LNK_INVOICE_LIST'             , '~/Invoices/default.aspx'                , 'Invoices.gif'            , 1,  2, 'Invoices', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Invoices'              , 'Payments.LNK_NEW_PAYMENT'              , '~/Payments/edit.aspx'                   , 'CreatePayments.gif'      , 1,  3, 'Payments', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Invoices'              , 'Payments.LNK_PAYMENT_LIST'             , '~/Payments/default.aspx'                , 'Payments.gif'            , 1,  4, 'Payments', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Invoices'              , '.LNK_ACTIVITY_STREAM'                  , '~/Invoices/stream.aspx'                 , 'ActivityStream.gif'      , 1,  5, 'ActivityStream'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Invoices'              , 'Invoices.LNK_ARCHIVED_INVOICES'        , '~/Invoices/default.aspx?ArchiveView=1'  , 'Invoices.gif'            , 1,  6, 'Invoices', 'archive';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'Payments';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Payments' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Payments'              , 'Invoices.LNK_NEW_INVOICE'              , '~/Invoices/edit.aspx'                   , 'CreateInvoices.gif'      , 1,  1, 'Invoices', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Payments'              , 'Invoices.LNK_INVOICE_LIST'             , '~/Invoices/default.aspx'                , 'Invoices.gif'            , 1,  2, 'Invoices', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Payments'              , 'Payments.LNK_NEW_PAYMENT'              , '~/Payments/edit.aspx'                   , 'CreatePayments.gif'      , 1,  3, 'Payments', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Payments'              , 'Payments.LNK_PAYMENT_LIST'             , '~/Payments/default.aspx'                , 'Payments.gif'            , 1,  4, 'Payments', 'list';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'Forums';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Forums' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Forums'                , 'Forums.LNK_FORUM_LIST'                 , '~/Forums/default.aspx'                    , 'Forums.gif'            , 1,  1, 'Forums'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Forums'                , 'Forums.LNK_NEW_FORUM'                  , '~/Forums/edit.aspx'                       , 'CreateForums.gif'      , 1,  2, 'Forums'    , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Forums'                , 'ForumTopics.LNK_FORUM_TOPIC_LIST'      , '~/Administration/ForumTopics/default.aspx', 'ForumTopics.gif'       , 1,  3, 'ForumTypes', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Forums'                , 'ForumTopics.LNK_NEW_FORUM_TOPIC'       , '~/Administration/ForumTopics/edit.aspx'   , 'CreateForumTopics.gif' , 1,  4, 'ForumTypes', 'edit';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'ForumTopics';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'ForumTopics' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'ForumTopics'           , 'Forums.LNK_FORUM_LIST'                 , '~/Forums/default.aspx'                    , 'Forums.gif'            , 1,  1, 'Forums'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ForumTopics'           , 'Forums.LNK_NEW_FORUM'                  , '~/Forums/edit.aspx'                       , 'CreateForums.gif'      , 1,  2, 'Forums'    , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ForumTopics'           , 'ForumTopics.LNK_FORUM_TOPIC_LIST'      , '~/Administration/ForumTopics/default.aspx', 'ForumTopics.gif'       , 1,  3, 'ForumTypes', 'list';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'ForumTopics';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Threads' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Threads'               , 'Forums.LNK_FORUM_LIST'                 , '~/Forums/default.aspx'                    , 'Forums.gif'            , 1,  1, 'Forums'    , 'list';
end -- if;
GO

-- 03/04/2009 Paul.  Add reassign link. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Users' and DISPLAY_NAME = 'Users.LNK_REASSIGN_RECORDS' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Users'                 , 'Users.LNK_REASSIGN_RECORDS'            , '~/Users/reassign.aspx'                    , 'Users.gif'             , 1,  4, 'Users', 'edit';
end -- if;
GO

-- 10/18/2009 Paul.  Add Knowledge Base module. 
-- 01/14/2018 Paul.  Remove KB Tags now that we have a global tag system. 
-- 09/16/2019 Paul.  Fix LNK_ARCHIVED_KBDOCUMENTS. 
-- delete from SHORTCUTS where MODULE_NAME = 'KBDocuments';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'KBDocuments' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBDocuments'           , 'KBDocuments.LNK_NEW_DOCUMENT'          , '~/KBDocuments/edit.aspx'                 , 'CreateKBDocuments.gif'   , 1,  1, 'KBDocuments'   , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBDocuments'           , 'KBDocuments.LNK_KBDOCUMENT_LIST'       , '~/KBDocuments/default.aspx'              , 'KBDocuments.gif'         , 1,  2, 'KBDocuments'   , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBDocuments'           , '.LBL_IMPORT'                           , '~/KBDocuments/import.aspx'               , 'Import.gif'              , 1,  3, 'KBDocuments'   , 'import';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBDocuments'           , '.LNK_ACTIVITY_STREAM'                  , '~/KBDocuments/stream.aspx'               , 'ActivityStream.gif'      , 1,  4, 'ActivityStream', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBDocuments'           , 'KBDocuments.LNK_ARCHIVED_KBDOCUMENTS'  , '~/KBDocuments/default.aspx?ArchiveView=1', 'KBDocuments.gif'         , 1,  5, 'KBDocuments'   , 'archive';
--	exec dbo.spSHORTCUTS_InsertOnly null, 'KBDocuments'           , 'KBTags.LNK_NEW_KBTAG'                  , '~/KBDocuments/KBTags/edit.aspx'          , 'CreateKBTags.gif'        , 1,  4, 'KBTags'        , 'edit';
--	exec dbo.spSHORTCUTS_InsertOnly null, 'KBDocuments'           , 'KBTags.LNK_KBTAG_LIST'                 , '~/KBDocuments/KBTags/default.aspx'       , 'KBTags.gif'              , 1,  5, 'KBTags'        , 'list';
end else begin
	-- 01/14/2018 Paul.  Remove KB Tags now that we have a global tag system. 
	if exists(select * from SHORTCUTS where MODULE_NAME = 'KBDocuments' and RELATIVE_PATH = '~/KBDocuments/KBTags/edit.aspx' and DELETED = 0) begin -- then
		print 'Remove KBTags.';
		update SHORTCUTS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'KBDocuments'
		   and RELATIVE_PATH     in ('~/KBDocuments/KBTags/edit.aspx', '~/KBDocuments/KBTags/default.aspx')
		   and DELETED           = 0;
		update SHORTCUTS
		   set SHORTCUT_ORDER    = SHORTCUT_ORDER - 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'KBDocuments'
		   and SHORTCUT_ORDER    > 4
		   and DELETED           = 0;
	end -- if;
	-- 09/16/2019 Paul.  Fix LNK_ARCHIVED_KBDOCUMENTS. 
	if exists(select * from SHORTCUTS where MODULE_NAME = 'KBDocuments' and RELATIVE_PATH = '~/KBDocuments/default.aspx?ArchiveView=1' and DISPLAY_NAME = 'KBDocuments.LNK_ARCHIVED_Quotes' and DELETED = 0) begin -- then
		update SHORTCUTS
		   set DISPLAY_NAME      = 'KBDocuments.LNK_ARCHIVED_KBDOCUMENTS'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where MODULE_NAME       = 'KBDocuments'
		   and RELATIVE_PATH     = '~/KBDocuments/default.aspx?ArchiveView=1'
		   and DISPLAY_NAME      = 'KBDocuments.LNK_ARCHIVED_Quotes' 
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists (select * from SHORTCUTS where MODULE_NAME = 'KBTags' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBTags'                , 'KBDocuments.LNK_NEW_DOCUMENT'          , '~/KBDocuments/edit.aspx'                , 'CreateKBDocuments.gif'   , 1,  1, 'KBDocuments', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBTags'                , 'KBDocuments.LNK_KBDOCUMENT_LIST'       , '~/KBDocuments/default.aspx'             , 'KBDocuments.gif'         , 1,  2, 'KBDocuments', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBTags'                , '.LBL_IMPORT'                           , '~/KBDocuments/import.aspx'              , 'Import.gif'              , 1,  3, 'KBDocuments', 'import';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBTags'                , 'KBTags.LNK_NEW_KBTAG'                  , '~/KBDocuments/KBTags/edit.aspx'         , 'CreateKBTags.gif'        , 1,  4, 'KBTags'     , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBTags'                , 'KBTags.LNK_KBTAG_LIST'                 , '~/KBDocuments/KBTags/default.aspx'      , 'KBTags.gif'              , 1,  5, 'KBTags'     , 'list';
end -- if;
GO

-- 07/20/2010 Paul.  Regions. 
-- 09/16/2010 Paul.  Move Regions to Professional file. 
-- delete from SHORTCUTS where MODULE_NAME = 'Regions';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Regions' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Regions'               , 'Regions.LNK_LIST_REGIONS'                , '~/Administration/Regions/default.aspx'                  , 'Regions.gif'              , 1,  1, 'Regions'          , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Regions'               , 'Regions.LNK_NEW_REGION'                  , '~/Administration/Regions/edit.aspx'                     , 'Regions.gif'              , 1,  2, 'Regions'          , 'edit';
end -- if;
GO

-- 09/16/2010 Paul.  Add support for multiple Payment Gateways.
if not exists (select * from SHORTCUTS where MODULE_NAME = 'PaymentGateway' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentGateway'        , 'PaymentGateway.LNK_PAYMENT_GATEWAYS'            , '~/Administration/PaymentGateway/default.aspx'           , 'PaymentGateway.gif'       , 1,  1, 'PaymentGateway'   , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentGateway'        , 'PaymentGateway.LNK_NEW_PAYMENT_GATEWAY'         , '~/Administration/PaymentGateway/edit.aspx'              , 'PaymentGateway.gif'       , 1,  2, 'PaymentGateway'   , 'edit';
end -- if;
GO

-- 10/29/2011 Paul.  Add charts. 
-- delete from SHORTCUTS where MODULE_NAME = 'Charts';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Charts' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Charts'                , 'Charts.LBL_CREATE_BUTTON_LABEL'               , '~/Charts/edit.aspx'                       , 'CreateChart.gif'      , 1,  1, 'Charts'            , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Charts'                , 'Charts.LNK_CHARTS'                            , '~/Charts/default.aspx'                    , 'Charts.gif'           , 1,  2, 'Charts'            , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Charts'                , '.LBL_IMPORT'                                  , '~/Charts/import.aspx'                     , 'Import.gif'           , 1,  3, 'Charts'            , 'import';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Charts'                , 'ReportRules.LNK_RULES'                        , '~/Reports/ReportRules/default.aspx'       , 'Rules.gif'            , 1,  4, 'ReportRules'       , 'list';
end -- if;
GO

-- 05/22/2013 Paul.  Add Surveys module. 
-- delete from SHORTCUTS where MODULE_NAME = 'Surveys';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Surveys' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , 'Surveys.LNK_NEW_SURVEY'                       , '~/Surveys/edit.aspx'                      , 'CreateSurveys.gif'        , 1,  1, 'Surveys'        , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , 'Surveys.LNK_SURVEY_LIST'                      , '~/Surveys/default.aspx'                   , 'Surveys.gif'              , 1,  2, 'Surveys'        , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , '.LBL_IMPORT'                                  , '~/Surveys/import.aspx'                    , 'Import.gif'               , 1,  3, 'Surveys'        , 'import';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , 'SurveyQuestions.LNK_NEW_SURVEY_QUESTION'      , '~/SurveyQuestions/edit.aspx'              , 'CreateSurveyQuestions.gif', 1,  4, 'SurveyQuestions', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , 'SurveyQuestions.LNK_SURVEY_QUESTION_LIST'     , '~/SurveyQuestions/default.aspx'           , 'SurveyQuestions.gif'      , 1,  5, 'SurveyQuestions', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , 'SurveyResults.LNK_SURVEY_RESULTS_LIST'        , '~/SurveyResults/default.aspx'             , 'SurveyResults.gif'        , 1,  6, 'SurveyResults'  , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , '.LNK_ACTIVITY_STREAM'                         , '~/Surveys/stream.aspx'                    , 'ActivityStream.gif'       , 1,  7, 'ActivityStream'    , 'list';
end else begin
	if not exists (select * from SHORTCUTS where MODULE_NAME = 'Surveys' and RELATIVE_PATH = '~/Surveys/import.aspx' and DELETED = 0) begin -- then
		exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , '.LBL_IMPORT'                                  , '~/Surveys/import.aspx'                    , 'Import.gif'               , 1,  null, 'Surveys'        , 'import';
	end -- if;
	if not exists (select * from SHORTCUTS where MODULE_NAME = 'Surveys' and RELATIVE_PATH = '~/SurveyResults/default.aspx' and DELETED = 0) begin -- then
		exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , 'SurveyResults.LNK_SURVEY_RESULTS_LIST'        , '~/SurveyResults/default.aspx'             , 'SurveyResults.gif'        , 1,  null, 'SurveyResults'  , 'list';
	end -- if;
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'SurveyPages';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'SurveyPages' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyPages'           , 'Surveys.LNK_NEW_SURVEY'                       , '~/Surveys/edit.aspx'                      , 'CreateSurveys.gif'        , 1,  1, 'Surveys'        , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyPages'           , 'Surveys.LNK_SURVEY_LIST'                      , '~/Surveys/default.aspx'                   , 'Surveys.gif'              , 1,  2, 'Surveys'        , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyPages'           , 'SurveyQuestions.LNK_NEW_SURVEY_QUESTION'      , '~/SurveyQuestions/edit.aspx'              , 'CreateSurveyQuestions.gif', 1,  3, 'SurveyQuestions', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyPages'           , 'SurveyQuestions.LNK_SURVEY_QUESTION_LIST'     , '~/SurveyQuestions/default.aspx'           , 'SurveyQuestions.gif'      , 1,  4, 'SurveyQuestions', 'list';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'SurveyQuestions';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'SurveyQuestions' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyQuestions'       , 'SurveyQuestions.LNK_NEW_SURVEY_QUESTION'      , '~/SurveyQuestions/edit.aspx'              , 'CreateSurveyQuestions.gif', 1,  1, 'SurveyQuestions', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyQuestions'       , 'SurveyQuestions.LNK_SURVEY_QUESTION_LIST'     , '~/SurveyQuestions/default.aspx'           , 'SurveyQuestions.gif'      , 1,  2, 'SurveyQuestions', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyQuestions'       , 'Surveys.LNK_NEW_SURVEY'                       , '~/Surveys/edit.aspx'                      , 'CreateSurveys.gif'        , 1,  3, 'Surveys'        , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyQuestions'       , 'Surveys.LNK_SURVEY_LIST'                      , '~/Surveys/default.aspx'                   , 'Surveys.gif'              , 1,  4, 'Surveys'        , 'list';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'SurveyResults';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'SurveyResults' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyResults'         , 'Surveys.LNK_NEW_SURVEY'                       , '~/Surveys/edit.aspx'                      , 'CreateSurveys.gif'        , 1,  1, 'Surveys'        , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyResults'         , 'Surveys.LNK_SURVEY_LIST'                      , '~/Surveys/default.aspx'                   , 'Surveys.gif'              , 1,  2, 'Surveys'        , 'list';
end -- if;
GO

-- 10/18/2013 Paul.  Add SurveyThemes to the tab menu. 
-- delete from SHORTCUTS where MODULE_NAME = 'SurveyThemes';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'SurveyThemes' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyThemes'          , 'SurveyThemes.LNK_NEW_SURVEY_THEME'            , '~/Administration/SurveyThemes/edit.aspx'   , 'CreateSurveyThemes.gif'  , 1,  1, 'SurveyThemes'  , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'SurveyThemes'          , 'SurveyThemes.LNK_SURVEY_THEME_LIST'           , '~/Administration/SurveyThemes/default.aspx', 'SurveyThemes.gif'        , 1,  2, 'SurveyThemes'  , 'list';
end -- if;
GO

-- delete from SHORTCUTS where MODULE_NAME = 'OutboundEmail';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'OutboundEmail' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'OutboundEmail'         , 'OutboundEmail.LNK_NEW_OUTBOUND_EMAIL'         , '~/Administration/OutboundEmail/edit.aspx'   , 'CreateInboundEmail.gif' , 1,  1, 'OutboundEmail', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'OutboundEmail'         , 'OutboundEmail.LNK_OUTBOUND_EMAIL_LIST'        , '~/Administration/OutboundEmail/default.aspx', 'InboundEmail.gif'       , 1,  2, 'OutboundEmail', 'list';
end -- if;
GO

-- 10/26/2013 Paul.  Add TwitterTracks module.
-- delete from SHORTCUTS where MODULE_NAME = 'TwitterTracks';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'TwitterTracks' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'TwitterTracks'         , 'TwitterTracks.LNK_NEW_TWITTER_TRACK'          , '~/TwitterTracks/edit.aspx'                  , 'CreateTwitterTracks.gif'  , 1,  1, 'TwitterTracks'  , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TwitterTracks'         , 'TwitterTracks.LNK_TWITTER_TRACKS_LIST'        , '~/TwitterTracks/default.aspx'               , 'TwitterTracks.gif'        , 1,  2, 'TwitterTracks'  , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TwitterTracks'         , 'TwitterMessages.LNK_NEW_TWITTER_MESSAGE'      , '~/TwitterMessages/edit.aspx'                , 'CreateTwitterMessages.gif', 1,  3, 'TwitterMessages', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TwitterTracks'         , 'TwitterMessages.LNK_TWITTER_MESSAGES_LIST'    , '~/TwitterMessages/default.aspx'             , 'TwitterMessages.gif'      , 1,  4, 'TwitterMessages', 'list';
end -- if;
GO

if not exists (select * from SHORTCUTS where MODULE_NAME = 'TwitterMessages' and RELATIVE_PATH = '~/TwitterTracks/edit.aspx' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'TwitterMessages'       , 'TwitterTracks.LNK_NEW_TWITTER_TRACK'          , '~/TwitterTracks/edit.aspx'                  , 'CreateTwitterTracks.gif'  , 1,  4, 'TwitterTracks'  , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'TwitterMessages'       , 'TwitterTracks.LNK_TWITTER_TRACKS_LIST'        , '~/TwitterTracks/default.aspx'               , 'TwitterTracks.gif'        , 1,  5, 'TwitterTracks'  , 'list';
end -- if;
GO

-- 03/02/2015 Paul.  Add Create links. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'PaymentTypes' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentTypes'          , 'PaymentTypes.LNK_NEW_PAYMENT_TYPE'            , '~/Administration/PaymentTypes/edit.aspx'    , 'PaymentTypes.gif'     , 1,  1, 'PaymentTypes'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentTypes'          , 'PaymentTypes.LNK_PAYMENT_TYPE_LIST'           , '~/Administration/PaymentTypes/default.aspx' , 'PaymentTypes.gif'     , 1,  2, 'PaymentTypes'      , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentTypes'          , 'PaymentTerms.LNK_NEW_PAYMENT_TERM'            , '~/Administration/PaymentTerms/edit.aspx'    , 'PaymentTerms.gif'     , 1,  3, 'PaymentTerms'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentTypes'          , 'PaymentTerms.LNK_PAYMENT_TERM_LIST'           , '~/Administration/PaymentTerms/default.aspx' , 'PaymentTerms.gif'     , 1,  4, 'PaymentTerms'      , 'list';
end -- if;
GO

if not exists (select * from SHORTCUTS where MODULE_NAME = 'PaymentTerms' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentTerms'          , 'PaymentTerms.LNK_NEW_PAYMENT_TERM'            , '~/Administration/PaymentTerms/edit.aspx'    , 'PaymentTerms.gif'     , 1,  1, 'PaymentTerms'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentTerms'          , 'PaymentTerms.LNK_PAYMENT_TERM_LIST'           , '~/Administration/PaymentTerms/default.aspx' , 'PaymentTerms.gif'     , 1,  2, 'PaymentTerms'      , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentTerms'          , 'PaymentTypes.LNK_NEW_PAYMENT_TYPE'            , '~/Administration/PaymentTypes/edit.aspx'    , 'PaymentTypes.gif'     , 1,  3, 'PaymentTypes'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'PaymentTerms'          , 'PaymentTypes.LNK_PAYMENT_TYPE_LIST'           , '~/Administration/PaymentTypes/default.aspx' , 'PaymentTypes.gif'     , 1,  4, 'PaymentTypes'      , 'list';
end -- if;
GO

-- 09/28/2015 Paul.  Add Activity Stream to all core modules. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Contracts' and DISPLAY_NAME = '.LNK_ACTIVITY_STREAM' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Contracts'             , '.LNK_ACTIVITY_STREAM'                  , '~/Contracts/stream.aspx'                , 'ActivityStream.gif'      , 1,  -1, 'ActivityStream'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBDocuments'           , '.LNK_ACTIVITY_STREAM'                  , '~/KBDocuments/stream.aspx'              , 'ActivityStream.gif'      , 1,  -1, 'ActivityStream'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Quotes'                , '.LNK_ACTIVITY_STREAM'                  , '~/Quotes/stream.aspx'                   , 'ActivityStream.gif'      , 1,  -1, 'ActivityStream'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Orders'                , '.LNK_ACTIVITY_STREAM'                  , '~/Orders/stream.aspx'                   , 'ActivityStream.gif'      , 1,  -1, 'ActivityStream'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Invoices'              , '.LNK_ACTIVITY_STREAM'                  , '~/Invoices/stream.aspx'                 , 'ActivityStream.gif'      , 1,  -1, 'ActivityStream'    , 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Surveys'               , '.LNK_ACTIVITY_STREAM'                  , '~/Surveys/stream.aspx'                  , 'ActivityStream.gif'      , 1,  -1, 'ActivityStream'    , 'list';
end -- if;
GO

-- 01/01/2016 Paul.  Add Authorize.Net module. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'AuthorizeNet' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'AuthorizeNet', 'AuthorizeNet.LNK_AUTHORIZENET_SETTINGS'         , '~/Administration/AuthorizeNet/config.aspx'                   , 'AuthorizeNet.gif'        , 1,  1, 'AuthorizeNet', 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'AuthorizeNet', 'AuthorizeNet.LNK_AUTHORIZENET_TRANSACTIONS'     , '~/Administration/AuthorizeNet/default.aspx'                  , 'AuthorizeNet.gif'        , 1,  2, 'AuthorizeNet', 'list';
	exec dbo.spSHORTCUTS_InsertOnly null, 'AuthorizeNet', 'AuthorizeNet.LNK_AUTHORIZENET_CUSTOMER_PROFILES', '~/Administration/AuthorizeNet//CustomerProfiles/default.aspx', 'AuthorizeNet.gif'        , 1,  3, 'AuthorizeNet', 'list';
end -- if;
GO

-- 01/01/2016 Paul.  Move PayPal module to Professional. 
-- delete SHORTCUTS where MODULE_NAME = 'PayPal';
if not exists (select * from SHORTCUTS where MODULE_NAME = 'PayPal' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'PayPal', 'PayPal.LNK_TRANSACTIONS_LIST', '~/Administration/PayPalTransactions/default.aspx'       , 'PayPalTransactions.gif'      , 1,  1, 'PayPal', 'list';
	--exec dbo.spSHORTCUTS_InsertOnly null, 'PayPal', 'PayPal.LNK_NEW_TRANSACTION'  , '~/Administration/PayPalTransactions/edit.aspx'          , 'CreatePayPalTransactions.gif', 1,  2, 'PayPal', 'edit';
end -- if;
GO

-- 09/26/2017 Paul.  Add Archive access right. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'Quotes' and DISPLAY_NAME = 'Quotes.LNK_ARCHIVED_QUOTES' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'Contracts'             , 'Contracts.LNK_ARCHIVED_CONTRACTS'             , '~/Contracts/default.aspx?ArchiveView=1'              , 'Contracts.gif'             , 1,  -1, 'Contracts'      , 'archive';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Quotes'                , 'Quotes.LNK_ARCHIVED_QUOTES'                   , '~/Quotes/default.aspx?ArchiveView=1'                 , 'Quotes.gif'                , 1,  -1, 'Quotes'         , 'archive';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Orders'                , 'Orders.LNK_ARCHIVED_ORDERS'                   , '~/Orders/default.aspx?ArchiveView=1'                 , 'Orders.gif'                , 1,  -1, 'Orders'         , 'archive';
	exec dbo.spSHORTCUTS_InsertOnly null, 'Invoices'              , 'Invoices.LNK_ARCHIVED_INVOICES'               , '~/Invoices/default.aspx?ArchiveView=1'               , 'Invoices.gif'              , 1,  -1, 'Invoices'       , 'archive';
	exec dbo.spSHORTCUTS_InsertOnly null, 'KBDocuments'           , 'KBDocuments.LNK_ARCHIVED_Quotes'              , '~/KBDocuments/default.aspx?ArchiveView=1'            , 'KBDocuments.gif'           , 1,  -1, 'KBDocuments'    , 'archive';
end -- if;
GO

-- 02/17/2018 Paul.  ModulesArchiveRules module to Professional. 
if not exists (select * from SHORTCUTS where MODULE_NAME = 'ModulesArchiveRules' and DELETED = 0) begin -- then
	exec dbo.spSHORTCUTS_InsertOnly null, 'ModulesArchiveRules'   , 'ModulesArchiveRules.LNK_NEW_ARCHIVE_RULE'     , '~/Administration/ModulesArchiveRules/edit.aspx'      , 'ModulesArchiveRules.gif'   , 1,  1, 'ModulesArchiveRules'      , 'edit';
	exec dbo.spSHORTCUTS_InsertOnly null, 'ModulesArchiveRules'   , 'ModulesArchiveRules.LNK_ARCHIVE_RULE_LIST'    , '~/Administration/ModulesArchiveRules/default.aspx'   , 'ModulesArchiveRules.gif'   , 1,  2, 'ModulesArchiveRules'      , 'list';
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

call dbo.spSHORTCUTS_Professional()
/

call dbo.spSqlDropProcedure('spSHORTCUTS_Professional')
/

-- #endif IBM_DB2 */


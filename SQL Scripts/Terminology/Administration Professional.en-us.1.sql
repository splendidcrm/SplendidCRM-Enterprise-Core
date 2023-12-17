

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:35 AM.
print 'TERMINOLOGY Administration Professional en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTRACT_TYPES_DESC'                       , N'en-US', N'Administration', null, null, N'Manage Contract Types.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTRACT_TYPES_TITLE'                      , N'en-US', N'Administration', null, null, N'Contract Types';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTRACTS_TITLE'                           , N'en-US', N'Administration', null, null, N'Contracts';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISCOUNTS_DESC'                            , N'en-US', N'Administration', null, null, N'Manage Discounts.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISCOUNTS_TITLE'                           , N'en-US', N'Administration', null, null, N'Discounts';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FORUM_TOPICS'                              , N'en-US', N'Administration', null, null, N'Forum Topics';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FORUM_TOPICS_DESC'                         , N'en-US', N'Administration', null, null, N'Manage Forum Topics.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FORUM_TOPICS_TITLE'                        , N'en-US', N'Administration', null, null, N'Forum Topics';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANUFACTURERS_DESC'                        , N'en-US', N'Administration', null, null, N'Manage Manufacturers.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANUFACTURERS_TITLE'                       , N'en-US', N'Administration', null, null, N'Manufacturers';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_BUILDER'                            , N'en-US', N'Administration', null, null, N'Manage Module Builder.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_BUILDER_TITLE'                      , N'en-US', N'Administration', null, null, N'Module Builder';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_GATEWAY'                           , N'en-US', N'Administration', null, null, N'Manage Payment Gateway.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_GATEWAY_TITLE'                     , N'en-US', N'Administration', null, null, N'Payment Gateway';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRODUCT_CATEGORIES_DESC'                   , N'en-US', N'Administration', null, null, N'Manage Product Categories.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRODUCT_CATEGORIES_TITLE'                  , N'en-US', N'Administration', null, null, N'Product Categories';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRODUCT_TEMPLATES_DESC'                    , N'en-US', N'Administration', null, null, N'Manage Product Catalog.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRODUCT_TEMPLATES_TITLE'                   , N'en-US', N'Administration', null, null, N'Product Catalog';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRODUCT_TYPES_DESC'                        , N'en-US', N'Administration', null, null, N'Manage Product Types.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRODUCT_TYPES_TITLE'                       , N'en-US', N'Administration', null, null, N'Product Types';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRODUCTS_QUOTES_TITLE'                     , N'en-US', N'Administration', null, null, N'Products Quotes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REGIONS_DESC'                              , N'en-US', N'Administration', null, null, N'Manage Regions.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REGIONS_TITLE'                             , N'en-US', N'Administration', null, null, N'Regions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPERS_DESC'                             , N'en-US', N'Administration', null, null, N'Manage Shippers.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPERS_TITLE'                            , N'en-US', N'Administration', null, null, N'Shippers';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYSTEM_SYNC_LOG'                           , N'en-US', N'Administration', null, null, N'System Sync Log';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYSTEM_SYNC_LOG_DESC'                      , N'en-US', N'Administration', null, null, N'View System Sync Log.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEAMS_DESC'                                , N'en-US', N'Administration', null, null, N'Manage Teams.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEAMS_TITLE'                               , N'en-US', N'Administration', null, null, N'Teams';
-- 02/15/2015 Paul.  Add payment types. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_TYPES_DESC'                        , N'en-US', N'Administration', null, null, N'Manage Payment Types.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_TYPES_TITLE'                       , N'en-US', N'Administration', null, null, N'Payment Types';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_TERMS_DESC'                        , N'en-US', N'Administration', null, null, N'Manage Payment Terms.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_TERMS_TITLE'                       , N'en-US', N'Administration', null, null, N'Payment Terms';
-- 01/01/2016 Paul.  Combine PayPal, PayTrace and AuthorizeNet into a single panel. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_SERVICES_TITLE'                    , N'en-US', N'Administration', null, null, N'Payment Services';
-- 01/01/2016 Paul.  Combine Asterisk and Avaya into a single panel. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VOIP_SERVICES_TITLE'                       , N'en-US', N'Administration', null, null, N'VoIP Services';

-- 08/07/2015 Paul.  Revenue Line Items. 
-- delete from TERMINOLOGY where NAME like 'LBL_OPPORTUNITIES_MODE_%';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPPORTUNITIES_MODE_INSTRUCTIONS'           , N'en-US', N'Administration', null, null, N'Opportunities can be configured to support multiple line items to support a more granular level of tracking.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPPORTUNITIES_MODE_OPPORTUNITIES'          , N'en-US', N'Administration', null, null, N'Opportunities';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPPORTUNITIES_MODE_REVENUE'                , N'en-US', N'Administration', null, null, N'Opportunities with Revenue Line Items';
GO


set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_Administration_Professional_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Administration_Professional_en_us')
/
-- #endif IBM_DB2 */

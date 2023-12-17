

print 'TERMINOLOGY QuickBooks en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUICKBOOKS_SETTINGS'                       , N'en-US', N'QuickBooks', null, null, N'QuickBooks Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_QUICKBOOKS'                         , N'en-US', N'QuickBooks', null, null, N'Configure QuickBooks Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_QUICKBOOKS_TITLE'                   , N'en-US', N'QuickBooks', null, null, N'QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'QuickBooks', null, null, N'In order to sync with QuickBooks, you install RSSBus ADO.NET Data Provider for QuickBooks on the computer running QuickBooks.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ENABLED'                                   , N'en-US', N'QuickBooks', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'QuickBooks', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'QuickBooks', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'QuickBooks', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_QUOTES'                               , N'en-US', N'QuickBooks', null, null, N'Sync Quotes to Estimates:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_ORDERS'                               , N'en-US', N'QuickBooks', null, null, N'Sync Orders to Sales Orders:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_INVOICES'                             , N'en-US', N'QuickBooks', null, null, N'Sync Invoices to Invoices:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_PAYMENTS'                             , N'en-US', N'QuickBooks', null, null, N'Sync Payments to Payments:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_CREDIT_MEMOS'                         , N'en-US', N'QuickBooks', null, null, N'Sync Refund Payments to Credit Memos:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENTS_DEPOSIT_ACCOUNT'                  , N'en-US', N'QuickBooks', null, null, N'Payments Deposit Account:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'QuickBooks', null, null, N'Connection successful.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_TAX_RATES'                       , N'en-US', N'QuickBooks', null, null, N'Tax Rates not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_SHIPPERS'                        , N'en-US', N'QuickBooks', null, null, N'Shippers not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_PRODUCT_TEMPLATES'               , N'en-US', N'QuickBooks', null, null, N'Product Templates not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_ACCOUNTS'                        , N'en-US', N'QuickBooks', null, null, N'Accounts not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_QUOTES'                          , N'en-US', N'QuickBooks', null, null, N'Quotes not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_INVOICES'                        , N'en-US', N'QuickBooks', null, null, N'Invoices not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_ORDERS'                          , N'en-US', N'QuickBooks', null, null, N'Orders not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_PAYMENTS'                        , N'en-US', N'QuickBooks', null, null, N'Payments not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_CREDIT_MEMOS'                    , N'en-US', N'QuickBooks', null, null, N'Credit Memos not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_PAYMENT_TYPES'                   , N'en-US', N'QuickBooks', null, null, N'Payment Types not synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_SYNCD_PAYMENT_TERMS'                   , N'en-US', N'QuickBooks', null, null, N'Payment Terms not synchronized';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_TAX_RATES'                           , N'en-US', N'QuickBooks', null, null, N'Tax Rates synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_SHIPPERS'                            , N'en-US', N'QuickBooks', null, null, N'Shippers synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_PRODUCT_TEMPLATES'                   , N'en-US', N'QuickBooks', null, null, N'Product Templates synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_ACCOUNTS'                            , N'en-US', N'QuickBooks', null, null, N'Accounts synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_QUOTES'                              , N'en-US', N'QuickBooks', null, null, N'Quotes synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_INVOICES'                            , N'en-US', N'QuickBooks', null, null, N'Invoices synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_ORDERS'                              , N'en-US', N'QuickBooks', null, null, N'Orders synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_PAYMENTS'                            , N'en-US', N'QuickBooks', null, null, N'Payments synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_CREDIT_MEMOS'                        , N'en-US', N'QuickBooks', null, null, N'Credit Memos synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_PAYMENT_TYPES'                       , N'en-US', N'QuickBooks', null, null, N'Payment Types synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNCD_PAYMENT_TERMS'                       , N'en-US', N'QuickBooks', null, null, N'Payment Terms synchronized';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUICKBOOKS_APP'                            , N'en-US', N'QuickBooks', null, null, N'QuickBooks App:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUICKBOOKS_APP_REMOTE'                     , N'en-US', N'QuickBooks', null, null, N'QuickBooks Pro/Premium/Enterprise';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUICKBOOKS_APP_ONLINE'                     , N'en-US', N'QuickBooks', null, null, N'QuickBooks Online';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REMOTE_USER'                               , N'en-US', N'QuickBooks', null, null, N'Remote User:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REMOTE_PASSWORD'                           , N'en-US', N'QuickBooks', null, null, N'Remote Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REMOTE_URL'                                , N'en-US', N'QuickBooks', null, null, N'Remote URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REMOTE_APPLICATION'                        , N'en-US', N'QuickBooks', null, null, N'Remote App Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_COMPANY_ID'                          , N'en-US', N'QuickBooks', null, null, N'Company ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_COUNTRY_CODE'                        , N'en-US', N'QuickBooks', null, null, N'Country Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                           , N'en-US', N'QuickBooks', null, null, N'OAuth Client ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                       , N'en-US', N'QuickBooks', null, null, N'OAuth Client Secret:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                        , N'en-US', N'QuickBooks', null, null, N'OAuth Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_SECRET'                       , N'en-US', N'QuickBooks', null, null, N'OAuth Access Token Secret:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_VERIFIER'                            , N'en-US', N'QuickBooks', null, null, N'OAuth Verifier:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_EXPIRES_AT'                          , N'en-US', N'QuickBooks', null, null, N'OAuth Access Token Expires:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                    , N'en-US', N'QuickBooks', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RECONNECT_BUTTON_LABEL'                    , N'en-US', N'QuickBooks', null, null, N'Reconnect';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_ITEMS'                                , N'en-US', N'QuickBooks', null, null, N'View Items in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_TAX_RATES'                            , N'en-US', N'QuickBooks', null, null, N'View Tax Rates in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_TAX_CODE'                             , N'en-US', N'QuickBooks', null, null, N'View Tax Codes in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_SHIPPERS'                             , N'en-US', N'QuickBooks', null, null, N'View Shippers in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_CUSTOMERS'                            , N'en-US', N'QuickBooks', null, null, N'View Customers in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_INVOICES'                             , N'en-US', N'QuickBooks', null, null, N'View Invoices in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_SALES_ORDERS'                         , N'en-US', N'QuickBooks', null, null, N'View Sales Orders in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_ESTIMATES'                            , N'en-US', N'QuickBooks', null, null, N'View Estimates in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_PAYMENTS'                             , N'en-US', N'QuickBooks', null, null, N'View Payments in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_CREDIT_MEMOS'                         , N'en-US', N'QuickBooks', null, null, N'View Credit Memos in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_PAYMENT_TYPES'                        , N'en-US', N'QuickBooks', null, null, N'View Payments Types in QuickBooks';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_PAYMENT_TERMS'                        , N'en-US', N'QuickBooks', null, null, N'View Payments Terms in QuickBooks';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHOW_SYNCHRONIZED'                         , N'en-US', N'QuickBooks', null, null, N'Show Synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHOW_NOT_SYNCHRONIZED'                     , N'en-US', N'QuickBooks', null, null, N'Show Not Synchronized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'QuickBooks', null, null, N'Sync will be performed in a background thread.';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'QuickBooks', null, null, N'QB';

GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'QuickBooks'                                    , N'en-US', null, N'moduleList'                        , 110, N'QuickBooks';

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                , N'en-US', null, N'quickbooks_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                   , N'en-US', null, N'quickbooks_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                 , N'en-US', null, N'quickbooks_sync_direction'         ,   3, N'from crm only';

exec dbo.spTERMINOLOGY_InsertOnly N'remote'                                        , N'en-US', null, N'sync_conflict_resolution'          ,   1, N'remote';
exec dbo.spTERMINOLOGY_InsertOnly N'local'                                         , N'en-US', null, N'sync_conflict_resolution'          ,   2, N'local';

exec dbo.spTERMINOLOGY_InsertOnly N'Remote'                                        , N'en-US', null, N'quickbooks_app_mode'               ,   1, N'QuickBooks Pro/Premium/Enterprise';
exec dbo.spTERMINOLOGY_InsertOnly N'Online'                                        , N'en-US', null, N'quickbooks_app_mode'               ,   2, N'QuickBooks Online';
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

call dbo.spTERMINOLOGY_QuickBooks_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_QuickBooks_en_us')
/
-- #endif IBM_DB2 */



print 'TERMINOLOGY PayTrace en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'PayTrace';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYTRACE_TITLE'                            , N'en-US', N'PayTrace', null, null, N'PayTrace';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYTRACE_SETTINGS'                         , N'en-US', N'PayTrace', null, null, N'PayTrace Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYTRACE_SETTINGS_DESC'                    , N'en-US', N'PayTrace', null, null, N'Configure PayTrace settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYTRACE_TRANSACTIONS'                     , N'en-US', N'PayTrace', null, null, N'PayTrace Transactions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYTRACE_TRANSACTIONS_DESC'                , N'en-US', N'PayTrace', null, null, N'Allows the import of transactions from the PayTrace service.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ENABLED'                                   , N'en-US', N'PayTrace', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_NAME'                                 , N'en-US', N'PayTrace', null, null, N'User Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PASSWORD'                                  , N'en-US', N'PayTrace', null, null, N'Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_BUTTON_LABEL'                         , N'en-US', N'PayTrace', null, null, N'Test';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONNECTION_SUCCESSFUL'                     , N'en-US', N'PayTrace', null, null, N'Connection successful';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_FAILED_TO_CONNECT'                         , N'en-US', N'PayTrace', null, null, N'Failed to connect: {0}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_START_DATE'                                , N'en-US', N'PayTrace', null, null, N'Start Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_END_DATE'                                  , N'en-US', N'PayTrace', null, null, N'End Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANSACTION_TYPE'                          , N'en-US', N'PayTrace', null, null, N'Transaction Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_TEXT'                               , N'en-US', N'PayTrace', null, null, N'Search Text:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'PayTrace', null, null, N'PayTrace Transactions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'PayTrace', null, null, N'Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINE_ITEMS'                                , N'en-US', N'PayTrace', null, null, N'Line Items';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_BUTTON_LABEL'                       , N'en-US', N'PayTrace', null, null, N'Import';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFUND_BUTTON_LABEL'                       , N'en-US', N'PayTrace', null, null, N'Refund';
exec dbo.spTERMINOLOGY_InsertOnly N'NTC_REFUND_CONFIRMATION'                       , N'en-US', N'PayTrace', null, null, N'Are you sure you want to refund the transaction?';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANXID'                                   , N'en-US', N'PayTrace', null, null, N'Transaction ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CC'                                        , N'en-US', N'PayTrace', null, null, N'Credit Card Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXPIRATION_DATE'                           , N'en-US', N'PayTrace', null, null, N'Expiration Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXPMNTH'                                   , N'en-US', N'PayTrace', null, null, N'Expiration Month:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXPYR'                                     , N'en-US', N'PayTrace', null, null, N'Expiration Year:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANXTYPE'                                 , N'en-US', N'PayTrace', null, null, N'Transaction Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'PayTrace', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMOUNT'                                    , N'en-US', N'PayTrace', null, null, N'Amount:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INVOICE'                                   , N'en-US', N'PayTrace', null, null, N'Invoice:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SNAME'                                     , N'en-US', N'PayTrace', null, null, N'Shipping Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SADDRESS'                                  , N'en-US', N'PayTrace', null, null, N'Shipping Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SADDRESS2'                                 , N'en-US', N'PayTrace', null, null, N'Shipping Address 2:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SCITY'                                     , N'en-US', N'PayTrace', null, null, N'Shipping City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SCOUNTY'                                   , N'en-US', N'PayTrace', null, null, N'Shipping County:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SSTATE'                                    , N'en-US', N'PayTrace', null, null, N'Shipping State:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SZIP'                                      , N'en-US', N'PayTrace', null, null, N'Shipping Zip:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SCOUNTRY'                                  , N'en-US', N'PayTrace', null, null, N'Shipping Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BNAME'                                     , N'en-US', N'PayTrace', null, null, N'Billing Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BADDRESS'                                  , N'en-US', N'PayTrace', null, null, N'Billing Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BADDRESS2'                                 , N'en-US', N'PayTrace', null, null, N'Billing Address 2:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BCITY'                                     , N'en-US', N'PayTrace', null, null, N'Billing City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BSTATE'                                    , N'en-US', N'PayTrace', null, null, N'Billing State:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BZIP'                                      , N'en-US', N'PayTrace', null, null, N'Billing Zip:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BCOUNTRY'                                  , N'en-US', N'PayTrace', null, null, N'Billing Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL'                                     , N'en-US', N'PayTrace', null, null, N'Email:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TAX'                                       , N'en-US', N'PayTrace', null, null, N'Tax:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTREF'                                   , N'en-US', N'PayTrace', null, null, N'Customer Reference:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APPROVAL'                                  , N'en-US', N'PayTrace', null, null, N'Approval:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APPMSG'                                    , N'en-US', N'PayTrace', null, null, N'App Message:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AVSRESPONSE'                               , N'en-US', N'PayTrace', null, null, N'AVS Response:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CSCRESPONSE'                               , N'en-US', N'PayTrace', null, null, N'CSC Response:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'PayTrace', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUSDESCRIPTION'                         , N'en-US', N'PayTrace', null, null, N'Status Desc:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_METHOD'                                    , N'en-US', N'PayTrace', null, null, N'Method:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WHEN'                                      , N'en-US', N'PayTrace', null, null, N'Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SETTLED'                                   , N'en-US', N'PayTrace', null, null, N'Settled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER'                                      , N'en-US', N'PayTrace', null, null, N'User:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IP'                                        , N'en-US', N'PayTrace', null, null, N'IP:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTID'                                    , N'en-US', N'PayTrace', null, null, N'Customer ID:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRANXID'                              , N'en-US', N'PayTrace', null, null, N'Transaction ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CC'                                   , N'en-US', N'PayTrace', null, null, N'Credit Card Number';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EXPMNTH'                              , N'en-US', N'PayTrace', null, null, N'Expiration Month';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EXPYR'                                , N'en-US', N'PayTrace', null, null, N'Expiration Year';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRANXTYPE'                            , N'en-US', N'PayTrace', null, null, N'Transaction Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'PayTrace', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AMOUNT'                               , N'en-US', N'PayTrace', null, null, N'Amount';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_INVOICE'                              , N'en-US', N'PayTrace', null, null, N'Invoice';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SNAME'                                , N'en-US', N'PayTrace', null, null, N'Shipping Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SADDRESS'                             , N'en-US', N'PayTrace', null, null, N'Shipping Address';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SADDRESS2'                            , N'en-US', N'PayTrace', null, null, N'Shipping Address 2';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SCITY'                                , N'en-US', N'PayTrace', null, null, N'Shipping City';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SCOUNTY'                              , N'en-US', N'PayTrace', null, null, N'Shipping County';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SSTATE'                               , N'en-US', N'PayTrace', null, null, N'Shipping State';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SZIP'                                 , N'en-US', N'PayTrace', null, null, N'Shipping Zip';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SCOUNTRY'                             , N'en-US', N'PayTrace', null, null, N'Shipping Country';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BNAME'                                , N'en-US', N'PayTrace', null, null, N'Billing Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BADDRESS'                             , N'en-US', N'PayTrace', null, null, N'Billing Address';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BADDRESS2'                            , N'en-US', N'PayTrace', null, null, N'Billing Address 2';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BCITY'                                , N'en-US', N'PayTrace', null, null, N'Billing City';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BSTATE'                               , N'en-US', N'PayTrace', null, null, N'Billing State';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BZIP'                                 , N'en-US', N'PayTrace', null, null, N'Billing Zip';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BCOUNTRY'                             , N'en-US', N'PayTrace', null, null, N'Billing Country';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EMAIL'                                , N'en-US', N'PayTrace', null, null, N'Email';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TAX'                                  , N'en-US', N'PayTrace', null, null, N'Tax';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CUSTREF'                              , N'en-US', N'PayTrace', null, null, N'Customer Reference';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_APPROVAL'                             , N'en-US', N'PayTrace', null, null, N'Approval';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_APPMSG'                               , N'en-US', N'PayTrace', null, null, N'App Message';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AVSRESPONSE'                          , N'en-US', N'PayTrace', null, null, N'AVS Response';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CSCRESPONSE'                          , N'en-US', N'PayTrace', null, null, N'CSC Response';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'PayTrace', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUSDESCRIPTION'                    , N'en-US', N'PayTrace', null, null, N'Status Desc';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_METHOD'                               , N'en-US', N'PayTrace', null, null, N'Method';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_WHEN'                                 , N'en-US', N'PayTrace', null, null, N'Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SETTLED'                              , N'en-US', N'PayTrace', null, null, N'Settled';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_USER'                                 , N'en-US', N'PayTrace', null, null, N'User';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_IP'                                   , N'en-US', N'PayTrace', null, null, N'IP';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CUSTID'                               , N'en-US', N'PayTrace', null, null, N'Customer ID';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'PayTrace', null, null, N'PTr';

GO

exec dbo.spTERMINOLOGY_InsertOnly N'PayTrace'                                      , N'en-US', null, N'moduleList', 117, N'PayTrace';

-- delete from TERMINOLOGY where LIST_NAME = 'paytrace_transaction_type';
exec dbo.spTERMINOLOGY_InsertOnly N'Sale'                                          , N'en-US', null, N'paytrace_transaction_type',  1, N'Sale';
exec dbo.spTERMINOLOGY_InsertOnly N'Authorization'                                 , N'en-US', null, N'paytrace_transaction_type',  2, N'Authorization';
exec dbo.spTERMINOLOGY_InsertOnly N'Str/Fwd'                                       , N'en-US', null, N'paytrace_transaction_type',  3, N'Store &amp; Forward';
exec dbo.spTERMINOLOGY_InsertOnly N'Refund'                                        , N'en-US', null, N'paytrace_transaction_type',  4, N'Refund';
exec dbo.spTERMINOLOGY_InsertOnly N'Void'                                          , N'en-US', null, N'paytrace_transaction_type',  5, N'Void';
exec dbo.spTERMINOLOGY_InsertOnly N'Capture'                                       , N'en-US', null, N'paytrace_transaction_type',  6, N'Capture';
exec dbo.spTERMINOLOGY_InsertOnly N'Force'                                         , N'en-US', null, N'paytrace_transaction_type',  7, N'Force';
exec dbo.spTERMINOLOGY_InsertOnly N'Settled'                                       , N'en-US', null, N'paytrace_transaction_type',  8, N'Settled';
exec dbo.spTERMINOLOGY_InsertOnly N'Pending'                                       , N'en-US', null, N'paytrace_transaction_type',  9, N'Pending Settlement';
exec dbo.spTERMINOLOGY_InsertOnly N'Declined'                                      , N'en-US', null, N'paytrace_transaction_type', 10, N'Declined';
exec dbo.spTERMINOLOGY_InsertOnly N'FORCED SALE'                                   , N'en-US', null, N'paytrace_transaction_type', 11, N'Forced Sale';
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

call dbo.spTERMINOLOGY_PayTrace_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_PayTrace_en_us')
/
-- #endif IBM_DB2 */

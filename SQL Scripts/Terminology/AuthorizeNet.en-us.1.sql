

print 'TERMINOLOGY AuthorizeNet en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'AuthorizeNet';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZENET_TITLE'                        , N'en-US', N'AuthorizeNet', null, null, N'AuthorizeNet';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZENET_SETTINGS'                     , N'en-US', N'AuthorizeNet', null, null, N'AuthorizeNet Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZENET_SETTINGS_DESC'                , N'en-US', N'AuthorizeNet', null, null, N'Configure AuthorizeNet settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZENET_TRANSACTIONS'                 , N'en-US', N'AuthorizeNet', null, null, N'AuthorizeNet Transactions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZENET_TRANSACTIONS_DESC'            , N'en-US', N'AuthorizeNet', null, null, N'List transactions from the AuthorizeNet service.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZENET_CUSTOMER_PROFILES'            , N'en-US', N'AuthorizeNet', null, null, N'AuthorizeNet Customer Profiles';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZENET_CUSTOMER_PROFILES_DESC'       , N'en-US', N'AuthorizeNet', null, null, N'List customer profiles from the AuthorizeNet service.';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_AUTHORIZENET_SETTINGS'                     , N'en-US', N'AuthorizeNet', null, null, N'AuthorizeNet Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_AUTHORIZENET_TRANSACTIONS'                 , N'en-US', N'AuthorizeNet', null, null, N'Transactions';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_AUTHORIZENET_CUSTOMER_PROFILES'            , N'en-US', N'AuthorizeNet', null, null, N'Customer Profiles';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ENABLED'                                   , N'en-US', N'AuthorizeNet', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_NAME'                                 , N'en-US', N'AuthorizeNet', null, null, N'User Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANSACTION_KEY'                           , N'en-US', N'AuthorizeNet', null, null, N'Transaction Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_BUTTON_LABEL'                         , N'en-US', N'AuthorizeNet', null, null, N'Test';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONNECTION_SUCCESSFUL'                     , N'en-US', N'AuthorizeNet', null, null, N'Connection successful';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_FAILED_TO_CONNECT'                         , N'en-US', N'AuthorizeNet', null, null, N'Failed to connect: {0}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFUND_BUTTON_LABEL'                       , N'en-US', N'AuthorizeNet', null, null, N'Refund';
exec dbo.spTERMINOLOGY_InsertOnly N'NTC_REFUND_CONFIRMATION'                       , N'en-US', N'AuthorizeNet', null, null, N'Are you sure you want to refund the transaction?';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_MODE'                                 , N'en-US', N'AuthorizeNet', null, null, N'Test Mode:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_TEXT'                               , N'en-US', N'AuthorizeNet', null, null, N'Search Text:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'AuthorizeNet', null, null, N'Authorize.Net Transactions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'AuthorizeNet', null, null, N'Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_BUTTON_LABEL'                       , N'en-US', N'AuthorizeNet', null, null, N'Import';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINE_ITEMS'                                , N'en-US', N'AuthorizeNet', null, null, N'Line Items';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_START_DATE'                                , N'en-US', N'AuthorizeNet', null, null, N'Start Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_END_DATE'                                  , N'en-US', N'AuthorizeNet', null, null, N'End Date:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRANS_ID'                             , N'en-US', N'AuthorizeNet', null, null, N'Transaction ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SUBMIT_TIME_LOCAL'                    , N'en-US', N'AuthorizeNet', null, null, N'Submit Time';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRANSACTION_STATUS'                   , N'en-US', N'AuthorizeNet', null, null, N'Transaction Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BILLTO_FIRST_NAME'                    , N'en-US', N'AuthorizeNet', null, null, N'First Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BILLTO_LAST_NAME'                     , N'en-US', N'AuthorizeNet', null, null, N'Last Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ACCOUNT_TYPE'                         , N'en-US', N'AuthorizeNet', null, null, N'Account Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ACCOUNT_NUMBER'                       , N'en-US', N'AuthorizeNet', null, null, N'Accout Number';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SETTLE_AMOUNT'                        , N'en-US', N'AuthorizeNet', null, null, N'Amount';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ITEM_QUANTITY'                        , N'en-US', N'AuthorizeNet', null, null, N'Quantity'                    ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ITEM_ITEM_ID'                         , N'en-US', N'AuthorizeNet', null, null, N'Item Id'                     ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ITEM_NAME'                            , N'en-US', N'AuthorizeNet', null, null, N'Name'                        ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ITEM_DESCRIPTION'                     , N'en-US', N'AuthorizeNet', null, null, N'Description'                 ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ITEM_UNIT_PRICE'                      , N'en-US', N'AuthorizeNet', null, null, N'Unit Price'                  ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ITEM_TAXABLE'                         , N'en-US', N'AuthorizeNet', null, null, N'Taxable'                     ;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANS_ID'                                  , N'en-US', N'AuthorizeNet', null, null, N'Transaction Id:'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFTRANS_ID'                               , N'en-US', N'AuthorizeNet', null, null, N'Reference Trans Id:'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUBMIT_TIME_UTC'                           , N'en-US', N'AuthorizeNet', null, null, N'Submit Time UTC:'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUBMIT_TIME_LOCAL'                         , N'en-US', N'AuthorizeNet', null, null, N'Submit Time Local:'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANSACTION_TYPE'                          , N'en-US', N'AuthorizeNet', null, null, N'Transaction Type:'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANSACTION_STATUS'                        , N'en-US', N'AuthorizeNet', null, null, N'Transaction Status:'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RESPONSE_CODE'                             , N'en-US', N'AuthorizeNet', null, null, N'Response Code:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RESPONSE_REASON_CODE'                      , N'en-US', N'AuthorizeNet', null, null, N'Response Reason Code:'       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RESPONSE_REASON_DESCRIPTION'               , N'en-US', N'AuthorizeNet', null, null, N'Response Reason Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTH_CODE'                                 , N'en-US', N'AuthorizeNet', null, null, N'Auth Code:'                  ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AVS_RESPONSE'                              , N'en-US', N'AuthorizeNet', null, null, N'AVS Response:'               ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BATCH_ID'                                  , N'en-US', N'AuthorizeNet', null, null, N'Batch Id:'                   ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SETTLEMENT_TIME_UTC'                       , N'en-US', N'AuthorizeNet', null, null, N'Settlement Time UTC:'        ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SETTLEMENT_TIME_LOCAL'                     , N'en-US', N'AuthorizeNet', null, null, N'Settlement Time Local:'      ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SETTLEMENT_STATE'                          , N'en-US', N'AuthorizeNet', null, null, N'Settlement State:'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTH_AMOUNT'                               , N'en-US', N'AuthorizeNet', null, null, N'Auth Amount:'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SETTLE_AMOUNT'                             , N'en-US', N'AuthorizeNet', null, null, N'Settle Amount:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TAX_EXEMPT'                                , N'en-US', N'AuthorizeNet', null, null, N'Tax Exempt:'                 ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RECURRING_BILLING'                         , N'en-US', N'AuthorizeNet', null, null, N'Recurring Billing:'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRODUCT'                                   , N'en-US', N'AuthorizeNet', null, null, N'Product:'                    ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MARKET_TYPE'                               , N'en-US', N'AuthorizeNet', null, null, N'Market Type:'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREDITCARD_CARD_NUMBER'                    , N'en-US', N'AuthorizeNet', null, null, N'Credit Card Number:'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREDITCARD_EXPIRATION_DATE'                , N'en-US', N'AuthorizeNet', null, null, N'Credit Card Expiration Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREDITCARD_CARD_TYPE'                      , N'en-US', N'AuthorizeNet', null, null, N'Credit Card Type:'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BANKACCOUNT_ROUTING_NUMBER'                , N'en-US', N'AuthorizeNet', null, null, N'Bank Routing Number:'        ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BANKACCOUNT_ACCOUNT_NUMBER'                , N'en-US', N'AuthorizeNet', null, null, N'Bank Account Number:'        ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BANKACCOUNT_NAME_ON_ACCOUNT'               , N'en-US', N'AuthorizeNet', null, null, N'Bank Name On Account:'       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BANKACCOUNT_BANK_NAME'                     , N'en-US', N'AuthorizeNet', null, null, N'Bank Account Bank Name:'     ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BANKACCOUNT_ACCOUNT_TYPE'                  , N'en-US', N'AuthorizeNet', null, null, N'Bank Account Type:'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BANKACCOUNT_ECHECK_TYPE'                   , N'en-US', N'AuthorizeNet', null, null, N'Bank Account eCheck Type:'   ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TOKEN_TOKEN_SOURCE'                        , N'en-US', N'AuthorizeNet', null, null, N'Token Source'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TOKEN_TOKEN_NUMBER'                        , N'en-US', N'AuthorizeNet', null, null, N'Token Number'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TOKEN_EXPIRATION_DATE'                     , N'en-US', N'AuthorizeNet', null, null, N'Token Expiration Date'       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOMER_ID'                               , N'en-US', N'AuthorizeNet', null, null, N'Customer Id:'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOMER_TYPE'                             , N'en-US', N'AuthorizeNet', null, null, N'Customer Type:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOMER_EMAIL'                            , N'en-US', N'AuthorizeNet', null, null, N'Customer Email:'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_FIRST_NAME'                         , N'en-US', N'AuthorizeNet', null, null, N'Bill To First Name:'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_LAST_NAME'                          , N'en-US', N'AuthorizeNet', null, null, N'Bill To Last Name:'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_ADDRESS'                            , N'en-US', N'AuthorizeNet', null, null, N'Bill To Address:'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_CITY'                               , N'en-US', N'AuthorizeNet', null, null, N'Bill To City:'               ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_STATE'                              , N'en-US', N'AuthorizeNet', null, null, N'Bill To State:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_ZIP'                                , N'en-US', N'AuthorizeNet', null, null, N'Bill To Zip:'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_COUNTRY'                            , N'en-US', N'AuthorizeNet', null, null, N'Bill To Country:'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_PHONE_NUMBER'                       , N'en-US', N'AuthorizeNet', null, null, N'Bill To Phone Number:'       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_FAX_NUMBER'                         , N'en-US', N'AuthorizeNet', null, null, N'Bill To Fax Number:'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLTO_EMAIL'                              , N'en-US', N'AuthorizeNet', null, null, N'Bill To Email:'              ;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BILLTO_FIRST_NAME'                    , N'en-US', N'AuthorizeNet', null, null, N'First Name'                  ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BILLTO_LAST_NAME'                     , N'en-US', N'AuthorizeNet', null, null, N'Last Name'                   ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BILLTO_EMAIL'                         , N'en-US', N'AuthorizeNet', null, null, N'Email'                       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CREDITCARD_CARD_TYPE'                 , N'en-US', N'AuthorizeNet', null, null, N'Card Type'                   ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CREDITCARD_CARD_NUMBER'               , N'en-US', N'AuthorizeNet', null, null, N'Card Number'                 ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BANKACCOUNT_BANK_NAME'                , N'en-US', N'AuthorizeNet', null, null, N'Bank Name'                   ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BANKACCOUNT_ACCOUNT_NUMBER'           , N'en-US', N'AuthorizeNet', null, null, N'bAccount Number'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TOKEN_TOKEN_NUMBER'                   , N'en-US', N'AuthorizeNet', null, null, N'Token Number'                ;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOMER_PROFILES'                         , N'en-US', N'AuthorizeNet', null, null, N'Customer Profiles'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_PROFILES'                          , N'en-US', N'AuthorizeNet', null, null, N'Payment Profiles'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_ADDRESSES'                        , N'en-US', N'AuthorizeNet', null, null, N'Shipping Addresses'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOMER_TYPE'                             , N'en-US', N'AuthorizeNet', null, null, N'Customer Type:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOMER_PROFILE_ID'                       , N'en-US', N'AuthorizeNet', null, null, N'Customer Profile Id:'        ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MERCHANT_CUSTOMER_ID'                      , N'en-US', N'AuthorizeNet', null, null, N'Merchant Customer Id:'       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'AuthorizeNet', null, null, N'Description:'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL'                                     , N'en-US', N'AuthorizeNet', null, null, N'Email:'                      ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRST_NAME'                                , N'en-US', N'AuthorizeNet', null, null, N'First Name:'                 ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_NAME'                                 , N'en-US', N'AuthorizeNet', null, null, N'Last Name:'                  ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS'                                   , N'en-US', N'AuthorizeNet', null, null, N'Address:'                    ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CITY'                                      , N'en-US', N'AuthorizeNet', null, null, N'City:'                       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATE'                                     , N'en-US', N'AuthorizeNet', null, null, N'State:'                      ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ZIP'                                       , N'en-US', N'AuthorizeNet', null, null, N'Zip:'                        ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRY'                                   , N'en-US', N'AuthorizeNet', null, null, N'Country:'                    ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE_NUMBER'                              , N'en-US', N'AuthorizeNet', null, null, N'Phone Number:'               ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FAX_NUMBER'                                , N'en-US', N'AuthorizeNet', null, null, N'Fax Number:'                 ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL'                                     , N'en-US', N'AuthorizeNet', null, null, N'Email:'                      ;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CUSTOMER_PROFILE_ID'                  , N'en-US', N'AuthorizeNet', null, null, N'Customer Profile Id'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MERCHANT_CUSTOMER_ID'                 , N'en-US', N'AuthorizeNet', null, null, N'Merchant Customer Id'        ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CUSTOMER_ADDRESS_ID'                  , N'en-US', N'AuthorizeNet', null, null, N'Customer Address Id'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CUSTOMER_PAYMENT_PROFILE_ID'          , N'en-US', N'AuthorizeNet', null, null, N'Payment Profile Id'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'AuthorizeNet', null, null, N'Description'                 ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FIRST_NAME'                           , N'en-US', N'AuthorizeNet', null, null, N'First Name'                  ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_NAME'                            , N'en-US', N'AuthorizeNet', null, null, N'Last Name'                   ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ADDRESS'                              , N'en-US', N'AuthorizeNet', null, null, N'Address'                     ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CITY'                                 , N'en-US', N'AuthorizeNet', null, null, N'City'                        ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATE'                                , N'en-US', N'AuthorizeNet', null, null, N'State'                       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ZIP'                                  , N'en-US', N'AuthorizeNet', null, null, N'Zip'                         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_COUNTRY'                              , N'en-US', N'AuthorizeNet', null, null, N'Country'                     ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PHONE_NUMBER'                         , N'en-US', N'AuthorizeNet', null, null, N'Phone Number'                ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FAX_NUMBER'                           , N'en-US', N'AuthorizeNet', null, null, N'Fax Number'                  ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EMAIL'                                , N'en-US', N'AuthorizeNet', null, null, N'Email'                       ;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'AuthorizeNet', null, null, N'Aut';

-- select * from TERMINOLOGY where list_name = 'modulelist' order by list_order desc
exec dbo.spTERMINOLOGY_InsertOnly N'AuthorizeNet'                                  , N'en-US', null, N'moduleList', 157, N'AuthorizeNet';

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

call dbo.spTERMINOLOGY_AuthorizeNet_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_AuthorizeNet_en_us')
/
-- #endif IBM_DB2 */



-- Terminology generated from database [SplendidCRM6_50] on 11/18/2010 11:37:59 PM.
print 'TERMINOLOGY PayPal en-us';
GO

set nocount on;
GO


-- delete from TERMINOLOGY where MODULE_NAME = 'PayPal';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYPAL_SETTINGS'                           , N'en-US', N'PayPal', null, null, N'PayPal Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYPAL_SETTINGS_DESC'                      , N'en-US', N'PayPal', null, null, N'Configure PayPal Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYPAL_TRANSACTIONS'                       , N'en-US', N'PayPal', null, null, N'PayPal Transactions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYPAL_TRANSACTIONS_DESC'                  , N'en-US', N'PayPal', null, null, N'Search and import PayPal Transactions';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_NAME'                                 , N'en-US', N'PayPal', null, null, N'API User Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PASSWORD'                                  , N'en-US', N'PayPal', null, null, N'API Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRIVATE_KEY'                               , N'en-US', N'PayPal', null, null, N'Private Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CERTIFICATE'                               , N'en-US', N'PayPal', null, null, N'Certificate:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SANDBOX'                                   , N'en-US', N'PayPal', null, null, N'Sandbox:';
-- 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REST_INSTRUCTIONS'                         , N'en-US', N'PayPal', null, null, N'The REST API credentials can be obtained at https://developer.paypal.com/webapps/developer/applications/myapps.';

-- 11/10/2017 Paul.  Correct the PayPal developer URL. 
if exists(select * from TERMINOLOGY where NAME = 'LBL_REST_INSTRUCTIONS' and MODULE_NAME = 'PayPal' and DISPLAY_NAME like '%https://developer.paypal.com/webapps/developer/applications/myapps%') begin -- then
	update TERMINOLOGY
	  set DISPLAY_NAME      = replace(DISPLAY_NAME, 'https://developer.paypal.com/webapps/developer/applications/myapps', 'https://developer.paypal.com/developer/applications/')
	    , DATE_MODIFIED     = getdate()
	    , DATE_MODIFIED_UTC = getutcdate()
	 where NAME             = 'LBL_REST_INSTRUCTIONS'
	  and MODULE_NAME       = 'PayPal'
	  and DISPLAY_NAME      like '%https://developer.paypal.com/webapps/developer/applications/myapps%';
end -- if;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REST_CLIENT_ID'                            , N'en-US', N'PayPal', null, null, N'REST API Client ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REST_CLIENT_SECRET'                        , N'en-US', N'PayPal', null, null, N'REST API Client Secret:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUCTION_BUYER_ID'                          , N'en-US', N'PayPal', null, null, N'Auction Buyer ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUCTION_CLOSING_DATE'                      , N'en-US', N'PayPal', null, null, N'Auction Closing Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUCTION_MULTI_ITEM'                        , N'en-US', N'PayPal', null, null, N'Auction Multi Item:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOM'                                    , N'en-US', N'PayPal', null, null, N'Custom:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_END_DATE'                                  , N'en-US', N'PayPal', null, null, N'End Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXCHANGE_RATE'                             , N'en-US', N'PayPal', null, null, N'Exchange Rate:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FEE_AMOUNT'                                , N'en-US', N'PayPal', null, null, N'Fees:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FEE_AMOUNT_CURRENCY'                       , N'en-US', N'PayPal', null, null, N'Fees Currency:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GROSS_AMOUNT'                              , N'en-US', N'PayPal', null, null, N'Transaction Amount:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GROSS_AMOUNT_CURRENCY'                     , N'en-US', N'PayPal', null, null, N'Transaction Currency:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_BUTTON_LABEL'                       , N'en-US', N'PayPal', null, null, N'Import';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_BUTTON_TITLE'                       , N'en-US', N'PayPal', null, null, N'Import';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INVOICE_ID'                                , N'en-US', N'PayPal', null, null, N'Invoice ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINE_ITEMS'                                , N'en-US', N'PayPal', null, null, N'Line Items';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AMOUNT'                               , N'en-US', N'PayPal', null, null, N'Amount';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FEE_AMOUNT'                           , N'en-US', N'PayPal', null, null, N'Fees';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FEE_AMOUNT_CURRENCY'                  , N'en-US', N'PayPal', null, null, N'Fee Currency';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'PayPal', null, null, N'PayPal Transactions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_GROSS_AMOUNT'                         , N'en-US', N'PayPal', null, null, N'Amount';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_GROSS_AMOUNT_CURRENCY'                , N'en-US', N'PayPal', null, null, N'Gross Currency';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'PayPal', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NET_AMOUNT'                           , N'en-US', N'PayPal', null, null, N'Balance';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NET_AMOUNT_CURRENCY'                  , N'en-US', N'PayPal', null, null, N'NET Currency';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NUMBER'                               , N'en-US', N'PayPal', null, null, N'Number';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PAYER'                                , N'en-US', N'PayPal', null, null, N'Sender';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PAYER_DISPLAY_NAME'                   , N'en-US', N'PayPal', null, null, N'Sender Display Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_QUANTITY'                             , N'en-US', N'PayPal', null, null, N'Quantity';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SALES_TAX'                            , N'en-US', N'PayPal', null, null, N'Sales Tax';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRANSACTION_CLASS'                    , N'en-US', N'PayPal', null, null, N'Transaction Class';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRANSACTION_DATE'                     , N'en-US', N'PayPal', null, null, N'Date Completed';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRANSACTION_ID'                       , N'en-US', N'PayPal', null, null, N'Transaction Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRANSACTION_STATUS'                   , N'en-US', N'PayPal', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRANSACTION_TYPE'                     , N'en-US', N'PayPal', null, null, N'Operation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MEMO'                                      , N'en-US', N'PayPal', null, null, N'Memo:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'PayPal', null, null, N'PayPal Transactions';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'PayPal', null, null, N'PP';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NET_AMOUNT'                                , N'en-US', N'PayPal', null, null, N'Balance:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NET_AMOUNT_CURRENCY'                       , N'en-US', N'PayPal', null, null, N'Balance Currency:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_TRANSACTION_ID'                     , N'en-US', N'PayPal', null, null, N'Parent Transaction ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER'                                     , N'en-US', N'PayPal', null, null, N'Sender:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_CITY'                        , N'en-US', N'PayPal', null, null, N'City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_COUNTRY'                     , N'en-US', N'PayPal', null, null, N'Country Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_COUNTRY_NAME'                , N'en-US', N'PayPal', null, null, N'Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_INTL_NAME'                   , N'en-US', N'PayPal', null, null, N'International Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_INTL_STATE'                  , N'en-US', N'PayPal', null, null, N'International State:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_INTL_STREET'                 , N'en-US', N'PayPal', null, null, N'International Street:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_NAME'                        , N'en-US', N'PayPal', null, null, N'Address Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_OWNER'                       , N'en-US', N'PayPal', null, null, N'Address Owner:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_PHONE'                       , N'en-US', N'PayPal', null, null, N'Alternate Phone:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_POSTAL_CODE'                 , N'en-US', N'PayPal', null, null, N'Postal Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_STATE'                       , N'en-US', N'PayPal', null, null, N'State:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_STATUS'                      , N'en-US', N'PayPal', null, null, N'Address Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_STREET1'                     , N'en-US', N'PayPal', null, null, N'Street 1:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ADDRESS_STREET2'                     , N'en-US', N'PayPal', null, null, N'Street 2:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_BUSINESS'                            , N'en-US', N'PayPal', null, null, N'Business:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_DISPLAY_NAME'                        , N'en-US', N'PayPal', null, null, N'Sender Display Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_FIRST_NAME'                          , N'en-US', N'PayPal', null, null, N'First Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_ID'                                  , N'en-US', N'PayPal', null, null, N'Payer ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_LAST_NAME'                           , N'en-US', N'PayPal', null, null, N'Last Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_MIDDLE_NAME'                         , N'en-US', N'PayPal', null, null, N'Middle Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_PHONE'                               , N'en-US', N'PayPal', null, null, N'Phone:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_SALUATION'                           , N'en-US', N'PayPal', null, null, N'Saluation:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_STATUS'                              , N'en-US', N'PayPal', null, null, N'Payer Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_SUFFIX'                              , N'en-US', N'PayPal', null, null, N'Suffix:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_DATE'                              , N'en-US', N'PayPal', null, null, N'Payment Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_STATUS'                            , N'en-US', N'PayPal', null, null, N'Payment Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYMENT_TYPE'                              , N'en-US', N'PayPal', null, null, N'Payment Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PENDING_REASON'                            , N'en-US', N'PayPal', null, null, N'Pending Reason:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REASON_CODE'                               , N'en-US', N'PayPal', null, null, N'Reason Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RECEIPT_ID'                                , N'en-US', N'PayPal', null, null, N'Receipt ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFUND_BUTTON_LABEL'                       , N'en-US', N'PayPal', null, null, N'Refund';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFUND_BUTTON_TITLE'                       , N'en-US', N'PayPal', null, null, N'Refund';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALES_TAX'                                 , N'en-US', N'PayPal', null, null, N'Sales Tax:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'PayPal', null, null, N'Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SETTLE_AMOUNT'                             , N'en-US', N'PayPal', null, null, N'Settle Amount:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_START_DATE'                                , N'en-US', N'PayPal', null, null, N'Start Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TAX_AMOUNT'                                , N'en-US', N'PayPal', null, null, N'Tax Amount:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANSACTION_CLASS'                         , N'en-US', N'PayPal', null, null, N'Transaction Class:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANSACTION_DATE'                          , N'en-US', N'PayPal', null, null, N'Date Completed:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANSACTION_ID'                            , N'en-US', N'PayPal', null, null, N'Transaction ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANSACTION_STATUS'                        , N'en-US', N'PayPal', null, null, N'Transaction Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRANSACTION_TYPE'                          , N'en-US', N'PayPal', null, null, N'Operation:';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_TRANSACTION'                           , N'en-US', N'PayPal', null, null, N'Create Transaction';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_TRANSACTIONS_LIST'                         , N'en-US', N'PayPal', null, null, N'Transactions';
exec dbo.spTERMINOLOGY_InsertOnly N'NTC_REFUND_CONFIRMATION'                       , N'en-US', N'PayPal', null, null, N'Are you sure you want to refund the transaction?';
-- 01/12/2018 Paul.  Add email. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAYER_EMAIL'                               , N'en-US', N'PayPal', null, null, N'Email:';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'PayPal'                                        , N'en-US', null, N'moduleList'                        ,  62, N'PayPal Transactions';

exec dbo.spTERMINOLOGY_InsertOnly N'All'                                           , N'en-US', null, N'paypal_transaction_class'          ,   1, N'All';
exec dbo.spTERMINOLOGY_InsertOnly N'Sent'                                          , N'en-US', null, N'paypal_transaction_class'          ,   2, N'Sent';
exec dbo.spTERMINOLOGY_InsertOnly N'Received'                                      , N'en-US', null, N'paypal_transaction_class'          ,   3, N'Received';
exec dbo.spTERMINOLOGY_InsertOnly N'MassPay'                                       , N'en-US', null, N'paypal_transaction_class'          ,   4, N'Mass Pay';
exec dbo.spTERMINOLOGY_InsertOnly N'MoneyRequest'                                  , N'en-US', null, N'paypal_transaction_class'          ,   5, N'Money Request';
exec dbo.spTERMINOLOGY_InsertOnly N'FundsAdded'                                    , N'en-US', null, N'paypal_transaction_class'          ,   6, N'Funds Added';
exec dbo.spTERMINOLOGY_InsertOnly N'FundsWithdrawn'                                , N'en-US', null, N'paypal_transaction_class'          ,   7, N'Funds Withdrawn';
exec dbo.spTERMINOLOGY_InsertOnly N'PayPalDebitCard'                               , N'en-US', null, N'paypal_transaction_class'          ,   8, N'PayPal Debit Card';
exec dbo.spTERMINOLOGY_InsertOnly N'Referral'                                      , N'en-US', null, N'paypal_transaction_class'          ,   9, N'Referral';
exec dbo.spTERMINOLOGY_InsertOnly N'Fee'                                           , N'en-US', null, N'paypal_transaction_class'          ,  10, N'Fee';
exec dbo.spTERMINOLOGY_InsertOnly N'Subscription'                                  , N'en-US', null, N'paypal_transaction_class'          ,  11, N'Subscription';
exec dbo.spTERMINOLOGY_InsertOnly N'Dividend'                                      , N'en-US', null, N'paypal_transaction_class'          ,  12, N'Dividend';
exec dbo.spTERMINOLOGY_InsertOnly N'Billpay'                                       , N'en-US', null, N'paypal_transaction_class'          ,  13, N'Billpay';
exec dbo.spTERMINOLOGY_InsertOnly N'Refund'                                        , N'en-US', null, N'paypal_transaction_class'          ,  14, N'Refund';
exec dbo.spTERMINOLOGY_InsertOnly N'CurrencyConversions'                           , N'en-US', null, N'paypal_transaction_class'          ,  15, N'Currency Conversions';
exec dbo.spTERMINOLOGY_InsertOnly N'BalanceTransfer'                               , N'en-US', null, N'paypal_transaction_class'          ,  16, N'Balance Transfer';
exec dbo.spTERMINOLOGY_InsertOnly N'Reversal'                                      , N'en-US', null, N'paypal_transaction_class'          ,  17, N'Reversal';
exec dbo.spTERMINOLOGY_InsertOnly N'Shipping'                                      , N'en-US', null, N'paypal_transaction_class'          ,  18, N'Shipping';
exec dbo.spTERMINOLOGY_InsertOnly N'BalanceAffecting'                              , N'en-US', null, N'paypal_transaction_class'          ,  19, N'Balance Affecting';
exec dbo.spTERMINOLOGY_InsertOnly N'ECheck'                                        , N'en-US', null, N'paypal_transaction_class'          ,  20, N'ECheck';

exec dbo.spTERMINOLOGY_InsertOnly N'Pending'                                       , N'en-US', null, N'paypal_transaction_status'         ,   1, N'Pending';
exec dbo.spTERMINOLOGY_InsertOnly N'Processing'                                    , N'en-US', null, N'paypal_transaction_status'         ,   2, N'Processing';
exec dbo.spTERMINOLOGY_InsertOnly N'Success'                                       , N'en-US', null, N'paypal_transaction_status'         ,   3, N'Success';
exec dbo.spTERMINOLOGY_InsertOnly N'Denied'                                        , N'en-US', null, N'paypal_transaction_status'         ,   4, N'Denied';
exec dbo.spTERMINOLOGY_InsertOnly N'Reversed'                                      , N'en-US', null, N'paypal_transaction_status'         ,   5, N'Reversed';
exec dbo.spTERMINOLOGY_InsertOnly N'Completed'                                     , N'en-US', null, N'paypal_transaction_status'         ,   6, N'Completed';
exec dbo.spTERMINOLOGY_InsertOnly N'Canceled'                                      , N'en-US', null, N'paypal_transaction_status'         ,   7, N'Cancelled';
exec dbo.spTERMINOLOGY_InsertOnly N'Removed'                                       , N'en-US', null, N'paypal_transaction_status'         ,   8, N'Removed';
exec dbo.spTERMINOLOGY_InsertOnly N'Paid'                                          , N'en-US', null, N'paypal_transaction_status'         ,   9, N'Paid';
exec dbo.spTERMINOLOGY_InsertOnly N'Cleared'                                       , N'en-US', null, N'paypal_transaction_status'         ,  10, N'Cleared';
exec dbo.spTERMINOLOGY_InsertOnly N'Partially Refunded'                            , N'en-US', null, N'paypal_transaction_status'         ,  11, N'Partially Refunded';
exec dbo.spTERMINOLOGY_InsertOnly N'Refunded'                                      , N'en-US', null, N'paypal_transaction_status'         ,  12, N'Refunded';
-- 07/31/2018 Paul.  Add missing term. 
exec dbo.spTERMINOLOGY_InsertOnly N'approved'                                      , N'en-US', null, N'paypal_transaction_status'         ,  13, N'Approved';

exec dbo.spTERMINOLOGY_InsertOnly N'Transfer'                                      , N'en-US', null, N'paypal_transaction_type'           ,   1, N'Transfer';
exec dbo.spTERMINOLOGY_InsertOnly N'Payment'                                       , N'en-US', null, N'paypal_transaction_type'           ,   2, N'Payment';
exec dbo.spTERMINOLOGY_InsertOnly N'Bill'                                          , N'en-US', null, N'paypal_transaction_type'           ,   3, N'Bill';
exec dbo.spTERMINOLOGY_InsertOnly N'Reversal'                                      , N'en-US', null, N'paypal_transaction_type'           ,   4, N'Reversal';
exec dbo.spTERMINOLOGY_InsertOnly N'Temporary Hold'                                , N'en-US', null, N'paypal_transaction_type'           ,   5, N'Temporary Hold';
exec dbo.spTERMINOLOGY_InsertOnly N'Authorization'                                 , N'en-US', null, N'paypal_transaction_type'           ,   6, N'Authorization';
exec dbo.spTERMINOLOGY_InsertOnly N'PayPal Services'                               , N'en-US', null, N'paypal_transaction_type'           ,   7, N'PayPal Services';
exec dbo.spTERMINOLOGY_InsertOnly N'Dividend'                                      , N'en-US', null, N'paypal_transaction_type'           ,   8, N'Dividend';
exec dbo.spTERMINOLOGY_InsertOnly N'Refund'                                        , N'en-US', null, N'paypal_transaction_type'           ,   9, N'Refund';
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

call dbo.spTERMINOLOGY_PayPal_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_PayPal_en_us')
/
-- #endif IBM_DB2 */

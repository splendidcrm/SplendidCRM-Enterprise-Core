

print 'TERMINOLOGY Portal en-US';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'Other'                           , N'en-US', null, N'lead_source_dom', 15, N'Portal';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DETAILS_BUTTON_LABEL'        , N'en-US', null, null, null, N'Details';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DETAILS_BUTTON_TITLE'        , N'en-US', null, null, null, N'Details';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PORTAL_NOTICES_TITLE'        , N'en-US', N'Home', null, null, N'Portal Notices';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REGISTRATION'                , N'en-US', N'Contacts', null, null, N'Registration';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REGISTER'                    , N'en-US', N'Contacts', null, null, N'Register Now';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PORTAL_PASSWORD'             , N'en-US', N'Contacts', null, null, N'Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFIRM_PORTAL_PASSWORD'     , N'en-US', N'Contacts', null, null, N'Confirm Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_PORTAL_EMAIL1_EXISTS'        , N'en-US', N'Contacts', null, null, N'A Contact already exists with the email {0}.  Please use the Forgot Password feature to re-establish your authentication credentials.';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_FACEBOOK_UID'                , N'en-US', N'Contacts', null, null, N'Portal Name does not match facebook UID.';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MY_OPEN_QUOTES'         , N'en-US', N'Quotes'  , null, null, N'Recent Quotes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUEST_QUOTE'               , N'en-US', N'Quotes'  , null, null, N'Request Quote';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUOTE_IS_EMPTY'              , N'en-US', N'Quotes'  , null, null, N'The quote is empty.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER_NOW'                   , N'en-US', N'Quotes'  , null, null, N'Order Now';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MY_OPEN_ORDERS'         , N'en-US', N'Orders'  , null, null, N'Recent Orders';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAY_NOW'                     , N'en-US', N'Orders'  , null, null, N'Pay Now';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MY_OPEN_INVOICES'       , N'en-US', N'Invoices', null, null, N'Recent Invoices';
-- 04/05/2013 Paul.  Add missing label. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAY_NOW'                     , N'en-US', N'Invoices', null, null, N'Pay Now';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADD_NEW_CARD'                , N'en-US', N'CreditCards', null, null, N'Add New Credit Card';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_CONTACT_HEADER'          , N'en-US', N'Portal', null, null, N'Contact Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_BILLING_HEADER'          , N'en-US', N'Portal', null, null, N'Billing Address';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_PAYMENT_HEADER'          , N'en-US', N'Portal', null, null, N'Payment Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_PORTAL_HEADER'           , N'en-US', N'Portal', null, null, N'SplendidCRM Portal Login';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_NEXT'                    , N'en-US', N'Portal', null, null, N'Next';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_PREVIOUS'                , N'en-US', N'Portal', null, null, N'Previous';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_FINISH'                  , N'en-US', N'Portal', null, null, N'Submit Order';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_PROCESSING'              , N'en-US', N'Portal', null, null, N'Processing . . .';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_NOW'                     , N'en-US', N'Portal', null, null, N'Buy Now';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UNIT_PRICE'                  , N'en-US', N'Portal', null, null, N'Price/user:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_USERS'                   , N'en-US', N'Portal', null, null, N'Users:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_TOTAL_CURRENCY'          , N'en-US', N'Portal', null, null, N'USD';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_APPLICATION_LABEL'       , N'en-US', N'Portal', null, null, N'Step 1';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_APPLICATION_HEADER'      , N'en-US', N'Portal', null, null, N'Application';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_PAYMENT_LABEL'           , N'en-US', N'Portal', null, null, N'Step 2';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_SUMMARY_LABEL'           , N'en-US', N'Portal', null, null, N'Step 3';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUY_SUMMARY_HEADER'          , N'en-US', N'Portal', null, null, N'Summary';
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

call dbo.spTERMINOLOGY_Portal_en_US()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Portal_en_US')
/
-- #endif IBM_DB2 */


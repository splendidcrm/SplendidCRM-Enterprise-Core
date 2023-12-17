

print 'TERMINOLOGY SimpleEmail en-us';
GO

set nocount on;
GO


exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMAZON_SIMPLE_EMAIL'                     , N'en-US', N'Administration', null, null, N'Simple Email Services';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMAZON_SIMPLE_EMAIL_DESC'                , N'en-US', N'Administration', null, null, N'Manage Email Services.';

exec dbo.spTERMINOLOGY_InsertOnly N'SimpleEmail'                                 , N'en-US', null, N'moduleList'                        , 103, N'Simple Email';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                         , N'en-US', N'SimpleEmail'   , null, null, N'Verified Email Addresses';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEND_STATISTICS'                         , N'en-US', N'SimpleEmail'   , null, null, N'Send Statistics';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREATE_EMAIL_ADDRESS'                    , N'en-US', N'SimpleEmail'   , null, null, N'Create Email Address';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL_ADDRESS'                           , N'en-US', N'SimpleEmail'   , null, null, N'Email Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EMAIL_ADDRESS'                      , N'en-US', N'SimpleEmail'   , null, null, N'Email Address';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAX_24HOUR_SEND'                         , N'en-US', N'SimpleEmail'   , null, null, N'Maximum send in 24 hour interval:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAX_SEND_RATE'                           , N'en-US', N'SimpleEmail'   , null, null, N'Maximum send per second:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SENT_LAST_24HOURS'                       , N'en-US', N'SimpleEmail'   , null, null, N'Emails sent in last 24 hours:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL_ADDRESS_CREATED'                   , N'en-US', N'SimpleEmail'   , null, null, N'The email has been created, but it will not appear until you click on the verification link sent by Amazon.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL_ADDRESS_DELETED'                   , N'en-US', N'SimpleEmail'   , null, null, N'The email has been deleted, but it may take a minute to disappear.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BOUNCES'                            , N'en-US', N'SimpleEmail'   , null, null, N'Bounces';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_COMPLAINTS'                         , N'en-US', N'SimpleEmail'   , null, null, N'Complaints';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DELIVERY_ATTEMPTS'                  , N'en-US', N'SimpleEmail'   , null, null, N'Delivery Attempts';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_REJECTS'                            , N'en-US', N'SimpleEmail'   , null, null, N'Rejects';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TIMESTAMP'                          , N'en-US', N'SimpleEmail'   , null, null, N'Timestamp';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_VERIFIED_EMAIL_ADDRESSES'                , N'en-US', N'SimpleEmail'   , null, null, N'Verified Email Addresses';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_SEND_STATISTICS'                         , N'en-US', N'SimpleEmail'   , null, null, N'Send Statistics';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_SEND_TEST'                               , N'en-US', N'SimpleEmail'   , null, null, N'Send Test';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                     , N'en-US', N'SimpleEmail'   , null, null, N'ASE';

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

call dbo.spTERMINOLOGY_SimpleEmail_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_SimpleEmail_en_us')
/
-- #endif IBM_DB2 */



print 'TERMINOLOGY OutboundEmail en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'OutboundEmail';
-- 03/28/2019 Paul.  Every module should have a LBL_NEW_FORM_TITLE. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_FORM_TITLE'                            , N'en-US', N'OutboundEmail', null, null, N'Outbound Email';
-- 01/18/2021 Paul.  LBL_LIST_FORM_TITLE is needed for the React Client. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'OutboundEmail', null, null, N'Outbound Email List';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FROM_ADDR'                            , N'en-US', N'OutboundEmail', null, null, N'From Email';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FROM_NAME'                            , N'en-US', N'OutboundEmail', null, null, N'From Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'OutboundEmail', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TYPE'                                 , N'en-US', N'OutboundEmail', null, null, N'Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_USER_ID'                              , N'en-US', N'OutboundEmail', null, null, N'User ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_USER_NAME'                            , N'en-US', N'OutboundEmail', null, null, N'User';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MAIL_SENDTYPE'                        , N'en-US', N'OutboundEmail', null, null, N'Send Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MAIL_SMTPTYPE'                        , N'en-US', N'OutboundEmail', null, null, N'SMTP Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MAIL_SMTPSERVER'                      , N'en-US', N'OutboundEmail', null, null, N'SMTP Server';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MAIL_SMTPPORT'                        , N'en-US', N'OutboundEmail', null, null, N'Port';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MAIL_SMTPUSER'                        , N'en-US', N'OutboundEmail', null, null, N'Login';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MAIL_SMTPPASS'                        , N'en-US', N'OutboundEmail', null, null, N'Password';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MAIL_SMTPAUTH_REQ'                    , N'en-US', N'OutboundEmail', null, null, N'SMTP Auth?';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MAIL_SMTPSSL'                         , N'en-US', N'OutboundEmail', null, null, N'SSL';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FROM_ADDR'                                 , N'en-US', N'OutboundEmail', null, null, N'From Email Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FROM_NAME'                                 , N'en-US', N'OutboundEmail', null, null, N'From Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'OutboundEmail', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TYPE'                                      , N'en-US', N'OutboundEmail', null, null, N'Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_ID'                                   , N'en-US', N'OutboundEmail', null, null, N'User ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_NAME'                                 , N'en-US', N'OutboundEmail', null, null, N'User:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAIL_SENDTYPE'                             , N'en-US', N'OutboundEmail', null, null, N'Send Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAIL_SMTPTYPE'                             , N'en-US', N'OutboundEmail', null, null, N'SMTP Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAIL_SMTPSERVER'                           , N'en-US', N'OutboundEmail', null, null, N'SMTP Server:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAIL_SMTPPORT'                             , N'en-US', N'OutboundEmail', null, null, N'Port:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAIL_SMTPUSER'                             , N'en-US', N'OutboundEmail', null, null, N'Login:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAIL_SMTPPASS'                             , N'en-US', N'OutboundEmail', null, null, N'Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAIL_SMTPAUTH_REQ'                         , N'en-US', N'OutboundEmail', null, null, N'Use SMTP Authentication?';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAIL_SMTPSSL'                              , N'en-US', N'OutboundEmail', null, null, N'Enable SMTP over SSL:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_TITLE'                              , N'en-US', N'OutboundEmail', null, null, N'Outbound Email';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_OUTBOUND_EMAIL_LIST'                       , N'en-US', N'OutboundEmail', null, null, N'Outbound Email Accounts';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_OUTBOUND_EMAIL'                        , N'en-US', N'OutboundEmail', null, null, N'Create Outbound Email';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_BUTTON_LABEL'                         , N'en-US', N'OutboundEmail', null, null, N'Test';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'OutboundEmail', null, null, N'Out';


exec dbo.spTERMINOLOGY_InsertOnly N'OutboundEmail'                                 , N'en-US', null, N'moduleList', 114, N'Outbound Email';

-- 01/17/2017 Paul.  Add support for Office 365 using OAuth. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SMTP_TITLE'                                , N'en-US', N'OutboundEmail', null, null, N'SMTP Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OFFICE365_TITLE'                           , N'en-US', N'OutboundEmail', null, null, N'Office 365';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GMAIL_TITLE'                               , N'en-US', N'OutboundEmail', null, null, N'Gmail';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GOOGLEAPPS_NOT_ENABLED'                    , N'en-US', N'OutboundEmail', null, null, N'Google Apps has not been enabled.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OFFICE365_NOT_ENABLED'                     , N'en-US', N'OutboundEmail', null, null, N'Office 365 has not been enabled.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXCHANGE_NOT_ENABLED'                      , N'en-US', N'OutboundEmail', null, null, N'Exchange Server has not been enabled.';

-- delete from TERMINOLOGY where LIST_NAME = 'outbound_send_type';
exec dbo.spTERMINOLOGY_InsertOnly N'smtp'                                          , N'en-US', null, N'outbound_send_type', 1, N'SMTP';
exec dbo.spTERMINOLOGY_InsertOnly N'Office365'                                     , N'en-US', null, N'outbound_send_type', 2, N'Office 365';
exec dbo.spTERMINOLOGY_InsertOnly N'GoogleApps'                                    , N'en-US', null, N'outbound_send_type', 3, N'Gmail';
-- 01/31/2017 Paul.  Add support for Exchange using Username/Password. 
exec dbo.spTERMINOLOGY_InsertOnly N'Exchange-Password'                             , N'en-US', null, N'outbound_send_type', 4, N'Exchange';
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

call dbo.spTERMINOLOGY_OutboundEmail_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_OutboundEmail_en_us')
/
-- #endif IBM_DB2 */

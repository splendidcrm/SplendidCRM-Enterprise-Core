

print 'TERMINOLOGY MailChimp en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'MailChimp';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_MAILCHIMP_TITLE'                        , N'en-US', N'MailChimp', null, null, N'MailChimp &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_MAILCHIMP'                              , N'en-US', N'MailChimp', null, null, N'Configure MailChimp Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAILCHIMP_SETTINGS'                            , N'en-US', N'MailChimp', null, null, N'MailChimp Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_DATA_CENTER'                             , N'en-US', N'MailChimp', null, null, N'MailChimp Data Center:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                               , N'en-US', N'MailChimp', null, null, N'MailChimp Client ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                           , N'en-US', N'MailChimp', null, null, N'MailChimp Secret Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                            , N'en-US', N'MailChimp', null, null, N'MailChimp Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAILCHIMP_ENABLED'                             , N'en-US', N'MailChimp', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                                , N'en-US', N'MailChimp', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                     , N'en-US', N'MailChimp', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                           , N'en-US', N'MailChimp', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                               , N'en-US', N'MailChimp', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                                  , N'en-US', N'MailChimp', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MERGE_FIELDS'                                  , N'en-US', N'MailChimp', null, null, N'Merge Fields:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                        , N'en-US', N'MailChimp', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                               , N'en-US', N'MailChimp', null, null, N'Connection successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                           , N'en-US', N'MailChimp', null, null, N'MC';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TYPE'                                          , N'en-US', N'MailChimp', null, null, N'Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TYPE'                                     , N'en-US', N'MailChimp', null, null, N'Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CATEGORY'                                      , N'en-US', N'MailChimp', null, null, N'Category:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CATEGORY'                                 , N'en-US', N'MailChimp', null, null, N'Category';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FOLDER_ID'                                     , N'en-US', N'MailChimp', null, null, N'Folder:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUBJECT'                                       , N'en-US', N'MailChimp', null, null, N'Subject:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FROM_NAME'                                     , N'en-US', N'MailChimp', null, null, N'From Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FROM_EMAIL'                                    , N'en-US', N'MailChimp', null, null, N'From Email:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_RATING'                                   , N'en-US', N'MailChimp', null, null, N'List Rating:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VISIBILITY'                                    , N'en-US', N'MailChimp', null, null, N'Visibility:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                          , N'en-US', N'MailChimp', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY'                                       , N'en-US', N'MailChimp', null, null, N'Company:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS1'                                      , N'en-US', N'MailChimp', null, null, N'Address 1:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS2'                                      , N'en-US', N'MailChimp', null, null, N'Address 2:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CITY'                                          , N'en-US', N'MailChimp', null, null, N'City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATE'                                         , N'en-US', N'MailChimp', null, null, N'State:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ZIP'                                           , N'en-US', N'MailChimp', null, null, N'Zip:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRY'                                       , N'en-US', N'MailChimp', null, null, N'Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE'                                         , N'en-US', N'MailChimp', null, null, N'Phone:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LANGUAGE'                                      , N'en-US', N'MailChimp', null, null, N'Language:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PERMISSION_REMINDER'                           , N'en-US', N'MailChimp', null, null, N'Permission Reminder:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOTIFY_ON_SUBSCRIBE'                           , N'en-US', N'MailChimp', null, null, N'Notify on Subscribe:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOTIFY_ON_UNSUBSCRIBE'                         , N'en-US', N'MailChimp', null, null, N'Notify on Unsubscribe:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL_TYPE_OPTION'                             , N'en-US', N'MailChimp', null, null, N'Email Type Option:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USE_ARCHIVE_BAR'                               , N'en-US', N'MailChimp', null, null, N'Use Archive Bar:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTACT_INFORMATION'                           , N'en-US', N'MailChimp', null, null, N'Contact Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CAMPAIGN_INFORMATION'                          , N'en-US', N'MailChimp', null, null, N'Campaign Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATISTICAL_INFORMATION'                       , N'en-US', N'MailChimp', null, null, N'Statistical Information';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MEMBER_COUNT'                                  , N'en-US', N'MailChimp', null, null, N'Member Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UNSUBSCRIBE_COUNT'                             , N'en-US', N'MailChimp', null, null, N'Unsubscribe Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CLEANED_COUNT'                                 , N'en-US', N'MailChimp', null, null, N'Cleaned Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MEMBER_COUNT_SINCE_SEND'                       , N'en-US', N'MailChimp', null, null, N'Member Count Since Send:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UNSUBSCRIBE_COUNT_SINCE_SEND'                  , N'en-US', N'MailChimp', null, null, N'Unsubscribe Count Since Send:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CLEANED_COUNT_SINCE_SEND'                      , N'en-US', N'MailChimp', null, null, N'Cleaned Count Since Send:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CAMPAIGN_COUNT'                                , N'en-US', N'MailChimp', null, null, N'Campaign Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CAMPAIGN_LAST_SENT'                            , N'en-US', N'MailChimp', null, null, N'Campaign Last Send:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MERGE_FIELD_COUNT'                             , N'en-US', N'MailChimp', null, null, N'Merge Field Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AVG_SUB_RATE'                                  , N'en-US', N'MailChimp', null, null, N'Average Subscribe Rate:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AVG_UNSUB_RATE'                                , N'en-US', N'MailChimp', null, null, N'Average Unsubscribe Rate:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TARGET_SUB_RATE'                               , N'en-US', N'MailChimp', null, null, N'Target Subscribe Rate:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPEN_RATE'                                     , N'en-US', N'MailChimp', null, null, N'Open Rate:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CLICK_RATE'                                    , N'en-US', N'MailChimp', null, null, N'Click Rate:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_SUB_DATE'                                 , N'en-US', N'MailChimp', null, null, N'Last Subscribe Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_UNSUB_DATE'                               , N'en-US', N'MailChimp', null, null, N'Last Unsubscribe Date:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LIST_RATING'                              , N'en-US', N'MailChimp', null, null, N'List Rating';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_VISIBILITY'                               , N'en-US', N'MailChimp', null, null, N'Visibility';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EMAIL'                                    , N'en-US', N'MailChimp', null, null, N'Email';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_UNIQUE_EMAIL_ID'                          , N'en-US', N'MailChimp', null, null, N'Unique Email ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                                   , N'en-US', N'MailChimp', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AVG_OPEN_RATE'                            , N'en-US', N'MailChimp', null, null, N'Avg Open Rate';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AVG_CLICK_RATE'                           , N'en-US', N'MailChimp', null, null, N'Avg Click Rate';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_CHANGED'                             , N'en-US', N'MailChimp', null, null, N'Last Changed';




exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAILCHIMP'                                     , N'en-US', N'Import', null, null, N'MailChimp &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_MAILCHIMP_TITLE'                        , N'en-US', N'Import', null, null, N'You will first need to sign-in to MailChimp &reg; in order to connect and retrieve the contacts.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                                  , N'en-US', N'MailChimp', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                              , N'en-US', N'MailChimp', null, null, N'<p>
In order to use MailChimp authentication or to allow the import of MailChimp contacts, 
you will need to create a MailChimp applicaton.  Once a MailChimp application has been created, 
you can provide the ClientID and the Secret key below.  Make sure to specify the following landing page:<br />
~/Administration/MailChimp/OAuthLanding.aspx
</p>
<p>
For instructions on how to create a MailChimp application, please follow the 
<a href="http://kb.mailchimp.com/accounts/management/about-api-keys/#Find-or-Generate-Your-API-Key" target="_default">Instructions</a> on the MailChimp site. 
</p>
<p>Access Token will be populated during the Authorize process.
</p>';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                    , N'en-US', null, N'mailchimp_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                       , N'en-US', null, N'mailchimp_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                     , N'en-US', null, N'mailchimp_sync_direction'         ,   3, N'from crm only';

exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                             , N'en-US', null, N'mailchimp_sync_module'            ,   1, N'Leads';
exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                          , N'en-US', null, N'mailchimp_sync_module'            ,   2, N'Contacts';
exec dbo.spTERMINOLOGY_InsertOnly N'Prospects'                                         , N'en-US', null, N'mailchimp_sync_module'            ,   3, N'Targets';

exec dbo.spTERMINOLOGY_InsertOnly N'pub'                                               , N'en-US', null, N'mailchimp_visibility'             ,   1, N'Public';
exec dbo.spTERMINOLOGY_InsertOnly N'priv'                                              , N'en-US', null, N'mailchimp_visibility'             ,   2, N'Private';

exec dbo.spTERMINOLOGY_InsertOnly N'MailChimp'                                         , N'en-US', null, N'prospect_list_type_dom'           ,   7, N'MailChimp';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'MailChimp'                                         , N'en-US', null, N'moduleList', 159, N'MailChimp';
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

call dbo.spTERMINOLOGY_MailChimp_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_MailChimp_en_us')
/
-- #endif IBM_DB2 */

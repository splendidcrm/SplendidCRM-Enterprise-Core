

print 'TERMINOLOGY Marketo en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'Marketo';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_MARKETO_TITLE'                      , N'en-US', N'Marketo', null, null, N'Marketo &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_MARKETO'                            , N'en-US', N'Marketo', null, null, N'Configure Marketo Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MARKETO_SETTINGS'                          , N'en-US', N'Marketo', null, null, N'Marketo Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ENDPOINT_URL'                        , N'en-US', N'Marketo', null, null, N'Marketo Endpoint URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_IDENTITY_URL'                        , N'en-US', N'Marketo', null, null, N'Marketo Identity URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                           , N'en-US', N'Marketo', null, null, N'Marketo ClientID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                       , N'en-US', N'Marketo', null, null, N'Marketo Secret Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                        , N'en-US', N'Marketo', null, null, N'Marketo Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_SCOPE'                               , N'en-US', N'Marketo', null, null, N'Marketo Scope:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_EXPIRES_AT'                          , N'en-US', N'Marketo', null, null, N'Access Token Expires:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MARKETO_ENABLED'                           , N'en-US', N'Marketo', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'Marketo', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'Marketo', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'Marketo', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'Marketo', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                              , N'en-US', N'Marketo', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                    , N'en-US', N'Marketo', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'Marketo', null, null, N'Connection successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_SUCCESSFUL'                      , N'en-US', N'Marketo', null, null, N'Authorization successful.';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Marketo', null, null, N'Mkt';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MARKETO'                                   , N'en-US', N'Import', null, null, N'Marketo &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_MARKETO_TITLE'                      , N'en-US', N'Import', null, null, N'You will first need to sign-in to Marketo &reg; in order to connect and retrieve the contacts.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'Marketo', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'Marketo', null, null, N'<p>
In order to use Marketo authentication or to allow the import of Marketo contacts, 
you will need to create a Marketo custom service.  Once a Marketo service has been created, 
you can provide the Instance URL, ClientID and the Secret key below.</p>
<p>
For instructions on how to create the custom service and get the Client ID and Client Secret, please follow the 
<a href="http://developers.marketo.com/documentation/rest/custom-service/" target="_default">Instructions</a> on the Marketo site. 
</p>
<p>Access Token, Token Expires and Scope will all be populated during the Authorize process.
</p>';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                , N'en-US', null, N'marketo_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                   , N'en-US', null, N'marketo_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                 , N'en-US', null, N'marketo_sync_direction'         ,   3, N'from crm only';

-- delete from TERMINOLOGY where LIST_NAME = 'marketo_sync_module';
exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                         , N'en-US', null, N'marketo_sync_module'            ,   1, N'CRM Leads to Marketo Leads';
exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                      , N'en-US', null, N'marketo_sync_module'            ,   2, N'CRM Contacts to Marketo Leads';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'Marketo'                                       , N'en-US', null, N'moduleList', 137, N'Marketo';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEAD_INFO'                                 , N'en-US', N'Marketo', null, null, N'Lead Info';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY_INFO'                              , N'en-US', N'Marketo', null, null, N'Company Info';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOURCE_INFO'                               , N'en-US', N'Marketo', null, null, N'Source Info';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOCIAL_MEDIA'                              , N'en-US', N'Marketo', null, null, N'Social Media';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY'                                   , N'en-US', N'Marketo', null, null, N'Company Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SITE'                                      , N'en-US', N'Marketo', null, null, N'Site:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLINGSTREET'                             , N'en-US', N'Marketo', null, null, N'Billing Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLINGCITY'                               , N'en-US', N'Marketo', null, null, N'Billing City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLINGSTATE'                              , N'en-US', N'Marketo', null, null, N'Billing State:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLINGCOUNTRY'                            , N'en-US', N'Marketo', null, null, N'Billing Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLINGPOSTALCODE'                         , N'en-US', N'Marketo', null, null, N'Billing Postal Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WEBSITE'                                   , N'en-US', N'Marketo', null, null, N'Website:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAINPHONE'                                 , N'en-US', N'Marketo', null, null, N'Main Phone:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANNUALREVENUE'                             , N'en-US', N'Marketo', null, null, N'Annual Revenue:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NUMBEROFEMPLOYEES'                         , N'en-US', N'Marketo', null, null, N'Num Employees:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INDUSTRY'                                  , N'en-US', N'Marketo', null, null, N'Industry:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SICCODE'                                   , N'en-US', N'Marketo', null, null, N'SIC Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ID'                                        , N'en-US', N'Marketo', null, null, N'Marketo ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PERSONTYPE'                                , N'en-US', N'Marketo', null, null, N'Person Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ISLEAD'                                    , N'en-US', N'Marketo', null, null, N'Is Lead:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ISANONYMOUS'                               , N'en-US', N'Marketo', null, null, N'Is Anonymous:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALUTATION'                                , N'en-US', N'Marketo', null, null, N'Salutation:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRSTNAME'                                 , N'en-US', N'Marketo', null, null, N'First Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MIDDLENAME'                                , N'en-US', N'Marketo', null, null, N'Middle Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LASTNAME'                                  , N'en-US', N'Marketo', null, null, N'Last Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL'                                     , N'en-US', N'Marketo', null, null, N'Email Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE'                                     , N'en-US', N'Marketo', null, null, N'Phone Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MOBILEPHONE'                               , N'en-US', N'Marketo', null, null, N'Mobile Phone Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FAX'                                       , N'en-US', N'Marketo', null, null, N'Fax Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TITLE'                                     , N'en-US', N'Marketo', null, null, N'Job Title:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTACTCOMPANY'                            , N'en-US', N'Marketo', null, null, N'Contact Company:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATEOFBIRTH'                               , N'en-US', N'Marketo', null, null, N'Date of Birth:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS'                                   , N'en-US', N'Marketo', null, null, N'Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CITY'                                      , N'en-US', N'Marketo', null, null, N'City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATE'                                     , N'en-US', N'Marketo', null, null, N'State:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRY'                                   , N'en-US', N'Marketo', null, null, N'Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_POSTALCODE'                                , N'en-US', N'Marketo', null, null, N'Postal Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORIGINALSOURCETYPE'                        , N'en-US', N'Marketo', null, null, N'Original Source Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORIGINALSOURCEINFO'                        , N'en-US', N'Marketo', null, null, N'Original Source Info:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REGISTRATIONSOURCETYPE'                    , N'en-US', N'Marketo', null, null, N'Registration Source Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REGISTRATIONSOURCEINFO'                    , N'en-US', N'Marketo', null, null, N'Registration Source Info:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORIGINALSEARCHENGINE'                      , N'en-US', N'Marketo', null, null, N'Original Search Engine:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORIGINALSEARCHPHRASE'                      , N'en-US', N'Marketo', null, null, N'Original Search Phrase:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORIGINALREFERRER'                          , N'en-US', N'Marketo', null, null, N'Original Referrer:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAILINVALID'                              , N'en-US', N'Marketo', null, null, N'Email Invalid:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAILINVALIDCAUSE'                         , N'en-US', N'Marketo', null, null, N'Email Invalid Cause:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UNSUBSCRIBED'                              , N'en-US', N'Marketo', null, null, N'Unsubscribed:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UNSUBSCRIBEDREASON'                        , N'en-US', N'Marketo', null, null, N'Unsubscribed Reason:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DONOTCALL'                                 , N'en-US', N'Marketo', null, null, N'Do Not Call:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DONOTCALLREASON'                           , N'en-US', N'Marketo', null, null, N'Do Not Call Reason:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANONYMOUSIP'                               , N'en-US', N'Marketo', null, null, N'Anonymous IP:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INFERREDCOMPANY'                           , N'en-US', N'Marketo', null, null, N'Inferred Company:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INFERREDCOUNTRY'                           , N'en-US', N'Marketo', null, null, N'Inferred Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INFERREDCITY'                              , N'en-US', N'Marketo', null, null, N'Inferred City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INFERREDSTATEREGION'                       , N'en-US', N'Marketo', null, null, N'Inferred State Region:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INFERREDPOSTALCODE'                        , N'en-US', N'Marketo', null, null, N'Inferred Postal Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INFERREDMETROPOLITANAREA'                  , N'en-US', N'Marketo', null, null, N'Inferred Metropolitan Area:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INFERREDPHONEAREACODE'                     , N'en-US', N'Marketo', null, null, N'Inferred Phone Area Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DEPARTMENT'                                , N'en-US', N'Marketo', null, null, N'Department:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREATEDAT'                                 , N'en-US', N'Marketo', null, null, N'Created At:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UPDATEDAT'                                 , N'en-US', N'Marketo', null, null, N'Updated At:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COOKIES'                                   , N'en-US', N'Marketo', null, null, N'Cookies:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEADPERSON'                                , N'en-US', N'Marketo', null, null, N'Lead Person:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEADROLE'                                  , N'en-US', N'Marketo', null, null, N'Role:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEADSOURCE'                                , N'en-US', N'Marketo', null, null, N'Lead Source:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEADSTATUS'                                , N'en-US', N'Marketo', null, null, N'Lead Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEADSCORE'                                 , N'en-US', N'Marketo', null, null, N'Lead Score:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_URGENCY'                                   , N'en-US', N'Marketo', null, null, N'Urgency:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRIORITY'                                  , N'en-US', N'Marketo', null, null, N'Priority:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RELATIVESCORE'                             , N'en-US', N'Marketo', null, null, N'Relative Score:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RATING'                                    , N'en-US', N'Marketo', null, null, N'Lead Rating:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PERSONPRIMARYLEADINTEREST'                 , N'en-US', N'Marketo', null, null, N'Primary Lead Interest:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEADPARTITIONID'                           , N'en-US', N'Marketo', null, null, N'Lead Partition:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEADREVENUECYCLEMODELID'                   , N'en-US', N'Marketo', null, null, N'Lead Revenue Cycle Model ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEADREVENUESTAGEID'                        , N'en-US', N'Marketo', null, null, N'Lead Revenue Stage ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GENDER'                                    , N'en-US', N'Marketo', null, null, N'Marketo Social Gender:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FACEBOOKDISPLAYNAME'                       , N'en-US', N'Marketo', null, null, N'Marketo Social Facebook Display Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERDISPLAYNAME'                        , N'en-US', N'Marketo', null, null, N'Marketo Social Twitter Display Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKEDINDISPLAYNAME'                       , N'en-US', N'Marketo', null, null, N'Marketo Social LinkedIn Display Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FACEBOOKPROFILEURL'                        , N'en-US', N'Marketo', null, null, N'Marketo Social Facebook Profile URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERPROFILEURL'                         , N'en-US', N'Marketo', null, null, N'Marketo Social Twitter Profile URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKEDINPROFILEURL'                        , N'en-US', N'Marketo', null, null, N'Marketo Social LinkedIn Profile URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FACEBOOKPHOTOURL'                          , N'en-US', N'Marketo', null, null, N'Marketo Social Facebook Photo URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERPHOTOURL'                           , N'en-US', N'Marketo', null, null, N'Marketo Social Twitter Photo URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKEDINPHOTOURL'                          , N'en-US', N'Marketo', null, null, N'Marketo Social LinkedIn Photo URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FACEBOOKREACH'                             , N'en-US', N'Marketo', null, null, N'Marketo Social Facebook Reach:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERREACH'                              , N'en-US', N'Marketo', null, null, N'Marketo Social Twitter Reach:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKEDINREACH'                             , N'en-US', N'Marketo', null, null, N'Marketo Social LinkedIn Reach:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FACEBOOKREFERREDVISITS'                    , N'en-US', N'Marketo', null, null, N'Marketo Social Facebook Referred Visits:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERREFERREDVISITS'                     , N'en-US', N'Marketo', null, null, N'Marketo Social Twitter Referred Visits:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKEDINREFERREDVISITS'                    , N'en-US', N'Marketo', null, null, N'Marketo Social LinkedIn Referred Visits:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TOTALREFERREDVISITS'                       , N'en-US', N'Marketo', null, null, N'Marketo Social Total Referred Visits:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FACEBOOKREFERREDENROLLMENTS'               , N'en-US', N'Marketo', null, null, N'Marketo Social Facebook Referred Enrollments:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERREFERREDENROLLMENTS'                , N'en-US', N'Marketo', null, null, N'Marketo Social Twitter Referred Enrollments:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKEDINREFERREDENROLLMENTS'               , N'en-US', N'Marketo', null, null, N'Marketo Social LinkedIn Referred Enrollments:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TOTALREFERREDENROLLMENTS'                  , N'en-US', N'Marketo', null, null, N'Marketo Social Total Referred Enrollments:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LASTREFERREDVISIT'                         , N'en-US', N'Marketo', null, null, N'Marketo Social Last Referred Visit:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LASTREFERREDENROLLMENT'                    , N'en-US', N'Marketo', null, null, N'Marketo Social Last Referred Enrollment:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNDICATIONID'                             , N'en-US', N'Marketo', null, null, N'Marketo Social Syndication ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FACEBOOKID'                                , N'en-US', N'Marketo', null, null, N'Marketo Social Facebook ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERID'                                 , N'en-US', N'Marketo', null, null, N'Marketo Social Twitter ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKEDINID'                                , N'en-US', N'Marketo', null, null, N'Marketo Social LinkedIn ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACQUISITIONPROGRAMID'                      , N'en-US', N'Marketo', null, null, N'Acquisition Program:';
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

call dbo.spTERMINOLOGY_Marketo_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Marketo_en_us')
/
-- #endif IBM_DB2 */

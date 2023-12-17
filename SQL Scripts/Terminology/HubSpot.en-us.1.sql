

print 'TERMINOLOGY HubSpot en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'HubSpot';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_HUBSPOT_TITLE'                      , N'en-US', N'HubSpot', null, null, N'HubSpot &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_HUBSPOT'                            , N'en-US', N'HubSpot', null, null, N'Configure HubSpot Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HUBSPOT_SETTINGS'                          , N'en-US', N'HubSpot', null, null, N'HubSpot Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_PORTAL_ID'                           , N'en-US', N'HubSpot', null, null, N'HubSpot PortalID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_ID'                           , N'en-US', N'HubSpot', null, null, N'HubSpot ClientID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_CLIENT_SECRET'                       , N'en-US', N'HubSpot', null, null, N'HubSpot Secret Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_ACCESS_TOKEN'                        , N'en-US', N'HubSpot', null, null, N'HubSpot Access Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_REFRESH_TOKEN'                       , N'en-US', N'HubSpot', null, null, N'HubSpot Refresh Token:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OAUTH_EXPIRES_AT'                          , N'en-US', N'HubSpot', null, null, N'Access Token Expires:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HUBSPOT_ENABLED'                           , N'en-US', N'HubSpot', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'HubSpot', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'HubSpot', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'HubSpot', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'HubSpot', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                              , N'en-US', N'HubSpot', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUTHORIZE_BUTTON_LABEL'                    , N'en-US', N'HubSpot', null, null, N'Authorize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REFRESH_TOKEN_LABEL'                       , N'en-US', N'HubSpot', null, null, N'Refresh Token';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'HubSpot', null, null, N'Connection successful.';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'HubSpot', null, null, N'Hub';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HUBSPOT'                                   , N'en-US', N'Import', null, null, N'HubSpot &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_HUBSPOT_TITLE'                      , N'en-US', N'Import', null, null, N'You will first need to sign-in to HubSpot &reg; in order to connect and retrieve the contacts.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'HubSpot', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'HubSpot', null, null, N'<p>
In order to use HubSpot authentication or to allow the import of HubSpot contacts, 
you will need to create a HubSpot applicaton.  Once a HubSpot application has been created, 
you can provide the PortalID, ClientID and the Secret key below.</p>
<p>
For instructions on how to create a HubSpot application, please follow the 
<a href="http://developers.hubspot.com/docs/overview" target="_default">Instructions</a> on the HubSpot site. 
</p>
<p>Access Token, Refresh Token and Token Expires will all be populated during the Authorize process.
</p>';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                , N'en-US', null, N'hubspot_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                   , N'en-US', null, N'hubspot_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                 , N'en-US', null, N'hubspot_sync_direction'         ,   3, N'from crm only';

exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                         , N'en-US', null, N'hubspot_sync_module'            ,   1, N'CRM Leads to HubSpot Contacts';
exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                      , N'en-US', null, N'hubspot_sync_module'            ,   2, N'CRM Contacts/Accounts to HubSpot Contacts/Companies';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'HubSpot'                                       , N'en-US', null, N'moduleList', 133, N'HubSpot';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTACT_INFORMATION'                           , N'en-US', N'HubSpot', null, null, N'Contact Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOCIAL_MEDIA_INFORMATION'                      , N'en-US', N'HubSpot', null, null, N'Social Media Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL_INFORMATION'                             , N'en-US', N'HubSpot', null, null, N'Email Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WEB_ANALYTICS_HISTORY'                         , N'en-US', N'HubSpot', null, null, N'Web Analytics History';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONVERSION_INFORMATION'                        , N'en-US', N'HubSpot', null, null, N'Conversion Information';

-- Company Information
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_LEAD_STATUS'                                , N'en-US', N'HubSpot', null, null, N'Lead Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRST_CONTACT_CREATEDATE'                      , N'en-US', N'HubSpot', null, null, N'First Contact Create Date:';

-- Contact Information
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ID'                                            , N'en-US', N'HubSpot', null, null, N'HubSpot ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANNUALREVENUE'                                 , N'en-US', N'HubSpot', null, null, N'Annual Revenue:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_LIFECYCLESTAGE_CUSTOMER_DATE'               , N'en-US', N'HubSpot', null, null, N'Became a Customer Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_LIFECYCLESTAGE_LEAD_DATE'                   , N'en-US', N'HubSpot', null, null, N'Became a Lead Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_LIFECYCLESTAGE_MARKETINGQUALIFIEDLEAD_DATE' , N'en-US', N'HubSpot', null, null, N'Became a Marketing Qualified Lead Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_LIFECYCLESTAGE_OPPORTUNITY_DATE'            , N'en-US', N'HubSpot', null, null, N'Became an Opportunity Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_LIFECYCLESTAGE_SALESQUALIFIEDLEAD_DATE'     , N'en-US', N'HubSpot', null, null, N'Lifecycle Stage Sales Qualified Lead Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_LIFECYCLESTAGE_EVANGELIST_DATE'             , N'en-US', N'HubSpot', null, null, N'Lifecycle Stage Evangelist Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_LIFECYCLESTAGE_SUBSCRIBER_DATE'             , N'en-US', N'HubSpot', null, null, N'Lifecycle Stage Subscriber Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_LIFECYCLESTAGE_OTHER_DATE'                  , N'en-US', N'HubSpot', null, null, N'Lifecycle Stage Other Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CITY'                                          , N'en-US', N'HubSpot', null, null, N'City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CLOSEDATE'                                     , N'en-US', N'HubSpot', null, null, N'Close Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY'                                       , N'en-US', N'HubSpot', null, null, N'Company Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRY'                                       , N'en-US', N'HubSpot', null, null, N'Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREATEDATE'                                    , N'en-US', N'HubSpot', null, null, N'Create Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DAYS_TO_CLOSE'                                 , N'en-US', N'HubSpot', null, null, N'Days To Close:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BLOG_DEFAULT_HUBSPOT_BLOG_SUBSCRIPTION'        , N'en-US', N'HubSpot', null, null, N'Default HubSpot Blog Email Subscription:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL'                                         , N'en-US', N'HubSpot', null, null, N'Email:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FAX'                                           , N'en-US', N'HubSpot', null, null, N'Fax:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRSTNAME'                                     , N'en-US', N'HubSpot', null, null, N'First Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HUBSPOT_OWNER_ID'                              , N'en-US', N'HubSpot', null, null, N'HubSpot Owner:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HUBSPOTSCORE'                                  , N'en-US', N'HubSpot', null, null, N'HubSpot Score:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IPADDRESS'                                     , N'en-US', N'HubSpot', null, null, N'IP Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INDUSTRY'                                      , N'en-US', N'HubSpot', null, null, N'Industry:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_JOBTITLE'                                      , N'en-US', N'HubSpot', null, null, N'Job Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LASTMODIFIEDDATE'                              , N'en-US', N'HubSpot', null, null, N'Last Modified Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LASTNAME'                                      , N'en-US', N'HubSpot', null, null, N'Last Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIFECYCLESTAGE'                                , N'en-US', N'HubSpot', null, null, N'Lifecycle Stage:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MOBILEPHONE'                                   , N'en-US', N'HubSpot', null, null, N'Mobile Phone Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MESSAGE'                                       , N'en-US', N'HubSpot', null, null, N'Notes:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NUMEMPLOYEES'                                  , N'en-US', N'HubSpot', null, null, N'Number of Employees:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HUBSPOT_OWNER_ASSIGNEDDATE'                    , N'en-US', N'HubSpot', null, null, N'Owner Assigned Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_PERSONA'                                    , N'en-US', N'HubSpot', null, null, N'Persona:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE'                                         , N'en-US', N'HubSpot', null, null, N'Phone Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ZIP'                                           , N'en-US', N'HubSpot', null, null, N'Postal Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALUTATION'                                    , N'en-US', N'HubSpot', null, null, N'Salutation:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATE'                                         , N'en-US', N'HubSpot', null, null, N'State/Region:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS'                                       , N'en-US', N'HubSpot', null, null, N'Street Address';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WEBSITE'                                       , N'en-US', N'HubSpot', null, null, N'Website URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHOTO'                                         , N'en-US', N'HubSpot', null, null, N'Photo:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEYMONKEYEVENTLASTUPDATED'                  , N'en-US', N'HubSpot', null, null, N'Survey Monkey Event Last Update:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WEBINAREVENTLASTUPDATED'                       , N'en-US', N'HubSpot', null, null, N'Webinar Event Last Updated:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASSOCIATEDCOMPANYLASTUPDATED'                  , N'en-US', N'HubSpot', null, null, N'Associated Company Last Updated:';

-- Social Media Information
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_SOCIAL_NUM_BROADCAST_CLICKS'                , N'en-US', N'HubSpot', null, null, N'Broadcast Clicks:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_SOCIAL_FACEBOOK_CLICKS'                     , N'en-US', N'HubSpot', null, null, N'Facebook Clicks:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FOLLOWERCOUNT'                                 , N'en-US', N'HubSpot', null, null, N'Follower Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FACEBOOKFANS'                                  , N'en-US', N'HubSpot', null, null, N'Facebook Fans:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_SOCIAL_GOOGLE_PLUS_CLICKS'                  , N'en-US', N'HubSpot', null, null, N'Google Plus Clicks:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_KLOUTSCOREGENERAL'                             , N'en-US', N'HubSpot', null, null, N'Klout Score:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKEDINBIO'                                   , N'en-US', N'HubSpot', null, null, N'LinkedIn Bio:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_SOCIAL_LINKEDIN_CLICKS'                     , N'en-US', N'HubSpot', null, null, N'LinkedIn Clicks:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKEDINCONNECTIONS'                           , N'en-US', N'HubSpot', null, null, N'LinkedIn Connections:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_SOCIAL_LAST_ENGAGEMENT'                     , N'en-US', N'HubSpot', null, null, N'Most Recent Social Click:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERBIO'                                    , N'en-US', N'HubSpot', null, null, N'Twitter Bio:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_SOCIAL_TWITTER_CLICKS'                      , N'en-US', N'HubSpot', null, null, N'Twitter Clicks:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERPROFILEPHOTO'                           , N'en-US', N'HubSpot', null, null, N'Twitter Profile Photo:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTERHANDLE'                                 , N'en-US', N'HubSpot', null, null, N'Twitter Username:';

-- Email Information
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CURRENTLYINWORKFLOW'                           , N'en-US', N'HubSpot', null, null, N'Currently in workflow:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAILCONFIRMATIONSTATUS'                    , N'en-US', N'HubSpot', null, null, N'Email Confirmation Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_BOUNCE'                               , N'en-US', N'HubSpot', null, null, N'Emails Bounced:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_CLICK'                                , N'en-US', N'HubSpot', null, null, N'Emails Clicked:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_DELIVERED'                            , N'en-US', N'HubSpot', null, null, N'Emails Delivered:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_OPEN'                                 , N'en-US', N'HubSpot', null, null, N'Emails Opened:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_FIRST_CLICK_DATE'                     , N'en-US', N'HubSpot', null, null, N'First email click date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_FIRST_OPEN_DATE'                      , N'en-US', N'HubSpot', null, null, N'First email open date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_FIRST_SEND_DATE'                      , N'en-US', N'HubSpot', null, null, N'First email send date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_LAST_CLICK_DATE'                      , N'en-US', N'HubSpot', null, null, N'Last email click date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_LAST_EMAIL_NAME'                      , N'en-US', N'HubSpot', null, null, N'Last email name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_LAST_OPEN_DATE'                       , N'en-US', N'HubSpot', null, null, N'Last email open date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_LAST_SEND_DATE'                       , N'en-US', N'HubSpot', null, null, N'Last email send date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_OPTOUT'                               , N'en-US', N'HubSpot', null, null, N'Opted out of all email:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_OPTOUT_384887'                        , N'en-US', N'HubSpot', null, null, N'Opted out of email: Marketing Information:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_IS_INELIGIBLE'                        , N'en-US', N'HubSpot', null, null, N'Email Is Ineligible:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_EMAIL_LASTUPDATED'                          , N'en-US', N'HubSpot', null, null, N'Email Last Update:';

-- Web Analytics History
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_AVERAGE_PAGE_VIEWS'               , N'en-US', N'HubSpot', null, null, N'Average Pageviews:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_FIRST_URL'                        , N'en-US', N'HubSpot', null, null, N'First Page Seen:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_FIRST_REFERRER'                   , N'en-US', N'HubSpot', null, null, N'First Referring Site:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_LAST_URL'                         , N'en-US', N'HubSpot', null, null, N'Last Page Seen:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_LAST_REFERRER'                    , N'en-US', N'HubSpot', null, null, N'Last Referring Site:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_NUM_PAGE_VIEWS'                   , N'en-US', N'HubSpot', null, null, N'Number of Pageviews:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_NUM_VISITS'                       , N'en-US', N'HubSpot', null, null, N'Number of Visits:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_NUM_EVENT_COMPLETIONS'            , N'en-US', N'HubSpot', null, null, N'Number of event completions:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_SOURCE_DATA_1'                    , N'en-US', N'HubSpot', null, null, N'Original Source Data 1:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_SOURCE_DATA_2'                    , N'en-US', N'HubSpot', null, null, N'Original Source Data 2:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_SOURCE'                           , N'en-US', N'HubSpot', null, null, N'Original Source Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_REVENUE'                          , N'en-US', N'HubSpot', null, null, N'Revenue:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_FIRST_TIMESTAMP'                  , N'en-US', N'HubSpot', null, null, N'Time First Seen:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_LAST_TIMESTAMP'                   , N'en-US', N'HubSpot', null, null, N'Time Last Seen:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_FIRST_VISIT_TIMESTAMP'            , N'en-US', N'HubSpot', null, null, N'Time of First Visit:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HS_ANALYTICS_LAST_VISIT_TIMESTAMP'             , N'en-US', N'HubSpot', null, null, N'Time of Last Session:';

-- Conversion Information
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRST_CONVERSION_EVENT_NAME'                   , N'en-US', N'HubSpot', null, null, N'First Conversion:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRST_CONVERSION_DATE'                         , N'en-US', N'HubSpot', null, null, N'First Conversion Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IP_CITY'                                       , N'en-US', N'HubSpot', null, null, N'IP City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IP_COUNTRY'                                    , N'en-US', N'HubSpot', null, null, N'IP Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IP_STATE'                                      , N'en-US', N'HubSpot', null, null, N'IP State/Region:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IP_LATLON'                                     , N'en-US', N'HubSpot', null, null, N'IP Longitude/Latitude:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NUM_CONVERSION_EVENTS'                         , N'en-US', N'HubSpot', null, null, N'Number of Form Submissions:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NUM_UNIQUE_CONVERSION_EVENTS'                  , N'en-US', N'HubSpot', null, null, N'Number of Unique Forms Submitted:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RECENT_CONVERSION_DATE'                        , N'en-US', N'HubSpot', null, null, N'Recent Conversion Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RECENT_CONVERSION_EVENT_NAME'                  , N'en-US', N'HubSpot', null, null, N'Recent Conversion:';
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

call dbo.spTERMINOLOGY_HubSpot_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_HubSpot_en_us')
/
-- #endif IBM_DB2 */

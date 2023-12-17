

print 'DETAILVIEWS_FIELDS Cloud Services';

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.iCloud';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.iCloud' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.iCloud';
	exec dbo.spDETAILVIEWS_InsertOnly           'Contacts.DetailView.iCloud'    , 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    ,  0, 'Contacts.LBL_NAME'               , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    ,  1, 'Contacts.LBL_OFFICE_PHONE'       , 'PHONE_WORK'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    ,  2, 'Contacts.LBL_MOBILE_PHONE'       , 'PHONE_MOBILE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    ,  3, 'Contacts.LBL_HOME_PHONE'         , 'PHONE_HOME'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Contacts.DetailView.iCloud'    ,  4, 'Contacts.LBL_LEAD_SOURCE'        , 'LEAD_SOURCE'                      , '{0}'        , 'lead_source_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    ,  5, 'Contacts.LBL_OTHER_PHONE'        , 'PHONE_OTHER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    ,  6, 'Contacts.LBL_TITLE'              , 'TITLE'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    ,  7, 'Contacts.LBL_FAX_PHONE'          , 'PHONE_FAX'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    ,  8, 'Contacts.LBL_DEPARTMENT'         , 'DEPARTMENT'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Contacts.DetailView.iCloud'    ,  9, 'Contacts.LBL_EMAIL_ADDRESS'      , 'EMAIL1'                           , '{0}'        , 'EMAIL1', 'mailto:{0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    , 10, 'Contacts.LBL_BIRTHDATE'          , 'BIRTHDATE'                        , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Contacts.DetailView.iCloud'    , 11, 'Contacts.LBL_OTHER_EMAIL_ADDRESS', 'EMAIL2'                           , '{0}'        , 'EMAIL2', 'mailto:{0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    , 12, 'Contacts.LBL_ASSISTANT'          , 'ASSISTANT'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    , 13, 'Contacts.LBL_ASSISTANT_PHONE'    , 'ASSISTANT_PHONE'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    , 14, '.LBL_DATE_MODIFIED'              , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Contacts.DetailView.iCloud'    , 15, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    , 16, 'Contacts.LBL_PRIMARY_ADDRESS'    , 'PRIMARY_ADDRESS_STREET PRIMARY_ADDRESS_CITY PRIMARY_ADDRESS_STATE PRIMARY_ADDRESS_POSTALCODE', '{0}<br />{1}, {2} {3}<br />', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    , 17, 'Contacts.LBL_ALTERNATE_ADDRESS'  , 'ALT_ADDRESS_STREET ALT_ADDRESS_CITY ALT_ADDRESS_STATE ALT_ADDRESS_POSTALCODE', '{0}<br />{1}, {2} {3}<br />', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly    'Contacts.DetailView.iCloud'    , 18, 'TextBox', 'Contacts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    , 14, 'Teams.LBL_TEAM'                  , 'TEAM_NAME'                        , '{0}'        , null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    , 16, '.LBL_ASSIGNED_TO'                , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.iCloud'    , 16, '.LBL_DATE_ENTERED'               , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Meetings.DetailView.iCloud' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Meetings.DetailView.iCloud';
	exec dbo.spDETAILVIEWS_InsertOnly           'Meetings.DetailView.iCloud'    , 'Meetings', 'vwMEETINGS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Meetings.DetailView.iCloud'    ,  0, 'Meetings.LBL_SUBJECT'             , 'NAME'                                                                         , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Meetings.DetailView.iCloud'    ,  1, 'Meetings.LBL_STATUS'              , 'STATUS'                                                                       , '{0}'            , 'meeting_status_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Meetings.DetailView.iCloud'    ,  2, 'Meetings.LBL_LOCATION'            , 'LOCATION'                                                                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Meetings.DetailView.iCloud'    ,  3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Meetings.DetailView.iCloud'    ,  4, 'Meetings.LBL_DATE_TIME'           , 'DATE_TIME'                                                                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Meetings.DetailView.iCloud'    ,  5, 'Meetings.LBL_DURATION'            , 'DURATION_HOURS Calls.LBL_HOURS_ABBREV DURATION_MINUTES Calls.LBL_MINSS_ABBREV', '{0} {1} {2} {3}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Meetings.DetailView.iCloud'    ,  7, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED'                                                                , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Meetings.DetailView.iCloud'    ,  8, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED'                                                                 , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly    'Meetings.DetailView.iCloud'    ,  9, 'TextBox', 'Meetings.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Meetings.DetailView.iCloud'    ,  6, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                                                                    , '{0}'            , null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Meetings.DetailView.iCloud'    ,  8, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                                                             , '{0}'            , null;
end -- if;
GO

-- 04/28/2015 Paul.  Add HubSpot layout. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.HubSpot';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.HubSpot' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Accounts.DetailView.HubSpot';
	exec dbo.spDETAILVIEWS_InsertOnly           'Accounts.DetailView.HubSpot'   , 'Accounts', 'vwACCOUNTS_HubSpot', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  0, 'HubSpot.LBL_ID'                                , 'id'                                , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  1, 'HubSpot.LBL_HUBSPOTSCORE'                      , 'hubspotscore'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  2, 'HubSpot.LBL_CREATEDATE'                        , 'createdate'                        , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  3, 'HubSpot.LBL_LASTMODIFIEDDATE'                  , 'lastmodifieddate'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  4, 'HubSpot.LBL_CLOSEDATE'                         , 'closedate'                         , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  5, 'HubSpot.LBL_DAYS_TO_CLOSE'                     , 'days_to_close'                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  6, 'HubSpot.LBL_LIFECYCLESTAGE'                    , 'lifecyclestage'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  7, 'HubSpot.LBL_HS_LEAD_STATUS'                    , 'hs_lead_status'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  8, 'HubSpot.LBL_FOLLOWERCOUNT'                     , 'twitterfollowers'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   ,  9, 'HubSpot.LBL_FACEBOOKFANS'                      , 'facebookfans'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 10, 'HubSpot.LBL_FIRST_CONTACT_CREATEDATE'          , 'first_contact_createdate'          , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 11, 'HubSpot.LBL_FIRST_CONVERSION_DATE'             , 'first_conversion_date'             , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 12, 'HubSpot.LBL_FIRST_CONVERSION_EVENT_NAME'       , 'first_conversion_event_name'       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 13, 'HubSpot.LBL_HS_ANALYTICS_SOURCE'               , 'hs_analytics_source'               , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 14, 'HubSpot.LBL_HS_ANALYTICS_SOURCE_DATA_1'        , 'hs_analytics_source_data_1'        , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 15, 'HubSpot.LBL_HS_ANALYTICS_SOURCE_DATA_2'        , 'hs_analytics_source_data_2'        , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 16, 'HubSpot.LBL_HS_ANALYTICS_FIRST_TIMESTAMP'      , 'hs_analytics_first_timestamp'      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 17, 'HubSpot.LBL_HS_ANALYTICS_LAST_TIMESTAMP'       , 'hs_analytics_last_timestamp'       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 18, 'HubSpot.LBL_HS_ANALYTICS_FIRST_VISIT_TIMESTAMP', 'hs_analytics_first_visit_timestamp', '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 19, 'HubSpot.LBL_HS_ANALYTICS_LAST_VISIT_TIMESTAMP' , 'hs_analytics_last_visit_timestamp' , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 20, 'HubSpot.LBL_HS_ANALYTICS_NUM_PAGE_VIEWS'       , 'hs_analytics_num_page_views'       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 21, 'HubSpot.LBL_HS_ANALYTICS_NUM_VISITS'           , 'hs_analytics_num_visits'           , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 22, 'HubSpot.LBL_NUM_CONVERSION_EVENTS'             , 'num_conversion_events'             , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 23, 'HubSpot.LBL_RECENT_CONVERSION_DATE'            , 'recent_conversion_date'            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.HubSpot'   , 24, 'HubSpot.LBL_RECENT_CONVERSION_EVENT_NAME'      , 'recent_conversion_event_name'      , '{0}'            , null;
end -- if;
GO

-- 04/28/2015 Paul.  Add HubSpot layout. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.HubSpot';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.HubSpot' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.HubSpot';
	exec dbo.spDETAILVIEWS_InsertOnly           'Contacts.DetailView.HubSpot'   , 'Contacts', 'vwCONTACTS_HubSpot', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Contacts.DetailView.HubSpot'   ,  0, 'HubSpot.LBL_CONTACT_INFORMATION', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   ,  1, 'HubSpot.LBL_ID'                                            , 'id'                                            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   ,  2, 'HubSpot.LBL_HUBSPOTSCORE'                                  , 'hubspotscore'                                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   ,  3, 'HubSpot.LBL_CREATEDATE'                                    , 'createdate'                                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   ,  4, 'HubSpot.LBL_LASTMODIFIEDDATE'                              , 'lastmodifieddate'                              , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   ,  5, 'HubSpot.LBL_CLOSEDATE'                                     , 'closedate'                                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   ,  6, 'HubSpot.LBL_DAYS_TO_CLOSE'                                 , 'days_to_close'                                 , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   ,  7, 'HubSpot.LBL_LIFECYCLESTAGE'                                , 'lifecyclestage'                                , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   ,  8, 'HubSpot.LBL_HS_LIFECYCLESTAGE_CUSTOMER_DATE'               , 'hs_lifecyclestage_customer_date'               , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   ,  9, 'HubSpot.LBL_HS_LIFECYCLESTAGE_LEAD_DATE'                   , 'hs_lifecyclestage_lead_date'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 10, 'HubSpot.LBL_HS_LIFECYCLESTAGE_MARKETINGQUALIFIEDLEAD_DATE' , 'hs_lifecyclestage_marketingqualifiedlead_date' , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 11, 'HubSpot.LBL_HS_LIFECYCLESTAGE_OPPORTUNITY_DATE'            , 'hs_lifecyclestage_opportunity_date'            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 12, 'HubSpot.LBL_HS_LIFECYCLESTAGE_SALESQUALIFIEDLEAD_DATE'     , 'hs_lifecyclestage_salesqualifiedlead_date'     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 13, 'HubSpot.LBL_HS_LIFECYCLESTAGE_EVANGELIST_DATE'             , 'hs_lifecyclestage_evangelist_date'             , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 14, 'HubSpot.LBL_HS_LIFECYCLESTAGE_SUBSCRIBER_DATE'             , 'hs_lifecyclestage_subscriber_date'             , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 15, 'HubSpot.LBL_HS_LIFECYCLESTAGE_OTHER_DATE'                  , 'hs_lifecyclestage_other_date'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 16, 'HubSpot.LBL_ASSOCIATEDCOMPANYLASTUPDATED'                  , 'associatedcompanylastupdated'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 17, 'HubSpot.LBL_HUBSPOT_OWNER_ASSIGNEDDATE'                    , 'hubspot_owner_assigneddate'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 18, 'HubSpot.LBL_SURVEYMONKEYEVENTLASTUPDATED'                  , 'surveymonkeyeventlastupdated'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 19, 'HubSpot.LBL_WEBINAREVENTLASTUPDATED'                       , 'webinareventlastupdated'                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Contacts.DetailView.HubSpot'   , 20, null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Contacts.DetailView.HubSpot'   , 21, 'HubSpot.LBL_SOCIAL_MEDIA_INFORMATION', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 22, 'HubSpot.LBL_HS_SOCIAL_NUM_BROADCAST_CLICKS'                , 'hs_social_num_broadcast_clicks'                , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 23, 'HubSpot.LBL_HS_SOCIAL_FACEBOOK_CLICKS'                     , 'hs_social_facebook_clicks'                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 24, 'HubSpot.LBL_FOLLOWERCOUNT'                                 , 'followercount'                                 , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 25, 'HubSpot.LBL_HS_SOCIAL_GOOGLE_PLUS_CLICKS'                  , 'hs_social_google_plus_clicks'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 26, 'HubSpot.LBL_KLOUTSCOREGENERAL'                             , 'kloutscoregeneral'                             , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 27, 'HubSpot.LBL_HS_SOCIAL_LINKEDIN_CLICKS'                     , 'hs_social_linkedin_clicks'                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 28, 'HubSpot.LBL_LINKEDINCONNECTIONS'                           , 'linkedinconnections'                           , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 29, 'HubSpot.LBL_HS_SOCIAL_LAST_ENGAGEMENT'                     , 'hs_social_last_engagement'                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 30, 'HubSpot.LBL_HS_SOCIAL_TWITTER_CLICKS'                      , 'hs_social_twitter_clicks'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Contacts.DetailView.HubSpot'   , 31, null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Contacts.DetailView.HubSpot'   , 32, 'HubSpot.LBL_EMAIL_INFORMATION', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 33, 'HubSpot.LBL_CURRENTLYINWORKFLOW'                           , 'currentlyinworkflow'                           , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 34, 'HubSpot.LBL_HS_EMAILCONFIRMATIONSTATUS'                    , 'hs_emailconfirmationstatus'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 35, 'HubSpot.LBL_HS_EMAIL_BOUNCE'                               , 'hs_email_bounce'                               , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 36, 'HubSpot.LBL_HS_EMAIL_CLICK'                                , 'hs_email_click'                                , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 37, 'HubSpot.LBL_HS_EMAIL_DELIVERED'                            , 'hs_email_delivered'                            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 38, 'HubSpot.LBL_HS_EMAIL_OPEN'                                 , 'hs_email_open'                                 , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 39, 'HubSpot.LBL_HS_EMAIL_FIRST_CLICK_DATE'                     , 'hs_email_first_click_date'                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 40, 'HubSpot.LBL_HS_EMAIL_FIRST_OPEN_DATE'                      , 'hs_email_first_open_date'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 41, 'HubSpot.LBL_HS_EMAIL_FIRST_SEND_DATE'                      , 'hs_email_first_send_date'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 42, 'HubSpot.LBL_HS_EMAIL_LAST_CLICK_DATE'                      , 'hs_email_last_click_date'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 43, 'HubSpot.LBL_HS_EMAIL_LAST_EMAIL_NAME'                      , 'hs_email_last_email_name'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 44, 'HubSpot.LBL_HS_EMAIL_LAST_OPEN_DATE'                       , 'hs_email_last_open_date'                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 45, 'HubSpot.LBL_HS_EMAIL_LAST_SEND_DATE'                       , 'hs_email_last_send_date'                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 46, 'HubSpot.LBL_HS_EMAIL_OPTOUT'                               , 'hs_email_optout'                               , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 47, 'HubSpot.LBL_HS_EMAIL_IS_INELIGIBLE'                        , 'hs_email_is_ineligible'                        , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 48, 'HubSpot.LBL_HS_EMAIL_LASTUPDATED'                          , 'hs_email_lastupdated'                          , '{0}'            , null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Contacts.DetailView.HubSpot'   , 49, 'HubSpot.LBL_WEB_ANALYTICS_HISTORY', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 50, 'HubSpot.LBL_HS_ANALYTICS_AVERAGE_PAGE_VIEWS'               , 'hs_analytics_average_page_views'               , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 51, 'HubSpot.LBL_HS_ANALYTICS_FIRST_URL'                        , 'hs_analytics_first_url'                        , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 52, 'HubSpot.LBL_HS_ANALYTICS_FIRST_REFERRER'                   , 'hs_analytics_first_referrer'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 53, 'HubSpot.LBL_HS_ANALYTICS_LAST_URL'                         , 'hs_analytics_last_url'                         , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 54, 'HubSpot.LBL_HS_ANALYTICS_LAST_REFERRER'                    , 'hs_analytics_last_referrer'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 55, 'HubSpot.LBL_HS_ANALYTICS_NUM_PAGE_VIEWS'                   , 'hs_analytics_num_page_views'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 56, 'HubSpot.LBL_HS_ANALYTICS_NUM_VISITS'                       , 'hs_analytics_num_visits'                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 57, 'HubSpot.LBL_HS_ANALYTICS_NUM_EVENT_COMPLETIONS'            , 'hs_analytics_num_event_completions'            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 58, 'HubSpot.LBL_HS_ANALYTICS_SOURCE_DATA_1'                    , 'hs_analytics_source_data_1'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 59, 'HubSpot.LBL_HS_ANALYTICS_SOURCE_DATA_2'                    , 'hs_analytics_source_data_2'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 60, 'HubSpot.LBL_HS_ANALYTICS_SOURCE'                           , 'hs_analytics_source'                           , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 61, 'HubSpot.LBL_HS_ANALYTICS_REVENUE'                          , 'hs_analytics_revenue'                          , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 62, 'HubSpot.LBL_HS_ANALYTICS_FIRST_TIMESTAMP'                  , 'hs_analytics_first_timestamp'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 63, 'HubSpot.LBL_HS_ANALYTICS_LAST_TIMESTAMP'                   , 'hs_analytics_last_timestamp'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 64, 'HubSpot.LBL_HS_ANALYTICS_FIRST_VISIT_TIMESTAMP'            , 'hs_analytics_first_visit_timestamp'            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 65, 'HubSpot.LBL_HS_ANALYTICS_LAST_VISIT_TIMESTAMP'             , 'hs_analytics_last_visit_timestamp'             , '{0}'            , null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Contacts.DetailView.HubSpot'   , 66, 'HubSpot.LBL_CONVERSION_INFORMATION', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 67, 'HubSpot.LBL_FIRST_CONVERSION_EVENT_NAME'                   , 'first_conversion_event_name'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 68, 'HubSpot.LBL_FIRST_CONVERSION_DATE'                         , 'first_conversion_date'                         , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 69, 'HubSpot.LBL_IP_CITY'                                       , 'ip_city'                                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 70, 'HubSpot.LBL_IP_COUNTRY'                                    , 'ip_country'                                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 71, 'HubSpot.LBL_IP_STATE'                                      , 'ip_state'                                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 72, 'HubSpot.LBL_NUM_CONVERSION_EVENTS'                         , 'num_conversion_events'                         , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 73, 'HubSpot.LBL_NUM_UNIQUE_CONVERSION_EVENTS'                  , 'num_unique_conversion_events'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 74, 'HubSpot.LBL_RECENT_CONVERSION_DATE'                        , 'recent_conversion_date'                        , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.HubSpot'   , 75, 'HubSpot.LBL_RECENT_CONVERSION_EVENT_NAME'                  , 'recent_conversion_event_name'                  , '{0}'            , null;
end -- if;
GO

-- 04/28/2015 Paul.  Add HubSpot layout. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.HubSpot';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.HubSpot' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Leads.DetailView.HubSpot';
	exec dbo.spDETAILVIEWS_InsertOnly           'Leads.DetailView.HubSpot'   , 'Leads', 'vwLEADS_HubSpot', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Leads.DetailView.HubSpot'   ,  0, 'HubSpot.LBL_CONTACT_INFORMATION', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   ,  1, 'HubSpot.LBL_ID'                                            , 'id'                                            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   ,  2, 'HubSpot.LBL_HUBSPOTSCORE'                                  , 'hubspotscore'                                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   ,  3, 'HubSpot.LBL_CREATEDATE'                                    , 'createdate'                                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   ,  4, 'HubSpot.LBL_LASTMODIFIEDDATE'                              , 'lastmodifieddate'                              , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   ,  5, 'HubSpot.LBL_CLOSEDATE'                                     , 'closedate'                                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   ,  6, 'HubSpot.LBL_DAYS_TO_CLOSE'                                 , 'days_to_close'                                 , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   ,  7, 'HubSpot.LBL_LIFECYCLESTAGE'                                , 'lifecyclestage'                                , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   ,  8, 'HubSpot.LBL_HS_LIFECYCLESTAGE_CUSTOMER_DATE'               , 'hs_lifecyclestage_customer_date'               , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   ,  9, 'HubSpot.LBL_HS_LIFECYCLESTAGE_LEAD_DATE'                   , 'hs_lifecyclestage_lead_date'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 10, 'HubSpot.LBL_HS_LIFECYCLESTAGE_MARKETINGQUALIFIEDLEAD_DATE' , 'hs_lifecyclestage_marketingqualifiedlead_date' , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 11, 'HubSpot.LBL_HS_LIFECYCLESTAGE_OPPORTUNITY_DATE'            , 'hs_lifecyclestage_opportunity_date'            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 12, 'HubSpot.LBL_HS_LIFECYCLESTAGE_SALESQUALIFIEDLEAD_DATE'     , 'hs_lifecyclestage_salesqualifiedlead_date'     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 13, 'HubSpot.LBL_HS_LIFECYCLESTAGE_EVANGELIST_DATE'             , 'hs_lifecyclestage_evangelist_date'             , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 14, 'HubSpot.LBL_HS_LIFECYCLESTAGE_SUBSCRIBER_DATE'             , 'hs_lifecyclestage_subscriber_date'             , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 15, 'HubSpot.LBL_HS_LIFECYCLESTAGE_OTHER_DATE'                  , 'hs_lifecyclestage_other_date'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 16, 'HubSpot.LBL_ASSOCIATEDCOMPANYLASTUPDATED'                  , 'associatedcompanylastupdated'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 17, 'HubSpot.LBL_HUBSPOT_OWNER_ASSIGNEDDATE'                    , 'hubspot_owner_assigneddate'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 18, 'HubSpot.LBL_SURVEYMONKEYEVENTLASTUPDATED'                  , 'surveymonkeyeventlastupdated'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 19, 'HubSpot.LBL_WEBINAREVENTLASTUPDATED'                       , 'webinareventlastupdated'                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Leads.DetailView.HubSpot'   , 20, null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Leads.DetailView.HubSpot'   , 21, 'HubSpot.LBL_SOCIAL_MEDIA_INFORMATION', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 22, 'HubSpot.LBL_HS_SOCIAL_NUM_BROADCAST_CLICKS'                , 'hs_social_num_broadcast_clicks'                , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 23, 'HubSpot.LBL_HS_SOCIAL_FACEBOOK_CLICKS'                     , 'hs_social_facebook_clicks'                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 24, 'HubSpot.LBL_FOLLOWERCOUNT'                                 , 'followercount'                                 , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 25, 'HubSpot.LBL_HS_SOCIAL_GOOGLE_PLUS_CLICKS'                  , 'hs_social_google_plus_clicks'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 26, 'HubSpot.LBL_KLOUTSCOREGENERAL'                             , 'kloutscoregeneral'                             , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 27, 'HubSpot.LBL_HS_SOCIAL_LINKEDIN_CLICKS'                     , 'hs_social_linkedin_clicks'                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 28, 'HubSpot.LBL_LINKEDINCONNECTIONS'                           , 'linkedinconnections'                           , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 29, 'HubSpot.LBL_HS_SOCIAL_LAST_ENGAGEMENT'                     , 'hs_social_last_engagement'                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 30, 'HubSpot.LBL_HS_SOCIAL_TWITTER_CLICKS'                      , 'hs_social_twitter_clicks'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Leads.DetailView.HubSpot'   , 31, null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Leads.DetailView.HubSpot'   , 32, 'HubSpot.LBL_EMAIL_INFORMATION', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 33, 'HubSpot.LBL_CURRENTLYINWORKFLOW'                           , 'currentlyinworkflow'                           , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 34, 'HubSpot.LBL_HS_EMAILCONFIRMATIONSTATUS'                    , 'hs_emailconfirmationstatus'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 35, 'HubSpot.LBL_HS_EMAIL_BOUNCE'                               , 'hs_email_bounce'                               , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 36, 'HubSpot.LBL_HS_EMAIL_CLICK'                                , 'hs_email_click'                                , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 37, 'HubSpot.LBL_HS_EMAIL_DELIVERED'                            , 'hs_email_delivered'                            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 38, 'HubSpot.LBL_HS_EMAIL_OPEN'                                 , 'hs_email_open'                                 , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 39, 'HubSpot.LBL_HS_EMAIL_FIRST_CLICK_DATE'                     , 'hs_email_first_click_date'                     , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 40, 'HubSpot.LBL_HS_EMAIL_FIRST_OPEN_DATE'                      , 'hs_email_first_open_date'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 41, 'HubSpot.LBL_HS_EMAIL_FIRST_SEND_DATE'                      , 'hs_email_first_send_date'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 42, 'HubSpot.LBL_HS_EMAIL_LAST_CLICK_DATE'                      , 'hs_email_last_click_date'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 43, 'HubSpot.LBL_HS_EMAIL_LAST_EMAIL_NAME'                      , 'hs_email_last_email_name'                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 44, 'HubSpot.LBL_HS_EMAIL_LAST_OPEN_DATE'                       , 'hs_email_last_open_date'                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 45, 'HubSpot.LBL_HS_EMAIL_LAST_SEND_DATE'                       , 'hs_email_last_send_date'                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 46, 'HubSpot.LBL_HS_EMAIL_OPTOUT'                               , 'hs_email_optout'                               , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 47, 'HubSpot.LBL_HS_EMAIL_IS_INELIGIBLE'                        , 'hs_email_is_ineligible'                        , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 48, 'HubSpot.LBL_HS_EMAIL_LASTUPDATED'                          , 'hs_email_lastupdated'                          , '{0}'            , null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Leads.DetailView.HubSpot'   , 49, 'HubSpot.LBL_WEB_ANALYTICS_HISTORY', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 50, 'HubSpot.LBL_HS_ANALYTICS_AVERAGE_PAGE_VIEWS'               , 'hs_analytics_average_page_views'               , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 51, 'HubSpot.LBL_HS_ANALYTICS_FIRST_URL'                        , 'hs_analytics_first_url'                        , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 52, 'HubSpot.LBL_HS_ANALYTICS_FIRST_REFERRER'                   , 'hs_analytics_first_referrer'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 53, 'HubSpot.LBL_HS_ANALYTICS_LAST_URL'                         , 'hs_analytics_last_url'                         , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 54, 'HubSpot.LBL_HS_ANALYTICS_LAST_REFERRER'                    , 'hs_analytics_last_referrer'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 55, 'HubSpot.LBL_HS_ANALYTICS_NUM_PAGE_VIEWS'                   , 'hs_analytics_num_page_views'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 56, 'HubSpot.LBL_HS_ANALYTICS_NUM_VISITS'                       , 'hs_analytics_num_visits'                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 57, 'HubSpot.LBL_HS_ANALYTICS_NUM_EVENT_COMPLETIONS'            , 'hs_analytics_num_event_completions'            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 58, 'HubSpot.LBL_HS_ANALYTICS_SOURCE_DATA_1'                    , 'hs_analytics_source_data_1'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 59, 'HubSpot.LBL_HS_ANALYTICS_SOURCE_DATA_2'                    , 'hs_analytics_source_data_2'                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 60, 'HubSpot.LBL_HS_ANALYTICS_SOURCE'                           , 'hs_analytics_source'                           , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 61, 'HubSpot.LBL_HS_ANALYTICS_REVENUE'                          , 'hs_analytics_revenue'                          , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 62, 'HubSpot.LBL_HS_ANALYTICS_FIRST_TIMESTAMP'                  , 'hs_analytics_first_timestamp'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 63, 'HubSpot.LBL_HS_ANALYTICS_LAST_TIMESTAMP'                   , 'hs_analytics_last_timestamp'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 64, 'HubSpot.LBL_HS_ANALYTICS_FIRST_VISIT_TIMESTAMP'            , 'hs_analytics_first_visit_timestamp'            , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 65, 'HubSpot.LBL_HS_ANALYTICS_LAST_VISIT_TIMESTAMP'             , 'hs_analytics_last_visit_timestamp'             , '{0}'            , null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Leads.DetailView.HubSpot'   , 66, 'HubSpot.LBL_CONVERSION_INFORMATION', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 67, 'HubSpot.LBL_FIRST_CONVERSION_EVENT_NAME'                   , 'first_conversion_event_name'                   , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 68, 'HubSpot.LBL_FIRST_CONVERSION_DATE'                         , 'first_conversion_date'                         , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 69, 'HubSpot.LBL_IP_CITY'                                       , 'ip_city'                                       , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 70, 'HubSpot.LBL_IP_COUNTRY'                                    , 'ip_country'                                    , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 71, 'HubSpot.LBL_IP_STATE'                                      , 'ip_state'                                      , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 72, 'HubSpot.LBL_NUM_CONVERSION_EVENTS'                         , 'num_conversion_events'                         , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 73, 'HubSpot.LBL_NUM_UNIQUE_CONVERSION_EVENTS'                  , 'num_unique_conversion_events'                  , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 74, 'HubSpot.LBL_RECENT_CONVERSION_DATE'                        , 'recent_conversion_date'                        , '{0}'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.HubSpot'   , 75, 'HubSpot.LBL_RECENT_CONVERSION_EVENT_NAME'                  , 'recent_conversion_event_name'                  , '{0}'            , null;
end -- if;
GO

-- 05/20/2015 Paul.  Add Marketo layout. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.Marketo';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.Marketo' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Leads.DetailView.Marketo';
	exec dbo.spDETAILVIEWS_InsertOnly           'Leads.DetailView.Marketo', 'Leads', 'vwLEADS_Marketo', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   0, 'Marketo.LBL_ID'                         , 'id'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   1, 'Marketo.LBL_LEADSCORE'                  , 'leadScore'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   2, 'Marketo.LBL_CREATEDAT'                  , 'createdAt'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   3, 'Marketo.LBL_UPDATEDAT'                  , 'updatedAt'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   4, 'Marketo.LBL_URGENCY'                    , 'urgency'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   5, 'Marketo.LBL_PRIORITY'                   , 'priority'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   6, 'Marketo.LBL_RELATIVESCORE'              , 'relativeScore'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   7, 'Marketo.LBL_RATING'                     , 'rating'                     , '{0}', null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Leads.DetailView.Marketo',   8, 'Marketo.LBL_SOURCE_INFO', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   9, 'Marketo.LBL_LEADSOURCE'                 , 'leadSource'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  10, 'Marketo.LBL_LEADSTATUS'                 , 'leadStatus'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  11, 'Marketo.LBL_COOKIES'                    , 'cookies'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  12, 'Marketo.LBL_CONTACTCOMPANY'             , 'contactCompany'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  13, 'Marketo.LBL_PERSONTYPE'                 , 'personType'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  14, 'Marketo.LBL_LEADPERSON'                 , 'leadPerson'                 , '{0}', null;

	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  15, 'Marketo.LBL_ORIGINALSOURCETYPE'         , 'originalSourceType'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  16, 'Marketo.LBL_ORIGINALSOURCEINFO'         , 'originalSourceInfo'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  17, 'Marketo.LBL_REGISTRATIONSOURCETYPE'     , 'registrationSourceType'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  18, 'Marketo.LBL_REGISTRATIONSOURCEINFO'     , 'registrationSourceInfo'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  19, 'Marketo.LBL_ISLEAD'                     , 'isLead'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  20, 'Marketo.LBL_ISANONYMOUS'                , 'isAnonymous'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  21, 'Marketo.LBL_ANONYMOUSIP'                , 'anonymousIP'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  22, 'Marketo.LBL_INFERREDCOMPANY'            , 'inferredCompany'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  23, 'Marketo.LBL_INFERREDCITY'               , 'inferredCity'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  24, 'Marketo.LBL_INFERREDSTATEREGION'        , 'inferredStateRegion'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  25, 'Marketo.LBL_INFERREDPOSTALCODE'         , 'inferredPostalCode'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  26, 'Marketo.LBL_INFERREDCOUNTRY'            , 'inferredCountry'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  27, 'Marketo.LBL_INFERREDMETROPOLITANAREA'   , 'inferredMetropolitanArea'   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  28, 'Marketo.LBL_INFERREDPHONEAREACODE'      , 'inferredPhoneAreaCode'      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  29, 'Marketo.LBL_ORIGINALSEARCHENGINE'       , 'originalSearchEngine'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  30, 'Marketo.LBL_ORIGINALSEARCHPHRASE'       , 'originalSearchPhrase'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  31, 'Marketo.LBL_ORIGINALREFERRER'           , 'originalReferrer'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  32, 'Marketo.LBL_LEADROLE'                   , 'leadRole'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  33, 'Marketo.LBL_PERSONPRIMARYLEADINTEREST'  , 'personPrimaryLeadInterest'  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Leads.DetailView.Marketo',  34, null;

	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  35, 'Marketo.LBL_EMAILINVALID'               , 'emailInvalid'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  36, 'Marketo.LBL_EMAILINVALIDCAUSE'          , 'emailInvalidCause'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  37, 'Marketo.LBL_DONOTCALL'                  , 'doNotCall'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  38, 'Marketo.LBL_DONOTCALLREASON'            , 'doNotCallReason'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  39, 'Marketo.LBL_UNSUBSCRIBED'               , 'unsubscribed'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  40, 'Marketo.LBL_UNSUBSCRIBEDREASON'         , 'unsubscribedReason'         , '{0}', null;

	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Leads.DetailView.Marketo',  41, 'Marketo.LBL_SOCIAL_MEDIA', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  42, 'Marketo.LBL_FACEBOOKDISPLAYNAME'        , 'facebookDisplayName'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  43, 'Marketo.LBL_FACEBOOKID'                 , 'facebookId'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  44, 'Marketo.LBL_FACEBOOKPHOTOURL'           , 'facebookPhotoURL'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  45, 'Marketo.LBL_FACEBOOKPROFILEURL'         , 'facebookProfileURL'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  46, 'Marketo.LBL_FACEBOOKREACH'              , 'facebookReach'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  47, 'Marketo.LBL_FACEBOOKREFERREDENROLLMENTS', 'facebookReferredEnrollments', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  48, 'Marketo.LBL_FACEBOOKREFERREDVISITS'     , 'facebookReferredVisits'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  49, 'Marketo.LBL_GENDER'                     , 'gender'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  50, 'Marketo.LBL_LASTREFERREDENROLLMENT'     , 'lastReferredEnrollment'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  51, 'Marketo.LBL_LASTREFERREDVISIT'          , 'lastReferredVisit'          , '{0}', null;

	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  52, 'Marketo.LBL_LINKEDINDISPLAYNAME'        , 'linkedInDisplayName'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  53, 'Marketo.LBL_LINKEDINID'                 , 'linkedInId'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  54, 'Marketo.LBL_LINKEDINPHOTOURL'           , 'linkedInPhotoURL'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  55, 'Marketo.LBL_LINKEDINPROFILEURL'         , 'linkedInProfileURL'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  56, 'Marketo.LBL_LINKEDINREACH'              , 'linkedInReach'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  57, 'Marketo.LBL_LINKEDINREFERREDENROLLMENTS', 'linkedInReferredEnrollments', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  58, 'Marketo.LBL_LINKEDINREFERREDVISITS'     , 'linkedInReferredVisits'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Leads.DetailView.Marketo',  59, null;

	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  60, 'Marketo.LBL_TWITTERDISPLAYNAME'         , 'twitterDisplayName'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  61, 'Marketo.LBL_TWITTERID'                  , 'twitterId'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  62, 'Marketo.LBL_TWITTERPHOTOURL'            , 'twitterPhotoURL'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  63, 'Marketo.LBL_TWITTERPROFILEURL'          , 'twitterProfileURL'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  64, 'Marketo.LBL_TWITTERREACH'               , 'twitterReach'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  65, 'Marketo.LBL_TWITTERREFERREDENROLLMENTS' , 'twitterReferredEnrollments' , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  66, 'Marketo.LBL_TWITTERREFERREDVISITS'      , 'twitterReferredVisits'      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Leads.DetailView.Marketo',  67, null;

	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  68, 'Marketo.LBL_TOTALREFERREDENROLLMENTS'   , 'totalReferredEnrollments'   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  69, 'Marketo.LBL_TOTALREFERREDVISITS'        , 'totalReferredVisits'        , '{0}', null;

--	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Leads.DetailView.Marketo',   8, 'Marketo.LBL_LEAD_INFO', 3;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',   9, 'Marketo.LBL_SALUTATION'                 , 'salutation'                 , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  10, 'Marketo.LBL_FIRSTNAME'                  , 'firstName'                  , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  11, 'Marketo.LBL_MIDDLENAME'                 , 'middleName'                 , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  12, 'Marketo.LBL_LASTNAME'                   , 'lastName'                   , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  13, 'Marketo.LBL_EMAIL'                      , 'email'                      , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  14, 'Marketo.LBL_TITLE'                      , 'title'                      , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  15, 'Marketo.LBL_DEPARTMENT'                 , 'department'                 , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  16, 'Marketo.LBL_MOBILEPHONE'                , 'mobilePhone'                , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  17, 'Marketo.LBL_FAX'                        , 'fax'                        , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  18, 'Marketo.LBL_PHONE'                      , 'phone'                      , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  19, 'Marketo.LBL_DATEOFBIRTH'                , 'dateOfBirth'                , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  20, 'Marketo.LBL_ADDRESS'                    , 'address'                    , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  21, 'Marketo.LBL_CITY'                       , 'city'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  22, 'Marketo.LBL_STATE'                      , 'state'                      , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  23, 'Marketo.LBL_COUNTRY'                    , 'country'                    , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  24, 'Marketo.LBL_POSTALCODE'                 , 'postalCode'                 , '{0}', null;

--	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'Leads.DetailView.Marketo',  25, 'Marketo.LBL_COMPANY_INFO', 3;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  26, 'Marketo.LBL_COMPANY'                    , 'company'                    , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  27, 'Marketo.LBL_SITE'                       , 'site'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  28, 'Marketo.LBL_BILLINGSTREET'              , 'billingStreet'              , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  29, 'Marketo.LBL_BILLINGCITY'                , 'billingCity'                , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  30, 'Marketo.LBL_BILLINGSTATE'               , 'billingState'               , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  31, 'Marketo.LBL_BILLINGCOUNTRY'             , 'billingCountry'             , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  32, 'Marketo.LBL_BILLINGPOSTALCODE'          , 'billingPostalCode'          , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  33, 'Marketo.LBL_MAINPHONE'                  , 'mainPhone'                  , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  34, 'Marketo.LBL_WEBSITE'                    , 'website'                    , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  35, 'Marketo.LBL_INDUSTRY'                   , 'industry'                   , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  36, 'Marketo.LBL_SICCODE'                    , 'sicCode'                    , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  37, 'Marketo.LBL_ANNUALREVENUE'              , 'annualRevenue'              , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo',  38, 'Marketo.LBL_NUMBEROFEMPLOYEES'          , 'numberOfEmployees'          , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Leads.DetailView.Marketo',  39, null;

--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo', 101, 'Marketo.LBL_LEADPARTITIONID'            , 'leadPartitionId'            , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo', 102, 'Marketo.LBL_LEADREVENUECYCLEMODELID'    , 'leadRevenueCycleModelId'    , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo', 103, 'Marketo.LBL_LEADREVENUESTAGEID'         , 'leadRevenueStageId'         , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo', 104, 'Marketo.LBL_SYNDICATIONID'              , 'syndicationId'              , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Marketo', 105, 'Marketo.LBL_ACQUISITIONPROGRAMID'       , 'acquisitionProgramId'       , '{0}', null;
end -- if;
GO


set nocount off;
GO


/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spDETAILVIEWS_FIELDS_Cloud()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_Cloud')
/

-- #endif IBM_DB2 */


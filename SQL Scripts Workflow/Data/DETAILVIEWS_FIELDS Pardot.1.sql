

print 'DETAILVIEWS_FIELDS Pardot';

set nocount on;
GO

-- 07/15/2017 Paul.  Add Pardot layout. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Prospects.DetailView.Pardot';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Prospects.DetailView.Pardot' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Prospects.DetailView.Pardot';
	exec dbo.spDETAILVIEWS_InsertOnly           'Prospects.DetailView.Pardot', 'Prospects', 'vwPROSPECTS_Pardot', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, '.LBL_ID'                                , 'id'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_EMAIL'                       , 'email'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, '.LBL_DATE_ENTERED'                      , 'created_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, '.LBL_DATE_MODIFIED'                     , 'updated_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_FIRST_NAME'                  , 'first_name'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_LAST_NAME'                   , 'last_name'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_PHONE'                       , 'phone'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_FAX'                         , 'fax'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_COMPANY'                     , 'company'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_JOB_TITLE'                   , 'job_title'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_DEPARTMENT'                  , 'department'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_WEBSITE'                     , 'website'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_IS_DO_NOT_EMAIL'             , 'is_do_not_email'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_IS_DO_NOT_CALL'              , 'is_do_not_call'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Prospects.DetailView.Pardot'    ,  -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_ADDRESS_ONE'                 , 'address_one'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_ADDRESS_TWO'                 , 'address_two'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_CITY'                        , 'city'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_STATE'                       , 'state'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_ZIP'                         , 'zip'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_COUNTRY'                     , 'country'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_NOTES'                       , 'notes'                       , '{0}', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Prospects.DetailView.Pardot'    ,  -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_SOURCE'                      , 'source'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_INDUSTRY'                    , 'industry'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_SCORE'                       , 'score'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_GRADE'                       , 'grade'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_CAMPAIGN_NAME'               , 'campaign_name'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_LAST_ACTIVITY_AT'            , 'last_activity_at'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_LAST_ACTIVITY_TYPE'          , 'last_activity_type'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_LAST_ACTIVITY_DETAILS'       , 'last_activity_details'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.DetailView.Pardot'    ,  -1, 'Pardot.LBL_RECENT_INTERACTION'          , 'recent_interaction'          , '{0}', 3;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.Pardot';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.Pardot' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Accounts.DetailView.Pardot';
	exec dbo.spDETAILVIEWS_InsertOnly           'Accounts.DetailView.Pardot', 'Accounts', 'vwACCOUNTS_Pardot', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, '.LBL_ID'                                , 'id'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Accounts.DetailView.Pardot'     ,  -1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, '.LBL_DATE_ENTERED'                      , 'created_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, '.LBL_DATE_MODIFIED'                     , 'updated_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_NAME'                        , 'name'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_NUMBER'                      , 'number'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_PHONE'                       , 'phone'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_FAX'                         , 'fax'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_RATING'                      , 'rating'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_SITE'                        , 'site'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_TYPE'                        , 'type'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_ANNUAL_REVENUE'              , 'annual_revenue'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_INDUSTRY'                    , 'industry'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_SIC'                         , 'sic'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_EMPLOYEES'                   , 'employees'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_OWNERSHIP'                   , 'ownership'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_TICKER_SYMBOL'               , 'ticker_symbol'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Accounts.DetailView.Pardot'     ,  -1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_DESCRIPTION'                 , 'description'                 , '{0}', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Accounts.DetailView.Pardot'     ,  -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_ADDRESS_ONE'         , 'billing_address_one'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_ADDRESS_ONE'        , 'shipping_address_one'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_ADDRESS_TWO'         , 'billing_address_two'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_ADDRESS_TWO'        , 'shipping_address_two'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_CITY'                , 'billing_city'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_CITY'               , 'shipping_city'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_STATE'               , 'billing_state'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_STATE'              , 'shipping_state'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_ZIP'                 , 'billing_zip'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_ZIP'                , 'shipping_zip'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_BILLING_COUNTRY'             , 'billing_country'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.Pardot'     ,  -1, 'Pardot.LBL_SHIPPING_COUNTRY'            , 'shipping_country'            , '{0}', null;
end -- if;
GO


-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Campaigns.DetailView.Pardot';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Campaigns.DetailView.Pardot' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Campaigns.DetailView.Pardot';
	exec dbo.spDETAILVIEWS_InsertOnly           'Campaigns.DetailView.Pardot', 'Campaigns', 'vwCAMPAIGNS_Pardot', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Campaigns.DetailView.Pardot'    ,  -1, '.LBL_ID'                                , 'id'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Campaigns.DetailView.Pardot'    ,  -1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Campaigns.DetailView.Pardot'    ,  -1, '.LBL_DATE_ENTERED'                      , 'created_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Campaigns.DetailView.Pardot'    ,  -1, '.LBL_DATE_MODIFIED'                     , 'updated_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Campaigns.DetailView.Pardot'    ,  -1, 'Pardot.LBL_NAME'                        , 'name'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Campaigns.DetailView.Pardot'    ,  -1, 'Pardot.LBL_COST'                        , 'cost'                        , '{0}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView.Pardot';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView.Pardot' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Opportunities.DetailView.Pardot';
	exec dbo.spDETAILVIEWS_InsertOnly           'Opportunities.DetailView.Pardot', 'Opportunities', 'vwOPPORTUNITIES_Pardot', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, '.LBL_ID'                                , 'id'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Opportunities.DetailView.Pardot',  -1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, '.LBL_DATE_ENTERED'                      , 'created_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, '.LBL_DATE_MODIFIED'                     , 'updated_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_NAME'                        , 'name'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_VALUE'                       , 'value'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_CAMPAIGN_NAME'               , 'campaign_name'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_PROBABILITY'                 , 'probability'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_TYPE'                        , 'type'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_STAGE'                       , 'stage'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_STATUS'                      , 'status'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_CLOSED_AT'                   , 'closed_at'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_IS_CLOSED'                   , 'is_closed'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_IS_WON'                      , 'is_won'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_EMAIL'                       , 'email'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Pardot',  -1, 'Pardot.LBL_EXTERNAL_ID'                 , 'crm_opportunity_fid'         , '{0}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Prospects.Pardot.Visitors';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Prospects.Pardot.Visitors' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Prospects.Pardot.Visitors';
	exec dbo.spDETAILVIEWS_InsertOnly           'Prospects.Pardot.Visitors', 'Prospects', 'vwPROSPECTS_VISITORS', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, '.LBL_ID'                                , 'id'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, '.LBL_DATE_ENTERED'                      , 'created_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, '.LBL_DATE_MODIFIED'                     , 'updated_at'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_IP_ADDRESS'                  , 'ip_address'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_PAGE_VIEW_COUNT'             , 'page_view_count'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_HOSTNAME'                    , 'hostname'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Prospects.Pardot.Visitors'      ,  -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_BROWSER'                     , 'browser'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_BROWSER_VERSION'             , 'browser_version'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_OPERATING_SYSTEM'            , 'operating_system'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_OPERATING_SYSTEM_VERSION'    , 'operating_system_version'    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_LANGUAGE'                    , 'language'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_SCREEN_HEIGHT'               , 'screen_height'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_SCREEN_WIDTH'                , 'screen_width'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_IS_FLASH_ENABLED'            , 'is_flash_enabled'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_IS_JAVA_ENABLED'             , 'is_java_enabled'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_CAMPAIGN_PARAMETER'          , 'campaign_parameter'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_MEDIUM_PARAMETER'            , 'medium_parameter'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_SOURCE_PARAMETER'            , 'source_parameter'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_CONTENT_PARAMETER'           , 'content_parameter'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_TERM_PARAMETER'              , 'term_parameter'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Prospects.Pardot.Visitors'      ,  -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_PROSPECT_ID'                 , 'prospect_id'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Prospects.Pardot.Visitors'      ,  -1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_FIRST_NAME'                  , 'prospect_first_name'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_LAST_NAME'                   , 'prospect_last_name'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_EMAIL'                       , 'prospect_email'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_COMPANY'                     , 'prospect_company'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Prospects.Pardot.Visitors'      ,  -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_COMPANY_NAME'                , 'company_name'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Prospects.Pardot.Visitors'      ,  -1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_COMPANY_STREET_ADDRESS'      , 'company_street_address'      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_COMPANY_CITY'                , 'company_city'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_COMPANY_STATE'               , 'company_state'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_COMPANY_POSTAL_CODE'         , 'company_postal_code'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_COMPANY_COUNTRY'             , 'company_country'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Prospects.Pardot.Visitors'      ,  -1, 'Pardot.LBL_COMPANY_EMAIL'               , 'company_email'               , '{0}', null;
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

call dbo.spDETAILVIEWS_FIELDS_Pardot()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_Pardot')
/

-- #endif IBM_DB2 */


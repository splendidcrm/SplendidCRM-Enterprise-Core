

print 'TERMINOLOGY Pardot en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'Pardot';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_PARDOT_TITLE'                       , N'en-US', N'Pardot', null, null, N'pardot &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_PARDOT'                             , N'en-US', N'Pardot', null, null, N'Configure pardot Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARDOT_SETTINGS'                           , N'en-US', N'Pardot', null, null, N'pardot Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_API_USER_KEY'                              , N'en-US', N'Pardot', null, null, N'API User Key:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_API_USERNAME'                              , N'en-US', N'Pardot', null, null, N'API Email:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_API_PASSWORD'                              , N'en-US', N'Pardot', null, null, N'API Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARDOT_ENABLED'                            , N'en-US', N'Pardot', null, null, N'Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VERBOSE_STATUS'                            , N'en-US', N'Pardot', null, null, N'Verbose Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DIRECTION'                                 , N'en-US', N'Pardot', null, null, N'Direction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONFLICT_RESOLUTION'                       , N'en-US', N'Pardot', null, null, N'Conflict Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_BACKGROUND'                           , N'en-US', N'Pardot', null, null, N'Sync will be performed in a background thread.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SYNC_MODULES'                              , N'en-US', N'Pardot', null, null, N'Sync Modules:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_SUCCESSFUL'                           , N'en-US', N'Pardot', null, null, N'Connection successful.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Pardot', null, null, N'pd';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARDOT'                                    , N'en-US', N'Import', null, null, N'pardot &reg;';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_PARDOT_TITLE'                       , N'en-US', N'Import', null, null, N'';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'Pardot', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APP_INSTRUCTIONS'                          , N'en-US', N'Pardot', null, null, N'<p>
The API User Key is available in Pardot under {your email address} > Settings > My Profile in the API User Key row.
</p>';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'bi-directional'                                , N'en-US', null, N'pardot_sync_direction'         ,   1, N'bi-directional';
exec dbo.spTERMINOLOGY_InsertOnly N'to crm only'                                   , N'en-US', null, N'pardot_sync_direction'         ,   2, N'to crm only';
exec dbo.spTERMINOLOGY_InsertOnly N'from crm only'                                 , N'en-US', null, N'pardot_sync_direction'         ,   3, N'from crm only';

exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                         , N'en-US', null, N'pardot_sync_module'            ,   1, N'CRM Leads to Pardot Prospects';
exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                      , N'en-US', null, N'pardot_sync_module'            ,   2, N'CRM Contacts to Pardot Prospects';
exec dbo.spTERMINOLOGY_InsertOnly N'Prospects'                                     , N'en-US', null, N'pardot_sync_module'            ,   3, N'CRM Targets to Pardot Prospects';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'Pardot'                                        , N'en-US', null, N'moduleList', 169, N'pardot';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ID'                                        , N'en-US', N'Pardot', null, null, N'Pardot ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALUTATION'                                , N'en-US', N'Pardot', null, null, N'Salutation:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRST_NAME'                                , N'en-US', N'Pardot', null, null, N'First Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_NAME'                                 , N'en-US', N'Pardot', null, null, N'Last Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL'                                     , N'en-US', N'Pardot', null, null, N'Email:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PASSWORD'                                  , N'en-US', N'Pardot', null, null, N'Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY'                                   , N'en-US', N'Pardot', null, null, N'Company:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROSPECT_ACCOUNT_ID'                       , N'en-US', N'Pardot', null, null, N'Account ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WEBSITE'                                   , N'en-US', N'Pardot', null, null, N'Website:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_JOB_TITLE'                                 , N'en-US', N'Pardot', null, null, N'Job Title:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DEPARTMENT'                                , N'en-US', N'Pardot', null, null, N'Department:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRY'                                   , N'en-US', N'Pardot', null, null, N'Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS_ONE'                               , N'en-US', N'Pardot', null, null, N'Address 1:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS_TWO'                               , N'en-US', N'Pardot', null, null, N'Address 2:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CITY'                                      , N'en-US', N'Pardot', null, null, N'City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATE'                                     , N'en-US', N'Pardot', null, null, N'State:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TERRITORY'                                 , N'en-US', N'Pardot', null, null, N'Territory:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ZIP'                                       , N'en-US', N'Pardot', null, null, N'Postal Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE'                                     , N'en-US', N'Pardot', null, null, N'Phone Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FAX'                                       , N'en-US', N'Pardot', null, null, N'Fax Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOURCE'                                    , N'en-US', N'Pardot', null, null, N'Source:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANNUAL_REVENUE'                            , N'en-US', N'Pardot', null, null, N'Annual Revenue:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMPLOYEES'                                 , N'en-US', N'Pardot', null, null, N'Number of Employees:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INDUSTRY'                                  , N'en-US', N'Pardot', null, null, N'Industry:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_YEARS_IN_BUSINESS'                         , N'en-US', N'Pardot', null, null, N'Years in business:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMMENTS'                                  , N'en-US', N'Pardot', null, null, N'Comments:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOTES'                                     , N'en-US', N'Pardot', null, null, N'Notes:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SCORE'                                     , N'en-US', N'Pardot', null, null, N'Score:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GRADE'                                     , N'en-US', N'Pardot', null, null, N'Letter Grade:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RECENT_INTERACTION'                        , N'en-US', N'Pardot', null, null, N'Most recent interaction:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_LEAD_FID'                              , N'en-US', N'Pardot', null, null, N'CRM Lead ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_CONTACT_FID'                           , N'en-US', N'Pardot', null, null, N'CRM Contact ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_OWNER_FID'                             , N'en-US', N'Pardot', null, null, N'CRM Owner ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_ACCOUNT_FID'                           , N'en-US', N'Pardot', null, null, N'CRM Account ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_LAST_SYNC'                             , N'en-US', N'Pardot', null, null, N'CRM Last Sync Time:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_URL'                                   , N'en-US', N'Pardot', null, null, N'CRM URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_DO_NOT_EMAIL'                           , N'en-US', N'Pardot', null, null, N'Do Not Email:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_DO_NOT_CALL'                            , N'en-US', N'Pardot', null, null, N'Do Not Call:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPTED_OUT'                                 , N'en-US', N'Pardot', null, null, N'Opted Out:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_REVIEWED'                               , N'en-US', N'Pardot', null, null, N'Reviewed:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_STARRED'                                , N'en-US', N'Pardot', null, null, N'Starred:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CAMPAIGN_ID'                               , N'en-US', N'Pardot', null, null, N'Campaign ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CAMPAIGN_NAME'                             , N'en-US', N'Pardot', null, null, N'Campaign Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_ACTIVITY_AT'                          , N'en-US', N'Pardot', null, null, N'Last Activity Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_ACTIVITY_TYPE'                        , N'en-US', N'Pardot', null, null, N'Last Activity Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_ACTIVITY_DETAILS'                     , N'en-US', N'Pardot', null, null, N'Last Activity Details:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VISITOR_ACTIVITIES'                        , N'en-US', N'Pardot', null, null, N'Visitor Activities' ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACTIVITY_TYPE'                             , N'en-US', N'Pardot', null, null, N'Activity Type:'     ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACTIVITY_DETAILS'                          , N'en-US', N'Pardot', null, null, N'Activity Details:'  ;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'Pardot', null, null, N'Name:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NUMBER'                                    , N'en-US', N'Pardot', null, null, N'Number:'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'Pardot', null, null, N'Description:'       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RATING'                                    , N'en-US', N'Pardot', null, null, N'Rating:'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SITE'                                      , N'en-US', N'Pardot', null, null, N'Site:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TYPE'                                      , N'en-US', N'Pardot', null, null, N'Type:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANNUAL_REVENUE'                            , N'en-US', N'Pardot', null, null, N'Annual Revenue:'    ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INDUSTRY'                                  , N'en-US', N'Pardot', null, null, N'Industry:'          ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SIC'                                       , N'en-US', N'Pardot', null, null, N'Sic:'               ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMPLOYEES'                                 , N'en-US', N'Pardot', null, null, N'Employees:'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNERSHIP'                                 , N'en-US', N'Pardot', null, null, N'Ownership:'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TICKER_SYMBOL'                             , N'en-US', N'Pardot', null, null, N'Ticker Symbol:'     ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_ADDRESS_ONE'                       , N'en-US', N'Pardot', null, null, N'Billing Address 1:' ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_ADDRESS_TWO'                       , N'en-US', N'Pardot', null, null, N'Billing Address 2:' ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_CITY'                              , N'en-US', N'Pardot', null, null, N'Billing City:'      ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_STATE'                             , N'en-US', N'Pardot', null, null, N'Billing State:'     ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_ZIP'                               , N'en-US', N'Pardot', null, null, N'Billing Zip:'       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_COUNTRY'                           , N'en-US', N'Pardot', null, null, N'Billing Country:'   ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_ADDRESS_ONE'                      , N'en-US', N'Pardot', null, null, N'Shipping Address 1:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_ADDRESS_TWO'                      , N'en-US', N'Pardot', null, null, N'Shipping Address 2:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_CITY'                             , N'en-US', N'Pardot', null, null, N'Shipping City:'     ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_STATE'                            , N'en-US', N'Pardot', null, null, N'Shipping State:'    ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_ZIP'                              , N'en-US', N'Pardot', null, null, N'Shipping Zip:'      ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_COUNTRY'                          , N'en-US', N'Pardot', null, null, N'Shipping Dountry:'  ;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COST'                                      , N'en-US', N'Pardot', null, null, N'Cost:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALUE'                                     , N'en-US', N'Pardot', null, null, N'Amount:'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROBABILITY'                               , N'en-US', N'Pardot', null, null, N'Probability %:'     ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STAGE'                                     , N'en-US', N'Pardot', null, null, N'Stage:'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TYPE'                                      , N'en-US', N'Pardot', null, null, N'Type:'              ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'Pardot', null, null, N'Status:'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CLOSED_AT'                                 , N'en-US', N'Pardot', null, null, N'Closed At:'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'Pardot', null, null, N'Status:'            ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXTERNAL_ID'                               , N'en-US', N'Pardot', null, null, N'External ID:'       ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_CLOSED'                                 , N'en-US', N'Pardot', null, null, N'Is Closed:'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_WON'                                    , N'en-US', N'Pardot', null, null, N'Is Won:'            ;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VISITORS'                                  , N'en-US', N'Pardot', null, null, N'Visitors'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROSPECT_NAME'                             , N'en-US', N'Pardot', null, null, N'Prospect'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HOSTNAME'                                  , N'en-US', N'Pardot', null, null, N'Hostname'           ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOURCE_PARAMETER'                          , N'en-US', N'Pardot', null, null, N'Source'             ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_VIEW_COUNT'                           , N'en-US', N'Pardot', null, null, N'Page Views'         ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRST_PAGE_VIEW'                           , N'en-US', N'Pardot', null, null, N'First Page View'    ;
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_PAGE_VIEW'                            , N'en-US', N'Pardot', null, null, N'Last Page View'     ;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IP_ADDRESS'                                , N'en-US', N'Pardot', null, null, N'IP Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HOSTNAME'                                  , N'en-US', N'Pardot', null, null, N'Hostname:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BROWSER'                                   , N'en-US', N'Pardot', null, null, N'Browser:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BROWSER_VERSION'                           , N'en-US', N'Pardot', null, null, N'Browser Version:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPERATING_SYSTEM'                          , N'en-US', N'Pardot', null, null, N'Operating System:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPERATING_SYSTEM_VERSION'                  , N'en-US', N'Pardot', null, null, N'Operating System Version:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LANGUAGE'                                  , N'en-US', N'Pardot', null, null, N'Language:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SCREEN_HEIGHT'                             , N'en-US', N'Pardot', null, null, N'Screen Height:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SCREEN_WIDTH'                              , N'en-US', N'Pardot', null, null, N'Screen Width:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_FLASH_ENABLED'                          , N'en-US', N'Pardot', null, null, N'Is Flash Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_JAVA_ENABLED'                           , N'en-US', N'Pardot', null, null, N'Is Java Enabled:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CAMPAIGN_PARAMETER'                        , N'en-US', N'Pardot', null, null, N'Campaign:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MEDIUM_PARAMETER'                          , N'en-US', N'Pardot', null, null, N'Medium:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOURCE_PARAMETER'                          , N'en-US', N'Pardot', null, null, N'Source:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTENT_PARAMETER'                         , N'en-US', N'Pardot', null, null, N'Content:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TERM_PARAMETER'                            , N'en-US', N'Pardot', null, null, N'Term:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROSPECT_ID'                               , N'en-US', N'Pardot', null, null, N'Prospect ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY_NAME'                              , N'en-US', N'Pardot', null, null, N'Company Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY_STREET_ADDRESS'                    , N'en-US', N'Pardot', null, null, N'Company Street:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY_CITY'                              , N'en-US', N'Pardot', null, null, N'Company City:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY_STATE'                             , N'en-US', N'Pardot', null, null, N'Company State:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY_POSTAL_CODE'                       , N'en-US', N'Pardot', null, null, N'Company Zipcode:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY_COUNTRY'                           , N'en-US', N'Pardot', null, null, N'Company Country:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY_EMAIL'                             , N'en-US', N'Pardot', null, null, N'Company Email:';

--exec dbo.spTERMINOLOGY_InsertOnly N''                                     , N'en-US', null, N'pardot_type_dom'            ,   0, N'';
--exec dbo.spTERMINOLOGY_InsertOnly N''                                     , N'en-US', null, N'pardot_stage_dom'           ,   0, N'';
--exec dbo.spTERMINOLOGY_InsertOnly N''                                     , N'en-US', null, N'pardot_status_dom'          ,   0, N'';
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

call dbo.spTERMINOLOGY_PARDOT_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_PARDOT_en_us')
/
-- #endif IBM_DB2 */

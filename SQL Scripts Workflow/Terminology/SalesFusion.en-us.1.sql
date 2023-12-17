

print 'TERMINOLOGY SalesFusion en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'SalesFusion';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALESFUSION_TITLE'                 , N'en-US', N'SalesFusion', null, null, N'SalesFusion';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALESFUSION_SETTINGS'              , N'en-US', N'SalesFusion', null, null, N'SalesFusion Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALESFUSION_SETTINGS_DESC'         , N'en-US', N'SalesFusion', null, null, N'Configure SalesFusion settings';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREATED_BY_ID'                     , N'en-US', N'SalesFusion', null, null, N'Created By Id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UPDATED_BY_ID'                     , N'en-US', N'SalesFusion', null, null, N'Updated By Id';

-- Accounts
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT_ID'                        , N'en-US', N'SalesFusion', null, null, N'Account id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT_NAME'                      , N'en-US', N'SalesFusion', null, null, N'Account name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER_ID'                          , N'en-US', N'SalesFusion', null, null, N'Owner id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER'                             , N'en-US', N'SalesFusion', null, null, N'Owner';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE'                             , N'en-US', N'SalesFusion', null, null, N'Phone';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_CITY'                      , N'en-US', N'SalesFusion', null, null, N'Billing city';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT'                           , N'en-US', N'SalesFusion', null, null, N'Account';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTACTS'                          , N'en-US', N'SalesFusion', null, null, N'Contacts';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOM_SCORE_FIELD'                , N'en-US', N'SalesFusion', null, null, N'Custom score field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_ID'                            , N'en-US', N'SalesFusion', null, null, N'Crm id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INDUSTRY'                          , N'en-US', N'SalesFusion', null, null, N'Industry';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TYPE'                              , N'en-US', N'SalesFusion', null, null, N'Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_COUNTRY'                  , N'en-US', N'SalesFusion', null, null, N'Shipping country';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_STREET'                    , N'en-US', N'SalesFusion', null, null, N'Billing street';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_STATE'                     , N'en-US', N'SalesFusion', null, null, N'Billing state';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_ZIP'                       , N'en-US', N'SalesFusion', null, null, N'Billing zip';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_KEY_ACCOUNT'                       , N'en-US', N'SalesFusion', null, null, N'Key account';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_COUNTRY'                   , N'en-US', N'SalesFusion', null, null, N'Billing country';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_ZIP'                      , N'en-US', N'SalesFusion', null, null, N'Shipping zip';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT_SCORE'                     , N'en-US', N'SalesFusion', null, null, N'Account score';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_STREET'                   , N'en-US', N'SalesFusion', null, null, N'Shipping street';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FAX'                               , N'en-US', N'SalesFusion', null, null, N'Fax';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SIC'                               , N'en-US', N'SalesFusion', null, null, N'Sic';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_CITY'                     , N'en-US', N'SalesFusion', null, null, N'Shipping city';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RATING'                            , N'en-US', N'SalesFusion', null, null, N'Rating';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                       , N'en-US', N'SalesFusion', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHIPPING_STATE'                    , N'en-US', N'SalesFusion', null, null, N'Shipping state';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_URL'                               , N'en-US', N'SalesFusion', null, null, N'Url';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CURRENCY_ISO_CODE'                 , N'en-US', N'SalesFusion', null, null, N'Currency iso code';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT_NUMBER'                    , N'en-US', N'SalesFusion', null, null, N'Account number';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALESFUSION_LAST_ACTIVITY'         , N'en-US', N'SalesFusion', null, null, N'Salesfusion last activity';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHORT_DESCRIPTION'                 , N'en-US', N'SalesFusion', null, null, N'Short description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CAMPAIGN_ID'                       , N'en-US', N'SalesFusion', null, null, N'Campaign id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOM_FIELDS'                     , N'en-US', N'SalesFusion', null, null, N'Custom fields';

-- Contacts
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTACT_ID'                        , N'en-US', N'SalesFusion', null, null, N'Contact id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTACT'                           , N'en-US', N'SalesFusion', null, null, N'Contact';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRST_NAME'                        , N'en-US', N'SalesFusion', null, null, N'First name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_NAME'                         , N'en-US', N'SalesFusion', null, null, N'Last name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE'                             , N'en-US', N'SalesFusion', null, null, N'Phone';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL'                             , N'en-US', N'SalesFusion', null, null, N'Email';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT_ID'                        , N'en-US', N'SalesFusion', null, null, N'Account id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT_NAME'                      , N'en-US', N'SalesFusion', null, null, N'Account name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT'                           , N'en-US', N'SalesFusion', null, null, N'Account';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER_ID'                          , N'en-US', N'SalesFusion', null, null, N'Owner id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER_NAME'                        , N'en-US', N'SalesFusion', null, null, N'Owner name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER'                             , N'en-US', N'SalesFusion', null, null, N'Owner';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_ID'                            , N'en-US', N'SalesFusion', null, null, N'Crm id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPT_OUT'                           , N'en-US', N'SalesFusion', null, null, N'Opt out';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPT_OUT_DATE'                      , N'en-US', N'SalesFusion', null, null, N'Opt out date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_TYPE'                          , N'en-US', N'SalesFusion', null, null, N'Crm type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                            , N'en-US', N'SalesFusion', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TITLE'                             , N'en-US', N'SalesFusion', null, null, N'Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOM_SCORE_FIELD'                , N'en-US', N'SalesFusion', null, null, N'Custom score field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DELIVERABILITY_STATUS'             , N'en-US', N'SalesFusion', null, null, N'Deliverability status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DELIVERABILITY_MESSAGE'            , N'en-US', N'SalesFusion', null, null, N'Deliverability message';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DELIVERED_DATE'                    , N'en-US', N'SalesFusion', null, null, N'Delivered date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INDUSTRY'                          , N'en-US', N'SalesFusion', null, null, N'Industry';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_ACTIVITY_DATE'                , N'en-US', N'SalesFusion', null, null, N'Last activity date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATE'                             , N'en-US', N'SalesFusion', null, null, N'State';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GENDER'                            , N'en-US', N'SalesFusion', null, null, N'Gender';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_STREET'                    , N'en-US', N'SalesFusion', null, null, N'Billing street';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALUTATION'                        , N'en-US', N'SalesFusion', null, null, N'Salutation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISTRICT'                          , N'en-US', N'SalesFusion', null, null, N'District';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_MODIFIED_BY_ID'               , N'en-US', N'SalesFusion', null, null, N'Last modified by id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DEPARTMENT'                        , N'en-US', N'SalesFusion', null, null, N'Department';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_PHONE'                       , N'en-US', N'SalesFusion', null, null, N'Other phone';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MOBILE'                            , N'en-US', N'SalesFusion', null, null, N'Mobile';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WEBSITE'                           , N'en-US', N'SalesFusion', null, null, N'Website';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DO_NOT_CALL'                       , N'en-US', N'SalesFusion', null, null, N'Do not call';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_STATE'                     , N'en-US', N'SalesFusion', null, null, N'Billing state';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRY'                           , N'en-US', N'SalesFusion', null, null, N'Country';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_ZIP'                       , N'en-US', N'SalesFusion', null, null, N'Billing zip';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_COUNTRY'                   , N'en-US', N'SalesFusion', null, null, N'Billing country';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STREET'                            , N'en-US', N'SalesFusion', null, null, N'Street';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HOME_PHONE'                        , N'en-US', N'SalesFusion', null, null, N'Home phone';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOURCE'                            , N'en-US', N'SalesFusion', null, null, N'Source';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY'                           , N'en-US', N'SalesFusion', null, null, N'Company';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_POSTAL_CODE'                       , N'en-US', N'SalesFusion', null, null, N'Postal code';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAILING_STREET'                    , N'en-US', N'SalesFusion', null, null, N'Mailing street';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CITY'                              , N'en-US', N'SalesFusion', null, null, N'City';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FAX'                               , N'en-US', N'SalesFusion', null, null, N'Fax';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEAD_SOURCE_ID'                    , N'en-US', N'SalesFusion', null, null, N'Lead source id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AREA'                              , N'en-US', N'SalesFusion', null, null, N'Area';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REGION'                            , N'en-US', N'SalesFusion', null, null, N'Region';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLING_CITY'                      , N'en-US', N'SalesFusion', null, null, N'Billing city';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RATING'                            , N'en-US', N'SalesFusion', null, null, N'Rating';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PURLID'                            , N'en-US', N'SalesFusion', null, null, N'Purlid';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BIRTH_DATE'                        , N'en-US', N'SalesFusion', null, null, N'Birth date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                       , N'en-US', N'SalesFusion', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CURRENCY_ISO_CODE'                 , N'en-US', N'SalesFusion', null, null, N'Currency iso code';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASSISTANT_NAME'                    , N'en-US', N'SalesFusion', null, null, N'Assistant name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAILING_ZIP'                       , N'en-US', N'SalesFusion', null, null, N'Mailing zip';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER_EMAIL'                       , N'en-US', N'SalesFusion', null, null, N'Owner email';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASSISTANT_PHONE'                   , N'en-US', N'SalesFusion', null, null, N'Assistant phone';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAILING_STATE'                     , N'en-US', N'SalesFusion', null, null, N'Mailing state';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAILING_COUNTRY'                   , N'en-US', N'SalesFusion', null, null, N'Mailing country';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAILING_CITY'                      , N'en-US', N'SalesFusion', null, null, N'Mailing city';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHORT_DESCRIPTION'                 , N'en-US', N'SalesFusion', null, null, N'Short description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_MODIFIED_DATE'                , N'en-US', N'SalesFusion', null, null, N'Last modified date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALARY'                            , N'en-US', N'SalesFusion', null, null, N'Salary';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOM_FIELDS'                     , N'en-US', N'SalesFusion', null, null, N'Custom fields';

-- Opportunities 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPPORTUNITY_ID'                    , N'en-US', N'SalesFusion', null, null, N'Opportunity id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPPORTUNITY'                       , N'en-US', N'SalesFusion', null, null, N'Opportunity';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER_ID'                          , N'en-US', N'SalesFusion', null, null, N'Owner id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER_NAME'                        , N'en-US', N'SalesFusion', null, null, N'Owner name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER'                             , N'en-US', N'SalesFusion', null, null, N'Owner';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT'                           , N'en-US', N'SalesFusion', null, null, N'Account';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CLOSING_DATE'                      , N'en-US', N'SalesFusion', null, null, N'Closing date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTACT'                           , N'en-US', N'SalesFusion', null, null, N'Contact';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                              , N'en-US', N'SalesFusion', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STAGE'                             , N'en-US', N'SalesFusion', null, null, N'Stage';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMOUNT'                            , N'en-US', N'SalesFusion', null, null, N'Amount';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROBABILITY'                       , N'en-US', N'SalesFusion', null, null, N'Probability';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WON'                               , N'en-US', N'SalesFusion', null, null, N'Won';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOM_MAPPING'                    , N'en-US', N'SalesFusion', null, null, N'Custom mapping';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONTACT_ID'                        , N'en-US', N'SalesFusion', null, null, N'Contact id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT_ID'                        , N'en-US', N'SalesFusion', null, null, N'Account id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_ID'                            , N'en-US', N'SalesFusion', null, null, N'Crm id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EST_CLOSING_DATE'                  , N'en-US', N'SalesFusion', null, null, N'Est closing date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUB_LEAD_SOURCE_ORIGINATOR'        , N'en-US', N'SalesFusion', null, null, N'Sub lead source originator';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEAD_SOURCE_ORIGINATOR'            , N'en-US', N'SalesFusion', null, null, N'Lead source originator';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUB_LEAD_SOURCE'                   , N'en-US', N'SalesFusion', null, null, N'Sub lead source';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                       , N'en-US', N'SalesFusion', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPP_TYPE'                          , N'en-US', N'SalesFusion', null, null, N'Opp type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEXT_STEP'                         , N'en-US', N'SalesFusion', null, null, N'Next step';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHARED_OPP'                        , N'en-US', N'SalesFusion', null, null, N'Shared opp';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRODUCT_NAME'                      , N'en-US', N'SalesFusion', null, null, N'Product name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACTION_STEPS_COMPLETE'             , N'en-US', N'SalesFusion', null, null, N'Action steps complete';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEAD_SOURCE'                       , N'en-US', N'SalesFusion', null, null, N'Lead source';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOM_FIELDS'                     , N'en-US', N'SalesFusion', null, null, N'Custom fields';

-- Distribution Lists
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST'                              , N'en-US', N'SalesFusion', null, null, N'List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ID'                           , N'en-US', N'SalesFusion', null, null, N'List id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_ID'                            , N'en-US', N'SalesFusion', null, null, N'Crm id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                         , N'en-US', N'SalesFusion', null, null, N'List name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TYPE'                         , N'en-US', N'SalesFusion', null, null, N'List type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER'                             , N'en-US', N'SalesFusion', null, null, N'Owner';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OWNER_ID'                          , N'en-US', N'SalesFusion', null, null, N'Owner id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                       , N'en-US', N'SalesFusion', null, null, N'Description';

-- Users
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER'                              , N'en-US', N'SalesFusion', null, null, N'User';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_ID'                           , N'en-US', N'SalesFusion', null, null, N'User id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_NAME'                         , N'en-US', N'SalesFusion', null, null, N'User name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIRST_NAME'                        , N'en-US', N'SalesFusion', null, null, N'First name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_NAME'                         , N'en-US', N'SalesFusion', null, null, N'Last name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EMAIL'                             , N'en-US', N'SalesFusion', null, null, N'Email';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                            , N'en-US', N'SalesFusion', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CRM_ID'                            , N'en-US', N'SalesFusion', null, null, N'Crm id';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ZIP'                               , N'en-US', N'SalesFusion', null, null, N'Zip';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATE'                             , N'en-US', N'SalesFusion', null, null, N'State';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SALUTATION'                        , N'en-US', N'SalesFusion', null, null, N'Salutation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MOBILE'                            , N'en-US', N'SalesFusion', null, null, N'Mobile';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COUNTRY'                           , N'en-US', N'SalesFusion', null, null, N'Country';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FACE_BOOK'                         , N'en-US', N'SalesFusion', null, null, N'Face book';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PORTAL_PASSWORD'                   , N'en-US', N'SalesFusion', null, null, N'Portal password';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINKED_IN'                         , N'en-US', N'SalesFusion', null, null, N'Linked in';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS1'                          , N'en-US', N'SalesFusion', null, null, N'Address1';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE'                             , N'en-US', N'SalesFusion', null, null, N'Phone';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADDRESS2'                          , N'en-US', N'SalesFusion', null, null, N'Address2';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CITY'                              , N'en-US', N'SalesFusion', null, null, N'City';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPANY_WEBSITE'                   , N'en-US', N'SalesFusion', null, null, N'Company website';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROFILE_PICTURE'                   , N'en-US', N'SalesFusion', null, null, N'Profile picture';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TWITTER'                           , N'en-US', N'SalesFusion', null, null, N'Twitter';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PHONE_EXTENSION'                   , N'en-US', N'SalesFusion', null, null, N'Phone extension';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_JOB_TITLE'                         , N'en-US', N'SalesFusion', null, null, N'Job title';


exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'               , N'en-US', N'SalesFusion', null, null, N'SFu';
GO

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc
exec dbo.spTERMINOLOGY_InsertOnly N'SalesFusion'                           , N'en-US', null, N'moduleList', 167, N'SalesFusion';
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

call dbo.spTERMINOLOGY_SALESFUSION_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_SALESFUSION_en_us')
/
-- #endif IBM_DB2 */

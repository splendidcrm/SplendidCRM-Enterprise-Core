

print 'DETAILVIEWS_FIELDS SalesFusion';

set nocount on;
GO


-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.SalesFusion';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.SalesFusion' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Accounts.DetailView.SalesFusion';
	exec dbo.spDETAILVIEWS_InsertOnly           'Accounts.DetailView.SalesFusion', 'Accounts', 'vwACCOUNTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    0, 'SalesFusion.LBL_ACCOUNT_ID'                   , 'account_id'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    1, 'SalesFusion.LBL_RATING'                       , 'rating'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    2, 'SalesFusion.LBL_OWNER_ID'                     , 'owner_id'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    3, 'SalesFusion.LBL_PHONE'                        , 'phone'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    4, 'SalesFusion.LBL_ACCOUNT_NAME'                 , 'account_name'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    5, 'SalesFusion.LBL_FAX'                          , 'fax'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    6, 'SalesFusion.LBL_URL'                          , 'url'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    7, 'SalesFusion.LBL_TYPE'                         , 'type'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    8, 'SalesFusion.LBL_INDUSTRY'                     , 'industry'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',    9, 'SalesFusion.LBL_CAMPAIGN_ID'                  , 'campaign_id'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   10, 'SalesFusion.LBL_DESCRIPTION'                  , 'description'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   11, 'SalesFusion.LBL_SIC'                          , 'sic'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Accounts.DetailView.SalesFusion',   12;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   13, 'SalesFusion.LBL_BILLING_STREET'               , 'billing_street'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   14, 'SalesFusion.LBL_SHIPPING_STREET'              , 'shipping_street'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   15, 'SalesFusion.LBL_BILLING_CITY'                 , 'billing_city'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   16, 'SalesFusion.LBL_SHIPPING_CITY'                , 'shipping_city'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   17, 'SalesFusion.LBL_BILLING_STATE'                , 'billing_state'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   18, 'SalesFusion.LBL_SHIPPING_STATE'               , 'shipping_state'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   19, 'SalesFusion.LBL_BILLING_ZIP'                  , 'billing_zip'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   20, 'SalesFusion.LBL_SHIPPING_ZIP'                 , 'shipping_zip'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   21, 'SalesFusion.LBL_BILLING_COUNTRY'              , 'billing_country'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   22, 'SalesFusion.LBL_SHIPPING_COUNTRY'             , 'shipping_country'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Accounts.DetailView.SalesFusion',   23;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   24, 'SalesFusion.LBL_UPDATED_BY_ID'                , 'updated_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   25, 'SalesFusion.LBL_CREATED_BY_ID'                , 'created_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   26, '.LBL_DATE_MODIFIED'                           , 'updated_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   27, '.LBL_DATE_ENTERED'                            , 'created_date'                 , '{0}', null;

--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   14, 'SalesFusion.LBL_CUSTOM_SCORE_FIELD'           , 'custom_score_field'           , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   15, 'SalesFusion.LBL_CRM_ID'                       , 'crm_id'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   22, 'SalesFusion.LBL_KEY_ACCOUNT'                  , 'key_account'                  , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   25, 'SalesFusion.LBL_ACCOUNT_SCORE'                , 'account_score'                , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   34, 'SalesFusion.LBL_CURRENCY_ISO_CODE'            , 'currency_iso_code'            , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   35, 'SalesFusion.LBL_ACCOUNT_NUMBER'               , 'account_number'               , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   36, 'SalesFusion.LBL_SALESFUSION_LAST_ACTIVITY'    , 'salesfusion_last_activity'    , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   37, 'SalesFusion.LBL_SHORT_DESCRIPTION'            , 'short_description'            , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Accounts.DetailView.SalesFusion',   39, 'SalesFusion.LBL_CUSTOM_FIELDS'                , 'custom_fields'                , '{0}', null;
end -- if;
GO


-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.SalesFusion';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.SalesFusion' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.SalesFusion';
	exec dbo.spDETAILVIEWS_InsertOnly           'Contacts.DetailView.SalesFusion', 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    0, 'SalesFusion.LBL_OWNER_NAME'                   , 'owner_name'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    1, 'SalesFusion.LBL_ACCOUNT_NAME'                 , 'account_name'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    2, 'SalesFusion.LBL_SALUTATION'                   , 'salutation'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    3, 'SalesFusion.LBL_STATUS'                       , 'status'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    4, 'SalesFusion.LBL_FIRST_NAME'                   , 'first_name'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    5, 'SalesFusion.LBL_CRM_TYPE'                     , 'crm_type'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    6, 'SalesFusion.LBL_LAST_NAME'                    , 'last_name'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    7, 'SalesFusion.LBL_LEAD_SOURCE_ID'               , 'lead_source_id'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    8, 'SalesFusion.LBL_TITLE'                        , 'title'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',    9, 'SalesFusion.LBL_GENDER'                       , 'gender'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   10, 'SalesFusion.LBL_COMPANY'                      , 'company'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   11, 'SalesFusion.LBL_PHONE'                        , 'phone'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   12, 'SalesFusion.LBL_DEPARTMENT'                   , 'department'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   13, 'SalesFusion.LBL_HOME_PHONE'                   , 'home_phone'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   14, 'SalesFusion.LBL_CONTACT_ID'                   , 'contact_id'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   15, 'SalesFusion.LBL_MOBILE'                       , 'mobile'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   16, 'SalesFusion.LBL_SOURCE'                       , 'source'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   17, 'SalesFusion.LBL_OTHER_PHONE'                  , 'other_phone'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   18, 'SalesFusion.LBL_BIRTH_DATE'                   , 'birth_date'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   19, 'SalesFusion.LBL_FAX'                          , 'fax'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   20, 'SalesFusion.LBL_PURLID'                       , 'purlid'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   21, 'SalesFusion.LBL_EMAIL'                        , 'email'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   22, 'SalesFusion.LBL_DESCRIPTION'                  , 'description'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   23, 'SalesFusion.LBL_WEBSITE'                      , 'website'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Contacts.DetailView.SalesFusion',   24;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   25, 'SalesFusion.LBL_BILLING_STREET'               , 'billing_street'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   26, 'SalesFusion.LBL_MAILING_STREET'               , 'mailing_street'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   27, 'SalesFusion.LBL_BILLING_CITY'                 , 'billing_city'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   28, 'SalesFusion.LBL_MAILING_CITY'                 , 'mailing_city'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   29, 'SalesFusion.LBL_BILLING_STATE'                , 'billing_state'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   30, 'SalesFusion.LBL_MAILING_STATE'                , 'mailing_state'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   31, 'SalesFusion.LBL_BILLING_ZIP'                  , 'billing_zip'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   32, 'SalesFusion.LBL_MAILING_ZIP'                  , 'mailing_zip'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   33, 'SalesFusion.LBL_BILLING_COUNTRY'              , 'billing_country'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   34, 'SalesFusion.LBL_MAILING_COUNTRY'              , 'mailing_country'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Contacts.DetailView.SalesFusion',   35;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   36, 'SalesFusion.LBL_UPDATED_BY_ID'                , 'updated_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   37, 'SalesFusion.LBL_CREATED_BY_ID'                , 'created_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   38, '.LBL_DATE_MODIFIED'                           , 'updated_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   39, '.LBL_DATE_ENTERED'                            , 'created_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   40, 'SalesFusion.LBL_LAST_ACTIVITY_DATE'           , 'last_activity_date'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   41, 'SalesFusion.LBL_OPT_OUT'                      , 'opt_out'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   42, 'SalesFusion.LBL_LAST_MODIFIED_DATE'           , 'last_modified_date'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   43, 'SalesFusion.LBL_OPT_OUT_DATE'                 , 'opt_out_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   44, 'SalesFusion.LBL_DELIVERABILITY_STATUS'        , 'deliverability_status'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   45, 'SalesFusion.LBL_DO_NOT_CALL'                  , 'do_not_call'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   46, 'SalesFusion.LBL_DELIVERABILITY_MESSAGE'       , 'deliverability_message'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   47, 'SalesFusion.LBL_CUSTOM_SCORE_FIELD'           , 'custom_score_field'           , '{0}', null;

--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   27, 'SalesFusion.LBL_DELIVERED_DATE'               , 'delivered_date'               , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   28, 'SalesFusion.LBL_INDUSTRY'                     , 'industry'                     , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   57, 'SalesFusion.LBL_RATING'                       , 'rating'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   71, 'SalesFusion.LBL_SALARY'                       , 'salary'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   35, 'SalesFusion.LBL_LAST_MODIFIED_BY_ID'          , 'last_modified_by_id'          , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   61, 'SalesFusion.LBL_CURRENCY_ISO_CODE'            , 'currency_iso_code'            , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   62, 'SalesFusion.LBL_ASSISTANT_NAME'               , 'assistant_name'               , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   65, 'SalesFusion.LBL_ASSISTANT_PHONE'              , 'assistant_phone'              , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   64, 'SalesFusion.LBL_OWNER_EMAIL'                  , 'owner_email'                  , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   69, 'SalesFusion.LBL_SHORT_DESCRIPTION'            , 'short_description'            , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   72, 'SalesFusion.LBL_CUSTOM_FIELDS'                , 'custom_fields'                , '{0}', null;

--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   45, 'SalesFusion.LBL_STREET'                       , 'street'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   51, 'SalesFusion.LBL_CITY'                         , 'city'                         , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   30, 'SalesFusion.LBL_STATE'                        , 'state'                        , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   49, 'SalesFusion.LBL_POSTAL_CODE'                  , 'postal_code'                  , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   42, 'SalesFusion.LBL_COUNTRY'                      , 'country'                      , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   54, 'SalesFusion.LBL_AREA'                         , 'area'                         , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   55, 'SalesFusion.LBL_REGION'                       , 'region'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   34, 'SalesFusion.LBL_DISTRICT'                     , 'district'                     , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.SalesFusion',   18, 'SalesFusion.LBL_CRM_ID'                       , 'crm_id'                       , '{0}', null;
end -- if;
GO


-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.SalesFusion';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.SalesFusion' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Leads.DetailView.SalesFusion';
	exec dbo.spDETAILVIEWS_InsertOnly           'Leads.DetailView.SalesFusion', 'Leads', 'vwLEADS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       0, 'SalesFusion.LBL_OWNER_NAME'                   , 'owner_name'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       1, 'SalesFusion.LBL_ACCOUNT_NAME'                 , 'account_name'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       2, 'SalesFusion.LBL_SALUTATION'                   , 'salutation'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       3, 'SalesFusion.LBL_STATUS'                       , 'status'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       4, 'SalesFusion.LBL_FIRST_NAME'                   , 'first_name'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       5, 'SalesFusion.LBL_CRM_TYPE'                     , 'crm_type'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       6, 'SalesFusion.LBL_LAST_NAME'                    , 'last_name'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       7, 'SalesFusion.LBL_LEAD_SOURCE_ID'               , 'lead_source_id'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       8, 'SalesFusion.LBL_TITLE'                        , 'title'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',       9, 'SalesFusion.LBL_GENDER'                       , 'gender'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      10, 'SalesFusion.LBL_COMPANY'                      , 'company'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      11, 'SalesFusion.LBL_PHONE'                        , 'phone'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      12, 'SalesFusion.LBL_DEPARTMENT'                   , 'department'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      13, 'SalesFusion.LBL_HOME_PHONE'                   , 'home_phone'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      14, 'SalesFusion.LBL_CONTACT_ID'                   , 'contact_id'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      15, 'SalesFusion.LBL_MOBILE'                       , 'mobile'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      16, 'SalesFusion.LBL_SOURCE'                       , 'source'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      17, 'SalesFusion.LBL_OTHER_PHONE'                  , 'other_phone'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      18, 'SalesFusion.LBL_BIRTH_DATE'                   , 'birth_date'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      19, 'SalesFusion.LBL_FAX'                          , 'fax'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      20, 'SalesFusion.LBL_PURLID'                       , 'purlid'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      21, 'SalesFusion.LBL_EMAIL'                        , 'email'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      22, 'SalesFusion.LBL_DESCRIPTION'                  , 'description'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      23, 'SalesFusion.LBL_WEBSITE'                      , 'website'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Leads.DetailView.SalesFusion',      24;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      25, 'SalesFusion.LBL_BILLING_STREET'               , 'billing_street'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      26, 'SalesFusion.LBL_MAILING_STREET'               , 'mailing_street'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      27, 'SalesFusion.LBL_BILLING_CITY'                 , 'billing_city'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      28, 'SalesFusion.LBL_MAILING_CITY'                 , 'mailing_city'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      29, 'SalesFusion.LBL_BILLING_STATE'                , 'billing_state'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      30, 'SalesFusion.LBL_MAILING_STATE'                , 'mailing_state'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      31, 'SalesFusion.LBL_BILLING_ZIP'                  , 'billing_zip'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      32, 'SalesFusion.LBL_MAILING_ZIP'                  , 'mailing_zip'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      33, 'SalesFusion.LBL_BILLING_COUNTRY'              , 'billing_country'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      34, 'SalesFusion.LBL_MAILING_COUNTRY'              , 'mailing_country'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Leads.DetailView.SalesFusion',      35;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      36, 'SalesFusion.LBL_UPDATED_BY_ID'                , 'updated_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      37, 'SalesFusion.LBL_CREATED_BY_ID'                , 'created_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      38, '.LBL_DATE_MODIFIED'                           , 'updated_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      39, '.LBL_DATE_ENTERED'                            , 'created_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      40, 'SalesFusion.LBL_LAST_ACTIVITY_DATE'           , 'last_activity_date'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      41, 'SalesFusion.LBL_OPT_OUT'                      , 'opt_out'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      42, 'SalesFusion.LBL_LAST_MODIFIED_DATE'           , 'last_modified_date'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      43, 'SalesFusion.LBL_OPT_OUT_DATE'                 , 'opt_out_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      44, 'SalesFusion.LBL_DELIVERABILITY_STATUS'        , 'deliverability_status'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      45, 'SalesFusion.LBL_DO_NOT_CALL'                  , 'do_not_call'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      46, 'SalesFusion.LBL_DELIVERABILITY_MESSAGE'       , 'deliverability_message'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      47, 'SalesFusion.LBL_CUSTOM_SCORE_FIELD'           , 'custom_score_field'           , '{0}', null;

--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      27, 'SalesFusion.LBL_DELIVERED_DATE'               , 'delivered_date'               , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      28, 'SalesFusion.LBL_INDUSTRY'                     , 'industry'                     , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      57, 'SalesFusion.LBL_RATING'                       , 'rating'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      71, 'SalesFusion.LBL_SALARY'                       , 'salary'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      35, 'SalesFusion.LBL_LAST_MODIFIED_BY_ID'          , 'last_modified_by_id'          , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      61, 'SalesFusion.LBL_CURRENCY_ISO_CODE'            , 'currency_iso_code'            , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      62, 'SalesFusion.LBL_ASSISTANT_NAME'               , 'assistant_name'               , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      65, 'SalesFusion.LBL_ASSISTANT_PHONE'              , 'assistant_phone'              , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      64, 'SalesFusion.LBL_OWNER_EMAIL'                  , 'owner_email'                  , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      69, 'SalesFusion.LBL_SHORT_DESCRIPTION'            , 'short_description'            , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      72, 'SalesFusion.LBL_CUSTOM_FIELDS'                , 'custom_fields'                , '{0}', null;

--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      45, 'SalesFusion.LBL_STREET'                       , 'street'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      51, 'SalesFusion.LBL_CITY'                         , 'city'                         , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      30, 'SalesFusion.LBL_STATE'                        , 'state'                        , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      49, 'SalesFusion.LBL_POSTAL_CODE'                  , 'postal_code'                  , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      42, 'SalesFusion.LBL_COUNTRY'                      , 'country'                      , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      54, 'SalesFusion.LBL_AREA'                         , 'area'                         , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      55, 'SalesFusion.LBL_REGION'                       , 'region'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      34, 'SalesFusion.LBL_DISTRICT'                     , 'district'                     , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.SalesFusion',      18, 'SalesFusion.LBL_CRM_ID'                       , 'crm_id'                       , '{0}', null;
end -- if;
GO


-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView.SalesFusion';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView.SalesFusion' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Opportunities.DetailView.SalesFusion';
	exec dbo.spDETAILVIEWS_InsertOnly           'Opportunities.DetailView.SalesFusion', 'Opportunities', 'vwOPPORTUNITIES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',    0, 'SalesFusion.LBL_OWNER_NAME'                   , 'owner_name'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',    1, 'SalesFusion.LBL_CLOSING_DATE'                 , 'closing_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Opportunities.DetailView.SalesFusion',    2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',    3, 'SalesFusion.LBL_AMOUNT'                       , 'amount'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',    4, 'SalesFusion.LBL_ACCOUNT_ID'                   , 'account_id'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Opportunities.DetailView.SalesFusion',    5, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',    6, 'SalesFusion.LBL_STAGE'                        , 'stage'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',    7, 'SalesFusion.LBL_CONTACT_ID'                   , 'contact_id'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',    8, 'SalesFusion.LBL_PROBABILITY'                  , 'probability'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',    9, 'SalesFusion.LBL_NAME'                         , 'name'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   10, 'SalesFusion.LBL_NEXT_STEP'                    , 'next_step'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   11, 'SalesFusion.LBL_PRODUCT_NAME'                 , 'product_name'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   12, 'SalesFusion.LBL_ACTION_STEPS_COMPLETE'        , 'action_steps_complete'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   13, 'SalesFusion.LBL_LEAD_SOURCE'                  , 'lead_source'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   14, 'SalesFusion.LBL_OPP_TYPE'                     , 'opp_type'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Opportunities.DetailView.SalesFusion',   15, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   16, 'SalesFusion.LBL_DESCRIPTION'                  , 'description'                  , '{0}', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Opportunities.DetailView.SalesFusion',   17;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   18, 'SalesFusion.LBL_UPDATED_BY_ID'                , 'updated_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   19, 'SalesFusion.LBL_CREATED_BY_ID'                , 'created_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   20, '.LBL_DATE_MODIFIED'                           , 'updated_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   21, '.LBL_DATE_ENTERED'                            , 'created_date'                 , '{0}', null;

--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   18, 'SalesFusion.LBL_WON'                          , 'won'                          , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   19, 'SalesFusion.LBL_CUSTOM_MAPPING'               , 'custom_mapping'               , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   22, 'SalesFusion.LBL_CRM_ID'                       , 'crm_id'                       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   23, 'SalesFusion.LBL_EST_CLOSING_DATE'             , 'est_closing_date'             , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   24, 'SalesFusion.LBL_SUB_LEAD_SOURCE_ORIGINATOR'   , 'sub_lead_source_originator'   , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   25, 'SalesFusion.LBL_LEAD_SOURCE_ORIGINATOR'       , 'lead_source_originator'       , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   26, 'SalesFusion.LBL_SUB_LEAD_SOURCE'              , 'sub_lead_source'              , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   30, 'SalesFusion.LBL_SHARED_OPP'                   , 'shared_opp'                   , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.SalesFusion',   34, 'SalesFusion.LBL_CUSTOM_FIELDS'                , 'custom_fields'                , '{0}', null;
end -- if;
GO


-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProspectLists.DetailView.SalesFusion';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProspectLists.DetailView.SalesFusion' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ProspectLists.DetailView.SalesFusion';
	exec dbo.spDETAILVIEWS_InsertOnly           'ProspectLists.DetailView.SalesFusion', 'ProspectLists', 'vwPROSPECT_LISTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    0, 'SalesFusion.LBL_LIST'                         , 'list'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    1, 'SalesFusion.LBL_LIST_ID'                      , 'list_id'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    2, 'SalesFusion.LBL_CRM_ID'                       , 'crm_id'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    3, 'SalesFusion.LBL_LIST_NAME'                    , 'list_name'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    4, 'SalesFusion.LBL_LIST_TYPE'                    , 'list_type'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    5, 'SalesFusion.LBL_OWNER'                        , 'owner'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    6, 'SalesFusion.LBL_OWNER_ID'                     , 'owner_id'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    7, 'SalesFusion.LBL_CREATED_DATE'                 , 'created_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    8, 'SalesFusion.LBL_CREATED_BY'                   , 'created_by'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',    9, 'SalesFusion.LBL_CREATED_BY_ID'                , 'created_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',   10, 'SalesFusion.LBL_UPDATED_DATE'                 , 'updated_date'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',   11, 'SalesFusion.LBL_UPDATED_BY'                   , 'updated_by'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',   12, 'SalesFusion.LBL_UPDATED_BY_ID'                , 'updated_by_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.SalesFusion',   13, 'SalesFusion.LBL_DESCRIPTION'                  , 'description'                  , '{0}', null;
end -- if;
GO


-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Users.DetailView.SalesFusion';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Users.DetailView.SalesFusion' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Users.DetailView.SalesFusion';
	exec dbo.spDETAILVIEWS_InsertOnly           'Users.DetailView.SalesFusion', 'Users', 'vwUSERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    0, 'SalesFusion.LBL_USER_ID'                      , 'user_id'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    1, 'SalesFusion.LBL_USER_NAME'                    , 'user_name'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    2, 'SalesFusion.LBL_FIRST_NAME'                   , 'first_name'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    3, 'SalesFusion.LBL_SALUTATION'                   , 'salutation'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    4, 'SalesFusion.LBL_LAST_NAME'                    , 'last_name'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    5, 'SalesFusion.LBL_MOBILE'                       , 'mobile'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    6, 'SalesFusion.LBL_EMAIL'                        , 'email'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    7, 'SalesFusion.LBL_PHONE'                        , 'phone'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    8, 'SalesFusion.LBL_JOB_TITLE'                    , 'job_title'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',    9, 'SalesFusion.LBL_PHONE_EXTENSION'              , 'phone_extension'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   10, 'SalesFusion.LBL_COMPANY_WEBSITE'              , 'company_website'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   11, 'SalesFusion.LBL_STATUS'                       , 'status'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   12, 'SalesFusion.LBL_CRM_ID'                       , 'crm_id'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'Users.DetailView.SalesFusion',   13;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   14, 'SalesFusion.LBL_ADDRESS1'                     , 'address1'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   15, 'SalesFusion.LBL_ADDRESS2'                     , 'address2'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   16, 'SalesFusion.LBL_CITY'                         , 'city'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   17, 'SalesFusion.LBL_STATE'                        , 'state'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   18, 'SalesFusion.LBL_ZIP'                          , 'zip'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   19, 'SalesFusion.LBL_COUNTRY'                      , 'country'                      , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   13, 'SalesFusion.LBL_FACE_BOOK'                    , 'face_book'                    , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   15, 'SalesFusion.LBL_LINKED_IN'                    , 'linked_in'                    , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   22, 'SalesFusion.LBL_TWITTER'                      , 'twitter'                      , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   14, 'SalesFusion.LBL_PORTAL_PASSWORD'              , 'portal_password'              , '{0}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Users.DetailView.SalesFusion',   21, 'SalesFusion.LBL_PROFILE_PICTURE'              , 'profile_picture'              , '{0}', null;
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

call dbo.spDETAILVIEWS_FIELDS_SalesFusion()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_SalesFusion')
/

-- #endif IBM_DB2 */




print 'DETAILVIEWS_FIELDS DetailView.OfficeAddin';
-- delete from DETAILVIEWS where NAME like '%.DetailView.OfficeAddin';
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME like '%.DetailView.OfficeAddin';
--GO

set nocount on;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Accounts.DetailView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Accounts.DetailView.OfficeAddin', 'Accounts', 'vwACCOUNTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin',  0, 'Accounts.LBL_ACCOUNT_NAME'       , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin',  1, 'Accounts.LBL_PHONE'              , 'PHONE_OFFICE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.OfficeAddin',  2, 'Accounts.LBL_WEBSITE'            , 'WEBSITE'                          , '{0}'        , 'WEBSITE'             , '{0}'                        , '_blank', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin',  3, 'Accounts.LBL_FAX'                , 'PHONE_FAX'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin',  4, 'Accounts.LBL_TICKER_SYMBOL'      , 'TICKER_SYMBOL'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin',  5, 'Accounts.LBL_OTHER_PHONE'        , 'PHONE_ALTERNATE'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.OfficeAddin',  6, 'Accounts.LBL_MEMBER_OF'          , 'PARENT_NAME'                      , '{0}'        , 'PARENT_ID'           , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.OfficeAddin',  7, 'Accounts.LBL_EMAIL'              , 'EMAIL1'                           , '{0}'        , 'EMAIL1'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin',  8, 'Accounts.LBL_EMPLOYEES'          , 'EMPLOYEES'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.OfficeAddin',  9, 'Accounts.LBL_OTHER_EMAIL_ADDRESS', 'EMAIL2'                           , '{0}'        , 'EMAIL2'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 10, 'Accounts.LBL_OWNERSHIP'          , 'OWNERSHIP'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 11, 'Accounts.LBL_RATING'             , 'RATING'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Accounts.DetailView.OfficeAddin', 12, 'Accounts.LBL_INDUSTRY'           , 'INDUSTRY'                         , '{0}'        , 'industry_dom'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 13, 'Accounts.LBL_SIC_CODE'           , 'SIC_CODE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Accounts.DetailView.OfficeAddin', 14, 'Accounts.LBL_TYPE'               , 'ACCOUNT_TYPE'                     , '{0}'        , 'account_type_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 15, 'Accounts.LBL_ANNUAL_REVENUE'     , 'ANNUAL_REVENUE'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 16, 'Teams.LBL_TEAM'                  , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 17, '.LBL_DATE_MODIFIED'              , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 18, '.LBL_ASSIGNED_TO'                , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 19, '.LBL_DATE_ENTERED'               , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 20, 'Accounts.LBL_BILLING_ADDRESS'    , 'BILLING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.OfficeAddin', 21, 'Accounts.LBL_SHIPPING_ADDRESS'   , 'SHIPPING_ADDRESS_HTML'            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Accounts.DetailView.OfficeAddin', 22, 'TextBox', 'Accounts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Bugs.DetailView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Bugs.DetailView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Bugs.DetailView.OfficeAddin'   , 'Bugs', 'vwBUGS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.OfficeAddin'   ,  0, 'Bugs.LBL_BUG_NUMBER'              , 'BUG_NUMBER'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.OfficeAddin'   ,  1, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.OfficeAddin'   ,  2, 'Bugs.LBL_PRIORITY'                , 'PRIORITY'                         , '{0}'        , 'bug_priority_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.OfficeAddin'   ,  3, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.OfficeAddin'   ,  4, 'Bugs.LBL_STATUS'                  , 'STATUS'                           , '{0}'        , 'bug_status_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.OfficeAddin'   ,  5, '.LBL_LAST_ACTIVITY_DATE'          , 'LAST_ACTIVITY_DATE'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.OfficeAddin'   ,  6, 'Bugs.LBL_TYPE'                    , 'TYPE'                             , '{0}'        , 'bug_type_dom'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.OfficeAddin'   ,  7, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.OfficeAddin'   ,  8, 'Bugs.LBL_SOURCE'                  , 'SOURCE'                           , '{0}'        , 'source_dom'          , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.OfficeAddin'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.OfficeAddin'   , 10, 'Bugs.LBL_PRODUCT_CATEGORY'        , 'PRODUCT_CATEGORY'                 , '{0}'        , 'product_category_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.OfficeAddin'   , 11, 'Bugs.LBL_RESOLUTION'              , 'RESOLUTION'                       , '{0}'        , 'bug_resolution_dom'  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.OfficeAddin'   , 12, 'Bugs.LBL_FOUND_IN_RELEASE'        , 'FOUND_IN_RELEASE'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.OfficeAddin'   , 13, 'Bugs.LBL_FIXED_IN_RELEASE'        , 'FIXED_IN_RELEASE'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Bugs.DetailView.OfficeAddin'   , 14, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Bugs.DetailView.OfficeAddin'   , 15, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.OfficeAddin'   , 16, 'Bugs.LBL_SUBJECT'                 , 'NAME'                             , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Bugs.DetailView.OfficeAddin'   , 17, 'TextBox', 'Bugs.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Bugs.DetailView.OfficeAddin'   , 18, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Bugs.DetailView.OfficeAddin'   , 19, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Bugs.DetailView.OfficeAddin'   , 20, 'TextBox', 'Bugs.LBL_WORK_LOG', 'WORK_LOG', null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Cases.DetailView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Cases.DetailView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Cases.DetailView.OfficeAddin'  , 'Cases', 'vwCASES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.OfficeAddin'  ,  0, 'Cases.LBL_CASE_NUMBER'            , 'CASE_NUMBER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.OfficeAddin'  ,  1, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Cases.DetailView.OfficeAddin'  ,  2, 'Cases.LBL_PRIORITY'               , 'PRIORITY'                         , '{0}'        , 'case_priority_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.OfficeAddin'  ,  3, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Cases.DetailView.OfficeAddin'  ,  4, 'Cases.LBL_STATUS'                 , 'STATUS'                           , '{0}'        , 'case_status_dom'  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Cases.DetailView.OfficeAddin'  ,  5, 'Cases.LBL_ACCOUNT_NAME'           , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'       , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Cases.DetailView.OfficeAddin'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.OfficeAddin'  ,  7, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.OfficeAddin'  ,  8, '.LBL_LAST_ACTIVITY_DATE'          , 'LAST_ACTIVITY_DATE'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.OfficeAddin'  ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.OfficeAddin'  , 10, 'Cases.LBL_SUBJECT'                , 'NAME'                             , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Cases.DetailView.OfficeAddin'  , 11, 'TextBox', 'Cases.LBL_DESCRIPTION' , 'DESCRIPTION', null, null, null, null, null, 3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Cases.DetailView.OfficeAddin'  , 12, 'TextBox', 'Cases.LBL_RESOLUTION'  , 'RESOLUTION' , null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contacts.DetailView.OfficeAddin', 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin',  0, 'Contacts.LBL_NAME'               , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin',  1, 'Contacts.LBL_OFFICE_PHONE'       , 'PHONE_WORK'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin',  2, '.LBL_LAST_ACTIVITY_DATE'         , 'LAST_ACTIVITY_DATE'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin',  3, 'Contacts.LBL_MOBILE_PHONE'       , 'PHONE_MOBILE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.OfficeAddin',  4, 'Contacts.LBL_ACCOUNT_NAME'       , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'       , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin',  5, 'Contacts.LBL_HOME_PHONE'         , 'PHONE_HOME'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Contacts.DetailView.OfficeAddin',  6, 'Contacts.LBL_LEAD_SOURCE'        , 'LEAD_SOURCE'                      , '{0}'        , 'lead_source_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin',  7, 'Contacts.LBL_OTHER_PHONE'        , 'PHONE_OTHER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin',  8, 'Contacts.LBL_TITLE'              , 'TITLE'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin',  9, 'Contacts.LBL_FAX_PHONE'          , 'PHONE_FAX'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 10, 'Contacts.LBL_DEPARTMENT'         , 'DEPARTMENT'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.OfficeAddin', 11, 'Contacts.LBL_EMAIL_ADDRESS'      , 'EMAIL1'                           , '{0}'        , 'EMAIL1'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 12, 'Contacts.LBL_BIRTHDATE'          , 'BIRTHDATE'                        , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.OfficeAddin', 13, 'Contacts.LBL_OTHER_EMAIL_ADDRESS', 'EMAIL2'                           , '{0}'        , 'EMAIL2'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.OfficeAddin', 14, 'Contacts.LBL_REPORTS_TO'         , 'REPORTS_TO_NAME'                  , '{0}'        , 'REPORTS_TO_ID'       , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 15, 'Contacts.LBL_ASSISTANT'          , 'ASSISTANT'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Contacts.DetailView.OfficeAddin', 16, 'Contacts.LBL_SYNC_CONTACT'       , 'SYNC_CONTACT'                     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 17, 'Contacts.LBL_ASSISTANT_PHONE'    , 'ASSISTANT_PHONE'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Contacts.DetailView.OfficeAddin', 18, 'Contacts.LBL_DO_NOT_CALL'        , 'DO_NOT_CALL'                      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Contacts.DetailView.OfficeAddin', 19, 'Contacts.LBL_EMAIL_OPT_OUT'      , 'EMAIL_OPT_OUT'                    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 20, 'Teams.LBL_TEAM'                  , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 21, '.LBL_DATE_MODIFIED'              , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 22, '.LBL_ASSIGNED_TO'                , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 23, '.LBL_DATE_ENTERED'               , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 24, 'Contacts.LBL_PRIMARY_ADDRESS'    , 'PRIMARY_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.OfficeAddin', 25, 'Contacts.LBL_ALTERNATE_ADDRESS'  , 'ALT_ADDRESS_HTML'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contacts.DetailView.OfficeAddin', 26, 'TextBox', 'Contacts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Leads.DetailView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Leads.DetailView.OfficeAddin'   , 'Leads', 'vwLEADS_Edit', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Leads.DetailView.OfficeAddin'   ,  0, 'Leads.LBL_LEAD_SOURCE'            , 'LEAD_SOURCE'                      , '{0}'        , 'lead_source_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Leads.DetailView.OfficeAddin'   ,  1, 'Leads.LBL_STATUS'                 , 'STATUS'                           , '{0}'        , 'lead_status_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   ,  2, 'Leads.LBL_LEAD_SOURCE_DESCRIPTION', 'LEAD_SOURCE_DESCRIPTION'          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   ,  3, 'Leads.LBL_STATUS_DESCRIPTION'     , 'STATUS_DESCRIPTION'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   ,  4, 'Leads.LBL_REFERED_BY'             , 'REFERED_BY'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Leads.DetailView.OfficeAddin'   ,  5, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Leads.DetailView.OfficeAddin'   ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   ,  7, 'Leads.LBL_OFFICE_PHONE'           , 'PHONE_WORK'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   ,  8, 'Leads.LBL_NAME'                   , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   ,  9, 'Leads.LBL_MOBILE_PHONE'           , 'PHONE_MOBILE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 10, '.LBL_LAST_ACTIVITY_DATE'          , 'LAST_ACTIVITY_DATE'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 11, 'Leads.LBL_HOME_PHONE'             , 'PHONE_HOME'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Leads.DetailView.OfficeAddin'   , 12, 'Leads.LBL_ACCOUNT_NAME'           , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 13, 'Leads.LBL_OTHER_PHONE'            , 'PHONE_OTHER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Leads.DetailView.OfficeAddin'   , 14, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 15, 'Leads.LBL_FAX_PHONE'              , 'PHONE_FAX'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 16, 'Leads.LBL_TITLE'                  , 'TITLE'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Leads.DetailView.OfficeAddin'   , 17, 'Leads.LBL_EMAIL_ADDRESS'          , 'EMAIL1'                           , '{0}'        , 'EMAIL1', 'mailto:{0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 18, 'Leads.LBL_DEPARTMENT'             , 'DEPARTMENT'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Leads.DetailView.OfficeAddin'   , 19, 'Leads.LBL_OTHER_EMAIL_ADDRESS'    , 'EMAIL2'                           , '{0}'        , 'EMAIL2', 'mailto:{0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Leads.DetailView.OfficeAddin'   , 20, 'Leads.LBL_DO_NOT_CALL'            , 'DO_NOT_CALL'                      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Leads.DetailView.OfficeAddin'   , 21, 'Leads.LBL_EMAIL_OPT_OUT'          , 'EMAIL_OPT_OUT'                    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 22, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 23, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 24, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 25, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 26, 'Leads.LBL_PRIMARY_ADDRESS'        , 'PRIMARY_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.OfficeAddin'   , 27, 'Leads.LBL_ALTERNATE_ADDRESS'      , 'ALT_ADDRESS_HTML'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Leads.DetailView.OfficeAddin'   , 28, 'TextBox', 'Leads.LBL_DESCRIPTION' , 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Opportunities.DetailView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Opportunities.DetailView.OfficeAddin', 'Opportunities', 'vwOPPORTUNITIES_Edit', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin',  0, 'Opportunities.LBL_OPPORTUNITY_NAME', 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin',  1, 'Opportunities.LBL_AMOUNT'          , 'AMOUNT'                           , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Opportunities.DetailView.OfficeAddin',  2, 'Opportunities.LBL_ACCOUNT_NAME'    , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'          , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Opportunities.DetailView.OfficeAddin',  3, 'Opportunities.LBL_LEAD_NAME'       , 'LEAD_NAME'                        , '{0}'        , 'LEAD_ID'             , '~/Leads/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin',  4, 'Opportunities.LBL_DATE_CLOSED'     , 'DATE_CLOSED'                      , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Opportunities.DetailView.OfficeAddin',  5, 'Opportunities.LBL_TYPE'            , 'OPPORTUNITY_TYPE'                 , '{0}'        , 'opportunity_type_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin',  6, 'Opportunities.LBL_NEXT_STEP'       , 'NEXT_STEP'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Opportunities.DetailView.OfficeAddin',  7, 'Opportunities.LBL_LEAD_SOURCE'     , 'LEAD_SOURCE'                      , '{0}'        , 'lead_source_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Opportunities.DetailView.OfficeAddin',  8, 'Opportunities.LBL_SALES_STAGE'     , 'SALES_STAGE'                      , '{0}'        , 'sales_stage_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin',  9, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin', 10, 'Opportunities.LBL_PROBABILITY'     , 'PROBABILITY'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin', 11, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin', 12, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin', 13, '.LBL_LAST_ACTIVITY_DATE'           , 'LAST_ACTIVITY_DATE'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Opportunities.DetailView.OfficeAddin', 14, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Opportunities.DetailView.OfficeAddin', 15, 'TextBox', 'Opportunities.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.OfficeAddin'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.DetailView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.DetailView.OfficeAddin'   , 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   ,  0, 'Quotes.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   ,  2, 'Quotes.LBL_QUOTE_NUM'             , 'QUOTE_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView.OfficeAddin'   ,  3, 'Quotes.LBL_QUOTE_STAGE'           , 'QUOTE_STAGE'                       , '{0}'        , 'quote_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   ,  4, 'Quotes.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'      , 'DATE_QUOTE_EXPECTED_CLOSED'        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView.OfficeAddin'   ,  6, 'Quotes.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   ,  7, 'Quotes.LBL_ORIGINAL_PO_DATE'      , 'ORIGINAL_PO_DATE'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   , 10, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   , 11, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.OfficeAddin'   , 12, 'Quotes.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.OfficeAddin'   , 13, 'Quotes.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.OfficeAddin'   , 14, 'Quotes.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.OfficeAddin'   , 15, 'Quotes.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   , 16, 'Quotes.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.OfficeAddin'   , 17, 'Quotes.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Quotes.DetailView.OfficeAddin'   , 18, 'TextBox', 'Quotes.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.OfficeAddin'
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.SummaryView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.SummaryView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.SummaryView.OfficeAddin'  , 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.OfficeAddin'  ,  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.OfficeAddin'  ,  1, 'Quotes.LBL_SUBTOTAL'              , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.OfficeAddin'  ,  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.OfficeAddin'  ,  3, 'Quotes.LBL_DISCOUNT'              , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.OfficeAddin'  ,  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.OfficeAddin'  ,  5, 'Quotes.LBL_SHIPPING'              , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.OfficeAddin'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.OfficeAddin'  ,  7, 'Quotes.LBL_TAX'                   , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Quotes.SummaryView.OfficeAddin'  ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.SummaryView.OfficeAddin'  ,  9, 'Quotes.LBL_TOTAL'                 , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.DetailView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.DetailView.OfficeAddin'   , 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   ,  0, 'Orders.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   ,  1, 'Orders.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   ,  2, 'Orders.LBL_ORDER_NUM'             , 'ORDER_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView.OfficeAddin'   ,  3, 'Orders.LBL_ORDER_STAGE'           , 'ORDER_STAGE'                       , '{0}'        , 'order_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   ,  4, 'Orders.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   ,  5, 'Orders.LBL_DATE_ORDER_DUE'        , 'DATE_ORDER_DUE'                    , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView.OfficeAddin'   ,  6, 'Orders.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'    , 'DATE_ORDER_SHIPPED'                , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   , 10, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   , 11, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.OfficeAddin'   , 12, 'Orders.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.OfficeAddin'   , 13, 'Orders.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.OfficeAddin'   , 14, 'Orders.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.OfficeAddin'   , 15, 'Orders.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   , 16, 'Orders.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.OfficeAddin'   , 17, 'Orders.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Orders.DetailView.OfficeAddin'   , 18, 'TextBox', 'Orders.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.SummaryView.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.SummaryView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.SummaryView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.SummaryView.OfficeAddin'  , 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.OfficeAddin'  ,  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.OfficeAddin'  ,  1, 'Orders.LBL_SUBTOTAL'              , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.OfficeAddin'  ,  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.OfficeAddin'  ,  3, 'Orders.LBL_DISCOUNT'              , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.OfficeAddin'  ,  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.OfficeAddin'  ,  5, 'Orders.LBL_SHIPPING'              , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.OfficeAddin'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.OfficeAddin'  ,  7, 'Orders.LBL_TAX'                   , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Orders.SummaryView.OfficeAddin'  ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.SummaryView.OfficeAddin'  ,  9, 'Orders.LBL_TOTAL'                 , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.DetailView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.DetailView.OfficeAddin' , 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' ,  0, 'Invoices.LBL_NAME'                 , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.OfficeAddin' ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'     , 'OPPORTUNITY_NAME'                  , '{0}'        , 'OPPORTUNITY_ID' , '~/Opportunities/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' ,  2, 'Invoices.LBL_INVOICE_NUM'          , 'INVOICE_NUM'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView.OfficeAddin' ,  3, 'Invoices.LBL_INVOICE_STAGE'        , 'INVOICE_STAGE'                     , '{0}'        , 'invoice_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.OfficeAddin' ,  4, 'Invoices.LBL_QUOTE_NAME'           , 'QUOTE_NAME'                        , '{0}'        , 'QUOTE_ID'       , '~/Quotes/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView.OfficeAddin' ,  5, 'Invoices.LBL_PAYMENT_TERMS'        , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.OfficeAddin' ,  6, 'Invoices.LBL_ORDER_NAME'           , 'ORDER_NAME'                        , '{0}'        , 'ORDER_ID'       , '~/Orders/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' ,  7, 'Invoices.LBL_DUE_DATE'             , 'DUE_DATE'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' ,  7, 'Invoices.LBL_SHIP_DATE'            , 'SHIP_DATE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' ,  9, 'Invoices.LBL_PURCHASE_ORDER_NUM'   , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' , 10, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' , 11, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' , 12, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' , 13, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.OfficeAddin' , 14, 'Invoices.LBL_BILLING_CONTACT_NAME' , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.OfficeAddin' , 15, 'Invoices.LBL_SHIPPING_CONTACT_NAME', 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.OfficeAddin' , 16, 'Invoices.LBL_BILLING_ACCOUNT_NAME' , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.OfficeAddin' , 17, 'Invoices.LBL_SHIPPING_ACCOUNT_NAME', 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' , 18, 'Invoices.LBL_BILLING_ADDRESS'      , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.OfficeAddin' , 19, 'Invoices.LBL_SHIPPING_ADDRESS'     , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Invoices.DetailView.OfficeAddin' , 20, 'TextBox', 'Invoices.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView.OfficeAddin';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.SummaryView.OfficeAddin' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.SummaryView.OfficeAddin';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.SummaryView.OfficeAddin', 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.OfficeAddin',  0, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.OfficeAddin',  1, 'Invoices.LBL_SUBTOTAL'            , 'SUBTOTAL_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.OfficeAddin',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.OfficeAddin',  3, 'Invoices.LBL_DISCOUNT'            , 'DISCOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.OfficeAddin',  4, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.OfficeAddin',  5, 'Invoices.LBL_SHIPPING'            , 'SHIPPING_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.OfficeAddin',  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.OfficeAddin',  7, 'Invoices.LBL_TAX'                 , 'TAX_USDOLLAR'                       , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.SummaryView.OfficeAddin',  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.SummaryView.OfficeAddin',  9, 'Invoices.LBL_TOTAL'               , 'TOTAL_USDOLLAR'                     , '{0:c}'      , null;
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

call dbo.spDETAILVIEWS_FIELDS_DetailViewOfficeAddin()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_DetailViewOfficeAddin')
/

-- #endif IBM_DB2 */


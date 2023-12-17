

print 'DETAILVIEWS_FIELDS Gmail';
--delete from DETAILVIEWS_FIELDS where DETAIL_NAME like '%.Gmail'
--GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Emails.ArchiveView.Gmail';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Emails.ArchiveView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Emails.ArchiveView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Emails.ArchiveView.Gmail', 'Emails', 'vwEMAILS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Emails.ArchiveView.Gmail',  0, 'Emails.LBL_FROM'                 , 'FROM_ADDR'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Emails.ArchiveView.Gmail',  1, 'Emails.LBL_TO'                   , 'TO_ADDRS'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Emails.ArchiveView.Gmail',  2, 'Emails.LBL_DATE_SENT'            , 'DATE_START'                       , '{0}', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Emails.ArchiveView.Gmail',  3, 'Emails.LBL_CC'                   , 'CC_ADDRS'                         , '{0}', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Emails.ArchiveView.Gmail',  4, 'Emails.LBL_SUBJECT'              , 'NAME'                             , '{0}', 3;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Accounts.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Accounts.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Accounts.DetailView.Gmail', 'Accounts', 'vwACCOUNTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail',  0, 'Accounts.LBL_ACCOUNT_NAME'       , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail',  1, 'Accounts.LBL_PHONE'              , 'PHONE_OFFICE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.Gmail',  2, 'Accounts.LBL_WEBSITE'            , 'WEBSITE'                          , '{0}'        , 'WEBSITE'             , '{0}'                        , '_blank', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail',  3, 'Accounts.LBL_FAX'                , 'PHONE_FAX'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail',  4, 'Accounts.LBL_TICKER_SYMBOL'      , 'TICKER_SYMBOL'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail',  5, 'Accounts.LBL_OTHER_PHONE'        , 'PHONE_ALTERNATE'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.Gmail',  6, 'Accounts.LBL_MEMBER_OF'          , 'PARENT_NAME'                      , '{0}'        , 'PARENT_ID'           , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.Gmail',  7, 'Accounts.LBL_EMAIL'              , 'EMAIL1'                           , '{0}'        , 'EMAIL1'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail',  8, 'Accounts.LBL_EMPLOYEES'          , 'EMPLOYEES'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Accounts.DetailView.Gmail',  9, 'Accounts.LBL_OTHER_EMAIL_ADDRESS', 'EMAIL2'                           , '{0}'        , 'EMAIL2'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 10, 'Accounts.LBL_OWNERSHIP'          , 'OWNERSHIP'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 11, 'Accounts.LBL_RATING'             , 'RATING'                           , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Accounts.DetailView.Gmail', 12, 'Accounts.LBL_INDUSTRY'           , 'INDUSTRY'                         , '{0}'        , 'industry_dom'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 13, 'Accounts.LBL_SIC_CODE'           , 'SIC_CODE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Accounts.DetailView.Gmail', 14, 'Accounts.LBL_TYPE'               , 'ACCOUNT_TYPE'                     , '{0}'        , 'account_type_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 15, 'Accounts.LBL_ANNUAL_REVENUE'     , 'ANNUAL_REVENUE'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 16, 'Teams.LBL_TEAM'                  , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 17, '.LBL_DATE_MODIFIED'              , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 18, '.LBL_ASSIGNED_TO'                , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 19, '.LBL_DATE_ENTERED'               , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 20, 'Accounts.LBL_BILLING_ADDRESS'    , 'BILLING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Accounts.DetailView.Gmail', 21, 'Accounts.LBL_SHIPPING_ADDRESS'   , 'SHIPPING_ADDRESS_HTML'            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Accounts.DetailView.Gmail', 22, 'TextBox', 'Accounts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Bugs.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Bugs.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Bugs.DetailView.Gmail', 'Bugs', 'vwBUGS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Gmail'   ,  0, 'Bugs.LBL_BUG_NUMBER'              , 'BUG_NUMBER'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Gmail'   ,  1, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Gmail'   ,  2, 'Bugs.LBL_PRIORITY'                , 'PRIORITY'                         , '{0}'        , 'bug_priority_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Gmail'   ,  3, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Gmail'   ,  4, 'Bugs.LBL_STATUS'                  , 'STATUS'                           , '{0}'        , 'bug_status_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Bugs.DetailView.Gmail'   ,  5, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Gmail'   ,  6, 'Bugs.LBL_TYPE'                    , 'TYPE'                             , '{0}'        , 'bug_type_dom'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Gmail'   ,  7, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Gmail'   ,  8, 'Bugs.LBL_SOURCE'                  , 'SOURCE'                           , '{0}'        , 'source_dom'          , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Gmail'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Gmail'   , 10, 'Bugs.LBL_PRODUCT_CATEGORY'        , 'PRODUCT_CATEGORY'                 , '{0}'        , 'product_category_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Gmail'   , 11, 'Bugs.LBL_RESOLUTION'              , 'RESOLUTION'                       , '{0}'        , 'bug_resolution_dom'  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Gmail'   , 12, 'Bugs.LBL_FOUND_IN_RELEASE'        , 'FOUND_IN_RELEASE'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Gmail'   , 13, 'Bugs.LBL_FIXED_IN_RELEASE'        , 'FIXED_IN_RELEASE'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Bugs.DetailView.Gmail'   , 14, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Bugs.DetailView.Gmail'   , 15, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Gmail'   , 16, 'Bugs.LBL_SUBJECT'                 , 'NAME'                             , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Bugs.DetailView.Gmail'   , 17, 'TextBox', 'Bugs.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Bugs.DetailView.Gmail'   , 18, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Bugs.DetailView.Gmail'   , 19, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Bugs.DetailView.Gmail'   , 20, 'TextBox', 'Bugs.LBL_WORK_LOG', 'WORK_LOG', null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Cases.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Cases.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Cases.DetailView.Gmail', 'Cases', 'vwCASES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Gmail'  ,  0, 'Cases.LBL_CASE_NUMBER'            , 'CASE_NUMBER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Gmail'  ,  1, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Cases.DetailView.Gmail'  ,  2, 'Cases.LBL_PRIORITY'               , 'PRIORITY'                         , '{0}'        , 'case_priority_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Gmail'  ,  3, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Cases.DetailView.Gmail'  ,  4, 'Cases.LBL_STATUS'                 , 'STATUS'                           , '{0}'        , 'case_status_dom'  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Cases.DetailView.Gmail'  ,  5, 'Cases.LBL_ACCOUNT_NAME'           , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'       , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Cases.DetailView.Gmail'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Gmail'  ,  7, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Cases.DetailView.Gmail'  ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Gmail'  ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Gmail'  , 10, 'Cases.LBL_SUBJECT'                , 'NAME'                             , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Cases.DetailView.Gmail'  , 11, 'TextBox', 'Cases.LBL_DESCRIPTION' , 'DESCRIPTION', null, null, null, null, null, 3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Cases.DetailView.Gmail'  , 12, 'TextBox', 'Cases.LBL_RESOLUTION'  , 'RESOLUTION' , null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contacts.DetailView.Gmail', 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail',  0, 'Contacts.LBL_NAME'               , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail',  1, 'Contacts.LBL_OFFICE_PHONE'       , 'PHONE_WORK'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Contacts.DetailView.Gmail',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail',  3, 'Contacts.LBL_MOBILE_PHONE'       , 'PHONE_MOBILE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.Gmail',  4, 'Contacts.LBL_ACCOUNT_NAME'       , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'       , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail',  5, 'Contacts.LBL_HOME_PHONE'         , 'PHONE_HOME'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Contacts.DetailView.Gmail',  6, 'Contacts.LBL_LEAD_SOURCE'        , 'LEAD_SOURCE'                      , '{0}'        , 'lead_source_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail',  7, 'Contacts.LBL_OTHER_PHONE'        , 'PHONE_OTHER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail',  8, 'Contacts.LBL_TITLE'              , 'TITLE'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail',  9, 'Contacts.LBL_FAX_PHONE'          , 'PHONE_FAX'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 10, 'Contacts.LBL_DEPARTMENT'         , 'DEPARTMENT'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.Gmail', 11, 'Contacts.LBL_EMAIL_ADDRESS'      , 'EMAIL1'                           , '{0}'        , 'EMAIL1'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 12, 'Contacts.LBL_BIRTHDATE'          , 'BIRTHDATE'                        , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.Gmail', 13, 'Contacts.LBL_OTHER_EMAIL_ADDRESS', 'EMAIL2'                           , '{0}'        , 'EMAIL2'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.Gmail', 14, 'Contacts.LBL_REPORTS_TO'         , 'REPORTS_TO_NAME'                  , '{0}'        , 'REPORTS_TO_ID'       , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 15, 'Contacts.LBL_ASSISTANT'          , 'ASSISTANT'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Contacts.DetailView.Gmail', 16, 'Contacts.LBL_SYNC_CONTACT'       , 'SYNC_CONTACT'                     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 17, 'Contacts.LBL_ASSISTANT_PHONE'    , 'ASSISTANT_PHONE'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Contacts.DetailView.Gmail', 18, 'Contacts.LBL_DO_NOT_CALL'        , 'DO_NOT_CALL'                      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Contacts.DetailView.Gmail', 19, 'Contacts.LBL_EMAIL_OPT_OUT'      , 'EMAIL_OPT_OUT'                    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 20, 'Teams.LBL_TEAM'                  , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 21, '.LBL_DATE_MODIFIED'              , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 22, '.LBL_ASSIGNED_TO'                , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 23, '.LBL_DATE_ENTERED'               , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 24, 'Contacts.LBL_PRIMARY_ADDRESS'    , 'PRIMARY_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Gmail', 25, 'Contacts.LBL_ALTERNATE_ADDRESS'  , 'ALT_ADDRESS_HTML'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contacts.DetailView.Gmail', 26, 'TextBox', 'Contacts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Leads.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Leads.DetailView.Gmail', 'Leads', 'vwLEADS_Edit', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Leads.DetailView.Gmail'   ,  0, 'Leads.LBL_LEAD_SOURCE'            , 'LEAD_SOURCE'                      , '{0}'        , 'lead_source_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Leads.DetailView.Gmail'   ,  1, 'Leads.LBL_STATUS'                 , 'STATUS'                           , '{0}'        , 'lead_status_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   ,  2, 'Leads.LBL_LEAD_SOURCE_DESCRIPTION', 'LEAD_SOURCE_DESCRIPTION'          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   ,  3, 'Leads.LBL_STATUS_DESCRIPTION'     , 'STATUS_DESCRIPTION'               , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   ,  4, 'Leads.LBL_REFERED_BY'             , 'REFERED_BY'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Leads.DetailView.Gmail'   ,  5, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Leads.DetailView.Gmail'   ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   ,  7, 'Leads.LBL_OFFICE_PHONE'           , 'PHONE_WORK'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   ,  8, 'Leads.LBL_NAME'                   , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   ,  9, 'Leads.LBL_MOBILE_PHONE'           , 'PHONE_MOBILE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Leads.DetailView.Gmail'   , 10, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 11, 'Leads.LBL_HOME_PHONE'             , 'PHONE_HOME'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Leads.DetailView.Gmail'   , 12, 'Leads.LBL_ACCOUNT_NAME'           , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 13, 'Leads.LBL_OTHER_PHONE'            , 'PHONE_OTHER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Leads.DetailView.Gmail'   , 14, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 15, 'Leads.LBL_FAX_PHONE'              , 'PHONE_FAX'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 16, 'Leads.LBL_TITLE'                  , 'TITLE'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Leads.DetailView.Gmail'   , 17, 'Leads.LBL_EMAIL_ADDRESS'          , 'EMAIL1'                           , '{0}'        , 'EMAIL1', 'mailto:{0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 18, 'Leads.LBL_DEPARTMENT'             , 'DEPARTMENT'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Leads.DetailView.Gmail'   , 19, 'Leads.LBL_OTHER_EMAIL_ADDRESS'    , 'EMAIL2'                           , '{0}'        , 'EMAIL2', 'mailto:{0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Leads.DetailView.Gmail'   , 20, 'Leads.LBL_DO_NOT_CALL'            , 'DO_NOT_CALL'                      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Leads.DetailView.Gmail'   , 21, 'Leads.LBL_EMAIL_OPT_OUT'          , 'EMAIL_OPT_OUT'                    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 22, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 23, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 24, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 25, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 26, 'Leads.LBL_PRIMARY_ADDRESS'        , 'PRIMARY_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Leads.DetailView.Gmail'   , 27, 'Leads.LBL_ALTERNATE_ADDRESS'      , 'ALT_ADDRESS_HTML'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Leads.DetailView.Gmail'   , 28, 'TextBox', 'Leads.LBL_DESCRIPTION' , 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Opportunities.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly           'Opportunities.DetailView.Gmail' , 'Opportunities' , 'vwOPPORTUNITIES_Edit' , '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Gmail',  0, 'Opportunities.LBL_OPPORTUNITY_NAME', 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Gmail',  1, 'Opportunities.LBL_AMOUNT'          , 'AMOUNT_USDOLLAR'                  , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Opportunities.DetailView.Gmail',  2, 'Opportunities.LBL_ACCOUNT_NAME'    , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'          , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Gmail',  3, 'Opportunities.LBL_DATE_CLOSED'     , 'DATE_CLOSED'                      , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Opportunities.DetailView.Gmail',  4, 'Opportunities.LBL_TYPE'            , 'OPPORTUNITY_TYPE'                 , '{0}'        , 'opportunity_type_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Gmail',  5, 'Opportunities.LBL_NEXT_STEP'       , 'NEXT_STEP'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Opportunities.DetailView.Gmail',  6, 'Opportunities.LBL_LEAD_SOURCE'     , 'LEAD_SOURCE'                      , '{0}'        , 'lead_source_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Opportunities.DetailView.Gmail',  7, 'Opportunities.LBL_SALES_STAGE'     , 'SALES_STAGE'                      , '{0}'        , 'sales_stage_dom'     , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Gmail',  8, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Gmail',  9, 'Opportunities.LBL_PROBABILITY'     , 'PROBABILITY'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Gmail', 10, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Gmail', 11, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Opportunities.DetailView.Gmail', 12, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  'Opportunities.DetailView.Gmail', 13, 'Opportunities.LBL_CAMPAIGN_NAME'   , 'CAMPAIGN_NAME'                    , '{0}'        , 'CAMPAIGN_ID'         , '~/Campaigns/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView.Gmail', 14, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly    'Opportunities.DetailView.Gmail', 15, 'TextBox', 'Opportunities.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Quotes.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Quotes.DetailView.Gmail', 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   ,  0, 'Quotes.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   ,  2, 'Quotes.LBL_QUOTE_NUM'             , 'QUOTE_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView.Gmail'   ,  3, 'Quotes.LBL_QUOTE_STAGE'           , 'QUOTE_STAGE'                       , '{0}'        , 'quote_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   ,  4, 'Quotes.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'      , 'DATE_QUOTE_EXPECTED_CLOSED'        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Quotes.DetailView.Gmail'   ,  6, 'Quotes.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   ,  7, 'Quotes.LBL_ORIGINAL_PO_DATE'      , 'ORIGINAL_PO_DATE'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   , 10, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   , 11, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Gmail'   , 12, 'Quotes.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Gmail'   , 13, 'Quotes.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Gmail'   , 14, 'Quotes.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Quotes.DetailView.Gmail'   , 15, 'Quotes.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   , 16, 'Quotes.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Quotes.DetailView.Gmail'   , 17, 'Quotes.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Quotes.DetailView.Gmail'   , 18, 'TextBox', 'Quotes.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Quotes.DetailView.Gmail' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update DETAILVIEWS_FIELDS
		--   set LIST_NAME         = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where DETAIL_NAME       = 'Quotes.DetailView.Gmail'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and LIST_NAME         = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Orders.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Orders.DetailView.Gmail', 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   ,  0, 'Orders.LBL_NAME'                  , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   ,  1, 'Orders.LBL_OPPORTUNITY_NAME'      , 'OPPORTUNITY_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   ,  2, 'Orders.LBL_ORDER_NUM'             , 'ORDER_NUM'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView.Gmail'   ,  3, 'Orders.LBL_ORDER_STAGE'           , 'ORDER_STAGE'                       , '{0}'        , 'order_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   ,  4, 'Orders.LBL_PURCHASE_ORDER_NUM'    , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   ,  5, 'Orders.LBL_DATE_ORDER_DUE'        , 'DATE_ORDER_DUE'                    , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Orders.DetailView.Gmail'   ,  6, 'Orders.LBL_PAYMENT_TERMS'         , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'    , 'DATE_ORDER_SHIPPED'                , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   ,  8, 'Teams.LBL_TEAM'                   , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   ,  9, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   , 10, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   , 11, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Gmail'   , 12, 'Orders.LBL_BILLING_CONTACT_NAME'  , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Gmail'   , 13, 'Orders.LBL_SHIPPING_CONTACT_NAME' , 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Gmail'   , 14, 'Orders.LBL_BILLING_ACCOUNT_NAME'  , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Orders.DetailView.Gmail'   , 15, 'Orders.LBL_SHIPPING_ACCOUNT_NAME' , 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   , 16, 'Orders.LBL_BILLING_ADDRESS'       , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Orders.DetailView.Gmail'   , 17, 'Orders.LBL_SHIPPING_ADDRESS'      , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Orders.DetailView.Gmail'   , 18, 'TextBox', 'Orders.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Orders.DetailView.Gmail' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update DETAILVIEWS_FIELDS
		--   set LIST_NAME         = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where DETAIL_NAME       = 'Orders.DetailView.Gmail'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and LIST_NAME         = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Invoices.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Invoices.DetailView.Gmail', 'Invoices', 'vwINVOICES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' ,  0, 'Invoices.LBL_NAME'                 , 'NAME'                              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Gmail' ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'     , 'OPPORTUNITY_NAME'                  , '{0}'        , 'OPPORTUNITY_ID' , '~/Opportunities/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' ,  2, 'Invoices.LBL_INVOICE_NUM'          , 'INVOICE_NUM'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView.Gmail' ,  3, 'Invoices.LBL_INVOICE_STAGE'        , 'INVOICE_STAGE'                     , '{0}'        , 'invoice_stage_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Gmail' ,  4, 'Invoices.LBL_QUOTE_NAME'           , 'QUOTE_NAME'                        , '{0}'        , 'QUOTE_ID'       , '~/Quotes/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Invoices.DetailView.Gmail' ,  5, 'Invoices.LBL_PAYMENT_TERMS'        , 'PAYMENT_TERMS'                     , '{0}'        , 'payment_terms_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Gmail' ,  6, 'Invoices.LBL_ORDER_NAME'           , 'ORDER_NAME'                        , '{0}'        , 'ORDER_ID'       , '~/Orders/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' ,  7, 'Invoices.LBL_DUE_DATE'             , 'DUE_DATE'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Invoices.DetailView.Gmail' ,  8, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' ,  9, 'Invoices.LBL_PURCHASE_ORDER_NUM'   , 'PURCHASE_ORDER_NUM'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' , 10, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' , 11, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'   , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' , 12, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                  , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' , 13, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME' , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Gmail' , 14, 'Invoices.LBL_BILLING_CONTACT_NAME' , 'BILLING_CONTACT_NAME'              , '{0}'        , 'BILLING_CONTACT_ID' , '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Gmail' , 15, 'Invoices.LBL_SHIPPING_CONTACT_NAME', 'SHIPPING_CONTACT_NAME'             , '{0}'        , 'SHIPPING_CONTACT_ID', '~/Contacts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Gmail' , 16, 'Invoices.LBL_BILLING_ACCOUNT_NAME' , 'BILLING_ACCOUNT_NAME'              , '{0}'        , 'BILLING_ACCOUNT_ID' , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Invoices.DetailView.Gmail' , 17, 'Invoices.LBL_SHIPPING_ACCOUNT_NAME', 'SHIPPING_ACCOUNT_NAME'             , '{0}'        , 'SHIPPING_ACCOUNT_ID', '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' , 18, 'Invoices.LBL_BILLING_ADDRESS'      , 'BILLING_ADDRESS_HTML'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Invoices.DetailView.Gmail' , 19, 'Invoices.LBL_SHIPPING_ADDRESS'     , 'SHIPPING_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Invoices.DetailView.Gmail' , 20, 'TextBox', 'Invoices.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Invoices.DetailView.Gmail' and DATA_FIELD = 'PAYMENT_TERMS' and LIST_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update DETAILVIEWS_FIELDS
		--   set LIST_NAME         = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where DETAIL_NAME       = 'Invoices.DetailView.Gmail'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and LIST_NAME         = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contracts.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contracts.DetailView.Gmail';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contracts.DetailView.Gmail', 'Contracts', 'vwCONTRACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail',  0, 'Contracts.LBL_NAME'                , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail',  1, 'Contracts.LBL_START_DATE'          , 'START_DATE'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail',  2, 'Contracts.LBL_REFERENCE_CODE'      , 'REFERENCE_CODE'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail',  3, 'Contracts.LBL_END_DATE'            , 'END_DATE'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contracts.DetailView.Gmail',  4, 'Contracts.LBL_ACCOUNT_NAME'        , 'ACCOUNT_NAME'                     , '{0}'        , 'ACCOUNT_ID'          , '~/Accounts/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Contracts.DetailView.Gmail',  5, 'Contracts.LBL_STATUS'              , 'STATUS'                           , '{0}'        , 'contract_status_dom' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contracts.DetailView.Gmail',  6, 'Contracts.LBL_OPPORTUNITY_NAME'    , 'OPPORTUNITY_NAME'                 , '{0}'        , 'OPPORTUNITY_ID'      , '~/Opportunities/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail',  7, 'Contracts.LBL_COMPANY_SIGNED_DATE' , 'COMPANY_SIGNED_DATE'              , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail',  8, 'Contracts.LBL_CONTRACT_VALUE'      , 'TOTAL_CONTRACT_VALUE'             , '{0:c}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail',  9, 'Contracts.LBL_CUSTOMER_SIGNED_DATE', 'CUSTOMER_SIGNED_DATE'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail', 10, 'Teams.LBL_TEAM'                    , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail', 11, '.LBL_DATE_MODIFIED'                , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail', 12, '.LBL_ASSIGNED_TO'                  , 'ASSIGNED_TO_NAME'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail', 13, '.LBL_DATE_ENTERED'                 , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail', 14, 'Contracts.LBL_EXPIRATION_NOTICE'   , 'EXPIRATION_NOTICE'                , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contracts.DetailView.Gmail', 15, 'Contracts.LBL_TYPE'                , 'TYPE'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contracts.DetailView.Gmail', 16, 'TextBox', 'Contracts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
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

call dbo.spDETAILVIEWS_FIELDS_Gmail()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_Gmail')
/

-- #endif IBM_DB2 */


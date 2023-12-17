

print 'EDITVIEWS_FIELDS Gmail';
--delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.EditView.Gmail'
--GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditView.Gmail';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Accounts.EditView.Gmail'       , 'Accounts'      , 'vwACCOUNTS_Edit'      , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       ,  0, 'Accounts.LBL_ACCOUNT_NAME'              , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       ,  1, 'Accounts.LBL_PHONE'                     , 'PHONE_OFFICE'               , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       ,  2, 'Accounts.LBL_WEBSITE'                   , 'WEBSITE'                    , 0, 1, 255, 28, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       ,  3, 'Accounts.LBL_FAX'                       , 'PHONE_FAX'                  , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       ,  4, 'Accounts.LBL_TICKER_SYMBOL'             , 'TICKER_SYMBOL'              , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       ,  5, 'Accounts.LBL_OTHER_PHONE'               , 'PHONE_ALTERNATE'            , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Accounts.EditView.Gmail'       ,  6, 'Accounts.LBL_MEMBER_OF'                 , 'PARENT_ID'                  , 0, 1, 'PARENT_NAME'        , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       ,  7, 'Accounts.LBL_EMAIL'                     , 'EMAIL1'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Accounts.EditView.Gmail'       ,  7, 'Email Address'                          , 'EMAIL1'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       ,  8, 'Accounts.LBL_EMPLOYEES'                 , 'EMPLOYEES'                  , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       ,  9, 'Accounts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Accounts.EditView.Gmail'       ,  9, 'Email Address'                          , 'EMAIL2'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 10, 'Accounts.LBL_OWNERSHIP'                 , 'OWNERSHIP'                  , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 11, 'Accounts.LBL_RATING'                    , 'RATING'                     , 0, 2,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Accounts.EditView.Gmail'       , 12, 'Accounts.LBL_INDUSTRY'                  , 'INDUSTRY'                   , 0, 1, 'industry_dom'       , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 13, 'Accounts.LBL_SIC_CODE'                  , 'SIC_CODE'                   , 0, 2,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Accounts.EditView.Gmail'       , 14, 'Accounts.LBL_TYPE'                      , 'ACCOUNT_TYPE'               , 0, 1, 'account_type_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 15, 'Accounts.LBL_ANNUAL_REVENUE'            , 'ANNUAL_REVENUE'             , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Accounts.EditView.Gmail'       , 16, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Accounts.EditView.Gmail'       , 17, '.LBL_EXCHANGE_FOLDER'                   , 'EXCHANGE_FOLDER'            , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Accounts.EditView.Gmail'       , 18, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Accounts.EditView.Gmail'       , 19, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditView.Gmail'       , 20, 'Accounts.LBL_BILLING_ADDRESS_STREET'    , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditView.Gmail'       , 21, 'Accounts.LBL_SHIPPING_ADDRESS_STREET'   , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 22, 'Accounts.LBL_CITY'                      , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 23, 'Accounts.LBL_CITY'                      , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 24, 'Accounts.LBL_STATE'                     , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 25, 'Accounts.LBL_STATE'                     , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 26, 'Accounts.LBL_POSTAL_CODE'               , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 27, 'Accounts.LBL_POSTAL_CODE'               , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 28, 'Accounts.LBL_COUNTRY'                   , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.Gmail'       , 29, 'Accounts.LBL_COUNTRY'                   , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditView.Gmail'       , 30, 'Accounts.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 5,   3,160, 3;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Bugs.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Bugs.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Bugs.EditView.Gmail'           , 'Bugs'          , 'vwBUGS_Edit'          , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Bugs.EditView.Gmail'           ,  0, 'Bugs.LBL_BUG_NUMBER'                    , 'BUG_NUMBER'                 , null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Bugs.EditView.Gmail'           ,  1, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'    , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.Gmail'           ,  2, 'Bugs.LBL_PRIORITY'                      , 'PRIORITY'                   , 0, 1, 'bug_priority_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Bugs.EditView.Gmail'           ,  3, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.Gmail'           ,  4, 'Bugs.LBL_TYPE'                          , 'TYPE'                       , 0, 1, 'bug_type_dom'        , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Bugs.EditView.Gmail'           ,  5, '.LBL_EXCHANGE_FOLDER'                   , 'EXCHANGE_FOLDER'            , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.Gmail'           ,  6, 'Bugs.LBL_SOURCE'                        , 'SOURCE'                     , 0, 1, 'source_dom'          , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.Gmail'           ,  7, 'Bugs.LBL_STATUS'                        , 'STATUS'                     , 0, 1, 'bug_status_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.Gmail'           ,  8, 'Bugs.LBL_PRODUCT_CATEGORY'              , 'PRODUCT_CATEGORY'           , 0, 1, 'product_category_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.Gmail'           ,  9, 'Bugs.LBL_RESOLUTION'                    , 'RESOLUTION'                 , 0, 2, 'bug_resolution_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.Gmail'           , 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.Gmail'           , 11, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Bugs.EditView.Gmail'           , 12, 'Bugs.LBL_FOUND_IN_RELEASE'              , 'FOUND_IN_RELEASE_ID'        , 0, 1, 'FOUND_IN_RELEASE'    , 'Releases', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Bugs.EditView.Gmail'           , 13, 'Bugs.LBL_FIXED_IN_RELEASE'              , 'FIXED_IN_RELEASE_ID'        , 0, 1, 'FIXED_IN_RELEASE'    , 'Releases', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.Gmail'           , 14, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.Gmail'           , 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsFile        'Bugs.EditView.Gmail'           , 16, 'Bugs.LBL_FILENAME'                      , 'ATTACHMENT'                 , 0, 2, 255, 60, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Bugs.EditView.Gmail'           , 17, 'Bugs.LBL_SUBJECT'                       , 'NAME'                       , 1, 3,   1, 70, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Bugs.EditView.Gmail'           , 18, 'Bugs.LBL_DESCRIPTION'                   , 'DESCRIPTION'                , 0, 3,   8, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.Gmail'           , 19, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.Gmail'           , 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Bugs.EditView.Gmail'           , 21, 'Bugs.LBL_WORK_LOG'                      , 'WORK_LOG'                   , 0, 3,   2, 80, 3;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Cases.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Cases.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Cases.EditView.Gmail'          , 'Cases'         , 'vwCASES_Edit'         , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Cases.EditView.Gmail'          ,  0, 'Cases.LBL_CASE_NUMBER'                  , 'CASE_NUMBER'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Cases.EditView.Gmail'          ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Cases.EditView.Gmail'          ,  2, 'Cases.LBL_PRIORITY'                     , 'PRIORITY'                   , 0, 1, 'case_priority_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Cases.EditView.Gmail'          ,  3, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Cases.EditView.Gmail'          ,  4, 'Cases.LBL_STATUS'                       , 'STATUS'                     , 0, 1, 'case_status_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Cases.EditView.Gmail'          ,  5, 'Cases.LBL_ACCOUNT_NAME'                 , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Cases.EditView.Gmail'          ,  6, '.LBL_EXCHANGE_FOLDER'                   , 'EXCHANGE_FOLDER'            , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Cases.EditView.Gmail'          ,  7, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Cases.EditView.Gmail'          ,  8, 'Cases.LBL_SUBJECT'                      , 'NAME'                       , 1, 3, 1, 70, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Cases.EditView.Gmail'          ,  9, 'Cases.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 3, 8, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Cases.EditView.Gmail'          , 10, 'Cases.LBL_RESOLUTION'                   , 'RESOLUTION'                 , 0, 3, 5, 80, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.Gmail';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Contacts.EditView.Gmail'      , 'Contacts'      , 'vwCONTACTS_Edit'      , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contacts.EditView.Gmail'       ,  0, 'Contacts.LBL_FIRST_NAME'                , 'SALUTATION'                 , 0, 1, 'salutation_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       ,  1, null                                     , 'FIRST_NAME'                 , 0, 1,  25, 25, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       ,  2, 'Contacts.LBL_OFFICE_PHONE'              , 'PHONE_WORK'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       ,  3, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 1, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       ,  4, 'Contacts.LBL_MOBILE_PHONE'              , 'PHONE_MOBILE'               , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.Gmail'       ,  5, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 0, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       ,  6, 'Contacts.LBL_HOME_PHONE'                , 'PHONE_HOME'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contacts.EditView.Gmail'       ,  7, 'Contacts.LBL_LEAD_SOURCE'               , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       ,  8, 'Contacts.LBL_OTHER_PHONE'               , 'PHONE_OTHER'                , 0, 2,  25, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       ,  9, 'Contacts.LBL_TITLE'                     , 'TITLE'                      , 0, 1,  40, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 10, 'Contacts.LBL_FAX_PHONE'                 , 'PHONE_FAX'                  , 0, 2,  25, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 11, 'Contacts.LBL_DEPARTMENT'                , 'DEPARTMENT'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 12, 'Contacts.LBL_EMAIL_ADDRESS'             , 'EMAIL1'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Contacts.EditView.Gmail'       , 12, 'Email Address'                          , 'EMAIL1'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.Gmail'       , 13, 'Contacts.LBL_BIRTHDATE'                 , 'BIRTHDATE'                  , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 14, 'Contacts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Contacts.EditView.Gmail'       , 14, 'Email Address'                          , 'EMAIL2'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.Gmail'       , 15, 'Contacts.LBL_REPORTS_TO'                , 'REPORTS_TO_ID'              , 0, 1, 'REPORTS_TO_NAME'    , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 16, 'Contacts.LBL_ASSISTANT'                 , 'ASSISTANT'                  , 0, 2,  75, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.Gmail'       , 17, 'Contacts.LBL_SYNC_CONTACT'              , 'SYNC_CONTACT'               , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 18, 'Contacts.LBL_ASSISTANT_PHONE'           , 'ASSISTANT_PHONE'            , 0, 2,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.Gmail'       , 19, 'Contacts.LBL_DO_NOT_CALL'               , 'DO_NOT_CALL'                , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.Gmail'       , 20, 'Contacts.LBL_EMAIL_OPT_OUT'             , 'EMAIL_OPT_OUT'              , 0, 2, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.Gmail'       , 21, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Contacts.EditView.Gmail'       , 22, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.Gmail'       , 23, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.Gmail'       , 24, 'Contacts.LBL_INVALID_EMAIL'             , 'INVALID_EMAIL'              , 0, 2, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditView.Gmail'       , 25, 'Contacts.LBL_PRIMARY_ADDRESS'           , 'PRIMARY_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditView.Gmail'       , 26, 'Contacts.LBL_ALTERNATE_ADDRESS'         , 'ALT_ADDRESS_STREET'         , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 27, 'Contacts.LBL_CITY'                      , 'PRIMARY_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 28, 'Contacts.LBL_CITY'                      , 'ALT_ADDRESS_CITY'           , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 29, 'Contacts.LBL_STATE'                     , 'PRIMARY_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 30, 'Contacts.LBL_STATE'                     , 'ALT_ADDRESS_STATE'          , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 31, 'Contacts.LBL_POSTAL_CODE'               , 'PRIMARY_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 32, 'Contacts.LBL_POSTAL_CODE'               , 'ALT_ADDRESS_POSTALCODE'     , 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 33, 'Contacts.LBL_COUNTRY'                   , 'PRIMARY_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.Gmail'       , 34, 'Contacts.LBL_COUNTRY'                   , 'ALT_ADDRESS_COUNTRY'        , 0, 4, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditView.Gmail'       , 35, 'Contacts.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 5,   3,160, 3;
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Contacts.EditView.Gmail', 'ACCOUNT_ID' , '1';
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.EditView.Gmail';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Leads.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Leads.EditView.Gmail'         , 'Leads'         , 'vwLEADS_Edit'         , '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Leads.EditView.Gmail'          ,  0, 'Leads.LBL_LEAD_SOURCE'                  , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Leads.EditView.Gmail'          ,  1, 'Leads.LBL_STATUS'                       , 'STATUS'                     , 0, 2, 'lead_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.Gmail'          ,  2, 'Leads.LBL_LEAD_SOURCE_DESCRIPTION'      , 'LEAD_SOURCE_DESCRIPTION'    , 0, 1,   3, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.Gmail'          ,  3, 'Leads.LBL_STATUS_DESCRIPTION'           , 'STATUS_DESCRIPTION'         , 0, 2,   3, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          ,  4, 'Leads.LBL_REFERED_BY'                   , 'REFERED_BY'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Leads.EditView.Gmail'          ,  5, '.LBL_EXCHANGE_FOLDER'                   , 'EXCHANGE_FOLDER'            , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.Gmail'          ,  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.Gmail'          ,  7, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Leads.EditView.Gmail'          ,  8, 'Leads.LBL_FIRST_NAME'                   , 'SALUTATION'                 , 0, 1, 'salutation_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          ,  9, null                                     , 'FIRST_NAME'                 , 0, 1,  25, 25, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 10, 'Leads.LBL_OFFICE_PHONE'                 , 'PHONE_WORK'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 11, 'Leads.LBL_LAST_NAME'                    , 'LAST_NAME'                  , 1, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 12, 'Leads.LBL_MOBILE_PHONE'                 , 'PHONE_MOBILE'               , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.Gmail'          , 13, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 14, 'Leads.LBL_HOME_PHONE'                   , 'PHONE_HOME'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 15, 'Leads.LBL_ACCOUNT_NAME'                 , 'ACCOUNT_NAME'               , 0, 1, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 16, 'Leads.LBL_OTHER_PHONE'                  , 'PHONE_OTHER'                , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.Gmail'          , 17, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 18, 'Leads.LBL_FAX_PHONE'                    , 'PHONE_FAX'                  , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 19, 'Leads.LBL_TITLE'                        , 'TITLE'                      , 0, 1,  40, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 20, 'Leads.LBL_EMAIL_ADDRESS'                , 'EMAIL1'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Leads.EditView.Gmail'          , 20, 'Email Address'                          , 'EMAIL1'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 21, 'Leads.LBL_DEPARTMENT'                   , 'DEPARTMENT'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 22, 'Leads.LBL_OTHER_EMAIL_ADDRESS'          , 'EMAIL2'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Leads.EditView.Gmail'          , 22, 'Email Address'                          , 'EMAIL2'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Leads.EditView.Gmail'          , 23, 'Leads.LBL_DO_NOT_CALL'                  , 'DO_NOT_CALL'                , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Leads.EditView.Gmail'          , 24, 'Leads.LBL_EMAIL_OPT_OUT'                , 'EMAIL_OPT_OUT'              , 0, 2, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Leads.EditView.Gmail'          , 25, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.Gmail'          , 26, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Leads.EditView.Gmail'          , 27, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Leads.EditView.Gmail'          , 28, 'Leads.LBL_INVALID_EMAIL'                , 'INVALID_EMAIL'              , 0, 2, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.Gmail'          , 29, 'Leads.LBL_PRIMARY_ADDRESS_STREET'       , 'PRIMARY_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.Gmail'          , 30, 'Leads.LBL_ALT_ADDRESS_STREET'           , 'ALT_ADDRESS_STREET'         , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 31, 'Leads.LBL_CITY'                         , 'PRIMARY_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 32, 'Leads.LBL_CITY'                         , 'ALT_ADDRESS_CITY'           , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 33, 'Leads.LBL_STATE'                        , 'PRIMARY_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 34, 'Leads.LBL_STATE'                        , 'ALT_ADDRESS_STATE'          , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 35, 'Leads.LBL_POSTAL_CODE'                  , 'PRIMARY_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 36, 'Leads.LBL_POSTAL_CODE'                  , 'ALT_ADDRESS_POSTALCODE'     , 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 37, 'Leads.LBL_COUNTRY'                      , 'PRIMARY_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.Gmail'          , 38, 'Leads.LBL_COUNTRY'                      , 'ALT_ADDRESS_COUNTRY'        , 0, 4, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.Gmail'          , 39, 'Leads.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 5,   3,160, 3;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Opportunities.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Opportunities.EditView.Gmail' , 'Opportunities' , 'vwOPPORTUNITIES_Edit' , '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView.Gmail'  ,  0, 'Opportunities.LBL_OPPORTUNITY_NAME'     , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView.Gmail'  ,  1, 'Opportunities.LBL_CURRENCY'             , 'CURRENCY_ID'                , 0, 2, 'Currencies'          , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Opportunities.EditView.Gmail'  ,  2, 'Opportunities.LBL_ACCOUNT_NAME'         , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'        , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView.Gmail'  ,  3, 'Opportunities.LBL_AMOUNT'               , 'AMOUNT'                     , 1, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView.Gmail'  ,  4, 'Opportunities.LBL_TYPE'                 , 'OPPORTUNITY_TYPE'           , 0, 1, 'opportunity_type_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Opportunities.EditView.Gmail'  ,  5, 'Opportunities.LBL_DATE_CLOSED'          , 'DATE_CLOSED'                , 1, 2, 'DatePicker'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView.Gmail'  ,  6, 'Opportunities.LBL_LEAD_SOURCE'          , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView.Gmail'  ,  7, 'Opportunities.LBL_NEXT_STEP'            , 'NEXT_STEP'                  , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Opportunities.EditView.Gmail'  ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'           , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView.Gmail'  ,  9, 'Opportunities.LBL_PROBABILITY'          , 'PROBABILITY'                , 0, 2,   3,  4, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Opportunities.EditView.Gmail'  , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'    , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView.Gmail'  , 11, 'Opportunities.LBL_SALES_STAGE'          , 'SALES_STAGE'                , 0, 2, 'sales_stage_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Opportunities.EditView.Gmail'  , 12, '.LBL_EXCHANGE_FOLDER'                   , 'EXCHANGE_FOLDER'            , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Opportunities.EditView.Gmail'  , 13, 'Opportunities.LBL_CAMPAIGN_NAME'        , 'CAMPAIGN_ID'                , 0, 2, 'CAMPAIGN_NAME'        , 'Campaigns', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Opportunities.EditView.Gmail'  , 14, 'Opportunities.LBL_DESCRIPTION'          , 'DESCRIPTION'                , 0, 3,   8, 60, 3;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditView.Gmail', 'Quotes', 'vwQUOTES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Gmail'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditView.Gmail'         ,  2, 'Quotes.LBL_QUOTE_NUM'                   , 'QUOTE_NUM'                  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.Gmail'         ,  3, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 1, 2, 'quote_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         ,  4, 'Quotes.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Gmail'         ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'            , 'DATE_QUOTE_EXPECTED_CLOSED' , 1, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.Gmail'         ,  6, 'Quotes.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Gmail'         ,  7, 'Quotes.LBL_ORIGINAL_PO_DATE'            , 'ORIGINAL_PO_DATE'           , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Gmail'         ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView.Gmail'         ,  9, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Gmail'         , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView.Gmail'         , 11, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Gmail'         , 12, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.Gmail'         , 13, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Gmail'         , 14, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Gmail'         , 15, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.Gmail'         , 16, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditView.Gmail'         , 17, 'Quotes.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditView.Gmail'         , 18, 'Quotes.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         , 19, 'Quotes.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         , 20, 'Quotes.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         , 21, 'Quotes.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         , 22, 'Quotes.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         , 23, 'Quotes.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         , 24, 'Quotes.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         , 25, 'Quotes.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.Gmail'         , 26, 'Quotes.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditView.Gmail'         , 27, 'Quotes.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Gmail', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Gmail', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditView.Gmail', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditView.Gmail', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Gmail', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.Gmail', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.Gmail' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Quotes.EditView.Gmail'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditView.Gmail', 'Orders', 'vwORDERS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Gmail'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Orders.EditView.Gmail'         ,  2, 'Orders.LBL_ORDER_NUM'                   , 'ORDER_NUM'                  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView.Gmail'         ,  3, 'Orders.LBL_ORDER_STAGE'                 , 'ORDER_STAGE'                , 1, 2, 'order_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         ,  4, 'Orders.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.Gmail'         ,  5, 'Orders.LBL_DATE_ORDER_DUE'              , 'DATE_ORDER_DUE'             , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView.Gmail'         ,  6, 'Orders.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.Gmail'         ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'          , 'DATE_ORDER_SHIPPED'         , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Gmail'         ,  8, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Gmail'         ,  9, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Gmail'         , 10, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.Gmail'         , 11, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Gmail'         , 12, 'Orders.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Gmail'         , 13, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.Gmail'         , 14, 'Orders.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditView.Gmail'         , 15, 'Orders.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditView.Gmail'         , 16, 'Orders.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         , 17, 'Orders.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         , 18, 'Orders.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         , 19, 'Orders.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         , 20, 'Orders.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         , 21, 'Orders.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         , 22, 'Orders.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         , 23, 'Orders.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.Gmail'         , 24, 'Orders.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditView.Gmail'         , 25, 'Orders.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Gmail', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Gmail', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Orders.EditView.Gmail', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Orders.EditView.Gmail', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Gmail', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.Gmail', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.Gmail' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Orders.EditView.Gmail'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditView.Gmail', 'Invoices', 'vwINVOICES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Gmail'       ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'          , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView.Gmail'       ,  2, 'Invoices.LBL_INVOICE_NUM'               , 'INVOICE_NUM'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView.Gmail'       ,  3, 'Invoices.LBL_INVOICE_STAGE'             , 'INVOICE_STAGE'              , 1, 2, 'invoice_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView.Gmail'       ,  4, 'Invoices.LBL_QUOTE_NAME'                , 'QUOTE_NAME'                 , null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView.Gmail'       ,  5, 'Invoices.LBL_AMOUNT_DUE'                , 'AMOUNT_DUE_USDOLLAR'        , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       ,  6, 'Invoices.LBL_PURCHASE_ORDER_NUM'        , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.Gmail'       ,  7, 'Invoices.LBL_DUE_DATE'                  , 'DUE_DATE'                   , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Invoices.EditView.Gmail'       ,  8, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView.Gmail'       ,  9, 'Invoices.LBL_PAYMENT_TERMS'             , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Gmail'       , 10, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Gmail'       , 11, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Gmail'       , 12, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.Gmail'       , 13, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Gmail'       , 14, 'Invoices.LBL_ACCOUNT'                   , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Gmail'       , 15, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.Gmail'       , 16, 'Invoices.LBL_CONTACT'                   , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditView.Gmail'       , 17, 'Invoices.LBL_STREET'                    , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditView.Gmail'       , 18, 'Invoices.LBL_STREET'                    , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       , 19, 'Invoices.LBL_CITY'                      , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       , 20, 'Invoices.LBL_CITY'                      , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       , 21, 'Invoices.LBL_STATE'                     , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       , 22, 'Invoices.LBL_STATE'                     , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       , 23, 'Invoices.LBL_POSTAL_CODE'               , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       , 24, 'Invoices.LBL_POSTAL_CODE'               , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       , 25, 'Invoices.LBL_COUNTRY'                   , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.Gmail'       , 26, 'Invoices.LBL_COUNTRY'                   , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditView.Gmail'       , 27, 'Invoices.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Gmail', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Gmail', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditView.Gmail', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditView.Gmail', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Gmail', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.Gmail', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.Gmail' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Invoices.EditView.Gmail'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView.Gmail' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.EditView.Gmail';
	exec dbo.spEDITVIEWS_InsertOnly            'Contracts.EditView.Gmail', 'Contracts', 'vwCONTRACTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Gmail'      ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                        , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Gmail'      ,  1, 'Contracts.LBL_STATUS'                   , 'STATUS'                      , 1, 2, 'contract_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Gmail'      ,  2, 'Contracts.LBL_REFERENCE_CODE'           , 'REFERENCE_CODE'              , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Gmail'      ,  3, 'Contracts.LBL_START_DATE'               , 'START_DATE'                  , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Gmail'      ,  4, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                  , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Gmail'      ,  5, 'Contracts.LBL_END_DATE'                 , 'END_DATE'                    , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Gmail'      ,  6, 'Contracts.LBL_OPPORTUNITY_NAME'         , 'OPPORTUNITY_ID'              , 0, 1, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Gmail'      ,  7, 'Contracts.LBL_CURRENCY'                 , 'CURRENCY_ID'                 , 0, 2, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Gmail'      ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                     , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView.Gmail'      ,  9, 'Contracts.LBL_CONTRACT_VALUE'           , 'TOTAL_CONTRACT_VALUE'        , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView.Gmail'      , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'            , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Gmail'      , 11, 'Contracts.LBL_COMPANY_SIGNED_DATE'      , 'COMPANY_SIGNED_DATE'         , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Gmail'      , 12, 'Contracts.LBL_EXPIRATION_NOTICE'        , 'EXPIRATION_NOTICE'           , 0, 1, 'DateTimeEdit'       , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView.Gmail'      , 13, 'Contracts.LBL_CUSTOMER_SIGNED_DATE'     , 'CUSTOMER_SIGNED_DATE'        , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView.Gmail'      , 14, 'Contracts.LBL_TYPE'                     , 'TYPE_ID'                     , 0, 2, 'ContractTypes'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Contracts.EditView.Gmail'      , 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contracts.EditView.Gmail'      , 16, 'Contracts.LBL_DESCRIPTION'              , 'DESCRIPTION'                 , 0, 3,   8, 80, 3;
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

call dbo.spEDITVIEWS_FIELDS_Gmail()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_Gmail')
/

-- #endif IBM_DB2 */



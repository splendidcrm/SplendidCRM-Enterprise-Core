

print 'EDITVIEWS_FIELDS EditView.OfficeAddin';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.EditView.OfficeAddin'
--GO

set nocount on;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Accounts.EditView.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Accounts.EditView.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly            'Accounts.EditView.OfficeAddin'      , 'Accounts'      , 'vwACCOUNTS_Edit'      , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       ,  0, 'Accounts.LBL_ACCOUNT_NAME'              , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       ,  1, 'Accounts.LBL_PHONE'                     , 'PHONE_OFFICE'               , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       ,  2, 'Accounts.LBL_WEBSITE'                   , 'WEBSITE'                    , 0, 1, 255, 28, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       ,  3, 'Accounts.LBL_FAX'                       , 'PHONE_FAX'                  , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       ,  4, 'Accounts.LBL_TICKER_SYMBOL'             , 'TICKER_SYMBOL'              , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       ,  5, 'Accounts.LBL_OTHER_PHONE'               , 'PHONE_ALTERNATE'            , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Accounts.EditView.OfficeAddin'       ,  6, 'Accounts.LBL_MEMBER_OF'                 , 'PARENT_ID'                  , 0, 1, 'PARENT_NAME'        , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       ,  7, 'Accounts.LBL_EMAIL'                     , 'EMAIL1'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       ,  8, 'Accounts.LBL_EMPLOYEES'                 , 'EMPLOYEES'                  , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       ,  9, 'Accounts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 10, 'Accounts.LBL_OWNERSHIP'                 , 'OWNERSHIP'                  , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 11, 'Accounts.LBL_RATING'                    , 'RATING'                     , 0, 2,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Accounts.EditView.OfficeAddin'       , 12, 'Accounts.LBL_INDUSTRY'                  , 'INDUSTRY'                   , 0, 1, 'industry_dom'       , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 13, 'Accounts.LBL_SIC_CODE'                  , 'SIC_CODE'                   , 0, 2,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Accounts.EditView.OfficeAddin'       , 14, 'Accounts.LBL_TYPE'                      , 'ACCOUNT_TYPE'               , 0, 1, 'account_type_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 15, 'Accounts.LBL_ANNUAL_REVENUE'            , 'ANNUAL_REVENUE'             , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Accounts.EditView.OfficeAddin'       , 16, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Accounts.EditView.OfficeAddin'       , 17, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Accounts.EditView.OfficeAddin'       , 18, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Accounts.EditView.OfficeAddin'       , 19, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Accounts.EditView.OfficeAddin'       , 20;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditView.OfficeAddin'       , 21, 'Accounts.LBL_BILLING_ADDRESS_STREET'    , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Accounts.EditView.OfficeAddin'       , 22, null                                     , null                         , 0, null, 'AddressButtons', null, null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditView.OfficeAddin'       , 23, 'Accounts.LBL_SHIPPING_ADDRESS_STREET'   , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 24, 'Accounts.LBL_CITY'                      , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 25, 'Accounts.LBL_CITY'                      , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 26, 'Accounts.LBL_STATE'                     , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 27, 'Accounts.LBL_STATE'                     , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 28, 'Accounts.LBL_POSTAL_CODE'               , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 29, 'Accounts.LBL_POSTAL_CODE'               , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 30, 'Accounts.LBL_COUNTRY'                   , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Accounts.EditView.OfficeAddin'       , 31, 'Accounts.LBL_COUNTRY'                   , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Accounts.EditView.OfficeAddin'       , 32;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Accounts.EditView.OfficeAddin'       , 33, 'Accounts.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 5,   2, 60, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Bugs.EditView.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Bugs.EditView.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly            'Bugs.EditView.OfficeAddin'          , 'Bugs'          , 'vwBUGS_Edit'          , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Bugs.EditView.OfficeAddin'           ,  0, 'Bugs.LBL_BUG_NUMBER'                    , 'BUG_NUMBER'                 , null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Bugs.EditView.OfficeAddin'           ,  1, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'    , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.OfficeAddin'           ,  2, 'Bugs.LBL_PRIORITY'                      , 'PRIORITY'                   , 0, 1, 'bug_priority_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Bugs.EditView.OfficeAddin'           ,  3, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'           , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.OfficeAddin'           ,  4, 'Bugs.LBL_STATUS'                        , 'STATUS'                     , 0, 1, 'bug_status_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Bugs.EditView.OfficeAddin'           ,  5, '.LBL_CREATED_BY'                        , 'CREATED_BY_NAME'            , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.OfficeAddin'           ,  6, 'Bugs.LBL_TYPE'                          , 'TYPE'                       , 0, 1, 'bug_type_dom'        , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Bugs.EditView.OfficeAddin'           ,  7, '.LBL_DATE_ENTERED'                      , 'DATE_ENTERED'               , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.OfficeAddin'           ,  8, 'Bugs.LBL_SOURCE'                        , 'SOURCE'                     , 0, 1, 'source_dom'          , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Bugs.EditView.OfficeAddin'           ,  9, '.LBL_MODIFIED_BY'                       , 'MODIFIED_BY_NAME'           , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.OfficeAddin'           , 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Bugs.EditView.OfficeAddin'           , 11, '.LBL_DATE_MODIFIED'                     , 'DATE_MODIFIED'              , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.OfficeAddin'           , 12, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.OfficeAddin'           , 13, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.OfficeAddin'           , 14, 'Bugs.LBL_PRODUCT_CATEGORY'              , 'PRODUCT_CATEGORY'           , 0, 1, 'product_category_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.OfficeAddin'           , 15, 'Bugs.LBL_RESOLUTION'                    , 'RESOLUTION'                 , 0, 2, 'bug_resolution_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.OfficeAddin'           , 16, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.OfficeAddin'           , 17, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.OfficeAddin'           , 18, 'Bugs.LBL_FOUND_IN_RELEASE'              , 'FOUND_IN_RELEASE_ID'        , 0, 1, 'Release'             , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Bugs.EditView.OfficeAddin'           , 19, 'Bugs.LBL_FIXED_IN_RELEASE'              , 'FIXED_IN_RELEASE_ID'        , 0, 2, 'Release'             , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.OfficeAddin'           , 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.OfficeAddin'           , 21, null;
	exec dbo.spEDITVIEWS_FIELDS_InsFile        'Bugs.EditView.OfficeAddin'           , 22, 'Bugs.LBL_FILENAME'                      , 'ATTACHMENT'                 , 0, 2, 255, 60, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Bugs.EditView.OfficeAddin'           , 23, 'Bugs.LBL_SUBJECT'                       , 'NAME'                       , 1, 3,   1, 60, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Bugs.EditView.OfficeAddin'           , 24, 'Bugs.LBL_DESCRIPTION'                   , 'DESCRIPTION'                , 0, 3,   2, 60, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.OfficeAddin'           , 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Bugs.EditView.OfficeAddin'           , 26, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Bugs.EditView.OfficeAddin'           , 27, 'Bugs.LBL_WORK_LOG'                      , 'WORK_LOG'                   , 0, 3,   2, 60, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Cases.EditView.OfficeAddin';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Cases.EditView.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Cases.EditView.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly            'Cases.EditView.OfficeAddin'          , 'Cases'         , 'vwCASES_Edit'         , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Cases.EditView.OfficeAddin'          ,  0, 'Cases.LBL_CASE_NUMBER'                  , 'CASE_NUMBER'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Cases.EditView.OfficeAddin'          ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'           , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Cases.EditView.OfficeAddin'          ,  2, 'Cases.LBL_PRIORITY'                     , 'PRIORITY'                   , 0, 1, 'case_priority_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Cases.EditView.OfficeAddin'          ,  3, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'    , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Cases.EditView.OfficeAddin'          ,  4, 'Cases.LBL_STATUS'                       , 'STATUS'                     , 0, 1, 'case_status_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Cases.EditView.OfficeAddin'          ,  5, 'Cases.LBL_ACCOUNT_NAME'                 , 'ACCOUNT_ID'                 , 1, 2, 'ACCOUNT_NAME'        , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Cases.EditView.OfficeAddin'          ,  6, 'Cases.LBL_SUBJECT'                      , 'NAME'                       , 1, 3, 1, 60, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Cases.EditView.OfficeAddin'          ,  7, 'Cases.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 3, 2, 60, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Cases.EditView.OfficeAddin'          ,  8, 'Cases.LBL_RESOLUTION'                   , 'RESOLUTION'                 , 0, 3, 2, 60, 3;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.EditView.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly            'Contacts.EditView.OfficeAddin'       , 'Contacts'      , 'vwCONTACTS_Edit'      , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contacts.EditView.OfficeAddin'       ,  0, 'Contacts.LBL_FIRST_NAME'                , 'SALUTATION'                 , 0, 1, 'salutation_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       ,  1, null                                     , 'FIRST_NAME'                 , 0, 1,  25, 25, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       ,  2, 'Contacts.LBL_OFFICE_PHONE'              , 'PHONE_WORK'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       ,  3, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 1, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       ,  4, 'Contacts.LBL_MOBILE_PHONE'              , 'PHONE_MOBILE'               , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.OfficeAddin'       ,  5, 'Cases.LBL_ACCOUNT_NAME'                 , 'ACCOUNT_ID'                 , 0, 1, 'ACCOUNT_NAME'        , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       ,  6, 'Contacts.LBL_HOME_PHONE'                , 'PHONE_HOME'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contacts.EditView.OfficeAddin'       ,  7, 'Contacts.LBL_LEAD_SOURCE'               , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       ,  8, 'Contacts.LBL_OTHER_PHONE'               , 'PHONE_OTHER'                , 0, 2,  25, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       ,  9, 'Contacts.LBL_TITLE'                     , 'TITLE'                      , 0, 1,  40, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 10, 'Contacts.LBL_FAX_PHONE'                 , 'PHONE_FAX'                  , 0, 2,  25, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 11, 'Contacts.LBL_DEPARTMENT'                , 'DEPARTMENT'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 12, 'Contacts.LBL_EMAIL_ADDRESS'             , 'EMAIL1'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.OfficeAddin'       , 13, 'Contacts.LBL_BIRTHDATE'                 , 'BIRTHDATE'                  , 0, 1, 'DatePicker'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 14, 'Contacts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.OfficeAddin'       , 15, 'Contacts.LBL_REPORTS_TO'                , 'REPORTS_TO_ID'              , 0, 1, 'REPORTS_TO_NAME'     , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 16, 'Contacts.LBL_ASSISTANT'                 , 'ASSISTANT'                  , 0, 2,  75, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.OfficeAddin'       , 17, 'Contacts.LBL_SYNC_CONTACT'              , 'SYNC_CONTACT'               , 0, 1, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 18, 'Contacts.LBL_ASSISTANT_PHONE'           , 'ASSISTANT_PHONE'            , 0, 2,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.OfficeAddin'       , 19, 'Contacts.LBL_DO_NOT_CALL'               , 'DO_NOT_CALL'                , 0, 1, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.OfficeAddin'       , 20, 'Contacts.LBL_EMAIL_OPT_OUT'             , 'EMAIL_OPT_OUT'              , 0, 2, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.OfficeAddin'       , 21, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'           , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Contacts.EditView.OfficeAddin'       , 22, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.OfficeAddin'       , 23, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'    , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.OfficeAddin'       , 24, 'Contacts.LBL_INVALID_EMAIL'             , 'INVALID_EMAIL'              , 0, 2, 'CheckBox'            , null, null, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Contacts.EditView.OfficeAddin'       , 25;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditView.OfficeAddin'       , 26, 'Contacts.LBL_PRIMARY_ADDRESS'           , 'PRIMARY_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.OfficeAddin'       , 27, null                                     , null                         , 0, null, 'AddressButtons', null, null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditView.OfficeAddin'       , 28, 'Contacts.LBL_ALTERNATE_ADDRESS'         , 'ALT_ADDRESS_STREET'         , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 29, 'Contacts.LBL_CITY'                      , 'PRIMARY_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 30, 'Contacts.LBL_CITY'                      , 'ALT_ADDRESS_CITY'           , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 31, 'Contacts.LBL_STATE'                     , 'PRIMARY_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 32, 'Contacts.LBL_STATE'                     , 'ALT_ADDRESS_STATE'          , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 33, 'Contacts.LBL_POSTAL_CODE'               , 'PRIMARY_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 34, 'Contacts.LBL_POSTAL_CODE'               , 'ALT_ADDRESS_POSTALCODE'     , 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 35, 'Contacts.LBL_COUNTRY'                   , 'PRIMARY_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.OfficeAddin'       , 36, 'Contacts.LBL_COUNTRY'                   , 'ALT_ADDRESS_COUNTRY'        , 0, 4, 100, 10, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Contacts.EditView.OfficeAddin'       , 37;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contacts.EditView.OfficeAddin'       , 38, 'Contacts.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 5,   2, 60, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.EditView.OfficeAddin';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Leads.EditView.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Leads.EditView.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly            'Leads.EditView.OfficeAddin'         , 'Leads'         , 'vwLEADS_Edit'         , '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Leads.EditView.OfficeAddin'          ,  0, 'Leads.LBL_LEAD_SOURCE'                  , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Leads.EditView.OfficeAddin'          ,  1, 'Leads.LBL_STATUS'                       , 'STATUS'                     , 0, 2, 'lead_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.OfficeAddin'          ,  2, 'Leads.LBL_LEAD_SOURCE_DESCRIPTION'      , 'LEAD_SOURCE_DESCRIPTION'    , 0, 1,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.OfficeAddin'          ,  3, 'Leads.LBL_STATUS_DESCRIPTION'           , 'STATUS_DESCRIPTION'         , 0, 2,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          ,  4, 'Leads.LBL_REFERED_BY'                   , 'REFERED_BY'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.OfficeAddin'          ,  5, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.OfficeAddin'          ,  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.OfficeAddin'          ,  7, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Leads.EditView.OfficeAddin'          ,  8, 'Leads.LBL_FIRST_NAME'                   , 'SALUTATION'                 , 0, 1, 'salutation_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          ,  9, null                                     , 'FIRST_NAME'                 , 0, 1,  25, 25, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 10, 'Leads.LBL_OFFICE_PHONE'                 , 'PHONE_WORK'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 11, 'Leads.LBL_LAST_NAME'                    , 'LAST_NAME'                  , 1, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 12, 'Leads.LBL_MOBILE_PHONE'                 , 'PHONE_MOBILE'               , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.OfficeAddin'          , 13, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 14, 'Leads.LBL_HOME_PHONE'                   , 'PHONE_HOME'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 15, 'Leads.LBL_ACCOUNT_NAME'                 , 'ACCOUNT_NAME'               , 0, 1, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 16, 'Leads.LBL_OTHER_PHONE'                  , 'PHONE_OTHER'                , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.OfficeAddin'          , 17, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 18, 'Leads.LBL_FAX_PHONE'                    , 'PHONE_FAX'                  , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 19, 'Leads.LBL_TITLE'                        , 'TITLE'                      , 0, 1,  40, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 20, 'Leads.LBL_EMAIL_ADDRESS'                , 'EMAIL1'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 21, 'Leads.LBL_DEPARTMENT'                   , 'DEPARTMENT'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 22, 'Leads.LBL_OTHER_EMAIL_ADDRESS'          , 'EMAIL2'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Leads.EditView.OfficeAddin'          , 23, 'Leads.LBL_DO_NOT_CALL'                  , 'DO_NOT_CALL'                , 0, 1, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Leads.EditView.OfficeAddin'          , 24, 'Leads.LBL_EMAIL_OPT_OUT'                , 'EMAIL_OPT_OUT'              , 0, 2, 'CheckBox'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Leads.EditView.OfficeAddin'          , 25, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Leads.EditView.OfficeAddin'          , 26, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Leads.EditView.OfficeAddin'          , 27, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Leads.EditView.OfficeAddin'          , 28, 'Leads.LBL_INVALID_EMAIL'                , 'INVALID_EMAIL'              , 0, 2, 'CheckBox'           , null, null, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Leads.EditView.OfficeAddin'          , 29;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.OfficeAddin'          , 30, 'Leads.LBL_PRIMARY_ADDRESS_STREET'       , 'PRIMARY_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Leads.EditView.OfficeAddin'          , 31, null                                     , null                         , 0, null, 'AddressButtons', null, null, 5;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.OfficeAddin'          , 32, 'Leads.LBL_ALT_ADDRESS_STREET'           , 'ALT_ADDRESS_STREET'         , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 33, 'Leads.LBL_CITY'                         , 'PRIMARY_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 34, 'Leads.LBL_CITY'                         , 'ALT_ADDRESS_CITY'           , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 35, 'Leads.LBL_STATE'                        , 'PRIMARY_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 36, 'Leads.LBL_STATE'                        , 'ALT_ADDRESS_STATE'          , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 37, 'Leads.LBL_POSTAL_CODE'                  , 'PRIMARY_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 38, 'Leads.LBL_POSTAL_CODE'                  , 'ALT_ADDRESS_POSTALCODE'     , 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 39, 'Leads.LBL_COUNTRY'                      , 'PRIMARY_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Leads.EditView.OfficeAddin'          , 40, 'Leads.LBL_COUNTRY'                      , 'ALT_ADDRESS_COUNTRY'        , 0, 4, 100, 10, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Leads.EditView.OfficeAddin'          , 41;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Leads.EditView.OfficeAddin'          , 42, 'Leads.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 5,   2, 60, 3;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Opportunities.EditView.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly            'Opportunities.EditView.OfficeAddin' , 'Opportunities' , 'vwOPPORTUNITIES_Edit' , '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView.OfficeAddin'  ,  0, 'Opportunities.LBL_OPPORTUNITY_NAME'     , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView.OfficeAddin'  ,  1, 'Opportunities.LBL_CURRENCY'             , 'CURRENCY_ID'                , 0, 2, 'Currencies'          , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Opportunities.EditView.OfficeAddin'  ,  2, 'Opportunities.LBL_ACCOUNT_NAME'         , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'        , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView.OfficeAddin'  ,  3, 'Opportunities.LBL_AMOUNT'               , 'AMOUNT'                     , 1, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView.OfficeAddin'  ,  4, 'Opportunities.LBL_TYPE'                 , 'OPPORTUNITY_TYPE'           , 0, 1, 'opportunity_type_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Opportunities.EditView.OfficeAddin'  ,  5, 'Opportunities.LBL_DATE_CLOSED'          , 'DATE_CLOSED'                , 1, 2, 'DatePicker'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView.OfficeAddin'  ,  6, 'Opportunities.LBL_LEAD_SOURCE'          , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView.OfficeAddin'  ,  7, 'Opportunities.LBL_NEXT_STEP'            , 'NEXT_STEP'                  , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Opportunities.EditView.OfficeAddin'  ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'           , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView.OfficeAddin'  ,  9, 'Opportunities.LBL_PROBABILITY'          , 'PROBABILITY'                , 0, 2,   3,  4, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Opportunities.EditView.OfficeAddin'  , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'    , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView.OfficeAddin'  , 11, 'Opportunities.LBL_SALES_STAGE'          , 'SALES_STAGE'                , 0, 2, 'sales_stage_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Opportunities.EditView.OfficeAddin'  , 12, 'Opportunities.LBL_DESCRIPTION'          , 'DESCRIPTION'                , 0, 3,   2, 60, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.OfficeAddin'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditView.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditView.OfficeAddin', 'Quotes', 'vwQUOTES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.OfficeAddin'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditView.OfficeAddin'         ,  2, 'Quotes.LBL_QUOTE_NUM'                   , 'QUOTE_NUM'                  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.OfficeAddin'         ,  3, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 1, 2, 'quote_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         ,  4, 'Quotes.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.OfficeAddin'         ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'            , 'DATE_QUOTE_EXPECTED_CLOSED' , 1, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView.OfficeAddin'         ,  6, 'Quotes.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.OfficeAddin'         ,  7, 'Quotes.LBL_ORIGINAL_PO_DATE'            , 'ORIGINAL_PO_DATE'           , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.OfficeAddin'         ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView.OfficeAddin'         ,  9, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.OfficeAddin'         , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView.OfficeAddin'         , 11, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Quotes.EditView.OfficeAddin'         , 12;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.OfficeAddin'         , 13, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView.OfficeAddin'         , 14, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.OfficeAddin'         , 15, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.OfficeAddin'         , 16, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView.OfficeAddin'         , 17, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditView.OfficeAddin'         , 18, 'Quotes.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditView.OfficeAddin'         , 19, 'Quotes.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         , 20, 'Quotes.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         , 21, 'Quotes.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         , 22, 'Quotes.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         , 23, 'Quotes.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         , 24, 'Quotes.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         , 25, 'Quotes.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         , 26, 'Quotes.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView.OfficeAddin'         , 27, 'Quotes.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.OfficeAddin', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.OfficeAddin', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditView.OfficeAddin', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditView.OfficeAddin', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.OfficeAddin', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView.OfficeAddin', 'SHIPPING_CONTACT_ID', '1,1';
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.OfficeAddin'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditView.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditView.OfficeAddin', 'Orders', 'vwORDERS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.OfficeAddin'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Orders.EditView.OfficeAddin'         ,  2, 'Orders.LBL_ORDER_NUM'                   , 'ORDER_NUM'                  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView.OfficeAddin'         ,  3, 'Orders.LBL_ORDER_STAGE'                 , 'ORDER_STAGE'                , 1, 2, 'order_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         ,  4, 'Orders.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.OfficeAddin'         ,  5, 'Orders.LBL_DATE_ORDER_DUE'              , 'DATE_ORDER_DUE'             , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView.OfficeAddin'         ,  6, 'Orders.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.OfficeAddin'         ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'          , 'DATE_ORDER_SHIPPED'         , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.OfficeAddin'         ,  8, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.OfficeAddin'         ,  9, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Orders.EditView.OfficeAddin'         , 10;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.OfficeAddin'         , 11, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView.OfficeAddin'         , 12, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.OfficeAddin'         , 13, 'Orders.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.OfficeAddin'         , 14, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView.OfficeAddin'         , 15, 'Orders.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditView.OfficeAddin'         , 16, 'Orders.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditView.OfficeAddin'         , 17, 'Orders.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         , 18, 'Orders.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         , 19, 'Orders.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         , 20, 'Orders.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         , 21, 'Orders.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         , 22, 'Orders.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         , 23, 'Orders.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         , 24, 'Orders.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView.OfficeAddin'         , 25, 'Orders.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.OfficeAddin', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.OfficeAddin', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Orders.EditView.OfficeAddin', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Orders.EditView.OfficeAddin', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.OfficeAddin', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView.OfficeAddin', 'SHIPPING_CONTACT_ID', '1,1';
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.OfficeAddin';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView.OfficeAddin' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditView.OfficeAddin';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditView.OfficeAddin', 'Invoices', 'vwINVOICES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.OfficeAddin'       ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'          , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView.OfficeAddin'       ,  2, 'Invoices.LBL_INVOICE_NUM'               , 'INVOICE_NUM'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView.OfficeAddin'       ,  3, 'Invoices.LBL_INVOICE_STAGE'             , 'INVOICE_STAGE'              , 1, 2, 'invoice_stage_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.OfficeAddin'       ,  4, 'Invoices.LBL_ORDER_NAME'                , 'ORDER_ID'                   , 0, 1, 'ORDER_NAME'         , 'Orders', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView.OfficeAddin'       ,  5, 'Invoices.LBL_AMOUNT_DUE'                , 'AMOUNT_DUE_USDOLLAR'        , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       ,  6, 'Invoices.LBL_PURCHASE_ORDER_NUM'        , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.OfficeAddin'       ,  7, 'Invoices.LBL_DUE_DATE'                  , 'DUE_DATE'                   , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.OfficeAddin'       ,  8, 'Invoices.LBL_SHIP_DATE'                 , 'SHIP_DATE'                  , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView.OfficeAddin'       ,  9, 'Invoices.LBL_PAYMENT_TERMS'             , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.OfficeAddin'       , 10, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.OfficeAddin'       , 11, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Invoices.EditView.OfficeAddin'       , 12;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.OfficeAddin'       , 13, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView.OfficeAddin'       , 14, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.OfficeAddin'       , 15, 'Invoices.LBL_ACCOUNT'                   , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.OfficeAddin'       , 16, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView.OfficeAddin'       , 17, 'Invoices.LBL_CONTACT'                   , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditView.OfficeAddin'       , 18, 'Invoices.LBL_STREET'                    , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditView.OfficeAddin'       , 19, 'Invoices.LBL_STREET'                    , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       , 20, 'Invoices.LBL_CITY'                      , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       , 21, 'Invoices.LBL_CITY'                      , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       , 22, 'Invoices.LBL_STATE'                     , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       , 23, 'Invoices.LBL_STATE'                     , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       , 24, 'Invoices.LBL_POSTAL_CODE'               , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       , 25, 'Invoices.LBL_POSTAL_CODE'               , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       , 26, 'Invoices.LBL_COUNTRY'                   , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView.OfficeAddin'       , 27, 'Invoices.LBL_COUNTRY'                   , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.OfficeAddin', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.OfficeAddin', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditView.OfficeAddin', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditView.OfficeAddin', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.OfficeAddin', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView.OfficeAddin', 'SHIPPING_CONTACT_ID', '1,1';
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

call dbo.spEDITVIEWS_FIELDS_EditViewMobileOfficeAddin()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_EditViewMobileOfficeAddin')
/

-- #endif IBM_DB2 */


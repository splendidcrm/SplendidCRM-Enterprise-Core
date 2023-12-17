

print 'EDITVIEWS_FIELDS EditView.Portal';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.EditView.Portal';
--GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Bugs.EditView.Portal';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Bugs.EditView.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Bugs.EditView.Portal';
	exec dbo.spEDITVIEWS_InsertOnly          'Bugs.EditView.Portal'           , 'Bugs', 'vwBUGS_Edit', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Bugs.EditView.Portal'           ,  0, 'Bugs.LBL_PRIORITY'                      , 'PRIORITY'                   , 0, 1, 'bug_priority_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Bugs.EditView.Portal'           ,  1, 'Bugs.LBL_STATUS'                        , 'STATUS'                     , 0, 1, 'bug_status_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Bugs.EditView.Portal'           ,  2, 'Bugs.LBL_SOURCE'                        , 'SOURCE'                     , 0, 1, 'source_dom'          , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Bugs.EditView.Portal'           ,  3, 'Bugs.LBL_PRODUCT_CATEGORY'              , 'PRODUCT_CATEGORY'           , 0, 1, 'product_category_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Bugs.EditView.Portal'           ,  4, 'Bugs.LBL_SUBJECT'                       , 'NAME'                       , 1, 1,   1, 70, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Bugs.EditView.Portal'           ,  5, 'Bugs.LBL_DESCRIPTION'                   , 'DESCRIPTION'                , 0, 1,  12,160, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Bugs.EditView.Portal'           ,  6, 'Bugs.LBL_WORK_LOG'                      , 'WORK_LOG'                   , 0, 1,  12,160, 3;
end -- if;
GO

-- delete from EDITVIEWS where NAME like 'Cases.EditView.Portal';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Cases.EditView.Portal';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Cases.EditView.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Cases.EditView.Portal';
	exec dbo.spEDITVIEWS_InsertOnly          'Cases.EditView.Portal'          , 'Cases', 'vwCASES_Edit', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Cases.EditView.Portal'          ,  0, 'Cases.LBL_CASE_NUMBER'                  , 'CASE_NUMBER'                , 0, null, 'Label', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Cases.EditView.Portal'          ,  1, 'Cases.LBL_PRIORITY'                     , 'PRIORITY'                   , 0, 1, 'case_priority_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Cases.EditView.Portal'          ,  2, 'Cases.LBL_SUBJECT'                      , 'NAME'                       , 1, 1, 1, 70, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Cases.EditView.Portal'          ,  3, 'Cases.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 1,12,160, 2;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Contacts.EditView.Portal';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.EditView.Portal';
	exec dbo.spEDITVIEWS_InsertOnly          'Contacts.EditView.Portal'       , 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Contacts.EditView.Portal'       ,  0, 'Contacts.LBL_SALUTATION'                , 'SALUTATION'                 , 0, 1, 'salutation_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Contacts.EditView.Portal'       ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       ,  2, 'Contacts.LBL_FIRST_NAME'                , 'FIRST_NAME'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       ,  3, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       ,  4, 'Contacts.LBL_OFFICE_PHONE'              , 'PHONE_WORK'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       ,  5, 'Contacts.LBL_MOBILE_PHONE'              , 'PHONE_MOBILE'               , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       ,  6, 'Contacts.LBL_HOME_PHONE'                , 'PHONE_HOME'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.EditView.Portal'       ,  7, 'Contacts.LBL_DO_NOT_CALL'               , 'DO_NOT_CALL'                , 0, 1, 'CheckBox'      , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       ,  8, 'Contacts.LBL_EMAIL_ADDRESS'             , 'EMAIL1'                     , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator 'Contacts.EditView.Portal'       ,  8, 'Email Address'                          , 'EMAIL1'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       ,  9, 'Contacts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator 'Contacts.EditView.Portal'       ,  9, 'Email Address'                          , 'EMAIL2'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.EditView.Portal'       , 10, 'Contacts.LBL_EMAIL_OPT_OUT'             , 'EMAIL_OPT_OUT'              , 0, 1, 'CheckBox'      , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Contacts.EditView.Portal'       , 11, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       , 12, 'Contacts.LBL_TITLE'                     , 'TITLE'                      , 0, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       , 13, 'Contacts.LBL_DEPARTMENT'                , 'DEPARTMENT'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.EditView.Portal'       , 14, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 1, null, 'Label', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Contacts.EditView.Portal'       , 15, 'Contacts.LBL_PRIMARY_ADDRESS'           , 'PRIMARY_ADDRESS_STREET'     , 0, 1,   2, 37, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Contacts.EditView.Portal'       , 16, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       , 17, 'Contacts.LBL_CITY'                      , 'PRIMARY_ADDRESS_CITY'       , 0, 1, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       , 18, 'Contacts.LBL_STATE'                     , 'PRIMARY_ADDRESS_STATE'      , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       , 19, 'Contacts.LBL_POSTAL_CODE'               , 'PRIMARY_ADDRESS_POSTALCODE' , 0, 1,  20, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.EditView.Portal'       , 20, 'Contacts.LBL_COUNTRY'                   , 'PRIMARY_ADDRESS_COUNTRY'    , 0, 1, 100, 25, null;
end -- if;
GO

-- delete from EDITVIEWS where NAME like 'Notes.EditView.Portal';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Notes.EditView.Portal';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Notes.EditView.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Notes.EditView.Portal';
	exec dbo.spEDITVIEWS_InsertOnly          'Notes.EditView.Portal'          , 'Notes', 'vwNOTES_Edit', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Notes.EditView.Portal'          ,  0, 'Notes.LBL_SUBJECT'                      , 'NAME'                       , 1, 1, 255, 90, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Notes.EditView.Portal'          ,  1, 'Notes.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 1,  10, 90, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsFile      'Notes.EditView.Portal'          ,  2, 'Notes.LBL_FILENAME'                     , 'ATTACHMENT'                 , 0, 1, 255, 60, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Notes.EditView.Portal'          ,  3, null                                     , 'FILENAME'                   , 0, null, 'Label', null, -1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Notes.EditView.Portal'          ,  4, 'PARENT_TYPE'                            , 'PARENT_ID'                  , 0, null, 'Hidden', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Notes.EditView.Portal'          ,  5, 'Notes.LBL_PARENT_TYPE'                  , 'PARENT_TYPE'                , 0, null, 'Hidden', null, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Contacts.Registration.Portal';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.Registration.Portal' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.Registration.Portal';
	exec dbo.spEDITVIEWS_InsertOnly          'Contacts.Registration.Portal'   , 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Contacts.Registration.Portal'   ,  0, 'Contacts.LBL_SALUTATION'                , 'SALUTATION'                 , 0, 1, 'salutation_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Contacts.Registration.Portal'   ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   ,  2, 'Contacts.LBL_FIRST_NAME'                , 'FIRST_NAME'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   ,  3, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   ,  4, 'Contacts.LBL_OFFICE_PHONE'              , 'PHONE_WORK'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   ,  5, 'Contacts.LBL_MOBILE_PHONE'              , 'PHONE_MOBILE'               , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   ,  6, 'Contacts.LBL_HOME_PHONE'                , 'PHONE_HOME'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.Registration.Portal'   ,  7, 'Contacts.LBL_DO_NOT_CALL'               , 'DO_NOT_CALL'                , 0, 1, 'CheckBox'      , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   ,  8, 'Contacts.LBL_EMAIL_ADDRESS'             , 'EMAIL1'                     , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator 'Contacts.Registration.Portal'   ,  8, 'Email Address'                          , 'EMAIL1'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.Registration.Portal'   ,  9, 'Contacts.LBL_EMAIL_OPT_OUT'             , 'EMAIL_OPT_OUT'              , 0, 1, 'CheckBox'      , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   , 10, 'Contacts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator 'Contacts.Registration.Portal'   , 10, 'Email Address'                          , 'EMAIL2'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Contacts.Registration.Portal'   , 11, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   , 12, 'Contacts.LBL_TITLE'                     , 'TITLE'                      , 0, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   , 13, 'Contacts.LBL_DEPARTMENT'                , 'DEPARTMENT'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   , 14, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 0, 1,  50, 35, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.Registration.Portal'   , 15, null                                     , 'ACCOUNT_ID'                 , 0, null, 'Hidden', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Contacts.Registration.Portal'   , 16, 'Contacts.LBL_PRIMARY_ADDRESS'           , 'PRIMARY_ADDRESS_STREET'     , 0, 1,   2, 37, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Contacts.Registration.Portal'   , 17, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   , 18, 'Contacts.LBL_CITY'                      , 'PRIMARY_ADDRESS_CITY'       , 0, 1, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   , 19, 'Contacts.LBL_STATE'                     , 'PRIMARY_ADDRESS_STATE'      , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   , 20, 'Contacts.LBL_POSTAL_CODE'               , 'PRIMARY_ADDRESS_POSTALCODE' , 0, 1,  20, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Portal'   , 21, 'Contacts.LBL_COUNTRY'                   , 'PRIMARY_ADDRESS_COUNTRY'    , 0, 1, 100, 25, null;
end -- if;
GO

-- 10/15/2015 Paul.  Password field needs to be of type Password. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like 'Contacts.Registration.Self';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.Registration.Self' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.Registration.Self';
	exec dbo.spEDITVIEWS_InsertOnly          'Contacts.Registration.Self'     , 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     ,  0, 'Contacts.LBL_PORTAL_NAME'               , 'PORTAL_NAME'                , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     ,  1, 'Contacts.LBL_PORTAL_PASSWORD'           , 'PORTAL_PASSWORD'            , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList 'Contacts.Registration.Self'     ,  2, 'Contacts.LBL_SALUTATION'                , 'SALUTATION'                 , 0, 1, 'salutation_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     ,  3, 'Contacts.LBL_CONFIRM_PORTAL_PASSWORD'   , 'PORTAL_PASSWORD_CONFIRM'    , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     ,  4, 'Contacts.LBL_FIRST_NAME'                , 'FIRST_NAME'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     ,  5, 'Contacts.LBL_LAST_NAME'                 , 'LAST_NAME'                  , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     ,  6, 'Contacts.LBL_OFFICE_PHONE'              , 'PHONE_WORK'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     ,  7, 'Contacts.LBL_MOBILE_PHONE'              , 'PHONE_MOBILE'               , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     ,  8, 'Contacts.LBL_HOME_PHONE'                , 'PHONE_HOME'                 , 0, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.Registration.Self'     ,  9, 'Contacts.LBL_DO_NOT_CALL'               , 'DO_NOT_CALL'                , 0, 1, 'CheckBox'      , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     , 10, 'Contacts.LBL_EMAIL_ADDRESS'             , 'EMAIL1'                     , 1, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator 'Contacts.Registration.Self'     , 10, 'Email Address'                          , 'EMAIL1'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.Registration.Self'     , 11, 'Contacts.LBL_EMAIL_OPT_OUT'             , 'EMAIL_OPT_OUT'              , 0, 1, 'CheckBox'      , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     , 12, 'Contacts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator 'Contacts.Registration.Self'     , 12, 'Email Address'                          , 'EMAIL2'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Contacts.Registration.Self'     , 13, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     , 14, 'Contacts.LBL_TITLE'                     , 'TITLE'                      , 0, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     , 15, 'Contacts.LBL_DEPARTMENT'                , 'DEPARTMENT'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     , 16, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 0, 1,  50, 35, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsControl   'Contacts.Registration.Self'     , 17, null                                     , 'ACCOUNT_ID'                 , 0, null, 'Hidden', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine 'Contacts.Registration.Self'     , 18, 'Contacts.LBL_PRIMARY_ADDRESS'           , 'PRIMARY_ADDRESS_STREET'     , 0, 1,   2, 37, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'Contacts.Registration.Self'     , 19, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     , 20, 'Contacts.LBL_CITY'                      , 'PRIMARY_ADDRESS_CITY'       , 0, 1, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     , 21, 'Contacts.LBL_STATE'                     , 'PRIMARY_ADDRESS_STATE'      , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     , 22, 'Contacts.LBL_POSTAL_CODE'               , 'PRIMARY_ADDRESS_POSTALCODE' , 0, 1,  20, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'Contacts.Registration.Self'     , 23, 'Contacts.LBL_COUNTRY'                   , 'PRIMARY_ADDRESS_COUNTRY'    , 0, 1, 100, 25, null;
	update EDITVIEWS_FIELDS
	   set FIELD_TYPE        = 'Password'
	     , DATE_MODIFIED_UTC = getutcdate()
	 where EDIT_NAME         = 'Contacts.Registration.Self'
	   and DATA_FIELD        = 'PORTAL_PASSWORD';
	update EDITVIEWS_FIELDS
	   set FIELD_TYPE        = 'Password'
	     , DATE_MODIFIED_UTC = getutcdate()
	 where EDIT_NAME         = 'Contacts.Registration.Self'
	   and DATA_FIELD        = 'PORTAL_PASSWORD_CONFIRM';
end else begin
	-- 10/15/2015 Paul.  Password field needs to be of type Password. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.Registration.Self' and EDIT_NAME = 'Contacts.Registration.Self' and DATA_FIELD = 'PORTAL_PASSWORD' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set FIELD_TYPE        = 'Password'
		     , DATE_MODIFIED_UTC = getutcdate()
		 where EDIT_NAME         = 'Contacts.Registration.Self'
		   and DATA_FIELD        = 'PORTAL_PASSWORD';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.Registration.Self' and EDIT_NAME = 'Contacts.Registration.Self' and DATA_FIELD = 'PORTAL_PASSWORD_CONFIRM' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set FIELD_TYPE        = 'Password'
		     , DATE_MODIFIED_UTC = getutcdate()
		 where EDIT_NAME         = 'Contacts.Registration.Self'
		   and DATA_FIELD        = 'PORTAL_PASSWORD_CONFIRM';
	end -- if;
end -- if;
GO

-- 07/28/2021 Paul.  React client needs portal layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.PortalView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.PortalView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.PortalView';
	exec dbo.spEDITVIEWS_InsertOnly            'Contacts.PortalView', 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.PortalView',  0, 'Contacts.LBL_PORTAL_NAME'            , 'PORTAL_NAME'                , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Contacts.PortalView',  1, 'Contacts.LBL_PORTAL_ACTIVE'          , 'PORTAL_ACTIVE'              , 0, 1, null, 0, null;
	exec dbo.spEDITVIEWS_FIELDS_InsPassword    'Contacts.PortalView',  2, 'Contacts.LBL_PORTAL_PASSWORD'        , 'PORTAL_PASSWORD'            , 0, 1, 32, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsPassword    'Contacts.PortalView',  3, 'Contacts.LBL_CONFIRM_PORTAL_PASSWORD', 'PORTAL_PASSWORD_CONFIRM'    , 0, 2, 32, 35, null;
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

call dbo.spEDITVIEWS_FIELDS_EditViewPortal()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_EditViewPortal')
/

-- #endif IBM_DB2 */




print 'EDITVIEWS_FIELDS Cloud Services';

set nocount on;
GO

-- 03/19/2020 Paul.  Move header to layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.iCloud';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.iCloud' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.EditView.iCloud';
	exec dbo.spEDITVIEWS_InsertOnly            'Contacts.EditView.iCloud', 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Contacts.EditView.iCloud',  0, 'Contacts.LBL_CONTACT_INFORMATION', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud',  1, 'Contacts.LBL_NAME'                      , 'NAME'                       , 1, 1,  25, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud',  2, 'Contacts.LBL_OFFICE_PHONE'              , 'PHONE_WORK'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud',  3, 'Contacts.LBL_MOBILE_PHONE'              , 'PHONE_MOBILE'               , 0, 1,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud',  4, 'Contacts.LBL_HOME_PHONE'                , 'PHONE_HOME'                 , 0, 2,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contacts.EditView.iCloud',  5, 'Contacts.LBL_LEAD_SOURCE'               , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud',  6, 'Contacts.LBL_OTHER_PHONE'               , 'PHONE_OTHER'                , 0, 2,  25, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud',  7, 'Contacts.LBL_TITLE'                     , 'TITLE'                      , 0, 1,  40, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud',  8, 'Contacts.LBL_FAX_PHONE'                 , 'PHONE_FAX'                  , 0, 2,  25, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud',  9, 'Contacts.LBL_DEPARTMENT'                , 'DEPARTMENT'                 , 0, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud', 10, 'Contacts.LBL_EMAIL_ADDRESS'             , 'EMAIL1'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contacts.EditView.iCloud', 11, 'Contacts.LBL_BIRTHDATE'                 , 'BIRTHDATE'                  , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud', 12, 'Contacts.LBL_OTHER_EMAIL_ADDRESS'       , 'EMAIL2'                     , 0, 2, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud', 13, 'Contacts.LBL_ASSISTANT'                 , 'ASSISTANT'                  , 0, 2,  75, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.iCloud', 14, 'Contacts.LBL_ASSISTANT_PHONE'           , 'ASSISTANT_PHONE'            , 0, 2,  25, 25, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.iCloud', 15, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
--	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contacts.EditView.iCloud', 16, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 03/19/2020 Paul.  The FIELD_INDEX is not needed, so remove from update statement. 
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Contacts.EditView.iCloud', -1, 'Email Address'                          , 'EMAIL1'                     , '.ERR_INVALID_EMAIL_ADDRESS';
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'Contacts.EditView.iCloud', -1, 'Email Address'                          , 'EMAIL2'                     , '.ERR_INVALID_EMAIL_ADDRESS';
end else begin
	-- 03/19/2020 Paul.  Move header to layout. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.iCloud' and DATA_LABEL = 'Contacts.LBL_CONTACT_INFORMATION' and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS Contacts.EditView.iCloud: Add header.';
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Contacts.EditView.iCloud'
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Contacts.EditView.iCloud'       ,  0, 'Contacts.LBL_CONTACT_INFORMATION', 3;
	end -- if;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Meetings.EditView.iCloud';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Meetings.EditView.iCloud' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Meetings.EditView.iCloud';
	exec dbo.spEDITVIEWS_InsertOnly            'Meetings.EditView.iCloud', 'Meetings', 'vwMEETINGS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Meetings.EditView.iCloud',  0, 'Meetings.LBL_SUBJECT'                   , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Meetings.EditView.iCloud',  1, 'Meetings.LBL_STATUS'                    , 'STATUS'                     , 1, 2, 'meeting_status_dom' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Meetings.EditView.iCloud',  2, 'Meetings.LBL_LOCATION'                  , 'LOCATION'                   , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Meetings.EditView.iCloud',  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Meetings.EditView.iCloud',  4, 'Meetings.LBL_DATE_TIME'                 , 'DATE_TIME'                  , 1, 1, 'DateTimePicker'     , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Meetings.EditView.iCloud',  5, 'Meetings.LBL_DURATION'                  , 'DURATION_HOURS'             , 1, 2,   2,  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Meetings.EditView.iCloud',  6, null                                     , 'DURATION_MINUTES'           , 1, 2,   2,  2, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Meetings.EditView.iCloud',  7, 'Meetings.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 3,   8,120, 3;
--	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Meetings.EditView.iCloud',  7, 'Meetings.LBL_REMINDER'                  , 'SHOULD_REMIND'              , 0, 1, 'CheckBox'           , 'toggleDisplay(''REMINDER_TIME'');', null, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Meetings.EditView.iCloud',  5, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
--	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Meetings.EditView.iCloud',  3, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
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

call dbo.spEDITVIEWS_FIELDS_Cloud()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_Cloud')
/

-- #endif IBM_DB2 */



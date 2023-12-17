

print 'EDITVIEWS_FIELDS MailChimp';

set nocount on;
GO

-- 04/08/2016 Paul.  Add MailChimp layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'EmailTemplates.EditView.MailChimp';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'EmailTemplates.EditView.MailChimp' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS EmailTemplates.EditView.MailChimp';
	exec dbo.spEDITVIEWS_InsertOnly            'EmailTemplates.EditView.MailChimp', 'EmailTemplates', 'vwMEETINGS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'EmailTemplates.EditView.MailChimp',  0, 'EmailTemplates.LBL_NAME'            , 'name'                       , 1, 1, 255,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'EmailTemplates.EditView.MailChimp',  1, 'MailChimp.LBL_FOLDER_ID'            , 'folder_id'                  , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'EmailTemplates.EditView.MailChimp',  2, 'EmailTemplates.LBL_BODY'            , 'html'                       , 1, 1,  10, 120, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ProspectLists.EditView.MailChimp';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProspectLists.EditView.MailChimp' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProspectLists.EditView.MailChimp';
	exec dbo.spEDITVIEWS_InsertOnly            'ProspectLists.EditView.MailChimp', 'ProspectLists', 'vwPROSPECT_LISTS_List', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' ,  0, 'MailChimp.LBL_NAME'                 , 'name'                       , 1, 1, 255,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProspectLists.EditView.MailChimp' ,  1, 'MailChimp.LBL_VISIBILITY'           , 'visibility'                 , 1, 2, 'mailchimp_visibility' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' ,  2, 'MailChimp.LBL_NOTIFY_ON_SUBSCRIBE'  , 'notify_on_subscribe'        , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' ,  3, 'MailChimp.LBL_NOTIFY_ON_UNSUBSCRIBE', 'notify_on_unsubscribe'      , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProspectLists.EditView.MailChimp' ,  4, 'MailChimp.LBL_EMAIL_TYPE_OPTION'    , 'email_type_option'          , 0, 1, 'CheckBox', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProspectLists.EditView.MailChimp' ,  5, 'MailChimp.LBL_USE_ARCHIVE_BAR'      , 'use_archive_bar'            , 0, 1, 'CheckBox', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'ProspectLists.EditView.MailChimp' ,  6, 'MailChimp.LBL_PERMISSION_REMINDER'  , 'permission_reminder'        , 1, 1,  10, 120, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'ProspectLists.EditView.MailChimp' ,  7;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'ProspectLists.EditView.MailChimp' ,  8, 'MailChimp.LBL_CONTACT_INFORMATION'  , 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' ,  9, 'MailChimp.LBL_COMPANY'              , 'company'                    , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 10, 'MailChimp.LBL_PHONE'                , 'phone'                      , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 11, 'MailChimp.LBL_ADDRESS1'             , 'address1'                   , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 12, 'MailChimp.LBL_ADDRESS2'             , 'address2'                   , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 13, 'MailChimp.LBL_CITY'                 , 'city'                       , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 14, 'MailChimp.LBL_STATE'                , 'state'                      , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 15, 'MailChimp.LBL_ZIP'                  , 'zip'                        , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 16, 'MailChimp.LBL_COUNTRY'              , 'country'                    , 0, 1, 100,  10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'ProspectLists.EditView.MailChimp' , 17;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'ProspectLists.EditView.MailChimp' , 18, 'MailChimp.LBL_CAMPAIGN_INFORMATION' , 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 19, 'MailChimp.LBL_FROM_NAME'            , 'from_name'                  , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 20, 'MailChimp.LBL_SUBJECT'              , 'subject'                    , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 21, 'MailChimp.LBL_FROM_EMAIL'           , 'from_email'                 , 0, 1, 100,  50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProspectLists.EditView.MailChimp' , 22, 'MailChimp.LBL_LANGUAGE'             , 'language'                   , 0, 1, 100,  10, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'MailChimp.ConfigView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'MailChimp.ConfigView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS MailChimp.ConfigView';
	exec dbo.spEDITVIEWS_InsertOnly            'MailChimp.ConfigView', 'MailChimp', 'vwCONFIG_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'MailChimp.ConfigView'       ,  0, 'MailChimp.LBL_MAILCHIMP_ENABLED'        , 'MailChimp.Enabled'               , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'MailChimp.ConfigView'       ,  1, 'MailChimp.LBL_VERBOSE_STATUS'           , 'MailChimp.VerboseStatus'         , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'MailChimp.ConfigView'       ,  2, 'MailChimp.LBL_OAUTH_CLIENT_ID'          , 'MailChimp.ClientID'              , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'MailChimp.ConfigView'       ,  3, 'MailChimp.LBL_OAUTH_ACCESS_TOKEN'       , 'MailChimp.OAuthAccessToken'      , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'MailChimp.ConfigView'       ,  4, 'MailChimp.LBL_OAUTH_CLIENT_SECRET'      , 'MailChimp.ClientSecret'          , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'MailChimp.ConfigView'       ,  5, 'MailChimp.LBL_OAUTH_DATA_CENTER'        , 'MailChimp.DataCenter'            , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'MailChimp.ConfigView'       ,  6, 'MailChimp.LBL_DIRECTION'                , 'MailChimp.Direction'             , 1, 1, 'mailchimp_sync_direction' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'MailChimp.ConfigView'       ,  7, 'MailChimp.LBL_CONFLICT_RESOLUTION'      , 'MailChimp.ConflictResolution'    , 0, 1, 'sync_conflict_resolution' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'MailChimp.ConfigView'       ,  8, 'MailChimp.LBL_SYNC_MODULES'             , 'MailChimp.SyncModules'           , 1, 1, 'mailchimp_sync_module'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'MailChimp.ConfigView'       ,  9, 'MailChimp.LBL_MERGE_FIELDS'             , 'MailChimp.MergeFields'           , 0, 1,   4, 50, null;
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

call dbo.spEDITVIEWS_FIELDS_MailChimp()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_MailChimp')
/

-- #endif IBM_DB2 */



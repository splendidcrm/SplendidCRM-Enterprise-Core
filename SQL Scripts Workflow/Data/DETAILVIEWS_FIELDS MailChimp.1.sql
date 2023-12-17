

print 'DETAILVIEWS_FIELDS MailChimp';

set nocount on;
GO

-- 04/08/2016 Paul.  Add MailChimp layout. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'EmailTemplates.DetailView.MailChimp';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'EmailTemplates.DetailView.MailChimp' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS EmailTemplates.DetailView.MailChimp';
	exec dbo.spDETAILVIEWS_InsertOnly           'EmailTemplates.DetailView.MailChimp', 'EmailTemplates', 'vwEMAIL_TEMPLATES_MailChimp', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.MailChimp',   0, '.LBL_ID'                       , 'id'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.MailChimp',   1, '.LBL_DATE_ENTERED'             , 'date_created'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.MailChimp',   2, 'EmailTemplates.LBL_NAME'       , 'name'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.MailChimp',   3, 'MailChimp.LBL_TYPE'            , 'type'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.MailChimp',   4, 'MailChimp.LBL_CATEGORY'        , 'category'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.MailChimp',   5, 'MailChimp.LBL_FOLDER_ID'       , 'folder_id'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.MailChimp',   6, 'EmailTemplates.LBL_BODY'       , 'html'                       , '{0}', 3;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProspectLists.DetailView.MailChimp';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProspectLists.DetailView.MailChimp' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ProspectLists.DetailView.MailChimp';
	exec dbo.spDETAILVIEWS_InsertOnly           'ProspectLists.DetailView.MailChimp', 'ProspectLists', 'vwPROSPECT_LISTS_MailChimp', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,   0, '.LBL_ID'                                   , 'id'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,   1, '.LBL_DATE_ENTERED'                         , 'date_created'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,   2, 'MailChimp.LBL_NAME'                        , 'name'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'ProspectLists.DetailView.MailChimp'  ,  3, 'MailChimp.LBL_VISIBILITY'                  , 'visibility'                  , '{0}', 'mailchimp_visibility', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,   4, 'MailChimp.LBL_NOTIFY_ON_SUBSCRIBE'         , 'notify_on_subscribe'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,   5, 'MailChimp.LBL_NOTIFY_ON_UNSUBSCRIBE'       , 'notify_on_unsubscribe'       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,   6, 'MailChimp.LBL_EMAIL_TYPE_OPTION'           , 'email_type_option'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,   7, 'MailChimp.LBL_USE_ARCHIVE_BAR'             , 'use_archive_bar'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,   8, 'MailChimp.LBL_PERMISSION_REMINDER'         , 'permission_reminder'         , '{0}', 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'ProspectLists.DetailView.MailChimp' ,   9;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'ProspectLists.DetailView.MailChimp' ,  10, 'MailChimp.LBL_CONTACT_INFORMATION'         , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  11, 'MailChimp.LBL_COMPANY'                     , 'company'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  12, 'MailChimp.LBL_PHONE'                       , 'phone'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  13, 'MailChimp.LBL_ADDRESS1'                    , 'address1'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  14, 'MailChimp.LBL_ADDRESS2'                    , 'address2'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  15, 'MailChimp.LBL_CITY'                        , 'city'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  16, 'MailChimp.LBL_STATE'                       , 'state'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  17, 'MailChimp.LBL_ZIP'                         , 'zip'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  18, 'MailChimp.LBL_COUNTRY'                     , 'country'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'ProspectLists.DetailView.MailChimp' ,  19;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'ProspectLists.DetailView.MailChimp' ,  20, 'MailChimp.LBL_CAMPAIGN_INFORMATION'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  21, 'MailChimp.LBL_FROM_NAME'                   , 'from_name'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  22, 'MailChimp.LBL_SUBJECT'                     , 'subject'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  23, 'MailChimp.LBL_FROM_EMAIL'                  , 'from_email'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  24, 'MailChimp.LBL_LANGUAGE'                    , 'language'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'ProspectLists.DetailView.MailChimp' ,  25;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'ProspectLists.DetailView.MailChimp' ,  26, 'MailChimp.LBL_STATISTICAL_INFORMATION'     , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  27, 'MailChimp.LBL_MEMBER_COUNT'                , 'member_count'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  28, 'MailChimp.LBL_UNSUBSCRIBE_COUNT'           , 'unsubscribe_count'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  29, 'MailChimp.LBL_CLEANED_COUNT'               , 'cleaned_count'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  30, 'MailChimp.LBL_MEMBER_COUNT_SINCE_SEND'     , 'member_count_since_send'     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  31, 'MailChimp.LBL_UNSUBSCRIBE_COUNT_SINCE_SEND', 'unsubscribe_count_since_send', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  32, 'MailChimp.LBL_CLEANED_COUNT_SINCE_SEND'    , 'cleaned_count_since_send'    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  33, 'MailChimp.LBL_CAMPAIGN_COUNT'              , 'campaign_count'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  34, 'MailChimp.LBL_CAMPAIGN_LAST_SENT'          , 'campaign_last_sent'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  35, 'MailChimp.LBL_MERGE_FIELD_COUNT'           , 'merge_field_count'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  36, 'MailChimp.LBL_AVG_SUB_RATE'                , 'avg_sub_rate'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  37, 'MailChimp.LBL_AVG_UNSUB_RATE'              , 'avg_unsub_rate'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  38, 'MailChimp.LBL_TARGET_SUB_RATE'             , 'target_sub_rate'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  39, 'MailChimp.LBL_OPEN_RATE'                   , 'open_rate'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  40, 'MailChimp.LBL_CLICK_RATE'                  , 'click_rate'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  41, 'MailChimp.LBL_LAST_SUB_DATE'               , 'last_sub_date'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.MailChimp' ,  42, 'MailChimp.LBL_LAST_UNSUB_DATE'             , 'last_unsub_date'             , '{0}', null;
end -- if;
GO

-- 02/24/2021 Paul.  Add support for React client. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'MailChimp.ConfigView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'MailChimp.ConfigView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS MailChimp.ConfigView';
	exec dbo.spDETAILVIEWS_InsertOnly            'MailChimp.ConfigView', 'MailChimp', 'vwCONFIG_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'MailChimp.ConfigView'       ,  0, 'MailChimp.LBL_MAILCHIMP_ENABLED'        , 'MailChimp.Enabled'               , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'MailChimp.ConfigView'       ,  1, 'MailChimp.LBL_VERBOSE_STATUS'           , 'MailChimp.VerboseStatus'         , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'MailChimp.ConfigView'       ,  2, 'MailChimp.LBL_OAUTH_CLIENT_ID'          , 'MailChimp.ClientID'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'MailChimp.ConfigView'       ,  3, 'MailChimp.LBL_OAUTH_ACCESS_TOKEN'       , 'MailChimp.OAuthAccessToken'      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'MailChimp.ConfigView'       ,  4, 'MailChimp.LBL_OAUTH_CLIENT_SECRET'      , 'MailChimp.ClientSecret'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'MailChimp.ConfigView'       ,  5, 'MailChimp.LBL_OAUTH_DATA_CENTER'        , 'MailChimp.DataCenter'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList   'MailChimp.ConfigView'       ,  6, 'MailChimp.LBL_DIRECTION'                , 'MailChimp.Direction'             , '{0}', 'mailchimp_sync_direction' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList   'MailChimp.ConfigView'       ,  7, 'MailChimp.LBL_CONFLICT_RESOLUTION'      , 'MailChimp.ConflictResolution'    , '{0}', 'sync_conflict_resolution' , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList   'MailChimp.ConfigView'       ,  8, 'MailChimp.LBL_SYNC_MODULES'             , 'MailChimp.SyncModules'           , '{0}', 'mailchimp_sync_module'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'MailChimp.ConfigView'       ,  9, 'MailChimp.LBL_MERGE_FIELDS'             , 'MailChimp.MergeFields'           , '{0}', null;
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

call dbo.spDETAILVIEWS_FIELDS_MailChimp()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_MailChimp')
/

-- #endif IBM_DB2 */


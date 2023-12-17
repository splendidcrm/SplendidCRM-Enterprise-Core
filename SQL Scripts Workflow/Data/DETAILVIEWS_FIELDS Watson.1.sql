

print 'DETAILVIEWS_FIELDS Watson';

set nocount on;
GO

-- 02/24/2021 Paul.  Add support for React client. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Watson.ConfigView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Watson.ConfigView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Watson.ConfigView';
	exec dbo.spDETAILVIEWS_InsertOnly            'Watson.ConfigView', 'Watson', 'vwCONFIG_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'Watson.ConfigView'          ,  0, 'Watson.LBL_WATSON_ENABLED'              , 'Watson.Enabled'                  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox    'Watson.ConfigView'          ,  1, 'Watson.LBL_VERBOSE_STATUS'              , 'Watson.VerboseStatus'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  2, 'Watson.LBL_OAUTH_REGION'                , 'Watson.Region'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank       'Watson.ConfigView'          ,  3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  4, 'Watson.LBL_OAUTH_POD_NUMBER'            , 'Watson.PodNumber'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  5, 'Watson.LBL_OAUTH_REFRESH_TOKEN'         , 'Watson.OAuthRefreshToken'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  6, 'Watson.LBL_OAUTH_CLIENT_ID'             , 'Watson.ClientID'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  7, 'Watson.LBL_OAUTH_ACCESS_TOKEN'          , 'Watson.OAuthAccessToken'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  8, 'Watson.LBL_OAUTH_CLIENT_SECRET'         , 'Watson.ClientSecret'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  9, 'Watson.LBL_OAUTH_EXPIRES_AT'            , 'Watson.OAuthExpiresAt'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList   'Watson.ConfigView'          , 10, 'Watson.LBL_DIRECTION'                   , 'Watson.Direction'                , '{0}', 'watson_sync_direction'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList   'Watson.ConfigView'          , 11, 'Watson.LBL_CONFLICT_RESOLUTION'         , 'Watson.ConflictResolution'       , '{0}', 'sync_conflict_resolution', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList   'Watson.ConfigView'          , 12, 'Watson.LBL_SYNC_MODULES'                , 'Watson.SyncModules'              , '{0}', 'watson_sync_module'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'Watson.ConfigView'          , 13, 'Watson.LBL_MERGE_FIELDS'                , 'Watson.MergeFields'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound       'Watson.ConfigView'          , 14, 'Watson.LBL_DEFAULT_DATABASE'            , 'Watson.DefaultDatabaseName'      , '{0}', null;
end -- if;
GO

-- 01/25/2018 Paul.  Add Watson layout. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'EmailTemplates.DetailView.Watson';
/*
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'EmailTemplates.DetailView.Watson' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS EmailTemplates.DetailView.Watson';
	exec dbo.spDETAILVIEWS_InsertOnly           'EmailTemplates.DetailView.Watson', 'EmailTemplates', 'vwEMAIL_TEMPLATES_Watson', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.Watson',   0, '.LBL_ID'                       , 'id'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.Watson',   1, '.LBL_DATE_ENTERED'             , 'date_created'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.Watson',   2, 'EmailTemplates.LBL_NAME'       , 'name'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.Watson',   3, 'Watson.LBL_TYPE'            , 'type'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.Watson',   4, 'Watson.LBL_CATEGORY'        , 'category'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.Watson',   5, 'Watson.LBL_FOLDER_ID'       , 'folder_id'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'EmailTemplates.DetailView.Watson',   6, 'EmailTemplates.LBL_BODY'       , 'html'                       , '{0}', 3;
end -- if;
*/
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProspectLists.DetailView.Watson';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'ProspectLists.DetailView.Watson' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS ProspectLists.DetailView.Watson';
	exec dbo.spDETAILVIEWS_InsertOnly           'ProspectLists.DetailView.Watson', 'ProspectLists', 'vwPROSPECT_LISTS_Watson', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, '.LBL_ID'                                , 'ID'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, '.LBL_DATE_MODIFIED'                     , 'LAST_MODIFIED'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_NAME'                        , 'NAME'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, '.LBL_DATE_ENTERED'                      , 'CREATED'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_PARENT_DATABASE_ID'          , 'PARENT_DATABASE_ID'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_VISIBILITY'                  , 'VISIBILITY'                  , '{0}', 'watson_visibility', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsSeparator  'ProspectLists.DetailView.Watson',  -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsHeader     'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_LIST_INFORMATION'            , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_TYPE'                        , 'TYPE'                        , '{0}', 'watson_list_type', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_SIZE'                        , 'SIZE'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_NUM_OPT_OUTS'                , 'NUM_OPT_OUTS'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_NUM_UNDELIVERABLE'           , 'NUM_UNDELIVERABLE'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_PARENT_NAME'                 , 'PARENT_NAME'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_ORGANIZATION_ID'             , 'ORGANIZATION_ID'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_USER_ID'                     , 'USER_ID'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_PARENT_FOLDER_ID'            , 'PARENT_FOLDER_ID'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_IS_FOLDER'                   , 'IS_FOLDER'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_FLAGGED_FOR_BACKUP'          , 'FLAGGED_FOR_BACKUP'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_SUPPRESSION_LIST_ID'         , 'SUPPRESSION_LIST_ID'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_OPT_IN_FORM_DEFINED'         , 'OPT_IN_FORM_DEFINED'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_OPT_OUT_FORM_DEFINED'        , 'OPT_OUT_FORM_DEFINED'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_PROFILE_FORM_DEFINED'        , 'PROFILE_FORM_DEFINED'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_OPT_IN_AUTOREPLY_DEFINED'    , 'OPT_IN_AUTOREPLY_DEFINED'    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'ProspectLists.DetailView.Watson',  -1, 'Watson.LBL_PROFILE_AUTOREPLY_DEFINED'   , 'PROFILE_AUTOREPLY_DEFINED'   , '{0}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.Watson';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.Watson' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.Watson';
	exec dbo.spDETAILVIEWS_InsertOnly           'Contacts.DetailView.Watson', 'Contacts', 'vwCONTACTS_Watson', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.Watson',  -1, '.LBL_ID'                        , 'RECIPIENT_ID'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.Watson',  -1, 'Contacts.LBL_EMAIL1'            , 'EMAIL1'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.Watson',  -1, 'Contacts.LBL_FIRST_NAME'        , 'FIRST_NAME'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.Watson',  -1, 'Contacts.LBL_LAST_NAME'         , 'LAST_NAME'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.Watson',  -1, '.LBL_DATE_MODIFIED'             , 'LAST_MODIFIED'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.Watson',  -1, 'Contacts.LBL_LEAD_SOURCE'       , 'CRM_LEAD_SOURCE'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.Watson',  -1, 'Watson.LBL_OPTED_IN_DATE'       , 'OPTED_IN_DATE'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.Watson',  -1, 'Watson.LBL_OPTED_OUT_DATE'      , 'OPTED_OUT_DATE'             , '{0}', null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.Watson';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView.Watson' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Leads.DetailView.Watson';
	exec dbo.spDETAILVIEWS_InsertOnly           'Leads.DetailView.Watson', 'Leads', 'vwLEADS_Watson', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Watson',  -1, '.LBL_ID'                        , 'RECIPIENT_ID'               , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Watson',  -1, 'Leads.LBL_EMAIL1'               , 'EMAIL1'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Watson',  -1, 'Leads.LBL_FIRST_NAME'           , 'FIRST_NAME'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Watson',  -1, 'Leads.LBL_LAST_NAME'            , 'LAST_NAME'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Watson',  -1, '.LBL_DATE_MODIFIED'             , 'LAST_MODIFIED'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Watson',  -1, 'Leads.LBL_LEAD_SOURCE'          , 'CRM_LEAD_SOURCE'            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Watson',  -1, 'Watson.LBL_OPTED_IN_DATE'       , 'OPTED_IN_DATE'              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Leads.DetailView.Watson',  -1, 'Watson.LBL_OPTED_OUT_DATE'      , 'OPTED_OUT_DATE'             , '{0}', null;
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

call dbo.spDETAILVIEWS_FIELDS_Watson()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_Watson')
/

-- #endif IBM_DB2 */


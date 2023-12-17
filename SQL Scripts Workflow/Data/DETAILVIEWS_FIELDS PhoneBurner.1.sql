

print 'DETAILVIEWS_FIELDS PhoneBurner';

set nocount on;
GO

-- 02/24/2021 Paul.  Add support for React client. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PhoneBurner.ConfigView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'PhoneBurner.ConfigView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS PhoneBurner.ConfigView';
	exec dbo.spDETAILVIEWS_InsertOnly           'PhoneBurner.ConfigView', 'PhoneBurner', 'vwCONFIG_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox   'PhoneBurner.ConfigView'         ,  0, 'PhoneBurner.LBL_PHONEBURNER_ENABLED'        , 'PhoneBurner.Enabled'                  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox   'PhoneBurner.ConfigView'         ,  1, 'PhoneBurner.LBL_VERBOSE_STATUS'             , 'PhoneBurner.VerboseStatus'            , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'PhoneBurner.ConfigView'         ,  2, 'PhoneBurner.LBL_OAUTH_CLIENT_ID'            , 'PhoneBurner.ClientID'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'PhoneBurner.ConfigView'         ,  3, 'PhoneBurner.LBL_OAUTH_ACCESS_TOKEN'         , 'PhoneBurner.OAuthAccessToken'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'PhoneBurner.ConfigView'         ,  4, 'PhoneBurner.LBL_OAUTH_CLIENT_SECRET'        , 'PhoneBurner.ClientSecret'             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'PhoneBurner.ConfigView'         ,  5, 'PhoneBurner.LBL_OAUTH_REFRESH_TOKEN'        , 'PhoneBurner.OAuthRefreshToken'        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'PhoneBurner.ConfigView'         ,  6, 'PhoneBurner.LBL_DIRECTION'                  , 'PhoneBurner.Direction'                , '{0}', 'phoneburner_sync_direction', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'PhoneBurner.ConfigView'         ,  7, 'PhoneBurner.LBL_OAUTH_EXPIRES_AT'           , 'PhoneBurner.OAuthExpiresAt'           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'PhoneBurner.ConfigView'         ,  8, 'PhoneBurner.LBL_SYNC_MODULES'               , 'PhoneBurner.SyncModules'              , '{0}', 'phoneburner_sync_module'   , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'PhoneBurner.ConfigView'         ,  9, 'PhoneBurner.LBL_CONFLICT_RESOLUTION'        , 'PhoneBurner.ConflictResolution'       , '{0}', 'sync_conflict_resolution'  , null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.PhoneBurner';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.PhoneBurner' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.PhoneBurner';
	exec dbo.spDETAILVIEWS_InsertOnly           'Contacts.DetailView.PhoneBurner', 'Contacts', 'vwCONTACTS_PhoneBurner', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, '.LBL_ID'                            , 'id'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, 'PhoneBurner.LBL_CATEGORY'           , 'category_id'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, 'Contacts.LBL_FIRST_NAME'            , 'first_name'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, 'Contacts.LBL_LAST_NAME'             , 'last_name'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, 'Contacts.LBL_EMAIL1'                , 'email'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, 'Contacts.LBL_PHONE_WORK'            , 'phone'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, 'Contacts.LBL_PRIMARY_ADDRESS_STREET', 'address1'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, 'Contacts.LBL_PRIMARY_ADDRESS_CITY'  , 'city'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, 'Contacts.LBL_PRIMARY_ADDRESS_STATE' , 'state'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      'Contacts.DetailView.PhoneBurner',  -1, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, '.LBL_DATE_ENTERED'                  , 'date_added'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Contacts.DetailView.PhoneBurner',  -1, '.LBL_DATE_MODIFIED'                 , 'date_modified'              , '{0}', null;
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

call dbo.spDETAILVIEWS_FIELDS_PhoneBurner()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_PhoneBurner')
/

-- #endif IBM_DB2 */


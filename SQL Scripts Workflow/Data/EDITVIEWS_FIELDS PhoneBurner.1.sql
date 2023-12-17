

print 'EDITVIEWS_FIELDS MailChimp';

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'PhoneBurner.ConfigView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'PhoneBurner.ConfigView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS PhoneBurner.ConfigView';
	exec dbo.spEDITVIEWS_InsertOnly            'PhoneBurner.ConfigView', 'PhoneBurner', 'vwCONFIG_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'PhoneBurner.ConfigView'         ,  0, 'PhoneBurner.LBL_PHONEBURNER_ENABLED'        , 'PhoneBurner.Enabled'                  , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'PhoneBurner.ConfigView'         ,  1, 'PhoneBurner.LBL_VERBOSE_STATUS'             , 'PhoneBurner.VerboseStatus'            , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PhoneBurner.ConfigView'         ,  2, 'PhoneBurner.LBL_OAUTH_CLIENT_ID'            , 'PhoneBurner.ClientID'                 , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PhoneBurner.ConfigView'         ,  3, 'PhoneBurner.LBL_OAUTH_ACCESS_TOKEN'         , 'PhoneBurner.OAuthAccessToken'         , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PhoneBurner.ConfigView'         ,  4, 'PhoneBurner.LBL_OAUTH_CLIENT_SECRET'        , 'PhoneBurner.ClientSecret'             , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PhoneBurner.ConfigView'         ,  5, 'PhoneBurner.LBL_OAUTH_REFRESH_TOKEN'        , 'PhoneBurner.OAuthRefreshToken'        , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'PhoneBurner.ConfigView'         ,  6, 'PhoneBurner.LBL_DIRECTION'                  , 'PhoneBurner.Direction'                , 1, 1, 'phoneburner_sync_direction', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PhoneBurner.ConfigView'         ,  7, 'PhoneBurner.LBL_OAUTH_EXPIRES_AT'           , 'PhoneBurner.OAuthExpiresAt'           , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'PhoneBurner.ConfigView'         ,  8, 'PhoneBurner.LBL_SYNC_MODULES'               , 'PhoneBurner.SyncModules'              , 1, 1, 'phoneburner_sync_module'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'PhoneBurner.ConfigView'         ,  9, 'PhoneBurner.LBL_CONFLICT_RESOLUTION'        , 'PhoneBurner.ConflictResolution'       , 0, 1, 'sync_conflict_resolution'  , null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.PhoneBurner';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contacts.EditView.PhoneBurner' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contacts.EditView.PhoneBurner';
	exec dbo.spEditViewS_InsertOnly            'Contacts.EditView.PhoneBurner', 'Contacts', 'vwCONTACTS_PhoneBurner', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Contacts.EditView.PhoneBurner'  ,  -1, '.LBL_ID'                                   , 'id'                                   , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'PhoneBurner.LBL_CATEGORY'                  , 'category_id'                          , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_FIRST_NAME'                   , 'first_name'                           , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_LAST_NAME'                    , 'last_name'                            , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_EMAIL1'                       , 'email'                                , 1, 1, 100,  60, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_PHONE'                        , 'phone'                                , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_PRIMARY_ADDRESS_STREET'       , 'address1'                             , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_PRIMARY_ADDRESS_STREET2'      , 'address2'                             , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_PRIMARY_ADDRESS_CITY'         , 'city'                                 , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_PRIMARY_ADDRESS_STATE'        , 'state'                                , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_PRIMARY_ADDRESS_POSTALCODE'   , 'zip'                                  , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_PRIMARY_ADDRESS_COUNTRY'      , 'country'                              , 0, 1, 100,  35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contacts.EditView.PhoneBurner'  ,  -1, 'Contacts.LBL_DESCRIPTION'                  , 'notes'                                , 0, 5,   4, 120, 3;
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



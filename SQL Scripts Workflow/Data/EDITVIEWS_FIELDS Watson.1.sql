

print 'EDITVIEWS_FIELDS Watson';
GO

set nocount on;
GO

-- 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
-- https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Watson.ConfigView' and DATA_FIELD = 'Watson.Region' and DELETED = 0) begin -- then
	update EDITVIEWS_FIELDS
	   set DELETED           = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where EDIT_NAME         = 'Watson.ConfigView'
	   and DELETED           = 0;
end -- if;

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Watson.ConfigView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Watson.ConfigView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Watson.ConfigView';
	exec dbo.spEDITVIEWS_InsertOnly            'Watson.ConfigView', 'Watson', 'vwCONFIG_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Watson.ConfigView'          ,  0, 'Watson.LBL_WATSON_ENABLED'              , 'Watson.Enabled'                  , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Watson.ConfigView'          ,  1, 'Watson.LBL_VERBOSE_STATUS'              , 'Watson.VerboseStatus'            , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  2, 'Watson.LBL_OAUTH_REGION'                , 'Watson.Region'                   , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Watson.ConfigView'          ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  4, 'Watson.LBL_OAUTH_POD_NUMBER'            , 'Watson.PodNumber'                , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  5, 'Watson.LBL_OAUTH_REFRESH_TOKEN'         , 'Watson.OAuthRefreshToken'        , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  6, 'Watson.LBL_OAUTH_CLIENT_ID'             , 'Watson.ClientID'                 , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  7, 'Watson.LBL_OAUTH_ACCESS_TOKEN'          , 'Watson.OAuthAccessToken'         , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  8, 'Watson.LBL_OAUTH_CLIENT_SECRET'         , 'Watson.ClientSecret'             , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Watson.ConfigView'          ,  9, 'Watson.LBL_OAUTH_EXPIRES_AT'            , 'Watson.OAuthExpiresAt'           , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Watson.ConfigView'          , 10, 'Watson.LBL_DIRECTION'                   , 'Watson.Direction'                , 1, 1, 'watson_sync_direction'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Watson.ConfigView'          , 11, 'Watson.LBL_CONFLICT_RESOLUTION'         , 'Watson.ConflictResolution'       , 0, 1, 'sync_conflict_resolution', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Watson.ConfigView'          , 12, 'Watson.LBL_SYNC_MODULES'                , 'Watson.SyncModules'              , 1, 1, 'watson_sync_module'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Watson.ConfigView'          , 13, 'Watson.LBL_MERGE_FIELDS'                , 'Watson.MergeFields'              , 0, 1,   4, 50, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Watson.ConfigView'          , 14, 'Watson.LBL_DEFAULT_DATABASE'            , 'Watson.DefaultDatabaseName'      , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsButton      'Watson.ConfigView'          , 15, null                                     , '.LBL_SELECT_BUTTON_LABEL'        , 'SelectDatabase', -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Watson.ConfigView'          , 16, null;
	exec dbo.spEDITVIEWS_FIELDS_InsHidden      'Watson.ConfigView'          , 17, 'Watson.DefaultDatabaseID';
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

call dbo.spEDITVIEWS_FIELDS_Watson()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_Watson')
/

-- #endif IBM_DB2 */


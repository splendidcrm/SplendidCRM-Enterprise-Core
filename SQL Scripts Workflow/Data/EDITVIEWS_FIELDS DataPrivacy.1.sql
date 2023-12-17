

print 'EDITVIEWS_FIELDS DataPrivacy';
GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'DataPrivacy.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'DataPrivacy.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS DataPrivacy.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'DataPrivacy.EditView'   , 'DataPrivacy', 'vwDATA_PRIVACY_Edit', '15%', '35%';
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'DataPrivacy.EditView'   ,  0, 'DataPrivacy.LBL_NAME'                   , 'NAME'                       , 1, 1, 255, 35, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'DataPrivacy.EditView'   ,  1, 'DataPrivacy.LBL_DATA_PRIVACY_NUMBER'    , 'DATA_PRIVACY_NUMBER'        , null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'DataPrivacy.EditView'   ,  2, 'DataPrivacy.LBL_STATUS'                 , 'STATUS'                     , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.EditView'   ,  3, 'DataPrivacy.LBL_TYPE'                   , 'TYPE'                       , 1, 1, 'dataprivacy_type_dom'    , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.EditView'   ,  4, 'DataPrivacy.LBL_PRIORITY'               , 'PRIORITY'                   , 0, 1, 'dataprivacy_priority_dom', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.EditView'   ,  5, 'DataPrivacy.LBL_SOURCE'                 , 'SOURCE'                     , 0, 1, 'dataprivacy_source_dom'  , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'DataPrivacy.EditView'   ,  6, 'DataPrivacy.LBL_REQUESTED_BY'           , 'REQUESTED_BY'               , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'DataPrivacy.EditView'   ,  7, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 1, 1, 'ASSIGNED_TO_NAME'        , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsDatePick    'DataPrivacy.EditView'   ,  8, 'DataPrivacy.LBL_DATE_DUE'               , 'DATE_DUE'                   , 0, 1, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'DataPrivacy.EditView'   ,  9, 'DataPrivacy.LBL_DATE_OPENED'            , 'DATE_OPENED'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'DataPrivacy.EditView'   , 10, 'DataPrivacy.LBL_DATE_CLOSED'            , 'DATE_CLOSED'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'DataPrivacy.EditView'   , 11, 'DataPrivacy.LBL_DESCRIPTION'            , 'DESCRIPTION'                , 0, 1,   4, 120, 4;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'DataPrivacy.EditView'   , 12, 'DataPrivacy.LBL_RESOLUTION'             , 'RESOLUTION'                 , 0, 1,   4, 120, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'DataPrivacy.EditView'   , 13, 'DataPrivacy.LBL_WORK_LOG'               , 'WORK_LOG'                   , 0, 1,   4, 120, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'DataPrivacy.EditView'   , 14, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 1, 1, 'TEAM_NAME'               , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'DataPrivacy.EditView'   , 15, 2, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.EditView'   , 16, 'DataPrivacy.LBL_BUSINESS_PURPOSE'       , 'BUSINESS_PURPOSE'           , 0, 1, 'business_purpose_dom'    , null, 4, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.EditView'   , 17, 'DataPrivacy.LBL_FIELDS_TO_ERASE'        , 'FIELDS_TO_ERASE'            , 0, 1, 'DataPrivacyFields'       , null, 4, 'csv';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'DataPrivacy.EditView', 'DATE_OPENED', '{0:d}';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'DataPrivacy.EditView', 'DATE_CLOSED', '{0:d}';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'DataPrivacy.EditView', 'DATE_DUE'   , '{0:d}';
	exec dbo.spEDITVIEWS_FIELDS_UpdateCacheName  null, 'DataPrivacy.EditView', 'STATUS'     , 'dataprivacy_status_dom';
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'DataPrivacy.EditView.Inline';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'DataPrivacy.EditView.Inline' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS DataPrivacy.EditView.Inline';
	exec dbo.spEDITVIEWS_InsertOnly            'DataPrivacy.EditView.Inline'   , 'DataPrivacy', 'vwDATA_PRIVACY_Edit', '15%', '35%';
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'DataPrivacy.EditView.Inline'   ,  0, 'DataPrivacy.LBL_NAME'                   , 'NAME'                       , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.EditView.Inline'   ,  1, 'DataPrivacy.LBL_TYPE'                   , 'TYPE'                       , 1, 1, 'dataprivacy_type_dom'    , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.EditView.Inline'   ,  2, 'DataPrivacy.LBL_PRIORITY'               , 'PRIORITY'                   , 0, 1, 'dataprivacy_priority_dom', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.EditView.Inline'   ,  3, 'DataPrivacy.LBL_SOURCE'                 , 'SOURCE'                     , 0, 1, 'dataprivacy_source_dom'  , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'DataPrivacy.EditView.Inline'   ,  4, 'DataPrivacy.LBL_REQUESTED_BY'           , 'REQUESTED_BY'               , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.EditView.Inline'   ,  5, 'DataPrivacy.LBL_BUSINESS_PURPOSE'       , 'BUSINESS_PURPOSE'           , 0, 1, 'business_purpose_dom'    , null, 4, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'DataPrivacy.EditView.Inline'   ,  6, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 1, 1, 'ASSIGNED_TO_NAME'        , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'DataPrivacy.EditView.Inline'   ,  7, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 1, 1, 'TEAM_NAME'               , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'DataPrivacy.EditView.Inline'   ,  8, 'DataPrivacy.LBL_DESCRIPTION'            , 'DESCRIPTION'                , 0, 2,   2, 120, 3;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'DataPrivacy.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'DataPrivacy.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS DataPrivacy.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly            'DataPrivacy.SearchBasic', 'DataPrivacy', 'vwBUSINESS_PROCESSES', '11%', '22%', 3
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'DataPrivacy.SearchBasic',  0, 'DataPrivacy.LBL_NAME'                   , 'NAME'                       , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.SearchBasic',  1, 'DataPrivacy.LBL_TYPE'                   , 'TYPE'                       , 0, null, 'dataprivacy_type_dom'    , null, 3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'DataPrivacy.SearchBasic',  2, 'DataPrivacy.LBL_STATUS'                 , 'STATUS'                     , 0, null, 'dataprivacy_status_dom'  , null, 3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'DataPrivacy.SearchBasic',  3, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'DataPrivacy.SearchBasic',  4, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsDateRng     'DataPrivacy.SearchBasic',  5, 'DataPrivacy.LBL_DATE_DUE'               , 'DATE_DUE'                   , 0, null, null, null;
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

call dbo.spEDITVIEWS_FIELDS_DataPrivacy()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_DataPrivacy')
/

-- #endif IBM_DB2 */


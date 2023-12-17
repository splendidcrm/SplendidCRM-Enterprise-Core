

print 'DETAILVIEWS_FIELDS DataPrivacy';
GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'DataPrivacy.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'DataPrivacy.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS DataPrivacy.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly           'DataPrivacy.DetailView', 'DataPrivacy', 'vwDATA_PRIVACY_Edit', '15%', '35%';
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView',  0, 'DataPrivacy.LBL_NAME'                   , 'NAME'                                  , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView',  1, 'DataPrivacy.LBL_DATA_PRIVACY_NUMBER'    , 'DATA_PRIVACY_NUMBER'                   , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'DataPrivacy.DetailView',  2, 'DataPrivacy.LBL_STATUS'                 , 'STATUS'                                , '{0}'        , 'dataprivacy_status_dom'  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'DataPrivacy.DetailView',  3, 'DataPrivacy.LBL_TYPE'                   , 'TYPE'                                  , '{0}'        , 'dataprivacy_type_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'DataPrivacy.DetailView',  4, 'DataPrivacy.LBL_PRIORITY'               , 'PRIORITY'                              , '{0}'        , 'dataprivacy_priority_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'DataPrivacy.DetailView',  5, 'DataPrivacy.LBL_SOURCE'                 , 'SOURCE'                                , '{0}'        , 'dataprivacy_source_dom'  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView',  6, 'DataPrivacy.LBL_REQUESTED_BY'           , 'REQUESTED_BY'                          , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView',  7, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_TO_NAME'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView',  8, 'DataPrivacy.LBL_DATE_DUE'               , 'DATE_DUE'                              , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView',  9, 'DataPrivacy.LBL_DATE_OPENED'            , 'DATE_OPENED'                           , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView', 10, 'DataPrivacy.LBL_DATE_CLOSED'            , 'DATE_CLOSED'                           , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly    'DataPrivacy.DetailView', 11, 'TextBox', 'DataPrivacy.LBL_DESCRIPTION' , 'DESCRIPTION', null, null, null, null, null, 3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly    'DataPrivacy.DetailView', 12, 'TextBox', 'DataPrivacy.LBL_WORK_LOG'    , 'WORK_LOG'   , null, null, null, null, null, 3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly    'DataPrivacy.DetailView', 13, 'TextBox', 'DataPrivacy.LBL_RESOLUTION'  , 'RESOLUTION' , null, null, null, null, null, 3, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView', 14, 'Teams.LBL_TEAM'                         , 'TEAM_NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsTags       'DataPrivacy.DetailView', 15, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView', 16, '.LBL_DATE_ENTERED'                      , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'DataPrivacy.DetailView', 17, '.LBL_DATE_MODIFIED'                     , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'DataPrivacy.DetailView', 10, 'DataPrivacy.LBL_BUSINESS_PURPOSE'       , 'BUSINESS_PURPOSE'                      , '{0}'        , 'business_purpose_dom'    , null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'DataPrivacy.DetailView', 11, 'DataPrivacy.LBL_FIELDS_TO_ERASE'        , 'FIELDS_TO_ERASE'                       , 'csv'        , 'DataPrivacyFields'       , null;
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

call dbo.spDETAILVIEWS_FIELDS_DataPrivacy()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_DataPrivacy')
/

-- #endif IBM_DB2 */




print 'DETAILVIEWS_FIELDS Avaya';
GO

set nocount on;
GO

-- 12/03/2013 Paul.  Add layout for Avaya. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Avaya.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Avaya.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Avaya.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly          'Avaya.DetailView', 'Avaya', 'vwCALL_DETAIL_RECORDS', '20%', '30%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        ,  0, 'Avaya.LBL_UNIQUEID'                        , 'UNIQUEID'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        ,  1, 'Avaya.LBL_START_TIME'                      , 'START_TIME'                            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Avaya.DetailView'        ,  2, 'Avaya.LBL_PARENT_NAME'                     , 'PARENT_NAME'                           , '{0}', 'PARENT_ID', '~/Calls/view.aspx?ID={0}', null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        ,  3, 'Avaya.LBL_ANSWER_TIME'                     , 'ANSWER_TIME'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        ,  4, 'Avaya.LBL_DURATION'                        , 'DURATION'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        ,  5, 'Avaya.LBL_END_TIME'                        , 'END_TIME'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        ,  6, 'Avaya.LBL_BILLABLE_SECONDS'                , 'BILLABLE_SECONDS'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Avaya.DetailView'        ,  7, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        ,  8, 'Avaya.LBL_CALLERID'                        , 'CALLERID'                              , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        ,  9, 'Avaya.LBL_DESTINATION'                     , 'DESTINATION'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        , 10, 'Avaya.LBL_SOURCE'                          , 'SOURCE'                                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        , 11, 'Avaya.LBL_DESTINATION_CONTEXT'             , 'DESTINATION_CONTEXT'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        , 12, 'Avaya.LBL_SOURCE_CHANNEL'                  , 'SOURCE_CHANNEL'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        , 13, 'Avaya.LBL_DESTINATION_CHANNEL'             , 'DESTINATION_CHANNEL'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        , 14, 'Avaya.LBL_DISPOSITION'                     , 'DISPOSITION'                           , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        , 15, 'Avaya.LBL_AMA_FLAGS'                       , 'AMA_FLAGS'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        , 16, 'Avaya.LBL_LAST_APPLICATION'                , 'LAST_APPLICATION'                      , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        , 17, 'Avaya.LBL_USER_FIELD'                      , 'USER_FIELD'                            , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Avaya.DetailView'        , 18, 'Avaya.LBL_LAST_DATA'                       , 'LAST_DATA'                             , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Avaya.DetailView'        , 19, null;
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

call dbo.spDETAILVIEWS_FIELDS_Avaya()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_Avaya')
/

-- #endif IBM_DB2 */


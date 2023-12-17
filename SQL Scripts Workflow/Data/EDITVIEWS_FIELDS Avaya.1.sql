

print 'EDITVIEWS_FIELDS Avaya';
GO

set nocount on;
GO

-- 12/03/2013 Paul.  Add layout for Avaya. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Avaya.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Avaya.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Avaya.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Avaya.SearchBasic', 'Avaya', 'vwCALL_DETAIL_RECORDS', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Avaya.SearchBasic'          ,  0, 'Avaya.LBL_CALLERID'                  , 'CALLERID'                   , 0, null, 80, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Avaya.SearchBasic'          ,  1, 'Avaya.LBL_PARENT_NAME'               , 'PARENT_ID'                  , 0, null, 'PARENT_NAME', 'Calls', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Avaya.SearchBasic'          ,  2, 'Avaya.LBL_START_TIME'                , 'START_TIME'                 , 0, null, 'DateRange'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Avaya.SearchBasic'          ,  3, 'Avaya.LBL_SOURCE'                    , 'SOURCE'                     , 0, null, 80, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Avaya.SearchBasic'          ,  4, 'Avaya.LBL_DESTINATION'               , 'DESTINATION'                , 0, null, 80, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Avaya.SearchBasic'          ,  5, 'Avaya.LBL_DISPOSITION'               , 'DISPOSITION'                , 0, null, 80, 25, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Avaya.ConfigView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Avaya.ConfigView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Avaya.ConfigView';
	exec dbo.spEDITVIEWS_InsertOnly            'Avaya.ConfigView', 'Avaya', 'vwCONFIG_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Avaya.ConfigView'           ,  0, 'Avaya.LBL_HOST_SERVER'                  , 'Avaya.Host'                       , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Avaya.ConfigView'           ,  1, 'Avaya.LBL_HOST_PORT'                    , 'Avaya.Port'                       , 0, 1,  10, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Avaya.ConfigView'           ,  2, 'Avaya.LBL_SWITCH_NAME'                  , 'Avaya.SwitchName'                 , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Avaya.ConfigView'           ,  3, 'Avaya.LBL_SECURE_SOCKET'                , 'Avaya.SecureSocket'               , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Avaya.ConfigView'           ,  4, 'Avaya.LBL_USER_NAME'                    , 'Avaya.UserName'                   , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Avaya.ConfigView'           ,  5, 'Avaya.LBL_PASSWORD'                     , 'Avaya.Password'                   , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Avaya.ConfigView'           ,  6, 'Avaya.LBL_LOG_MISSED_INCOMING_CALLS'    , 'Avaya.LogIncomingMissedCalls'     , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Avaya.ConfigView'           ,  7, 'Avaya.LBL_LOG_MISSED_OUTGOING_CALLS'    , 'Avaya.LogOutgoingMissedCalls'     , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Avaya.ConfigView'           ,  8, 'Avaya.LBL_LOG_CALL_DETAILS'             , 'Avaya.LogCallDetails'             , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Avaya.ConfigView'           ,  9, null;
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

call dbo.spEDITVIEWS_FIELDS_Avaya()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_Avaya')
/

-- #endif IBM_DB2 */




print 'EDITVIEWS_FIELDS ReportRules';
GO

set nocount on;
GO

-- 05/19/2021 Paul.  ReportRules layout for React client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportRules.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportRules.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ReportRules.EditView';
	exec dbo.spEDITVIEWS_InsertOnly             'ReportRules.EditView'    , 'ReportRules', 'vwBUSINESS_RULES', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ReportRules.EditView'    ,  0, 'Rules.LBL_NAME'                         , 'NAME'                       , 0, null, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ReportRules.EditView'    ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'ReportRules.EditView'    ,  2, 'Rules.LBL_MODULE_NAME'                  , 'MODULE_NAME'                , 0, null, 'RulesModules', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ReportRules.EditView'    ,  3, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportRules.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportRules.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ReportRules.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'ReportRules.SearchBasic' , 'ReportRules', 'vwBUSINESS_RULES', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ReportRules.SearchBasic' ,  0, 'Rules.LBL_NAME'                         , 'NAME'                       , 0, null, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'ReportRules.SearchBasic' ,  1, 'Rules.LBL_MODULE_NAME'                  , 'MODULE_NAME'                , 0, null, 'RulesModules', null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ReportRules.SearchBasic' ,  2, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportRules.SearchPopup';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportRules.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ReportRules.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'ReportRules.SearchPopup' , 'ReportRules', 'vwBUSINESS_RULES', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ReportRules.SearchPopup' ,  0, 'Rules.LBL_NAME'                         , 'NAME'                       , 0, null, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ReportRules.SearchPopup' ,  1, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportRules.EventsEditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportRules.EventsEditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ReportRules.EventsEditView';
	exec dbo.spEDITVIEWS_InsertOnly             'ReportRules.EventsEditView', 'ReportRules', 'vwGRIDVIEWS', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'ReportRules.EventsEditView',  0, 'ReportRules.LBL_TABLE_LOAD_EVENT_NAME', 'PRE_LOAD_EVENT_ID'        , 0, null, 'PRE_LOAD_EVENT_NAME'  , 'ReportRules', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'ReportRules.EventsEditView',  1, 'ReportRules.LBL_ROW_LOAD_EVENT_NAME'  , 'POST_LOAD_EVENT_ID'       , 0, null, 'POST_LOAD_EVENT_NAME' , 'ReportRules', null;
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick  null, 'ReportRules.EventsEditView', 'PRE_LOAD_EVENT_ID'  , 'return PreLoadEventPopup();'   ;
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick  null, 'ReportRules.EventsEditView', 'POST_LOAD_EVENT_ID' , 'return PostLoadEventPopup();'  ;
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

call dbo.spEDITVIEWS_FIELDS_ReportRules()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_ReportRules')
/

-- #endif IBM_DB2 */


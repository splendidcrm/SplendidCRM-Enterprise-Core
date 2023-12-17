

print 'EDITVIEWS_FIELDS MachineLearningModels';
GO

set nocount on;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'MachineLearningModels.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'MachineLearningModels.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS MachineLearningModels.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'MachineLearningModels.EditView'   , 'MachineLearningModels', 'vwMACHINE_LEARNING_MODELS_Edit', '15%', '35%';
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'MachineLearningModels.EditView'   ,  0, 'MachineLearningModels.LBL_NAME'                   , 'NAME'                       , 1, 1,  255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'MachineLearningModels.EditView'   ,  1, 'MachineLearningModels.LBL_STATUS'                 , 'STATUS'                     , 1, 1, 'ml_model_status_dom', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'MachineLearningModels.EditView'   ,  2, 'MachineLearningModels.LBL_BASE_MODULE'            , 'BASE_MODULE'                , 1, 1, 'ml_modules_dom', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'MachineLearningModels.EditView'   ,  3, 'MachineLearningModels.LBL_USE_CROSS_VALIDATION'   , 'USE_CROSS_VALIDATION'       , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'MachineLearningModels.EditView'   ,  4, 'MachineLearningModels.LBL_TRAIN_SQL_VIEW'         , 'TRAIN_SQL_VIEW'             , 1, 1,  255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'MachineLearningModels.EditView'   ,  5, 'MachineLearningModels.LBL_GOOD_FIELD_NAME'        , 'GOOD_FIELD_NAME'            , 1, 1,  255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'MachineLearningModels.EditView'   ,  6, 'MachineLearningModels.LBL_EVALUATE_SQL_VIEW'      , 'EVALUATE_SQL_VIEW'          , 0, 1,  255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'MachineLearningModels.EditView'   ,  7, 'MachineLearningModels.LBL_SCENARIO'               , 'SCENARIO'                   , 1, 1, 'ml_model_scenario_dom', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'MachineLearningModels.EditView'   ,  8, 'MachineLearningModels.LBL_DESCRIPTION'            , 'DESCRIPTION'                , 0, 5,   8, 80, 3;
end -- if;
GO

-- delete from EDITVIEWS where NAME = 'MachineLearningModels.SearchBasic';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'MachineLearningModels.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'MachineLearningModels.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS MachineLearningModels.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly            'MachineLearningModels.SearchBasic', 'MachineLearningModels', 'vwMACHINE_LEARNING_MODELS_Edit', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'MachineLearningModels.SearchBasic',  0, 'MachineLearningModels.LBL_NAME'                   , 'NAME'                       , 0, null, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'MachineLearningModels.SearchBasic',  1, null;
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

call dbo.spEDITVIEWS_FIELDS_MachineLearningModels()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_MachineLearningModels')
/

-- #endif IBM_DB2 */


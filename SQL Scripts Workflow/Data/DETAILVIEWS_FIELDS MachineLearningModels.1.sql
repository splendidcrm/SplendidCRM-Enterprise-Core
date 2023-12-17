

print 'DETAILVIEWS_FIELDS MachineLearningModels';
GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'MachineLearningModels.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'MachineLearningModels.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS MachineLearningModels.DetailView';
	exec dbo.spDETAILVIEWS_InsertOnly           'MachineLearningModels.DetailView', 'MachineLearningModels', 'vwMACHINE_LEARNING_MODELS_Edit', '15%', '35%';
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView',  0, 'MachineLearningModels.LBL_NAME'                         , 'NAME'                                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'MachineLearningModels.DetailView',  1, 'MachineLearningModels.LBL_STATUS'                       , 'STATUS'                                , '{0}', 'ml_model_status_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'MachineLearningModels.DetailView',  2, 'MachineLearningModels.LBL_BASE_MODULE'                  , 'BASE_MODULE'                           , '{0}', 'ml_modules_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox   'MachineLearningModels.DetailView',  3, 'MachineLearningModels.LBL_USE_CROSS_VALIDATION'         , 'USE_CROSS_VALIDATION'                  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView',  4, 'MachineLearningModels.LBL_TRAIN_SQL_VIEW'               , 'TRAIN_SQL_VIEW'                        , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView',  5, 'MachineLearningModels.LBL_GOOD_FIELD_NAME'              , 'GOOD_FIELD_NAME'                       , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView',  6, 'MachineLearningModels.LBL_EVALUATE_SQL_VIEW'            , 'EVALUATE_SQL_VIEW'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'MachineLearningModels.DetailView',  7, 'MachineLearningModels.LBL_SCENARIO'                     , 'SCENARIO'                              , '{0}', 'ml_model_scenario_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView',  8, '.LBL_DATE_ENTERED'                                      , 'DATE_ENTERED .LBL_BY CREATED_BY_NAME'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView',  9, '.LBL_DATE_MODIFIED'                                     , 'DATE_MODIFIED .LBL_BY MODIFIED_BY_NAME', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView', 10, 'MachineLearningModels.LBL_LAST_TRAINING_DATE'           , 'LAST_TRAINING_DATE'                    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView', 11, 'MachineLearningModels.LBL_LAST_TRAINING_COUNT'          , 'LAST_TRAINING_COUNT'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView', 12, 'MachineLearningModels.LBL_LAST_TRAINING_STATUS'         , 'LAST_TRAINING_STATUS'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound      'MachineLearningModels.DetailView', 13, 'MachineLearningModels.LBL_EVALUATION_STATUS'            , 'EVALUATION_STATUS'                     , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly    'MachineLearningModels.DetailView', 14, 'TextBox', 'MachineLearningModels.LBL_DESCRIPTION'       , 'DESCRIPTION', null, null, null, null, null, 3, null;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'MachineLearningModels.EvaluationView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'MachineLearningModels.EvaluationView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS MachineLearningModels.EvaluationView';
	exec dbo.spDETAILVIEWS_InsertOnly             'MachineLearningModels.EvaluationView', 'MachineLearningModels', 'vwMACHINE_LEARNING_MODELS_Edit', '15%', '35%';
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  0, 'MachineLearningModels.LBL_ACCURACY'                         , 'Accuracy'                         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  1, 'MachineLearningModels.LBL_AREA_UNDER_PRECISION_RECALL_CURVE', 'AreaUnderPrecisionRecallCurve'    , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  2, 'MachineLearningModels.LBL_AREA_UNDER_ROC_CURVE'             , 'AreaUnderRocCurve'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  3, 'MachineLearningModels.LBL_F1_SCORE'                         , 'F1Score'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  4, 'MachineLearningModels.LBL_NEGATIVE_PRECISION'               , 'NegativePrecision'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  5, 'MachineLearningModels.LBL_NEGATIVE_RECALL'                  , 'NegativeRecall'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  6, 'MachineLearningModels.LBL_POSITIVE_PRECISION'               , 'PositivePrecision'                , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  7, 'MachineLearningModels.LBL_POSITIVE_RECALL'                  , 'PositiveRecall'                   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  8, 'MachineLearningModels.LBL_ENTROPY'                          , 'Entropy'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView',  9, 'MachineLearningModels.LBL_LOG_LOSS'                         , 'LogLoss'                          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'MachineLearningModels.EvaluationView', 10, 'MachineLearningModels.LBL_LOG_LOSS_REDUCTION'               , 'LogLossReduction'                 , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank        'MachineLearningModels.EvaluationView', 11, null;

	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  0, 'MachineLearningModels.LBL_ACCURACY_TOOLTIP'                         ;
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  1, 'MachineLearningModels.LBL_AREA_UNDER_PRECISION_RECALL_CURVE_TOOLTIP';
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  2, 'MachineLearningModels.LBL_AREA_UNDER_ROC_CURVE_TOOLTIP'             ;
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  3, 'MachineLearningModels.LBL_F1_SCORE_TOOLTIP'                         ;
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  4, 'MachineLearningModels.LBL_NEGATIVE_PRECISION_TOOLTIP'               ;
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  5, 'MachineLearningModels.LBL_NEGATIVE_RECALL_TOOLTIP'                  ;
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  6, 'MachineLearningModels.LBL_POSITIVE_PRECISION_TOOLTIP'               ;
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  7, 'MachineLearningModels.LBL_POSITIVE_RECALL_TOOLTIP'                  ;
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  8, 'MachineLearningModels.LBL_ENTROPY_TOOLTIP'                          ;
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView',  9, 'MachineLearningModels.LBL_LOG_LOSS_TOOLTIP'                         ;
	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip null, 'MachineLearningModels.EvaluationView', 10, 'MachineLearningModels.LBL_LOG_LOSS_REDUCTION_TOOLTIP'               ;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView' and DATA_FIELD = 'PREDICTION' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'Contacts.DetailView'     ,  -1, 'MachineLearningModels.LBL_PROBABILITY'   , 'PROBABILITY'   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'Contacts.DetailView'     ,  -1, 'MachineLearningModels.LBL_SCORE'         , 'SCORE'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList    'Contacts.DetailView'     ,  -1, 'MachineLearningModels.LBL_PREDICTION'    , 'PREDICTION'    , '{0}', 'ml_contact_prediction_dom', null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Leads.DetailView' and DATA_FIELD = 'PREDICTION' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'Leads.DetailView'        ,  -1, 'MachineLearningModels.LBL_PROBABILITY'   , 'PROBABILITY'   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'Leads.DetailView'        ,  -1, 'MachineLearningModels.LBL_SCORE'         , 'SCORE'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList    'Leads.DetailView'        ,  -1, 'MachineLearningModels.LBL_PREDICTION'    , 'PREDICTION'    , '{0}', 'ml_contact_prediction_dom', null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Prospects.DetailView' and DATA_FIELD = 'PREDICTION' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'Prospects.DetailView'    ,  -1, 'MachineLearningModels.LBL_PROBABILITY'   , 'PROBABILITY'   , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'Prospects.DetailView'    ,  -1, 'MachineLearningModels.LBL_SCORE'         , 'SCORE'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList    'Prospects.DetailView'    ,  -1, 'MachineLearningModels.LBL_PREDICTION'    , 'PREDICTION'    , '{0}', 'ml_contact_prediction_dom', null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView' and DATA_FIELD = 'PREDICTION' and DELETED = 0) begin -- then
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'Opportunities.DetailView',  -1, 'MachineLearningModels.LBL_ML_PROBABILITY', 'ML_PROBABILITY', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound        'Opportunities.DetailView',  -1, 'MachineLearningModels.LBL_SCORE'         , 'SCORE'         , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList    'Opportunities.DetailView',  -1, 'MachineLearningModels.LBL_PREDICTION'    , 'PREDICTION'    , '{0}', 'ml_opportunity_prediction_dom', null;
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

call dbo.spDETAILVIEWS_FIELDS_MachineLearningModels()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_MachineLearningModels')
/

-- #endif IBM_DB2 */


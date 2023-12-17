


print 'TERMINOLOGY MachineLearningModels en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'MachineLearningModels';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'MachineLearningModels', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BASE_MODULE'                               , N'en-US', N'MachineLearningModels', null, null, N'Base Module:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'MachineLearningModels', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SCENARIO'                                  , N'en-US', N'MachineLearningModels', null, null, N'Scenario:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRAIN_SQL_VIEW'                            , N'en-US', N'MachineLearningModels', null, null, N'Train SQL View:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EVALUATE_SQL_VIEW'                         , N'en-US', N'MachineLearningModels', null, null, N'Evaluate SQL View:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GOOD_FIELD_NAME'                           , N'en-US', N'MachineLearningModels', null, null, N'GOOD Field:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USE_CROSS_VALIDATION'                      , N'en-US', N'MachineLearningModels', null, null, N'Use Cross Validation:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'MachineLearningModels', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_TRAINING_DATE'                        , N'en-US', N'MachineLearningModels', null, null, N'Last Training Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_TRAINING_COUNT'                       , N'en-US', N'MachineLearningModels', null, null, N'Last Training Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_TRAINING_STATUS'                      , N'en-US', N'MachineLearningModels', null, null, N'Last Training Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EVALUATION_STATUS'                         , N'en-US', N'MachineLearningModels', null, null, N'Evaluation Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROBABILITY'                               , N'en-US', N'MachineLearningModels', null, null, N'Probability:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ML_PROBABILITY'                            , N'en-US', N'MachineLearningModels', null, null, N'ML Probability:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SCORE'                                     , N'en-US', N'MachineLearningModels', null, null, N'Score:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PREDICTION'                                , N'en-US', N'MachineLearningModels', null, null, N'Prediction:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'MachineLearningModels', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BASE_MODULE'                          , N'en-US', N'MachineLearningModels', null, null, N'Base Module';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'MachineLearningModels', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SCENARIO'                             , N'en-US', N'MachineLearningModels', null, null, N'Scenario';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TRAIN_SQL_VIEW'                       , N'en-US', N'MachineLearningModels', null, null, N'Train:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EVALUATE_SQL_VIEW'                    , N'en-US', N'MachineLearningModels', null, null, N'Evaluate:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_GOOD_FIELD_NAME'                      , N'en-US', N'MachineLearningModels', null, null, N'GOOD Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_USE_CROSS_VALIDATION'                 , N'en-US', N'MachineLearningModels', null, null, N'Use Cross Validation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'MachineLearningModels', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_TRAINING_DATE'                   , N'en-US', N'MachineLearningModels', null, null, N'Training Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_TRAINING_COUNT'                  , N'en-US', N'MachineLearningModels', null, null, N'Training Count';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_TRAINING_STATUS'                 , N'en-US', N'MachineLearningModels', null, null, N'Training Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PROBABILITY'                          , N'en-US', N'MachineLearningModels', null, null, N'Probability';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SCORE'                                , N'en-US', N'MachineLearningModels', null, null, N'Score';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PREDICTION'                           , N'en-US', N'MachineLearningModels', null, null, N'Prediction';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'MachineLearningModels', null, null, N'ML';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'MachineLearningModels', null, null, N'Machine Learning Models';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'MachineLearningModels', null, null, N'Machine Learning Models';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'MachineLearningModels', null, null, N'Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_MACHINE_LEARNING_MODEL'                , N'en-US', N'MachineLearningModels', null, null, N'Create Machine Learning Model';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_MACHINE_LEARNING_MODEL_LIST'               , N'en-US', N'MachineLearningModels', null, null, N'Machine Learning Models';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MACHINE_LEARNING_MODELS_DESC'              , N'en-US', N'MachineLearningModels', null, null, N'Manage Machine Learning Models';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MACHINE_LEARNING_MODELS_TITLE'             , N'en-US', N'MachineLearningModels', null, null, N'Machine Learning Models';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRAIN_BUTTON'                              , N'en-US', N'MachineLearningModels', null, null, N'Train';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EVALUATE_BUTTON'                           , N'en-US', N'MachineLearningModels', null, null, N'Evaluate';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PREDICT_BUTTON'                            , N'en-US', N'MachineLearningModels', null, null, N'Predict';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TRAIN_BACKGROUND'                          , N'en-US', N'MachineLearningModels', null, null, N'Training will occur in the background.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUSY_TRAINING'                             , N'en-US', N'MachineLearningModels', null, null, N'Busy training.  Please try again when complete.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUSY_EVALUATING'                           , N'en-US', N'MachineLearningModels', null, null, N'Busy evaluating.  Please try again when complete.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUCCESS'                                   , N'en-US', N'MachineLearningModels', null, null, N'Success';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EVALUATION_INFORMATION'                    , N'en-US', N'MachineLearningModels', null, null, N'Evaluation Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCURACY'                                  , N'en-US', N'MachineLearningModels', null, null, N'Accuracy:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AREA_UNDER_PRECISION_RECALL_CURVE'         , N'en-US', N'MachineLearningModels', null, null, N'Area Under Precision Recall Curve:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AREA_UNDER_ROC_CURVE'                      , N'en-US', N'MachineLearningModels', null, null, N'Area Under Roc Curve:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_F1_SCORE'                                  , N'en-US', N'MachineLearningModels', null, null, N'F1Score:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEGATIVE_PRECISION'                        , N'en-US', N'MachineLearningModels', null, null, N'Negative Precision:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEGATIVE_RECALL'                           , N'en-US', N'MachineLearningModels', null, null, N'Negative Recall:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_POSITIVE_PRECISION'                        , N'en-US', N'MachineLearningModels', null, null, N'Positive Precision:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_POSITIVE_RECALL'                           , N'en-US', N'MachineLearningModels', null, null, N'Positive Recall:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ENTROPY'                                   , N'en-US', N'MachineLearningModels', null, null, N'Entropy:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOG_LOSS'                                  , N'en-US', N'MachineLearningModels', null, null, N'Log Loss:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOG_LOSS_REDUCTION'                        , N'en-US', N'MachineLearningModels', null, null, N'Log Loss Reduction:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCURACY_TOOLTIP'                          , N'en-US', N'MachineLearningModels', null, null, N'Gets the accuracy of a classifier which is the proportion of correct predictions in the test set.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AREA_UNDER_PRECISION_RECALL_CURVE_TOOLTIP' , N'en-US', N'MachineLearningModels', null, null, N'Gets the area under the precision/recall curve of the classifier. The area under the precision/recall curve is a single number summary of the information in the precision/recall curve. It is increasingly used in the machine learning community, particularly for imbalanced datasets where one class is observed more frequently than the other.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AREA_UNDER_ROC_CURVE_TOOLTIP'              , N'en-US', N'MachineLearningModels', null, null, N'Gets the area under the ROC curve. The area under the ROC curve is equal to the probability that the classifier ranks a randomly chosen positive instance higher than a randomly chosen negative one (assuming ''positive'' ranks higher than ''negative''). Area under the ROC curve ranges between 0 and 1, with a value closer to 1 indicating a better model.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_F1_SCORE_TOOLTIP'                          , N'en-US', N'MachineLearningModels', null, null, N'Gets the F1 score of the classifier, which is a measure of the classifier''s quality considering both precision and recall. F1 score is the harmonic mean of precision and recall: 2 * precision * recall / (precision + recall).  F1 ranges between 0 and 1, with a value of 1 indicating perfect precision and recall.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEGATIVE_PRECISION_TOOLTIP'                , N'en-US', N'MachineLearningModels', null, null, N'Gets the negative precision of a classifier which is the proportion of correctly predicted negative instances among all the negative predictions (i.e., the number of negative instances predicted as negative, divided by the total number of instances predicted as negative).';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEGATIVE_RECALL_TOOLTIP'                   , N'en-US', N'MachineLearningModels', null, null, N'Gets the negative recall of a classifier which is the proportion of correctly predicted negative instances among all the negative instances (i.e., the number of negative instances predicted as negative, divided by the total number of negative instances).';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_POSITIVE_PRECISION_TOOLTIP'                , N'en-US', N'MachineLearningModels', null, null, N'Gets the positive precision of a classifier which is the proportion of correctly predicted positive instances among all the positive predictions (i.e., the number of positive instances predicted as positive, divided by the total number of instances predicted as positive).';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_POSITIVE_RECALL_TOOLTIP'                   , N'en-US', N'MachineLearningModels', null, null, N'Gets the positive recall of a classifier which is the proportion of correctly predicted positive instances among all the positive instances (i.e., the number of positive instances predicted as positive, divided by the total number of positive instances).';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ENTROPY_TOOLTIP'                           , N'en-US', N'MachineLearningModels', null, null, N'Gets the test-set entropy, which is the prior log-loss based on the proportion of positive and negative instances in the test set. A classifier''s LogLoss lower than the entropy indicates that a classifier does better than predicting the proportion of positive instances as the probability for each instance.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOG_LOSS_TOOLTIP'                          , N'en-US', N'MachineLearningModels', null, null, N'Gets the log-loss of the classifier. Log-loss measures the performance of a classifier with respect to how much the predicted probabilities diverge from the true class label. Lower log-loss indicates a better model. A perfect model, which predicts a probability of 1 for the true class, will have a log-loss of 0.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOG_LOSS_REDUCTION_TOOLTIP'                , N'en-US', N'MachineLearningModels', null, null, N'Gets the log-loss reduction (also known as relative log-loss, or reduction in information gain - RIG) of the classifier. It gives a measure of how much a model improves on a model that gives random predictions.  Log-loss reduction closer to 1 indicates a better model.';

-- select * from TERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc;
exec dbo.spTERMINOLOGY_InsertOnly N'MachineLearningModels'                         , N'en-US', null, N'moduleList'              , 176, N'Machine Learning Models';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MACHINE_LEARNING_MODELS_TITLE'             , N'en-US', N'Administration', null, null, N'Machine Learning Models';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MACHINE_LEARNING_MODELS'                   , N'en-US', N'Administration', null, null, N'Manage Machine Learning Models';

-- delete from TERMINOLOGY where LIST_NAME = 'MachineLearningModels_METHOD_dom';
exec dbo.spTERMINOLOGY_InsertOnly N'Active'                                        , N'en-US', null, N'ml_model_status_dom'    ,   0, N'Active';
exec dbo.spTERMINOLOGY_InsertOnly N'Inactive'                                      , N'en-US', null, N'ml_model_status_dom'    ,   1, N'Inactive';

exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                      , N'en-US', null, N'ml_modules_dom'         ,   0, N'Contacts';
exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                         , N'en-US', null, N'ml_modules_dom'         ,   1, N'Leads';
exec dbo.spTERMINOLOGY_InsertOnly N'Prospects'                                     , N'en-US', null, N'ml_modules_dom'         ,   2, N'Targets';
exec dbo.spTERMINOLOGY_InsertOnly N'Opportunities'                                 , N'en-US', null, N'ml_modules_dom'         ,   3, N'Opportunities';

exec dbo.spTERMINOLOGY_InsertOnly N'Very High'                                     , N'en-US', null, N'ml_contact_prediction_dom',   0, N'Very High';
exec dbo.spTERMINOLOGY_InsertOnly N'High'                                          , N'en-US', null, N'ml_contact_prediction_dom',   1, N'High';
exec dbo.spTERMINOLOGY_InsertOnly N'Normal'                                        , N'en-US', null, N'ml_contact_prediction_dom',   2, N'Normal';
exec dbo.spTERMINOLOGY_InsertOnly N'Low'                                           , N'en-US', null, N'ml_contact_prediction_dom',   3, N'Low';
exec dbo.spTERMINOLOGY_InsertOnly N'Very Low'                                      , N'en-US', null, N'ml_contact_prediction_dom',   4, N'Very Low';

exec dbo.spTERMINOLOGY_InsertOnly N'Very Likely'                                   , N'en-US', null, N'ml_opportunity_prediction_dom',   0, N'Very Likely';
exec dbo.spTERMINOLOGY_InsertOnly N'More Likely'                                   , N'en-US', null, N'ml_opportunity_prediction_dom',   1, N'More Likely';
exec dbo.spTERMINOLOGY_InsertOnly N'Neutral'                                       , N'en-US', null, N'ml_opportunity_prediction_dom',   2, N'Neutral';
exec dbo.spTERMINOLOGY_InsertOnly N'Less Likely'                                   , N'en-US', null, N'ml_opportunity_prediction_dom',   3, N'Less Likely';
exec dbo.spTERMINOLOGY_InsertOnly N'Not Likely'                                    , N'en-US', null, N'ml_opportunity_prediction_dom',   4, N'Not Likely';

exec dbo.spTERMINOLOGY_InsertOnly N'Binary classification'                         , N'en-US', null, N'ml_model_scenario_dom'  ,   0, N'Binary classification'    ;
--exec dbo.spTERMINOLOGY_InsertOnly N'Multiclass classification'                     , N'en-US', null, N'ml_model_scenario_dom'  ,   1, N'Multiclass classification';
--exec dbo.spTERMINOLOGY_InsertOnly N'Regression'                                    , N'en-US', null, N'ml_model_scenario_dom'  ,   2, N'Regression'               ;
--exec dbo.spTERMINOLOGY_InsertOnly N'Clustering'                                    , N'en-US', null, N'ml_model_scenario_dom'  ,   3, N'Clustering'               ;
--exec dbo.spTERMINOLOGY_InsertOnly N'Anomaly detection'                             , N'en-US', null, N'ml_model_scenario_dom'  ,   4, N'Anomaly detection'        ;
--exec dbo.spTERMINOLOGY_InsertOnly N'Ranking'                                       , N'en-US', null, N'ml_model_scenario_dom'  ,   5, N'Ranking'                  ;
--exec dbo.spTERMINOLOGY_InsertOnly N'Recommendation'                                , N'en-US', null, N'ml_model_scenario_dom'  ,   6, N'Recommendation'           ;
--exec dbo.spTERMINOLOGY_InsertOnly N'Forecasting'                                   , N'en-US', null, N'ml_model_scenario_dom'  ,   7, N'Forecasting'              ;


GO


set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_MachineLearningModels_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_MachineLearningModels_en_us')
/
-- #endif IBM_DB2 */

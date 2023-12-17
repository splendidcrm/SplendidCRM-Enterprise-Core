

print 'TERMINOLOGY SurveyQuestionResults en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'SurveyQuestionResults';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'SurveyQuestionResults', null, null, N'Survey Question Results';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'SurveyQuestionResults', null, null, N'SQR';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'SurveyQuestionResults', null, null, N'Survey Question Results List';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_SURVEY_RESULTS_LIST'                       , N'en-US', N'SurveyQuestionResults', null, null, N'Survey Question Results';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_RESULT_ID'                          , N'en-US', N'SurveyQuestionResults', null, null, N'Survey Result ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_ID'                                 , N'en-US', N'SurveyQuestionResults', null, null, N'Survey ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_PAGE_ID'                            , N'en-US', N'SurveyQuestionResults', null, null, N'Survey Page ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_QUESTION_ID'                        , N'en-US', N'SurveyQuestionResults', null, null, N'Survey Question ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWER_ID'                                 , N'en-US', N'SurveyQuestionResults', null, null, N'Answer ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWER_TEXT'                               , N'en-US', N'SurveyQuestionResults', null, null, N'Answer:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COLUMN_ID'                                 , N'en-US', N'SurveyQuestionResults', null, null, N'Column ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COLUMN_TEXT'                               , N'en-US', N'SurveyQuestionResults', null, null, N'Column:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MENU_ID'                                   , N'en-US', N'SurveyQuestionResults', null, null, N'Menu ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MENU_TEXT'                                 , N'en-US', N'SurveyQuestionResults', null, null, N'Menu:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WEIGHT'                                    , N'en-US', N'SurveyQuestionResults', null, null, N'Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_TEXT'                                , N'en-US', N'SurveyQuestionResults', null, null, N'Other:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_TYPE'                             , N'en-US', N'SurveyQuestionResults', null, null, N'Question Type:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_RESULT_ID'                     , N'en-US', N'SurveyQuestionResults', null, null, N'Survey Result ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_ID'                            , N'en-US', N'SurveyQuestionResults', null, null, N'Survey ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_PAGE_ID'                       , N'en-US', N'SurveyQuestionResults', null, null, N'Survey Page ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_QUESTION_ID'                   , N'en-US', N'SurveyQuestionResults', null, null, N'Survey Question ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ANSWER_ID'                            , N'en-US', N'SurveyQuestionResults', null, null, N'Answer ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ANSWER_TEXT'                          , N'en-US', N'SurveyQuestionResults', null, null, N'Answer';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_COLUMN_ID'                            , N'en-US', N'SurveyQuestionResults', null, null, N'Column ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_COLUMN_TEXT'                          , N'en-US', N'SurveyQuestionResults', null, null, N'Column';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MENU_ID'                              , N'en-US', N'SurveyQuestionResults', null, null, N'Menu ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MENU_TEXT'                            , N'en-US', N'SurveyQuestionResults', null, null, N'Menu';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_WEIGHT'                               , N'en-US', N'SurveyQuestionResults', null, null, N'Weight';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_OTHER_TEXT'                           , N'en-US', N'SurveyQuestionResults', null, null, N'Other';

exec dbo.spTERMINOLOGY_InsertOnly N'SurveyQuestionResults'                         , N'en-US', null, N'moduleList'        , 114, N'Survey Question Results';
exec dbo.spTERMINOLOGY_InsertOnly N'SurveyQuestionResults'                         , N'en-US', null, N'moduleListSingular', 114, N'Survey Question Result';

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

call dbo.spTERMINOLOGY_SurveyQuestionResults_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_SurveyQuestionResults_en_us')
/
-- #endif IBM_DB2 */

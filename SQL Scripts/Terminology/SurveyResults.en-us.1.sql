

print 'TERMINOLOGY SurveyResults en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'SurveyResults';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPLETE'                                  , N'en-US', N'SurveyResults', null, null, N'COMPLETE';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INCOMPLETE'                                , N'en-US', N'SurveyResults', null, null, N'Incomplete';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_START_DATE'                                , N'en-US', N'SurveyResults', null, null, N'Start Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATE_MODIFIED'                             , N'en-US', N'SurveyResults', null, null, N'Date Modified:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TIME_SPENT'                                , N'en-US', N'SurveyResults', null, null, N'Time Spent:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IP_ADDRESS'                                , N'en-US', N'SurveyResults', null, null, N'IP Address:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWERED'                                  , N'en-US', N'SurveyResults', null, null, N'Answered: {0}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SKIPPED'                                   , N'en-US', N'SurveyResults', null, null, N'Skipped: {0}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWER_CHOICES'                            , N'en-US', N'SurveyResults', null, null, N'Answers';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RESPONSES'                                 , N'en-US', N'SurveyResults', null, null, N'Responses';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AVERAGE'                                   , N'en-US', N'SurveyResults', null, null, N'Average';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TOTAL'                                     , N'en-US', N'SurveyResults', null, null, N'Total';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AVERAGE_RATING'                            , N'en-US', N'SurveyResults', null, null, N'Average Rating';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NA'                                        , N'en-US', N'SurveyResults', null, null, N'N/A';
-- 12/23/2015 Paul.  Add Export to Summary. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXPORT'                                    , N'en-US', N'SurveyResults', null, null, N'Export';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'SurveyResults', null, null, N'Survey Results';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'SurveyResults', null, null, N'SR';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'SurveyResults', null, null, N'Survey Results List';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_SURVEY_RESULTS_LIST'                       , N'en-US', N'SurveyResults', null, null, N'Survey Results';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_NAME'                               , N'en-US', N'SurveyResults', null, null, N'Survey:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATE_ENTERED'                              , N'en-US', N'SurveyResults', null, null, N'Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_COMPLETE'                               , N'en-US', N'SurveyResults', null, null, N'Complete:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_QUESTION_NAME'                      , N'en-US', N'SurveyResults', null, null, N'Question:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWER_TEXT'                               , N'en-US', N'SurveyResults', null, null, N'Answer:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COLUMN_TEXT'                               , N'en-US', N'SurveyResults', null, null, N'Column:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MENU_TEXT'                                 , N'en-US', N'SurveyResults', null, null, N'Menu:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_TEXT'                                , N'en-US', N'SurveyResults', null, null, N'Other:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WEIGHT'                                    , N'en-US', N'SurveyResults', null, null, N'Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_ANSWERED'                               , N'en-US', N'SurveyResults', null, null, N'Answered:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RESPONDANT'                                , N'en-US', N'SurveyResults', null, null, N'Respondant:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_NAME'                          , N'en-US', N'SurveyResults', null, null, N'Survey';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DATE_ENTERED'                         , N'en-US', N'SurveyResults', null, null, N'Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_IS_COMPLETE'                          , N'en-US', N'SurveyResults', null, null, N'Complete';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_START_DATE'                           , N'en-US', N'SurveyResults', null, null, N'Start Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SUBMIT_DATE'                          , N'en-US', N'SurveyResults', null, null, N'Submit Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_QUESTION_NAME'                 , N'en-US', N'SurveyResults', null, null, N'Question';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ANSWER_TEXT'                          , N'en-US', N'SurveyResults', null, null, N'Answer';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_COLUMN_TEXT'                          , N'en-US', N'SurveyResults', null, null, N'Column';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MENU_TEXT'                            , N'en-US', N'SurveyResults', null, null, N'Menu';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_OTHER_TEXT'                           , N'en-US', N'SurveyResults', null, null, N'Other';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_WEIGHT'                               , N'en-US', N'SurveyResults', null, null, N'Weight';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_IS_ANSWERED'                          , N'en-US', N'SurveyResults', null, null, N'Answered';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_RESPONDANT'                           , N'en-US', N'SurveyResults', null, null, N'Respondant';

-- 08/28/2013 Paul.  Add missing Survey Results terms. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_ID'                                 , N'en-US', N'SurveyResults', null, null, N'Survey ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_ID'                                 , N'en-US', N'SurveyResults', null, null, N'Parent ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_NAME'                               , N'en-US', N'SurveyResults', null, null, N'Respondant Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_TYPE'                               , N'en-US', N'SurveyResults', null, null, N'Respondant Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_TYPE'                             , N'en-US', N'SurveyResults', null, null, N'Question Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUBMIT_DATE'                               , N'en-US', N'SurveyResults', null, null, N'Submit Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_AGENT'                                , N'en-US', N'SurveyResults', null, null, N'User Agent:';

-- select * from TERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER;
-- delete from TERMINOLOGY where NAME = 'SurveyResults';
exec dbo.spTERMINOLOGY_InsertOnly N'SurveyResults'                                 , N'en-US', null, N'moduleList'        , 113, N'Survey Results';
exec dbo.spTERMINOLOGY_InsertOnly N'SurveyResults'                                 , N'en-US', null, N'moduleListSingular', 113, N'Survey Result';

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

call dbo.spTERMINOLOGY_SurveyResults_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_SurveyResults_en_us')
/
-- #endif IBM_DB2 */

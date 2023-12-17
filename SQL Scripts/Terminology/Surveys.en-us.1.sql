

print 'TERMINOLOGY Surveys en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'ERR_SURVEY_NOT_FOUND'                          , N'en-US', N'Surveys', null, null, N'Survey Not Found.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'Surveys', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'Surveys', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Surveys', null, null, N'Survey List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'Surveys', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'Surveys', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_STYLE'                         , N'en-US', N'Surveys', null, null, N'Style';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PAGE_RANDOMIZATION'                   , N'en-US', N'Surveys', null, null, N'Page Randomization';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_THEME_NAME'                    , N'en-US', N'Surveys', null, null, N'Theme';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_RESPONSES'                            , N'en-US', N'Surveys', null, null, N'Responses';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'Surveys', null, null, N'Surveys';
-- 06/04/2015 Paul.  Add module abbreviation. 
-- delete from TERMINOLOGY where NAME = 'LBL_MODULE_ABBREVIATION' and MODULE_NAME = 'Surveys';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Surveys', null, null, N'Svy';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'Surveys', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_FORM_TITLE'                            , N'en-US', N'Surveys', null, null, N'Create Survey';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'Surveys', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_STYLE'                              , N'en-US', N'Surveys', null, null, N'Style:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_RANDOMIZATION'                        , N'en-US', N'Surveys', null, null, N'Page Randomization:';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_SURVEY_LIST'                               , N'en-US', N'Surveys', null, null, N'Surveys';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_THEME_ID'                           , N'en-US', N'Surveys', null, null, N'Survey Theme:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_THEME_NAME'                         , N'en-US', N'Surveys', null, null, N'Survey Theme:';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_SURVEY'                                , N'en-US', N'Surveys', null, null, N'Create Survey';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOT_RANDOMIZED'                            , N'en-US', N'Surveys', null, null, N'Not Randomized';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PREVIEW'                                   , N'en-US', N'Surveys', null, null, N'Preview';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_BUTTON_LABEL'                         , N'en-US', N'Surveys', null, null, N'Test';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_URL'                                , N'en-US', N'Surveys', null, null, N'Survey URL:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUMMARY'                                   , N'en-US', N'Surveys', null, null, N'Summary';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RESULTS'                                   , N'en-US', N'Surveys', null, null, N'Results';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DETAILS'                                   , N'en-US', N'Surveys', null, null, N'Details';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXIT_LINK'                                 , N'en-US', N'Surveys', null, null, N'Exit Survey';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PREV_LINK'                                 , N'en-US', N'Surveys', null, null, N'Previous';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEXT_LINK'                                 , N'en-US', N'Surveys', null, null, N'Next';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUBMIT_LINK'                               , N'en-US', N'Surveys', null, null, N'Submit';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_COMPLETE'                           , N'en-US', N'Surveys', null, null, N'Thank you for taking the survey.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXPORT_BUTTON_LABEL'                       , N'en-US', N'Surveys', null, null, N'Export';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_BUTTON_LABEL'                       , N'en-US', N'Surveys', null, null, N'Import';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COPY_OF'                                   , N'en-US', N'Surveys', null, null, N'{0} - Copy';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEYS_TITLE'                             , N'en-US', N'Surveys', null, null, N'Surveys';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_THEMES_TITLE'                       , N'en-US', N'Surveys', null, null, N'Survey Themes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_THEMES_DESC'                        , N'en-US', N'Surveys', null, null, N'Manage Survey Themes';

-- 10/24/2014 Paul.  Need to provide a way to delete all survey results. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DELETE_RESULTS_BUTTON'                     , N'en-US', N'Surveys', null, null, N'Delete Results';
-- 07/28/2018 Paul.  Add Kiosk mode fields. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOOP_SURVEY'                               , N'en-US', N'Surveys', null, null, N'Loop Survey:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LOOP_SURVEY'                          , N'en-US', N'Surveys', null, null, N'Loop Survey';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXIT_CODE'                                 , N'en-US', N'Surveys', null, null, N'Exit Code:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EXIT_CODE'                            , N'en-US', N'Surveys', null, null, N'Exit Code';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TIMEOUT'                                   , N'en-US', N'Surveys', null, null, N'Timeout:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TIMEOUT'                              , N'en-US', N'Surveys', null, null, N'Timeout';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_KIOSK_PROPERTIES'                          , N'en-US', N'Surveys', null, null, N'Kiosk Properties';
-- 09/30/2018 Paul.  Add survey record creation to survey. Can't use LBL_MODULE_NAME as that is already being used as the core keyword. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TARGET_MODULE'                      , N'en-US', N'Surveys', null, null, N'Survey Target Module:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_TARGET_MODULE'                 , N'en-US', N'Surveys', null, null, N'Target Module';
-- 11/08/2018 Paul.  Allow questions to be added directly to the survey. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADD_QUESTIONS'                             , N'en-US', N'Surveys', null, null, N'Add Questions';

-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TARGET_ASSIGNMENT'                  , N'en-US', N'Surveys', null, null, N'Survey Target Assignment:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_TARGET_ASSIGNMENT'             , N'en-US', N'Surveys', null, null, N'Target Assignment';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */

-- delete from TERMINOLOGY where LIST_NAME like 'survey%';
exec dbo.spTERMINOLOGY_InsertOnly N'Surveys'                                       , N'en-US', null, N'moduleList'                        , 109, N'Surveys';
exec dbo.spTERMINOLOGY_InsertOnly N'Surveys'                                       , N'en-US', null, N'moduleListSingular'                , 109, N'Survey';

exec dbo.spTERMINOLOGY_InsertOnly N'Active'                                        , N'en-US', null, N'survey_status_dom'                 ,   1, N'Active';
exec dbo.spTERMINOLOGY_InsertOnly N'Inactive'                                      , N'en-US', null, N'survey_status_dom'                 ,   2, N'Inactive';

-- delete from TERMINOLOGY where LIST_NAME = 'survey_page_randomization';
exec dbo.spTERMINOLOGY_InsertOnly N'Randomize'                                     , N'en-US', null, N'survey_page_randomization'         ,  1, N'Randomize';
exec dbo.spTERMINOLOGY_InsertOnly N'Flip'                                          , N'en-US', null, N'survey_page_randomization'         ,  2, N'Flip';
exec dbo.spTERMINOLOGY_InsertOnly N'Rotate'                                        , N'en-US', null, N'survey_page_randomization'         ,  3, N'Rotate';

-- delete from TERMINOLOGY where LIST_NAME = 'survey_question_randomization';
exec dbo.spTERMINOLOGY_InsertOnly N'Randomize'                                     , N'en-US', null, N'survey_question_randomization'     ,  1, N'Randomize';
exec dbo.spTERMINOLOGY_InsertOnly N'Flip'                                          , N'en-US', null, N'survey_question_randomization'     ,  2, N'Flip';
exec dbo.spTERMINOLOGY_InsertOnly N'Rotate'                                        , N'en-US', null, N'survey_question_randomization'     ,  3, N'Rotate';

exec dbo.spTERMINOLOGY_InsertOnly N'Randomize'                                     , N'en-US', null, N'survey_answer_randomization'       ,  1, N'Randomize';
exec dbo.spTERMINOLOGY_InsertOnly N'Flip'                                          , N'en-US', null, N'survey_answer_randomization'       ,  2, N'Flip';
exec dbo.spTERMINOLOGY_InsertOnly N'Sort'                                          , N'en-US', null, N'survey_answer_randomization'       ,  3, N'Sort';

exec dbo.spTERMINOLOGY_InsertOnly N'New Row'                                       , N'en-US', null, N'survey_question_placement'         ,  1, N'Start on new row';
exec dbo.spTERMINOLOGY_InsertOnly N'Next to Previous'                              , N'en-US', null, N'survey_question_placement'         ,  2, N'Next to previous';

-- delete from TERMINOLOGY where LIST_NAME = 'survey_question_type';
exec dbo.spTERMINOLOGY_InsertOnly N'Radio'                                         , N'en-US', null, N'survey_question_type'              ,  1, N'Radio Buttons (Only one answer)';
exec dbo.spTERMINOLOGY_InsertOnly N'Checkbox'                                      , N'en-US', null, N'survey_question_type'              ,  2, N'Checkboxes (Multiple answers)';
exec dbo.spTERMINOLOGY_InsertOnly N'Dropdown'                                      , N'en-US', null, N'survey_question_type'              ,  3, N'Drop-down Menu (Only one answer)';
exec dbo.spTERMINOLOGY_InsertOnly N'Ranking'                                       , N'en-US', null, N'survey_question_type'              ,  4, N'Ranking';
exec dbo.spTERMINOLOGY_InsertOnly N'Rating Scale'                                  , N'en-US', null, N'survey_question_type'              ,  5, N'Rating Scale';
exec dbo.spTERMINOLOGY_InsertOnly N'Radio Matrix'                                  , N'en-US', null, N'survey_question_type'              ,  6, N'Matrix of Radio Buttons (Only one answer per row)';
exec dbo.spTERMINOLOGY_InsertOnly N'Checkbox Matrix'                               , N'en-US', null, N'survey_question_type'              ,  7, N'Matrix of Checkboxes (Multiple answers per row)';
exec dbo.spTERMINOLOGY_InsertOnly N'Dropdown Matrix'                               , N'en-US', null, N'survey_question_type'              ,  8, N'Matrix of Drop-down Menus (Only one answer per row)';
exec dbo.spTERMINOLOGY_InsertOnly N'Text Area'                                     , N'en-US', null, N'survey_question_type'              ,  9, N'Text Area';
exec dbo.spTERMINOLOGY_InsertOnly N'Textbox'                                       , N'en-US', null, N'survey_question_type'              , 10, N'Textbox';
exec dbo.spTERMINOLOGY_InsertOnly N'Textbox Multiple'                              , N'en-US', null, N'survey_question_type'              , 11, N'Multiple Textboxes';
exec dbo.spTERMINOLOGY_InsertOnly N'Textbox Numerical'                             , N'en-US', null, N'survey_question_type'              , 12, N'Numerical Textboxes';
exec dbo.spTERMINOLOGY_InsertOnly N'Plain Text'                                    , N'en-US', null, N'survey_question_type'              , 13, N'Plain Text (no answers)';
exec dbo.spTERMINOLOGY_InsertOnly N'Image'                                         , N'en-US', null, N'survey_question_type'              , 14, N'Image';
exec dbo.spTERMINOLOGY_InsertOnly N'Date'                                          , N'en-US', null, N'survey_question_type'              , 15, N'Date/Time';
exec dbo.spTERMINOLOGY_InsertOnly N'Demographic'                                   , N'en-US', null, N'survey_question_type'              , 16, N'Demographic';
-- 10/08/2014 Paul.  Add Range question type. 
exec dbo.spTERMINOLOGY_InsertOnly N'Range'                                         , N'en-US', null, N'survey_question_type'              , 17, N'Range';
-- 11/07/2018 Paul.  Provide a way to get a single numerical value for lead population.
exec dbo.spTERMINOLOGY_InsertOnly N'Single Numerical'                              , N'en-US', null, N'survey_question_type'              , 18, N'Single Numerical';
-- 11/07/2018 Paul.  Provide a way to get a single date for lead population.
exec dbo.spTERMINOLOGY_InsertOnly N'Single Date'                                   , N'en-US', null, N'survey_question_type'              , 19, N'Single Date';
-- 11/10/2018 Paul.  Provide a way to get a single checkbox for lead population.
exec dbo.spTERMINOLOGY_InsertOnly N'Single Checkbox'                               , N'en-US', null, N'survey_question_type'              , 20, N'Single Checkbox';
-- 11/10/2018 Paul.  Provide a way to get a hidden value for lead population.
exec dbo.spTERMINOLOGY_InsertOnly N'Hidden'                                        , N'en-US', null, N'survey_question_type'              , 21, N'Hidden';


-- delete from TERMINOLOGY where LIST_NAME = 'survey_question_format';
exec dbo.spTERMINOLOGY_InsertOnly N'1'                                             , N'en-US', null, N'survey_question_format'            ,  1, N'1 column';
exec dbo.spTERMINOLOGY_InsertOnly N'2'                                             , N'en-US', null, N'survey_question_format'            ,  2, N'2 columns';
exec dbo.spTERMINOLOGY_InsertOnly N'3'                                             , N'en-US', null, N'survey_question_format'            ,  3, N'3 columns';
exec dbo.spTERMINOLOGY_InsertOnly N'horizontal'                                    , N'en-US', null, N'survey_question_format'            ,  4, N'Horizontal';
--exec dbo.spTERMINOLOGY_InsertOnly N'dropdown'                                      , N'en-US', null, N'survey_question_format'            ,  5, N'Drop-down Menu';
-- 10/08/2014 Paul.  Add Range question type. 
exec dbo.spTERMINOLOGY_InsertOnly N'horizontal'                                    , N'en-US', null, N'survey_question_range_format'      ,  1, N'Horizontal';
exec dbo.spTERMINOLOGY_InsertOnly N'vertical'                                      , N'en-US', null, N'survey_question_range_format'      ,  2, N'Vertical';


exec dbo.spTERMINOLOGY_InsertOnly N'Percent'                                       , N'en-US', null, N'survey_question_width_units'       ,  1, N'Percent';
exec dbo.spTERMINOLOGY_InsertOnly N'Fixed'                                         , N'en-US', null, N'survey_question_width_units'       ,  2, N'Fixed';

exec dbo.spTERMINOLOGY_InsertOnly N'100%'                                          , N'en-US', null, N'survey_question_width_percent'     ,  1, N'100%';
exec dbo.spTERMINOLOGY_InsertOnly N'90%'                                           , N'en-US', null, N'survey_question_width_percent'     ,  2, N'90%';
exec dbo.spTERMINOLOGY_InsertOnly N'80%'                                           , N'en-US', null, N'survey_question_width_percent'     ,  3, N'80%';
exec dbo.spTERMINOLOGY_InsertOnly N'70%'                                           , N'en-US', null, N'survey_question_width_percent'     ,  4, N'70%';
exec dbo.spTERMINOLOGY_InsertOnly N'60%'                                           , N'en-US', null, N'survey_question_width_percent'     ,  5, N'60%';
exec dbo.spTERMINOLOGY_InsertOnly N'50%'                                           , N'en-US', null, N'survey_question_width_percent'     ,  6, N'50%';
exec dbo.spTERMINOLOGY_InsertOnly N'40%'                                           , N'en-US', null, N'survey_question_width_percent'     ,  7, N'40%';
exec dbo.spTERMINOLOGY_InsertOnly N'30%'                                           , N'en-US', null, N'survey_question_width_percent'     ,  8, N'30%';
exec dbo.spTERMINOLOGY_InsertOnly N'20%'                                           , N'en-US', null, N'survey_question_width_percent'     ,  9, N'20%';
exec dbo.spTERMINOLOGY_InsertOnly N'10%'                                           , N'en-US', null, N'survey_question_width_percent'     , 10, N'10%';

exec dbo.spTERMINOLOGY_InsertOnly N'100px'                                         , N'en-US', null, N'survey_question_width_fixed'       ,  1, N'100 pixels';
exec dbo.spTERMINOLOGY_InsertOnly N'200px'                                         , N'en-US', null, N'survey_question_width_fixed'       ,  2, N'200 pixels';
exec dbo.spTERMINOLOGY_InsertOnly N'300px'                                         , N'en-US', null, N'survey_question_width_fixed'       ,  3, N'300 pixels';
exec dbo.spTERMINOLOGY_InsertOnly N'400px'                                         , N'en-US', null, N'survey_question_width_fixed'       ,  4, N'400 pixels';
exec dbo.spTERMINOLOGY_InsertOnly N'500px'                                         , N'en-US', null, N'survey_question_width_fixed'       ,  5, N'500 pixels';
exec dbo.spTERMINOLOGY_InsertOnly N'600px'                                         , N'en-US', null, N'survey_question_width_fixed'       ,  6, N'600 pixels';
exec dbo.spTERMINOLOGY_InsertOnly N'700px'                                         , N'en-US', null, N'survey_question_width_fixed'       ,  7, N'700 pixels';
exec dbo.spTERMINOLOGY_InsertOnly N'800px'                                         , N'en-US', null, N'survey_question_width_fixed'       ,  8, N'800 pixels';

exec dbo.spTERMINOLOGY_InsertOnly N'10'                                            , N'en-US', null, N'survey_question_columns_width'     ,  1, N'10% label / 90% value';
exec dbo.spTERMINOLOGY_InsertOnly N'20'                                            , N'en-US', null, N'survey_question_columns_width'     ,  2, N'20% label / 80% value';
exec dbo.spTERMINOLOGY_InsertOnly N'30'                                            , N'en-US', null, N'survey_question_columns_width'     ,  3, N'30% label / 70% value';
exec dbo.spTERMINOLOGY_InsertOnly N'40'                                            , N'en-US', null, N'survey_question_columns_width'     ,  4, N'40% label / 60% value';
exec dbo.spTERMINOLOGY_InsertOnly N'50'                                            , N'en-US', null, N'survey_question_columns_width'     ,  5, N'50% label / 50% value';
exec dbo.spTERMINOLOGY_InsertOnly N'60'                                            , N'en-US', null, N'survey_question_columns_width'     ,  6, N'60% label / 40% value';
exec dbo.spTERMINOLOGY_InsertOnly N'70'                                            , N'en-US', null, N'survey_question_columns_width'     ,  7, N'70% label / 30% value';
exec dbo.spTERMINOLOGY_InsertOnly N'80'                                            , N'en-US', null, N'survey_question_columns_width'     ,  8, N'80% label / 20% value';
exec dbo.spTERMINOLOGY_InsertOnly N'90'                                            , N'en-US', null, N'survey_question_columns_width'     ,  9, N'90% label / 10% value';
exec dbo.spTERMINOLOGY_InsertOnly N'100'                                           , N'en-US', null, N'survey_question_columns_width'     , 10, N'Stacked';

exec dbo.spTERMINOLOGY_InsertOnly N''                                              , N'en-US', null, N'survey_question_validation'        ,  0, N'No validation';
exec dbo.spTERMINOLOGY_InsertOnly N'Specific Length'                               , N'en-US', null, N'survey_question_validation'        ,  1, N'Specific length';
exec dbo.spTERMINOLOGY_InsertOnly N'Integer'                                       , N'en-US', null, N'survey_question_validation'        ,  2, N'Integer';
exec dbo.spTERMINOLOGY_InsertOnly N'Decimal'                                       , N'en-US', null, N'survey_question_validation'        ,  3, N'Decimal';
exec dbo.spTERMINOLOGY_InsertOnly N'Date'                                          , N'en-US', null, N'survey_question_validation'        ,  4, N'Date';
exec dbo.spTERMINOLOGY_InsertOnly N'Email'                                         , N'en-US', null, N'survey_question_validation'        ,  5, N'Email';

-- 11/07/2018 Paul.  Provide a way to get a single numerical value for lead population.
exec dbo.spTERMINOLOGY_InsertOnly N''                                              , N'en-US', null, N'survey_question_validation_numerical',  0, N'No validation';
exec dbo.spTERMINOLOGY_InsertOnly N'Integer'                                       , N'en-US', null, N'survey_question_validation_numerical',  1, N'Integer';
exec dbo.spTERMINOLOGY_InsertOnly N'Decimal'                                       , N'en-US', null, N'survey_question_validation_numerical',  2, N'Decimal';
-- 11/07/2018 Paul.  Provide a way to get a single date for lead population.
exec dbo.spTERMINOLOGY_InsertOnly N''                                              , N'en-US', null, N'survey_question_validation_date'     ,  0, N'No validation';
exec dbo.spTERMINOLOGY_InsertOnly N'Date'                                          , N'en-US', null, N'survey_question_validation_date'     ,  1, N'Date';

exec dbo.spTERMINOLOGY_InsertOnly N'1'                                             , N'en-US', null, N'survey_question_menu_choices'      ,  1, N'1 menu';
exec dbo.spTERMINOLOGY_InsertOnly N'2'                                             , N'en-US', null, N'survey_question_menu_choices'      ,  2, N'2 menus';
exec dbo.spTERMINOLOGY_InsertOnly N'3'                                             , N'en-US', null, N'survey_question_menu_choices'      ,  3, N'3 menus';
exec dbo.spTERMINOLOGY_InsertOnly N'4'                                             , N'en-US', null, N'survey_question_menu_choices'      ,  4, N'4 menus';
exec dbo.spTERMINOLOGY_InsertOnly N'5'                                             , N'en-US', null, N'survey_question_menu_choices'      ,  5, N'5 menus';
exec dbo.spTERMINOLOGY_InsertOnly N'6'                                             , N'en-US', null, N'survey_question_menu_choices'      ,  6, N'6 menus';
exec dbo.spTERMINOLOGY_InsertOnly N'7'                                             , N'en-US', null, N'survey_question_menu_choices'      ,  7, N'7 menus';
exec dbo.spTERMINOLOGY_InsertOnly N'8'                                             , N'en-US', null, N'survey_question_menu_choices'      ,  8, N'8 menus';
exec dbo.spTERMINOLOGY_InsertOnly N'9'                                             , N'en-US', null, N'survey_question_menu_choices'      ,  9, N'9 menus';

exec dbo.spTERMINOLOGY_InsertOnly N'2'                                             , N'en-US', null, N'survey_question_ratings_scale'     ,  2, N'2 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'3'                                             , N'en-US', null, N'survey_question_ratings_scale'     ,  3, N'3 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'4'                                             , N'en-US', null, N'survey_question_ratings_scale'     ,  4, N'4 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'5'                                             , N'en-US', null, N'survey_question_ratings_scale'     ,  5, N'5 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'6'                                             , N'en-US', null, N'survey_question_ratings_scale'     ,  6, N'6 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'7'                                             , N'en-US', null, N'survey_question_ratings_scale'     ,  7, N'7 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'8'                                             , N'en-US', null, N'survey_question_ratings_scale'     ,  8, N'8 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'9'                                             , N'en-US', null, N'survey_question_ratings_scale'     ,  9, N'9 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'10'                                            , N'en-US', null, N'survey_question_ratings_scale'     , 10, N'10 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'11'                                            , N'en-US', null, N'survey_question_ratings_scale'     , 11, N'11 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'12'                                            , N'en-US', null, N'survey_question_ratings_scale'     , 12, N'12 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'13'                                            , N'en-US', null, N'survey_question_ratings_scale'     , 13, N'13 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'14'                                            , N'en-US', null, N'survey_question_ratings_scale'     , 14, N'14 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'15'                                            , N'en-US', null, N'survey_question_ratings_scale'     , 15, N'15 ratings';
exec dbo.spTERMINOLOGY_InsertOnly N'16'                                            , N'en-US', null, N'survey_question_ratings_scale'     , 16, N'16 ratings';


exec dbo.spTERMINOLOGY_InsertOnly N'Single Line'                                   , N'en-US', null, N'survey_question_field_size'        ,  1, N'Single line';
exec dbo.spTERMINOLOGY_InsertOnly N'Paragraph'                                     , N'en-US', null, N'survey_question_field_size'        ,  2, N'Paragraph';

-- delete from TERMINOLOGY where LIST_NAME = 'survey_question_field_lines';
exec dbo.spTERMINOLOGY_InsertOnly N'1'                                             , N'en-US', null, N'survey_question_field_lines'       ,  1, N'1 row';
exec dbo.spTERMINOLOGY_InsertOnly N'2'                                             , N'en-US', null, N'survey_question_field_lines'       ,  2, N'2 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'3'                                             , N'en-US', null, N'survey_question_field_lines'       ,  3, N'3 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'4'                                             , N'en-US', null, N'survey_question_field_lines'       ,  4, N'4 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'5'                                             , N'en-US', null, N'survey_question_field_lines'       ,  5, N'5 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'6'                                             , N'en-US', null, N'survey_question_field_lines'       ,  6, N'6 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'7'                                             , N'en-US', null, N'survey_question_field_lines'       ,  7, N'7 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'8'                                             , N'en-US', null, N'survey_question_field_lines'       ,  8, N'8 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'9'                                             , N'en-US', null, N'survey_question_field_lines'       ,  9, N'9 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'10'                                            , N'en-US', null, N'survey_question_field_lines'       , 10, N'10 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'11'                                            , N'en-US', null, N'survey_question_field_lines'       , 11, N'11 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'12'                                            , N'en-US', null, N'survey_question_field_lines'       , 12, N'12 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'13'                                            , N'en-US', null, N'survey_question_field_lines'       , 13, N'13 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'14'                                            , N'en-US', null, N'survey_question_field_lines'       , 14, N'14 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'15'                                            , N'en-US', null, N'survey_question_field_lines'       , 15, N'15 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'16'                                            , N'en-US', null, N'survey_question_field_lines'       , 16, N'16 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'17'                                            , N'en-US', null, N'survey_question_field_lines'       , 17, N'17 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'18'                                            , N'en-US', null, N'survey_question_field_lines'       , 18, N'18 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'19'                                            , N'en-US', null, N'survey_question_field_lines'       , 19, N'19 rows';
exec dbo.spTERMINOLOGY_InsertOnly N'20'                                            , N'en-US', null, N'survey_question_field_lines'       , 20, N'20 rows';

-- delete from TERMINOLOGY where LIST_NAME = 'survey_question_field_chars';
exec dbo.spTERMINOLOGY_InsertOnly N'10'                                            , N'en-US', null, N'survey_question_field_chars'       ,  1, N'10 cols';
exec dbo.spTERMINOLOGY_InsertOnly N'20'                                            , N'en-US', null, N'survey_question_field_chars'       ,  2, N'20 cols';
exec dbo.spTERMINOLOGY_InsertOnly N'30'                                            , N'en-US', null, N'survey_question_field_chars'       ,  3, N'30 cols';
exec dbo.spTERMINOLOGY_InsertOnly N'40'                                            , N'en-US', null, N'survey_question_field_chars'       ,  4, N'40 cols';
exec dbo.spTERMINOLOGY_InsertOnly N'50'                                            , N'en-US', null, N'survey_question_field_chars'       ,  5, N'50 cols';
exec dbo.spTERMINOLOGY_InsertOnly N'60'                                            , N'en-US', null, N'survey_question_field_chars'       ,  6, N'60 cols';
exec dbo.spTERMINOLOGY_InsertOnly N'70'                                            , N'en-US', null, N'survey_question_field_chars'       ,  7, N'70 cols';
exec dbo.spTERMINOLOGY_InsertOnly N'80'                                            , N'en-US', null, N'survey_question_field_chars'       ,  8, N'80 cols';
exec dbo.spTERMINOLOGY_InsertOnly N'90'                                            , N'en-US', null, N'survey_question_field_chars'       ,  9, N'90 cols';
exec dbo.spTERMINOLOGY_InsertOnly N'100'                                           , N'en-US', null, N'survey_question_field_chars'       , 10, N'100 cols';

-- 08/07/2018 Paul.  Required Type of blank means to use the existing bValid flag. 
exec dbo.spTERMINOLOGY_InsertOnly null                                             , N'en-US', null, N'survey_question_required_rows'     ,  0, null;
exec dbo.spTERMINOLOGY_InsertOnly N'All'                                           , N'en-US', null, N'survey_question_required_rows'     ,  1, N'All';
exec dbo.spTERMINOLOGY_InsertOnly N'At Least'                                      , N'en-US', null, N'survey_question_required_rows'     ,  2, N'At Least';
exec dbo.spTERMINOLOGY_InsertOnly N'At Most'                                       , N'en-US', null, N'survey_question_required_rows'     ,  3, N'At Most';
exec dbo.spTERMINOLOGY_InsertOnly N'Exactly'                                       , N'en-US', null, N'survey_question_required_rows'     ,  4, N'Exactly';
exec dbo.spTERMINOLOGY_InsertOnly N'Range'                                         , N'en-US', null, N'survey_question_required_rows'     ,  5, N'Range';

-- delete from TERMINOLOGY where LIST_NAME = 'survey_question_date_format';
exec dbo.spTERMINOLOGY_InsertOnly N'Date'                                          , N'en-US', null, N'survey_question_date_format'       ,  1, N'Date Only';
exec dbo.spTERMINOLOGY_InsertOnly N'Time'                                          , N'en-US', null, N'survey_question_date_format'       ,  2, N'Time Only';
exec dbo.spTERMINOLOGY_InsertOnly N'DateTime'                                      , N'en-US', null, N'survey_question_date_format'       ,  3, N'Date/Time';

-- 01/01/2016 Paul.  Catalin wants to force page navigation for each question, just like mobile navigation. 
-- delete from TERMINOLOGY where LIST_NAME = 'survey_style';
exec dbo.spTERMINOLOGY_InsertOnly N'One Question Per Page'                         , N'en-US', null, N'survey_style_dom'                  ,  1, N'One Question Per Page';

-- 01/02/2016 Paul.  We need a combined format list. 
exec dbo.spTERMINOLOGY_InsertOnly N'1'                                             , N'en-US', null, N'survey_question_format_all'        ,  1, N'1 column';
exec dbo.spTERMINOLOGY_InsertOnly N'2'                                             , N'en-US', null, N'survey_question_format_all'        ,  2, N'2 columns';
exec dbo.spTERMINOLOGY_InsertOnly N'3'                                             , N'en-US', null, N'survey_question_format_all'        ,  3, N'3 columns';
exec dbo.spTERMINOLOGY_InsertOnly N'horizontal'                                    , N'en-US', null, N'survey_question_format_all'        ,  4, N'Horizontal';
exec dbo.spTERMINOLOGY_InsertOnly N'horizontal'                                    , N'en-US', null, N'survey_question_format_all'        ,  5, N'Horizontal';
exec dbo.spTERMINOLOGY_InsertOnly N'vertical'                                      , N'en-US', null, N'survey_question_format_all'        ,  6, N'Vertical';
exec dbo.spTERMINOLOGY_InsertOnly N'Date'                                          , N'en-US', null, N'survey_question_format_all'        ,  7, N'Date Only';
exec dbo.spTERMINOLOGY_InsertOnly N'Time'                                          , N'en-US', null, N'survey_question_format_all'        ,  8, N'Time Only';
exec dbo.spTERMINOLOGY_InsertOnly N'DateTime'                                      , N'en-US', null, N'survey_question_format_all'        ,  9, N'Date/Time';
GO

-- 09/30/2018 Paul.  Add survey record creation to survey. 
-- delete from TERMINOLOGY where LIST_NAME = 'survey_target_module_dom';
exec dbo.spTERMINOLOGY_InsertOnly N'Leads'                                         , N'en-US', null, N'survey_target_module_dom'          ,   1, N'Leads';
-- 10/09/2018 Paul.  Prospects and Contacts will not exist on survey CRM. 
if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PROSPECTS_CSTM') begin -- then
	exec dbo.spTERMINOLOGY_InsertOnly N'Prospects'                                     , N'en-US', null, N'survey_target_module_dom'          ,   2, N'Targets';
end -- if;
if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CONTACTS_CSTM') begin -- then
	exec dbo.spTERMINOLOGY_InsertOnly N'Contacts'                                      , N'en-US', null, N'survey_target_module_dom'          ,   3, N'Contacts';
end -- if;
exec dbo.spTERMINOLOGY_InsertOnly N'Accounts'                                      , N'en-US', null, N'survey_target_module_dom'          ,   4, N'Accounts';

-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
exec dbo.spTERMINOLOGY_InsertOnly N'Survey Team'                                   , N'en-US', null, N'survey_target_assignment_dom',  1, N'Survey Team';
exec dbo.spTERMINOLOGY_InsertOnly N'Current User'                                  , N'en-US', null, N'survey_target_assignment_dom',  2, N'Current User/Team';
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

call dbo.spTERMINOLOGY_Surveys_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Surveys_en_us')
/
-- #endif IBM_DB2 */

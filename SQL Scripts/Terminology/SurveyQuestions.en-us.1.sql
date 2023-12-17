

print 'TERMINOLOGY SurveyQuestions en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'SurveyQuestions';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION'                                  , N'en-US', N'SurveyQuestions', null, null, N'Question';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_SIZE'                             , N'en-US', N'SurveyQuestions', null, null, N'Question Size and Placement';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWER_OPTIONS'                            , N'en-US', N'SurveyQuestions', null, null, N'Answer Options';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CHANGE_PAGE'                               , N'en-US', N'SurveyQuestions', null, null, N'Change Page';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWER_CHOICES'                            , N'en-US', N'SurveyQuestions', null, null, N'Answer Choices:';
-- 11/24/2018 Paul.  Place image caption in ANSWER_CHOICES. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMAGE_CAPTION'                             , N'en-US', N'SurveyQuestions', null, null, N'Image Caption:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COLUMN_CHOICES'                            , N'en-US', N'SurveyQuestions', null, null, N'Column Choices:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MENU_CHOICES'                              , N'en-US', N'SurveyQuestions', null, null, N'Menu Choices:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FORCED_RANKING'                            , N'en-US', N'SurveyQuestions', null, null, N'Forced Ranking';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATE_FORMAT'                               , N'en-US', N'SurveyQuestions', null, null, N'Date Format:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISPLAY_FORMAT'                            , N'en-US', N'SurveyQuestions', null, null, N'Display Format:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INVALID_DATE_MESSAGE'                      , N'en-US', N'SurveyQuestions', null, null, N'Invalid date message:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INVALID_DATE_MESSAGE_DEFAULT'              , N'en-US', N'SurveyQuestions', null, null, N'Please enter a valid date.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INVALID_NUMBER_MESSAGE'                    , N'en-US', N'SurveyQuestions', null, null, N'Invalid number message:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INVALID_NUMBER_MESSAGE_DEFAULT'            , N'en-US', N'SurveyQuestions', null, null, N'Please enter a valid number.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'SurveyQuestions', null, null, N'Question Text:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'SurveyQuestions', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NA_ENABLED'                                , N'en-US', N'SurveyQuestions', null, null, N'Add N/A';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NA_LABEL_DEFAULT'                          , N'en-US', N'SurveyQuestions', null, null, N'N/A';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_TYPE'                             , N'en-US', N'SurveyQuestions', null, null, N'Question Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED'                                  , N'en-US', N'SurveyQuestions', null, null, N'Required';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_OPTIONS'                          , N'en-US', N'SurveyQuestions', null, null, N'Required Options';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_TYPE'                             , N'en-US', N'SurveyQuestions', null, null, N'Required Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_RESPONSES_RANGE'                  , N'en-US', N'SurveyQuestions', null, null, N' to ';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_MESSAGE'                          , N'en-US', N'SurveyQuestions', null, null, N'Required error message:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_MESSAGE_DEFAULT'                  , N'en-US', N'SurveyQuestions', null, null, N'Please provide an answer.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_MESSAGE_DEFAULT1'                 , N'en-US', N'SurveyQuestions', null, null, N'Please provide an answer {REQUIRED_TYPE} {0}.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_MESSAGE_DEFAULT2'                 , N'en-US', N'SurveyQuestions', null, null, N'Please provide an answer between {0} and {1}.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RANDOMIZE'                                 , N'en-US', N'SurveyQuestions', null, null, N'Randomize';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RANDOMIZE_TYPE'                            , N'en-US', N'SurveyQuestions', null, null, N'Randomize:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RANDOMIZE_NOT_LAST'                        , N'en-US', N'SurveyQuestions', null, null, N'Last option not randomized.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PLACEMENT'                                 , N'en-US', N'SurveyQuestions', null, null, N'Placement:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SIZE'                                      , N'en-US', N'SurveyQuestions', null, null, N'Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BOX_SIZE'                                  , N'en-US', N'SurveyQuestions', null, null, N'Box Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COLUMN_WIDTH'                              , N'en-US', N'SurveyQuestions', null, null, N'Column Width:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SPACING'                                   , N'en-US', N'SurveyQuestions', null, null, N'Spacing:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SPACING_LEFT'                              , N'en-US', N'SurveyQuestions', null, null, N'Left:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SPACING_TOP'                               , N'en-US', N'SurveyQuestions', null, null, N'Top:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SPACING_RIGHT'                             , N'en-US', N'SurveyQuestions', null, null, N'Right:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SPACING_BOTTOM'                            , N'en-US', N'SurveyQuestions', null, null, N'Bottom:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMAGE_UPLOAD'                              , N'en-US', N'SurveyQuestions', null, null, N'Upload image:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMAGE_URL'                                 , N'en-US', N'SurveyQuestions', null, null, N'Image URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXISTING_IMAGE'                            , N'en-US', N'SurveyQuestions', null, null, N'Existing image:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_ENABLED'                             , N'en-US', N'SurveyQuestions', null, null, N'Add other field:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_LABEL'                               , N'en-US', N'SurveyQuestions', null, null, N'Other Label:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_LABEL_DEFAULT'                       , N'en-US', N'SurveyQuestions', null, null, N'Other (please specify)';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_SIZE'                                , N'en-US', N'SurveyQuestions', null, null, N'Other Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_REQUIRED_MESSAGE_DEFAULT'            , N'en-US', N'SurveyQuestions', null, null, N'Please provide other value.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_AS_CHOICE'                           , N'en-US', N'SurveyQuestions', null, null, N'Use other as choice';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_ONE_PER_ROW'                         , N'en-US', N'SurveyQuestions', null, null, N'One comment per row';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_VALIDATION_TYPE'                     , N'en-US', N'SurveyQuestions', null, null, N'Validation:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_VALIDATION_MESSAGE'                  , N'en-US', N'SurveyQuestions', null, null, N'Validation Message:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_VALIDATION_MESSAGE_DEFAULT'          , N'en-US', N'SurveyQuestions', null, null, N'Please correct the format.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_VALIDATION_MESSAGE_DEFAULT2'         , N'en-US', N'SurveyQuestions', null, null, N'Please specify a value between {0} and {1}.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_ENABLED'                        , N'en-US', N'SurveyQuestions', null, null, N'Validate answer';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_TYPE'                           , N'en-US', N'SurveyQuestions', null, null, N'Validation:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_BETWEEN'                        , N'en-US', N'SurveyQuestions', null, null, N'Between';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_AND'                            , N'en-US', N'SurveyQuestions', null, null, N'and';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_MESSAGE'                        , N'en-US', N'SurveyQuestions', null, null, N'Validate Message:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_MESSAGE_DEFAULT'                , N'en-US', N'SurveyQuestions', null, null, N'The format is invalid.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_MESSAGE_DEFAULT2'               , N'en-US', N'SurveyQuestions', null, null, N'Please specify a value between {0} and {1}.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_SUM_ENABLED'                    , N'en-US', N'SurveyQuestions', null, null, N'Validate sum:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_SUM'                            , N'en-US', N'SurveyQuestions', null, null, N'Sum of choices:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_SUM_MESSAGE'                    , N'en-US', N'SurveyQuestions', null, null, N'Sum of choices:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_SUM_MESSAGE_DEFAULT'            , N'en-US', N'SurveyQuestions', null, null, N'Sum of choices need to add to {0}.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NUMBER_OF_MENUS'                           , N'en-US', N'SurveyQuestions', null, null, N'Number of menus:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RATING_SCALE'                              , N'en-US', N'SurveyQuestions', null, null, N'Rating scale:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RATING_SCALE_CHOICES'                      , N'en-US', N'SurveyQuestions', null, null, N'Rating scale choices and weights:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RATING_SCALE_LABEL'                        , N'en-US', N'SurveyQuestions', null, null, N'Label:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RATING_SCALE_WEIGHT'                       , N'en-US', N'SurveyQuestions', null, null, N'Weight:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MENU_HEADING'                              , N'en-US', N'SurveyQuestions', null, null, N'Menu #{0} Heading:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MENU_OPTIONS'                              , N'en-US', N'SurveyQuestions', null, null, N'Menu #{0} Options:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DEMOGRAPHIC_INFORMATION'                   , N'en-US', N'SurveyQuestions', null, null, N'Demographic Information';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DEMOGRAPHIC_VISIBLE'                       , N'en-US', N'SurveyQuestions', null, null, N'Visible';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DEMOGRAPHIC_REQUIRED'                      , N'en-US', N'SurveyQuestions', null, null, N'Required';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_VALIDATION'                           , N'en-US', N'SurveyQuestions', null, null, N'Test Validation';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'SurveyQuestions', null, null, N'Question Text';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'SurveyQuestions', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_QUESTION_TYPE'                        , N'en-US', N'SurveyQuestions', null, null, N'Question Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_QUESTION_NUMBER'                      , N'en-US', N'SurveyQuestions', null, null, N'Number';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_PAGE_NAME'                     , N'en-US', N'SurveyQuestions', null, null, N'Page Name';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'SurveyQuestions', null, null, N'Survey Question List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_FORM_TITLE'                            , N'en-US', N'SurveyQuestions', null, null, N'Create Survey';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_SURVEY_QUESTION'                       , N'en-US', N'SurveyQuestions', null, null, N'Create Survey Question';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_SURVEY_QUESTION_LIST'                      , N'en-US', N'SurveyQuestions', null, null, N'Survey Questions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'SurveyQuestions', null, null, N'Survey Questions';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'SurveyQuestions', null, null, N'SQ';
-- 10/08/2018 Paul.  Show sample questoin. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SAMPLE'                                    , N'en-US', N'SurveyQuestions', null, null, N'Sample';

exec dbo.spTERMINOLOGY_InsertOnly N'SurveyQuestions'                               , N'en-US', null, N'moduleList'                        , 112, N'Survey Questions';
exec dbo.spTERMINOLOGY_InsertOnly N'SurveyQuestions'                               , N'en-US', null, N'moduleListSingular'                , 112, N'Survey Question';

-- 09/30/2018 Paul.  Include change to first and last name for new installations. 
-- delete from TERMINOLOGY where LIST_NAME = 'survey_question_demographic_fields';
if not exists(select * from TERMINOLOGY where LIST_NAME = 'survey_question_demographic_fields') begin -- then
	exec dbo.spTERMINOLOGY_InsertOnly N'FIRST_NAME'                                    , N'en-US', null, N'survey_question_demographic_fields',  1, N'First Name:';
	exec dbo.spTERMINOLOGY_InsertOnly N'LAST_NAME'                                     , N'en-US', null, N'survey_question_demographic_fields',  2, N'Last Name:';
	exec dbo.spTERMINOLOGY_InsertOnly N'COMPANY'                                       , N'en-US', null, N'survey_question_demographic_fields',  3, N'Company:';
	exec dbo.spTERMINOLOGY_InsertOnly N'ADDRESS1'                                      , N'en-US', null, N'survey_question_demographic_fields',  4, N'Address 1:';
	exec dbo.spTERMINOLOGY_InsertOnly N'ADDRESS2'                                      , N'en-US', null, N'survey_question_demographic_fields',  5, N'Address 2:';
	exec dbo.spTERMINOLOGY_InsertOnly N'CITY'                                          , N'en-US', null, N'survey_question_demographic_fields',  6, N'City:';
	exec dbo.spTERMINOLOGY_InsertOnly N'STATE'                                         , N'en-US', null, N'survey_question_demographic_fields',  7, N'State/Province:';
	exec dbo.spTERMINOLOGY_InsertOnly N'POSTAL_CODE'                                   , N'en-US', null, N'survey_question_demographic_fields',  8, N'Postal Code:';
	exec dbo.spTERMINOLOGY_InsertOnly N'COUNTRY'                                       , N'en-US', null, N'survey_question_demographic_fields',  9, N'Country:';
	exec dbo.spTERMINOLOGY_InsertOnly N'EMAIL_ADDRESS'                                 , N'en-US', null, N'survey_question_demographic_fields', 10, N'Email Address:';
	exec dbo.spTERMINOLOGY_InsertOnly N'PHONE_NUMBER'                                  , N'en-US', null, N'survey_question_demographic_fields', 11, N'Phone Number:';
end -- if;

-- 10/08/2014 Paul.  Add Range question type. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RANGE_OPTIONS'                             , N'en-US', N'SurveyQuestions', null, null, N'Range Options';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RANGE_VALUES'                              , N'en-US', N'SurveyQuestions', null, null, N'Range:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RANGE_BETWEEN'                             , N'en-US', N'SurveyQuestions', null, null, N'Between';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RANGE_AND'                                 , N'en-US', N'SurveyQuestions', null, null, N'and';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RANGE_STEP'                                , N'en-US', N'SurveyQuestions', null, null, N'Step:';

-- 01/01/2016 Paul.  Add categories. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CATEGORIES'                                , N'en-US', N'SurveyQuestions', null, null, N'Categories:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CATEGORIES'                           , N'en-US', N'SurveyQuestions', null, null, N'Categories';

-- 01/02/2016 Paul.  Missing labels used on import page. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NA_LABEL'                                  , N'en-US', N'SurveyQuestions', null, null, N'N/A Label:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_HEIGHT'                              , N'en-US', N'SurveyQuestions', null, null, N'Other Size Rows:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_WIDTH'                               , N'en-US', N'SurveyQuestions', null, null, N'Other Size Columns:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_REQUIRED_MESSAGE'                    , N'en-US', N'SurveyQuestions', null, null, N'Other Required Message:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_VALIDATION_MIN'                      , N'en-US', N'SurveyQuestions', null, null, N'Other Validation Minimum:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OTHER_VALIDATION_MAX'                      , N'en-US', N'SurveyQuestions', null, null, N'Ohter Validation Maximum:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_RESPONSES_MIN'                    , N'en-US', N'SurveyQuestions', null, null, N'Required Responses Minimum:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_RESPONSES_MAX'                    , N'en-US', N'SurveyQuestions', null, null, N'Required Responses Maximum:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_MIN'                            , N'en-US', N'SurveyQuestions', null, null, N'Validation Minimum:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_MAX'                            , N'en-US', N'SurveyQuestions', null, null, N'Validation Maximum:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_NUMERIC_SUM'                    , N'en-US', N'SurveyQuestions', null, null, N'Validation Numeric Sum:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SIZE_WIDTH'                                , N'en-US', N'SurveyQuestions', null, null, N'Size Width:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SIZE_HEIGHT'                               , N'en-US', N'SurveyQuestions', null, null, N'Size Height:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BOX_WIDTH'                                 , N'en-US', N'SurveyQuestions', null, null, N'Box Width:';
-- 09/30/2018 Paul.  Add survey record creation to survey. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TARGET_FIELD_NAME'                         , N'en-US', N'SurveyQuestions', null, null, N'Target Field:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TARGET_FIELD_NAME'                    , N'en-US', N'SurveyQuestions', null, null, N'Target Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TARGET_MODULE'                      , N'en-US', N'SurveyQuestions', null, null, N'Survey Target Module:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_TARGET_MODULE'                 , N'en-US', N'SurveyQuestions', null, null, N'Target Module';
-- 11/09/2018 Paul.  Render actual question. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RENDERING_DATA'                            , N'en-US', N'SurveyQuestions', null, null, N'Rendering data...';
-- 11/30/2019 Paul.  Correct for embedded Test Validation text. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUCCESS'                                   , N'en-US', N'SurveyQuestions', null, null, N'Success:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FAILURE'                                   , N'en-US', N'SurveyQuestions', null, null, N'Failure';
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

call dbo.spTERMINOLOGY_SurveyQuestions_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_SurveyQuestions_en_us')
/
-- #endif IBM_DB2 */

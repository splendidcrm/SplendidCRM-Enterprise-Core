

print 'TERMINOLOGY SurveyThemes en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'SurveyThemes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                   , N'en-US', N'SurveyThemes', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_FONT_FAMILY'                     , N'en-US', N'SurveyThemes', null, null, N'Survey Font Family:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOGO_BACKGROUND'                        , N'en-US', N'SurveyThemes', null, null, N'Logo Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_BACKGROUND'                      , N'en-US', N'SurveyThemes', null, null, N'Survey Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TITLE'                           , N'en-US', N'SurveyThemes', null, null, N'Survey Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TITLE_TEXT_COLOR'                , N'en-US', N'SurveyThemes', null, null, N'Text Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TITLE_FONT_SIZE'                 , N'en-US', N'SurveyThemes', null, null, N'Font Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TITLE_FONT_STYLE'                , N'en-US', N'SurveyThemes', null, null, N'Font Style:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TITLE_FONT_WEIGHT'               , N'en-US', N'SurveyThemes', null, null, N'Font Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TITLE_DECORATION'                , N'en-US', N'SurveyThemes', null, null, N'Text Decoration:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_TITLE_BACKGROUND'                , N'en-US', N'SurveyThemes', null, null, N'Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_TITLE'                             , N'en-US', N'SurveyThemes', null, null, N'Page Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_TITLE_TEXT_COLOR'                  , N'en-US', N'SurveyThemes', null, null, N'Text Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_TITLE_FONT_SIZE'                   , N'en-US', N'SurveyThemes', null, null, N'Font Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_TITLE_FONT_STYLE'                  , N'en-US', N'SurveyThemes', null, null, N'Font Style:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_TITLE_FONT_WEIGHT'                 , N'en-US', N'SurveyThemes', null, null, N'Font Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_TITLE_DECORATION'                  , N'en-US', N'SurveyThemes', null, null, N'Text Decoration:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_TITLE_BACKGROUND'                  , N'en-US', N'SurveyThemes', null, null, N'Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_DESCRIPTION'                       , N'en-US', N'SurveyThemes', null, null, N'Page Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_DESCRIPTION_TEXT_COLOR'            , N'en-US', N'SurveyThemes', null, null, N'Text Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_DESCRIPTION_FONT_SIZE'             , N'en-US', N'SurveyThemes', null, null, N'Font Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_DESCRIPTION_FONT_STYLE'            , N'en-US', N'SurveyThemes', null, null, N'Font Style:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_DESCRIPTION_FONT_WEIGHT'           , N'en-US', N'SurveyThemes', null, null, N'Font Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_DESCRIPTION_DECORATION'            , N'en-US', N'SurveyThemes', null, null, N'Text Decoration:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_DESCRIPTION_BACKGROUND'            , N'en-US', N'SurveyThemes', null, null, N'Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_HEADING'                       , N'en-US', N'SurveyThemes', null, null, N'Question Heading';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_HEADING_TEXT_COLOR'            , N'en-US', N'SurveyThemes', null, null, N'Text Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_HEADING_FONT_SIZE'             , N'en-US', N'SurveyThemes', null, null, N'Font Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_HEADING_FONT_STYLE'            , N'en-US', N'SurveyThemes', null, null, N'Font Style:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_HEADING_FONT_WEIGHT'           , N'en-US', N'SurveyThemes', null, null, N'Font Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_HEADING_DECORATION'            , N'en-US', N'SurveyThemes', null, null, N'Text Decoration:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_HEADING_BACKGROUND'            , N'en-US', N'SurveyThemes', null, null, N'Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_CHOICE'                        , N'en-US', N'SurveyThemes', null, null, N'Question Choice';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_CHOICE_TEXT_COLOR'             , N'en-US', N'SurveyThemes', null, null, N'Text Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_CHOICE_FONT_SIZE'              , N'en-US', N'SurveyThemes', null, null, N'Font Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_CHOICE_FONT_STYLE'             , N'en-US', N'SurveyThemes', null, null, N'Font Style:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_CHOICE_FONT_WEIGHT'            , N'en-US', N'SurveyThemes', null, null, N'Font Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_CHOICE_DECORATION'             , N'en-US', N'SurveyThemes', null, null, N'Text Decoration:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_CHOICE_BACKGROUND'             , N'en-US', N'SurveyThemes', null, null, N'Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR'                           , N'en-US', N'SurveyThemes', null, null, N'Progress Bar';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_PAGE_WIDTH'                , N'en-US', N'SurveyThemes', null, null, N'Page Width:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_COLOR'                     , N'en-US', N'SurveyThemes', null, null, N'Bar Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_BORDER_COLOR'              , N'en-US', N'SurveyThemes', null, null, N'Border Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_BORDER_WIDTH'              , N'en-US', N'SurveyThemes', null, null, N'Border Width:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_TEXT_COLOR'                , N'en-US', N'SurveyThemes', null, null, N'Text Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_FONT_SIZE'                 , N'en-US', N'SurveyThemes', null, null, N'Font Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_FONT_STYLE'                , N'en-US', N'SurveyThemes', null, null, N'Font Style:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_FONT_WEIGHT'               , N'en-US', N'SurveyThemes', null, null, N'Font Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_DECORATION'                , N'en-US', N'SurveyThemes', null, null, N'Text Decoration:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROGRESS_BAR_BACKGROUND'                , N'en-US', N'SurveyThemes', null, null, N'Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERROR'                                  , N'en-US', N'SurveyThemes', null, null, N'Error';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERROR_TEXT_COLOR'                       , N'en-US', N'SurveyThemes', null, null, N'Text Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERROR_FONT_SIZE'                        , N'en-US', N'SurveyThemes', null, null, N'Font Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERROR_FONT_STYLE'                       , N'en-US', N'SurveyThemes', null, null, N'Font Style:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERROR_FONT_WEIGHT'                      , N'en-US', N'SurveyThemes', null, null, N'Font Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERROR_DECORATION'                       , N'en-US', N'SurveyThemes', null, null, N'Text Decoration:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERROR_BACKGROUND'                       , N'en-US', N'SurveyThemes', null, null, N'Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXIT_LINK'                              , N'en-US', N'SurveyThemes', null, null, N'Exit Link';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXIT_LINK_TEXT_COLOR'                   , N'en-US', N'SurveyThemes', null, null, N'Text Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXIT_LINK_FONT_SIZE'                    , N'en-US', N'SurveyThemes', null, null, N'Font Size:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXIT_LINK_FONT_STYLE'                   , N'en-US', N'SurveyThemes', null, null, N'Font Style:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXIT_LINK_FONT_WEIGHT'                  , N'en-US', N'SurveyThemes', null, null, N'Font Weight:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXIT_LINK_DECORATION'                   , N'en-US', N'SurveyThemes', null, null, N'Text Decoration:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXIT_LINK_BACKGROUND'                   , N'en-US', N'SurveyThemes', null, null, N'Background Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUIRED_TEXT_COLOR'                    , N'en-US', N'SurveyThemes', null, null, N'Required Color:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                            , N'en-US', N'SurveyThemes', null, null, N'Description:';
-- 11/12/2018 Paul.  Add custom styles field to allow any style change. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOM_STYLES'                          , N'en-US', N'SurveyThemes', null, null, N'Custom Styles:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_NUMBER'                            , N'en-US', N'SurveyThemes', null, null, N'Page 1';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALIDATION_ERROR'                       , N'en-US', N'SurveyThemes', null, null, N'Validation error.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                              , N'en-US', N'SurveyThemes', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_SURVEY_THEME'                       , N'en-US', N'SurveyThemes', null, null, N'Create Survey Theme';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_SURVEY_THEME_LIST'                      , N'en-US', N'SurveyThemes', null, null, N'Survey Themes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                        , N'en-US', N'SurveyThemes', null, null, N'Survey Themes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                      , N'en-US', N'SurveyThemes', null, null, N'Search';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                    , N'en-US', N'SurveyThemes', null, null, N'ST';
-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_BACKGROUND'                        , N'en-US', N'SurveyThemes', null, null, N'Page Background';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_BACKGROUND_IMAGE'                  , N'en-US', N'SurveyThemes', null, null, N'Background Image:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_BACKGROUND_POSITION'               , N'en-US', N'SurveyThemes', null, null, N'Background Position:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_BACKGROUND_REPEAT'                 , N'en-US', N'SurveyThemes', null, null, N'Background Repeat:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_BACKGROUND_SIZE'                   , N'en-US', N'SurveyThemes', null, null, N'Background Size:';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'SurveyThemes'                               , N'en-US', null, N'moduleList'                            , 111, N'Survey Themes';
exec dbo.spTERMINOLOGY_InsertOnly N'SurveyThemes'                               , N'en-US', null, N'moduleListSingular'                    , 111, N'Survey Theme';

-- delete from TERMINOLOGY where LIST_NAME in ('font_weight_dom', 'font_style_dom', 'text_decoration_dom', 'font_size_dom', 'font_family_dom');
exec dbo.spTERMINOLOGY_InsertOnly N'normal'                                     , N'en-US', null, N'font_weight_dom'                       ,  1, N'normal';
exec dbo.spTERMINOLOGY_InsertOnly N'bold'                                       , N'en-US', null, N'font_weight_dom'                       ,  2, N'bold';
exec dbo.spTERMINOLOGY_InsertOnly N'bolder'                                     , N'en-US', null, N'font_weight_dom'                       ,  3, N'bolder';
exec dbo.spTERMINOLOGY_InsertOnly N'lighter'                                    , N'en-US', null, N'font_weight_dom'                       ,  4, N'lighter';
exec dbo.spTERMINOLOGY_InsertOnly N'100'                                        , N'en-US', null, N'font_weight_dom'                       ,  5, N'100';
exec dbo.spTERMINOLOGY_InsertOnly N'200'                                        , N'en-US', null, N'font_weight_dom'                       ,  6, N'200';
exec dbo.spTERMINOLOGY_InsertOnly N'300'                                        , N'en-US', null, N'font_weight_dom'                       ,  7, N'300';
exec dbo.spTERMINOLOGY_InsertOnly N'400'                                        , N'en-US', null, N'font_weight_dom'                       ,  8, N'400';
exec dbo.spTERMINOLOGY_InsertOnly N'500'                                        , N'en-US', null, N'font_weight_dom'                       ,  9, N'500';
exec dbo.spTERMINOLOGY_InsertOnly N'600'                                        , N'en-US', null, N'font_weight_dom'                       , 10, N'600';
exec dbo.spTERMINOLOGY_InsertOnly N'700'                                        , N'en-US', null, N'font_weight_dom'                       , 11, N'700';
exec dbo.spTERMINOLOGY_InsertOnly N'800'                                        , N'en-US', null, N'font_weight_dom'                       , 12, N'800';
exec dbo.spTERMINOLOGY_InsertOnly N'900'                                        , N'en-US', null, N'font_weight_dom'                       , 13, N'900';
exec dbo.spTERMINOLOGY_InsertOnly N'inherit'                                    , N'en-US', null, N'font_weight_dom'                       , 14, N'inherit';

exec dbo.spTERMINOLOGY_InsertOnly N'normal'                                     , N'en-US', null, N'font_style_dom'                        ,  1, N'normal';
exec dbo.spTERMINOLOGY_InsertOnly N'italic'                                     , N'en-US', null, N'font_style_dom'                        ,  2, N'italic';
exec dbo.spTERMINOLOGY_InsertOnly N'oblique'                                    , N'en-US', null, N'font_style_dom'                        ,  3, N'oblique';
exec dbo.spTERMINOLOGY_InsertOnly N'inherit'                                    , N'en-US', null, N'font_style_dom'                        ,  4, N'inherit';

exec dbo.spTERMINOLOGY_InsertOnly N'none'                                       , N'en-US', null, N'text_decoration_dom'                   ,  1, N'none';
exec dbo.spTERMINOLOGY_InsertOnly N'underline'                                  , N'en-US', null, N'text_decoration_dom'                   ,  2, N'underline';
exec dbo.spTERMINOLOGY_InsertOnly N'overline'                                   , N'en-US', null, N'text_decoration_dom'                   ,  3, N'overline';
exec dbo.spTERMINOLOGY_InsertOnly N'line-through'                               , N'en-US', null, N'text_decoration_dom'                   ,  4, N'line-through';
exec dbo.spTERMINOLOGY_InsertOnly N'inherit'                                    , N'en-US', null, N'text_decoration_dom'                   ,  5, N'inherit';

exec dbo.spTERMINOLOGY_InsertOnly N'inherit'                                    , N'en-US', null, N'font_size_dom'                         ,  0, N'inherit';
exec dbo.spTERMINOLOGY_InsertOnly N'6px'                                        , N'en-US', null, N'font_size_dom'                         ,  1, N'6px';
exec dbo.spTERMINOLOGY_InsertOnly N'7px'                                        , N'en-US', null, N'font_size_dom'                         ,  2, N'7px';
exec dbo.spTERMINOLOGY_InsertOnly N'8px'                                        , N'en-US', null, N'font_size_dom'                         ,  3, N'8px';
exec dbo.spTERMINOLOGY_InsertOnly N'9px'                                        , N'en-US', null, N'font_size_dom'                         ,  4, N'9px';
exec dbo.spTERMINOLOGY_InsertOnly N'10px'                                       , N'en-US', null, N'font_size_dom'                         ,  5, N'10px';
exec dbo.spTERMINOLOGY_InsertOnly N'11px'                                       , N'en-US', null, N'font_size_dom'                         ,  6, N'11px';
exec dbo.spTERMINOLOGY_InsertOnly N'12px'                                       , N'en-US', null, N'font_size_dom'                         ,  7, N'12px';
exec dbo.spTERMINOLOGY_InsertOnly N'14px'                                       , N'en-US', null, N'font_size_dom'                         ,  8, N'14px';
exec dbo.spTERMINOLOGY_InsertOnly N'16px'                                       , N'en-US', null, N'font_size_dom'                         ,  9, N'16px';
exec dbo.spTERMINOLOGY_InsertOnly N'18px'                                       , N'en-US', null, N'font_size_dom'                         , 10, N'18px';
exec dbo.spTERMINOLOGY_InsertOnly N'20px'                                       , N'en-US', null, N'font_size_dom'                         , 11, N'20px';
exec dbo.spTERMINOLOGY_InsertOnly N'24px'                                       , N'en-US', null, N'font_size_dom'                         , 12, N'24px';
exec dbo.spTERMINOLOGY_InsertOnly N'30px'                                       , N'en-US', null, N'font_size_dom'                         , 13, N'30px';

exec dbo.spTERMINOLOGY_InsertOnly N'Arial, Helvetica, sans-serif'               , N'en-US', null, N'font_family_dom'                       ,  1, N'Arial, Helvetica, sans-serif';
exec dbo.spTERMINOLOGY_InsertOnly N'Tahoma, Geneva, sans-serif'                 , N'en-US', null, N'font_family_dom'                       ,  2, N'Tahoma, Geneva, sans-serif';
exec dbo.spTERMINOLOGY_InsertOnly N'Verdana, Geneva, sans-serif'                , N'en-US', null, N'font_family_dom'                       ,  3, N'Verdana, Geneva, sans-serif';
exec dbo.spTERMINOLOGY_InsertOnly N'"Times New Roman", Times, serif'            , N'en-US', null, N'font_family_dom'                       ,  4, N'Times New Roman, Times, serif';
exec dbo.spTERMINOLOGY_InsertOnly N'Georgia, serif'                             , N'en-US', null, N'font_family_dom'                       ,  5, N'Georgia, serif';
exec dbo.spTERMINOLOGY_InsertOnly N'"Courier New", Courier, monospace'          , N'en-US', null, N'font_family_dom'                       ,  6, N'Courier New, Courier, monospace';

-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
-- https://www.w3schools.com/cssref/pr_background-repeat.asp
exec dbo.spTERMINOLOGY_InsertOnly N'repeat'                                     , N'en-US', null, N'page_background_repeat'                ,  1, N'repeat';
exec dbo.spTERMINOLOGY_InsertOnly N'repeat-x'                                   , N'en-US', null, N'page_background_repeat'                ,  2, N'repeat-x';
exec dbo.spTERMINOLOGY_InsertOnly N'repeat-y'                                   , N'en-US', null, N'page_background_repeat'                ,  3, N'repeat-y';
exec dbo.spTERMINOLOGY_InsertOnly N'no-repeat'                                  , N'en-US', null, N'page_background_repeat'                ,  4, N'no-repeat';
exec dbo.spTERMINOLOGY_InsertOnly N'initial'                                    , N'en-US', null, N'page_background_repeat'                ,  5, N'initial';
exec dbo.spTERMINOLOGY_InsertOnly N'inherit'                                    , N'en-US', null, N'page_background_repeat'                ,  6, N'inherit';

-- https://www.w3schools.com/cssref/pr_background-position.asp
exec dbo.spTERMINOLOGY_InsertOnly N'left top'                                   , N'en-US', null, N'page_background_position'              ,  1, N'left top';
exec dbo.spTERMINOLOGY_InsertOnly N'left center'                                , N'en-US', null, N'page_background_position'              ,  2, N'left center';
exec dbo.spTERMINOLOGY_InsertOnly N'left bottom'                                , N'en-US', null, N'page_background_position'              ,  3, N'left bottom';
exec dbo.spTERMINOLOGY_InsertOnly N'right top'                                  , N'en-US', null, N'page_background_position'              ,  4, N'right top';
exec dbo.spTERMINOLOGY_InsertOnly N'right center'                               , N'en-US', null, N'page_background_position'              ,  5, N'right center';
exec dbo.spTERMINOLOGY_InsertOnly N'right bottom'                               , N'en-US', null, N'page_background_position'              ,  6, N'right bottom';
exec dbo.spTERMINOLOGY_InsertOnly N'center top'                                 , N'en-US', null, N'page_background_position'              ,  7, N'center top';
exec dbo.spTERMINOLOGY_InsertOnly N'center center'                              , N'en-US', null, N'page_background_position'              ,  8, N'center center';
exec dbo.spTERMINOLOGY_InsertOnly N'center bottom'                              , N'en-US', null, N'page_background_position'              ,  9, N'center bottom';
exec dbo.spTERMINOLOGY_InsertOnly N'initial'                                    , N'en-US', null, N'page_background_position'              , 10, N'initial';
exec dbo.spTERMINOLOGY_InsertOnly N'inherit'                                    , N'en-US', null, N'page_background_position'              , 11, N'inherit';

-- https://www.w3schools.com/cssref/css3_pr_background-size.asp
exec dbo.spTERMINOLOGY_InsertOnly N'auto'                                       , N'en-US', null, N'page_background_size'                  ,  1, N'auto';
exec dbo.spTERMINOLOGY_InsertOnly N'cover'                                      , N'en-US', null, N'page_background_size'                  ,  2, N'cover';
exec dbo.spTERMINOLOGY_InsertOnly N'contain'                                    , N'en-US', null, N'page_background_size'                  ,  3, N'contain';
exec dbo.spTERMINOLOGY_InsertOnly N'initial'                                    , N'en-US', null, N'page_background_size'                  ,  4, N'initial';
exec dbo.spTERMINOLOGY_InsertOnly N'inherit'                                    , N'en-US', null, N'page_background_size'                  ,  5, N'inherit';
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

call dbo.spTERMINOLOGY_SurveyThemes_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_SurveyThemes_en_us')
/
-- #endif IBM_DB2 */

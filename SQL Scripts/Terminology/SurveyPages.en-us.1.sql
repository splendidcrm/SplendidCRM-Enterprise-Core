

print 'TERMINOLOGY SurveyPages en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'SurveyPages';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_ID'                                 , N'en-US', N'SurveyPages', null, null, N'Survey ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SURVEY_NAME'                               , N'en-US', N'SurveyPages', null, null, N'Survey Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'SurveyPages', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUESTION_RANDOMIZATION'                    , N'en-US', N'SurveyPages', null, null, N'Question Randomization:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_NUMBER'                               , N'en-US', N'SurveyPages', null, null, N'Page Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'SurveyPages', null, null, N'Description:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'SurveyPages', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PAGE_NUMBER'                          , N'en-US', N'SurveyPages', null, null, N'Page';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SURVEY_NAME'                          , N'en-US', N'SurveyPages', null, null, N'Survey';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'SurveyPages', null, null, N'Survey Pages';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'SurveyPages', null, null, N'SP';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_FORM_TITLE'                            , N'en-US', N'SurveyPages', null, null, N'Create Survey Page';

exec dbo.spTERMINOLOGY_InsertOnly N'SurveyPages'                                   , N'en-US', null, N'moduleList'                        , 110, N'Survey Pages';
exec dbo.spTERMINOLOGY_InsertOnly N'SurveyPages'                                   , N'en-US', null, N'moduleListSingular'                , 110, N'Survey Page';
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

call dbo.spTERMINOLOGY_SurveyPages_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_SurveyPages_en_us')
/
-- #endif IBM_DB2 */

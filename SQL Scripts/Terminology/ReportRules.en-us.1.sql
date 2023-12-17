

-- Terminology generated from database [SplendidCRM6_50] on 11/18/2010 11:37:52 PM.
print 'TERMINOLOGY ReportRules en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REPORT_RULES'                              , N'en-US', N'ReportRules', null, null, N'Create rules for use in Reports';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REPORT_RULES_TITLE'                        , N'en-US', N'ReportRules', null, null, N'Report Rules';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREATE_BUTTON_LABEL'                       , N'en-US', N'ReportRules', null, null, N'Create Rule';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'ReportRules', null, null, N'Report Rules';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ROW_LOAD_EVENT_NAME'                       , N'en-US', N'ReportRules', null, null, N'Row-Load Event:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TABLE_LOAD_EVENT_NAME'                     , N'en-US', N'ReportRules', null, null, N'Table-Load Event:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PREVIEW_FILTER'                            , N'en-US', N'ReportRules', null, null, N'Preview Filter';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PREVIEW_RULES'                             , N'en-US', N'ReportRules', null, null, N'Preview Rules';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUBMIT_RULES'                              , N'en-US', N'ReportRules', null, null, N'Submit Rules';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WIZARD_STEP1'                              , N'en-US', N'ReportRules', null, null, N'1. Module';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WIZARD_STEP2'                              , N'en-US', N'ReportRules', null, null, N'2. Module Filter';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WIZARD_STEP3'                              , N'en-US', N'ReportRules', null, null, N'3. Rule Definitions';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WIZARD_STEP4'                              , N'en-US', N'ReportRules', null, null, N'4. Results';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_RULES'                                     , N'en-US', N'ReportRules', null, null, N'Report Rules';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'ReportRules', null, null, N'RpR';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'ReportRules'                                   , N'en-US', null, N'moduleList'                        , 102, N'Report Rules';
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

call dbo.spTERMINOLOGY_ReportRules_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_ReportRules_en_us')
/
-- #endif IBM_DB2 */

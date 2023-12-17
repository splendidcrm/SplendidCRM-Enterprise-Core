

-- Terminology generated from database [SplendidCRM6_50] on 11/18/2010 11:38:02 PM.
print 'TERMINOLOGY WorkflowAlertTemplates en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BASE_MODULE'                               , N'en-US', N'WorkflowAlertTemplates', null, null, N'Base Module:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BODY'                                      , N'en-US', N'WorkflowAlertTemplates', null, null, N'Body:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BODY_HTML'                                 , N'en-US', N'WorkflowAlertTemplates', null, null, N'Body:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'WorkflowAlertTemplates', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FROM_ADDR'                                 , N'en-US', N'WorkflowAlertTemplates', null, null, N'From Email Address:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FROM_NAME'                                 , N'en-US', N'WorkflowAlertTemplates', null, null, N'From Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSERT'                                    , N'en-US', N'WorkflowAlertTemplates', null, null, N'Insert';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSERT_VARIABLE'                           , N'en-US', N'WorkflowAlertTemplates', null, null, N'Insert Variable:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LINK_TO_RECORD'                            , N'en-US', N'WorkflowAlertTemplates', null, null, N'Link To Record';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BASE_MODULE'                          , N'en-US', N'WorkflowAlertTemplates', null, null, N'Base Module';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BODY'                                 , N'en-US', N'WorkflowAlertTemplates', null, null, N'Body';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BODY_HTML'                            , N'en-US', N'WorkflowAlertTemplates', null, null, N'Body';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'WorkflowAlertTemplates', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'WorkflowAlertTemplates', null, null, N'Workflow Alert Templates';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FROM_ADDR'                            , N'en-US', N'WorkflowAlertTemplates', null, null, N'From Email';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FROM_NAME'                            , N'en-US', N'WorkflowAlertTemplates', null, null, N'From Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'WorkflowAlertTemplates', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SUBJECT'                              , N'en-US', N'WorkflowAlertTemplates', null, null, N'Subject';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'WorkflowAlertTemplates', null, null, N'Alert Templates';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'WorkflowAlertTemplates', null, null, N'WAt';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'WorkflowAlertTemplates', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RELATED_MODULE'                            , N'en-US', N'WorkflowAlertTemplates', null, null, N'Related Module:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SUBJECT'                                   , N'en-US', N'WorkflowAlertTemplates', null, null, N'Subject:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WORKFLOW_ALERT_TEMPLATES'                  , N'en-US', N'Administration', null, null, N'Manage Workflow Alert Templates';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WORKFLOW_ALERT_TEMPLATES_TITLE'            , N'en-US', N'Administration', null, null, N'Workflow Alert Templates';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'WorkflowAlertTemplates'                        , N'en-US', null, N'moduleList'                        ,  62, N'Workflow Alert Templates';
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

call dbo.spTERMINOLOGY_WorkflowAlertTemplates_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_WorkflowAlertTemplates_en_us')
/
-- #endif IBM_DB2 */

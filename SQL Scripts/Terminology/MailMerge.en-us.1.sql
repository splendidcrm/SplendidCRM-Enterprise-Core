

-- Terminology generated from database [SplendidCRM6_50] on 11/18/2010 11:37:52 PM.
print 'TERMINOLOGY MailMerge en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MAIL_MERGE'                                , N'en-US', null, null, null, N'Mail Merge';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'MailMerge', null, null, N'Mail Merge';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INSTRUCTIONS'                              , N'en-US', N'MailMerge', null, null, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SELECT_TEMPLATE'                           , N'en-US', N'MailMerge', null, null, N'Select Template:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SELECTED_MODULE'                           , N'en-US', N'MailMerge', null, null, N'Selected Module:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SECONDARY_MODULE'                          , N'en-US', N'MailMerge', null, null, N'Secondary Module:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'MailMerge', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MODULE_NAME'                          , N'en-US', N'MailMerge', null, null, N'Module Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SECONDARY_NAME'                       , N'en-US', N'MailMerge', null, null, N'Secondary';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GENERATE_BUTTON'                           , N'en-US', N'MailMerge', null, null, N'Generate';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'MailMerge', null, null, N'MM';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'MailMerge'                                 , N'en-US', null, N'moduleList'                        , 102, N'Mail Merge';
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

call dbo.spTERMINOLOGY_MailMerge_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_MailMerge_en_us')
/
-- #endif IBM_DB2 */

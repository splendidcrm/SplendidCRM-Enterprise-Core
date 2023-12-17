

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:42 AM.
print 'TERMINOLOGY TeamNotices en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATE_END'                                  , N'en-US', N'TeamNotices', null, null, N'End Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATE_START'                                , N'en-US', N'TeamNotices', null, null, N'Start Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'TeamNotices', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DATE_END'                             , N'en-US', N'TeamNotices', null, null, N'End Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DATE_START'                           , N'en-US', N'TeamNotices', null, null, N'Start Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'TeamNotices', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'TeamNotices', null, null, N'Team Notice List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'TeamNotices', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'TeamNotices', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TEAM'                                 , N'en-US', N'TeamNotices', null, null, N'Team';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_URL'                                  , N'en-US', N'TeamNotices', null, null, N'URL';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_URL_TITLE'                            , N'en-US', N'TeamNotices', null, null, N'Url Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'TeamNotices', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'TeamNotices', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEAM'                                      , N'en-US', N'TeamNotices', null, null, N'Team:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEAMS'                                     , N'en-US', N'TeamNotices', null, null, N'Teams';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_URL'                                       , N'en-US', N'TeamNotices', null, null, N'URL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_URL_TITLE'                                 , N'en-US', N'TeamNotices', null, null, N'Url Title:';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_TEAM_NOTICE'                           , N'en-US', N'TeamNotices', null, null, N'Create Team Notice';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_TEAM_NOTICE_LIST'                          , N'en-US', N'TeamNotices', null, null, N'Team Notices';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'TeamNotices', null, null, N'TN';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'TeamNotices'                                   , N'en-US', null, N'moduleList'                        ,  45, N'TeamNotices';

exec dbo.spTERMINOLOGY_InsertOnly N'Visible'                                       , N'en-US', null, N'team_notice_status_dom'            ,   1, N'Visible';
exec dbo.spTERMINOLOGY_InsertOnly N'Hidden'                                        , N'en-US', null, N'team_notice_status_dom'            ,   2, N'Hidden';
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

call dbo.spTERMINOLOGY_TeamNotices_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_TeamNotices_en_us')
/
-- #endif IBM_DB2 */

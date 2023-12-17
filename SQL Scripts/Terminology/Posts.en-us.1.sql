

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:40 AM.
print 'TERMINOLOGY Posts en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CATEGORY'                                  , N'en-US', N'Posts', null, null, N'Category:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'Posts', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION_HTML'                          , N'en-US', N'Posts', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CATEGORY'                             , N'en-US', N'Posts', null, null, N'Category';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'Posts', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION_HTML'                     , N'en-US', N'Posts', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Posts', null, null, N'Post List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_THREAD'                               , N'en-US', N'Posts', null, null, N'Parent Thread';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_THREAD_ID'                            , N'en-US', N'Posts', null, null, N'Thread ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_THREAD_TITLE'                         , N'en-US', N'Posts', null, null, N'Thread Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_THREADANDPOSTCOUNT'                   , N'en-US', N'Posts', null, null, N'Posts';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_THREADCOUNT'                          , N'en-US', N'Posts', null, null, N'Threads';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TITLE'                                , N'en-US', N'Posts', null, null, N'Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'Posts', null, null, N'Posts';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Posts', null, null, N'Pos';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REPLIES_LIST'                              , N'en-US', N'Posts', null, null, N'Replies to Thread';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REPLY_PREFIX'                              , N'en-US', N'Posts', null, null, N'RE: ';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_THREAD_ID'                                 , N'en-US', N'Posts', null, null, N'Thread ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_THREAD_TITLE'                              , N'en-US', N'Posts', null, null, N'Thread Title:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_THREADANDPOSTCOUNT'                        , N'en-US', N'Posts', null, null, N'Posts:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_THREADCOUNT'                               , N'en-US', N'Posts', null, null, N'Threads:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TITLE'                                     , N'en-US', N'Posts', null, null, N'Title:';
exec dbo.spTERMINOLOGY_InsertOnly N'QUOTE_FORMAT'                                  , N'en-US', N'Posts', null, null, N'User ''{0}'' said:';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'Posts'                                         , N'en-US', null, N'moduleList'                        ,  52, N'Posts';
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

call dbo.spTERMINOLOGY_Posts_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Posts_en_us')
/
-- #endif IBM_DB2 */



-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:42 AM.
print 'TERMINOLOGY Threads en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BACK_TO_PARENT'                            , N'en-US', N'Threads', null, null, N'Back To Parent';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION_HTML'                          , N'en-US', N'Threads', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FORUM_ID'                                  , N'en-US', N'Threads', null, null, N'Forum ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FORUM_NAME'                                , N'en-US', N'Threads', null, null, N'Forum Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FORUM_TITLE'                               , N'en-US', N'Threads', null, null, N'Forum Title:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_STICKY'                                 , N'en-US', N'Threads', null, null, N'Is Sticky:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_POST_CREATED_BY'                      , N'en-US', N'Threads', null, null, N'Last Post Created By';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_POST_DATE_MODIFIED'                   , N'en-US', N'Threads', null, null, N'Last Post Date Modified';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_POST_TITLE'                           , N'en-US', N'Threads', null, null, N'Last Post Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION_HTML'                     , N'en-US', N'Threads', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Threads', null, null, N'Thread List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORUM_ID'                             , N'en-US', N'Threads', null, null, N'Forum ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORUM_NAME'                           , N'en-US', N'Threads', null, null, N'Forum Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORUM_TITLE'                          , N'en-US', N'Threads', null, null, N'Forum Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_IS_STICKY'                            , N'en-US', N'Threads', null, null, N'Is Sticky';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_POST_CREATED_BY'                 , N'en-US', N'Threads', null, null, N'Post By';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_POST_TITLE'                      , N'en-US', N'Threads', null, null, N'Last Post';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_POSTCOUNT'                            , N'en-US', N'Threads', null, null, N'Replies';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TITLE'                                , N'en-US', N'Threads', null, null, N'Title';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_VIEW_COUNT'                           , N'en-US', N'Threads', null, null, N'Views';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'Threads', null, null, N'Threads';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Threads', null, null, N'Thr';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_BUTTON_LABEL'                          , N'en-US', N'Threads', null, null, N'Create New Thread';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_BUTTON_TITLE'                          , N'en-US', N'Threads', null, null, N'Create New Thread';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_POSTCOUNT'                                 , N'en-US', N'Threads', null, null, N'Replies:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUOTE_BUTTON_LABEL'                        , N'en-US', N'Threads', null, null, N'Quote';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_QUOTE_BUTTON_TITLE'                        , N'en-US', N'Threads', null, null, N'Quote';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REPLY_BUTTON_LABEL'                        , N'en-US', N'Threads', null, null, N'Reply';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REPLY_BUTTON_TITLE'                        , N'en-US', N'Threads', null, null, N'Reply';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SWITCH_TO_LISTVIEW'                        , N'en-US', N'Threads', null, null, N'Switch To Listview';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SWITCH_TO_THREADED'                        , N'en-US', N'Threads', null, null, N'Switch To Threaded';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TITLE'                                     , N'en-US', N'Threads', null, null, N'Title:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VIEW_COUNT'                                , N'en-US', N'Threads', null, null, N'Views:';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'Threads'                                       , N'en-US', null, N'moduleList'                        ,  51, N'Threads';
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

call dbo.spTERMINOLOGY_Threads_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Threads_en_us')
/
-- #endif IBM_DB2 */



-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:38 AM.
print 'TERMINOLOGY KBTags en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FULL_TAG_NAME'                             , N'en-US', N'KBTags', null, null, N'Full Tag Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'KBTags', null, null, N'Tags';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FULL_TAG_NAME'                        , N'en-US', N'KBTags', null, null, N'Full Tag Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'KBTags', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PARENT_FULL_TAG_NAME'                 , N'en-US', N'KBTags', null, null, N'Parent Full Tag Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PARENT_TAG_ID'                        , N'en-US', N'KBTags', null, null, N'Parent Tag ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PARENT_TAG_NAME'                      , N'en-US', N'KBTags', null, null, N'Parent Tag Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TAG_NAME'                             , N'en-US', N'KBTags', null, null, N'Tag Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'KBTags', null, null, N'Knowledge Base Tags';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'KBTags', null, null, N'KBT';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'KBTags', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_FULL_TAG_NAME'                      , N'en-US', N'KBTags', null, null, N'Parent Full Tag Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_TAG_ID'                             , N'en-US', N'KBTags', null, null, N'Parent Tag ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_TAG_NAME'                           , N'en-US', N'KBTags', null, null, N'Parent Tag Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'KBTags', null, null, N'Tag Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TAG_NAME'                                  , N'en-US', N'KBTags', null, null, N'Tag Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_KBTAG_LIST'                                , N'en-US', N'KBTags', null, null, N'Tags';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_KBTAG'                                 , N'en-US', N'KBTags', null, null, N'Create Tag';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'KBTags'                                        , N'en-US', null, N'moduleList'                        ,  84, N'Tags';
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

call dbo.spTERMINOLOGY_KBTags_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_KBTags_en_us')
/
-- #endif IBM_DB2 */

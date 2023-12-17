

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:38 AM.
print 'TERMINOLOGY KBDocuments en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACTIVE_DATE'                               , N'en-US', N'KBDocuments', null, null, N'Active Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'KBDocuments', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXP_DATE'                                  , N'en-US', N'KBDocuments', null, null, N'Expiration Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HAS_ATTACHMENTS'                           , N'en-US', N'KBDocuments', null, null, N'Has Attachments:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_EXTERNAL_ARTICLE'                       , N'en-US', N'KBDocuments', null, null, N'Is External Article:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_KBDOC_APPROVER_ID'                         , N'en-US', N'KBDocuments', null, null, N'Approver:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_KBDOC_APPROVER_NAME'                       , N'en-US', N'KBDocuments', null, null, N'Approver Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_KBTAG_NAME'                                , N'en-US', N'KBDocuments', null, null, N'Tag Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_KBTAG_SET_LIST'                            , N'en-US', N'KBDocuments', null, null, N'Tag:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ACTIVE_DATE'                          , N'en-US', N'KBDocuments', null, null, N'Active Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'KBDocuments', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_EXP_DATE'                             , N'en-US', N'KBDocuments', null, null, N'Expiration Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'KBDocuments', null, null, N'Articles';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_HAS_ATTACHMENTS'                      , N'en-US', N'KBDocuments', null, null, N'Has Attachments';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_IS_EXTERNAL_ARTICLE'                  , N'en-US', N'KBDocuments', null, null, N'Is External Article';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_KBDOC_APPROVER_ID'                    , N'en-US', N'KBDocuments', null, null, N'Approver';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_KBDOC_APPROVER_NAME'                  , N'en-US', N'KBDocuments', null, null, N'Approver Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_KBTAG_NAME'                           , N'en-US', N'KBDocuments', null, null, N'Tag Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_KBTAG_SET_LIST'                       , N'en-US', N'KBDocuments', null, null, N'Tags';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'KBDocuments', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_REVISION'                             , N'en-US', N'KBDocuments', null, null, N'Revision';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'KBDocuments', null, null, N'Status';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_VIEW_FREQUENCY'                       , N'en-US', N'KBDocuments', null, null, N'View Frequency';
-- 01/24/2018 Paul.  Correct spelling of Frequency. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'KBDocuments' and NAME = 'LBL_LIST_VIEW_FREQUENCY' and DISPLAY_NAME = 'View Frequencey') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME      = 'View Frequency'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       = 'KBDocuments'
	   and NAME              = 'LBL_LIST_VIEW_FREQUENCY'
	   and DISPLAY_NAME      = 'View Frequencey'
	   and DELETED           = 0;
end -- if;

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'KBDocuments', null, null, N'Knowledge Base';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'KBDocuments', null, null, N'KB';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'KBDocuments', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REVISION'                                  , N'en-US', N'KBDocuments', null, null, N'Revision:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'KBDocuments', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_KBDOCUMENT_LIST'                           , N'en-US', N'KBDocuments', null, null, N'Articles';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_DOCUMENT'                              , N'en-US', N'KBDocuments', null, null, N'Create Article';
-- 09/20/2013 Paul.  Add missing term. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEND_EMAIL_BUTTON_LABEL'                   , N'en-US', N'KBDocuments', null, null, N'Send as Email';
-- 10/19/2016 Paul.  Add CONTENT field for Full-Text Searching. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ATTACHMENT'                                , N'en-US', N'KBDocuments', null, null, N'Content:';

-- 01/01/2011 Paul.  Add missing terms. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TAGS'                                      , N'en-US', N'KBDocuments'           , null, null, N'Tags:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TAGS'                                 , N'en-US', N'KBDocuments'           , null, null, N'Tags';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMAGES'                                    , N'en-US', N'KBDocuments'           , null, null, N'Images:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_IMAGES'                               , N'en-US', N'KBDocuments'           , null, null, N'Images';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ATTACHMENTS'                               , N'en-US', N'KBDocuments'           , null, null, N'Attachments:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ATTACHMENTS'                          , N'en-US', N'KBDocuments'           , null, null, N'Attachments';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_KBDOCUMENT_NOT_FOUND'                      , N'en-US', N'KBDocuments'           , null, null, N'Article not found.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADD_FILE'                                  , N'en-US', N'KBDocuments'           , null, null, N'Add Files';

-- 09/26/2017 Paul.  Add Archive access right. 
-- 09/16/2019 Paul.  Fix LNK_ARCHIVED_KBDOCUMENTS. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'KBDocuments' and NAME = 'LNK_ARCHIVED_Quotes') begin -- then
	update TERMINOLOGY
	   set NAME              = 'LNK_ARCHIVED_KBDOCUMENTS'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       = 'KBDocuments'
	   and NAME              = 'LNK_ARCHIVED_Quotes'
	   and DELETED           = 0;
end -- if;
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_ARCHIVED_KBDOCUMENTS'                      , N'en-US', N'KBDocuments', null, null, N'Archived KB Documents';

GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'KBDocuments'                                   , N'en-US', null, N'moduleList'                        ,  83, N'Knowledge Base';
GO

-- 01/01/2011 Paul.  Add missing lists. 
exec dbo.spTERMINOLOGY_InsertOnly N'Draft'                                         , N'en-US', null, N'kbdocument_status_dom',    1, N'Draft';
exec dbo.spTERMINOLOGY_InsertOnly N'Expired'                                       , N'en-US', null, N'kbdocument_status_dom',    2, N'Expired';
exec dbo.spTERMINOLOGY_InsertOnly N'In Review'                                     , N'en-US', null, N'kbdocument_status_dom',    3, N'In Review';
exec dbo.spTERMINOLOGY_InsertOnly N'Published'                                     , N'en-US', null, N'kbdocument_status_dom',    4, N'Published';
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

call dbo.spTERMINOLOGY_KBDocuments_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_KBDocuments_en_us')
/
-- #endif IBM_DB2 */


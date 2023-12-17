

print 'DETAILVIEWS_FIELDS DetailView.Portal';
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME like '%.DetailView.Portal';
--GO

set nocount on;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME like 'Bugs.DetailView.Portal';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Bugs.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Bugs.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Bugs.DetailView.Portal'   , 'Bugs', 'vwBUGS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Portal'   ,  0, 'Bugs.LBL_BUG_NUMBER'              , 'BUG_NUMBER'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Portal'   ,  1, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Portal'   ,  2, 'Bugs.LBL_PRIORITY'                , 'PRIORITY'                         , '{0}'        , 'bug_priority_dom'    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Portal'   ,  3, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Portal'   ,  4, 'Bugs.LBL_STATUS'                  , 'STATUS'                           , '{0}'        , 'bug_status_dom'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Portal'   ,  5, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Portal'   ,  6, 'Bugs.LBL_TYPE'                    , 'TYPE'                             , '{0}'        , 'bug_type_dom'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Portal'   ,  7, 'Bugs.LBL_SOURCE'                  , 'SOURCE'                           , '{0}'        , 'source_dom'          , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Portal'   ,  8, 'Bugs.LBL_PRODUCT_CATEGORY'        , 'PRODUCT_CATEGORY'                 , '{0}'        , 'product_category_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Bugs.DetailView.Portal'   ,  9, 'Bugs.LBL_RESOLUTION'              , 'RESOLUTION'                       , '{0}'        , 'bug_resolution_dom'  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Bugs.DetailView.Portal'   , 10, 'Bugs.LBL_SUBJECT'                 , 'NAME'                             , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Bugs.DetailView.Portal'   , 11, 'TextBox', 'Bugs.LBL_DESCRIPTION'  , 'DESCRIPTION', null, null, null, null, null, 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Bugs.DetailView.Portal'   , 12, 'TextBox', 'Bugs.LBL_WORK_LOG'     , 'WORK_LOG'   , null, null, null, null, null, 3;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME like 'Cases.DetailView.Portal';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Cases.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Cases.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Cases.DetailView.Portal'  , 'Cases', 'vwCASES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Portal'  ,  0, 'Cases.LBL_CASE_NUMBER'            , 'CASE_NUMBER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Portal'  ,  1, '.LBL_ASSIGNED_TO'                 , 'ASSIGNED_TO'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Cases.DetailView.Portal'  ,  2, 'Cases.LBL_PRIORITY'               , 'PRIORITY'                         , '{0}'        , 'case_priority_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Portal'  ,  3, '.LBL_DATE_ENTERED'                , 'DATE_ENTERED'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Cases.DetailView.Portal'  ,  4, 'Cases.LBL_STATUS'                 , 'STATUS'                           , '{0}'        , 'case_status_dom'  , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Portal'  ,  5, 'Cases.LBL_ACCOUNT_NAME'           , 'ACCOUNT_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Cases.DetailView.Portal'  ,  6, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Portal'  ,  7, '.LBL_DATE_MODIFIED'               , 'DATE_MODIFIED'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Cases.DetailView.Portal'  ,  8, 'Cases.LBL_SUBJECT'                , 'NAME'                             , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Cases.DetailView.Portal'  ,  9, 'TextBox', 'Cases.LBL_DESCRIPTION' , 'DESCRIPTION'                      , null, null, null, null, null, 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Cases.DetailView.Portal'  , 10, 'TextBox', 'Cases.LBL_RESOLUTION'  , 'RESOLUTION'                       , null, null, null, null, null, 3;
end -- if;
GO

-- 11/26/2009 Paul.  Remove SYNC_CONTACT as it makes no sense for a portal user to sync to Outlook. 
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME like 'Contacts.DetailView.Portal';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Contacts.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Contacts.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Contacts.DetailView.Portal', 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal',  0, 'Contacts.LBL_NAME'               , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal',  1, 'Contacts.LBL_OFFICE_PHONE'       , 'PHONE_WORK'                       , '{0}'        , null;
--	exec dbo.spDETAILVIEWS_FIELDS_InsButton    'Contacts.DetailView.Portal',  2, null                              , '.LBL_VCARD'                       , 'vCard'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBlank     'Contacts.DetailView.Portal',  2, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal',  3, 'Contacts.LBL_MOBILE_PHONE'       , 'PHONE_MOBILE'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal',  4, 'Contacts.LBL_ACCOUNT_NAME'       , 'ACCOUNT_NAME'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal',  5, 'Contacts.LBL_HOME_PHONE'         , 'PHONE_HOME'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList 'Contacts.DetailView.Portal',  6, 'Contacts.LBL_LEAD_SOURCE'        , 'LEAD_SOURCE'                      , '{0}'        , 'lead_source_dom', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal',  7, 'Contacts.LBL_OTHER_PHONE'        , 'PHONE_OTHER'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal',  8, 'Contacts.LBL_TITLE'              , 'TITLE'                            , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal',  9, 'Contacts.LBL_FAX_PHONE'          , 'PHONE_FAX'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 10, 'Contacts.LBL_DEPARTMENT'         , 'DEPARTMENT'                       , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.Portal', 11, 'Contacts.LBL_EMAIL_ADDRESS'      , 'EMAIL1'                           , '{0}'        , 'EMAIL1'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 12, 'Contacts.LBL_BIRTHDATE'          , 'BIRTHDATE'                        , '{0:d}'      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Contacts.DetailView.Portal', 13, 'Contacts.LBL_OTHER_EMAIL_ADDRESS', 'EMAIL2'                           , '{0}'        , 'EMAIL2'              , 'mailto:{0}'                 , null, null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 14, 'Contacts.LBL_ASSISTANT'          , 'ASSISTANT'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 15, 'Contacts.LBL_ASSISTANT_PHONE'    , 'ASSISTANT_PHONE'                  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Contacts.DetailView.Portal', 16, 'Contacts.LBL_DO_NOT_CALL'        , 'DO_NOT_CALL'                      , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox  'Contacts.DetailView.Portal', 17, 'Contacts.LBL_EMAIL_OPT_OUT'      , 'EMAIL_OPT_OUT'                    , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 18, 'Teams.LBL_TEAM'                  , 'TEAM_NAME'                        , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 19, '.LBL_DATE_MODIFIED'              , 'DATE_MODIFIED .LBL_BY MODIFIED_BY', '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 20, '.LBL_ASSIGNED_TO'                , 'ASSIGNED_TO'                      , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 21, '.LBL_DATE_ENTERED'               , 'DATE_ENTERED .LBL_BY CREATED_BY'  , '{0} {1} {2}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 22, 'Contacts.LBL_PRIMARY_ADDRESS'    , 'PRIMARY_ADDRESS_HTML'             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Contacts.DetailView.Portal', 23, 'Contacts.LBL_ALTERNATE_ADDRESS'  , 'ALT_ADDRESS_HTML'                 , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Contacts.DetailView.Portal', 24, 'TextBox', 'Contacts.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME like 'Notes.DetailView.Portal';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Notes.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Notes.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'Notes.DetailView.Portal'   , 'Notes', 'vwNOTES_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Notes.DetailView.Portal'   ,  0, 'Notes.LBL_SUBJECT'               , 'NAME'                             , '{0}'        , 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Notes.DetailView.Portal'   ,  1, '.LBL_DATE_ENTERED'               , 'DATE_ENTERED'                     , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink 'Notes.DetailView.Portal'   ,  2, 'Notes.LBL_FILENAME'              , 'FILENAME'                         , '{0}'        , 'NOTE_ATTACHMENT_ID', '~/Notes/Attachment.aspx?ID={0}', null, 3;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'Notes.DetailView.Portal'   ,  3, '.LBL_DATE_MODIFIED'              , 'DATE_MODIFIED'                    , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'Notes.DetailView.Portal'   ,  4, 'TextBox', 'Notes.LBL_NOTE'       , 'DESCRIPTION', '30,90', null, null, null, null, 3;
end -- if;
GO

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'KBDocuments.DetailView.Portal';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'KBDocuments.DetailView.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS KBDocuments.DetailView.Portal';
	exec dbo.spDETAILVIEWS_InsertOnly          'KBDocuments.DetailView.Portal', 'KBDocuments'     , 'vwKBDOCUMENTS_Edit'     , '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView.Portal',  0, 'KBDocuments.LBL_NAME'             , 'NAME'                             , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound     'KBDocuments.DetailView.Portal',  1, 'KBDocuments.LBL_REVISION'         , 'REVISION'                         , '{0}'        , null;
	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly   'KBDocuments.DetailView.Portal',  2, 'TextBox', 'KBDocuments.LBL_DESCRIPTION', 'DESCRIPTION', '10,90', null, null, null, null, 3, null;
end -- if;
GO

set nocount off;
GO


/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spDETAILVIEWS_FIELDS_DetailViewPortal()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_DetailViewPortal')
/

-- #endif IBM_DB2 */


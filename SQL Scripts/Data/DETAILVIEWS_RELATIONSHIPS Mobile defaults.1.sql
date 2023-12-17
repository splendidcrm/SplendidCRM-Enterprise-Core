

print 'DETAILVIEWS_RELATIONSHIPS Mobile';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Accounts.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView.Mobile'      , 'Contacts'         , 'Contacts'           ,  0, 'Contacts.LBL_MODULE_NAME'         , 'vwACCOUNTS_CONTACTS'          , 'ACCOUNT_ID', 'CONTACT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView.Mobile'      , 'Opportunities'    , 'Opportunities'      ,  1, 'Opportunities.LBL_MODULE_NAME'    , 'vwACCOUNTS_OPPORTUNITIES'     , 'ACCOUNT_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView.Mobile'      , 'Leads'            , 'Leads'              ,  2, 'Leads.LBL_MODULE_NAME'            , 'vwACCOUNTS_LEADS'             , 'ACCOUNT_ID', 'LEAD_NAME'    , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView.Mobile'      , 'Cases'            , 'Cases'              ,  3, 'Cases.LBL_MODULE_NAME'            , 'vwACCOUNTS_CASES'             , 'ACCOUNT_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView.Mobile'      , 'Documents'        , 'Documents'          ,  4, 'Documents.LBL_MODULE_NAME'        , 'vwACCOUNTS_DOCUMENTS'         , 'ACCOUNT_ID', 'DOCUMENT_NAME', 'asc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Bugs.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Bugs.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Bugs.DetailView.Mobile'          , 'Contacts'         , 'Contacts'           ,  0, 'Contacts.LBL_MODULE_NAME'         , 'vwBUGS_CONTACTS'          , 'BUG_ID', 'CONTACT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Bugs.DetailView.Mobile'          , 'Accounts'         , 'Accounts'           ,  1, 'Accounts.LBL_MODULE_NAME'         , 'vwBUGS_ACCOUNTS'          , 'BUG_ID', 'ACCOUNT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Bugs.DetailView.Mobile'          , 'Cases'            , 'Cases'              ,  2, 'Cases.LBL_MODULE_NAME'            , 'vwBUGS_CASES'             , 'BUG_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Bugs.DetailView.Mobile'          , 'Documents'        , 'Documents'          ,  3, 'Documents.LBL_MODULE_NAME'        , 'vwBUGS_DOCUMENTS'         , 'BUG_ID', 'DOCUMENT_NAME', 'asc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Calls.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Calls.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Calls.DetailView.Mobile'         , 'Contacts'         , 'Contacts'           ,  0, 'Contacts.LBL_MODULE_NAME'         , 'vwCALLS_CONTACTS', 'CALL_ID', 'CONTACT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Calls.DetailView.Mobile'         , 'Users'            , 'Users'              ,  1, 'Users.LBL_MODULE_NAME'            , 'vwCALLS_USERS'   , 'CALL_ID', 'FULL_NAME'   , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Calls.DetailView.Mobile'         , 'Leads'            , 'Leads'              ,  2, 'Leads.LBL_MODULE_NAME'            , 'vwCALLS_LEADS'   , 'CALL_ID', 'LEAD_NAME'   , 'asc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Cases.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Cases.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Cases.DetailView.Mobile'         , 'Contacts'         , 'Contacts'           ,  0, 'Contacts.LBL_MODULE_NAME'         , 'vwCASES_CONTACTS'          , 'CASE_ID', 'CONTACT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Cases.DetailView.Mobile'         , 'Bugs'             , 'Bugs'               ,  1, 'Bugs.LBL_MODULE_NAME'             , 'vwCASES_BUGS'              , 'CASE_ID', 'BUG_NAME'     , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Cases.DetailView.Mobile'         , 'Documents'        , 'Documents'          ,  2, 'Documents.LBL_MODULE_NAME'        , 'vwCASES_DOCUMENTS'         , 'CASE_ID', 'DOCUMENT_NAME', 'asc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Contacts.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView.Mobile'      , 'Leads'            , 'Leads'              ,  0, 'Leads.LBL_MODULE_NAME'            , 'vwCONTACTS_LEADS'             , 'CONTACT_ID', 'LEAD_NAME'    , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView.Mobile'      , 'Opportunities'    , 'Opportunities'      ,  1, 'Opportunities.LBL_MODULE_NAME'    , 'vwCONTACTS_OPPORTUNITIES'     , 'CONTACT_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView.Mobile'      , 'Cases'            , 'Cases'              ,  2, 'Cases.LBL_MODULE_NAME'            , 'vwCONTACTS_CASES'             , 'CONTACT_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView.Mobile'      , 'Bugs'             , 'Bugs'               ,  3, 'Bugs.LBL_MODULE_NAME'             , 'vwCONTACTS_BUGS'              , 'CONTACT_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView.Mobile'      , 'Contacts'         , 'DirectReports'      ,  4, 'Contacts.LBL_MODULE_NAME'         , 'vwCONTACTS_DIRECT_REPORTS'    , 'CONTACT_ID', 'DIRECT_REPORT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView.Mobile'      , 'Documents'        , 'Documents'          ,  5, 'Documents.LBL_MODULE_NAME'        , 'vwCONTACTS_DOCUMENTS'         , 'CONTACT_ID', 'DOCUMENT_NAME', 'asc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Documents.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Documents.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Documents.DetailView.Mobile'     , 'Documents'        , 'DocumentRevisions'  ,  0, 'Documents.LBL_MODULE_NAME'       , 'vwDOCUMENT_REVISIONS'     , 'DOCUMENT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Documents.DetailView.Mobile'     , 'Accounts'         , 'Accounts'           ,  1, 'Accounts.LBL_MODULE_NAME'        , 'vwDOCUMENTS_ACCOUNTS'     , 'DOCUMENT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Documents.DetailView.Mobile'     , 'Contacts'         , 'Contacts'           ,  2, 'Contacts.LBL_MODULE_NAME'        , 'vwDOCUMENTS_CONTACTS'     , 'DOCUMENT_ID', 'CONTACT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Documents.DetailView.Mobile'     , 'Leads'            , 'Leads'              ,  3, 'Leads.LBL_MODULE_NAME'           , 'vwDOCUMENTS_LEADS'        , 'DOCUMENT_ID', 'LEAD_NAME'   , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Documents.DetailView.Mobile'     , 'Opportunities'    , 'Opportunities'      ,  4, 'Opportunities.LBL_MODULE_NAME'   , 'vwDOCUMENTS_OPPORTUNITIES', 'DOCUMENT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Documents.DetailView.Mobile'     , 'Bugs'             , 'Bugs'               ,  5, 'Bugs.LBL_MODULE_NAME'            , 'vwDOCUMENTS_BUGS'         , 'DOCUMENT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Documents.DetailView.Mobile'     , 'Cases'            , 'Cases'              ,  6, 'Cases.LBL_MODULE_NAME'           , 'vwDOCUMENTS_CASES'        , 'DOCUMENT_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Emails.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Emails.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Emails.DetailView.Mobile'        , 'Accounts'         , 'Accounts'           ,  0, 'Accounts.LBL_MODULE_NAME'         , 'vwEMAILS_ACCOUNTS'       , 'EMAIL_ID', 'ACCOUNT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Emails.DetailView.Mobile'        , 'Contacts'         , 'Contacts'           ,  1, 'Contacts.LBL_MODULE_NAME'         , 'vwEMAILS_CONTACTS'       , 'EMAIL_ID', 'CONTACT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Emails.DetailView.Mobile'        , 'Opportunities'    , 'Opportunities'      ,  2, 'Opportunities.LBL_MODULE_NAME'    , 'vwEMAILS_OPPORTUNITIES'  , 'EMAIL_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Emails.DetailView.Mobile'        , 'Leads'            , 'Leads'              ,  3, 'Leads.LBL_MODULE_NAME'            , 'vwEMAILS_LEADS'          , 'EMAIL_ID', 'LEAD_NAME'   , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Emails.DetailView.Mobile'        , 'Cases'            , 'Cases'              ,  4, 'Cases.LBL_MODULE_NAME'            , 'vwEMAILS_CASES'          , 'EMAIL_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Emails.DetailView.Mobile'        , 'Users'            , 'Users'              ,  5, 'Users.LBL_MODULE_NAME'            , 'vwEMAILS_USERS'          , 'EMAIL_ID', 'FULL_NAME'   , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Emails.DetailView.Mobile'        , 'Bugs'             , 'Bugs'               ,  6, 'Bugs.LBL_MODULE_NAME'             , 'vwEMAILS_BUGS'           , 'EMAIL_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO


-- 08/07/2015 Paul.  Add Leads/Contacts relationship. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Leads.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Leads.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Leads.DetailView.Mobile'         , 'Documents'        , 'Documents'          ,  0, 'Documents.LBL_MODULE_NAME'        , 'vwLEADS_DOCUMENTS'         , 'LEAD_ID'   , 'DOCUMENT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Leads.DetailView.Mobile'         , 'Contacts'         , 'Contacts'           ,  1, 'Contacts.LBL_MODULE_NAME'         , 'vwLEADS_CONTACTS'          , 'ACCOUNT_ID', 'CONTACT_NAME' , 'asc';
end else begin
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Leads.DetailView.Mobile'         , 'Contacts'         , 'Contacts'           ,  1, 'Contacts.LBL_MODULE_NAME'         , 'vwLEADS_CONTACTS'          , 'ACCOUNT_ID', 'CONTACT_NAME' , 'asc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Meetings.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Meetings.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Meetings.DetailView.Mobile'      , 'Contacts'         , 'Contacts'           ,  0, 'Contacts.LBL_MODULE_NAME'         , 'vwMEETINGS_CONTACTS', 'MEETING_ID', 'CONTACT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Meetings.DetailView.Mobile'      , 'Users'            , 'Users'              ,  1, 'Users.LBL_MODULE_NAME'            , 'vwMEETINGS_USERS'   , 'MEETING_ID', 'FULL_NAME'   , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Meetings.DetailView.Mobile'      , 'Leads'            , 'Leads'              ,  2, 'Leads.LBL_MODULE_NAME'            , 'vwMEETINGS_LEADS'   , 'MEETING_ID', 'LEAD_NAME'   , 'asc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Opportunities.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Opportunities.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.DetailView.Mobile' , 'Leads'            , 'Leads'              ,  0, 'Leads.LBL_MODULE_NAME'            , 'vwOPPORTUNITIES_LEADS'             , 'OPPORTUNITY_ID', 'LEAD_NAME'    , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.DetailView.Mobile' , 'Contacts'         , 'Contacts'           ,  1, 'Contacts.LBL_MODULE_NAME'         , 'vwOPPORTUNITIES_CONTACTS'          , 'OPPORTUNITY_ID', 'CONTACT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.DetailView.Mobile' , 'Documents'        , 'Documents'          ,  2, 'Documents.LBL_MODULE_NAME'        , 'vwOPPORTUNITIES_DOCUMENTS'         , 'OPPORTUNITY_ID', 'DATE_ENTERED' , 'desc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Project.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Project.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Project.DetailView.Mobile'       , 'ProjectTask'      , 'ProjectTasks'       ,  0, 'ProjectTask.LBL_MODULE_NAME'      , 'vwPROJECTS_PROJECT_TASKS'     , 'PROJECT_ID', 'DATE_DUE'     , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Project.DetailView.Mobile'       , 'Contacts'         , 'Contacts'           ,  1, 'Contacts.LBL_MODULE_NAME'         , 'vwPROJECTS_CONTACTS'          , 'PROJECT_ID', 'CONTACT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Project.DetailView.Mobile'       , 'Accounts'         , 'Accounts'           ,  2, 'Accounts.LBL_MODULE_NAME'         , 'vwPROJECTS_ACCOUNTS'          , 'PROJECT_ID', 'ACCOUNT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Project.DetailView.Mobile'       , 'Opportunities'    , 'Opportunities'      ,  3, 'Opportunities.LBL_MODULE_NAME'    , 'vwPROJECTS_OPPORTUNITIES'     , 'PROJECT_ID', 'DATE_ENTERED' , 'desc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'ChatChannels.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS ChatChannels.DetailView.Mobile';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'ChatChannels.DetailView.Mobile'  , 'ChatMessages'     , 'ChatMessages'       ,  0, 'ChatMessages.LBL_MODULE_NAME'    , 'vwCHAT_CHANNELS_CHAT_MESSAGES', 'CHAT_CHANNEL_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'ChatChannels.DetailView.Mobile'  , 'Notes'            , 'Attachments'        ,  1, 'ChatChannels.LBL_ATTACHMENTS'    , 'vwCHAT_CHANNELS_ATTACHMENTS'  , 'CHAT_CHANNEL_ID', 'DATE_ENTERED', 'desc';
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_Mobile()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_Mobile')
/

-- #endif IBM_DB2 */


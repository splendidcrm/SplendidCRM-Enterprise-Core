

print 'DETAILVIEWS_RELATIONSHIPS DataPrivacy';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'DataPrivacy.DetailView';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'DataPrivacy.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS DataPrivacy.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'DataPrivacy.DetailView' , 'Contacts'         , 'Contacts'           ,  1, 'Contacts.LBL_MODULE_NAME'         , 'vwDATA_PRIVACY_CONTACTS'         , 'DATA_PRIVACY_ID', 'NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'DataPrivacy.DetailView' , 'Contacts'         , 'ContactsArchived'   ,  2, 'Contacts.LNK_ARCHIVED_CONTACTS'   , 'vwDATA_PRIVACY_CONTACTS_ARCHIVE' , 'DATA_PRIVACY_ID', 'NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'DataPrivacy.DetailView' , 'Leads'            , 'Leads'              ,  3, 'Leads.LBL_MODULE_NAME'            , 'vwDATA_PRIVACY_LEADS'            , 'DATA_PRIVACY_ID', 'NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'DataPrivacy.DetailView' , 'Leads'            , 'LeadsArchived'      ,  4, 'Leads.LNK_ARCHIVED_LEADS'         , 'vwDATA_PRIVACY_LEADS_ARCHIVE'    , 'DATA_PRIVACY_ID', 'NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'DataPrivacy.DetailView' , 'Prospects'        , 'Prospects'          ,  5, 'Prospects.LBL_MODULE_NAME'        , 'vwDATA_PRIVACY_PROSPECTS'        , 'DATA_PRIVACY_ID', 'NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'DataPrivacy.DetailView' , 'Prospects'        , 'ProspectsArchived'  ,  6, 'Prospects.LNK_ARCHIVED_PROSPECTS' , 'vwDATA_PRIVACY_PROSPECTS_ARCHIVE', 'DATA_PRIVACY_ID', 'NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'DataPrivacy.DetailView' , 'Accounts'         , 'Accounts'           ,  7, 'Accounts.LBL_MODULE_NAME'         , 'vwDATA_PRIVACY_ACCOUNTS'         , 'DATA_PRIVACY_ID', 'NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'DataPrivacy.DetailView' , 'Accounts'         , 'AccountsArchived'   ,  8, 'Accounts.LNK_ARCHIVED_ACCOUNTS'   , 'vwDATA_PRIVACY_ACCOUNTS_ARCHIVE' , 'DATA_PRIVACY_ID', 'NAME', 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'DataPrivacyView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView', 'Administration', 'DataPrivacyView', 20, 'Administration.LBL_DATA_PRIVACY_TITLE', null, null, null, null;
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.DetailView' and CONTROL_NAME = 'DataPrivacy' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Accounts.DetailView';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where DETAIL_NAME        = 'Accounts.DetailView'
	   and DELETED            = 0;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView' , 'DataPrivacy'         , 'DataPrivacy'        ,  0, 'DataPrivacy.LBL_MODULE_NAME'      , 'vwACCOUNTS_DATA_PRIVACY'       , 'ACCOUNT_ID'     , 'DATE_ENTERED' , 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView' and CONTROL_NAME = 'DataPrivacy' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Contacts.DetailView';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where DETAIL_NAME        = 'Contacts.DetailView'
	   and DELETED            = 0;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView' , 'DataPrivacy'         , 'DataPrivacy'        ,  0, 'DataPrivacy.LBL_MODULE_NAME'      , 'vwCONTACTS_DATA_PRIVACY'       , 'CONTACT_ID'     , 'DATE_ENTERED' , 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Leads.DetailView' and CONTROL_NAME = 'DataPrivacy' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Leads.DetailView';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where DETAIL_NAME        = 'Leads.DetailView'
	   and DELETED            = 0;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Leads.DetailView'    , 'DataPrivacy'         , 'DataPrivacy'        ,  0, 'DataPrivacy.LBL_MODULE_NAME'      , 'vwLEADS_DATA_PRIVACY'          , 'LEAD_ID'        , 'DATE_ENTERED' , 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Prospects.DetailView' and CONTROL_NAME = 'DataPrivacy' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Prospects.DetailView';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where DETAIL_NAME        = 'Prospects.DetailView'
	   and DELETED            = 0;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Prospects.DetailView', 'DataPrivacy'         , 'DataPrivacy'        ,  0, 'DataPrivacy.LBL_MODULE_NAME'      , 'vwPROSPECTS_DATA_PRIVACY'      , 'PROSPECT_ID'    , 'DATE_ENTERED' , 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.ArchiveView' and CONTROL_NAME = 'DataPrivacy' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Accounts.ArchiveView';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where DETAIL_NAME        = 'Accounts.ArchiveView'
	   and DELETED            = 0;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.ArchiveView' , 'DataPrivacy'         , 'DataPrivacy'        ,  0, 'DataPrivacy.LBL_MODULE_NAME'      , 'vwACCOUNTS_DATA_PRIVACY'       , 'ACCOUNT_ID'     , 'DATE_ENTERED' , 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.ArchiveView' and CONTROL_NAME = 'DataPrivacy' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Contacts.ArchiveView';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where DETAIL_NAME        = 'Contacts.ArchiveView'
	   and DELETED            = 0;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.ArchiveView' , 'DataPrivacy'         , 'DataPrivacy'        ,  0, 'DataPrivacy.LBL_MODULE_NAME'      , 'vwCONTACTS_DATA_PRIVACY'       , 'CONTACT_ID'     , 'DATE_ENTERED' , 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Leads.ArchiveView' and CONTROL_NAME = 'DataPrivacy' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Leads.ArchiveView';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where DETAIL_NAME        = 'Leads.ArchiveView'
	   and DELETED            = 0;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Leads.ArchiveView'    , 'DataPrivacy'         , 'DataPrivacy'        ,  0, 'DataPrivacy.LBL_MODULE_NAME'      , 'vwLEADS_DATA_PRIVACY'          , 'LEAD_ID'        , 'DATE_ENTERED' , 'asc';
end -- if;
GO

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Prospects.ArchiveView' and CONTROL_NAME = 'DataPrivacy' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Prospects.ArchiveView';
	update DETAILVIEWS_RELATIONSHIPS
	   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	 where DETAIL_NAME        = 'Prospects.ArchiveView'
	   and DELETED            = 0;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Prospects.ArchiveView', 'DataPrivacy'         , 'DataPrivacy'        ,  0, 'DataPrivacy.LBL_MODULE_NAME'      , 'vwPROSPECTS_DATA_PRIVACY'      , 'PROSPECT_ID'    , 'DATE_ENTERED' , 'asc';
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_DataPrivacy()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_DataPrivacy')
/

-- #endif IBM_DB2 */


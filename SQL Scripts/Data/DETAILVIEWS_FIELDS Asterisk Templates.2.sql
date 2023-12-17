

print 'DETAILVIEWS_FIELDS Asterisk Templates';
-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME like 'Asterisk.%.Template'
--GO

set nocount on;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Asterisk.Accounts.Template' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Asterisk.Accounts.Template';
	exec dbo.spDETAILVIEWS_InsertOnly           'Asterisk.Accounts.Template' , 'Accounts', 'vwACCOUNTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Accounts.Template' , 0, null, 'PHONE_OFFICE'   , 'ID PHONE_OFFICE'   , 'CreateClickToCall("spn{0}_PHONE_OFFICE", "Accounts", "{0}", "{1}");'   , 'spn{0}_PHONE_OFFICE'   , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Accounts.Template' , 1, null, 'PHONE_ALTERNATE', 'ID PHONE_ALTERNATE', 'CreateClickToCall("spn{0}_PHONE_ALTERNATE", "Accounts", "{0}", "{1}");', 'spn{0}_PHONE_ALTERNATE', -1;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Asterisk.Contacts.Template' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Asterisk.Contacts.Template';
	exec dbo.spDETAILVIEWS_InsertOnly           'Asterisk.Contacts.Template' , 'Contacts', 'vwCONTACTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Contacts.Template' , 0, null, 'PHONE_WORK'  , 'ID PHONE_WORK'  , 'CreateClickToCall("spn{0}_PHONE_WORK", "Contacts", "{0}", "{1}");'   , 'spn{0}_PHONE_WORK'  , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Contacts.Template' , 1, null, 'PHONE_MOBILE', 'ID PHONE_MOBILE', 'CreateClickToCall("spn{0}_PHONE_MOBILE", "Contacts", "{0}", "{1}");' , 'spn{0}_PHONE_MOBILE', -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Contacts.Template' , 2, null, 'PHONE_OTHER' , 'ID PHONE_OTHER' , 'CreateClickToCall("spn{0}_PHONE_OTHER", "Contacts", "{0}", "{1}");'  , 'spn{0}_PHONE_OTHER' , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Contacts.Template' , 3, null, 'PHONE_HOME'  , 'ID PHONE_HOME'  , 'CreateClickToCall("spn{0}_PHONE_HOME", "Contacts", "{0}", "{1}");'   , 'spn{0}_PHONE_HOME'  , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Contacts.Template' , 4, null, 'PHONE_FAX'   , 'ID PHONE_FAX'   , 'CreateClickToCall("spn{0}_PHONE_FAX", "Contacts", "{0}", "{1}");'    , 'spn{0}_PHONE_FAX'   , -1;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Asterisk.Leads.Template' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Asterisk.Leads.Template';
	exec dbo.spDETAILVIEWS_InsertOnly           'Asterisk.Leads.Template' , 'Leads', 'vwLEADS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Leads.Template'    , 0, null, 'PHONE_WORK'  , 'ID PHONE_WORK'  , 'CreateClickToCall("spn{0}_PHONE_WORK", "Leads", "{0}", "{1}");'      , 'spn{0}_PHONE_WORK'  , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Leads.Template'    , 1, null, 'PHONE_MOBILE', 'ID PHONE_MOBILE', 'CreateClickToCall("spn{0}_PHONE_MOBILE", "Leads", "{0}", "{1}");'    , 'spn{0}_PHONE_MOBILE', -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Leads.Template'    , 2, null, 'PHONE_OTHER' , 'ID PHONE_OTHER' , 'CreateClickToCall("spn{0}_PHONE_OTHER", "Leads", "{0}", "{1}");'     , 'spn{0}_PHONE_OTHER' , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Leads.Template'    , 3, null, 'PHONE_HOME'  , 'ID PHONE_HOME'  , 'CreateClickToCall("spn{0}_PHONE_HOME", "Leads", "{0}", "{1}");'      , 'spn{0}_PHONE_HOME'  , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Leads.Template'    , 4, null, 'PHONE_FAX'   , 'ID PHONE_FAX'   , 'CreateClickToCall("spn{0}_PHONE_FAX", "Leads", "{0}", "{1}");'       , 'spn{0}_PHONE_FAX'   , -1;
end -- if;
GO

if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Asterisk.Prospects.Template' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS Asterisk.Prospects.Template';
	exec dbo.spDETAILVIEWS_InsertOnly           'Asterisk.Prospects.Template' , 'Prospects', 'vwPROSPECTS_Edit', '15%', '35%', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Prospects.Template', 0, null, 'PHONE_WORK'  , 'ID PHONE_WORK'  , 'CreateClickToCall("spn{0}_PHONE_WORK", "Prospects", "{0}", "{1}");'  , 'spn{0}_PHONE_WORK'  , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Prospects.Template', 1, null, 'PHONE_MOBILE', 'ID PHONE_MOBILE', 'CreateClickToCall("spn{0}_PHONE_MOBILE", "Prospects", "{0}", "{1}");', 'spn{0}_PHONE_MOBILE', -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Prospects.Template', 2, null, 'PHONE_OTHER' , 'ID PHONE_OTHER' , 'CreateClickToCall("spn{0}_PHONE_OTHER", "Prospects", "{0}", "{1}");' , 'spn{0}_PHONE_OTHER' , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Prospects.Template', 3, null, 'PHONE_HOME'  , 'ID PHONE_HOME'  , 'CreateClickToCall("spn{0}_PHONE_HOME", "Prospects", "{0}", "{1}");'  , 'spn{0}_PHONE_HOME'  , -1;
	exec dbo.spDETAILVIEWS_FIELDS_InsJavaScript 'Asterisk.Prospects.Template', 4, null, 'PHONE_FAX'   , 'ID PHONE_FAX'   , 'CreateClickToCall("spn{0}_PHONE_FAX", "Prospects", "{0}", "{1}");'   , 'spn{0}_PHONE_FAX'   , -1;
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

call dbo.spDETAILVIEWS_FIELDS_Asterisk()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_FIELDS_Asterisk')
/

-- #endif IBM_DB2 */


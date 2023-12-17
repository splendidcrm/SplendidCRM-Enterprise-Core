

print 'GRIDVIEWS_COLUMNS Asterisk Templates';
-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like 'Asterisk.%.Template'
--GO

set nocount on;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Asterisk.Accounts.Template' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Asterisk.Accounts.Template';
	exec dbo.spGRIDVIEWS_InsertOnly            'Asterisk.Accounts.Template' , 'Accounts', 'vwACCOUNTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Accounts.Template' , 0, null, 'PHONE_OFFICE'   , '16px', 'ID PHONE_OFFICE'   , 'CreateClickToCall("spn{0}_PHONE_OFFICE", "Accounts", "{0}", "{1}");'   , 'spn{0}_PHONE_OFFICE'   ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Accounts.Template' , 1, null, 'PHONE_ALTERNATE', '16px', 'ID PHONE_ALTERNATE', 'CreateClickToCall("spn{0}_PHONE_ALTERNATE", "Accounts", "{0}", "{1}");', 'spn{0}_PHONE_ALTERNATE';
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Accounts.Template', 0, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Accounts.Template', 1, null, null, 'Left', 'Top', 0;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Asterisk.Contacts.Template' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Asterisk.Contacts.Template';
	exec dbo.spGRIDVIEWS_InsertOnly            'Asterisk.Contacts.Template' , 'Contacts', 'vwCONTACTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Contacts.Template' , 0, null, 'PHONE_WORK'  , '16px', 'ID PHONE_WORK'  , 'CreateClickToCall("spn{0}_PHONE_WORK", "Contacts", "{0}", "{1}");'   , 'spn{0}_PHONE_WORK'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Contacts.Template' , 1, null, 'PHONE_MOBILE', '16px', 'ID PHONE_MOBILE', 'CreateClickToCall("spn{0}_PHONE_MOBILE", "Contacts", "{0}", "{1}");' , 'spn{0}_PHONE_MOBILE';
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Contacts.Template' , 2, null, 'PHONE_OTHER' , '16px', 'ID PHONE_OTHER' , 'CreateClickToCall("spn{0}_PHONE_OTHER", "Contacts", "{0}", "{1}");'  , 'spn{0}_PHONE_OTHER' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Contacts.Template' , 3, null, 'PHONE_HOME'  , '16px', 'ID PHONE_HOME'  , 'CreateClickToCall("spn{0}_PHONE_HOME", "Contacts", "{0}", "{1}");'   , 'spn{0}_PHONE_HOME'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Contacts.Template' , 4, null, 'PHONE_FAX'   , '16px', 'ID PHONE_FAX'   , 'CreateClickToCall("spn{0}_PHONE_FAX", "Contacts", "{0}", "{1}");'    , 'spn{0}_PHONE_FAX'   ;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Contacts.Template', 0, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Contacts.Template', 1, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Contacts.Template', 2, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Contacts.Template', 3, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Contacts.Template', 4, null, null, 'Left', 'Top', 0;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Asterisk.Leads.Template' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Asterisk.Leads.Template';
	exec dbo.spGRIDVIEWS_InsertOnly            'Asterisk.Leads.Template'    , 'Leads', 'vwLEADS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Leads.Template'    , 0, null, 'PHONE_WORK'  , '16px', 'ID PHONE_WORK'  , 'CreateClickToCall("spn{0}_PHONE_WORK", "Leads", "{0}", "{1}");'      , 'spn{0}_PHONE_WORK'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Leads.Template'    , 1, null, 'PHONE_MOBILE', '16px', 'ID PHONE_MOBILE', 'CreateClickToCall("spn{0}_PHONE_MOBILE", "Leads", "{0}", "{1}");'    , 'spn{0}_PHONE_MOBILE';
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Leads.Template'    , 2, null, 'PHONE_OTHER' , '16px', 'ID PHONE_OTHER' , 'CreateClickToCall("spn{0}_PHONE_OTHER", "Leads", "{0}", "{1}");'     , 'spn{0}_PHONE_OTHER' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Leads.Template'    , 3, null, 'PHONE_HOME'  , '16px', 'ID PHONE_HOME'  , 'CreateClickToCall("spn{0}_PHONE_HOME", "Leads", "{0}", "{1}");'      , 'spn{0}_PHONE_HOME'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Leads.Template'    , 4, null, 'PHONE_FAX'   , '16px', 'ID PHONE_FAX'   , 'CreateClickToCall("spn{0}_PHONE_FAX", "Leads", "{0}", "{1}");'       , 'spn{0}_PHONE_FAX'   ;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Leads.Template', 0, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Leads.Template', 1, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Leads.Template', 2, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Leads.Template', 3, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Leads.Template', 4, null, null, 'Left', 'Top', 0;
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Asterisk.Prospects.Template' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS Asterisk.Prospects.Template';
	exec dbo.spGRIDVIEWS_InsertOnly            'Asterisk.Prospects.Template', 'Prospects', 'vwPROSPECTS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Prospects.Template', 0, null, 'PHONE_WORK'  , '16px', 'ID PHONE_WORK'  , 'CreateClickToCall("spn{0}_PHONE_WORK", "Prospects", "{0}", "{1}");'  , 'spn{0}_PHONE_WORK'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Prospects.Template', 1, null, 'PHONE_MOBILE', '16px', 'ID PHONE_MOBILE', 'CreateClickToCall("spn{0}_PHONE_MOBILE", "Prospects", "{0}", "{1}");', 'spn{0}_PHONE_MOBILE';
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Prospects.Template', 2, null, 'PHONE_OTHER' , '16px', 'ID PHONE_OTHER' , 'CreateClickToCall("spn{0}_PHONE_OTHER", "Prospects", "{0}", "{1}");' , 'spn{0}_PHONE_OTHER' ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Prospects.Template', 3, null, 'PHONE_HOME'  , '16px', 'ID PHONE_HOME'  , 'CreateClickToCall("spn{0}_PHONE_HOME", "Prospects", "{0}", "{1}");'  , 'spn{0}_PHONE_HOME'  ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsJavaScript 'Asterisk.Prospects.Template', 4, null, 'PHONE_FAX'   , '16px', 'ID PHONE_FAX'   , 'CreateClickToCall("spn{0}_PHONE_FAX", "Prospects", "{0}", "{1}");'   , 'spn{0}_PHONE_FAX'   ;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Prospects.Template', 0, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Prospects.Template', 1, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Prospects.Template', 2, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Prospects.Template', 3, null, null, 'Left', 'Top', 0;
	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, 'Asterisk.Prospects.Template', 4, null, null, 'Left', 'Top', 0;
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

call dbo.spGRIDVIEWS_COLUMNS_Asterisk()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_Asterisk')
/

-- #endif IBM_DB2 */


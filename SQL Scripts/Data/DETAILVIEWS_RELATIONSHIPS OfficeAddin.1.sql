

print 'DETAILVIEWS_RELATIONSHIPS OfficeAddin';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

-- 02/24/2016 Paul.  Searched Office Addin modules. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.OfficeAddin.AppRead';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Home.OfficeAddin.AppRead';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppRead'   , 'Opportunities'    , 'Opportunities'      ,  0, 'Opportunities.LBL_MODULE_NAME'    , 'vwOPPORTUNITIES', 'ACCOUNT_EMAIL1 B2C_CONTACT_EMAIL1 LEAD_EMAIL1', null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppRead'   , 'Cases'            , 'Cases'              ,  1, 'Cases.LBL_MODULE_NAME'            , 'vwCASESS'       , 'ID ACCOUNT_EMAIL1 B2C_CONTACT_EMAIL1'         , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppRead'   , 'Quotes'           , 'Quotes'             ,  2, 'Quotes.LBL_MODULE_NAME'           , 'vwQUOTES'       , 'BILLING_ACCOUNT_EMAIL1 SHIPPING_ACCOUNT_EMAIL1 BILLING_CONTACT_EMAIL1 SHIPPING_CONTACT_EMAIL1', null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppRead'   , 'Orders'           , 'Orders'             ,  3, 'Orders.LBL_MODULE_NAME'           , 'vwORDERS'       , 'BILLING_ACCOUNT_EMAIL1 SHIPPING_ACCOUNT_EMAIL1 BILLING_CONTACT_EMAIL1 SHIPPING_CONTACT_EMAIL1', null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppRead'   , 'Invoices'         , 'Invoices'           ,  4, 'Invoices.LBL_MODULE_NAME'         , 'vwINVOICES'     , 'BILLING_ACCOUNT_EMAIL1 SHIPPING_ACCOUNT_EMAIL1 BILLING_CONTACT_EMAIL1 SHIPPING_CONTACT_EMAIL1', null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppRead'   , 'Accounts'         , 'Accounts'           ,  5, 'Accounts.LBL_MODULE_NAME'         , 'vwACCOUNTS'     , 'EMAIL1'        , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppRead'   , 'Contacts'         , 'Contacts'           ,  6, 'Contacts.LBL_MODULE_NAME'         , 'vwCONTACTS'     , 'EMAIL1'        , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppRead'   , 'Leads'            , 'Leads'              ,  7, 'Leads.LBL_MODULE_NAME'            , 'vwLEADS'        , 'EMAIL1'        , null, null;
end -- if;
GO

-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.OfficeAddin.AppCompose';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.OfficeAddin.AppCompose' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Home.OfficeAddin.AppCompose';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppCompose', 'Opportunities'    , 'Opportunities'      ,  0, 'Opportunities.LBL_MODULE_NAME'    , 'vwOPPORTUNITIES', 'ACCOUNT_EMAIL1 B2C_CONTACT_EMAIL1 LEAD_EMAIL1', null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppCompose', 'Cases'            , 'Cases'              ,  1, 'Cases.LBL_MODULE_NAME'            , 'vwCASESS'       , 'ID ACCOUNT_EMAIL1 B2C_CONTACT_EMAIL1'         , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppCompose', 'Quotes'           , 'Quotes'             ,  2, 'Quotes.LBL_MODULE_NAME'           , 'vwQUOTES'       , 'BILLING_ACCOUNT_EMAIL1 SHIPPING_ACCOUNT_EMAIL1 BILLING_CONTACT_EMAIL1 SHIPPING_CONTACT_EMAIL1', null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppCompose', 'Orders'           , 'Orders'             ,  3, 'Orders.LBL_MODULE_NAME'           , 'vwORDERS'       , 'BILLING_ACCOUNT_EMAIL1 SHIPPING_ACCOUNT_EMAIL1 BILLING_CONTACT_EMAIL1 SHIPPING_CONTACT_EMAIL1', null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppCompose', 'Invoices'         , 'Invoices'           ,  4, 'Invoices.LBL_MODULE_NAME'         , 'vwINVOICES'     , 'BILLING_ACCOUNT_EMAIL1 SHIPPING_ACCOUNT_EMAIL1 BILLING_CONTACT_EMAIL1 SHIPPING_CONTACT_EMAIL1', null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppCompose', 'Accounts'         , 'Accounts'           ,  5, 'Accounts.LBL_MODULE_NAME'         , 'vwACCOUNTS'     , 'EMAIL1'        , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppCompose', 'Contacts'         , 'Contacts'           ,  6, 'Contacts.LBL_MODULE_NAME'         , 'vwCONTACTS'     , 'EMAIL1'        , null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.OfficeAddin.AppCompose', 'Leads'            , 'Leads'              ,  7, 'Leads.LBL_MODULE_NAME'            , 'vwLEADS'        , 'EMAIL1'        , null, null;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_OfficeAddin()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_OfficeAddin')
/

-- #endif IBM_DB2 */


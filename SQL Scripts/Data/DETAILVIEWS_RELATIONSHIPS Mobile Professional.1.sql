

print 'DETAILVIEWS_RELATIONSHIPS Mobile Professional';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Accounts.DetailView.Mobile' and MODULE_NAME in ('Quotes', 'Invoices', 'Orders') and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Accounts.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView.Mobile'      , 'Quotes'           , 'Quotes'             ,  5, 'Quotes.LBL_MODULE_NAME'           , 'vwACCOUNTS_QUOTES'      , 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView.Mobile'      , 'Contracts'        , 'Contracts'          ,  6, 'Contracts.LBL_MODULE_NAME'        , 'vwACCOUNTS_CONTRACTS'   , 'ACCOUNT_ID', 'CONTRACT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView.Mobile'      , 'Invoices'         , 'Invoices'           ,  7, 'Invoices.LBL_MODULE_NAME'         , 'vwACCOUNTS_INVOICES'    , 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Accounts.DetailView.Mobile'      , 'Orders'           , 'Orders'             ,  8, 'Orders.LBL_MODULE_NAME'           , 'vwACCOUNTS_ORDERS'      , 'ACCOUNT_ID', 'DATE_ENTERED', 'desc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contacts.DetailView.Mobile' and MODULE_NAME in ('Quotes', 'Invoices', 'Orders') and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Contacts.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView.Mobile'      , 'Quotes'           , 'Quotes'             ,   6, 'Quotes.LBL_MODULE_NAME'          , 'vwCONTACTS_QUOTES'      , 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView.Mobile'      , 'Invoices'         , 'Invoices'           ,   7, 'Invoices.LBL_MODULE_NAME'        , 'vwCONTACTS_INVOICES'    , 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contacts.DetailView.Mobile'      , 'Orders'           , 'Orders'             ,   8, 'Orders.LBL_MODULE_NAME'          , 'vwCONTACTS_ORDERS'      , 'CONTACT_ID', 'DATE_ENTERED'    , 'desc';
end -- if;


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Opportunities.DetailView.Mobile' and MODULE_NAME in ('Quotes', 'Contracts') and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Opportunities.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.DetailView.Mobile' , 'Quotes'           , 'Quotes'             ,  3, 'Quotes.LBL_MODULE_NAME'           , 'vwOPPORTUNITIES_QUOTES'            , 'OPPORTUNITY_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Opportunities.DetailView.Mobile' , 'Contracts'        , 'Contracts'          ,  4, 'Contracts.LBL_MODULE_NAME'        , 'vwOPPORTUNITIES_CONTRACTS'         , 'OPPORTUNITY_ID', 'CONTRACT_NAME', 'asc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Contracts.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Contracts.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView.Mobile'     , 'Documents'        , 'Documents'          ,  0, 'Documents.LBL_MODULE_NAME'        , 'vwCONTRACTS_DOCUMENTS'         , 'CONTRACT_ID', 'DOCUMENT_NAME', 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView.Mobile'     , 'Notes'            , 'Notes'              ,  1, 'Notes.LBL_MODULE_NAME'            , 'vwCONTRACTS_NOTES'             , 'CONTRACT_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView.Mobile'     , 'Contacts'         , 'Contacts'           ,  2, 'Contacts.LBL_MODULE_NAME'         , 'vwCONTRACTS_CONTACTS'          , 'CONTRACT_ID', 'CONTACT_NAME' , 'asc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView.Mobile'     , 'Products'         , 'Products'           ,  3, 'Products.LBL_MODULE_NAME'         , 'vwCONTRACTS_PRODUCTS'          , 'CONTRACT_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Contracts.DetailView.Mobile'     , 'Quotes'           , 'Quotes'             ,  4, 'Quotes.LBL_MODULE_NAME'           , 'vwCONTRACTS_QUOTES'            , 'CONTRACT_ID', 'DATE_ENTERED' , 'desc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Quotes.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Quotes.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView.Mobile'        , 'Orders'           , 'Orders'             ,  0, 'Orders.LBL_MODULE_NAME'           , 'vwQUOTES_ORDERS'            , 'QUOTE_ID', 'DATE_ENTERED' , 'desc';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Quotes.DetailView.Mobile'        , 'Invoices'         , 'Invoices'           ,  1, 'Invoices.LBL_MODULE_NAME'         , 'vwQUOTES_INVOICES'          , 'QUOTE_ID', 'DATE_ENTERED' , 'desc';
end -- if;
GO


if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Orders.DetailView.Mobile' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Orders.DetailView Professional';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Orders.DetailView.Mobile'        , 'Invoices'         , 'Invoices'           ,  0, 'Invoices.LBL_MODULE_NAME'         , 'vwORDERS_INVOICES'          , 'ORDER_ID', 'DATE_ENTERED' , 'desc';
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_MobilePro()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_MobilePro')
/

-- #endif IBM_DB2 */


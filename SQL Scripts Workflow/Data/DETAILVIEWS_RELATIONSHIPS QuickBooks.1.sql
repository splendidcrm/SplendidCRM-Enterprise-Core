

print 'DETAILVIEWS_RELATIONSHIPS QuickBooks';
GO

set nocount on;
GO

-- 10/13/2012 Paul.  Add table info for HTML5 Offline Client. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'QuickBooks.DetailView';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'QuickBooks.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS QuickBooks.DetailView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'PaymentTypes'    , 'PaymentTypes'    ,  0, 'QuickBooks.LBL_NOT_SYNCD_PAYMENT_TYPES'    , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'PaymentTerms'    , 'PaymentTerms'    ,  1, 'QuickBooks.LBL_NOT_SYNCD_PAYMENT_TERMS'    , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'Shippers'        , 'Shippers'        ,  2, 'QuickBooks.LBL_NOT_SYNCD_SHIPPERS'         , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'TaxRates'        , 'TaxRates'        ,  3, 'QuickBooks.LBL_NOT_SYNCD_TAX_RATES'        , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'ProductTemplates', 'ProductTemplates',  4, 'QuickBooks.LBL_NOT_SYNCD_PRODUCT_TEMPLATES', null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'Accounts'        , 'Accounts'        ,  5, 'QuickBooks.LBL_NOT_SYNCD_ACCOUNTS'         , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'Quotes'          , 'Quotes'          ,  6, 'QuickBooks.LBL_NOT_SYNCD_QUOTES'           , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'Invoices'        , 'Invoices'        ,  7, 'QuickBooks.LBL_NOT_SYNCD_INVOICES'         , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'Orders'          , 'Orders'          ,  8, 'QuickBooks.LBL_NOT_SYNCD_ORDERS'           , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'Payments'        , 'Payments'        ,  9, 'QuickBooks.LBL_NOT_SYNCD_PAYMENTS'         , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'Payments'        , 'CreditMemos'     , 10, 'QuickBooks.LBL_NOT_SYNCD_CREDIT_MEMOS'     , null, null, null, null;
end else begin
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'QuickBooks.DetailView' and MODULE_NAME = 'PaymentTerms' and DELETED = 0) begin -- then
		update DETAILVIEWS_RELATIONSHIPS
		   set RELATIONSHIP_ORDER = RELATIONSHIP_ORDER + 2
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		 where DETAIL_NAME        = 'QuickBooks.DetailView'
		   and DELETED            = 0;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'PaymentTypes'    , 'PaymentTypes'    ,  0, 'QuickBooks.LBL_NOT_SYNCD_PAYMENT_TYPES'    , null, null, null, null;
		exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'PaymentTerms'    , 'PaymentTerms'    ,  1, 'QuickBooks.LBL_NOT_SYNCD_PAYMENT_TERMS'    , null, null, null, null;
	end -- if;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'Payments'        , 'Payments'        ,  9, 'QuickBooks.LBL_NOT_SYNCD_PAYMENTS'         , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'QuickBooks.DetailView'      , 'Payments'        , 'CreditMemos'     , 10, 'QuickBooks.LBL_NOT_SYNCD_CREDIT_MEMOS'     , null, null, null, null;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_QuickBooks()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_QuickBooks')
/

-- #endif IBM_DB2 */


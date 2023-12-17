

print 'DETAILVIEWS_RELATIONSHIPS TabMenu Professional';
--delete from DETAILVIEWS_RELATIONSHIPS
--GO

set nocount on;
GO

-- 10/13/2012 Paul.  Add table info for HTML5 Offline Client. 
-- 02/23/2013 Paul.  Add Calendar for HTML5 Offline Client. 
-- delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'TabMenu';
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'TabMenu' and MODULE_NAME = 'Quotes' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS TabMenu';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'TabMenu'       , 'Quotes'           , '~/Quotes/SearchQuotes'              ,  7, 'Quotes.LBL_LIST_FORM_TITLE'       , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'TabMenu'       , 'Orders'           , '~/Orders/SearchOrders'              ,  8, 'Orders.LBL_LIST_FORM_TITLE'       , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'TabMenu'       , 'Invoices'         , '~/Invoices/SearchInvoices'          ,  9, 'Invoices.LBL_LIST_FORM_TITLE'     , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'TabMenu'       , 'Contracts'        , '~/Contracts/SearchContracts'        , 10, 'Contracts.LBL_LIST_FORM_TITLE'    , null, null, null, null;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_TabMenuPro()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_TabMenuPro')
/

-- #endif IBM_DB2 */


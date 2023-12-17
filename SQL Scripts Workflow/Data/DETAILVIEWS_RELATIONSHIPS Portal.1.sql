

print 'DETAILVIEWS_RELATIONSHIPS Portal';
--delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME like '%.Portal';
--GO

set nocount on;
GO

-- 10/13/2012 Paul.  Add table info for HTML5 Offline Client. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.DetailView.Body.Portal' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Home.DetailView.Body.Portal';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.DetailView.Body.Portal'          , 'Cases'            , '~/Cases/MyCases'                ,  0, 'Cases.LBL_LIST_MY_CASES'              , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.DetailView.Body.Portal'          , 'Bugs'             , '~/Bugs/MyBugs'                  ,  1, 'Bugs.LBL_LIST_MY_BUGS'                , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.DetailView.Body.Portal'          , 'Quotes'           , '~/Quotes/MyQuotes'              ,  2, 'Quotes.LBL_LIST_MY_QUOTES'            , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.DetailView.Body.Portal'          , 'Orders'           , '~/Orders/MyOrders'              ,  3, 'Orders.LBL_LIST_MY_ORDERS'            , null, null, null, null;
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.DetailView.Body.Portal'          , 'Invoices'         , '~/Invoices/MyInvoices'          ,  4, 'Invoices.LBL_LIST_MY_INVOICES'        , null, null, null, null;
end -- if;

if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Home.DetailView.Right.Portal' and CONTROL_NAME = '~/Administration/TeamNotices/MyTeamNotices' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Home.DetailView.Right.Portal';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Home.DetailView.Right.Portal'         , 'Home'             , '~/Administration/TeamNotices/MyTeamNotices', 0, 'Home.LBL_TEAM_NOTICES_TITLE', null, null, null, null;
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

call dbo.spDETAILVIEWS_RELATIONSHIPS_Portal()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_RELATIONSHIPS_Portal')
/

-- #endif IBM_DB2 */




print 'GRIDVIEWS Professional';
GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
--exec dbo.spGRIDVIEWS_InsertOnly 'Forecasts.ListView'     , 'Forecasts'     , 'vwFORECASTS_List'     ;
exec dbo.spGRIDVIEWS_InsertOnly 'Products.ListView'      , 'Products'      , 'vwPRODUCTS_List'      ;
exec dbo.spGRIDVIEWS_InsertOnly 'Quotes.ListView'        , 'Quotes'        , 'vwQUOTES_List'        ;
--exec dbo.spGRIDVIEWS_InsertOnly 'ReportMaker.ListView'   , 'ReportMaker'   , 'vwREPORTMAKER_List'   ;
exec dbo.spGRIDVIEWS_InsertOnly 'Reports.ListView'       , 'Reports'       , 'vwREPORTS_List'       ;
--exec dbo.spGRIDVIEWS_InsertOnly 'Roles.ListView'         , 'Roles'         , 'vwROLES_List'         ;
--exec dbo.spGRIDVIEWS_InsertOnly 'Sync.ListView'          , 'Sync'          , 'vwSYNC_List'          ;
exec dbo.spGRIDVIEWS_InsertOnly 'Teams.ListView'         , 'Teams'         , 'vwTEAMS_List'         ;
-- 06/03/2006 Paul.  Add Contracts view. 
exec dbo.spGRIDVIEWS_InsertOnly 'Contracts.ListView'     , 'Contracts'     , 'vwCONTRACTS_List'     ;
-- 10/15/2006 Paul.  Add Team Notices view. 
exec dbo.spGRIDVIEWS_InsertOnly 'TeamNotices.ListView'   , 'TeamNotices'   , 'vwTEAM_NOTICES_List'  ;
-- 04/03/2007 Paul.  Add Orders module. 
exec dbo.spGRIDVIEWS_InsertOnly 'Orders.ListView'        , 'Orders'        , 'vwORDERS_List'        ;
-- 04/11/2007 Paul.  Add Invoices module. 
exec dbo.spGRIDVIEWS_InsertOnly 'Invoices.ListView'      , 'Invoices'      , 'vwINVOICES_List'      ;
exec dbo.spGRIDVIEWS_InsertOnly 'Payments.ListView'      , 'Payments'      , 'vwPAYMENTS_List'      ;
-- 07/15/2007 Paul.  Add forums/threaded discussions.
exec dbo.spGRIDVIEWS_InsertOnly 'Forums.ListView'        , 'Forums'        , 'vwFORUMS_List'        ;
-- 10/18/2009 Paul.  Add Knowledge Base module. 
exec dbo.spGRIDVIEWS_InsertOnly 'KBDocuments.ListView'   , 'KBDocuments'   , 'vwKBDOCUMENTS_List'   ;
exec dbo.spGRIDVIEWS_InsertOnly 'KBTags.ListView'        , 'KBTags'        , 'vwKBTAGS_List'        ;
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

call dbo.spGRIDVIEWS_Professional()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_Professional')
/

-- #endif IBM_DB2 */


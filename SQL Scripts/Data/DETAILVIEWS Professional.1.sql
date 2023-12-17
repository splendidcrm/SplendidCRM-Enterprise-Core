

print 'DETAILVIEWS Professional';
--delete from DETAILVIEWS
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 09/14/2008 Paul.  DB2 does not work well with optional parameters. 
--exec dbo.spDETAILVIEWS_InsertOnly 'Administration.DetailView', 'Administration', 'vwADMINISTRATION_Edit', '15%', '35%', null;
--exec dbo.spDETAILVIEWS_InsertOnly 'Forecasts.DetailView'     , 'Forecasts'     , 'vwFORECASTS_Edit'     , '15%', '35%', null;
exec dbo.spDETAILVIEWS_InsertOnly 'Products.DetailView'      , 'Products'      , 'vwPRODUCTS_Edit'      , '15%', '35%', null;
exec dbo.spDETAILVIEWS_InsertOnly 'Quotes.DetailView'        , 'Quotes'        , 'vwQUOTES_Edit'        , '15%', '35%', null;
--exec dbo.spDETAILVIEWS_InsertOnly 'ReportMaker.DetailView'   , 'ReportMaker'   , 'vwREPORTMAKER_Edit'   , '15%', '35%', null;
exec dbo.spDETAILVIEWS_InsertOnly 'Reports.DetailView'       , 'Reports'       , 'vwREPORTS_Edit'       , '15%', '35%', null;
--exec dbo.spDETAILVIEWS_InsertOnly 'Roles.DetailView'         , 'Roles'         , 'vwROLES_Edit'         , '15%', '35%', null;
--exec dbo.spDETAILVIEWS_InsertOnly 'Sync.DetailView'          , 'Sync'          , 'vwSYNC_Edit'          , '15%', '35%', null;
exec dbo.spDETAILVIEWS_InsertOnly 'Teams.DetailView'         , 'Teams'         , 'vwTEAMS_Edit'         , '15%', '35%', null;
-- 06/03/2006 Paul.  Add Contracts view. 
exec dbo.spDETAILVIEWS_InsertOnly 'Contracts.DetailView'     , 'Contracts'     , 'vwCONTRACTS_Edit'     , '15%', '35%', null;
-- 10/15/2006 Paul.  Add Team Notices view. 
exec dbo.spDETAILVIEWS_InsertOnly 'TeamNotices.DetailView'   , 'TeamNotices'   , 'vwTEAM_NOTICES_Edit'  , '15%', '35%', null;
-- 04/03/2007 Paul.  Add Orders module. 
exec dbo.spDETAILVIEWS_InsertOnly 'Orders.DetailView'        , 'Orders'        , 'vwORDERS_Edit'        , '15%', '35%', null;
-- 04/11/2007 Paul.  Add Invoices module. 
exec dbo.spDETAILVIEWS_InsertOnly 'Invoices.DetailView'      , 'Invoices'      , 'vwINVOICES_Edit'      , '15%', '35%', null;
exec dbo.spDETAILVIEWS_InsertOnly 'Payments.DetailView'      , 'Payments'      , 'vwPAYMENTS_Edit'      , '15%', '35%', null;
-- 07/15/2007 Paul.  Add forums/threaded discussions.
exec dbo.spDETAILVIEWS_InsertOnly 'Forums.DetailView'        , 'Forums'        , 'vwFORUMS_Edit'        , '15%', '35%', null;
exec dbo.spDETAILVIEWS_InsertOnly 'Threads.DetailView'       , 'Threads'       , 'vwTHREADS_Edit'       , '15%', '35%', null;
-- 10/18/2009 Paul.  Add Knowledge Base module. 
exec dbo.spDETAILVIEWS_InsertOnly 'KBDocuments.DetailView'   , 'KBDocuments'   , 'vwKBDOCUMENTS_Edit'   , '15%', '35%', null;
exec dbo.spDETAILVIEWS_InsertOnly 'KBTags.DetailView'        , 'KBTags'        , 'vwKBTAGS_Edit'        , '15%', '35%', null;
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

call dbo.spDETAILVIEWS_Professional()
/

call dbo.spSqlDropProcedure('spDETAILVIEWS_Professional')
/

-- #endif IBM_DB2 */


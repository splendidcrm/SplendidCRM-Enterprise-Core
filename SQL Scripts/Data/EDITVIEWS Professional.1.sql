

print 'EDITVIEWS Professional';
--delete from EDITVIEWS
--GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 09/14/2008 Paul.  DB2 does not work well with optional parameters. 
-- 09/14/2008 Paul.  DB2 does not work well with optional parameters. 
--exec dbo.spEDITVIEWS_InsertOnly 'Administration.EditView', 'Administration', 'vwADMINISTRATION_Edit', '15%', '35%', null;
--exec dbo.spEDITVIEWS_InsertOnly 'Forecasts.EditView'     , 'Forecasts'     , 'vwFORECASTS_Edit'     , '15%', '35%', null;
exec dbo.spEDITVIEWS_InsertOnly 'Products.EditView'      , 'Products'      , 'vwPRODUCTS_Edit'      , '15%', '35%', null;
exec dbo.spEDITVIEWS_InsertOnly 'Quotes.EditView'        , 'Quotes'        , 'vwQUOTES_Edit'        , '15%', '35%', null;
--exec dbo.spEDITVIEWS_InsertOnly 'ReportMaker.EditView'   , 'ReportMaker'   , 'vwREPORTMAKER_Edit'   , '15%', '35%', null;
exec dbo.spEDITVIEWS_InsertOnly 'Reports.EditView'       , 'Reports'       , 'vwREPORTS_Edit'       , '15%', '35%', null;
--exec dbo.spEDITVIEWS_InsertOnly 'Roles.EditView'         , 'Roles'         , 'vwROLES_Edit'         , '15%', '35%', null;
--exec dbo.spEDITVIEWS_InsertOnly 'Sync.EditView'          , 'Sync'          , 'vwSYNC_Edit'          , '15%', '35%', null;
exec dbo.spEDITVIEWS_InsertOnly 'Teams.EditView'         , 'Teams'         , 'vwTEAMS_Edit'         , '15%', '35%', null;
-- 06/03/2006 Paul.  Add Contracts view. 
exec dbo.spEDITVIEWS_InsertOnly 'Contracts.EditView'     , 'Contracts'     , 'vwCONTRACTS_Edit'     , '15%', '35%', null;
-- 10/15/2006 Paul.  Add Team Notices view. 
exec dbo.spEDITVIEWS_InsertOnly 'TeamNotices.EditView'   , 'TeamNotices'   , 'vwTEAM_NOTICES_Edit'  , '15%', '35%', null;
-- 04/03/2007 Paul.  Add Orders module. 
exec dbo.spEDITVIEWS_InsertOnly 'Orders.EditView'        , 'Orders'        , 'vwORDERS_Edit'        , '15%', '35%', null;
-- 04/11/2007 Paul.  Add Invoices module. 
exec dbo.spEDITVIEWS_InsertOnly 'Invoices.EditView'      , 'Invoices'      , 'vwINVOICES_Edit'      , '15%', '35%', null;
exec dbo.spEDITVIEWS_InsertOnly 'Payments.EditView'      , 'Payments'      , 'vwPAYMENTS_Edit'      , '15%', '35%', null;
-- 07/15/2007 Paul.  Add forums/threaded discussions.
exec dbo.spEDITVIEWS_InsertOnly 'Forums.EditView'        , 'Forums'        , 'vwFORUMS_Edit'        , '15%', '85%', null;
-- 10/18/2009 Paul.  Add Knowledge Base module. 
exec dbo.spEDITVIEWS_InsertOnly 'KBDocuments.EditView'   , 'KBDocuments'   , 'vwKBDOCUMENTS_Edit'   , '15%', '85%', null;
exec dbo.spEDITVIEWS_InsertOnly 'KBTags.EditView'        , 'KBTags'        , 'vwKBTAGS_Edit'        , '15%', '35%', null;

-- 04/06/2016 Paul.  We want to be able to run a workflow when a signature has been submitted. 
exec dbo.spEDITVIEWS_InsertOnly 'Quotes.SubmitSignature'   , 'Quotes'      , 'vwQUOTES_Edit'        , '15%', '35%', null;
exec dbo.spEDITVIEWS_InsertOnly 'Orders.SubmitSignature'   , 'Orders'      , 'vwORDERS_Edit'        , '15%', '35%', null;
exec dbo.spEDITVIEWS_InsertOnly 'Invoices.SubmitSignature' , 'Invoices'    , 'vwINVOICES_Edit'      , '15%', '35%', null;
exec dbo.spEDITVIEWS_InsertOnly 'Contracts.SubmitSignature', 'Contracts'   , 'vwCONTRACTS_Edit'     , '15%', '35%', null;
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

call dbo.spEDITVIEWS_Professional()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_Professional')
/

-- #endif IBM_DB2 */


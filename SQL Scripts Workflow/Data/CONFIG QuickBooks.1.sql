

print 'CONFIG QuickBooks';
GO

set nocount on;
GO

-- 05/11/2012 Paul.  We will be connecting to QuickBooks via RSSBus. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.Enabled'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.VerboseStatus'         , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.ConflictResolution'    , '';  -- blank, remote, local 
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.Direction'             , 'bi-directional';  -- bi-directional, to crm only, from crm only
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.SyncQuotes'            , 'true';
-- 05/23/2012 Paul.  QuickBooks Sales Orders are not suppored on QuickBooks Pro. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.SyncOrders'            , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.SyncInvoices'          , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.SyncPayments'          , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.SyncCreditMemos'       , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.MaxRecords'            , '0';  -- Maximum records per sync operation. 

exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.RemoteUser'            , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.RemotePassword'        , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.RemoteURL'             , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.RemoteApplicationName' , '';
					
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.OAuthCompanyID'        , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.OAuthCountryCode'      , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.OAuthClientID'         , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.OAuthClientSecret'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.OAuthAccessToken'      , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.OAuthAccessTokenSecret', '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'QuickBooks.OAuthVerifier'         , '';
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

call dbo.spCONFIG_QuickBooks()
/

call dbo.spSqlDropProcedure('spCONFIG_QuickBooks')
/

-- #endif IBM_DB2 */




print 'CONFIG PhoneBurner';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.Enabled'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.VerboseStatus'         , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.ConflictResolution'    , '';  -- blank, remote, local 
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.Direction'             , 'bi-directional';  -- bi-directional, to crm only, from crm only
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.MaxRecords'            , '0';  -- Maximum records per sync operation. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.SyncModules'           , 'Leads';

exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.PortalID'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.ClientID'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.OAuthClientSecret'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.OAuthAccessToken'      , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.OAuthRefreshToken'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'PhoneBurner.OAuthExpiresAt'        , '';
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

call dbo.spCONFIG_PhoneBurner()
/

call dbo.spSqlDropProcedure('spCONFIG_PhoneBurner')
/

-- #endif IBM_DB2 */


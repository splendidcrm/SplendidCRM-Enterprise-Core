

print 'CONFIG HubSpot';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.Enabled'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.VerboseStatus'         , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.ConflictResolution'    , '';  -- blank, remote, local 
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.Direction'             , 'bi-directional';  -- bi-directional, to crm only, from crm only
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.MaxRecords'            , '0';  -- Maximum records per sync operation. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.SyncModules'           , 'Leads';

exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.PortalID'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.ClientID'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.OAuthClientSecret'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.OAuthAccessToken'      , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.OAuthRefreshToken'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'HubSpot.OAuthExpiresAt'        , '';
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

call dbo.spCONFIG_HubSpot()
/

call dbo.spSqlDropProcedure('spCONFIG_HubSpot')
/

-- #endif IBM_DB2 */


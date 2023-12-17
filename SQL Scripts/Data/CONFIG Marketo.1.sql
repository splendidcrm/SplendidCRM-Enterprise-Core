

print 'CONFIG Marketo';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.Enabled'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.VerboseStatus'         , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.ConflictResolution'    , '';  -- blank, remote, local 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.Direction'             , 'bi-directional';  -- bi-directional, to crm only, from crm only
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.MaxRecords'            , '0';  -- Maximum records per sync operation. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.SyncModules'           , 'Leads';

exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.EndpointURL'           , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.IdentityURL'           , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.ClientID'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.OAuthClientSecret'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.OAuthAccessToken'      , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.OAuthScope'            , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Marketo.OAuthExpiresAt'        , '';
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

call dbo.spCONFIG_Marketo()
/

call dbo.spSqlDropProcedure('spCONFIG_Marketo')
/

-- #endif IBM_DB2 */


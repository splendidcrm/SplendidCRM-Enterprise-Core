

print 'CONFIG ConstantContact';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'ConstantContact.Enabled'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'ConstantContact.VerboseStatus'         , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'ConstantContact.ConflictResolution'    , '';  -- blank, remote, local 
exec dbo.spCONFIG_InsertOnly null, 'system', 'ConstantContact.Direction'             , 'bi-directional';  -- bi-directional, to crm only, from crm only
exec dbo.spCONFIG_InsertOnly null, 'system', 'ConstantContact.MaxRecords'            , '0';  -- Maximum records per sync operation. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'ConstantContact.SyncModules'           , 'Leads';

exec dbo.spCONFIG_InsertOnly null, 'system', 'ConstantContact.ClientID'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'ConstantContact.OAuthClientSecret'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'ConstantContact.OAuthAccessToken'      , '';
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

call dbo.spCONFIG_ConstantContact()
/

call dbo.spSqlDropProcedure('spCONFIG_ConstantContact')
/

-- #endif IBM_DB2 */




print 'CONFIG Pardot';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.Enabled'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.VerboseStatus'         , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.ConflictResolution'    , '';  -- blank, remote, local 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.Direction'             , 'bi-directional';  -- bi-directional, to crm only, from crm only
exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.MaxRecords'            , '0';  -- Maximum records per sync operation. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.SyncModules'           , 'Leads';

exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.ApiAppId'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.ApiUsername'           , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.ApiPassword'           , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.PardotAccountId'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Pardot.PardotClientFolderId', '';
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

call dbo.spCONFIG_Pardot()
/

call dbo.spSqlDropProcedure('spCONFIG_Pardot')
/

-- #endif IBM_DB2 */


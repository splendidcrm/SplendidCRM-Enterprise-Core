

print 'CONFIG iContact';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.Enabled'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.VerboseStatus'         , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.ConflictResolution'    , '';  -- blank, remote, local 
exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.Direction'             , 'bi-directional';  -- bi-directional, to crm only, from crm only
exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.MaxRecords'            , '0';  -- Maximum records per sync operation. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.SyncModules'           , 'Leads';

exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.ApiAppId'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.ApiUsername'           , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.ApiPassword'           , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.iContactAccountId'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'iContact.iContactClientFolderId', '';
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

call dbo.spCONFIG_iContact()
/

call dbo.spSqlDropProcedure('spCONFIG_iContact')
/

-- #endif IBM_DB2 */


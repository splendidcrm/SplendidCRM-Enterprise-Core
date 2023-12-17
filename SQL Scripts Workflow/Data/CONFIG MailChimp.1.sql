

print 'CONFIG MailChimp';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.Enabled'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.VerboseStatus'         , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.ConflictResolution'    , '';  -- blank, remote, local 
exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.Direction'             , 'bi-directional';  -- bi-directional, to crm only, from crm only
exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.MaxRecords'            , '0';  -- Maximum records per sync operation. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.SyncModules'           , 'Leads';
exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.MergeFields'           , 'FIRST_NAME:FNAME,LAST_NAME:LNAME';

exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.DataCenter'            , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.ClientID'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.OAuthClientSecret'     , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'MailChimp.OAuthAccessToken'      , '';
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

call dbo.spCONFIG_MailChimp()
/

call dbo.spSqlDropProcedure('spCONFIG_MailChimp')
/

-- #endif IBM_DB2 */


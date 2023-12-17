

print 'CONFIG Asterisk';
GO

set nocount on;
GO

-- 09/04/2013 Paul.  Add support for Asterisk. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.Host'                          , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.Port'                          , '5038';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.UserName'                      , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.Password'                      , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.Trunk'                         , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.Context'                       , 'from-internal';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.LogCallDetails'                , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.LogIncomingMissedCalls'        , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.LogOutgoingMissedCalls'        , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Asterisk.OriginateExtensionFirst'       , 'true';
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

call dbo.spCONFIG_Asterisk()
/

call dbo.spSqlDropProcedure('spCONFIG_Asterisk')
/

-- #endif IBM_DB2 */


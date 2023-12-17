

print 'CONFIG Avaya';
GO

set nocount on;
GO

-- 12/03/2013 Paul.  Add support for Avaya. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Avaya.Host'                             , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Avaya.Port'                             , '5038';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Avaya.SecureSocket'                     , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Avaya.UserName'                         , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Avaya.Password'                         , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Avaya.SwitchName'                       , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Avaya.Context'                          , 'from-internal';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Avaya.VerboseStatus'                    , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Avaya.Certificate'                      , '';
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

call dbo.spCONFIG_Avaya()
/

call dbo.spSqlDropProcedure('spCONFIG_Avaya')
/

-- #endif IBM_DB2 */


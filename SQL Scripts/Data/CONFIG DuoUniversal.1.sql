

print 'CONFIG DuoUniversal';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'DuoUniversal.Enabled'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'DuoUniversal.VerboseStatus'         , 'false';

exec dbo.spCONFIG_InsertOnly null, 'system', 'DuoUniversal.ClientID'              , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'DuoUniversal.ClientSecret'          , '';
exec dbo.spCONFIG_InsertOnly null, 'system', 'DuoUniversal.ApiHostURL'            , '';
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

call dbo.spCONFIG_DuoUniversal()
/

call dbo.spSqlDropProcedure('spCONFIG_DuoUniversal')
/

-- #endif IBM_DB2 */


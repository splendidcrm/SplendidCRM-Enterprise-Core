

print 'CONFIG PayPal';
GO

set nocount on;
GO

-- 01/01/2016 Paul.  Move PayPal module to Professional. 

-- 02/05/2009 Paul.  Set PayPal records to the Global team. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'PayPalIPN.TEAM_ID'                      , '17BB7135-2B95-42DC-85DE-842CAFF927A0';
exec dbo.spCONFIG_InsertOnly null, 'system', 'PayPalIPN.ASSIGNED_USER_ID'             , '00000000-0000-0000-0000-000000000005';

-- 09/13/2011 Paul.  Create empty paypal config entries. 
exec dbo.spCONFIG_InsertOnly null, 'PayPal', 'PayPal.APIPassword'    , '';
exec dbo.spCONFIG_InsertOnly null, 'PayPal', 'PayPal.APIUsername'    , '';
exec dbo.spCONFIG_InsertOnly null, 'PayPal', 'PayPal.Sandbox'        , 'false';
exec dbo.spCONFIG_InsertOnly null, 'PayPal', 'PayPal.X509Certificate', '';
exec dbo.spCONFIG_InsertOnly null, 'PayPal', 'PayPal.X509PrivateKey' , '';

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

call dbo.spCONFIG_PayPal()
/

call dbo.spSqlDropProcedure('spCONFIG_PayPal')
/

-- #endif IBM_DB2 */


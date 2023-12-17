

print 'CONFIG Enterprise';
GO

set nocount on;
GO

-- 10/15/2008 Paul.  Move enterprise modules to a separate file. 

-- 08/29/2009 Paul.  Dynamic teams can be enabled and disabled. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'enable_dynamic_teams'                   , 'true';

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

call dbo.spCONFIG_Enterprise()
/

call dbo.spSqlDropProcedure('spCONFIG_Enterprise')
/

-- #endif IBM_DB2 */


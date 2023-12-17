

print 'CONFIG Workflow';
GO

set nocount on;
GO

-- 08/09/2008 Paul.  The default setting will prevent any workflow from being triggered from another workflow. 
exec dbo.spCONFIG_InsertOnly null, 'Workflow', 'workflow_protection_level', '10';

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

call dbo.spCONFIG_Workflow()
/

call dbo.spSqlDropProcedure('spCONFIG_Workflow')
/

-- #endif IBM_DB2 */


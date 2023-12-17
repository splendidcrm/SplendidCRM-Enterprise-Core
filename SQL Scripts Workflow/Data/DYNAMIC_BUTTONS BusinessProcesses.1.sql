

print 'DYNAMIC_BUTTONS BusinessProcesses';
GO

set nocount on;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView', 'BusinessProcesses.DetailView', 'BusinessProcesses';
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

call dbo.spDYNAMIC_BUTTONS_BusinessProcesses()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_BusinessProcesses')
/

-- #endif IBM_DB2 */


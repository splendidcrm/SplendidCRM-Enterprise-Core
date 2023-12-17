

print 'TEAMS Portal';
GO
-- delete TEAMS
set nocount on;
GO

-- 06/30/2010 Paul.  Products will only be visible if assigned to this team. 
exec dbo.spTEAMS_InsertOnly 'C1698CF0-B0C8-40DA-BF95-08C65E6AB47B', 'Portal', 'Visible on Portal';
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

call dbo.spTEAMS_Portal()
/

call dbo.spSqlDropProcedure('spTEAMS_Portal')
/

-- #endif IBM_DB2 */


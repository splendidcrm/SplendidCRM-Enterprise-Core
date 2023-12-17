

	-- 09/20/2007 Paul.  Move private team creation to procedure for better access. 
	-- 09/14/2008 Paul.  A single space after the procedure simplifies the migration to DB2. 
	exec dbo.spTEAMS_InitPrivate ;
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

call dbo.spUSERS_privateteam()
/

call dbo.spSqlDropProcedure('spUSERS_privateteam')
/

-- #endif IBM_DB2 */


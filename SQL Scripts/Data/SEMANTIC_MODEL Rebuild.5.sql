

set nocount on;
GO

-- 11/20/2015 Paul.  Nobody is using the Semantic Model. 
-- exec dbo.spSEMANTIC_MODEL_Rebuild ;
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

call dbo.spSEMANTIC_MODEL_RebuildData()
/

call dbo.spSqlDropProcedure('spSEMANTIC_MODEL_RebuildData')
/

-- #endif IBM_DB2 */


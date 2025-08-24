

print 'MODULES DuoUniversal';
GO

set nocount on;
GO

-- 08/07/2025 Paul.  Add DuoUniversal module. 
exec dbo.spMODULES_InsertOnly null, 'DuoUniversal'             , '.moduleList.DuoUniversal'                , '~/Administration/DuoUniversal/'        , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
GO


-- 08/24/2008 Paul.  Reorder the modules. 
exec dbo.spMODULES_Reorder null;
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

call dbo.spMODULES_DuoUniversal()
/

call dbo.spSqlDropProcedure('spMODULES_DuoUniversal')
/

-- #endif IBM_DB2 */


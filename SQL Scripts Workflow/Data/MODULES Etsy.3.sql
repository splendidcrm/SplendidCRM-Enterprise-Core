

print 'MODULES Etsy';
GO

set nocount on;
GO

-- 03/11/2022 Paul.  Add Etsy module. 
exec dbo.spMODULES_InsertOnly null, 'Etsy'       , '.moduleList.Etsy'          , '~/Administration/Etsy/'  , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;


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

call dbo.spMODULES_Etsy()
/

call dbo.spSqlDropProcedure('spMODULES_Etsy')
/

-- #endif IBM_DB2 */


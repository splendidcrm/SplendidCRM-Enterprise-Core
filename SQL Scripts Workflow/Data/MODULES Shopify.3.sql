

print 'MODULES Shopify';
GO

set nocount on;
GO

-- 03/08/2022 Paul.  Add Shopify module. 
exec dbo.spMODULES_InsertOnly null, 'Shopify'       , '.moduleList.Shopify'          , '~/Administration/Shopify/'  , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;


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

call dbo.spMODULES_Shopify()
/

call dbo.spSqlDropProcedure('spMODULES_Shopify')
/

-- #endif IBM_DB2 */


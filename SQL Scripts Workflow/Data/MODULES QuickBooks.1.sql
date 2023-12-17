

print 'MODULES QuickBooks';
GO

set nocount on;
GO

-- 05/23/2012 Paul.  Add QuickBooks module. 
exec dbo.spMODULES_InsertOnly null, 'QuickBooks'            , '.moduleList.QuickBooks'                , '~/Administration/QuickBooks/'            , 1, 0,  0, 0, 0, 0, 0, 1, null                      , 0, 0, 0, 0, 0, 0;
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

call dbo.spMODULES_QuickBooks()
/

call dbo.spSqlDropProcedure('spMODULES_QuickBooks')
/

-- #endif IBM_DB2 */




print 'MODULES Processes';
GO

set nocount on;
GO

-- select * from vwMODULES order by TAB_ORDER desc
exec dbo.spMODULES_InsertOnly null, 'Processes'     , '.moduleList.Processes'         , '~/Processes/'                    , 1, 1, 14, 0, 0, 0, 0, 0, 'PROCESSES'             , 0, 0, 0, 0, 0, 0;
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

call dbo.spMODULES_Processes()
/

call dbo.spSqlDropProcedure('spMODULES_Processes')
/

-- #endif IBM_DB2 */


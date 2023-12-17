

print 'MODULES DataPrivacy';
GO

set nocount on;
GO

-- 06/24/2018 Paul.  Add DataPrivacy module. 
-- 07/03/2018 Paul.  Enable Data Privacy by default. 
exec dbo.spMODULES_InsertOnly null, 'DataPrivacy'             , '.moduleList.DataPrivacy'                , '~/Administration/DataPrivacy/'        , 1, 0,  0, 0, 0, 0, 0, 1, 'DATA_PRIVACY', 0, 0, 0, 0, 0, 0;
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

call dbo.spMODULES_DataPrivacy()
/

call dbo.spSqlDropProcedure('spMODULES_DataPrivacy')
/

-- #endif IBM_DB2 */


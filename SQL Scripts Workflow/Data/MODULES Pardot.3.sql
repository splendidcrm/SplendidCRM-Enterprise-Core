

print 'MODULES Pardot';
GO

set nocount on;
GO

-- 04/04/2016 Paul.  Add Pardot module. 
exec dbo.spMODULES_InsertOnly null, 'Pardot'             , '.moduleList.Pardot'                , '~/Administration/Pardot/'        , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 0, 0, 0, 0, 0;
GO

-- 07/31/2019 Paul.  DEFAULT_SORT is a new field for the React Client. 
if exists(select * from MODULES where MODULE_NAME = N'Pardot' and DEFAULT_SORT is null) begin -- then
	print 'MODULES: Update DEFAULT_SORT defaults.';
	update MODULES
	   set DEFAULT_SORT        = 'updated_at desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'Pardot';
end -- if;
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

call dbo.spMODULES_Pardot()
/

call dbo.spSqlDropProcedure('spMODULES_Pardot')
/

-- #endif IBM_DB2 */


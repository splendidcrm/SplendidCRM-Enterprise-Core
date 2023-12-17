

print 'MODULES Avaya';
GO

set nocount on;
GO

-- 12/03/2013 Paul.  Add AvayaView. 
exec dbo.spMODULES_InsertOnly null, 'Avaya'              , '.moduleList.Avaya'                 , '~/Administration/Avaya/'         , 1, 0,  0, 0, 0, 0, 0, 1, null                 , 0, 1, 0, 0, 0, 0;
GO

-- 07/31/2019 Paul.  DEFAULT_SORT is a new field for the React Client. 
if exists(select * from MODULES where MODULE_NAME = N'Avaya' and DEFAULT_SORT is null) begin -- then
	print 'MODULES: Update DEFAULT_SORT defaults.';
	update MODULES
	   set DEFAULT_SORT        = 'NAME desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'Avaya';
end -- if;
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

call dbo.spMODULES_Avaya()
/

call dbo.spSqlDropProcedure('spMODULES_Avaya')
/

-- #endif IBM_DB2 */


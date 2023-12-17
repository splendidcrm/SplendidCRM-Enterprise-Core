

print 'MODULES BusinessProcesses';
GO

set nocount on;
GO

exec dbo.spMODULES_InsertOnly null, 'BusinessProcesses'     , '.moduleList.BusinessProcesses'         , '~/Administration/BusinessProcesses/'     , 1, 0,  0, 0, 0, 0, 0, 1, 'BUSINESS_PROCESSES'      , 0, 0, 0, 0, 0, 0;
exec dbo.spMODULES_InsertOnly null, 'BusinessProcessesLog'  , '.moduleList.BusinessProcessesLog'      , '~/Administration/BusinessProcessesLog/'  , 1, 0,  0, 0, 0, 0, 0, 1, 'BUSINESS_PROCESSES_RUN'  , 0, 0, 0, 0, 0, 0;
GO

-- 07/31/2019 Paul.  DEFAULT_SORT is a new field for the React Client. 
if exists(select * from MODULES where MODULE_NAME = N'Processes' and DEFAULT_SORT is null) begin -- then
	print 'MODULES: Update DEFAULT_SORT defaults.';
	update MODULES
	   set DEFAULT_SORT        = 'DATE_MODIFIED desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'Processes';

	update MODULES
	   set DEFAULT_SORT        = 'DATE_ENTERED desc'
	     , DATE_MODIFIED       = getdate()
	     , DATE_MODIFIED_UTC   = getutcdate()
	     , MODIFIED_USER_ID    = null
	 where DEFAULT_SORT        is null
	   and MODULE_NAME         = N'BusinessProcessesLog';
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

call dbo.spMODULES_BusinessProcesses()
/

call dbo.spSqlDropProcedure('spMODULES_BusinessProcesses')
/

-- #endif IBM_DB2 */


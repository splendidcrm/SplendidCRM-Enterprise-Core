

print 'DASHLETS BusinessProcesses';
--delete from DASHLETS
--GO

set nocount on;
GO

if not exists(select * from DASHLETS where CATEGORY = 'My Dashlets' and CONTROL_NAME = '~/Processes/MyProcesses' and DELETED = 0) begin -- then
	exec dbo.spDASHLETS_InsertOnly 'My Dashlets', 'Processes'      , '~/Processes/MyProcesses', 'Processes.LBL_LIST_MY_PROCESSES', 0;
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

call dbo.spDASHLETS_BusinessProcesses()
/

call dbo.spSqlDropProcedure('spDASHLETS_BusinessProcesses')
/

-- #endif IBM_DB2 */


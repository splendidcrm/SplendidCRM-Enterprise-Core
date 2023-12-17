

print 'DASHBOARD_APPS Enterprise';
--delete from DASHBOARD_APPS
--GO

set nocount on;
GO


if not exists(select * from DASHBOARD_APPS where CATEGORY = 'My Dashboard' and NAME = 'My Processes' and DELETED = 0) begin -- then
	exec dbo.spDASHBOARD_APPS_InsertOnly 'My Processes'                 , 'My Dashboard', 'Processes'    , 'Processes.LBL_LIST_MY_PROCESSES'        , 'Processes.SearchHome'                  , '~/html5/Dashlets/MyProcesses.js'             , 0;
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

call dbo.spDASHBOARD_APPS_Ent()
/

call dbo.spSqlDropProcedure('spDASHBOARD_APPS_Ent')
/

-- #endif IBM_DB2 */


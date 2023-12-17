

if exists(select *
            from MODULES
           where MODULE_NAME    = 'TestPlans'
             and MODULE_ENABLED = 1
             and DELETED        = 0
             ) begin -- then
	print 'TEST_PLANS are being disabled until they are completed.';
	update MODULES
	   set MODULE_ENABLED = 0
	     , DATE_MODIFIED  = getdate()
	 where MODULE_NAME in ('TestPlans', 'TestCases', 'TestRuns');
end -- if;
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

call dbo.spTEST_PLANS_Disable()
/

call dbo.spSqlDropProcedure('spTEST_PLANS_Disable')
/

-- #endif IBM_DB2 */


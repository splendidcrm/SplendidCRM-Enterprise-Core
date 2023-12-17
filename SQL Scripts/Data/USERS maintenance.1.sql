

-- 11/19/2006 Paul.  Team management requires that no users report to themselves. 
if exists(select * from USERS where REPORTS_TO_ID = ID and DELETED = 0) begin -- then
	print 'USERS maintenance: A user may not report to himself.';
	update USERS
	   set REPORTS_TO_ID     = null
	     , MODIFIED_USER_ID  = null
	     , DATE_MODIFIED     = getdate()        
	 where REPORTS_TO_ID     = ID
	   and DELETED           = 0;
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

call dbo.spUSERS_maintenance()
/

call dbo.spSqlDropProcedure('spUSERS_maintenance')
/

-- #endif IBM_DB2 */


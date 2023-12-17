

print 'TEAMS defaults';
GO
-- delete TEAMS
set nocount on;
GO

-- 11/18/2006 Paul.  We need to define a global team with global ID. 
exec dbo.spTEAMS_InsertOnly '17BB7135-2B95-42DC-85DE-842CAFF927A0', 'Global', 'Globally Visible';
GO

-- 04/28/2016 Paul.  PRIVATE flag should not be null. 
if exists(select * from TEAMS where PRIVATE is null and DELETED = 0) begin -- then
	print 'TEAMS: PRIVATE flag should not be null. ';
	update TEAMS
	   set PRIVATE           = 0
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where PRIVATE           is null;
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

call dbo.spTEAMS_Defaults()
/

call dbo.spSqlDropProcedure('spTEAMS_Defaults')
/

-- #endif IBM_DB2 */




print 'CONFIG ServiceLevel';
GO

set nocount on;
GO

exec dbo.spCONFIG_InsertOnly null, 'system', 'service_level'   , 'Professional';
-- 04/21/2010 Paul.  Update the service level when converting from Community to Professional or Full. 
if exists(select * from CONFIG where NAME = N'service_level' and cast(VALUE as nvarchar(20)) in (N'Community', N'Basic') and DELETED = 0) begin -- then
	update CONFIG
	   set VALUE            = N'Professional'
	     , DATE_ENTERED     = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = N'service_level'
	   and DELETED          = 0;
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

call dbo.spCONFIG_ServiceLevel()
/

call dbo.spSqlDropProcedure('spCONFIG_ServiceLevel')
/

-- #endif IBM_DB2 */


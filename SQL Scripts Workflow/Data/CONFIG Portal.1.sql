

print 'CONFIG Portal';
GO

set nocount on;
GO

if exists(select * from CONFIG where NAME = 'portal_on' and cast(VALUE as varchar(20)) = 'false' and DELETED = 0) begin -- then
	update CONFIG
	   set VALUE            = 'true'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'portal_on'
	   and DELETED          = 0;
end -- if;

exec dbo.spCONFIG_InsertOnly null, 'system', 'portal_on'                              , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'portal_self_registration'               , 'true';
-- 06/30/2010 Paul.  Products will only be visible if assigned to this team. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Portal.Team'                            , 'C1698CF0-B0C8-40DA-BF95-08C65E6AB47B';
-- 04/05/2013 Paul.  Portal may require Https. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Portal.Https'                           , 'false';
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

call dbo.spCONFIG_Portal()
/

call dbo.spSqlDropProcedure('spCONFIG_Portal')
/

-- #endif IBM_DB2 */


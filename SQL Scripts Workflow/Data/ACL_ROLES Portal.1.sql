

print 'ACL_ROLES Portal';
GO
-- delete ACL_ROLES
set nocount on;
GO

-- 12/18/2015 Paul.  Need to use ACL to control Shortcuts on Portal. 
-- 09/26/2017 Paul.  Add Archive access right. 
if not exists(select * from ACL_ROLES where ID = '5B99F57A-3F86-4B44-9324-80E777D0EE04') begin -- then
	exec dbo.spACL_ROLES_InsertOnly '5B99F57A-3F86-4B44-9324-80E777D0EE04', 'Portal Role', 'Visible on Portal';
	
	-- 09/26/2017 Paul.  Add Archive access right. 
	-- Access (Enabled = 89, Disabled = -98)
	-- View (All = 90, Owner = 75, None -99)
	-- delete from ACL_ROLES_ACTIONS where ROLE_ID = '5B99F57A-3F86-4B44-9324-80E777D0EE04';
	insert into ACL_ROLES_ACTIONS
		( ID
		, ROLE_ID
		, ACTION_ID
		, ACCESS_OVERRIDE
		)
	select newid()
	     , '5B99F57A-3F86-4B44-9324-80E777D0EE04'
	     , ACL_ACTIONS.ID
	     , (case ACL_ACTIONS.NAME
	        when N'access' then (case when MODULES.MODULE_NAME in (N'Bugs', N'Cases', N'Quotes', N'Orders', N'Invoices', N'Payments', N'KBDocuments', N'Contracts') then 89 else -98 end)
	        when N'view'   then (case when MODULES.MODULE_NAME in (N'Bugs', N'Cases', N'Quotes', N'Orders', N'Invoices', N'Payments', N'KBDocuments', N'Contracts') then 75 else -99 end)
	        when N'list'   then (case when MODULES.MODULE_NAME in (N'Bugs', N'Cases', N'Quotes', N'Orders', N'Invoices', N'Payments', N'KBDocuments', N'Contracts', N'ProductCatalog') then 75 else -99 end)
	        when N'edit'   then (case when MODULES.MODULE_NAME in (N'Bugs', N'Cases', N'Quotes', N'Payments') then 75 else -99 end)
	        when N'delete' then -99
	        when N'import' then -99
	        when N'export' then -99
	        when N'admin'  then -99
	        when N'archive' then -99
	        end)
	  from            MODULES
	       inner join ACL_ACTIONS
	               on ACL_ACTIONS.CATEGORY = MODULE_NAME
	              and ACL_ACTIONS.DELETED  = 0
	  left outer join ACL_ROLES_ACTIONS
	               on ACL_ROLES_ACTIONS.ACTION_ID = ACL_ACTIONS.ID
	              and ACL_ROLES_ACTIONS.ROLE_ID   = '5B99F57A-3F86-4B44-9324-80E777D0EE04'
	              and ACL_ROLES_ACTIONS.DELETED   = 0
	 where MODULES.DELETED  = 0
	   and ACL_ACTIONS.NAME in (N'access', N'view', N'list', N'edit', N'delete', N'import', N'export', N'admin', N'archive')
	   and MODULES.MODULE_NAME not in (N'Activities', N'Calendar', N'Home', N'Teams')
	   and MODULES.IS_ADMIN = 0
	   and ACL_ROLES_ACTIONS.ID is null
	 order by MODULES.MODULE_NAME, ACL_ACTIONS.NAME;
end else begin
	-- 09/26/2017 Paul.  Add Archive access right. 
	if not exists(select * from vwACL_ROLES_ACTIONS where ROLE_ID = '5B99F57A-3F86-4B44-9324-80E777D0EE04' and NAME = 'archive') begin -- then
		insert into ACL_ROLES_ACTIONS
			( ID
			, ROLE_ID
			, ACTION_ID
			, ACCESS_OVERRIDE
			)
		select newid()
		     , '5B99F57A-3F86-4B44-9324-80E777D0EE04'
		     , ACL_ACTIONS.ID
		     , -99
		  from            MODULES
		       inner join ACL_ACTIONS
		               on ACL_ACTIONS.CATEGORY = MODULE_NAME
		              and ACL_ACTIONS.DELETED  = 0
		  left outer join ACL_ROLES_ACTIONS
		               on ACL_ROLES_ACTIONS.ACTION_ID = ACL_ACTIONS.ID
		              and ACL_ROLES_ACTIONS.ROLE_ID   = '5B99F57A-3F86-4B44-9324-80E777D0EE04'
		              and ACL_ROLES_ACTIONS.DELETED   = 0
		 where MODULES.DELETED  = 0
		   and ACL_ACTIONS.NAME = N'archive'
		   and MODULES.MODULE_NAME not in (N'Activities', N'Calendar', N'Home', N'Teams')
		   and MODULES.IS_ADMIN = 0
		   and ACL_ROLES_ACTIONS.ID is null
		 order by MODULES.MODULE_NAME, ACL_ACTIONS.NAME;
	end -- if;
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

call dbo.spACL_ROLES_Portal()
/

call dbo.spSqlDropProcedure('spACL_ROLES_Portal')
/

-- #endif IBM_DB2 */


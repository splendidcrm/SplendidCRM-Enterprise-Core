

print 'ACL_ROLES DataPrivacyManager';
GO
-- delete ACL_ROLES
set nocount on;
GO

if exists(select *
	    from            MODULES
	         inner join ACL_ACTIONS
	                 on ACL_ACTIONS.CATEGORY = MODULE_NAME
	                and ACL_ACTIONS.DELETED  = 0
	    left outer join ACL_ROLES_ACTIONS
	                 on ACL_ROLES_ACTIONS.ACTION_ID = ACL_ACTIONS.ID
	                and ACL_ROLES_ACTIONS.ROLE_ID   = '3013244F-BFA9-4DDB-AF0D-67286C5342A0'
	                and ACL_ROLES_ACTIONS.DELETED   = 0
	   where MODULES.DELETED  = 0
	     and ACL_ACTIONS.NAME in (N'access', N'view', N'list', N'edit', N'delete', N'import', N'export', N'admin', N'archive')
	     and MODULES.IS_ADMIN = 0
	     and ACL_ROLES_ACTIONS.ID is null
	 ) begin -- then
	exec dbo.spACL_ROLES_InsertOnly '3013244F-BFA9-4DDB-AF0D-67286C5342A0', 'Data Privacy Manager Role', 'The Data Privacy Manager Role provides an admin-delegate access to the Data Privacy admin module.';
	
	-- Access (Enabled = 89, Disabled = -98)
	-- View (All = 90, Owner = 75, None -99)
	-- delete from ACL_ROLES_ACTIONS where ROLE_ID = '3013244F-BFA9-4DDB-AF0D-67286C5342A0';
	insert into ACL_ROLES_ACTIONS
		( ID
		, ROLE_ID
		, ACTION_ID
		, ACCESS_OVERRIDE
		)
	select newid()
	     , '3013244F-BFA9-4DDB-AF0D-67286C5342A0'
	     , ACL_ACTIONS.ID
	     , (case ACL_ACTIONS.NAME
	        when N'access'  then (case when MODULES.MODULE_NAME in (N'DataPrivacy', N'Accounts', N'Contacts', N'Leads', N'Prospects') then 89 else -98 end)
	        when N'view'    then (case when MODULES.MODULE_NAME in (N'DataPrivacy', N'Accounts', N'Contacts', N'Leads', N'Prospects') then 89 else -99 end)
	        when N'list'    then (case when MODULES.MODULE_NAME in (N'DataPrivacy', N'Accounts', N'Contacts', N'Leads', N'Prospects') then 89 else -99 end)
	        when N'edit'    then (case when MODULES.MODULE_NAME in (N'DataPrivacy', N'Accounts', N'Contacts', N'Leads', N'Prospects') then 89 else -99 end)
	        when N'delete'  then (case when MODULES.MODULE_NAME in (N'DataPrivacy', N'Accounts', N'Contacts', N'Leads', N'Prospects') then 89 else -99 end)
	        when N'import'  then (case when MODULES.MODULE_NAME in (N'DataPrivacy', N'Accounts', N'Contacts', N'Leads', N'Prospects') then 89 else -99 end)
	        when N'export'  then (case when MODULES.MODULE_NAME in (N'DataPrivacy', N'Accounts', N'Contacts', N'Leads', N'Prospects') then 89 else -99 end)
	        when N'admin'   then (case when MODULES.MODULE_NAME in (N'DataPrivacy', N'Accounts', N'Contacts', N'Leads', N'Prospects') then 89 else -99 end)
	        when N'archive' then (case when MODULES.MODULE_NAME in (N'DataPrivacy', N'Accounts', N'Contacts', N'Leads', N'Prospects') then 89 else -99 end)
	        end)
	  from            MODULES
	       inner join ACL_ACTIONS
	               on ACL_ACTIONS.CATEGORY = MODULE_NAME
	              and ACL_ACTIONS.DELETED  = 0
	  left outer join ACL_ROLES_ACTIONS
	               on ACL_ROLES_ACTIONS.ACTION_ID = ACL_ACTIONS.ID
	              and ACL_ROLES_ACTIONS.ROLE_ID   = '3013244F-BFA9-4DDB-AF0D-67286C5342A0'
	              and ACL_ROLES_ACTIONS.DELETED   = 0
	 where MODULES.DELETED  = 0
	   and ACL_ACTIONS.NAME in (N'access', N'view', N'list', N'edit', N'delete', N'import', N'export', N'admin', N'archive')
	   and MODULES.IS_ADMIN = 0
	   and ACL_ROLES_ACTIONS.ID is null
	 order by MODULES.MODULE_NAME, ACL_ACTIONS.NAME;
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

call dbo.spACL_ROLES_DataPrivacyManager()
/

call dbo.spSqlDropProcedure('spACL_ROLES_DataPrivacyManager')
/

-- #endif IBM_DB2 */


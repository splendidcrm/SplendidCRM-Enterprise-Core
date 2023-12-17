

print 'DYNAMIC_BUTTONS ListView Cloud Services';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.ListView'
--GO

set nocount on;
GO


if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.ListView.GoogleApps' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contacts.ListView.GoogleApps', 0, 'Contacts', 'edit', null, null, null, null, null, 'Google.LBL_AUTHORIZE_BUTTON_LABEL', 'Google.LBL_AUTHORIZE_BUTTON_LABEL', null, null, null, 'return GoogleAppsAuthorize();';
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Meetings.ListView.GoogleApps' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Meetings.ListView.GoogleApps', 0, 'Meetings', 'edit', null, null, null, null, null, 'Google.LBL_AUTHORIZE_BUTTON_LABEL', 'Google.LBL_AUTHORIZE_BUTTON_LABEL', null, null, null, 'return GoogleAppsAuthorize();';
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

call dbo.spDYNAMIC_BUTTONS_ListView_Cloud()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_ListView_Cloud')
/

-- #endif IBM_DB2 */




print 'DYNAMIC_BUTTONS DetailView ChatMessages';

set nocount on;
GO

-- 06/10/2015 Paul.  ButtonLinks should use relative path instead of ~ as the URL is not translated. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Accounts.Activities.History'    , -1, 'Accounts', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Accounts', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Bugs.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Bugs.Activities.History'    , -1, 'Bugs', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Bugs', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Cases.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Cases.Activities.History'    , -1, 'Cases', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Cases', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contacts.Activities.History'    , -1, 'Contacts', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Contacts', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Leads.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Leads.Activities.History'    , -1, 'Leads', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Leads', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Opporunities.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Opporunities.Activities.History'    , -1, 'Opporunities', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Opporunities', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Project.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Project.Activities.History'    , -1, 'Project', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Project', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProjectTask.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'ProjectTask.Activities.History'    , -1, 'ProjectTask', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=ProjectTask', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Prospects.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Prospects.Activities.History'    , -1, 'Prospects', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Prospects', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

-- 06/10/2015 Paul.  ButtonLinks should use relative path instead of .. as the URL is not translated. 
if exists(select * from DYNAMIC_BUTTONS where URL_FORMAT like '~/ChatMessages%' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .Activities.History:  ButtonLinks should use relative path instead of ~ as the URL is not translated. ';
	update DYNAMIC_BUTTONS
	   set URL_FORMAT        = replace(URL_FORMAT, '~', '..')
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where URL_FORMAT        like '~/ChatMessages%'
	   and DELETED           = 0;
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

call dbo.spDYNAMIC_BUTTONS_DetailView_ChatMessages()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailView_ChatMessages')
/

-- #endif IBM_DB2 */


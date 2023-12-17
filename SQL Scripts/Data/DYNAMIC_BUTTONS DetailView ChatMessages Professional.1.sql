

print 'DYNAMIC_BUTTONS DetailView ChatMessages Professional';

set nocount on;
GO

-- 06/10/2015 Paul.  ButtonLinks should use relative path instead of ~ as the URL is not translated. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Contracts.Activities.History'    , -1, 'Contracts', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Contracts', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Invoices.Activities.History'    , -1, 'Invoices', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Invoices', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Orders.Activities.History'    , -1, 'Orders', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Orders', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.Activities.History' and COMMAND_NAME = 'ChatMessages.Create' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink 'Quotes.Activities.History'    , -1, 'Quotes', 'edit', 'ChatMessages', 'edit', 'ChatMessages.Create', '../ChatMessages/default.aspx?PARENT_ID={0}&PARENT_TYPE=Quotes', 'ID', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', 'ChatMessages.LNK_NEW_CHAT_MESSAGE', null, null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_DetailView_ChatMessages_Pro()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_DetailView_ChatMessages_Pro')
/

-- #endif IBM_DB2 */




print 'DYNAMIC_BUTTONS MassUpdate MailMerge';
GO

set nocount on;
GO

-- 05/14/2011 Paul.  Add MailMerge button. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.MassUpdate' and COMMAND_NAME = 'MailMerge' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.MassUpdate'      , -1, 'Accounts'      , 'view'  , null, null, 'MailMerge' , null, '.LBL_MAIL_MERGE'     , '.LBL_MAIL_MERGE'     , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.MassUpdate' and COMMAND_NAME = 'MailMerge' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.MassUpdate'      , -1, 'Contacts'      , 'view'  , null, null, 'MailMerge' , null, '.LBL_MAIL_MERGE'     , '.LBL_MAIL_MERGE'     , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Leads.MassUpdate' and COMMAND_NAME = 'MailMerge' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Leads.MassUpdate'         , -1, 'Leads'         , 'view'  , null, null, 'MailMerge' , null, '.LBL_MAIL_MERGE'     , '.LBL_MAIL_MERGE'     , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Prospects.MassUpdate' and COMMAND_NAME = 'MailMerge' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Prospects.MassUpdate'     , -1, 'Prospects'     , 'view'  , null, null, 'MailMerge' , null, '.LBL_MAIL_MERGE'     , '.LBL_MAIL_MERGE'     , null, 'if ( !ValidateOne() ) return false;', null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProspectLists.DetailView' and COMMAND_NAME = 'MailMerge' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ProspectLists.DetailView MailMerge';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProspectLists.DetailView' , -1, 'ProspectLists' , 'view'  , null, null, 'MailMerge' , null, '.LBL_MAIL_MERGE'     , '.LBL_MAIL_MERGE'     , null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_MailMerge()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_MailMerge')
/

-- #endif IBM_DB2 */


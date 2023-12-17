

print 'DYNAMIC_BUTTONS Gmail';
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.Gmail'
--GO

set nocount on;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Emails.ArchiveView.Gmail';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Emails.ArchiveView.Gmail' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Emails.ArchiveView.Gmail';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Emails.ArchiveView.Gmail', 0, 'Emails', 'edit', null, null, 'Save'  , null, 'Emails.LNK_NEW_EMAIL'      , 'Emails.LNK_NEW_EMAIL'      , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Emails.ArchiveView.Gmail', 1, 'Emails', 'view', null, null, 'Source', null, 'Emails.LBL_LIST_RAW_SOURCE', 'Emails.LBL_LIST_RAW_SOURCE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    'Emails.ArchiveView.Gmail', 2, null, 0;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = '.DetailView.Gmail' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .DetailView.Gmail';
	exec dbo.spDYNAMIC_BUTTONS_InsEdit      '.DetailView.Gmail'                     , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDuplicate '.DetailView.Gmail'                     , 1, null;
	exec dbo.spDYNAMIC_BUTTONS_InsDelete    '.DetailView.Gmail'                     , 2, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel    '.DetailView.Gmail'                     , 3, null, 0;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Accounts.DetailView.Gmail'        , 'Accounts'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Bugs.DetailView.Gmail'            , 'Bugs'         ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Cases.DetailView.Gmail'           , 'Cases'        ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Contacts.DetailView.Gmail'        , 'Contacts'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Leads.DetailView.Gmail'           , 'Leads'        ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Opportunities.DetailView.Gmail'   , 'Opportunities';
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Quotes.DetailView.Gmail'          , 'Quotes'       ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Orders.DetailView.Gmail'          , 'Orders'       ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Invoices.DetailView.Gmail'        , 'Invoices'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.DetailView.Gmail', 'Contracts.DetailView.Gmail'       , 'Contracts'    ;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = '.EditView.Gmail' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS .EditView.Gmail';
	exec dbo.spDYNAMIC_BUTTONS_InsSave   '.EditView.Gmail'                       , 0, null;
	exec dbo.spDYNAMIC_BUTTONS_InsCancel '.EditView.Gmail'                       , 1, null, 0;
end -- if;
GO

exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Accounts.EditView.Gmail'        , 'Accounts'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Bugs.EditView.Gmail'            , 'Bugs'         ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Cases.EditView.Gmail'           , 'Cases'        ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Contacts.EditView.Gmail'        , 'Contacts'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Leads.EditView.Gmail'           , 'Leads'        ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Opportunities.EditView.Gmail'   , 'Opportunities';
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Quotes.EditView.Gmail'          , 'Quotes'       ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Orders.EditView.Gmail'          , 'Orders'       ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Invoices.EditView.Gmail'        , 'Invoices'     ;
exec dbo.spDYNAMIC_BUTTONS_CopyDefault '.EditView.Gmail', 'Contracts.EditView.Gmail'       , 'Contracts'    ;
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

call dbo.spDYNAMIC_BUTTONS_Gmail()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_Gmail')
/

-- #endif IBM_DB2 */


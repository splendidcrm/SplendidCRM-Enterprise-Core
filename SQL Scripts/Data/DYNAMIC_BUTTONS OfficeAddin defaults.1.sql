

print N'DYNAMIC_BUTTONS OfficeAddin defaults';

set nocount on;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like '%.OfficeAddin.AppRead';

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Accounts.OfficeAddin' and DELETED = 0) begin -- then
	delete from DYNAMIC_BUTTONS where VIEW_NAME like 'Accounts.OfficeAddin'     ;
	delete from DYNAMIC_BUTTONS where VIEW_NAME like 'Bugs.OfficeAddin'         ;
	delete from DYNAMIC_BUTTONS where VIEW_NAME like 'Cases.OfficeAddin'        ;
	delete from DYNAMIC_BUTTONS where VIEW_NAME like 'Contacts.OfficeAddin'     ;
	delete from DYNAMIC_BUTTONS where VIEW_NAME like 'Leads.OfficeAddin'        ;
	delete from DYNAMIC_BUTTONS where VIEW_NAME like 'Opportunities.OfficeAddin';
end -- if;

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Accounts.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Accounts.OfficeAddin.AppRead';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Accounts.OfficeAddin.AppRead'     , 0, N'Accounts'     , N'edit', N'Accounts'     , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Accounts.OfficeAddin.AppRead'     , 1, N'Accounts'     , N'view', N'Accounts'     , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Accounts.OfficeAddin.AppRead'     , 2, N'Accounts'     , N'view', N'Accounts'     , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Accounts.OfficeAddin.AppRead'     , 3, N'Accounts'     , N'view', N'Emails'       , N'edit', N'ArchiveEmail'        , N'ID', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL' , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Accounts.OfficeAddin.AppRead'     , 4, N'Accounts'     , N'view', N'Cases'        , N'edit', N'Cases.Create'        , N'ID,NAME', N'Home.LNK_NEW_CASE'              , N'Home.LNK_NEW_CASE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Accounts.OfficeAddin.AppRead'     , 5, N'Accounts'     , N'view', N'Opportunities', N'edit', N'Opportunities.Create', N'ID,NAME', N'Home.LNK_NEW_OPPORTUNITY'       , N'Home.LNK_NEW_OPPORTUNITY'        , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Cases.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Cases.OfficeAddin.AppRead';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Cases.OfficeAddin.AppRead'        , 0, N'Cases'        , N'edit', N'Cases'        , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Cases.OfficeAddin.AppRead'        , 1, N'Cases'        , N'view', N'Cases'        , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Cases.OfficeAddin.AppRead'        , 2, N'Cases'        , N'view', N'Cases'        , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Cases.OfficeAddin.AppRead'        , 3, N'Cases'        , N'view', N'Emails'       , N'edit', N'ArchiveEmail'        , N'ID', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL' , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Contacts.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Contacts.OfficeAddin.AppRead';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppRead'     , 0, N'Contacts'     , N'edit', N'Contacts'     , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppRead'     , 1, N'Contacts'     , N'view', N'Contacts'     , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppRead'     , 2, N'Contacts'     , N'view', N'Contacts'     , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppRead'     , 3, N'Contacts'     , N'view', N'Emails'       , N'edit', N'ArchiveEmail'        , N'ID', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL' , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppRead'     , 4, N'Contacts'     , N'view', N'Cases'        , N'edit', N'Cases.Create'        , N'ID,NAME,ACCOUNT_ID,ACCOUNT_NAME', N'Home.LNK_NEW_CASE'              , N'Home.LNK_NEW_CASE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppRead'     , 5, N'Contacts'     , N'view', N'Opportunities', N'edit', N'Opportunities.Create', N'ID,NAME', N'Home.LNK_NEW_OPPORTUNITY'       , N'Home.LNK_NEW_OPPORTUNITY'        , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Leads.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Leads.OfficeAddin.AppRead';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppRead'        , 0, N'Leads'        , N'edit', N'Leads'        , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppRead'        , 1, N'Leads'        , N'view', N'Leads'        , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppRead'        , 2, N'Leads'        , N'view', N'Leads'        , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppRead'        , 3, N'Leads'        , N'view', N'Emails'       , N'edit', N'ArchiveEmail'        , N'ID', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL' , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppRead'        , 4, N'Leads'        , N'view', N'Cases'        , N'edit', N'Cases.Create'        , N'ID,NAME,ACCOUNT_ID,ACCOUNT_NAME', N'Home.LNK_NEW_CASE'              , N'Home.LNK_NEW_CASE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppRead'        , 5, N'Leads'        , N'view', N'Opportunities', N'edit', N'Opportunities.Create', N'ID,NAME', N'Home.LNK_NEW_OPPORTUNITY'       , N'Home.LNK_NEW_OPPORTUNITY'        , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Opportunities.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Opportunities.OfficeAddin.AppRead';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Opportunities.OfficeAddin.AppRead', 0, N'Opportunities', N'edit', N'Opportunities', N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Opportunities.OfficeAddin.AppRead', 1, N'Opportunities', N'view', N'Opportunities', N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Opportunities.OfficeAddin.AppRead', 2, N'Opportunities', N'view', N'Opportunities', N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Opportunities.OfficeAddin.AppRead', 3, N'Opportunities', N'view', N'Emails'       , N'edit', N'ArchiveEmail'        , N'ID', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL' , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Quotes.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Quotes.OfficeAddin.AppRead';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Quotes.OfficeAddin.AppRead'       , 0, N'Quotes'       , N'edit', N'Quotes'       , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Quotes.OfficeAddin.AppRead'       , 1, N'Quotes'       , N'view', N'Quotes'       , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Quotes.OfficeAddin.AppRead'       , 2, N'Quotes'       , N'view', N'Quotes'       , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Quotes.OfficeAddin.AppRead'       , 3, N'Quotes'       , N'view', N'Emails'       , N'edit', N'ArchiveEmail'        , N'ID', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL' , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Orders.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Orders.OfficeAddin.AppRead';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Orders.OfficeAddin.AppRead'       , 0, N'Orders'       , N'edit', N'Orders'       , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Orders.OfficeAddin.AppRead'       , 1, N'Orders'       , N'view', N'Orders'       , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Orders.OfficeAddin.AppRead'       , 2, N'Orders'       , N'view', N'Orders'       , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Orders.OfficeAddin.AppRead'       , 3, N'Orders'       , N'view', N'Emails'       , N'edit', N'ArchiveEmail'        , N'ID', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL' , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Invoices.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Invoices.OfficeAddin.AppRead';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Invoices.OfficeAddin.AppRead'     , 0, N'Invoices'     , N'edit', N'Invoices'     , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Invoices.OfficeAddin.AppRead'     , 1, N'Invoices'     , N'view', N'Invoices'     , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Invoices.OfficeAddin.AppRead'     , 2, N'Invoices'     , N'view', N'Invoices'     , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Invoices.OfficeAddin.AppRead'     , 3, N'Invoices'     , N'view', N'Emails'       , N'edit', N'ArchiveEmail'        , N'ID', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL', N'.LBL_ARCHIVE_EMAIL_BUTTON_LABEL' , null, null, null;
end -- if;
GO

if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Home.OfficeAddin.AppRead' and COMMAND_NAME = 'ViewSplendidCRM' and DELETED = 0) begin -- then
	delete from DYNAMIC_BUTTONS where VIEW_NAME = N'Home.OfficeAddin.AppRead';
end -- if;

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = N'Home.OfficeAddin.AppRead';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Home.OfficeAddin.AppRead' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Home.OfficeAddin.AppRead';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Home.OfficeAddin.AppRead'         , 0, null            , N'edit', N'Accounts'     , N'edit', N'Accounts.Create'     , null , N'Home.LNK_NEW_ACCOUNT'           , N'Home.LNK_NEW_ACCOUNT'            , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Home.OfficeAddin.AppRead'         , 1, null            , N'edit', N'Contacts'     , N'edit', N'Contacts.Create'     , null , N'Home.LNK_NEW_CONTACT'           , N'Home.LNK_NEW_CONTACT'            , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Home.OfficeAddin.AppRead'         , 2, null            , N'edit', N'Leads'        , N'edit', N'Leads.Create'        , null , N'Home.LNK_NEW_LEAD'              , N'Home.LNK_NEW_LEAD'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Home.OfficeAddin.AppRead'         , 3, null            , N'edit', N'Cases'        , N'edit', N'Cases.Create'        , null , N'Home.LNK_NEW_CASE'              , N'Home.LNK_NEW_CASE'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Home.OfficeAddin.AppRead'         , 4, null            , N'edit', N'Opportunities', N'edit', N'Opportunities.Create', null , N'Home.LNK_NEW_OPPORTUNITY'       , N'Home.LNK_NEW_OPPORTUNITY'        , null, null, null;
--	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Home.OfficeAddin.AppRead'         , 5, null            , N'view', null            , N'list', N'Search'              , null , N'.LBL_SEARCH_BUTTON_LABEL'       , N'.LBL_SEARCH_BUTTON_TITLE'        , null, null, null;
end -- if;
GO


if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Accounts.OfficeAddin.AppCompose' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Accounts.OfficeAddin.AppCompose';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Accounts.OfficeAddin.AppCompose'     , 0, N'Accounts'     , N'edit', N'Accounts'     , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Accounts.OfficeAddin.AppCompose'     , 1, N'Accounts'     , N'view', N'Accounts'     , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Accounts.OfficeAddin.AppCompose'     , 2, N'Accounts'     , N'view', N'Accounts'     , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Cases.OfficeAddin.AppCompose' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Cases.OfficeAddin.AppCompose';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Cases.OfficeAddin.AppCompose'        , 0, N'Cases'        , N'edit', N'Cases'        , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Cases.OfficeAddin.AppCompose'        , 1, N'Cases'        , N'view', N'Cases'        , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Cases.OfficeAddin.AppCompose'        , 2, N'Cases'        , N'view', N'Cases'        , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Contacts.OfficeAddin.AppCompose' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Contacts.OfficeAddin.AppCompose';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppCompose'     , 0, N'Contacts'     , N'edit', N'Contacts'     , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppCompose'     , 1, N'Contacts'     , N'view', N'Contacts'     , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppCompose'     , 2, N'Contacts'     , N'view', N'Contacts'     , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Contacts.OfficeAddin.AppCompose'     , 3, N'Contacts'     , N'view', N'Contacts'     , N'view', N'AddRecipient'        , N'ID,NAME,EMAIL1', N'.LBL_ADD_RECIPIENT' , N'.LBL_ADD_RECIPIENT'              , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Leads.OfficeAddin.AppCompose' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Leads.OfficeAddin.AppCompose';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppCompose'        , 0, N'Leads'        , N'edit', N'Leads'        , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppCompose'        , 1, N'Leads'        , N'view', N'Leads'        , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppCompose'        , 2, N'Leads'        , N'view', N'Leads'        , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Leads.OfficeAddin.AppCompose'        , 3, N'Leads'        , N'view', N'Leads'        , N'view', N'AddRecipient'        , N'ID,NAME,EMAIL1', N'.LBL_ADD_RECIPIENT' , N'.LBL_ADD_RECIPIENT'              , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Opportunities.OfficeAddin.AppCompose' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Opportunities.OfficeAddin.AppCompose';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Opportunities.OfficeAddin.AppCompose', 0, N'Opportunities', N'edit', N'Opportunities', N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Opportunities.OfficeAddin.AppCompose', 1, N'Opportunities', N'view', N'Opportunities', N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Opportunities.OfficeAddin.AppCompose', 2, N'Opportunities', N'view', N'Opportunities', N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Quotes.OfficeAddin.AppCompose' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Quotes.OfficeAddin.AppCompose';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Quotes.OfficeAddin.AppCompose'       , 0, N'Quotes'       , N'edit', N'Quotes'       , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Quotes.OfficeAddin.AppCompose'       , 1, N'Quotes'       , N'view', N'Quotes'       , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Quotes.OfficeAddin.AppCompose'       , 2, N'Quotes'       , N'view', N'Quotes'       , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Quotes.OfficeAddin.AppCompose'       , 3, N'Quotes'       , N'view', N'Quotes'       , N'view', N'AddRecipient'        , N'ID,NAME,BILLING_CONTACT_NAME,BILLING_CONTACT_EMAIL1', N'.LBL_ADD_RECIPIENT' , N'.LBL_ADD_RECIPIENT', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Quotes.OfficeAddin.AppCompose'       , 4, N'Quotes'       , N'view', N'Quotes'       , N'view', N'AttachPDF'           , N'ID,NAME'                                            , N'.LBL_ATTACH_PDF'    , N'.LBL_ATTACH_PDF'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Orders.OfficeAddin.AppCompose' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Orders.OfficeAddin.AppCompose';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Orders.OfficeAddin.AppCompose'       , 0, N'Orders'       , N'edit', N'Orders'       , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Orders.OfficeAddin.AppCompose'       , 1, N'Orders'       , N'view', N'Orders'       , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Orders.OfficeAddin.AppCompose'       , 2, N'Orders'       , N'view', N'Orders'       , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Orders.OfficeAddin.AppCompose'       , 3, N'Orders'       , N'view', N'Orders'       , N'view', N'AddRecipient'        , N'ID,NAME,BILLING_CONTACT_NAME,BILLING_CONTACT_EMAIL1', N'.LBL_ADD_RECIPIENT' , N'.LBL_ADD_RECIPIENT', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Orders.OfficeAddin.AppCompose'       , 4, N'Orders'       , N'view', N'Orders'       , N'view', N'AttachPDF'           , N'ID,NAME'                                            , N'.LBL_ATTACH_PDF'    , N'.LBL_ATTACH_PDF'   , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = N'Invoices.OfficeAddin.AppCompose' and DELETED = 0) begin -- then
	print N'DYNAMIC_BUTTONS Invoices.OfficeAddin.AppCompose';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Invoices.OfficeAddin.AppCompose'     , 0, N'Invoices'     , N'edit', N'Invoices'     , N'edit', N'Edit'                , N'ID', N'.LBL_EDIT_BUTTON_LABEL'         , N'.LBL_EDIT_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Invoices.OfficeAddin.AppCompose'     , 1, N'Invoices'     , N'view', N'Invoices'     , N'view', N'View'                , N'ID', N'.LBL_VIEW_BUTTON_LABEL'         , N'.LBL_VIEW_BUTTON_LABEL'          , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Invoices.OfficeAddin.AppCompose'     , 2, N'Invoices'     , N'view', N'Invoices'     , N'view', N'ViewSplendidCRM'     , N'ID', N'.LBL_VIEW_IN_SPLENDIDCRM'       , N'.LBL_VIEW_IN_SPLENDIDCRM'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Invoices.OfficeAddin.AppCompose'     , 3, N'Invoices'     , N'view', N'Invoices'     , N'view', N'AddRecipient'        , N'ID,NAME,BILLING_CONTACT_NAME,BILLING_CONTACT_EMAIL1', N'.LBL_ADD_RECIPIENT' , N'.LBL_ADD_RECIPIENT', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    N'Invoices.OfficeAddin.AppCompose'     , 4, N'Invoices'     , N'view', N'Invoices'     , N'view', N'AttachPDF'           , N'ID,NAME'                                            , N'.LBL_ATTACH_PDF'    , N'.LBL_ATTACH_PDF'   , null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_OfficeAddin()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_OfficeAddin')
/

-- #endif IBM_DB2 */


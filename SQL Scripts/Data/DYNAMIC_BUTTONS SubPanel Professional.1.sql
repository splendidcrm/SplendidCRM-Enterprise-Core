

print 'DYNAMIC_BUTTONS SubPanel Professional';

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 06/21/2010 Paul.  Remove the KEY data. 
-- 06/21/2010 Paul.  Add Search buttons. 
-- 10/14/2010 Paul.  Change Track Email to Archive Email. 

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.Invoices' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Accounts SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.CreditCards'            , 0, 'Accounts'        , 'edit', 'CreditCards'     , 'edit', 'CreditCards.Create'      , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Invoices'               , 0, 'Accounts'        , 'edit', 'Invoices'        , 'edit', 'Invoices.Create'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Invoices'               , 1, 'Accounts'        , 'view', 'Invoices'        , 'list', 'Invoices.Search'         , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Orders'                 , 0, 'Accounts'        , 'edit', 'Orders'          , 'edit', 'Orders.Create'           , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Orders'                 , 1, 'Accounts'        , 'view', 'Orders'          , 'list', 'Orders.Search'           , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Payments'               , 0, 'Accounts'        , 'edit', 'Payments'        , 'edit', 'Payments.Create'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Quotes'                 , 0, 'Accounts'        , 'edit', 'Quotes'          , 'edit', 'Quotes.Create'           , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Quotes'                 , 1, 'Accounts'        , 'view', 'Quotes'          , 'list', 'Quotes.Search'           , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Threads'                , 0, 'Accounts'        , 'edit', 'Threads'         , 'edit', 'Threads.Create'          , null, 'Threads.LBL_NEW_BUTTON_LABEL'                , 'Threads.LBL_NEW_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Accounts.Threads'                , 1, 'Accounts'        , 'edit', 'Threads'         , 'list', 'ThreadPopup();'          , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 06/03/2010 Paul.  Allow a contract to be created from an Account. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Accounts.Contracts' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Contracts'              , 0, 'Accounts'        , 'edit', 'Contracts'       , 'edit', 'Contracts.Create'        , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Accounts.Contracts'              , 1, 'Accounts'        , 'view', 'Contracts'       , 'list', 'Contracts.Search'        , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Bugs.Threads' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Bugs SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Bugs.Threads'                    , 0, 'Bugs'            , 'edit', 'Threads'         , 'edit', 'Threads.Create'          , null, 'Threads.LBL_NEW_BUTTON_LABEL'                , 'Threads.LBL_NEW_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Bugs.Threads'                    , 1, 'Bugs'            , 'edit', 'Threads'         , 'list', 'ThreadPopup();'          , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Cases.Threads' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Cases SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Cases.Threads'                   , 0, 'Cases'           , 'edit', 'Threads'         , 'edit', 'Threads.Create'          , null, 'Threads.LBL_NEW_BUTTON_LABEL'                , 'Threads.LBL_NEW_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Cases.Threads'                   , 1, 'Cases'           , 'edit', 'Threads'         , 'list', 'ThreadPopup();'          , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 02/13/2009 Paul.  Add relationships to activities. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.Activities.Open' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Activities.Open'       , 0, 'Contracts'        , 'edit', 'Tasks'          , 'edit', 'Tasks.Create'            , null, 'Activities.LBL_NEW_TASK_BUTTON_LABEL'        , 'Activities.LBL_NEW_TASK_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Activities.Open'       , 1, 'Contracts'        , 'edit', 'Meetings'       , 'edit', 'Meetings.Create'         , null, 'Activities.LBL_SCHEDULE_MEETING_BUTTON_LABEL', 'Activities.LBL_SCHEDULE_MEETING_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Activities.Open'       , 2, 'Contracts'        , 'edit', 'Calls'          , 'edit', 'Calls.Create'            , null, 'Activities.LBL_SCHEDULE_CALL_BUTTON_LABEL'   , 'Activities.LBL_SCHEDULE_CALL_BUTTON_TITLE'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Activities.Open'       , 3, 'Contracts'        , 'edit', 'Emails'         , 'edit', 'Emails.Compose'          , null, '.LBL_COMPOSE_EMAIL_BUTTON_LABEL'             , '.LBL_COMPOSE_EMAIL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Activities.Open'       , 4, 'Contracts'        , 'view', null             , null  , 'Activities.SearchOpen'   , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Contracts.Activities.Open'       , 5, 'Contracts'        , 'view', 'Activities'     , 'list', 'ActivitiesRelatedPopup();', null, 'Activities.LBL_SEARCH_RELATED'               , 'Activities.LBL_SEARCH_RELATED'               , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Activities.History'    , 0, 'Contracts'        , 'edit', 'Notes'          , 'edit', 'Notes.Create'            , null, 'Activities.LBL_NEW_NOTE_BUTTON_LABEL'        , 'Activities.LBL_NEW_NOTE_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Activities.History'    , 1, 'Contracts'        , 'edit', 'Emails'         , 'edit', 'Emails.Archive'          , null, 'Activities.LBL_ARCHIVE_EMAIL_BUTTON_LABEL'   , 'Activities.LBL_ARCHIVE_EMAIL_BUTTON_TITLE'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Activities.History'    , 2, 'Contracts'        , 'view', 'Emails'         , 'list', 'Activities.SearchHistory', null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.Quotes' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contacts SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.CreditCards'            , 0, 'Contacts'        , 'edit', 'CreditCards'     , 'edit', 'CreditCards.Create'      , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Products'               , 0, 'Contacts'        , 'edit', 'Products'        , 'edit', 'Products.Create'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Products'               , 1, 'Contacts'        , 'view', 'Products'        , 'list', 'Products.Search'         , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Quotes'                 , 0, 'Contacts'        , 'edit', 'Quotes'          , 'edit', 'Quotes.Create'           , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Quotes'                 , 1, 'Contacts'        , 'view', 'Quotes'          , 'list', 'Quotes.Search'           , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Threads'                , 0, 'Contacts'        , 'edit', 'Threads'         , 'edit', 'Threads.Create'          , null, 'Threads.LBL_NEW_BUTTON_LABEL'                , 'Threads.LBL_NEW_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Contacts.Threads'                , 1, 'Contacts'        , 'edit', 'Threads'         , 'list', 'ThreadPopup();'          , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 10/07/2010 Paul.  Add Contact field. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.CreditCards' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.CreditCards'            , 0, 'Contacts'        , 'edit', 'CreditCards'     , 'edit', 'CreditCards.Create'      , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
end -- if;
GO


-- 08/18/2010 Paul.  Add Contacts.Invoices relationship. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.Invoices' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Invoices'               , 0, 'Contacts'        , 'edit', 'Invoices'        , 'edit', 'Invoices.Create'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Invoices'               , 1, 'Contacts'        , 'view', 'Invoices'        , 'list', 'Invoices.Search'         , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 01/16/2013 Paul.  Add Contacts.Orders relationship. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.Orders' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Orders'                 , 0, 'Contacts'        , 'edit', 'Orders'          , 'edit', 'Orders.Create'           , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Orders'                 , 1, 'Contacts'        , 'view', 'Orders'          , 'list', 'Orders.Search'           , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 03/14/2016 Paul.  Allow a contract to be created from a Contact. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contacts.Contracts' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Contracts'              , 0, 'Contacts'        , 'edit', 'Contracts'       , 'edit', 'Contracts.Create'        , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contacts.Contracts'              , 1, 'Contacts'        , 'view', 'Contracts'       , 'list', 'Contracts.Search'        , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Contracts.Contacts' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Contracts SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Contacts'              , 0, 'Contracts'       , 'edit', 'Contacts'        , 'edit', 'Contacts.Create'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Contracts.Contacts'              , 1, 'Contracts'       , 'edit', 'Contacts'        , 'list', 'ContactPopup();'         , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Contracts.Documents'             , 0, 'Contracts'       , 'edit', 'Documents'       , 'edit', 'Documents.Create'        , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Contracts.Documents'             , 1, 'Contracts'       , 'edit', 'Documents'       , 'list', 'DocumentPopup();'        , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Contracts.Products'              , 0, 'Contracts'       , 'edit', 'Products'        , 'list', 'ProductPopup();'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Contracts.Quotes'                , 0, 'Contracts'       , 'edit', 'Quotes'          , 'list', 'QuotePopup();'           , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Emails.Quotes' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Emails SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Emails.Quotes'                   , 0, 'Emails'          , 'edit', 'Quotes'          , 'edit', 'Quotes.Create'           , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Emails.Quotes'                   , 1, 'Emails'          , 'edit', 'Quotes'          , 'list', 'QuotePopup();'           , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Emails.Quotes'                   , 2, 'Emails'          , 'view', 'Quotes'          , 'list', 'Quotes.Search'           , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Forums.Posts' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Forums SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Forums.Posts'                    , 0, 'Forums'          , 'edit', 'Posts'           , 'edit', 'Posts.Create'            , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Forums.Threads'                  , 0, 'Forums'          , 'edit', 'Threads'         , 'edit', 'Threads.Create'          , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.Activities.Open' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Invoices SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Activities.Open'        , 0, 'Invoices'        , 'edit', 'Tasks'           , 'edit', 'Tasks.Create'            , null, 'Activities.LBL_NEW_TASK_BUTTON_LABEL'        , 'Activities.LBL_NEW_TASK_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Activities.Open'        , 1, 'Invoices'        , 'edit', 'Meetings'        , 'edit', 'Meetings.Create'         , null, 'Activities.LBL_SCHEDULE_MEETING_BUTTON_LABEL', 'Activities.LBL_SCHEDULE_MEETING_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Activities.Open'        , 2, 'Invoices'        , 'edit', 'Calls'           , 'edit', 'Calls.Create'            , null, 'Activities.LBL_SCHEDULE_CALL_BUTTON_LABEL'   , 'Activities.LBL_SCHEDULE_CALL_BUTTON_TITLE'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Activities.Open'        , 3, 'Invoices'        , 'edit', 'Emails'          , 'edit', 'Emails.Compose'          , null, '.LBL_COMPOSE_EMAIL_BUTTON_LABEL'             , '.LBL_COMPOSE_EMAIL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Activities.Open'        , 4, 'Invoices'        , 'view', null              , null  , 'Activities.SearchOpen'   , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Invoices.Activities.Open'        , 5, 'Invoices'        , 'view', 'Activities'      , 'list', 'ActivitiesRelatedPopup();', null, 'Activities.LBL_SEARCH_RELATED'               , 'Activities.LBL_SEARCH_RELATED'               , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Activities.History'     , 0, 'Invoices'        , 'edit', 'Notes'           , 'edit', 'Notes.Create'            , null, 'Activities.LBL_NEW_NOTE_BUTTON_LABEL'        , 'Activities.LBL_NEW_NOTE_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Activities.History'     , 1, 'Invoices'        , 'edit', 'Emails'          , 'edit', 'Emails.Archive'          , null, 'Activities.LBL_ARCHIVE_EMAIL_BUTTON_LABEL'   , 'Activities.LBL_ARCHIVE_EMAIL_BUTTON_TITLE'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Activities.History'     , 2, 'Invoices'        , 'view', 'Emails'          , 'list', 'Activities.SearchHistory', null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Payments'               , 0, 'Invoices'        , 'edit', 'Payments'        , 'edit', 'Payments.Create'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Leads.Threads' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Leads SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Leads.Threads'                   , 0, 'Leads'           , 'edit', 'Threads'         , 'edit', 'Threads.Create'          , null, 'Threads.LBL_NEW_BUTTON_LABEL'                , 'Threads.LBL_NEW_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Leads.Threads'                   , 1, 'Leads'           , 'edit', 'Threads'         , 'list', 'ThreadPopup();'          , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Opportunities.Quotes' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Opportunities SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Opportunities.Quotes'            , 0, 'Opportunities'   , 'edit', 'Quotes'          , 'edit', 'Quotes.Create'           , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Opportunities.Quotes'            , 1, 'Opportunities'   , 'edit', 'Quotes'          , 'list', 'QuotePopup();'           , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Opportunities.Quotes'            , 2, 'Opportunities'   , 'view', 'Quotes'          , 'list', 'Quotes.Search'           , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Opportunities.Threads'           , 0, 'Opportunities'   , 'edit', 'Threads'         , 'edit', 'Threads.Create'          , null, 'Threads.LBL_NEW_BUTTON_LABEL'                , 'Threads.LBL_NEW_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Opportunities.Threads'           , 1, 'Opportunities'   , 'edit', 'Threads'         , 'list', 'ThreadPopup();'          , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 06/03/2010 Paul.  Allow a contract to be created from an Opportunities. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Opportunities.Contracts' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Opportunities.Contracts'         , 0, 'Opportunities'   , 'edit', 'Contracts'       , 'edit', 'Contracts.Create'        , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Products.Notes' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Products SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Products.Notes'                  , 0, 'Products'        , 'edit', 'Notes'           , 'edit', 'Notes.Create'            , null, 'Threads.LBL_NEW_BUTTON_LABEL'                , 'Threads.LBL_NEW_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Products.Notes'                  , 1, 'Products'        , 'view', 'Notes'           , 'list', 'Notes.Search'            , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Products.RelatedProducts'        , 0, 'Products'        , 'edit', 'Products'        , 'list', 'ProductPopup();'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Project.Quotes' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Project SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Project.Quotes'                  , 0, 'Project'         , 'edit', 'Quotes'          , 'list', 'QuotePopup();'           , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Project.Quotes'                  , 1, 'Project'         , 'view', 'Quotes'          , 'list', 'Quotes.Search'           , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Project.Threads'                 , 0, 'Project'         , 'edit', 'Threads'         , 'edit', 'Threads.Create'          , null, 'Threads.LBL_NEW_BUTTON_LABEL'                , 'Threads.LBL_NEW_BUTTON_TITLE'                , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Project.Threads'                 , 1, 'Project'         , 'edit', 'Threads'         , 'list', 'ThreadPopup();'          , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME like 'Quotes.%';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.Invoices' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Quotes SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Activities.Open'          , 0, 'Quotes'          , 'edit', 'Tasks'           , 'edit', 'Tasks.Create'            , null, 'Activities.LBL_NEW_TASK_BUTTON_LABEL'        , 'Activities.LBL_NEW_TASK_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Activities.Open'          , 1, 'Quotes'          , 'edit', 'Meetings'        , 'edit', 'Meetings.Create'         , null, 'Activities.LBL_SCHEDULE_MEETING_BUTTON_LABEL', 'Activities.LBL_SCHEDULE_MEETING_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Activities.Open'          , 2, 'Quotes'          , 'edit', 'Calls'           , 'edit', 'Calls.Create'            , null, 'Activities.LBL_SCHEDULE_CALL_BUTTON_LABEL'   , 'Activities.LBL_SCHEDULE_CALL_BUTTON_TITLE'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Activities.Open'          , 3, 'Quotes'          , 'edit', 'Emails'          , 'edit', 'Emails.Compose'          , null, '.LBL_COMPOSE_EMAIL_BUTTON_LABEL'             , '.LBL_COMPOSE_EMAIL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Activities.Open'          , 4, 'Quotes'          , 'view', null              , null  , 'Activities.SearchOpen'   , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Quotes.Activities.Open'          , 5, 'Quotes'          , 'view', 'Activities'      , 'list', 'ActivitiesRelatedPopup();', null, 'Activities.LBL_SEARCH_RELATED'               , 'Activities.LBL_SEARCH_RELATED'               , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Activities.History'       , 0, 'Quotes'          , 'edit', 'Notes'           , 'edit', 'Notes.Create'            , null, 'Activities.LBL_NEW_NOTE_BUTTON_LABEL'        , 'Activities.LBL_NEW_NOTE_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Activities.History'       , 1, 'Quotes'          , 'edit', 'Emails'          , 'edit', 'Emails.Archive'          , null, 'Activities.LBL_ARCHIVE_EMAIL_BUTTON_LABEL'   , 'Activities.LBL_ARCHIVE_EMAIL_BUTTON_TITLE'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Activities.History'       , 2, 'Quotes'          , 'view', 'Emails'          , 'list', 'Activities.SearchHistory', null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Contracts'                , 0, 'Quotes'          , 'edit', 'Contracts'       , 'edit', 'Contracts.Create'        , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Contracts'                , 1, 'Quotes'          , 'view', 'Contracts'       , 'list', 'Contracts.Search'        , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Invoices'                 , 0, 'Quotes'          , 'edit', 'Invoices'        , 'edit', 'Invoices.Create'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Invoices'                 , 1, 'Quotes'          , 'view', 'Invoices'        , 'list', 'Invoices.Search'         , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Orders'                   , 0, 'Quotes'          , 'edit', 'Orders'          , 'edit', 'Orders.Create'           , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Orders'                   , 1, 'Quotes'          , 'view', 'Orders'          , 'list', 'Orders.Search'           , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Project'                  , 0, 'Quotes'          , 'edit', 'Project'         , 'edit', 'Project.Create'          , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Project'                  , 1, 'Quotes'          , 'view', 'Project'         , 'list', 'Project.Search'          , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 06/03/2015 Paul.  Combine ListHeader and DynamicButtons. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.Documents' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Documents'                , 0, 'Quotes'          , 'edit', 'Documents'       , 'edit', 'Documents.Create'        , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Quotes.Documents'                , 1, 'Quotes'          , 'edit', 'Documents'       , 'list', 'DocumentPopup();'        , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 02/05/2010 Paul.  Not sure why Orders buttons were missing. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME like 'Orders.Activities.%' or VIEW_NAME = 'Orders.Invoices';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Orders.Invoices' and COMMAND_NAME like '%.Search' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Orders SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Activities.Open'          , 0, 'Orders'          , 'edit', 'Tasks'           , 'edit', 'Tasks.Create'            , null, 'Activities.LBL_NEW_TASK_BUTTON_LABEL'        , 'Activities.LBL_NEW_TASK_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Activities.Open'          , 1, 'Orders'          , 'edit', 'Meetings'        , 'edit', 'Meetings.Create'         , null, 'Activities.LBL_SCHEDULE_MEETING_BUTTON_LABEL', 'Activities.LBL_SCHEDULE_MEETING_BUTTON_TITLE', null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Activities.Open'          , 2, 'Orders'          , 'edit', 'Calls'           , 'edit', 'Calls.Create'            , null, 'Activities.LBL_SCHEDULE_CALL_BUTTON_LABEL'   , 'Activities.LBL_SCHEDULE_CALL_BUTTON_TITLE'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Activities.Open'          , 3, 'Orders'          , 'edit', 'Emails'          , 'edit', 'Emails.Compose'          , null, '.LBL_COMPOSE_EMAIL_BUTTON_LABEL'             , '.LBL_COMPOSE_EMAIL_BUTTON_TITLE'             , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Activities.Open'          , 4, 'Orders'          , 'view', null              , null  , 'Activities.SearchOpen'   , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Orders.Activities.Open'          , 5, 'Orders'          , 'view', 'Activities'      , 'list', 'ActivitiesRelatedPopup();', null, 'Activities.LBL_SEARCH_RELATED'               , 'Activities.LBL_SEARCH_RELATED'               , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Activities.History'       , 0, 'Orders'          , 'edit', 'Notes'           , 'edit', 'Notes.Create'            , null, 'Activities.LBL_NEW_NOTE_BUTTON_LABEL'        , 'Activities.LBL_NEW_NOTE_BUTTON_TITLE'        , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Activities.History'       , 1, 'Orders'          , 'edit', 'Emails'          , 'edit', 'Emails.Archive'          , null, 'Activities.LBL_ARCHIVE_EMAIL_BUTTON_LABEL'   , 'Activities.LBL_ARCHIVE_EMAIL_BUTTON_TITLE'   , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Activities.History'       , 2, 'Orders'          , 'view', 'Emails'          , 'list', 'Activities.SearchHistory', null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Invoices'                 , 0, 'Orders'          , 'edit', 'Invoices'        , 'edit', 'Invoices.Create'         , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Invoices'                 , 1, 'Orders'          , 'view', 'Invoices'        , 'list', 'Invoices.Search'         , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- Administration
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.RelatedProducts' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ProductTemplates SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'ProductTemplates.RelatedProducts', 0, 'ProductTemplates', 'edit', 'ProductTemplate' , 'list', 'ProductTemplatePopup();' , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ProductTemplates.Notes' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'ProductTemplates.Notes'          , 0, 'ProductTemplates', 'edit', 'Notes'           , 'list', 'Notes.Create'            , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Teams.Users' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Teams.Users SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Teams.Users'                     , 1, 'Teams'           , 'edit', 'Users'           , 'edit', 'UserMultiSelect();'      , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 04/12/2016 Paul.  Add ZipCodes. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Teams.ZipCodes' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Teams.ZipCodes SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Teams.ZipCodes'                  , 1, 'Teams'           , 'edit', 'ZipCodes'        , 'edit', 'ZipCodesMultiSelect();'  , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 01/01/2017 Paul.  Add Regions.
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Teams.Regions' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Teams.Regions SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Teams.Regions'                   , 1, 'Teams'           , 'edit', 'Regions'         , 'edit', 'RegionsMultiSelect();'   , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Users.Teams' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Users.Teams SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Users.Teams'                     , 0, 'Users'           , 'edit', 'Teams'           , 'edit', 'TeamMultiSelect();'      , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ContractTypes.Documents' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS ContractTypes SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'ContractTypes.Documents'         , 0, 'ContractTypes'   , 'edit', 'Documents'       , 'edit', 'DocumentPopup();'        , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end else begin
	-- 09/01/2009 Paul.  Fix the Documents popup. 
	if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'ContractTypes.Documents' and ONCLICK_SCRIPT like 'UserMultiSelect%' and DELETED = 0) begin -- then
		print 'Fix ContractTypes.Documents.';
		update DYNAMIC_BUTTONS
		   set ONCLICK_SCRIPT   = 'DocumentPopup();return false;'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where VIEW_NAME        = 'ContractTypes.Documents'
		   and ONCLICK_SCRIPT   like 'UserMultiSelect%'
		   and DELETED          = 0;
	end -- if;
end -- if;
GO

-- 08/05/2010 Paul.  Add buttons for Quotes, Orders Invoices and Cases. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Quotes.Cases' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Cases'                    , 0, 'Quotes'          , 'edit', 'Cases'           , 'edit', 'Cases.Create'            , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Quotes.Cases'                    , 1, 'Quotes'          , 'edit', 'Cases'           , 'list', 'CasePopup();'            , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Quotes.Cases'                    , 2, 'Quotes'          , 'view', 'Cases'           , 'list', 'Cases.Search'            , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Cases'                    , 0, 'Orders'          , 'edit', 'Cases'           , 'edit', 'Cases.Create'            , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Orders.Cases'                    , 1, 'Orders'          , 'edit', 'Cases'           , 'list', 'CasePopup();'            , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Orders.Cases'                    , 2, 'Orders'          , 'view', 'Cases'           , 'list', 'Cases.Search'            , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;

	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Cases'                  , 0, 'Invoices'        , 'edit', 'Cases'           , 'edit', 'Cases.Create'            , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Invoices.Cases'                  , 1, 'Invoices'        , 'edit', 'Cases'           , 'list', 'CasePopup();'            , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Invoices.Cases'                  , 2, 'Invoices'        , 'view', 'Cases'           , 'list', 'Cases.Search'            , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 07/20/2010 Paul.  Regions. 
-- 09/16/2010 Paul.  Move Regions to Professional file. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Regions.Countries' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Regions SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Regions.Countries'                , 0, 'Regions'         , 'edit', null              , null  , 'CountriesPopup();'      , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 06/21/2011 Paul.  Add relationship between KBDocuments and Cases. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'KBDocuments.Cases' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'KBDocuments.Cases'               , 0, 'KBDocuments'     , 'edit', 'Cases'           , 'edit', 'Cases.Create'            , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'KBDocuments.Cases'               , 1, 'KBDocuments'     , 'edit', 'Cases'           , 'list', 'CasePopup();'            , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'KBDocuments.Cases'               , 2, 'KBDocuments'     , 'view', 'Cases'           , 'list', 'Cases.Search'            , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Cases.KBDocuments' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Cases.KBDocuments'               , 0, 'Cases'           , 'edit', 'KBDocuments'     , 'edit', 'KBDocuments.Create'      , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Cases.KBDocuments'               , 1, 'Cases'           , 'edit', 'KBDocuments'     , 'list', 'KBDocumentPopup();'      , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Cases.KBDocuments'               , 2, 'Cases'           , 'view', 'KBDocuments'     , 'list', 'KBDocuments.Search'      , null, '.LBL_SEARCH_BUTTON_LABEL'                    , '.LBL_SEARCH_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 02/04/2012 Paul.  Add Documents relationship to Accounts, Contacts, Leads and Opportunities. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Documents.Contracts' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Documents.Contracts SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Documents.Contracts'             , 0, 'Documents'       , 'edit', 'Contracts'       , 'list', 'ContractPopup();'        , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 05/31/2013 Paul.  Add Surveys module. 
-- 11/08/2018 Paul.  Allow questions to be added directly to the survey. 
-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.SurveyPages';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Surveys.SurveyPages' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS Surveys.SurveyPages SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'Surveys.SurveyPages'             , 0, 'Surveys'         , 'edit', 'SurveyPages'     , 'edit', 'SurveyPages.Create'      , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Surveys.SurveyPages'             , 1, 'Surveys'         , 'edit', 'SurveyPages'     , 'list', 'SurveyQuestionPopup();'  , null, 'Surveys.LBL_ADD_QUESTIONS'                   , 'Surveys.LBL_ADD_QUESTIONS'                   , null, null, null;
end else begin
	-- 11/08/2018 Paul.  Allow questions to be added directly to the survey. 
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Surveys.SurveyPages'             , 1, 'Surveys'         , 'edit', 'SurveyPages'     , 'list', 'SurveyQuestionPopup();'  , null, 'Surveys.LBL_ADD_QUESTIONS'                   , 'Surveys.LBL_ADD_QUESTIONS'                   , null, null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyPages.SurveyQuestions';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SurveyPages.SurveyQuestions' and DELETED = 0) begin -- then
	print 'DYNAMIC_BUTTONS SurveyPages.SurveyQuestions SubPanel';
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SurveyPages.SurveyQuestions'     , 0, 'SurveyPages'     , 'edit', 'SurveyQuestions' , 'edit', 'SurveyQuestions.Create'  , null, '.LBL_NEW_BUTTON_LABEL'                       , '.LBL_NEW_BUTTON_TITLE'                       , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'SurveyPages.SurveyQuestions'     , 1, 'SurveyPages'     , 'edit', 'SurveyQuestions' , 'list', 'SurveyQuestionPopup();'  , null, '.LBL_SELECT_BUTTON_LABEL'                    , '.LBL_SELECT_BUTTON_TITLE'                    , null, null, null;
end -- if;
GO

-- 03/15/2016 Paul.  Add links to related popup. 
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'Invoices.Activities.Open' and ONCLICK_SCRIPT like 'ActivitiesRelatedPopup();%' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Contracts.Activities.Open'       , 5, 'Contracts'        , 'view', 'Activities'     , 'list', 'ActivitiesRelatedPopup();', null, 'Activities.LBL_SEARCH_RELATED'               , 'Activities.LBL_SEARCH_RELATED'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Invoices.Activities.Open'        , 5, 'Invoices'        , 'view', 'Activities'      , 'list', 'ActivitiesRelatedPopup();', null, 'Activities.LBL_SEARCH_RELATED'               , 'Activities.LBL_SEARCH_RELATED'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Quotes.Activities.Open'          , 5, 'Quotes'          , 'view', 'Activities'      , 'list', 'ActivitiesRelatedPopup();', null, 'Activities.LBL_SEARCH_RELATED'               , 'Activities.LBL_SEARCH_RELATED'               , null, null, null;
	exec dbo.spDYNAMIC_BUTTONS_InsPopup     'Orders.Activities.Open'          , 5, 'Orders'          , 'view', 'Activities'      , 'list', 'ActivitiesRelatedPopup();', null, 'Activities.LBL_SEARCH_RELATED'               , 'Activities.LBL_SEARCH_RELATED'               , null, null, null;
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

call dbo.spDYNAMIC_BUTTONS_SubPanelProfessional()
/

call dbo.spSqlDropProcedure('spDYNAMIC_BUTTONS_SubPanelProfessional')
/

-- #endif IBM_DB2 */


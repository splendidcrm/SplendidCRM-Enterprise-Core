

if exists(select *
            from TERMINOLOGY
           where NAME         = 'Prospects'
             and LANG         = 'en-US'
             and LIST_NAME    = 'moduleList'
             and DISPLAY_NAME = 'Prospects') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Targets'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'Prospects'
	   and LANG          = 'en-US'
	   and LIST_NAME     = 'moduleList'
	   and DISPLAY_NAME  = 'Prospects';
end -- if;
GO

-- 05/26/2007 Paul.  List names must be less than 25 characters. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'Partially Shipped & Invoiced'
             and LANG         = 'en-US'
             and LIST_NAME    = 'order_stage_dom') begin -- then
	update TERMINOLOGY
	   set NAME          = 'Partially Shipped & Invoi'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'Partially Shipped & Invoiced'
	   and LANG          = 'en-US'
	   and LIST_NAME     = 'order_stage_dom';
end -- if;
if exists(select *
            from TERMINOLOGY
           where NAME         = 'Closed - Shipped & Invoiced'
             and LANG         = 'en-US'
             and LIST_NAME    = 'order_stage_dom') begin -- then
	update TERMINOLOGY
	   set NAME          = 'Closed - Shipped & Invoic'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'Closed - Shipped & Invoiced'
	   and LANG          = 'en-US'
	   and LIST_NAME     = 'order_stage_dom';
end -- if;
GO

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.
if exists(select * from TERMINOLOGY where MODULE_NAME = 'TestPlans') begin -- then
	delete from TERMINOLOGY 
	 where MODULE_NAME = 'TestPlans';
end -- if;

if exists(select * from TERMINOLOGY where MODULE_NAME = 'TestCases') begin -- then
	delete from TERMINOLOGY 
	 where MODULE_NAME = 'TestCases';
end -- if;

if exists(select * from TERMINOLOGY where MODULE_NAME = 'TestRuns') begin -- then
	delete from TERMINOLOGY 
	 where MODULE_NAME = 'TestRuns';
end -- if;
GO

if exists(select * from TERMINOLOGY where NAME in ('TestPlans', 'TestCases', 'TestRuns') and LIST_NAME = 'moduleList') begin -- then
	delete from TERMINOLOGY
	 where NAME in ('TestPlans', 'TestCases', 'TestRuns')
	   and LIST_NAME = 'moduleList';
end -- if;
GO

-- 12/13/2007 Paul.  Need to distinguish between Name and List Name fields. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_LIST_NAME'
             and LANG         = 'en-US'
             and MODULE_NAME  = 'Terminology'
             and DISPLAY_NAME = 'Name') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'List Name'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_LIST_NAME'
	   and LANG          = 'en-US'
	   and MODULE_NAME  = 'Terminology'
	   and DISPLAY_NAME  = 'Name';

	exec dbo.spTERMINOLOGY_InsertOnly 'LBL_LIST_NAME_NAME', 'en-US', 'Terminology', null, null, 'Name';
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_CONFIGURE_UPDATER'
             and MODULE_NAME  = 'Administration'
             and DISPLAY_NAME like '% Sugar %') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = replace(DISPLAY_NAME, ' Sugar ', ' SplendidCRM ')
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_CONFIGURE_UPDATER'
	   and MODULE_NAME   = 'Administration'
	   and DISPLAY_NAME like '% Sugar %';
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where NAME         = 'HEARTBEAT_MESSAGE'
             and MODULE_NAME  = 'Administration'
             and DISPLAY_NAME like '%In return for this information%') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'The SplendidCRM Updates mechanism allows your server to check to see if an update to your version of SplendidCRM is available.'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'HEARTBEAT_MESSAGE'
	   and MODULE_NAME   = 'Administration'
	   and DISPLAY_NAME like '%In return for this information%';
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_SEND_STAT'
             and MODULE_NAME  = 'Administration'
             and DISPLAY_NAME like 'Usage Statistics Reporting Enabled.') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = '<B>Send Anonymous Usage Statistics</B> - If checked, SplendidCRM will send anonymous statistics about your installation to SplendidCRM Software, Inc. every time your system checks for new versions.  This information will help us better understand how the application is used and guide improvements to the product.'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_SEND_STAT'
	   and MODULE_NAME   = 'Administration'
	   and DISPLAY_NAME like 'Usage Statistics Reporting Enabled.';
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_SEND_STAT'
             and MODULE_NAME  = 'Administration'
             and DISPLAY_NAME like '% Sugar %') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = replace(replace(DISPLAY_NAME, ' Sugar ', ' SplendidCRM '), ' SugarCRM ', ' SplendidCRM Software, ')
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_SEND_STAT'
	   and MODULE_NAME   = 'Administration'
	   and DISPLAY_NAME like '% Sugar %';
end -- if;
GO

-- 08/08/2011 Paul.  Use a better update message. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_UPDATE_CHECK_TYPE'
             and MODULE_NAME  = 'Administration'
             and DISPLAY_NAME in ('Check for updates', 'Update Check Type')) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Periodically check for updates.'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_UPDATE_CHECK_TYPE'
	   and MODULE_NAME   = 'Administration'
	   and DISPLAY_NAME in ('Check for updates', 'Update Check Type');
end -- if;
GO

-- 01/19/2008 Paul.  We do not support IMAP at this time, so just delete the entry. 
-- 10/21/2010 Paul.  IMAP is now supported. 

-- 01/21/2008 Paul.  Fix send error.  It should not have an underscore. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'send_error'
             and LIST_NAME    = 'dom_email_status'
             and DELETED      = 0) begin -- then
	update TERMINOLOGY
	   set NAME             = 'send error'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'send_error'
	   and LIST_NAME        = 'dom_email_status'
	   and DELETED          = 0;
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where NAME         = 'ERR_INVALID_EMAIL_ADDRESS'
             and MODULE_NAME  is null
             and DISPLAY_NAME like 'not a valid email address.') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = '(invalid email)'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'ERR_INVALID_EMAIL_ADDRESS'
	   and MODULE_NAME   is null
	   and DISPLAY_NAME like 'not a valid email address.';
end -- if;
GO

-- 04/22/2008 Paul.  Refund was moved to the Payment Transaction grid, so change label to Refund. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_REFUND_BUTTON_LABEL'
             and MODULE_NAME  = 'Payments'
             and DISPLAY_NAME = 'Refund Now') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Refund'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_REFUND_BUTTON_LABEL'
	   and MODULE_NAME   = 'Payments'
	   and DISPLAY_NAME  = 'Refund Now';
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_REFUND_BUTTON_TITLE'
             and MODULE_NAME  = 'Payments'
             and DISPLAY_NAME = 'Refund Now') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Refund'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_REFUND_BUTTON_TITLE'
	   and MODULE_NAME   = 'Payments'
	   and DISPLAY_NAME  = 'Refund Now';
end -- if;
GO

-- 05/09/2008 Paul.  Change class from error to warning so that Precompile will not stop on ~/Administration/EmailMain/config.aspx
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_SECURITY_PRESERVE_RAW'
             and DISPLAY_NAME like '%class="error"%'
             and DELETED      = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME = replace(DISPLAY_NAME, 'class="error"', 'class="warning"')
	 where NAME         = 'LBL_SECURITY_PRESERVE_RAW'
	   and DISPLAY_NAME like '%class="error"%'
	   and DELETED      = 0;
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_SECURITY_PRESERVE_RAW'
             and DISPLAY_NAME like '%SugarCRM%'
             and DELETED      = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME = replace(DISPLAY_NAME, 'SugarCRM', 'SplendidCRM')
	 where NAME         = 'LBL_SECURITY_PRESERVE_RAW'
	   and DISPLAY_NAME like '%SugarCRM%'
	   and DELETED      = 0;
end -- if;
GO

-- 05/19/2008 Paul.  A terminology name should never be blank or null. 
-- 06/07/2008 Paul.  The only exceptions are product_category_dom, published_reports_dom and saved_reports_dom. 
/*
if exists(select *
            from TERMINOLOGY
           where (NAME is null or NAME = '')
             and LIST_NAME in ('product_category_dom', 'published_reports_dom', 'saved_reports_dom')
             and DELETED      = 0) begin -- then
	update TERMINOLOGY
	   set DELETED       = 1
	     , DATE_MODIFIED = getdate()
	 where (NAME is null or NAME = '')
	   and LIST_NAME in ('product_category_dom', 'published_reports_dom', 'saved_reports_dom')
	   and DELETED       = 0;

end -- if;
*/


-- 06/07/2008 Paul.  A number of terms needed to be changed from Prospect to Target. 
if exists(select *
            from TERMINOLOGY
           where NAME             = 'Prospect'
             and LIST_NAME        = 'account_type_dom'
             and DISPLAY_NAME     = 'Prospect'
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME     = 'Target'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'Prospect'
	   and LIST_NAME        = 'account_type_dom'
	   and DISPLAY_NAME     = 'Prospect'
	   and DELETED          = 0;
end -- if;

if exists(select *
            from TERMINOLOGY
           where NAME             = 'Prospects'
             and LIST_NAME        = 'record_type_display'
             and DISPLAY_NAME     = 'Prospect'
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME     = 'Target'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'Prospects'
	   and LIST_NAME        = 'record_type_display'
	   and DISPLAY_NAME     = 'Prospect'
	   and DELETED          = 0;
end -- if;

if exists(select *
            from TERMINOLOGY
           where NAME             = 'LBL_LIST_ALL_PROSPECT_LISTS'
             and MODULE_NAME      = 'EmailMarketing'
             and DISPLAY_NAME     = 'All Prospect Lists'
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME     = 'All Target Lists'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'LBL_LIST_ALL_PROSPECT_LISTS'
	   and MODULE_NAME      = 'EmailMarketing'
	   and DISPLAY_NAME     = 'All Prospect Lists'
	   and DELETED          = 0;
end -- if;

if exists(select *
            from TERMINOLOGY
           where NAME             = 'LBL_CONTACT_AND_OTHERS'
             and MODULE_NAME      = 'EmailTemplates'
             and DISPLAY_NAME     = 'Contact/Lead/Prospect'
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME     = 'Contact/Lead/Target'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'LBL_CONTACT_AND_OTHERS'
	   and MODULE_NAME      = 'EmailTemplates'
	   and DISPLAY_NAME     = 'Contact/Lead/Prospect'
	   and DELETED          = 0;
end -- if;

if exists(select *
            from TERMINOLOGY
           where NAME             = 'NTC_EMAIL_MKTG_REMOVE_PROSPECT_LISTS_CONFIRM'
             and MODULE_NAME      = 'ProspectLists'
             and DISPLAY_NAME     = 'Are you sure you want to remove this Prospect List?'
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME     = 'Are you sure you want to remove this Target List?'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'NTC_EMAIL_MKTG_REMOVE_PROSPECT_LISTS_CONFIRM'
	   and MODULE_NAME      = 'ProspectLists'
	   and DISPLAY_NAME     = 'Are you sure you want to remove this Prospect List?'
	   and DELETED          = 0;
end -- if;

if exists(select *
            from TERMINOLOGY
           where NAME             = 'NTC_PROSPECT_REMOVE_PROSPECT_LISTS_CONFIRM'
             and MODULE_NAME      = 'ProspectLists'
             and DISPLAY_NAME     = 'Are you sure you want to remove this Prospect?'
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME     = 'Are you sure you want to remove this Target?'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'NTC_PROSPECT_REMOVE_PROSPECT_LISTS_CONFIRM'
	   and MODULE_NAME      = 'ProspectLists'
	   and DISPLAY_NAME     = 'Are you sure you want to remove this Prospect?'
	   and DELETED          = 0;
end -- if;

if exists(select *
            from TERMINOLOGY
           where NAME             = 'LNK_REPORTS'
             and MODULE_NAME      = 'Prospects'
             and DISPLAY_NAME     = 'Prospect Reports'
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME     = 'Target Reports'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'LNK_REPORTS'
	   and MODULE_NAME      = 'Prospects'
	   and DISPLAY_NAME     = 'Prospect Reports'
	   and DELETED          = 0;
end -- if;
GO

-- 08/12/2008 Paul.  Remove trailing space from St. Kitts. 
if exists(select *
            from TERMINOLOGY
           where NAME             = 'St. Kitts '
             and LIST_NAME        = 'countries_dom'
             and right(NAME, 1)   = ' '
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set NAME             = 'St. Kitts'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'St. Kitts '
	   and LIST_NAME        = 'countries_dom'
	   and right(NAME, 1)   = ' '
	   and DELETED          = 0;
end -- if;
GO

-- 12/13/2008 Paul.  Alt-D should be reserved for the Internet Explorer Address bar. 
if exists(select *
            from TERMINOLOGY
           where NAME             = 'LBL_DELETE_BUTTON_KEY'
             and DISPLAY_NAME     = 'D'
             and DELETED          = 0) begin -- then
	print 'Alt-D should be reserved for the Internet Explorer Address bar. ';
	update TERMINOLOGY
	   set DISPLAY_NAME     = ''
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'LBL_DELETE_BUTTON_KEY'
	   and DISPLAY_NAME     = 'D'
	   and DELETED          = 0;
end -- if;
GO


-- 02/02/2009 Paul.  Fix list numbering. 
if exists(select *
            from TERMINOLOGY
           where (NAME = '' or NAME is null)
             and LIST_NAME        = 'published_reports_dom'
             and LIST_ORDER is null
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set NAME             = null
	     , LIST_ORDER       = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where (NAME = '' or NAME is null)
	   and LIST_NAME        = 'published_reports_dom'
	   and LIST_ORDER is null
	   and DELETED          = 0;
end -- if;
GO

if exists(select *
            from TERMINOLOGY
           where (NAME = '' or NAME is null)
             and LIST_NAME        = 'saved_reports_dom'
             and LIST_ORDER is null
             and DELETED          = 0) begin -- then
	update TERMINOLOGY
	   set NAME             = null
	     , LIST_ORDER       = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where (NAME = '' or NAME is null)
	   and LIST_NAME        = 'saved_reports_dom'
	   and LIST_ORDER is null
	   and DELETED          = 0;
end -- if;
GO

-- 07/11/2009 Paul.  Remove Sugar from Dashlets. 
if exists(select *
            from TERMINOLOGY
           where DISPLAY_NAME like '%Sugar Dashlet%') begin -- then
	print 'Remove Sugar from Dashlets. ';
	update TERMINOLOGY
	   set DISPLAY_NAME  = replace(DISPLAY_NAME, 'Sugar ', '')
	     , DATE_MODIFIED = getdate()
	 where DISPLAY_NAME like '%Sugar Dashlet%';
end -- if;
GO

-- 05/30/2010 Paul.  We will no longer advertise the [Alt] in button titles. 
if exists(select *
            from TERMINOLOGY
           where DISPLAY_NAME like '% [[]Alt]'
             and DELETED      = 0             ) begin -- then
	print 'We will no longer advertise the [Alt] in button titles. ';
	update TERMINOLOGY
	   set DISPLAY_NAME     = replace(DISPLAY_NAME, ' [Alt]', '')
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = null
	 where DISPLAY_NAME     like '% [[]Alt]'
             and DELETED        = 0;
end -- if;
GO

-- 10/19/2010 Paul.  Fix PaymentGateway Default. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_LIST_DEFAULT'
             and LANG         = 'en-US'
             and MODULE_NAME  = 'PaymentGateway'
             and DISPLAY_NAME = 'Description') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Default'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_LIST_DEFAULT'
	   and LANG          = 'en-US'
	   and MODULE_NAME   = 'PaymentGateway'
	   and DISPLAY_NAME  = 'Description';
end -- if;
GO

-- 10/20/2010 Paul.  Support Expires and Starts were reversed. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_DATE_SUPPORT_EXPIRES'
             and LANG         = 'en-US'
             and MODULE_NAME  = 'Products'
             and DISPLAY_NAME = 'Support Starts:') begin -- then
	print 'Fix Products.LBL_DATE_SUPPORT_EXPIRES';
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Support Expires:'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_DATE_SUPPORT_EXPIRES'
	   and LANG          = 'en-US'
	   and MODULE_NAME   = 'Products'
	   and DISPLAY_NAME  = 'Support Starts:';
end -- if;
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_DATE_SUPPORT_STARTS'
             and LANG         = 'en-US'
             and MODULE_NAME  = 'Products'
             and DISPLAY_NAME = 'Support Expires:') begin -- then
	print 'Fix Products.LBL_DATE_SUPPORT_STARTS';
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Support Starts:'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_DATE_SUPPORT_STARTS'
	   and LANG          = 'en-US'
	   and MODULE_NAME   = 'Products'
	   and DISPLAY_NAME  = 'Support Expires:';
end -- if;
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_DATE_SUPPORT_EXPIRES'
             and LANG         = 'en-US'
             and MODULE_NAME  = 'ProductTemplates'
             and DISPLAY_NAME = 'Support Starts:') begin -- then
	print 'Fix ProductTemplates.LBL_DATE_SUPPORT_EXPIRES';
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Support Expires:'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_DATE_SUPPORT_EXPIRES'
	   and LANG          = 'en-US'
	   and MODULE_NAME   = 'ProductTemplates'
	   and DISPLAY_NAME  = 'Support Starts:';
end -- if;
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_DATE_SUPPORT_STARTS'
             and LANG         = 'en-US'
             and MODULE_NAME  = 'ProductTemplates'
             and DISPLAY_NAME = 'Support Expires:') begin -- then
	print 'Fix ProductTemplates.LBL_DATE_SUPPORT_STARTS';
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Support Starts:'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_DATE_SUPPORT_STARTS'
	   and LANG          = 'en-US'
	   and MODULE_NAME   = 'ProductTemplates'
	   and DISPLAY_NAME  = 'Support Expires:';
end -- if;
GO

-- 01/11/2011 Paul.  Fix LBL_TEAM_SET_NAME. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_TEAM_SET_NAME'
             and LANG         = 'en-US'
             and MODULE_NAME  is null
             and DISPLAY_NAME = 'Team Set Name:') begin -- then
	print 'Fix .LBL_TEAM_SET_NAME';
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Teams:'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_TEAM_SET_NAME'
	   and LANG          = 'en-US'
	   and MODULE_NAME   is null
	   and DISPLAY_NAME  = 'Team Set Name:';
end -- if;
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_TEAM_SET_LIST'
             and LANG         = 'en-US'
             and MODULE_NAME  is null
             and DISPLAY_NAME = 'Team Set List:') begin -- then
	print 'Fix .LBL_TEAM_SET_LIST';
	update TERMINOLOGY
	   set DISPLAY_NAME  = 'Teams:'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_TEAM_SET_LIST'
	   and LANG          = 'en-US'
	   and MODULE_NAME   is null
	   and DISPLAY_NAME  = 'Team Set List:';
end -- if;
GO

-- 02/16/2011 Paul.  Fix URL for ChangePassword.  It had a single " and not enclosing double quotes. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_RESET_PASSWORD_BODY'
             and LANG         = 'en-US'
             and MODULE_NAME  = 'Users'
             and DISPLAY_NAME like '%<a href={0}">%') begin -- then
	print 'Fix Users.LBL_RESET_PASSWORD_BODY';
	update TERMINOLOGY
	   set DISPLAY_NAME  = N'<p>A password reset was requested.</p><p>Please click the following link to reset your password:</p><p><a href="{0}">{0}</a></p>'
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'LBL_RESET_PASSWORD_BODY'
	   and LANG          = 'en-US'
	   and MODULE_NAME   = 'Users'
	   and DISPLAY_NAME  like '%<a href={0}">%';
end -- if;
GO

-- 03/19/2011 Paul.  Fix password confirmation message. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_CONFIRM_PORTAL_PASSWORD'
             and LANG         = 'en-US'
             and MODULE_NAME  = 'Contacts'
             and DISPLAY_NAME = 'Are you sure?') begin -- then
	print 'Fix password confirmation message. ';
	update TERMINOLOGY
	   set DISPLAY_NAME      = N'Confirm Password:'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where NAME              = 'LBL_CONFIRM_PORTAL_PASSWORD'
	   and LANG              = 'en-US'
	   and MODULE_NAME       = 'Contacts'
	   and DISPLAY_NAME      = 'Are you sure?';
end -- if;
GO

-- 03/31/2012 Paul.  Change current user to My Items. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_CURRENT_USER_FILTER'
             and LANG         = 'en-US'
             and MODULE_NAME  is null
             and DISPLAY_NAME = 'Current User Filter:') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME      = N'My Items:'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where NAME              = 'LBL_CURRENT_USER_FILTER'
	   and LANG              = 'en-US'
	   and MODULE_NAME       is null
	   and DISPLAY_NAME      = 'Current User Filter:';
end -- if;
GO

-- 09/14/2012 Paul.  Fix spelling for ERR_CONCURRENCY_EXCEPTION. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'ERR_CONCURRENCY_EXCEPTION'
             and MODULE_NAME  is null
             and DISPLAY_NAME like '% lated %') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME  = replace(DISPLAY_NAME, ' lated ', ' last ')
	     , DATE_MODIFIED = getdate()
	 where NAME          = 'ERR_CONCURRENCY_EXCEPTION'
	   and MODULE_NAME   is null
	   and DISPLAY_NAME like '% lated %';
end -- if;
GO

-- 01/19/2013 Paul.  Fix spelling for LBL_REFERED_BY and LBL_LIST_REFERED_BY. 
if exists(select *
            from TERMINOLOGY
           where NAME         in ('LBL_REFERED_BY', 'LBL_LIST_REFERED_BY')
             and MODULE_NAME  = 'Leads'
             and DISPLAY_NAME like '%Refered%') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME      = replace(DISPLAY_NAME, 'Refered', 'Referred')
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getdate()
	 where NAME              in ('LBL_REFERED_BY', 'LBL_LIST_REFERED_BY')
	   and MODULE_NAME       = 'Leads'
	   and DISPLAY_NAME like '%Refered%';
end -- if;
GO

-- 08/07/2013 Paul.  Change My Account to Profile. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_MY_ACCOUNT'
             and MODULE_NAME  is null
             and DISPLAY_NAME = 'My Account') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME      = 'Profile'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getdate()
	 where NAME         = 'LBL_MY_ACCOUNT'
	   and MODULE_NAME  is null
	   and DISPLAY_NAME = 'My Account';
end -- if;
GO

-- 09/15/2014 Paul.  Change to just Reports to match all other modules. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LNK_REPORTS'
             and MODULE_NAME  = 'Reports'
             and DISPLAY_NAME = 'All Reports') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME      = 'Reports'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getdate()
	 where NAME         = 'LNK_REPORTS'
	   and MODULE_NAME  = 'Reports'
	   and DISPLAY_NAME = 'All Reports';
end -- if;
GO

-- 09/15/2015 Paul.  Change to Targets. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LBL_LIST_MY_PROSPECTS'
             and MODULE_NAME  = 'Prospects'
             and DISPLAY_NAME = 'My Prospects') begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME      = 'My Targets'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getdate()
	 where NAME         = 'LBL_LIST_MY_PROSPECTS'
	   and MODULE_NAME  = 'Prospects'
	   and DISPLAY_NAME = 'My Prospects';
end -- if;
GO

-- 06/30/2018 Paul.  Rename to Audit Log. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'LNK_VIEW_CHANGE_LOG'
             and DISPLAY_NAME = 'View Change Log'
             and LANG         = 'en-US'
             and DELETED      = 0) begin -- then
	update TERMINOLOGY
	   set DISPLAY_NAME      = 'View Audit Log'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getdate()
	 where NAME              = 'LNK_VIEW_CHANGE_LOG'
	   and DISPLAY_NAME      = 'View Change Log'
	   and LANG              = 'en-US'
	   and DELETED           = 0;
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

call dbo.spTERMINOLOGY_maintenance()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_maintenance')
/

-- #endif IBM_DB2 */


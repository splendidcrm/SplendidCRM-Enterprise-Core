

set nocount on;
GO

-- 05/26/2007 Paul.  Delete duplicate ProjectTasks entry. 
if exists (select * from MODULES where MODULE_NAME = 'ProjectTasks' and DELETED = 0) begin -- then
	print 'Delete the invalid ProjectTasks module.';
	update MODULES
	   set DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	     , DELETED          = 1
	 where MODULE_NAME      = 'ProjectTasks'
	   and DELETED          = 0;
end -- if;
GO


-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.


if not exists (select * from MODULES where MODULE_NAME = 'ProductTemplates' and DELETED = 0) begin -- then
	exec dbo.spMODULES_InsertOnly null, 'ProductTemplates'      , '.moduleList.ProductTemplates'         , '~/Administration/ProductTemplates/' , 1, 0,  0, 0, 1, 0, 0, 1, 'PRODUCT_TEMPLATES', 0;
	-- 06/02/2006 Paul.  Enable Products, Quotes and Reports. 
	print 'Enable Products, Quotes and Reports.';
	update MODULES
	   set MODULE_ENABLED   = 1
	     , TAB_ENABLED      = 1
	     , TAB_ORDER        = 17
	     , CUSTOM_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where DISPLAY_NAME     = '.moduleList.Products'
	   and DELETED          = 0;
	update MODULES
	   set MODULE_ENABLED   = 1
	     , TAB_ENABLED      = 1
	     , TAB_ORDER        = 18
	     , CUSTOM_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where DISPLAY_NAME     = '.moduleList.Quotes'
	   and DELETED          = 0;
	update MODULES
	   set MODULE_ENABLED   = 1
	     , TAB_ENABLED      = 1
	     , TAB_ORDER        = 19
	     , CUSTOM_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where DISPLAY_NAME     = '.moduleList.Reports'
	   and DELETED          = 0;
end -- if;
GO


-- 04/25/2006 Paul.  Fix name for Project Tasks.
if exists (select * from MODULES where DISPLAY_NAME = '.moduleList.ProjectTasks' and DELETED = 0) begin -- then
	print 'Fix name for Project Tasks.';
	update MODULES
	   set DISPLAY_NAME     = '.moduleList.ProjectTask'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where DISPLAY_NAME     = '.moduleList.ProjectTasks'
	   and DELETED          = 0;
end -- if;
GO

-- 04/28/2006 Paul.  Fix relative path for Feeds.
if exists (select * from MODULES where RELATIVE_PATH = '~/Feeds/MyFeeds.aspx' and DELETED = 0) begin -- then
	print 'Fix relative path for Feeds.';
	update MODULES
	   set RELATIVE_PATH    = '~/Feeds/'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where RELATIVE_PATH    = '~/Feeds/MyFeeds.aspx'
	   and DELETED          = 0;
end -- if;
GO

-- 04/28/2006 Paul.  Delete the old Roles module. 
if exists (select * from MODULES where MODULE_NAME = 'Roles' and DELETED = 0) begin -- then
	print 'Delete the old Roles module.';
	update MODULES
	   set DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	     , DELETED          = 1
	 where MODULE_NAME      = 'Roles'
	   and DELETED          = 0;
end -- if;
GO

-- 05/26/2007 Paul.  There is not compelling reason to allow ACLRoles to be customized. 
if exists (select * from MODULES where MODULE_NAME = 'ACLRoles' and CUSTOM_ENABLED = 1) begin -- then
	print 'Disable ACLRoles customization.';
	update MODULES
	   set DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	     , CUSTOM_ENABLED   = 0
	 where MODULE_NAME      = 'ACLRoles'
	   and CUSTOM_ENABLED   = 1;
end -- if;
GO

-- 07/07/2007 Paul.  Fix misspelled FORECASTS table name. 
if exists (select * from MODULES where MODULE_NAME = 'Forecasts' and TABLE_NAME = 'FORCASTS' and DELETED = 0) begin -- then
	print 'Fix misspelled FORECASTS table name. ';
	update MODULES
	   set TABLE_NAME       = 'FORECASTS'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'Forecasts'
	   and TABLE_NAME       = 'FORCASTS'
	   and DELETED          = 0;
end -- if;
GO

if exists (select * from MODULES where MODULE_ENABLED = 0 and DELETED = 0 and (TAB_ENABLED = 1 or TAB_ORDER = 1)) begin -- then
	print 'Clear the tab info for disabled modules.';
	update MODULES
	   set TAB_ENABLED      = 0
	     , TAB_ORDER        = 0
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_ENABLED   = 0
	   and DELETED          = 0
	   and (TAB_ENABLED = 1 or TAB_ORDER = 1);
end -- if;
GO

-- 11/15/2007 Paul.  Contracts can be customized. 
if exists (select * from MODULES where MODULE_NAME = 'Contracts' and CUSTOM_ENABLED = 0 and DELETED = 0) begin -- then
	print 'Enable customizations for the Contracts module.';
	update MODULES
	   set CUSTOM_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'Contracts'
	   and CUSTOM_ENABLED   = 0
	   and DELETED          = 0;
end -- if;
GO

-- 11/17/2007 Paul.  Clear tab for modules that are not visible. 
if exists (select * from MODULES where TAB_ENABLED = 0 and MOBILE_ENABLED = 0 and TAB_ORDER > 0 and DELETED = 0) begin -- then
	print 'Clear tab for modules that are not visible.';
	update MODULES
	   set TAB_ORDER        = 0
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where TAB_ENABLED      = 0 
	   and MOBILE_ENABLED   = 0 
	   and TAB_ORDER        > 0
	   and DELETED          = 0;
end -- if;
GO

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.
if exists(select * from MODULES where MODULE_NAME = 'TestPlans') begin -- then
	delete from MODULES 
	 where MODULE_NAME = 'TestPlans';
end -- if;
GO

if exists(select * from MODULES where MODULE_NAME = 'TestCases') begin -- then
	delete from MODULES 
	 where MODULE_NAME = 'TestCases';
end -- if;
GO

if exists(select * from MODULES where MODULE_NAME = 'TestRuns') begin -- then
	delete from MODULES 
	 where MODULE_NAME = 'TestRuns';
end -- if;
GO

-- 12/29/2007 Paul.  Delete any modules that have duplicate records.  This would cause spMODULES_InsertOnly to fail. 
if exists(select MODULE_NAME from MODULES where DELETED = 0 group by MODULE_NAME having count(*) > 1) begin -- then
	print 'Deleting modules with duplicate records.';
	update MODULES
	   set DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	     , DELETED          = 1
	 where MODULE_NAME in (select MODULE_NAME from MODULES where DELETED = 0 group by MODULE_NAME having count(*) > 1);
end -- if;
GO

-- 12/29/2007 Paul.  Delete any modules that have duplicate records.  This would cause spMODULES_InsertOnly to fail. 
if exists(select MODULE_NAME from MODULES where DELETED = 0 group by MODULE_NAME having count(*) > 1) begin -- then
	print 'Deleting modules with duplicate records.';
	update MODULES
	   set DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	     , DELETED          = 1
	 where MODULE_NAME in (select MODULE_NAME from MODULES where DELETED = 0 group by MODULE_NAME having count(*) > 1);
end -- if;
GO


-- 02/10/2008 Paul.  Lets not display Forums to all users. Creating a forum is an admin-only function. 
if exists (select * from MODULES where MODULE_NAME = 'Forums' and TAB_ENABLED = 1 and DELETED = 0) begin -- then
	print 'Hide Forums from tab menu.';
	update MODULES
	   set TAB_ENABLED      = 0
	     , TAB_ORDER        = null
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME     = 'Forums'
	   and TAB_ENABLED      = 1
	   and DELETED          = 0;
end -- if;
GO

-- 02/23/2008 Paul.  Change ProductTasks to ProductTypes. 
if exists (select * from MODULES where MODULE_NAME = 'ProductTasks' and DELETED = 0) begin -- then
	print 'Change ProductTasks to ProductTypes.';
	update MODULES
	   set MODULE_NAME      = 'ProductTypes'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'ProductTasks'
	   and DELETED          = 0;
end -- if;
GO

-- 02/29/2008 Paul.  Threads can now contain custom fields. 
if exists (select * from MODULES where MODULE_NAME = 'Threads' and CUSTOM_ENABLED = 0 and DELETED = 0) begin -- then
	print 'Threads can now contain custom fields.';
	update MODULES
	   set CUSTOM_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'Threads'
	   and CUSTOM_ENABLED   = 0
	   and DELETED          = 0;
end -- if;
GO

-- 03/04/2008 Paul.  Minor fix to RELATIVE_PATH. 
-- 02/23/2010 Paul.  Administration was spelled wrong.  It was spelled as Administation, so ModulePopups failed on upgraded systems. 
if exists (select * from MODULES where MODULE_NAME = 'Teams' and RELATIVE_PATH = '~/Teams/' and DELETED = 0) begin -- then
	print 'Fix Teams RELATIVE_PATH.';
	update MODULES
	   set RELATIVE_PATH    = '~/Administration/Teams/'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'Teams'
	   and RELATIVE_PATH    = '~/Teams/'
	   and DELETED          = 0;
end -- if;
GO

-- 02/23/2010 Paul.  Administration was spelled wrong.  It was spelled as Administation, so ModulePopups failed on upgraded systems. 
if exists (select * from MODULES where RELATIVE_PATH like '%Administation%' and DELETED = 0) begin -- then
	print 'Fix Teams RELATIVE_PATH.';
	update MODULES
	   set RELATIVE_PATH    = replace(RELATIVE_PATH, 'Administation', 'Administration')
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where RELATIVE_PATH    like '%Administation%'
	   and DELETED          = 0;
end -- if;
GO

-- 04/21/2008 Paul.  Move MODULE maintenance from Tables area to Data area. 
-- 05/02/2006 Paul.  Correct the module name. 
if exists(select * from MODULES where MODULE_NAME = N'ProjectTasks') begin -- then
	print 'Correct the ProjectTask module name.';
	update MODULES
	   set MODULE_NAME = N'ProjectTask'
	 where MODULE_NAME = N'ProjectTasks';
end -- if;
GO

-- 05/02/2006 Paul.  Module names are not the same as table names. 
if not exists(select * from MODULES where MODULE_NAME = N'ProjectTask' and CUSTOM_ENABLED = 1) begin -- then
	print 'Module names are not the same as table names.';
	update MODULES
	   set CUSTOM_ENABLED = 1
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME in
		( N'Accounts'
		, N'Bugs'
		, N'Calls'
		, N'Campaigns'
		, N'Cases'
		, N'Contacts'
		, N'Currencies'
		, N'Documents'
		, N'EmailMarketing'
		, N'EmailTemplates'
		, N'Emailman'
		, N'Emails'
		, N'Leads'
		, N'Meetings'
		, N'Notes'
		, N'Opportunities'
		, N'Project'
		, N'ProjectTask'
		, N'ProspectLists'
		, N'Prospects'
		, N'Releases'
		, N'Roles'
		, N'Tasks'
		, N'TestCases'
		, N'TestPlans'
		, N'TestRuns'
		, N'Users'
		);
end -- if;
GO

-- 01/13/2010 Paul.  The MASS_UPDATE_ENABLED flag needs to be corrected on a clean database. 
if not exists(select * from MODULES where MASS_UPDATE_ENABLED = 1) begin -- then
	print 'MODULES: Update MASS_UPDATE_ENABLED defaults.';
	update MODULES
	   set MASS_UPDATE_ENABLED = 1
	     , DATE_MODIFIED       = getdate()
	     , MODIFIED_USER_ID    = null
	 where MODULE_NAME in 
		( N'Accounts'
		, N'Bugs'
		, N'Calls'
		, N'Campaigns'
		, N'Cases'
		, N'Contacts'
		, N'Contracts'
		, N'Documents'
		, N'Emails'
		, N'EmailTemplates'
		, N'iFrames'
		, N'Invoices'
		, N'KBDocuments'
		, N'Leads'
		, N'Meetings'
		, N'Notes'
		, N'Opportunities'
		, N'Orders'
		, N'Payments'
		, N'Products'
		, N'Project'
		, N'ProjectTask'
		, N'ProspectLists'
		, N'Prospects'
		, N'Quotes'
		, N'Tasks'
		);
end -- if;
GO

-- 05/13/2008 Paul.  Fix misspelled CREDIT_CARDS table name. 
if exists (select * from MODULES where MODULE_NAME = 'CreditCards' and TABLE_NAME = 'CreditCards' and DELETED = 0) begin -- then
	print 'Fix misspelled CREDIT_CARDS table name. ';
	update MODULES
	   set TABLE_NAME       = 'CREDIT_CARDS'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'CreditCards'
	   and TABLE_NAME       = 'CreditCards'
	   and DELETED          = 0;
end -- if;
GO

-- 07/24/2008 Paul.  Admin modules are not typically reported on.
if exists (select * from MODULES where REPORT_ENABLED = 1 and MODULE_NAME in ('Shortcuts', 'EmailMan', 'InboundEmail', 'Schedulers') and DELETED = 0) begin -- then
	print 'Admin modules are not typically reported on.';
	update MODULES
	   set REPORT_ENABLED    = 0
	     , DATE_MODIFIED     = getdate()
	     , MODIFIED_USER_ID  = null
	 where REPORT_ENABLED    = 1
	   and MODULE_NAME       in ('Shortcuts', 'EmailMan', 'InboundEmail', 'Schedulers')
	   and DELETED           = 0;
end -- if;
GO

-- 09/10/2008 Paul.  Fix Posts table name. 
if exists (select * from MODULES where MODULE_NAME = 'Posts' and TABLE_NAME = 'FORUMS' and DELETED = 0) begin -- then
	print 'Fix Posts table name. ';
	update MODULES
	   set TABLE_NAME       = 'POSTS'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'Posts'
	   and TABLE_NAME       = 'FORUMS'
	   and DELETED          = 0;
end -- if;
GO

-- 09/09/2009 Paul.  Employees are stored in the USERS table, so specify the table in the record. 
if exists (select * from MODULES where MODULE_NAME = 'Employees' and TABLE_NAME is null and DELETED = 0) begin -- then
	print 'Fix Employees table name. ';
	update MODULES
	   set TABLE_NAME       = 'USERS'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'Employees'
	   and TABLE_NAME       is null
	   and DELETED          = 0;
end -- if;
GO

-- 09/26/2010 Paul.  Fix relative path for ProductTypes. 
if exists (select * from MODULES where MODULE_NAME = 'ProductTypes' and RELATIVE_PATH = '~/Administrations/ProductTypes/' and DELETED = 0) begin -- then
	print 'Fix ProductTypes relative path. ';
	update MODULES
	   set RELATIVE_PATH    = '~/Administration/ProductTypes/'
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'ProductTypes'
	   and RELATIVE_PATH    = '~/Administrations/ProductTypes/'
	   and DELETED          = 0;
end -- if;
GO

-- 09/26/2010 Paul.  ProductTypes: Enable custom fields. 
if exists (select * from MODULES where MODULE_NAME = 'ProductCategories' and CUSTOM_ENABLED = 0 and DELETED = 0) begin -- then
	print 'ProductCategories: Enable custom fields. ';
	update MODULES
	   set CUSTOM_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'ProductCategories'
	   and CUSTOM_ENABLED   = 0
	   and DELETED          = 0;
end -- if;
GO

-- 09/26/2010 Paul.  ProductTypes: Enable custom fields. 
if exists (select * from MODULES where MODULE_NAME = 'ProductTypes' and CUSTOM_ENABLED = 0 and DELETED = 0) begin -- then
	print 'ProductTypes: Enable custom fields. ';
	update MODULES
	   set CUSTOM_ENABLED   = 1
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = null
	 where MODULE_NAME      = 'ProductTypes'
	   and CUSTOM_ENABLED   = 0
	   and DELETED          = 0;
end -- if;
GO

-- 12/06/2010 Paul.  MODULES: Update DISPLAY_NAME to use moduleList.
if exists (select TERMINOLOGY.NAME
             from      TERMINOLOGY
            inner join MODULES
                    on MODULES.MODULE_NAME = TERMINOLOGY.NAME
                   and MODULES.DELETED     = 0
                   and MODULES.DISPLAY_NAME not like '.moduleList.%' 
            where TERMINOLOGY.LIST_NAME = 'moduleList'
              and TERMINOLOGY.DELETED = 0
          ) begin -- then
	print 'MODULES: Update DISPLAY_NAME to use moduleList. ';
	update MODULES
	   set DISPLAY_NAME     = '.moduleList.' + MODULE_NAME
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = null
	 where DELETED = 0
	   and MODULE_NAME in 
	       (select TERMINOLOGY.NAME
	          from      TERMINOLOGY
	         inner join MODULES
	                 on MODULES.MODULE_NAME = TERMINOLOGY.NAME
	                and MODULES.DELETED     = 0
	                and MODULES.DISPLAY_NAME not like '.moduleList%' 
	         where TERMINOLOGY.LIST_NAME = 'moduleList'
	           and TERMINOLOGY.DELETED = 0
	       );
end -- if;
GO


-- 02/22/2013 Paul.  NumberSequences is an admin module. 
if exists (select * from MODULES where MODULE_NAME = 'NumberSequences' and IS_ADMIN = 0 and DELETED = 0) begin -- then
	print 'NumberSequences is an admin module.';
	update MODULES
	   set IS_ADMIN          = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       = 'NumberSequences'
	   and IS_ADMIN          = 0
	   and DELETED           = 0;
end -- if;
GO

-- 02/23/2013 Paul.  In order to show the Calendar module, we need to enable it as a REST table. 
-- 02/26/2013 Paul.  Change the path to the new HTML5 calendar. 
if exists (select * from MODULES where MODULE_NAME = 'Calendar' and TABLE_NAME is null and DELETED = 0) begin -- then
	print 'Calendar needs a table name.';
	update MODULES
	   set TABLE_NAME        = 'ACTIVITIES'
	     , RELATIVE_PATH     = '~/Calendar/html5/'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where MODULE_NAME       = 'Calendar'
	   and TABLE_NAME        is null
	   and DELETED           = 0;
end -- if;
GO

-- 08/13/2014 Paul.  Make the CampaignLog reportable so that workflow can be attached. 
if exists (select * from MODULES where MODULE_NAME = 'CampaignLog' and REPORT_ENABLED = 0 and DELETED = 0) begin -- then
	print 'Make the CampaignLog reportable so that workflow can be attached. ';
	update MODULES
	   set REPORT_ENABLED    = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where REPORT_ENABLED    = 0
	   and MODULE_NAME       = 'CampaignLog'
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

call dbo.spMODULES_maintenance()
/

call dbo.spSqlDropProcedure('spMODULES_maintenance')
/

-- #endif IBM_DB2 */


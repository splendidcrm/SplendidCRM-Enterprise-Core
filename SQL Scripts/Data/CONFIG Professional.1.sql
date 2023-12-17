

print 'CONFIG Professional';
GO

set nocount on;
GO

-- 08/22/2008 Paul.  Move professional modules to a separate file. 

-- 02/13/2008 Paul.  Create separate keys for credit card numbers. 
if not exists(select * from CONFIG where NAME = 'CreditCardKey' and DELETED = 0) begin -- then
	insert into CONFIG(ID, CATEGORY, NAME, VALUE)
	values(newid(), 'system', 'CreditCardKey', cast(newid() as nvarchar(36)));
end -- if;
-- 01/09/2008 Paul.  Generate the encryption IV as it must remain with the database. 
if not exists(select * from CONFIG where NAME = 'CreditCardKey' and DELETED = 0) begin -- then
	insert into CONFIG(ID, CATEGORY, NAME, VALUE)
	values(newid(), 'system', 'CreditCardIV', cast(newid() as nvarchar(36)));
end -- if;

-- 11/19/2006 Paul.  Team Management can be enabled and disabled. Default to false. 
-- 08/29/2009 Paul.  Team Management is an important feature, so we will turn it on by default. 

-- 02/27/2010 Paul.  Team Management was not previously enabled because true was misspelled as tue. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'enable_team_management'                 , 'true';
-- 11/22/2006 Paul.  When Team Management is enabled, it can required or optional.  Default is fault. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'require_team_management'                , 'false';
-- 04/07/2016 Paul.  Provide a way to disable private teams.  
exec dbo.spCONFIG_InsertOnly null, 'system', 'disable_private_teams'                  , 'false';

-- #if SQL_Server /*
if exists(select * from CONFIG where NAME = 'enable_team_management' and VALUE = 'tue' and DELETED = 0) begin -- then
	-- 02/27/2010 Paul.  As we fix the Team Management flag, convert bad value to false so it is not turned on by mistake.
	update CONFIG
	   set VALUE             = 'false'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where NAME = 'enable_team_management';
end -- if;
-- #endif SQL_Server */

-- 01/22/2007 Paul.  If ASSIGNED_USER_ID is null, then let everybody see it. 

-- 02/21/2008 Paul.  Payment settings. 
exec dbo.spCONFIG_InsertOnly null, 'payments', 'PaymentGateway'                       , '';
exec dbo.spCONFIG_InsertOnly null, 'payments', 'PaymentGateway_Login'                 , '';
exec dbo.spCONFIG_InsertOnly null, 'payments', 'PaymentGateway_Password'              , '';
exec dbo.spCONFIG_InsertOnly null, 'payments', 'PaymentGateway_TestMode'              , 'true';

-- 07/26/2008 Paul.  Provide a way to disable workflow. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'enable_workflow'                        , 'true';
-- 03/05/2009 Paul.  Add portal option, but start disabled. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'portal_on'                              , 'false';

-- 06/02/2009 Paul.  We need to allow the global team to be changed to help with SugarCRM migrations. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'global_team_id'                         , '17BB7135-2B95-42DC-85DE-842CAFF927A0';

-- 07/10/2010 Paul.  Product Options. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'ProductCatalog.EnableOptions'           , 'true';

-- 08/02/2010 Paul.  Some states require that the shipping be taxes. We will use one flag for Quotes, Orders and Invoices. 
exec dbo.spCONFIG_InsertOnly null, 'orders', 'Orders.TaxShipping'                     , 'false';
-- 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
exec dbo.spCONFIG_InsertOnly null, 'orders', 'Orders.TaxLineItems'                    , 'false';
exec dbo.spCONFIG_InsertOnly null, 'orders', 'Orders.ShowTaxColumn'                   , 'false';
-- 12/14/2013 Paul.  Move Show flags to config. 
exec dbo.spCONFIG_InsertOnly null, 'orders', 'Orders.ShowCostPriceColumn'             , 'true';
exec dbo.spCONFIG_InsertOnly null, 'orders', 'Orders.ShowListPriceColumn'             , 'true';
-- 11/30/2015 Paul.  Allow Tax to be disabled and to hide MFT Part Number. 
exec dbo.spCONFIG_InsertOnly null, 'orders', 'Orders.ShowMftPartNumColumn'             , 'true';
exec dbo.spCONFIG_InsertOnly null, 'orders', 'Orders.EnableSalesTax'                   , 'true';
-- 04/07/2016 Paul.  Tax rates per team. 
exec dbo.spCONFIG_InsertOnly null, 'orders', 'Orders.EnableTaxRateTeams'               , 'false';

-- 10/19/2010 Paul.  Create a placeholder for a default team to be assigned to new users. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'default_team'                           , '';

-- 03/25/2011 Paul.  Undocumented Exchange sync flags. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Exchange.VerboseStatus'                 , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Exchange.ConflictResolution'            , '';  -- blank, remote, local 
-- 06/05/2011 Paul.  A customer had an internal server error when trying to connect to Exchange 2010 SP1. 
-- 01/17/2017 Paul.  Default to Exchange 2013 SP1. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Exchange.Version'                       , 'Exchange2013_SP1';  -- blank, remote, local 
-- 02/20/2013 Paul.  Reduced the number of days to go back. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Exchange.AppointmentAgeDays'            , '7';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Exchange.CrmFolderName'                 , 'SplendidCRM';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Exchange.Calendar.Category'             , 'SplendidCRM';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Exchange.Contacts.Category'             , 'SplendidCRM';
-- 04/17/2018 Paul.  Enable Exchange Sync when configuring Exchange or Office365. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Exchange.DefaultEnableExchangeFolders'  , 'true';

-- 03/25/2011 Paul.  Add support for Google Apps. 
-- 02/25/2012 Paul.  Enable Google Apps by default so that it will appear in the user profile area. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'GoogleApps.Enabled'                     , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'GoogleApps.VerboseStatus'               , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'GoogleApps.ConflictResolution'          , '';  -- blank, remote, local 
-- 02/20/2013 Paul.  Reduced the number of days to go back. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'GoogleApps.AppointmentAgeDays'          , '7';

exec dbo.spCONFIG_InsertOnly null, 'system', 'GoogleMaps.Key'                         , '';
-- 08/26/2011 Paul.  Geocoding API V3 allows us to select long or short names. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'GoogleMaps.ShortStateName'              , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'GoogleMaps.ShortCountryName'            , 'false';

-- 12/13/2011 Paul.  Add support for Apple iCloud. 
-- 02/25/2012 Paul.  Enable iCloud by default so that it will appear in the user profile area. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'iCloud.Enabled'                         , 'true';
exec dbo.spCONFIG_InsertOnly null, 'system', 'iCloud.VerboseStatus'                   , 'false';
exec dbo.spCONFIG_InsertOnly null, 'system', 'iCloud.ConflictResolution'              , '';  -- blank, remote, local 
-- 02/20/2013 Paul.  Reduced the number of days to go back. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'iCloud.AppointmentAgeDays'              , '7';

-- 01/15/2013 Paul.  A customer wants to be able to change the assigned user as this was previously allowed in report prompts. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Reports.ShowAssignedUser'               , 'false';

-- 06/04/2013 Paul.  Default survey theme. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Surveys.DefaultTheme'                   , '795E60EE-CF84-4CD2-926B-E26D22D6C9DB';
exec dbo.spCONFIG_InsertOnly null, 'system', 'Surveys.SurveySiteURL'                  , '';
-- 07/23/2013 Paul.  Requiring selection is optional. 
exec dbo.spCONFIG_InsertOnly null, 'system', 'Emails.RequireSelectMailbox'            , 'false';
-- 04/14/2016 Paul.  Provide a way to inherit Assigned User from parent.  
exec dbo.spCONFIG_InsertOnly null, 'system', 'inherit_team'                           , 'false';
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

call dbo.spCONFIG_Professional()
/

call dbo.spSqlDropProcedure('spCONFIG_Professional')
/

-- #endif IBM_DB2 */


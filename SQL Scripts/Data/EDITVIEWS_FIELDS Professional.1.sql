

print 'EDITVIEWS_FIELDS Professional';
--delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.EditView'
--GO

set nocount on;
GO

-- 11/17/2007 Paul.  Add spEDITVIEWS_InsertOnly to simplify creation of Mobile views.
-- 11/24/2006 Paul.  Add TEAM_ID for team management. 
-- 11/25/2006 Paul.  Convert Assigned To from a ListBox to a ChangeButton. 
-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 09/08/2008 Paul.  Must use a comment block to allow Oracle migration to work properly. 
-- 09/14/2008 Paul.  DB2 does not work well with optional parameters. 
-- 08/24/2009 Paul.  Change TEAM_NAME to TEAM_SET_NAME. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 

/*
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Roles.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Roles.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Roles.EditView'         , 'Roles'         , 'vwROLES_Edit'         , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Roles.EditView'          ,  0, 'Roles.LBL_NAME'                         , 'NAME'                       , 1, 1, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView'          ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView'          ,  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView'          ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Roles.EditView'          ,  4, 'Roles.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 3,   8, 90, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView'          ,  5, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView'          ,  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Roles.EditView'          ,  7, null;
end -- if;
*/

-- 03/13/2008 Paul.  Allow default team during import. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Users.TeamView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Users.TeamView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Users.TeamView';
	-- 03/25/2011 Paul.  Remove trailing space from EDIT_NAME. 
	exec dbo.spEDITVIEWS_InsertOnly            'Users.TeamView'          , 'Users'         , 'vwUSERS_Edit'         , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Users.TeamView'          ,  1, 'Users.LBL_STATUS'                       , 'STATUS'                      , 1, 1, 'user_status_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Users.TeamView'          ,  2, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                     , 0, 1, 'TEAM_NAME'          , 'Teams', null;
end -- if;
GO

-- 03/25/2011 Paul.  Add support for Google Apps. 
-- 09/13/2015 Paul.  Google now uses OAuth 2.0, so Username and password is used.  Keep Username for now. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Users.EditGoogleAppsOptions';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Users.EditGoogleAppsOptions' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Users.EditGoogleAppsOptions';
	exec dbo.spEDITVIEWS_InsertOnly             'Users.EditGoogleAppsOptions', 'Users', 'vwUSERS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Users.EditGoogleAppsOptions',  0, 'Users.LBL_GOOGLEAPPS_SYNC_CONTACTS', 'GOOGLEAPPS_SYNC_CONTACTS'      , 0, 10, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Users.EditGoogleAppsOptions',  1, 'Users.LBL_GOOGLEAPPS_SYNC_CALENDAR', 'GOOGLEAPPS_SYNC_CALENDAR'      , 0, 10, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Users.EditGoogleAppsOptions',  2, 'Users.LBL_GOOGLEAPPS_USERNAME'     , 'GOOGLEAPPS_USERNAME'           , 0, 10, 100, 35, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsPassword     'Users.EditGoogleAppsOptions',  3, 'Users.LBL_GOOGLEAPPS_PASSWORD'     , 'GOOGLEAPPS_PASSWORD'           , 0, 10, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_UpdateTip null, 'Users.EditGoogleAppsOptions',  2, 'Users.LBL_GOOGLEAPPS_USERNAME_TIP';
--	exec dbo.spEDITVIEWS_FIELDS_UpdateTip null, 'Users.EditGoogleAppsOptions',  3, 'Users.LBL_GOOGLEAPPS_PASSWORD_TIP';
end else begin
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Users.EditGoogleAppsOptions' and DATA_FIELD = 'GOOGLEAPPS_PASSWORD' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Users.EditGoogleAppsOptions'
		   and DATA_FIELD        = 'GOOGLEAPPS_PASSWORD'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 12/13/2011 Paul.  Add support for Apple iCloud. 
-- 07/11/2020 Paul.  iCloud now uses 2 factor authentication, so we need to prompt for the security code. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Users.EditICloudOptions';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Users.EditICloudOptions' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Users.EditICloudOptions';
	exec dbo.spEDITVIEWS_InsertOnly             'Users.EditICloudOptions', 'Users', 'vwUSERS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Users.EditICloudOptions',  0, 'Users.LBL_ICLOUD_SYNC_CONTACTS', 'ICLOUD_SYNC_CONTACTS'      , 0, 10, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Users.EditICloudOptions',  1, 'Users.LBL_ICLOUD_SYNC_CALENDAR', 'ICLOUD_SYNC_CALENDAR'      , 0, 10, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Users.EditICloudOptions',  2, 'Users.LBL_ICLOUD_USERNAME'     , 'ICLOUD_USERNAME'           , 0, 10, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsPassword     'Users.EditICloudOptions',  3, 'Users.LBL_ICLOUD_PASSWORD'     , 'ICLOUD_PASSWORD'           , 0, 10, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Users.EditICloudOptions',  4, 'Users.LBL_ICLOUD_SECURITY_CODE', 'ICLOUD_SECURITY_CODE'      , 0, 10, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'Users.EditICloudOptions',  5, null;
end else begin
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Users.EditICloudOptions' and DATA_FIELD = 'ICLOUD_SECURITY_CODE' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsBound        'Users.EditICloudOptions',  4, 'Users.LBL_ICLOUD_SECURITY_CODE', 'ICLOUD_SECURITY_CODE'      , 0, 10, 100, 35, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBlank        'Users.EditICloudOptions',  5, null;
	end -- if;
end -- if;
GO

-- 12/10/2007 Paul.  Removed references to TestCases, TestPlans and TestRuns.


-- 06/03/2006 Paul.  Add support for Contracts. 
-- 11/30/2007 Paul.  Change TYPE to unique identifier and rename to TYPE_ID. 
-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 12/12/2022 Paul.  React requires currency fields to have currency data format. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Contracts.EditView', 'Contracts', 'vwCONTRACTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView'      ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                        , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView'      ,  1, 'Contracts.LBL_STATUS'                   , 'STATUS'                      , 1, 2, 'contract_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView'      ,  2, 'Contracts.LBL_REFERENCE_CODE'           , 'REFERENCE_CODE'              , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView'      ,  3, 'Contracts.LBL_START_DATE'               , 'START_DATE'                  , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView'      ,  4, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                  , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView'      ,  5, 'Contracts.LBL_END_DATE'                 , 'END_DATE'                    , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView'      ,  6, 'Contracts.LBL_OPPORTUNITY_NAME'         , 'OPPORTUNITY_ID'              , 0, 1, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView'      ,  7, 'Contracts.LBL_CURRENCY'                 , 'CURRENCY_ID'                 , 0, 2, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView'      ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                     , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Contracts.EditView'      ,  9, 'Contracts.LBL_CONTRACT_VALUE'           , 'TOTAL_CONTRACT_VALUE'        , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Contracts.EditView'      , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'            , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView'      , 11, 'Contracts.LBL_COMPANY_SIGNED_DATE'      , 'COMPANY_SIGNED_DATE'         , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView'      , 12, 'Contracts.LBL_EXPIRATION_NOTICE'        , 'EXPIRATION_NOTICE'           , 0, 1, 'DateTimeEdit'       , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Contracts.EditView'      , 13, 'Contracts.LBL_CUSTOMER_SIGNED_DATE'     , 'CUSTOMER_SIGNED_DATE'        , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Contracts.EditView'      , 14, 'Contracts.LBL_TYPE'                     , 'TYPE_ID'                     , 0, 2, 'ContractTypes'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Contracts.EditView'      , 15, 1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Contracts.EditView'      , 16, 'Contracts.LBL_DESCRIPTION'              , 'DESCRIPTION'                 , 0, 3,   8, 80, 3;

	-- 12/12/2022 Paul.  React requires currency fields to have currency data format. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Contracts.EditView', 'TOTAL_CONTRACT_VALUE', '{0:c}';
end else begin
	-- 08/24/2009 Paul.  Keep the old conversion and let the field be fixed during the TEAMS Update. 
	exec dbo.spEDITVIEWS_FIELDS_CnvChange      'Contracts.EditView'      ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                     , 0, 1, 'TEAM_NAME'          , null, null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Contracts.EditView'      ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                     , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Contracts.EditView'      , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'            , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users'   , null;
	-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Contracts.EditView'      ,  4, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                  , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Contracts.EditView'      ,  6, 'Contracts.LBL_OPPORTUNITY_NAME'         , 'OPPORTUNITY_ID'              , 0, 1, 'OPPORTUNITY_NAME'   , 'Opportunities', null;

	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView' and DATA_FIELD = 'TYPE' and DELETED = 0) begin -- then
		print 'Fix Contracts.EditView TYPE_ID';
		update EDITVIEWS_FIELDS
		   set DATA_FIELD       = 'TYPE_ID'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'Contracts.EditView'
		   and DATA_FIELD       = 'TYPE'
		   and DELETED          = 0;
	end -- if;
	-- 05/12/2016 Paul.  Add Tags module. 
	exec dbo.spEDITVIEWS_FIELDS_CnvTagSelect   'Contracts.EditView' , 15, 1, null;

	-- 12/12/2022 Paul.  React requires currency fields to have currency data format. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.EditView' and DATA_FIELD = 'TOTAL_CONTRACT_VALUE' and DATA_FORMAT is null and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FORMAT       = '{0:c}'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Contracts.EditView'
		   and DATA_FIELD        = 'TOTAL_CONTRACT_VALUE'
		   and DATA_FORMAT       is null
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 06/03/2006 Paul.  Add support for Products. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.EditView'
-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
-- 05/01/2013 Paul.  Convert the ChangeButton to a ModulePopup. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Products.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Products.EditView', 'Products', 'vwPRODUCTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.EditView'       ,  0, 'Products.LBL_NAME'                      , 'PRODUCT_TEMPLATE_ID'        , 1, 1, 'NAME'               , 'ProductCatalog', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.EditView'       ,  1, 'Products.LBL_STATUS'                    , 'STATUS'                     , 1, 2, 'product_status_dom' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.EditView'       ,  2, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.EditView'       ,  3, 'Contracts.LBL_CONTACT_NAME'             , 'CONTACT_ID'                 , 1, 2, 'CONTACT_NAME'       , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.EditView'       ,  4, 'Products.LBL_QUANTITY'                  , 'QUANTITY'                   , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.EditView'       ,  5, 'Products.LBL_DATE_PURCHASED'            , 'DATE_PURCHASED'             , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.EditView'       ,  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.EditView'       ,  7, 'Products.LBL_DATE_SUPPORT_STARTS'       , 'DATE_SUPPORT_STARTS'        , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.EditView'       ,  8, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.EditView'       ,  9, 'Products.LBL_DATE_SUPPORT_EXPIRES'      , 'DATE_SUPPORT_EXPIRES'       , 0, 2, 'DatePicker'         , null, null, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Products.EditView'       ,  0, 'Products.LBL_NAME'                      , 'PRODUCT_TEMPLATE_ID'        , 1, 1, 'NAME'               , 'ProductCatalog', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Products.EditView'       ,  2, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 1, 1, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Products.EditView'       ,  3, 'Contracts.LBL_CONTACT_NAME'             , 'CONTACT_ID'                 , 1, 2, 'CONTACT_NAME'       , 'Contacts', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.CostView' and DELETED = 0) begin -- then
	exec dbo.spEDITVIEWS_InsertOnly            'Products.CostView', 'Products', 'vwPRODUCTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.CostView'       ,  0, 'Products.LBL_CURRENCY'                  , 'CURRENCY_ID'                , 1, 1, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.CostView'       ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.CostView'       ,  2, 'Products.LBL_COST_PRICE'                , 'COST_PRICE'                 , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.CostView'       ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.CostView'       ,  4, 'Products.LBL_LIST_PRICE'                , 'LIST_PRICE'                 , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.CostView'       ,  5, 'Products.LBL_BOOK_VALUE'                , 'BOOK_VALUE'                 , 1, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.CostView'       ,  6, 'Products.LBL_DISCOUNT_PRICE'            , 'DISCOUNT_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Products.CostView'       ,  7, 'Products.LBL_BOOK_VALUE_DATE'           , 'BOOK_VALUE_DATE'            , 0, 2, 'DatePicker'         , null, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.EditView'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.MftView' and DELETED = 0) begin -- then
	exec dbo.spEDITVIEWS_InsertOnly            'Products.MftView', 'Products', 'vwPRODUCTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView'        ,  0, 'Products.LBL_WEBSITE'                   , 'WEBSITE'                    , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.MftView'        ,  1, 'Products.LBL_TAX_CLASS'                 , 'TAX_CLASS'                  , 0, 2, 'tax_class_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.MftView'        ,  2, 'Products.LBL_MANUFACTURER'              , 'MANUFACTURER_ID'            , 0, 1, 'Manufacturers'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView'        ,  3, 'Products.LBL_WEIGHT'                    , 'WEIGHT'                     , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView'        ,  4, 'Products.LBL_MFT_PART_NUM'              , 'MFT_PART_NUM'               , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Products.MftView'        ,  5, 'Products.LBL_CATEGORY'                  , 'CATEGORY_ID'                , 1, 2, 'CATEGORY_NAME'     , 'ProductCategories', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView'        ,  6, 'Products.LBL_VENDOR_PART_NUM'           , 'VENDOR_PART_NUM'            , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.MftView'        ,  7, 'Products.LBL_TYPE'                      , 'TYPE_ID'                    , 0, 2, 'ProductTypes'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView'        ,  8, 'Products.LBL_SERIAL_NUMBER'             , 'SERIAL_NUMBER'              , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.MftView'        ,  9, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView'        , 10, 'Products.LBL_ASSET_NUMBER'              , 'ASSET_NUMBER'               , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.MftView'        , 11, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Products.MftView'        , 12, 'Products.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 1,   8, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.MftView'        , 13, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Products.MftView'        , 14, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView'        , 15, 'Products.LBL_SUPPORT_NAME'              , 'SUPPORT_NAME'               , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView'        , 16, 'Products.LBL_SUPPORT_CONTACT'           , 'SUPPORT_CONTACT'            , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Products.MftView'        , 17, 'Products.LBL_SUPPORT_DESCRIPTION'       , 'SUPPORT_DESCRIPTION'        , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Products.MftView'        , 18, 'Products.LBL_SUPPORT_TERM'              , 'SUPPORT_TERM'               , 0, 2, 'support_term_dom'   , null, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Products.MftView'        ,  5, 'Products.LBL_CATEGORY'                  , 'CATEGORY_ID'                , 1, 2, 'CATEGORY_NAME'     , 'ProductCategories', null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView';
-- 02/03/2009 Paul.  Add TEAM_ID for team management. 
-- 07/10/2010 Paul.  Add Options fields. 
-- 05/21/2012 Paul.  Add QUICKBOOKS_ACCOUNT to support QuickBooks sync. 
-- 10/21/2015 Paul.  Add min and max order fields for published data. 
-- 12/12/2022 Paul.  React requires currency fields to have currency data format. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTemplates.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'ProductTemplates.EditView', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' ,  0, 'ProductTemplates.LBL_NAME'                , 'NAME'                   , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView' ,  1, 'ProductTemplates.LBL_STATUS'              , 'STATUS'                 , 1, 2, 'product_template_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ProductTemplates.EditView' ,  2, 'ProductTemplates.LBL_CATEGORY'            , 'CATEGORY_ID'            , 1, 1, 'CATEGORY_NAME'      , 'ProductCategories', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ProductTemplates.EditView' ,  3, 'Teams.LBL_TEAM'                           , 'TEAM_ID'                , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' ,  4, 'ProductTemplates.LBL_WEBSITE'             , 'WEBSITE'                , 0, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'ProductTemplates.EditView' ,  5, 'ProductTemplates.LBL_DATE_AVAILABLE'      , 'DATE_AVAILABLE'         , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView' ,  6, 'ProductTemplates.LBL_TAX_CLASS'           , 'TAX_CLASS'              , 0, 1, 'tax_class_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' ,  7, 'ProductTemplates.LBL_QUANTITY'            , 'QUANTITY'               , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' ,  8, 'ProductTemplates.LBL_MINIMUM_QUANTITY'    , 'MINIMUM_QUANTITY'       , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' ,  9, 'ProductTemplates.LBL_MAXIMUM_QUANTITY'    , 'MAXIMUM_QUANTITY'       , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView' , 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 11, 'ProductTemplates.LBL_LIST_ORDER'          , 'LIST_ORDER'             , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView' , 12, 'ProductTemplates.LBL_MANUFACTURER'        , 'MANUFACTURER_ID'        , 0, 1, 'Manufacturers'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 13, 'ProductTemplates.LBL_WEIGHT'              , 'WEIGHT'                 , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 14, 'ProductTemplates.LBL_MFT_PART_NUM'        , 'MFT_PART_NUM'           , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 15, 'ProductTemplates.LBL_QUICKBOOKS_ACCOUNT'  , 'QUICKBOOKS_ACCOUNT'     , 0, 2,  31, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 16, 'ProductTemplates.LBL_VENDOR_PART_NUM'     , 'VENDOR_PART_NUM'        , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView' , 17, 'ProductTemplates.LBL_TYPE'                , 'TYPE_ID'                , 0, 2, 'ProductTypes'       , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 18, 'ProductTemplates.LBL_MINIMUM_OPTIONS'     , 'MINIMUM_OPTIONS'        , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 19, 'ProductTemplates.LBL_MAXIMUM_OPTIONS'     , 'MAXIMUM_OPTIONS'        , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView' , 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView' , 21, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView' , 22, 'ProductTemplates.LBL_CURRENCY'            , 'CURRENCY_ID'            , 1, 1, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 23, 'ProductTemplates.LBL_SUPPORT_NAME'        , 'SUPPORT_NAME'           , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 24, 'ProductTemplates.LBL_COST_PRICE'          , 'COST_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 25, 'ProductTemplates.LBL_SUPPORT_CONTACT'     , 'SUPPORT_CONTACT'        , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 26, 'ProductTemplates.LBL_LIST_PRICE'          , 'LIST_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 27, 'ProductTemplates.LBL_SUPPORT_DESCRIPTION' , 'SUPPORT_DESCRIPTION'    , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 28, 'ProductTemplates.LBL_DISCOUNT_PRICE'      , 'DISCOUNT_PRICE'         , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView' , 29, 'ProductTemplates.LBL_SUPPORT_TERM'        , 'SUPPORT_TERM'           , 0, 2, 'support_term_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ProductTemplates.EditView' , 30, 'ProductTemplates.LBL_DISCOUNT_NAME'       , 'DISCOUNT_ID'            , 0, 1, 'DISCOUNT_NAME'      , 'Discounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView' , 31, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView' , 32, 'ProductTemplates.LBL_PRICING_FORMULA'     , 'PRICING_FORMULA'        , 0, 2, 'pricing_formula_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 33, 'ProductTemplates.LBL_PRICING_FACTOR'      , 'PRICING_FACTOR'         , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'ProductTemplates.EditView' , 34, 'ProductTemplates.LBL_DESCRIPTION'         , 'DESCRIPTION'            , 0, 3,   8, 80, 3;
	-- 08/15/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'ProductTemplates.EditView', 'DISCOUNT_ID' , '1';

	-- 12/12/2022 Paul.  React requires currency fields to have currency data format. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'ProductTemplates.EditView', 'COST_PRICE'    , '{0:c}';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'ProductTemplates.EditView', 'LIST_PRICE'    , '{0:c}';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'ProductTemplates.EditView', 'DISCOUNT_PRICE', '{0:c}';
end else begin
	-- 08/24/2009 Paul.  Keep the old conversion and let the field be fixed during the TEAMS Update. 
	exec dbo.spEDITVIEWS_FIELDS_CnvChange      'ProductTemplates.EditView' ,  3, 'Teams.LBL_TEAM'                           , 'TEAM_ID'                , 0, 2, 'TEAM_NAME'          , null, null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'ProductTemplates.EditView' ,  3, 'Teams.LBL_TEAM'                           , 'TEAM_ID'                , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'ProductTemplates.EditView' ,  2, 'ProductTemplates.LBL_CATEGORY'            , 'CATEGORY_ID'            , 1, 1, 'CATEGORY_NAME'      , 'ProductCategories', null;
	-- 05/21/2012 Paul.  Add QUICKBOOKS_ACCOUNT to support QuickBooks sync. 
	exec dbo.spEDITVIEWS_FIELDS_CnvBound       'ProductTemplates.EditView' , 13, 'ProductTemplates.LBL_QUICKBOOKS_ACCOUNT'  , 'QUICKBOOKS_ACCOUNT'     , 0, 2,  31, 35, null;
	
	-- 07/10/2010 Paul.  Add Options fields. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView' and DATA_FIELD = 'MINIMUM_OPTIONS' and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS ProductTemplates.EditView: Add options fields.';
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'ProductTemplates.EditView'
		   and FIELD_INDEX      >= 16
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 16, 'ProductTemplates.LBL_MINIMUM_OPTIONS'     , 'MINIMUM_OPTIONS'        , 0, 1,  25, 15, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 17, 'ProductTemplates.LBL_MAXIMUM_OPTIONS'     , 'MAXIMUM_OPTIONS'        , 0, 2,  25, 15, null;
	end -- if;
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView' and DATA_FIELD = 'DISCOUNT_ID' and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS ProductTemplates.EditView: Change PRICING_FORMULA to DISCOUNT.';
		update EDITVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'ProductTemplates.EditView'
		   and DATA_FIELD        = 'PRICING_FORMULA'
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ProductTemplates.EditView' , 28, 'ProductTemplates.LBL_DISCOUNT_NAME'       , 'DISCOUNT_ID'            , 0, 1, 'DISCOUNT_NAME'      , 'Discounts', null;
		-- 08/15/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'ProductTemplates.EditView', 'DISCOUNT_ID' , '1';
	end -- if;
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView' and DATA_FIELD = 'PRICING_FORMULA' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'ProductTemplates.EditView'
		   and FIELD_TYPE        = 'Blank'
		   and FIELD_INDEX      in (30, 31)
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ProductTemplates.EditView' , 30, 'ProductTemplates.LBL_PRICING_FORMULA'     , 'PRICING_FORMULA'        , 0, 2, 'pricing_formula_dom', null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 31, 'ProductTemplates.LBL_PRICING_FACTOR'      , 'PRICING_FACTOR'         , 0, 1,  25, 15, null;
		-- 08/15/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'ProductTemplates.EditView', 'DISCOUNT_ID' , '1';
	end -- if;
	-- 10/21/2015 Paul.  Add min and max order fields for published data. 
	exec dbo.spEDITVIEWS_FIELDS_CnvBound       'ProductTemplates.EditView' ,  8, 'ProductTemplates.LBL_MINIMUM_QUANTITY'    , 'MINIMUM_QUANTITY'       , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_CnvBound       'ProductTemplates.EditView' ,  9, 'ProductTemplates.LBL_MAXIMUM_QUANTITY'    , 'MAXIMUM_QUANTITY'       , 0, 2,  25, 15, null;
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView' and DATA_FIELD = 'LIST_ORDER' and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS ProductTemplates.EditView: Add publishing fields.';
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'ProductTemplates.EditView'
		   and FIELD_INDEX      >= 10
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductTemplates.EditView' , 10, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTemplates.EditView' , 11, 'ProductTemplates.LBL_LIST_ORDER'          , 'LIST_ORDER'             , 0, 1,  25, 15, null;
	end -- if;

	-- 12/12/2022 Paul.  React requires currency fields to have currency data format. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.EditView' and DATA_FIELD in ('COST_PRICE', 'LIST_PRICE', 'DISCOUNT_PRICE') and DATA_FORMAT is null and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FORMAT       = '{0:c}'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'ProductTemplates.EditView'
		   and DATA_FIELD        in ('COST_PRICE', 'LIST_PRICE', 'DISCOUNT_PRICE')
		   and DATA_FORMAT       is null
		   and DELETED           = 0;
	end -- if;
end -- if;
GO


-- 06/07/2006 Paul.  Add support for Quotes. 
-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
-- 10/06/2010 Paul.  Size of NAME field was increased to 150. 
-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- 04/13/2016 Paul.  Add ZipCode lookup. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 10/31/2019 Paul.  Add Billing and Shipping titles to new layout. Was previously only on modified layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditView', 'Quotes', 'vwQUOTES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView'         ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditView'         ,  2, 'Quotes.LBL_QUOTE_NUM'                   , 'QUOTE_NUM'                  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView'         ,  3, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 1, 2, 'quote_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView'         ,  4, 'Quotes.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView'         ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'            , 'DATE_QUOTE_EXPECTED_CLOSED' , 1, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Quotes.EditView'         ,  6, 'Quotes.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView'         ,  7, 'Quotes.LBL_ORIGINAL_PO_DATE'            , 'ORIGINAL_PO_DATE'           , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView'         ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Quotes.EditView'         ,  9, 1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView'         , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditView'         , 11, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Quotes.EditView'         , 12;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Quotes.EditView'         , 13, 'Invoices.LBL_BILLING_TITLE' , 3;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Quotes.EditView'         , 14, 'Invoices.LBL_SHIPPING_TITLE', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView'         , 15, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditView'         , 16, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView'         , 17, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView'         , 18, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditView'         , 19, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditView'         , 20, 'Quotes.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditView'         , 21, 'Quotes.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView'         , 22, 'Quotes.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView'         , 23, 'Quotes.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView'         , 24, 'Quotes.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView'         , 25, 'Quotes.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Quotes.EditView'         , 26, 'Quotes.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Quotes.EditView'         , 27, 'Quotes.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView'         , 28, 'Quotes.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditView'         , 29, 'Quotes.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditView', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditView', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditView', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	-- 08/24/2009 Paul.  Keep the old conversion and let the field be fixed during the TEAMS Update. 
	exec dbo.spEDITVIEWS_FIELDS_CnvChange      'Quotes.EditView'         ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , null, null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditView'         ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditView'         , 10, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditView'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditAddress'      ,  0, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditAddress'      ,  2, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditAddress'      ,  3, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditAddress'      ,  4, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'BILLING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'BILLING_ACCOUNT_ID' , '1';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'SHIPPING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'SHIPPING_ACCOUNT_ID', '1';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Quotes.EditAddress', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Quotes.EditAddress', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'BILLING_CONTACT_ID' , '1,1';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'SHIPPING_CONTACT_ID', '1,1';
		end -- if;
		exec dbo.spEDITVIEWS_FIELDS_MergeView      'Quotes.EditView', 'Quotes.EditAddress', 'Quotes.LBL_BILLING_TITLE', 'Quotes.LBL_SHIPPING_TITLE';
	end -- if;
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditView' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Quotes.EditView'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Quotes.EditView', 'BILLING_ADDRESS_POSTALCODE';
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Quotes.EditView', 'SHIPPING_ADDRESS_POSTALCODE';
	-- 05/12/2016 Paul.  Add Tags module. 
	exec dbo.spEDITVIEWS_FIELDS_CnvTagSelect   'Quotes.EditView' ,  9, 1, null;
end -- if;
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
/*
-- select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DEFAULT_VIEW = 0 and DELETED = 0 order by FIELD_INDEX
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditAddress';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditAddress', 'Quotes', 'vwQUOTES_Edit', '15%', '30%', null;
	-- 08/29/2009 Paul.  Don't convert the ChangeButton to a ModulePopup. 
	-- 07/27/2010 Paul.  Convert to a ModulePopup so that Account and Contacts will get auto-complete. The DataFormat plus the onclient script will solve the previous problem. 
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditAddress'      ,  0, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Quotes.EditAddress'      ,  1, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditAddress'      ,  2, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditAddress'      ,  3, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Quotes.EditAddress'      ,  4, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditAddress'      ,  5, 'Quotes.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditAddress'      ,  6, 'Quotes.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress'      ,  7, 'Quotes.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress'      ,  8, 'Quotes.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress'      ,  9, 'Quotes.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress'      , 10, 'Quotes.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress'      , 11, 'Quotes.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress'      , 12, 'Quotes.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress'      , 13, 'Quotes.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditAddress'      , 14, 'Quotes.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditAddress', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Quotes.EditAddress', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditAddress'      ,  0, 'Quotes.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditAddress'      ,  2, 'Quotes.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditAddress'      ,  3, 'Quotes.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Quotes.EditAddress'      ,  4, 'Quotes.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'BILLING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'BILLING_ACCOUNT_ID' , '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'SHIPPING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'SHIPPING_ACCOUNT_ID', '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Quotes.EditAddress', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Quotes.EditAddress', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	end -- if;
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'BILLING_CONTACT_ID' , '1,1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Quotes.EditAddress', 'SHIPPING_CONTACT_ID', '1,1';
	end -- if;
end -- if;
*/
GO

/*
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditSummary' and DELETED = 0;
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditSummary' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditSummary';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditSummary', 'Quotes', 'vwQUOTES_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditSummary'      ,  0, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditSummary'      ,  1, 'Quotes.LBL_SUBTOTAL'                    , 'SUBTOTAL'                   , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditSummary'      ,  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditSummary'      ,  3, 'Quotes.LBL_DISCOUNT'                    , 'DISCOUNT'                   , 0, 5, 10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditSummary'      ,  4, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Quotes.EditSummary'      ,  5, 'Quotes.LBL_SHIPPING'                    , 'SHIPPING'                   , 0, 5, 10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditSummary'      ,  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditSummary'      ,  7, 'Quotes.LBL_TAX'                         , 'TAX'                        , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Quotes.EditSummary'      ,  8, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Quotes.EditSummary'      ,  9, 'Quotes.LBL_TOTAL'                       , 'TOTAL'                      , null;

end -- if;
*/
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.EditDescription' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.EditDescription';
	exec dbo.spEDITVIEWS_InsertOnly            'Quotes.EditDescription', 'Quotes', 'vwQUOTES_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Quotes.EditDescription'  ,  0, 'Quotes.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
end -- if;
GO

-- 06/20/2020 Paul.  React Client uses a dynamic layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'QuotesLineItems.LineItems';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'QuotesLineItems.LineItems' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS QuotesLineItems.LineItems';
	exec dbo.spEDITVIEWS_InsertOnly             'QuotesLineItems.LineItems', 'QuotesLineItems', 'vwQUOTES_LINE_ITEMS_Edit', '15%', '35', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'QuotesLineItems.LineItems',  0, 'Quotes.LBL_LIST_ITEM_QUANTITY'      , 'QUANTITY'               , 1, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'QuotesLineItems.LineItems',  1, 'Quotes.LBL_LIST_ITEM_NAME'          , 'PRODUCT_TEMPLATE_ID'    , 0, 1, 'PRODUCT_TEMPLATE_NAME'        , 'ProductCatalog', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine    'QuotesLineItems.LineItems',  2, 'Quotes.LBL_LIST_DESCRIPTION'        , 'DESCRIPTION'            , 0, 1,   3, 80, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'QuotesLineItems.LineItems',  3, 'Quotes.LBL_LIST_ITEM_MFT_PART_NUM'  , 'MFT_PART_NUM'           , 0, null, 50, 20, 'ProductPartNumbers', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'QuotesLineItems.LineItems',  4, 'Quotes.LBL_LIST_ITEM_TAX_CLASS'     , 'TAX_CLASS'              , 1, 1, 'tax_class_dom'                , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'QuotesLineItems.LineItems',  5, 'Quotes.LBL_LIST_ITEM_TAX_RATE'      , 'TAXRATE_ID'             , 0, 1, 'TaxRates'                     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'QuotesLineItems.LineItems',  6, 'Quotes.LBL_LIST_ITEM_COST_PRICE'    , 'COST_PRICE'             , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'QuotesLineItems.LineItems',  7, 'Quotes.LBL_LIST_ITEM_LIST_PRICE'    , 'LIST_PRICE'             , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'QuotesLineItems.LineItems',  8, 'Quotes.LBL_LIST_ITEM_UNIT_PRICE'    , 'UNIT_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'QuotesLineItems.LineItems',  9, 'Quotes.LBL_LIST_ITEM_EXTENDED_PRICE', 'EXTENDED_PRICE'         , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'QuotesLineItems.LineItems', 10, 'Quotes.LBL_LIST_ITEM_TAX'           , 'TAX'                    , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'QuotesLineItems.LineItems', 11, null                                 , 'DISCOUNT_ID'            , 0, 1, 'Discounts'                    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'QuotesLineItems.LineItems', 12, null                                 , 'PRICING_FORMULA'        , 0, 1, 'pricing_formula_line_items'   , -1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'QuotesLineItems.LineItems', 13, null                                 , 'PRICING_FACTOR'         , 0, 1,  25, 10, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'QuotesLineItems.LineItems', 14, 'Quotes.LBL_LIST_ITEM_DISCOUNT_NAME' , 'DISCOUNT_PRICE'         , 0, 1,  25, 15, null;
end -- if;
GO

-- 10/15/2006 Paul.  Add support for Teams. 
-- 04/12/2016 Paul.  Add parent team and custom fields. 
-- 04/28/2016 Paul.  Rename parent to PARENT_ID. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.EditView'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Teams.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Teams.EditView', 'Teams', 'vwTEAMS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Teams.EditView'          ,  0, 'Teams.LBL_NAME'                         , 'NAME'                       , 1, 1, 128, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Teams.EditView'          ,  1, 'Teams.LBL_PARENT_NAME'                  , 'PARENT_ID'                  , 0, 1, 'PARENT_NAME', 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Teams.EditView'          ,  2, 'Teams.LBL_DESCRIPTION'                  , 'DESCRIPTION'                , 0, 2,   4, 60, null;
end else begin
	-- 04/12/2016 Paul.  Add parent team and custom fields. 
	-- 04/28/2016 Paul.  Rename parent to PARENT_ID. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.EditView' and DATA_FIELD = 'PARENT_TEAM_ID' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FIELD        = 'PARENT_ID'
		     , DISPLAY_FIELD     = 'PARENT_NAME'
		     , DATA_LABEL        = 'Teams.LBL_PARENT_NAME'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Teams.EditView'
		   and DATA_FIELD        = 'PARENT_TEAM_ID'
		   and DELETED           = 0;
	end -- if;
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.EditView' and DATA_FIELD = 'PARENT_ID' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Teams.EditView'
		   and FIELD_TYPE        = 'Blank'
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Teams.EditView'          ,  1, 'Teams.LBL_PARENT_NAME'                  , 'PARENT_ID'                  , 0, 1, 'PARENT_NAME', 'Teams', null;
	end -- if;
	-- 05/11/2016 Paul.  Correct field width to support parent. 
	if exists(select * from EDITVIEWS where NAME = 'Teams.EditView' and FIELD_WIDTH = '85%' and DELETED = 0) begin -- then
		update EDITVIEWS
		   set FIELD_WIDTH       = '35%'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where NAME              = 'Teams.EditView'
		   and FIELD_WIDTH       = '85%'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 10/15/2006 Paul.  Add support for Team Notices. 
-- 05/01/2013 Paul.  Convert from Change to ModulePopup. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'TeamNotices.EditView'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TeamNotices.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS TeamNotices.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'TeamNotices.EditView'   , 'TeamNotices'   , 'vwTEAM_NOTICES_Edit'  , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'TeamNotices.EditView'    ,  0, 'TeamNotices.LBL_DATE_START'             , 'DATE_START'                 , 1, 1, 'DatePicker'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'TeamNotices.EditView'    ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 1, 2, 'TEAM_NAME'             , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'TeamNotices.EditView'    ,  2, 'TeamNotices.LBL_DATE_END'               , 'DATE_END'                   , 1, 1, 'DatePicker'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'TeamNotices.EditView'    ,  3, 'TeamNotices.LBL_STATUS'                 , 'STATUS'                     , 1, 2, 'team_notice_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TeamNotices.EditView'    ,  4, 'TeamNotices.LBL_NAME'                   , 'NAME'                       , 1, 1,  50, 70, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'TeamNotices.EditView'    ,  5, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'TeamNotices.EditView'    ,  6, 'TeamNotices.LBL_DESCRIPTION'            , 'DESCRIPTION'                , 0, 1,   8, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'TeamNotices.EditView'    ,  7, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TeamNotices.EditView'    ,  8, 'TeamNotices.LBL_URL_TITLE'              , 'URL_TITLE'                  , 0, 1, 255, 70, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'TeamNotices.EditView'    ,  9, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TeamNotices.EditView'    , 10, 'TeamNotices.LBL_URL'                    , 'URL'                        , 0, 1, 255, 70, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'TeamNotices.EditView'    , 11, null;
end else begin
	-- 05/01/2013 Paul.  Convert from Change to ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'TeamNotices.EditView'    ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 1, 2, 'TEAM_NAME'             , 'Teams', null;
end -- if;
GO

-- 04/03/2007 Paul.  Add Orders module. 
-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
-- 10/06/2010 Paul.  Size of NAME field was increased to 150. 
-- 03/05/2011 Paul.  There is no compelling reason to require Date Order Shipped. 
-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- 04/13/2016 Paul.  Add ZipCode lookup. 
-- 10/31/2019 Paul.  Add Billing and Shipping titles to new layout. Was previously only on modified layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView'
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditView', 'Orders', 'vwORDERS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView'         ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Orders.EditView'         ,  2, 'Orders.LBL_ORDER_NUM'                   , 'ORDER_NUM'                  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView'         ,  3, 'Orders.LBL_ORDER_STAGE'                 , 'ORDER_STAGE'                , 1, 2, 'order_stage_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView'         ,  4, 'Orders.LBL_PURCHASE_ORDER_NUM'          , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView'         ,  5, 'Orders.LBL_DATE_ORDER_DUE'              , 'DATE_ORDER_DUE'             , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Orders.EditView'         ,  6, 'Orders.LBL_PAYMENT_TERMS'               , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView'         ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'          , 'DATE_ORDER_SHIPPED'         , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView'         ,  8, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView'         ,  9, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Orders.EditView'         , 10, 1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditView'         , 11, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Orders.EditView'         , 12;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Orders.EditView'         , 13, 'Orders.LBL_BILLING_TITLE' , 3;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Orders.EditView'         , 14, 'Orders.LBL_SHIPPING_TITLE', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView'         , 15, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Orders.EditView'         , 16, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView'         , 17, 'Orders.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView'         , 18, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Orders.EditView'         , 19, 'Orders.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditView'         , 20, 'Orders.LBL_STREET'                      , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditView'         , 21, 'Orders.LBL_STREET'                      , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView'         , 22, 'Orders.LBL_CITY'                        , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView'         , 23, 'Orders.LBL_CITY'                        , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView'         , 24, 'Orders.LBL_STATE'                       , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView'         , 25, 'Orders.LBL_STATE'                       , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Orders.EditView'         , 26, 'Orders.LBL_POSTAL_CODE'                 , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Orders.EditView'         , 27, 'Orders.LBL_POSTAL_CODE'                 , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView'         , 28, 'Orders.LBL_COUNTRY'                     , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditView'         , 29, 'Orders.LBL_COUNTRY'                     , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Orders.EditView', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Orders.EditView', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditView', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditView'         ,  1, 'Quotes.LBL_OPPORTUNITY_NAME'            , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditView'         ,  8, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditAddress' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditAddress'      ,  0, 'Orders.LBL_ACCOUNT'                     , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditAddress'      ,  2, 'Orders.LBL_ACCOUNT'                     , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditAddress'      ,  3, 'Orders.LBL_CONTACT'                     , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Orders.EditAddress'      ,  4, 'Orders.LBL_CONTACT'                     , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditAddress' and DATA_FIELD = 'BILLING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditAddress', 'BILLING_ACCOUNT_ID' , '1';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditAddress' and DATA_FIELD = 'SHIPPING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditAddress', 'SHIPPING_ACCOUNT_ID', '1';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Orders.EditAddress', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Orders.EditAddress', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditAddress', 'BILLING_CONTACT_ID' , '1,1';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Orders.EditAddress', 'SHIPPING_CONTACT_ID', '1,1';
		end -- if;
		exec dbo.spEDITVIEWS_FIELDS_MergeView      'Orders.EditView', 'Orders.EditAddress', 'Orders.LBL_BILLING_TITLE', 'Orders.LBL_SHIPPING_TITLE';
	end -- if;
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Orders.EditView'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Orders.EditView', 'BILLING_ADDRESS_POSTALCODE';
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Orders.EditView', 'SHIPPING_ADDRESS_POSTALCODE';
	-- 05/12/2016 Paul.  Add Tags module. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditView' and DATA_FIELD = 'TAG_SET_NAME' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where EDIT_NAME         = 'Orders.EditView'
		   and FIELD_INDEX      >= 10
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Orders.EditView'          , 10, 1, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditView'          , 11, null;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditDescription' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditDescription';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditDescription', 'Orders', 'vwORDERS_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Orders.EditDescription'  ,  0, 'Orders.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
end -- if;
GO

/*
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditSummary' and DELETED = 0;
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.EditSummary' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.EditSummary';
	exec dbo.spEDITVIEWS_InsertOnly            'Orders.EditSummary', 'Orders', 'vwORDERS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditSummary'      ,  0, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Orders.EditSummary'      ,  1, 'Orders.LBL_SUBTOTAL'                    , 'SUBTOTAL'                   , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditSummary'      ,  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditSummary'      ,  3, 'Orders.LBL_DISCOUNT'                    , 'DISCOUNT'                   , 0, 5, 10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditSummary'      ,  4, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Orders.EditSummary'      ,  5, 'Orders.LBL_SHIPPING'                    , 'SHIPPING'                   , 0, 5, 10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditSummary'      ,  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Orders.EditSummary'      ,  7, 'Orders.LBL_TAX'                         , 'TAX'                        , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Orders.EditSummary'      ,  8, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Orders.EditSummary'      ,  9, 'Orders.LBL_TOTAL'                       , 'TOTAL'                      , null;

end -- if;
*/
GO

-- 05/21/2009 Paul.  Added serial number and support fields. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'OrdersLineItems.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'OrdersLineItems.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS OrdersLineItems.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'OrdersLineItems.EditView', 'OrdersLineItems', 'vwORDERS_LINE_ITEMS_Detail', '15%', '35', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView',  0, 'Orders.LBL_NAME'                  , 'NAME'                   , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'OrdersLineItems.EditView',  1, 'Orders.LBL_TAX_CLASS'             , 'TAX_CLASS'              , 0, 1, 'tax_class_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView',  2, 'Orders.LBL_MFT_PART_NUM'          , 'MFT_PART_NUM'           , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView',  3, 'Orders.LBL_VENDOR_PART_NUM'       , 'VENDOR_PART_NUM'        , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView',  4, 'Orders.LBL_QUANTITY'              , 'QUANTITY'               , 0, 2,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView',  5, 'Orders.LBL_COST_PRICE'            , 'COST_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView',  6, 'Orders.LBL_LIST_PRICE'            , 'LIST_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView',  7, 'Orders.LBL_UNIT_PRICE'            , 'UNIT_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'OrdersLineItems.EditView',  8, 'Orders.LBL_DESCRIPTION'           , 'DESCRIPTION'            , 0, 3,   8, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'OrdersLineItems.EditView',  9, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'OrdersLineItems.EditView', 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView', 11, 'Products.LBL_SERIAL_NUMBER'       , 'SERIAL_NUMBER'          , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView', 12, 'Products.LBL_ASSET_NUMBER'        , 'ASSET_NUMBER'           , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'OrdersLineItems.EditView', 13, 'Orders.LBL_DATE_ORDER_SHIPPED'    , 'DATE_ORDER_SHIPPED'     , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'OrdersLineItems.EditView', 14, 'Products.LBL_DATE_SUPPORT_EXPIRES', 'DATE_SUPPORT_EXPIRES'   , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'OrdersLineItems.EditView', 15, 'Products.LBL_DATE_SUPPORT_STARTS' , 'DATE_SUPPORT_STARTS'    , 0, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView', 16, 'Products.LBL_SUPPORT_NAME'        , 'SUPPORT_NAME'           , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView', 17, 'Products.LBL_SUPPORT_CONTACT'     , 'SUPPORT_CONTACT'        , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'OrdersLineItems.EditView', 18, 'Products.LBL_SUPPORT_TERM'        , 'SUPPORT_TERM'           , 0, 1, 'support_term_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'OrdersLineItems.EditView', 19, 'Products.LBL_SUPPORT_DESCRIPTION' , 'SUPPORT_DESCRIPTION'    , 0, 3,   8, 80, 3;
end else begin
	-- 06/02/2009 Paul.  Fix OrdersLineItems.EditView to use vwORDERS_LINE_ITEMS_Detail.
	if exists(select * from EDITVIEWS where NAME = 'OrdersLineItems.EditView' and VIEW_NAME <> 'vwORDERS_LINE_ITEMS_Detail' and DELETED = 0) begin -- then
		print 'EDITVIEWS: Fix OrdersLineItems.EditView to use vwORDERS_LINE_ITEMS_Detail.';
		update EDITVIEWS
		   set VIEW_NAME =  'vwORDERS_LINE_ITEMS_Detail'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where NAME      =  'OrdersLineItems.EditView'
		   and VIEW_NAME <> 'vwORDERS_LINE_ITEMS_Detail'
		   and DELETED   = 0;
	end -- if;
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'OrdersLineItems.EditView' and DATA_FIELD = 'SERIAL_NUMBER' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsBlank       'OrdersLineItems.EditView',  9, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBlank       'OrdersLineItems.EditView', 10, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView', 11, 'Products.LBL_SERIAL_NUMBER'       , 'SERIAL_NUMBER'          , 0, 1,  50, 35, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView', 12, 'Products.LBL_ASSET_NUMBER'        , 'ASSET_NUMBER'           , 0, 1,  50, 35, null;
		exec dbo.spEDITVIEWS_FIELDS_InsControl     'OrdersLineItems.EditView', 13, 'Orders.LBL_DATE_ORDER_SHIPPED'    , 'DATE_ORDER_SHIPPED'     , 0, 1, 'DatePicker'         , null, null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsControl     'OrdersLineItems.EditView', 14, 'Products.LBL_DATE_SUPPORT_EXPIRES', 'DATE_SUPPORT_EXPIRES'   , 0, 1, 'DatePicker'         , null, null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsControl     'OrdersLineItems.EditView', 15, 'Products.LBL_DATE_SUPPORT_STARTS' , 'DATE_SUPPORT_STARTS'    , 0, 1, 'DatePicker'         , null, null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView', 16, 'Products.LBL_SUPPORT_NAME'        , 'SUPPORT_NAME'           , 0, 1,  50, 35, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'OrdersLineItems.EditView', 17, 'Products.LBL_SUPPORT_CONTACT'     , 'SUPPORT_CONTACT'        , 0, 1,  50, 35, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'OrdersLineItems.EditView', 18, 'Products.LBL_SUPPORT_TERM'        , 'SUPPORT_TERM'           , 0, 1, 'support_term_dom'   , null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'OrdersLineItems.EditView', 19, 'Products.LBL_SUPPORT_DESCRIPTION' , 'SUPPORT_DESCRIPTION'    , 0, 3,   8, 80, 3;
	end -- if;
end -- if;
GO

-- 06/20/2020 Paul.  React Client uses a dynamic layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'OrdersLineItems.LineItems';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'OrdersLineItems.LineItems' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS OrdersLineItems.LineItems';
	exec dbo.spEDITVIEWS_InsertOnly             'OrdersLineItems.LineItems', 'OrdersLineItems', 'vwORDERS_LINE_ITEMS_Edit', '15%', '35', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'OrdersLineItems.LineItems',  0, 'Orders.LBL_LIST_ITEM_QUANTITY'      , 'QUANTITY'               , 1, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'OrdersLineItems.LineItems',  1, 'Orders.LBL_LIST_ITEM_NAME'          , 'PRODUCT_TEMPLATE_ID'    , 0, 1, 'PRODUCT_TEMPLATE_NAME'        , 'ProductCatalog', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine    'OrdersLineItems.LineItems',  2, 'Orders.LBL_LIST_DESCRIPTION'        , 'DESCRIPTION'            , 0, 1,   3, 80, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'OrdersLineItems.LineItems',  3, 'Orders.LBL_LIST_ITEM_MFT_PART_NUM'  , 'MFT_PART_NUM'           , 0, null, 50, 20, 'ProductPartNumbers', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'OrdersLineItems.LineItems',  4, 'Orders.LBL_LIST_ITEM_TAX_CLASS'     , 'TAX_CLASS'              , 1, 1, 'tax_class_dom'                , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'OrdersLineItems.LineItems',  5, 'Orders.LBL_LIST_ITEM_TAX_RATE'      , 'TAXRATE_ID'             , 0, 1, 'TaxRates'                     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'OrdersLineItems.LineItems',  6, 'Orders.LBL_LIST_ITEM_COST_PRICE'    , 'COST_PRICE'             , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'OrdersLineItems.LineItems',  7, 'Orders.LBL_LIST_ITEM_LIST_PRICE'    , 'LIST_PRICE'             , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'OrdersLineItems.LineItems',  8, 'Orders.LBL_LIST_ITEM_UNIT_PRICE'    , 'UNIT_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'OrdersLineItems.LineItems',  9, 'Orders.LBL_LIST_ITEM_EXTENDED_PRICE', 'EXTENDED_PRICE'         , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'OrdersLineItems.LineItems', 10, 'Orders.LBL_LIST_ITEM_TAX'           , 'TAX'                    , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'OrdersLineItems.LineItems', 11, null                                 , 'DISCOUNT_ID'            , 0, 1, 'Discounts'                    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'OrdersLineItems.LineItems', 12, null                                 , 'PRICING_FORMULA'        , 0, 1, 'pricing_formula_line_items'   , -1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'OrdersLineItems.LineItems', 13, null                                 , 'PRICING_FACTOR'         , 0, 1,  25, 10, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'OrdersLineItems.LineItems', 14, 'Orders.LBL_LIST_ITEM_DISCOUNT_NAME' , 'DISCOUNT_PRICE'         , 0, 1,  25, 15, null;
end -- if;
GO

-- 04/11/2007 Paul.  Add Invoices module. 
-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
-- 10/06/2010 Paul.  Size of NAME field was increased to 150. 
-- 03/16/2012 Paul.  Convert the Quote to an Order so that a converted Order will be linked to the invoice. 
-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
-- 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
-- 04/13/2016 Paul.  Add ZipCode lookup. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 10/31/2019 Paul.  Add Billing and Shipping titles to new layout. Was previously only on modified layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditView', 'Invoices', 'vwINVOICES_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView'       ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView'       ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'          , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView'       ,  2, 'Invoices.LBL_INVOICE_NUM'               , 'INVOICE_NUM'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView'       ,  3, 'Invoices.LBL_INVOICE_STAGE'             , 'INVOICE_STAGE'              , 1, 2, 'invoice_stage_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView'       ,  4, 'Invoices.LBL_ORDER_NAME'                , 'ORDER_ID'                   , 0, 1, 'ORDER_NAME'         , 'Orders', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Invoices.EditView'       ,  5, 'Invoices.LBL_AMOUNT_DUE'                , 'AMOUNT_DUE_USDOLLAR'        , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView'       ,  6, 'Invoices.LBL_PURCHASE_ORDER_NUM'        , 'PURCHASE_ORDER_NUM'         , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView'       ,  7, 'Invoices.LBL_DUE_DATE'                  , 'DUE_DATE'                   , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView'       ,  8, 'Invoices.LBL_SHIP_DATE'                 , 'SHIP_DATE'                  , 0, 2, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Invoices.EditView'       ,  9, 'Invoices.LBL_PAYMENT_TERMS'             , 'PAYMENT_TERMS'              , 0, 1, 'payment_terms_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView'       , 10, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView'       , 11, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Invoices.EditView'       , 12, 1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Invoices.EditView'       , 13, null;

	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Invoices.EditView'       , 14;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Invoices.EditView'       , 15, 'Invoices.LBL_BILLING_TITLE' , 3;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Invoices.EditView'       , 16, 'Invoices.LBL_SHIPPING_TITLE', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView'       , 17, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditView'       , 18, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView'       , 19, 'Invoices.LBL_ACCOUNT'                   , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView'       , 20, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditView'       , 21, 'Invoices.LBL_CONTACT'                   , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditView'       , 22, 'Invoices.LBL_STREET'                    , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditView'       , 23, 'Invoices.LBL_STREET'                    , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView'       , 24, 'Invoices.LBL_CITY'                      , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView'       , 25, 'Invoices.LBL_CITY'                      , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView'       , 26, 'Invoices.LBL_STATE'                     , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView'       , 27, 'Invoices.LBL_STATE'                     , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Invoices.EditView'       , 28, 'Invoices.LBL_POSTAL_CODE'               , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'Invoices.EditView'       , 29, 'Invoices.LBL_POSTAL_CODE'               , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView'       , 30, 'Invoices.LBL_COUNTRY'                   , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditView'       , 31, 'Invoices.LBL_COUNTRY'                   , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditView', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditView', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditView', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditView'       ,  1, 'Invoices.LBL_OPPORTUNITY_NAME'          , 'OPPORTUNITY_ID'             , 0, 2, 'OPPORTUNITY_NAME'   , 'Opportunities', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditView'       , 11, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 03/16/2012 Paul.  Convert the Quote Name to an Order Popup so that a converted Order will be linked to the invoice. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView' and DATA_FIELD = 'ORDER_ID' and DELETED = 0) begin -- then
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView' and DATA_FIELD = 'QUOTE_NAME' and FIELD_TYPE = 'Label' and DELETED = 0) begin -- then
			print 'EDITVIEWS_FIELDS Invoices.EditView:  Convert Quote Name to Order popup.';
			update EDITVIEWS_FIELDS
			   set DATA_LABEL        = 'Invoices.LBL_ORDER_NAME'
			     , DATA_FIELD        = 'ORDER_ID'
			     , DISPLAY_FIELD     = 'ORDER_NAME'
			     , FIELD_TYPE        = 'ModulePopup'
			     , MODULE_TYPE       = 'Orders'
			     , DATE_MODIFIED     = getutcdate()
			     , DATE_MODIFIED_UTC = getdate()
			     , MODIFIED_USER_ID  = null
			 where EDIT_NAME         = 'Invoices.EditView'
			   and DATA_FIELD        = 'QUOTE_NAME'
			   and FIELD_TYPE        = 'Label'
			   and DELETED           = 0;
		end -- if;
	end -- if;
	-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditAddress'    ,  0, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditAddress'    ,  2, 'Invoices.LBL_ACCOUNT'                   , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditAddress'    ,  3, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditAddress'    ,  4, 'Invoices.LBL_CONTACT'                   , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'BILLING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'BILLING_ACCOUNT_ID' , '1';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'SHIPPING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'SHIPPING_ACCOUNT_ID', '1';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Invoices.EditAddress', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Invoices.EditAddress', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'BILLING_CONTACT_ID' , '1,1';
		end -- if;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'SHIPPING_CONTACT_ID', '1,1';
		end -- if;
		exec dbo.spEDITVIEWS_FIELDS_MergeView      'Invoices.EditView', 'Invoices.EditAddress', 'Invoices.LBL_BILLING_TITLE', 'Invoices.LBL_SHIPPING_TITLE';
	end -- if;
	-- 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
	exec dbo.spEDITVIEWS_FIELDS_CnvControl     'Invoices.EditView'       ,  8, 'Invoices.LBL_SHIP_DATE'                 , 'SHIP_DATE'                  , 0, 2, 'DatePicker'         , null, null, null;
	-- 02/15/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView' and DATA_FIELD = 'PAYMENT_TERMS' and CACHE_NAME = 'payment_terms_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_terms_dom to PaymentTerms list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTerms for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTerms'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Invoices.EditView'
		--   and DATA_FIELD        = 'PAYMENT_TERMS'
		--   and CACHE_NAME        = 'payment_terms_dom'
		--   and DELETED           = 0;
	end -- if;
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Invoices.EditView', 'BILLING_ADDRESS_POSTALCODE';
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'Invoices.EditView', 'SHIPPING_ADDRESS_POSTALCODE';
	-- 05/12/2016 Paul.  Add Tags module. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditView' and DATA_FIELD = 'TAG_SET_NAME' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 2
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where EDIT_NAME         = 'Invoices.EditView'
		   and FIELD_INDEX      >= 12
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Invoices.EditView'          , 12, 1, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Invoices.EditView'          , 13, null;
	end -- if;
end -- if;
GO

-- 09/02/2012 Paul.  Merge layout so that there is only one table to render in the HTML5 Client. 
/*
-- 07/27/2010 Paul.  Convert to a ModulePopup so that Account and Contacts will get auto-complete. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditAddress';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditAddress', 'Invoices', 'vwINVOICES_Edit', '15%', '30%', null;
	-- 08/29/2009 Paul.  Don't convert the ChangeButton to a ModulePopup. 
	-- 07/27/2010 Paul.  Convert to a ModulePopup so that Account and Contacts will get auto-complete. The DataFormat plus the onclient script will solve the previous problem. 
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditAddress'    ,  0, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Invoices.EditAddress'    ,  1, null                                     , null                         , 0, null, 'AddressButtons', null, null, 7;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditAddress'    ,  2, 'Invoices.LBL_ACCOUNT'                   , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditAddress'    ,  3, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Invoices.EditAddress'    ,  4, 'Invoices.LBL_CONTACT'                   , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditAddress'    ,  5, 'Invoices.LBL_STREET'                    , 'BILLING_ADDRESS_STREET'     , 0, 3,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditAddress'    ,  6, 'Invoices.LBL_STREET'                    , 'SHIPPING_ADDRESS_STREET'    , 0, 4,   2, 30, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress'    ,  7, 'Invoices.LBL_CITY'                      , 'BILLING_ADDRESS_CITY'       , 0, 3, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress'    ,  8, 'Invoices.LBL_CITY'                      , 'SHIPPING_ADDRESS_CITY'      , 0, 4, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress'    ,  9, 'Invoices.LBL_STATE'                     , 'BILLING_ADDRESS_STATE'      , 0, 3, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress'    , 10, 'Invoices.LBL_STATE'                     , 'SHIPPING_ADDRESS_STATE'     , 0, 4, 100, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress'    , 11, 'Invoices.LBL_POSTAL_CODE'               , 'BILLING_ADDRESS_POSTALCODE' , 0, 3,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress'    , 12, 'Invoices.LBL_POSTAL_CODE'               , 'SHIPPING_ADDRESS_POSTALCODE', 0, 4,  20, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress'    , 13, 'Invoices.LBL_COUNTRY'                   , 'BILLING_ADDRESS_COUNTRY'    , 0, 3, 100, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Invoices.EditAddress'    , 14, 'Invoices.LBL_COUNTRY'                   , 'SHIPPING_ADDRESS_COUNTRY'   , 0, 4, 100, 10, null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'BILLING_ACCOUNT_ID' , '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'SHIPPING_ACCOUNT_ID', '1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditAddress', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Invoices.EditAddress', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'BILLING_CONTACT_ID' , '1,1';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'SHIPPING_CONTACT_ID', '1,1';
end else begin
	-- 07/27/2010 Paul.  Convert to a ModulePopup so that Account and Contacts will get auto-complete. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditAddress'    ,  0, 'Invoices.LBL_ACCOUNT'                   , 'BILLING_ACCOUNT_ID'         , 1, 3, 'BILLING_ACCOUNT_NAME' , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditAddress'    ,  2, 'Invoices.LBL_ACCOUNT'                   , 'SHIPPING_ACCOUNT_ID'        , 0, 4, 'SHIPPING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditAddress'    ,  3, 'Invoices.LBL_CONTACT'                   , 'BILLING_CONTACT_ID'         , 0, 3, 'BILLING_CONTACT_NAME' , 'Contacts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Invoices.EditAddress'    ,  4, 'Invoices.LBL_CONTACT'                   , 'SHIPPING_CONTACT_ID'        , 0, 4, 'SHIPPING_CONTACT_NAME', 'Contacts', null;
	-- 07/27/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'BILLING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'BILLING_ACCOUNT_ID' , '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'SHIPPING_ACCOUNT_ID' and DATA_FORMAT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'SHIPPING_ACCOUNT_ID', '1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Invoices.EditAddress', 'BILLING_CONTACT_ID' , 'return BillingContactPopup();';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and ONCLICK_SCRIPT is null and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick null, 'Invoices.EditAddress', 'SHIPPING_CONTACT_ID', 'return ShippingContactPopup();';
	end -- if;
	-- 07/27/2010 Paul.  JavaScript seems to have a problem with function overloading. 
	-- Instead of trying to use function overloading, use a DataFormat flag to check the UseContextKey AutoComplete flag. 
	-- 08/21/2010 Paul.  We now want to auto-submit a contact change. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'BILLING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'BILLING_CONTACT_ID' , '1,1';
	end -- if;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditAddress' and DATA_FIELD = 'SHIPPING_CONTACT_ID' and (DATA_FORMAT is null or DATA_FORMAT = '0,1') and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Invoices.EditAddress', 'SHIPPING_CONTACT_ID', '1,1';
	end -- if;
end -- if;
*/
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.EditDescription' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.EditDescription';
	exec dbo.spEDITVIEWS_InsertOnly            'Invoices.EditDescription', 'Invoices', 'vwINVOICES_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Invoices.EditDescription'  ,  0, 'Invoices.LBL_DESCRIPTION'                 , 'DESCRIPTION'                , 0, 5,   8, 60, null;
end -- if;
GO

-- 06/20/2020 Paul.  React Client uses a dynamic layout. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.Invoices';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.Invoices' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS InvoicesLineItems.LineItems';
	exec dbo.spEDITVIEWS_InsertOnly             'Payments.Invoices', 'InvoicesLineItems', 'vwINVOICES_LINE_ITEMS_Edit', '15%', '35', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.Invoices',  0, 'Invoices.LBL_LIST_ITEM_QUANTITY'      , 'QUANTITY'               , 1, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Payments.Invoices',  1, 'Invoices.LBL_LIST_ITEM_NAME'          , 'PRODUCT_TEMPLATE_ID'    , 0, 1, 'PRODUCT_TEMPLATE_NAME'        , 'ProductCatalog', null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine    'Payments.Invoices',  2, 'Invoices.LBL_LIST_DESCRIPTION'        , 'DESCRIPTION'            , 0, 1,   3, 80, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Payments.Invoices',  3, 'Invoices.LBL_LIST_ITEM_MFT_PART_NUM'  , 'MFT_PART_NUM'           , 0, null, 50, 20, 'ProductPartNumbers', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Payments.Invoices',  4, 'Invoices.LBL_LIST_ITEM_TAX_CLASS'     , 'TAX_CLASS'              , 1, 1, 'tax_class_dom'                , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Payments.Invoices',  5, 'Invoices.LBL_LIST_ITEM_TAX_RATE'      , 'TAXRATE_ID'             , 0, 1, 'TaxRates'                     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.Invoices',  6, 'Invoices.LBL_LIST_ITEM_COST_PRICE'    , 'COST_PRICE'             , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.Invoices',  7, 'Invoices.LBL_LIST_ITEM_LIST_PRICE'    , 'LIST_PRICE'             , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.Invoices',  8, 'Invoices.LBL_LIST_ITEM_UNIT_PRICE'    , 'UNIT_PRICE'             , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.Invoices',  9, 'Invoices.LBL_LIST_ITEM_EXTENDED_PRICE', 'EXTENDED_PRICE'         , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.Invoices', 10, 'Invoices.LBL_LIST_ITEM_TAX'           , 'TAX'                    , 0, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Payments.Invoices', 11, null                                   , 'DISCOUNT_ID'            , 0, 1, 'Discounts'                    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Payments.Invoices', 12, null                                   , 'PRICING_FORMULA'        , 0, 1, 'pricing_formula_line_items'   , -1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.Invoices', 13, null                                   , 'PRICING_FACTOR'         , 0, 1,  25, 10, -1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.Invoices', 14, 'Invoices.LBL_LIST_ITEM_DISCOUNT_NAME' , 'DISCOUNT_PRICE'         , 0, 1,  25, 15, null;
end -- if;
GO

-- 02/09/2008 Paul.  Add credit card ID. 
-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
-- 08/26/2010 Paul.  We need a bank fee field to allow for a difference between allocated and received payment. 
-- 09/15/2010 Paul.  Bank Fee should not be required. 
-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
-- 12/12/2022 Paul.  React requires currency fields to have currency data format. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Payments.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Payments.EditView', 'Payments', 'vwPAYMENTS_Edit', '15%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView'       ,  0, 'Payments.LBL_AMOUNT'                    , 'AMOUNT'                     , 1, 1,  10, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView'       ,  1, 'Payments.LBL_BANK_FEE'                  , 'BANK_FEE'                   , 0, 1,  10, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.EditView'       ,  2, 'Payments.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 1, 2, 'ACCOUNT_NAME'       , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Payments.EditView'       ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Payments.EditView'       ,  4, 'Payments.LBL_CURRENCY'                  , 'CURRENCY_ID'                , 1, 1, 'Currencies'         , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView'       ,  5, 'Payments.LBL_CUSTOMER_REFERENCE'        , 'CUSTOMER_REFERENCE'         , 0, 2,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'Payments.EditView'       ,  6, 'Payments.LBL_PAYMENT_DATE'              , 'PAYMENT_DATE'               , 1, 1, 'DatePicker'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'Payments.EditView'       ,  7, 'Payments.LBL_PAYMENT_NUM'               , 'PAYMENT_NUM'                , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Payments.EditView'       ,  8, 'Payments.LBL_PAYMENT_TYPE'              , 'PAYMENT_TYPE'               , 1, 1, 'payment_type_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsChange      'Payments.EditView'       ,  9, 'Payments.LBL_CREDIT_CARD_NAME'          , 'CREDIT_CARD_ID'             , 0, 2, 'CREDIT_CARD_NAME'   , 'return CreditCardPopup();', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.EditView'       , 10, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.EditView'       , 11, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 08/04/2010 Paul.  We don't need 8 rows for the description as it will not be used often. 
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Payments.EditView'       , 12, 'Payments.LBL_DESCRIPTION'               , 'DESCRIPTION'                , 0, 5,   4, 80, 3;
	-- 08/04/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Payments.EditView', 'ACCOUNT_ID' , '1';

	-- 12/12/2022 Paul.  React requires currency fields to have currency data format. 
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Payments.EditView', 'AMOUNT'  , '{0:c}';
	exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Payments.EditView', 'BANK_FEE', '{0:c}';
end else begin
	-- 08/27/2009 Paul.  Convert the ChangeButton to a ModulePopup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Payments.EditView'       ,  8, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Payments.EditView'       ,  9, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	-- 08/04/2010 Paul.  Convert the ChangeButton to a ModulePopup. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView' and DATA_FIELD = 'ACCOUNT_ID' and FIELD_TYPE = 'ChangeButton' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup 'Payments.EditView'       ,  1, 'Payments.LBL_ACCOUNT_NAME'              , 'ACCOUNT_ID'                 , 1, 2, 'ACCOUNT_NAME'       , 'Accounts', null;
		-- 08/04/2010 Paul.  A DataFormat of 1 for a ModulePopup means to auto-submit. 
		exec dbo.spEDITVIEWS_FIELDS_UpdateDataFormat null, 'Payments.EditView', 'ACCOUNT_ID' , '1';
	end -- if;
	-- 02/11/2008 Paul.  Data is required. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView' and DATA_FIELD = 'ACCOUNT_ID' and UI_REQUIRED = 0 and DELETED = 0) begin -- then
		print 'Payment Account is required. ';
		update EDITVIEWS_FIELDS
		   set UI_REQUIRED      = 1
		     , DATA_REQUIRED    = 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'Payments.EditView'
		   and DATA_FIELD       = 'ACCOUNT_ID'
		   and UI_REQUIRED      = 0
		   and DELETED          = 0;
	end -- if;
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView' and DATA_FIELD = 'BANK_FEE' and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS Payments.EditView: Add BANK_FEE.';
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX      = FIELD_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'Payments.EditView'
		   and FIELD_INDEX     >= 1
		   and DELETED          = 0;
		-- 09/15/2010 Paul.  Bank Fee should not be required. 
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.EditView'       ,  1, 'Payments.LBL_BANK_FEE'                  , 'BANK_FEE'          , 0, 1,  10, 35, null;
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX      = FIELD_INDEX + 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'Payments.EditView'
		   and FIELD_INDEX     >= 3
		   and DELETED          = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Payments.EditView'       ,  3, null;
	end -- if;
	-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView' and DATA_FIELD = 'PAYMENT_TYPE' and CACHE_NAME = 'payment_type_dom' and DELETED = 0) begin -- then
		print 'Change from terminology payment_type_dom to PaymentTypes list. ';
		-- 11/06/2015 Paul.  Instead of changing to PaymentTypes for all situations, only do so when QuickBooks enabled. 
		--update EDITVIEWS_FIELDS
		--   set CACHE_NAME        = 'PaymentTypes'
		--     , DATE_MODIFIED     = getdate()
		--     , DATE_MODIFIED_UTC = getutcdate()
		--     , MODIFIED_USER_ID  = null
		-- where EDIT_NAME         = 'Payments.EditView'
		--   and DATA_FIELD        = 'PAYMENT_TYPE'
		--   and CACHE_NAME        = 'payment_type_dom'
		--   and DELETED           = 0;
	end -- if;
	-- 09/15/2010 Paul.  Lets not apply this rule as it will prevent users from making it a required field. 
/*
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView' and DATA_FIELD = 'BANK_FEE' and (DATA_REQUIRED = 1 or UI_REQUIRED = 1) and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_REQUIRED    = 0
		     , UI_REQUIRED      = 0
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'Payments.EditView'
		   and DATA_FIELD       = 'BANK_FEE'
		   and (DATA_REQUIRED = 1 or UI_REQUIRED = 1)
		   and DELETED          = 0;
	end -- if;
*/

	-- 12/12/2022 Paul.  React requires currency fields to have currency data format. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView' and DATA_FIELD in ('AMOUNT', 'BANK_FEE') and DATA_FORMAT is null and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FORMAT       = '{0:c}'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Payments.EditView'
		   and DATA_FIELD        in ('AMOUNT', 'BANK_FEE')
		   and DATA_FORMAT       is null
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 05/26/2007 Paul.  We need to display the unconverted amount. 
if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.EditView' and DATA_FIELD = 'AMOUNT_USDOLLAR' and DELETED = 0) begin -- then
	print 'Fix Payments.EditView AMOUNT';
	update EDITVIEWS_FIELDS
	   set DATA_FIELD       = 'AMOUNT'
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where EDIT_NAME        = 'Payments.EditView'
	   and DATA_LABEL       = 'Payments.LBL_AMOUNT' 
	   and DATA_FIELD       = 'AMOUNT_USDOLLAR'
	   and DELETED          = 0;
end -- if;
GO

-- 10/09/2022 Paul.  Add Payments.SummaryView to React Client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.LineItems';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.LineItems' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Payments.LineItems';
	exec dbo.spEDITVIEWS_InsertOnly            'Payments.LineItems', 'Payments', 'vwPAYMENTS_INVOICES', '15%', '35', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Payments.LineItems'       ,  0, 'Payments.LBL_LIST_INVOICE_NAME'        , 'INVOICE_ID'                 , 1, 1, 'INVOICE_NAME'        , 'Invoices', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.LineItems'       ,  1, 'Invoices.LBL_LIST_AMOUNT_DUE'          , 'AMOUNT_DUE'                 , 1, 1,  25, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Payments.LineItems'       ,  2, 'Payments.LBL_LIST_ALLOCATED'           , 'AMOUNT'                     , 1, 1,  25, 15, null;
end -- if;
GO

-- 07/15/2007 Paul.  Add forums/threaded discussions.
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Forums.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Forums.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Forums.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Forums.EditView', 'Forums', 'vwFORUMS_Edit', '15%', '85%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Forums.EditView'          ,  0, 'Forums.LBL_TITLE'                      , 'TITLE'                      , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Forums.EditView'          ,  1, 'Forums.LBL_CATEGORY'                   , 'CATEGORY'                   , 1, 2, 'ForumTopics', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Forums.EditView'          ,  2, 'Teams.LBL_TEAM'                        , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Forums.EditView'          ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Forums.EditView'          ,  4, 'Forums.LBL_DESCRIPTION'                , 'DESCRIPTION'                , 0, 1,   4, 60, null;
end -- if;
GO

-- 02/09/2008 Paul.  Add credit card management. 
-- 03/12/2008 Paul.  Some customers may want a simplified mm/yy entry format. 
-- 09/27/2008 Paul.  Allow editing of security code. 
-- 12/16/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
-- 04/13/2016 Paul.  Add ZipCode lookup. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'CreditCards.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'CreditCards.EditView' and DELETED = 0) begin -- then 
	print 'EDITVIEWS_FIELDS CreditCards.EditView'; 
	exec dbo.spEDITVIEWS_InsertOnly 'CreditCards.EditView', 'CreditCards', 'vwCREDIT_CARDS_Edit', '15%', '35%', null; 
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView',  0, 'CreditCards.LBL_NAME'              , 'NAME'              , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'CreditCards.EditView',  1, 'CreditCards.LBL_CARD_TYPE'         , 'CARD_TYPE'         , 1, 1, 'credit_card_type_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView',  2, 'CreditCards.LBL_CARD_NUMBER'       , 'CARD_NUMBER'       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'CreditCards.EditView',  3, 'CreditCards.LBL_EXPIRATION_DATE'   , 'EXPIRATION_MONTH'  , 1, 1, 'dom_cal_month_long'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'CreditCards.EditView',  4, null                                , 'EXPIRATION_YEAR'   , 1, 1, 'credit_card_year'    , -1, null;

	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView',  5, 'CreditCards.LBL_SECURITY_CODE'     , 'SECURITY_CODE'     , 0, 1, 10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'CreditCards.EditView',  6, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'CreditCards.EditView',  7, 'CreditCards.LBL_IS_PRIMARY'        , 'IS_PRIMARY'        , 0, 1, 'CheckBox'            , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView',  8, 'CreditCards.LBL_ADDRESS_STREET'    , 'ADDRESS_STREET'    , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView',  9, 'CreditCards.LBL_ADDRESS_CITY'      , 'ADDRESS_CITY'      , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView', 10, 'CreditCards.LBL_ADDRESS_STATE'     , 'ADDRESS_STATE'     , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsZipCode     'CreditCards.EditView', 11, 'CreditCards.LBL_ADDRESS_POSTALCODE', 'ADDRESS_POSTALCODE', 0, 1,  20, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView', 12, 'CreditCards.LBL_ADDRESS_COUNTRY'   , 'ADDRESS_COUNTRY'   , 0, 1, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView', 13, 'CreditCards.LBL_EMAIL'             , 'EMAIL'             , 0, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView', 14, 'CreditCards.LBL_PHONE'             , 'PHONE'             , 0, 1, 100, 35, null;
end else begin
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'CreditCards.EditView' and DATA_FIELD = 'SECURITY_CODE' and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS CreditCards.EditView: Add SECURITY_CODE.';
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX      = FIELD_INDEX + 2
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'CreditCards.EditView'
		   and FIELD_INDEX     >= 5
		   and DELETED          = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView',  5, 'CreditCards.LBL_SECURITY_CODE'     , 'SECURITY_CODE'     , 0, 1, 10, 10, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBlank       'CreditCards.EditView',  6, null;
	end -- if;
	-- 12/16/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView', 13, 'CreditCards.LBL_EMAIL'             , 'EMAIL'             , 0, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'CreditCards.EditView', 14, 'CreditCards.LBL_PHONE'             , 'PHONE'             , 0, 1, 100, 35, null;
	-- 04/13/2016 Paul.  Add ZipCode lookup. 
	exec dbo.spEDITVIEWS_FIELDS_CnvZipCodePopup 'CreditCards.EditView', 'ADDRESS_POSTALCODE';
end -- if;
GO

-- 04/02/2009 Paul.  Convert Threads to EditView now that we support an HtmlEditor. 
-- delete from EDITVIEWS where NAME = 'Threads.EditView';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Threads.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Threads.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Threads.EditView';
	exec dbo.spEDITVIEWS_InsertOnly           'Threads.EditView', 'Threads', 'vwTHREADS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Threads.EditView'        ,  0, 'Threads.LBL_TITLE'                      , 'TITLE'                      , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl    'Threads.EditView'        ,  1, 'Threads.LBL_IS_STICKY'                  , 'IS_STICKY'                  , 0, 1, 'CheckBox', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsHtmlEditor 'Threads.EditView'        ,  2, 'Threads.LBL_DESCRIPTION_HTML'           , 'DESCRIPTION_HTML'           , 0, null, null, null, 3;
end -- if;
GO

-- 04/02/2009 Paul.  Convert Posts to EditView now that we support an HtmlEditor. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Posts.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Posts.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Posts.EditView';
	exec dbo.spEDITVIEWS_InsertOnly           'Posts.EditView', 'Posts', 'vwPOSTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound      'Posts.EditView'          ,  0, 'Threads.LBL_TITLE'                      , 'TITLE'                      , 1, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank      'Posts.EditView'          ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsHtmlEditor 'Posts.EditView'          ,  2, 'Threads.LBL_DESCRIPTION_HTML'           , 'DESCRIPTION_HTML'           , 0, null, null, null, 3;
end -- if;
GO

-- 10/18/2009 Paul.  Add Knowledge Base module. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 01/14/2018 Paul.  Remove KB Tags now that we have a global tag system. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS KBDocuments.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'KBDocuments.EditView', 'KBDocuments', 'vwKBDOCUMENTS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'KBDocuments.EditView'    ,  0, 'KBDocuments.LBL_NAME'                   , 'NAME'                       , 1, null, 255, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'KBDocuments.EditView'    ,  1, 'KBDocuments.LBL_IS_EXTERNAL_ARTICLE'    , 'IS_EXTERNAL_ARTICLE'        , 0, null, 'CheckBox'                , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'KBDocuments.EditView'    ,  2, 'KBDocuments.LBL_REVISION'               , 'REVISION'                   , 1, null,  25, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'KBDocuments.EditView'    ,  3, 'KBDocuments.LBL_STATUS'                 , 'STATUS'                     , 1, null, 'kbdocument_status_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'KBDocuments.EditView'    ,  4, 'KBDocuments.LBL_KBDOC_APPROVER_ID'      , 'KBDOC_APPROVER_ID'          , 0, null, 'KBDOC_APPROVER_NAME'     , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'KBDocuments.EditView'    ,  5, 'KBDocuments.LBL_ACTIVE_DATE'            , 'ACTIVE_DATE'                , 0, null, 'DatePicker'              , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'KBDocuments.EditView'    ,  6, 'KBDocuments.LBL_EXP_DATE'               , 'EXP_DATE'                   , 0, null, 'DatePicker'              , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'KBDocuments.EditView'    ,  7, 1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'KBDocuments.EditView'    ,  8, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 1, null, 'ASSIGNED_TO_NAME'        , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'KBDocuments.EditView'    ,  9, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsControl     'KBDocuments.EditView'    ,  9, 'KBDocuments.LBL_TAGS'                   , 'KBTAG_NAME'                 , 1, null, 'KBTagSelect'             , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'KBDocuments.EditView'    , 10, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 1, null, 'TEAM_NAME'               , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsHtmlEditor  'KBDocuments.EditView'    , 11, 'KBDocuments.LBL_DESCRIPTION'            , 'DESCRIPTION'                , 1, null, null, null, 3;
end else begin
	-- 05/12/2016 Paul.  Add Tags module. 
	exec dbo.spEDITVIEWS_FIELDS_CnvTagSelect   'KBDocuments.EditView' ,  7, 1, null;
	-- 01/14/2018 Paul.  Remove KB Tags now that we have a global tag system. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.EditView' and DATA_FIELD = 'KBTAG_NAME' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set FIELD_TYPE        = 'Blank'
		     , DATA_FIELD        = null
		     , DISPLAY_FIELD     = null
		     , DATA_LABEL        = null
		     , FORMAT_TAB_INDEX  = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'KBDocuments.EditView'
		   and DATA_FIELD        = 'KBTAG_NAME'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'KBTags.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBTags.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS KBTags.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'KBTags.EditView'         , 'KBTags', 'vwKBDTAGS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'KBTags.EditView'         ,  0, 'KBTags.LBL_FULL_TAG_NAME'               , 'FULL_TAG_NAME'              , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'KBTags.EditView'         ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'KBTags.EditView'         ,  2, 'KBTags.LBL_TAG_NAME'                    , 'TAG_NAME'                   , 1, null, 100, 20, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'KBTags.EditView'         ,  3, 'KBTags.LBL_PARENT_TAG_NAME'             , 'PARENT_TAG_ID'              , 0, null, 'PARENT_FULL_TAG_NAME'    , 'KBTags', null;
end -- if;
GO

-- 09/04/2010 Paul.  Create full editing for ProductCategories. 
-- 09/26/2010 Paul.  Change default layout to use two columns. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductCategories.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductCategories.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductCategories.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'ProductCategories.EditView', 'ProductCategories', 'vwPRODUCT_CATEGORIES', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductCategories.EditView',  0, 'ProductCategories.LBL_NAME'           , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductCategories.EditView',  1, 'ProductCategories.LBL_ORDER'          , 'LIST_ORDER'                 , 1, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'ProductCategories.EditView',  1, 'Integer'                              , 'LIST_ORDER'                 , '.ERR_INVALID_INTEGER';
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'ProductCategories.EditView',  2, 'ProductCategories.LBL_PARENT'         , 'PARENT_ID'                  , 0, 1, 'PARENT_NAME'   , 'ProductCategories', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'ProductCategories.EditView',  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'ProductCategories.EditView',  4, 'ProductCategories.LBL_DESCRIPTION'    , 'DESCRIPTION'                , 0, 1,   8, 60, 3;
end -- if;
GO

-- 09/26/2010 Paul.  Create full editing for ProductTypes. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTypes.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTypes.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTypes.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'ProductTypes.EditView', 'ProductTypes', 'vwPRODUCT_TYPES', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTypes.EditView',  0, 'ProductTypes.LBL_NAME'           , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ProductTypes.EditView',  1, 'ProductTypes.LBL_ORDER'          , 'LIST_ORDER'                 , 1, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'ProductTypes.EditView',  1, 'Integer'                         , 'LIST_ORDER'                 , '.ERR_INVALID_INTEGER';
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'ProductTypes.EditView',  2, 'ProductTypes.LBL_DESCRIPTION'    , 'DESCRIPTION'                , 0, 1,   8, 60, 3;
end -- if;
GO

-- 07/20/2010 Paul.  Regions. 
-- 09/16/2010 Paul.  Move Regions to Professional file. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Regions.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Regions.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Regions.EditView', 'Regions', 'vwREGIONS', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Regions.EditView'        ,  0, 'Regions.LBL_NAME'                       , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Regions.EditView'        ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Regions.EditView'        ,  2, 'Regions.LBL_DESCRIPTION'                , 'DESCRIPTION'                , 0, 2,   8, 60, null;
end -- if;
GO

-- 09/16/2010 Paul.  Add support for multiple Payment Gateways.
-- 12/12/2015 Paul.  Change to LibraryPaymentGateways. 
-- 03/17/2021 Paul.  Change to use password type. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentGateway.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentGateway.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS PaymentGateway.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'PaymentGateway.EditView', 'PaymentGateway', 'vwPAYMENT_GATEWAYS', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PaymentGateway.EditView',  0, 'PaymentGateway.LBL_NAME'           , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'PaymentGateway.EditView',  1, 'PaymentGateway.LBL_GATEWAY'        , 'GATEWAY'                    , 1, 1, 'LibraryPaymentGateways' , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PaymentGateway.EditView',  2, 'PaymentGateway.LBL_LOGIN'          , 'LOGIN'                      , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'PaymentGateway.EditView',  3, 'PaymentGateway.LBL_TEST_MODE'      , 'TEST_MODE'                  , 0, 1, 'CheckBox'               , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsPassword    'PaymentGateway.EditView',  4, 'PaymentGateway.LBL_PASSWORD'       , 'PASSWORD'                   , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'PaymentGateway.EditView',  5, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'PaymentGateway.EditView',  6, 'PaymentGateway.LBL_DESCRIPTION'    , 'DESCRIPTION'                , 0, 1,   8, 80, 3;
end else begin
	-- 12/12/2015 Paul.  Change to ApiPaymentGateways. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentGateway.EditView' and DATA_FIELD = 'GATEWAY' and CACHE_NAME = 'payment_gateway_dom' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set CACHE_NAME        = 'LibraryPaymentGateways'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'PaymentGateway.EditView'
		   and DATA_FIELD        = 'GATEWAY'
		   and CACHE_NAME        = 'payment_gateway_dom'
		   and DELETED           = 0;
	end -- if;
	-- 03/17/2021 Paul.  Change to use password type. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentGateway.EditView' and DATA_FIELD = 'PASSWORD' and FIELD_TYPE = 'TextBox' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set FIELD_TYPE        = 'Password'
		     , UI_REQUIRED       = 0
		     , DATA_REQUIRED     = 0
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'PaymentGateway.EditView'
		   and DATA_FIELD        = 'PASSWORD'
		   and FIELD_TYPE        = 'TextBox'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 09/26/2010 Paul.  Create full editing for TaxRates. 
-- 02/24/2015 Paul.  Add state for lookup. 
-- 04/07/2016 Paul.  Tax rates per team. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'TaxRates.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TaxRates.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS TaxRates.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'TaxRates.EditView', 'TaxRates', 'vwTAX_RATES_Edit', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView'      ,  0, 'TaxRates.LBL_NAME'                 , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'TaxRates.EditView'      ,  1, 'TaxRates.LBL_STATUS'               , 'STATUS'                     , 1, 1, 'tax_rate_status_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView'      ,  2, 'TaxRates.LBL_VALUE'                , 'VALUE'                      , 1, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'TaxRates.EditView'      ,  3, 'Positive Decimal'                  , 'VALUE'                      , '.ERR_INVALID_INTEGER';
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView'      ,  4, 'TaxRates.LBL_ORDER'                , 'LIST_ORDER'                 , 1, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'TaxRates.EditView'      ,  5, 'Integer'                           , 'LIST_ORDER'                 , '.ERR_INVALID_INTEGER';
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView'      ,  6, 'TaxRates.LBL_QUICKBOOKS_TAX_VENDOR', 'QUICKBOOKS_TAX_VENDOR'      , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TaxRates.EditView'      ,  7, 'TaxRates.LBL_ADDRESS_STATE'        , 'ADDRESS_STATE'              , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'TaxRates.EditView'      ,  8, 'TaxRates.LBL_DESCRIPTION'          , 'DESCRIPTION'                , 0, 1,   8, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'TaxRates.EditView'      ,  9, 'Teams.LBL_TEAM'                    , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvBound       'TaxRates.EditView'      ,  7, 'TaxRates.LBL_ADDRESS_STATE'        , 'ADDRESS_STATE'              , 0, 1,  50, 35, null;
	-- 04/07/2016 Paul.  Tax rates per team. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TaxRates.EditView' and DATA_FIELD ='TEAM_ID' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'TaxRates.EditView'      ,  9, 'Teams.LBL_TEAM'                    , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
		update EDITVIEWS_FIELDS
		   set COLSPAN           = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where EDIT_NAME         = 'TaxRates.EditView'
		   and DATA_FIELD        = 'DESCRIPTION'
		   and COLSPAN           = 3
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 09/26/2010 Paul.  Create full editing for Manufacturers. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Manufacturers.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Manufacturers.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Manufacturers.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Manufacturers.EditView', 'Manufacturers', 'vwMANUFACTURERS', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Manufacturers.EditView' ,  0, 'Manufacturers.LBL_NAME'            , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Manufacturers.EditView' ,  1, 'Manufacturers.LBL_STATUS'          , 'STATUS'                     , 1, 1, 'manufacturer_status_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Manufacturers.EditView' ,  2, 'Manufacturers.LBL_ORDER'           , 'LIST_ORDER'                 , 1, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Manufacturers.EditView' ,  3, null;
end -- if;
GO

-- 09/26/2010 Paul.  Create full editing for Shippers. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Shippers.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Shippers.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Shippers.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Shippers.EditView', 'Shippers', 'vwSHIPPERS', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Shippers.EditView'      ,  0, 'Shippers.LBL_NAME'                 , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Shippers.EditView'      ,  1, 'Shippers.LBL_STATUS'               , 'STATUS'                     , 1, 1, 'shipper_status_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Shippers.EditView'      ,  2, 'Shippers.LBL_ORDER'                , 'LIST_ORDER'                 , 1, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Shippers.EditView'      ,  3, null;
end -- if;
GO

-- 09/26/2010 Paul.  Create full editing for ContractTypes. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ContractTypes.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ContractTypes.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ContractTypes.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'ContractTypes.EditView', 'ContractTypes', 'vwCONTRACT_TYPES', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ContractTypes.EditView' ,  0, 'ContractTypes.LBL_NAME'            , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ContractTypes.EditView' ,  1, 'ContractTypes.LBL_ORDER'           , 'LIST_ORDER'                 , 1, 1,  10, 10, null;
end -- if;
GO

-- 09/26/2010 Paul.  Create full editing for Discounts. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Discounts.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Discounts.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Discounts.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Discounts.EditView', 'Discounts', 'vwDISCOUNTS', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Discounts.EditView'     ,  0, 'Discounts.LBL_NAME'                , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Discounts.EditView'     ,  1, 'Discounts.LBL_PRICING_FORMULA'     , 'PRICING_FORMULA'            , 1, 1, 'pricing_formula_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Discounts.EditView'     ,  2, 'Discounts.LBL_PRICING_FACTOR'      , 'PRICING_FACTOR'             , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Discounts.EditView'     ,  3, null;
end -- if;
GO

-- 11/12/2018 Paul.  Add custom styles field to allow any style change. 
-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyThemes.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyThemes.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyThemes.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'SurveyThemes.EditView'  , 'SurveyThemes', 'vwSUREVEY_THEMES_Edit', '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  ,  0, 'SurveyThemes.LBL_NAME'                        , 'NAME'                        , 1, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  ,  1, 'SurveyThemes.LBL_SURVEY_FONT_FAMILY'          , 'SURVEY_FONT_FAMILY'          , 0, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  ,  2, 'SurveyThemes.LBL_LOGO_BACKGROUND'             , 'LOGO_BACKGROUND'             , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  ,  3, 'SurveyThemes.LBL_SURVEY_BACKGROUND'           , 'SURVEY_BACKGROUND'           , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  ,  4, 'SurveyThemes.LBL_REQUIRED_TEXT_COLOR'         , 'REQUIRED_TEXT_COLOR'         , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'SurveyThemes.EditView'  ,  5, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  ,  6;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  ,  7, 'SurveyThemes.LBL_SURVEY_TITLE', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  ,  8, 'SurveyThemes.LBL_SURVEY_TITLE_TEXT_COLOR'     , 'SURVEY_TITLE_TEXT_COLOR'     , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  ,  9, 'SurveyThemes.LBL_SURVEY_TITLE_FONT_SIZE'      , 'SURVEY_TITLE_FONT_SIZE'      , 0, 1, 'font_size_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 10, 'SurveyThemes.LBL_SURVEY_TITLE_FONT_STYLE'     , 'SURVEY_TITLE_FONT_STYLE'     , 0, 1, 'font_style_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 11, 'SurveyThemes.LBL_SURVEY_TITLE_FONT_WEIGHT'    , 'SURVEY_TITLE_FONT_WEIGHT'    , 0, 1, 'font_weight_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 12, 'SurveyThemes.LBL_SURVEY_TITLE_DECORATION'     , 'SURVEY_TITLE_DECORATION'     , 0, 1, 'text_decoration_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 13, 'SurveyThemes.LBL_SURVEY_TITLE_BACKGROUND'     , 'SURVEY_TITLE_BACKGROUND'     , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 14;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  , 15, 'SurveyThemes.LBL_PAGE_TITLE', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 16, 'SurveyThemes.LBL_PAGE_TITLE_TEXT_COLOR'       , 'PAGE_TITLE_TEXT_COLOR'       , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 17, 'SurveyThemes.LBL_PAGE_TITLE_FONT_SIZE'        , 'PAGE_TITLE_FONT_SIZE'        , 0, 1, 'font_size_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 18, 'SurveyThemes.LBL_PAGE_TITLE_FONT_STYLE'       , 'PAGE_TITLE_FONT_STYLE'       , 0, 1, 'font_style_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 19, 'SurveyThemes.LBL_PAGE_TITLE_FONT_WEIGHT'      , 'PAGE_TITLE_FONT_WEIGHT'      , 0, 1, 'font_weight_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 20, 'SurveyThemes.LBL_PAGE_TITLE_DECORATION'       , 'PAGE_TITLE_DECORATION'       , 0, 1, 'text_decoration_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 21, 'SurveyThemes.LBL_PAGE_TITLE_BACKGROUND'       , 'PAGE_TITLE_BACKGROUND'       , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 22;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  , 23, 'SurveyThemes.LBL_PAGE_DESCRIPTION', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 24, 'SurveyThemes.LBL_PAGE_DESCRIPTION_TEXT_COLOR' , 'PAGE_DESCRIPTION_TEXT_COLOR' , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 25, 'SurveyThemes.LBL_PAGE_DESCRIPTION_FONT_SIZE'  , 'PAGE_DESCRIPTION_FONT_SIZE'  , 0, 1, 'font_size_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 26, 'SurveyThemes.LBL_PAGE_DESCRIPTION_FONT_STYLE' , 'PAGE_DESCRIPTION_FONT_STYLE' , 0, 1, 'font_style_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 27, 'SurveyThemes.LBL_PAGE_DESCRIPTION_FONT_WEIGHT', 'PAGE_DESCRIPTION_FONT_WEIGHT', 0, 1, 'font_weight_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 28, 'SurveyThemes.LBL_PAGE_DESCRIPTION_DECORATION' , 'PAGE_DESCRIPTION_DECORATION' , 0, 1, 'text_decoration_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 29, 'SurveyThemes.LBL_PAGE_DESCRIPTION_BACKGROUND' , 'PAGE_DESCRIPTION_BACKGROUND' , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 30;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  , 31, 'SurveyThemes.LBL_PAGE_BACKGROUND', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'SurveyThemes.EditView'  , 32, 'SurveyThemes.LBL_PAGE_BACKGROUND_IMAGE'       , 'PAGE_BACKGROUND_IMAGE'       , 0, 1, 'Image', null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 33, 'SurveyThemes.LBL_PAGE_BACKGROUND_POSITION'    , 'PAGE_BACKGROUND_POSITION'    , 0, 1, 'page_background_position', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 34, 'SurveyThemes.LBL_PAGE_BACKGROUND_REPEAT'      , 'PAGE_BACKGROUND_REPEAT'      , 0, 1, 'page_background_repeat'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 35, 'SurveyThemes.LBL_PAGE_BACKGROUND_SIZE'        , 'PAGE_BACKGROUND_SIZE'        , 0, 1, 'page_background_size'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 36;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  , 37, 'SurveyThemes.LBL_QUESTION_HEADING', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 38, 'SurveyThemes.LBL_QUESTION_HEADING_TEXT_COLOR' , 'QUESTION_HEADING_TEXT_COLOR' , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 39, 'SurveyThemes.LBL_QUESTION_HEADING_FONT_SIZE'  , 'QUESTION_HEADING_FONT_SIZE'  , 0, 1, 'font_size_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 40, 'SurveyThemes.LBL_QUESTION_HEADING_FONT_STYLE' , 'QUESTION_HEADING_FONT_STYLE' , 0, 1, 'font_style_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 41, 'SurveyThemes.LBL_QUESTION_HEADING_FONT_WEIGHT', 'QUESTION_HEADING_FONT_WEIGHT', 0, 1, 'font_weight_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 42, 'SurveyThemes.LBL_QUESTION_HEADING_DECORATION' , 'QUESTION_HEADING_DECORATION' , 0, 1, 'text_decoration_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 43, 'SurveyThemes.LBL_QUESTION_HEADING_BACKGROUND' , 'QUESTION_HEADING_BACKGROUND' , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 44;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  , 45, 'SurveyThemes.LBL_QUESTION_CHOICE', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 46, 'SurveyThemes.LBL_QUESTION_CHOICE_TEXT_COLOR'  , 'QUESTION_CHOICE_TEXT_COLOR'  , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 47, 'SurveyThemes.LBL_QUESTION_CHOICE_FONT_SIZE'   , 'QUESTION_CHOICE_FONT_SIZE'   , 0, 1, 'font_size_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 48, 'SurveyThemes.LBL_QUESTION_CHOICE_FONT_STYLE'  , 'QUESTION_CHOICE_FONT_STYLE'  , 0, 1, 'font_style_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 49, 'SurveyThemes.LBL_QUESTION_CHOICE_FONT_WEIGHT' , 'QUESTION_CHOICE_FONT_WEIGHT' , 0, 1, 'font_weight_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 50, 'SurveyThemes.LBL_QUESTION_CHOICE_DECORATION'  , 'QUESTION_CHOICE_DECORATION'  , 0, 1, 'text_decoration_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 51, 'SurveyThemes.LBL_QUESTION_CHOICE_BACKGROUND'  , 'QUESTION_CHOICE_BACKGROUND'  , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 52;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  , 53, 'SurveyThemes.LBL_PROGRESS_BAR', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 54, 'SurveyThemes.LBL_PROGRESS_BAR_PAGE_WIDTH'     , 'PROGRESS_BAR_PAGE_WIDTH'     , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 55, 'SurveyThemes.LBL_PROGRESS_BAR_COLOR'          , 'PROGRESS_BAR_COLOR'          , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 56, 'SurveyThemes.LBL_PROGRESS_BAR_BORDER_COLOR'   , 'PROGRESS_BAR_BORDER_COLOR'   , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 57, 'SurveyThemes.LBL_PROGRESS_BAR_BORDER_WIDTH'   , 'PROGRESS_BAR_BORDER_WIDTH'   , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 58, 'SurveyThemes.LBL_PROGRESS_BAR_TEXT_COLOR'     , 'PROGRESS_BAR_TEXT_COLOR'     , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 59, 'SurveyThemes.LBL_PROGRESS_BAR_FONT_SIZE'      , 'PROGRESS_BAR_FONT_SIZE'      , 0, 1, 'font_size_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 60, 'SurveyThemes.LBL_PROGRESS_BAR_FONT_STYLE'     , 'PROGRESS_BAR_FONT_STYLE'     , 0, 1, 'font_style_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 61, 'SurveyThemes.LBL_PROGRESS_BAR_FONT_WEIGHT'    , 'PROGRESS_BAR_FONT_WEIGHT'    , 0, 1, 'font_weight_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 62, 'SurveyThemes.LBL_PROGRESS_BAR_DECORATION'     , 'PROGRESS_BAR_DECORATION'     , 0, 1, 'text_decoration_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 63, 'SurveyThemes.LBL_PROGRESS_BAR_BACKGROUND'     , 'PROGRESS_BAR_BACKGROUND'     , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 64;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  , 65, 'SurveyThemes.LBL_ERROR', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 66, 'SurveyThemes.LBL_ERROR_TEXT_COLOR'            , 'ERROR_TEXT_COLOR'            , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 67, 'SurveyThemes.LBL_ERROR_FONT_SIZE'             , 'ERROR_FONT_SIZE'             , 0, 1, 'font_size_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 68, 'SurveyThemes.LBL_ERROR_FONT_STYLE'            , 'ERROR_FONT_STYLE'            , 0, 1, 'font_style_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 69, 'SurveyThemes.LBL_ERROR_FONT_WEIGHT'           , 'ERROR_FONT_WEIGHT'           , 0, 1, 'font_weight_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 70, 'SurveyThemes.LBL_ERROR_DECORATION'            , 'ERROR_DECORATION'            , 0, 1, 'text_decoration_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 71, 'SurveyThemes.LBL_ERROR_BACKGROUND'            , 'ERROR_BACKGROUND'            , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 72;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  , 73, 'SurveyThemes.LBL_EXIT_LINK', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 74, 'SurveyThemes.LBL_EXIT_LINK_TEXT_COLOR'        , 'EXIT_LINK_TEXT_COLOR'        , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 75, 'SurveyThemes.LBL_EXIT_LINK_FONT_SIZE'         , 'EXIT_LINK_FONT_SIZE'         , 0, 1, 'font_size_dom'      , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 76, 'SurveyThemes.LBL_EXIT_LINK_FONT_STYLE'        , 'EXIT_LINK_FONT_STYLE'        , 0, 1, 'font_style_dom'     , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 77, 'SurveyThemes.LBL_EXIT_LINK_FONT_WEIGHT'       , 'EXIT_LINK_FONT_WEIGHT'       , 0, 1, 'font_weight_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 78, 'SurveyThemes.LBL_EXIT_LINK_DECORATION'        , 'EXIT_LINK_DECORATION'        , 0, 1, 'text_decoration_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyThemes.EditView'  , 79, 'SurveyThemes.LBL_EXIT_LINK_BACKGROUND'        , 'EXIT_LINK_BACKGROUND'        , 0, 1,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 80;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyThemes.EditView'  , 81, 'SurveyThemes.LBL_DESCRIPTION'                 , 'DESCRIPTION'                 , 0, 3,   8, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 82;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyThemes.EditView'  , 83, 'SurveyThemes.LBL_CUSTOM_STYLES'               , 'CUSTOM_STYLES'               , 0, 3,   8, 80, 3;
end else begin
	-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyThemes.EditView' and DATA_FIELD = 'PAGE_BACKGROUND_IMAGE' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX       = FIELD_INDEX + 6
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'SurveyThemes.EditView'
		   and FIELD_INDEX       >= 31
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsHeader      'SurveyThemes.EditView'  , 31, 'SurveyThemes.LBL_PAGE_BACKGROUND', 3;
		exec dbo.spEDITVIEWS_FIELDS_InsControl     'SurveyThemes.EditView'  , 32, 'SurveyThemes.LBL_PAGE_BACKGROUND_IMAGE'       , 'PAGE_BACKGROUND_IMAGE'       , 0, 1, 'Image', null, null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 33, 'SurveyThemes.LBL_PAGE_BACKGROUND_POSITION'    , 'PAGE_BACKGROUND_POSITION'    , 0, 1, 'page_background_position', null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 34, 'SurveyThemes.LBL_PAGE_BACKGROUND_REPEAT'      , 'PAGE_BACKGROUND_REPEAT'      , 0, 1, 'page_background_repeat'  , null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyThemes.EditView'  , 35, 'SurveyThemes.LBL_PAGE_BACKGROUND_SIZE'        , 'PAGE_BACKGROUND_SIZE'        , 0, 1, 'page_background_size'    , null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 36;
	end -- if;
	-- 11/12/2018 Paul.  Add custom styles field to allow any style change. 
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'SurveyThemes.EditView'  , 82;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyThemes.EditView'  , 83, 'SurveyThemes.LBL_CUSTOM_STYLES'               , 'CUSTOM_STYLES'               , 0, 3,   8, 80, 3;
end -- if;
GO

-- 05/22/2013 Paul.  Add Surveys module. 
-- 01/01/2016 Paul.  Catalin wants to force page navigation for each question, just like mobile navigation. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 07/28/2018 Paul.  Add Kiosk mode fields. 
-- 09/30/2018 Paul.  Add survey record creation to survey. 
-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Surveys.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Surveys.EditView'       , 'Surveys', 'vwSUREVEYS_Edit', '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Surveys.EditView'       ,  0, 'Surveys.LBL_NAME'                             , 'NAME'                       , 1, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Surveys.EditView'       ,  1, 'Surveys.LBL_SURVEY_THEME_NAME'                , 'SURVEY_THEME_ID'            , 1, 1, 'SURVEY_THEME_NAME'  , 'SurveyThemes', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Surveys.EditView'       ,  2, 'Surveys.LBL_STATUS'                           , 'STATUS'                     , 1, 1, 'survey_status_dom'  , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Surveys.EditView'       ,  3, '.LBL_ASSIGNED_TO'                             , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Surveys.EditView'       ,  4, 'Surveys.LBL_PAGE_RANDOMIZATION'               , 'PAGE_RANDOMIZATION'         , 0, 1, 'survey_page_randomization', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Surveys.EditView'       ,  5, 'Teams.LBL_TEAM'                               , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Surveys.EditView'       ,  6, 'Surveys.LBL_SURVEY_STYLE'                     , 'SURVEY_STYLE'               , 0, 1, 'survey_style_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect   'Surveys.EditView'       ,  7, 1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Surveys.EditView'       ,  8, 'Surveys.LBL_DESCRIPTION'                      , 'DESCRIPTION'                , 0, 3,   8, 80, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Surveys.EditView'       ,  9;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Surveys.EditView'       , 10, 'Surveys.LBL_KIOSK_PROPERTIES', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Surveys.EditView'       , 11, 'Surveys.LBL_LOOP_SURVEY'                      , 'LOOP_SURVEY'                , 0, 4,  null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Surveys.EditView'       , 12, 'Surveys.LBL_SURVEY_TARGET_ASSIGNMENT'         , 'SURVEY_TARGET_ASSIGNMENT'   , 1, 1, 'survey_target_assignment_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Surveys.EditView'       , 13, 'Surveys.LBL_TIMEOUT'                          , 'TIMEOUT'                    , 0, 4,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Surveys.EditView'       , 14, 'Surveys.LBL_SURVEY_TARGET_MODULE'             , 'SURVEY_TARGET_MODULE'       , 0, 1, 'survey_target_module_dom', null, null;
end else begin
	-- 01/01/2016 Paul.  Catalin wants to force page navigation for each question, just like mobile navigation. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.EditView' and DATA_FIELD = 'SURVEY_STYLE' and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS Surveys.EditView: Add SECURITY_CODE.';
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX      = FIELD_INDEX + 2
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'Surveys.EditView'
		   and FIELD_INDEX     >= 6
		   and DELETED          = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Surveys.EditView'       ,  6, 'Surveys.LBL_SURVEY_STYLE'                     , 'SURVEY_STYLE'               , 0, 1, 'survey_style_dom'   , null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Surveys.EditView'       ,  7, null;
	end -- if;
	-- 05/12/2016 Paul.  Add Tags module. 
	exec dbo.spEDITVIEWS_FIELDS_CnvTagSelect   'Surveys.EditView' ,  7, 1, null;
	-- 07/28/2018 Paul.  Add Kiosk mode fields. 
	exec dbo.spEDITVIEWS_FIELDS_InsSeparator   'Surveys.EditView'       ,  9;
	exec dbo.spEDITVIEWS_FIELDS_InsHeader      'Surveys.EditView'       , 10, 'Surveys.LBL_KIOSK_PROPERTIES', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Surveys.EditView'       , 11, 'Surveys.LBL_LOOP_SURVEY'                      , 'LOOP_SURVEY'                , 0, 4,  null, null, null;
	--exec dbo.spEDITVIEWS_FIELDS_InsBound       'Surveys.EditView'       , 12, 'Surveys.LBL_EXIT_CODE'                        , 'EXIT_CODE'                  , 0, 4,  25, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Surveys.EditView'       , 13, 'Surveys.LBL_TIMEOUT'                          , 'TIMEOUT'                    , 0, 4,  10, 10, null;
	-- 09/30/2018 Paul.  Add survey record creation to survey. 
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Surveys.EditView'       , 14, 'Surveys.LBL_SURVEY_TARGET_MODULE'             , 'SURVEY_TARGET_MODULE'       , 0, 1, 'survey_target_module_dom', null, null;
	-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.EditView' and DATA_FIELD = 'SURVEY_TARGET_ASSIGNMENT' and DELETED = 0) begin -- then
		print 'EDITVIEWS_FIELDS Surveys.EditView: Add SURVEY_TARGET_ASSIGNMENT.';
		update EDITVIEWS_FIELDS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'Surveys.EditView'
		   and DATA_FIELD       = 'EXIT_CODE'
		   and DELETED          = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Surveys.EditView'       , 12, 'Surveys.LBL_SURVEY_TARGET_ASSIGNMENT'         , 'SURVEY_TARGET_ASSIGNMENT'   , 1, 1, 'survey_target_assignment_dom', null, null;
	end -- if;
end -- if;
GO

-- 05/31/2013 Paul.  Add Surveys module. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyPages.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyPages.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyPages.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'SurveyPages.EditView', 'SurveyPages', 'vwSURVEY_PAGES_Edit', '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'SurveyPages.EditView'   ,  0, 'SurveyPages.LBL_SURVEY_NAME'                  , 'SURVEY_NAME'                 , null;
	exec dbo.spEDITVIEWS_FIELDS_InsLabel       'SurveyPages.EditView'   ,  1, 'SurveyPages.LBL_PAGE_NUMBER'                  , 'PAGE_NUMBER'                 , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyPages.EditView'   ,  2, 'SurveyPages.LBL_NAME'                         , 'NAME'                        , 0, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyPages.EditView'   ,  3, 'SurveyPages.LBL_QUESTION_RANDOMIZATION'       , 'QUESTION_RANDOMIZATION'      , 0, 1, 'survey_question_randomization', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyPages.EditView'   ,  4, 'SurveyPages.LBL_DESCRIPTION'                  , 'DESCRIPTION'                 , 0, 3,   8, 80, 3;
end -- if;
GO

-- 09/30/2018 Paul.  Add survey record creation to survey. 
-- delete from EDITVIEWS where NAME = 'SurveyQuestions.EditView';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyQuestions.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'SurveyQuestions.EditView', 'SurveyQuestions', 'vwSURVEY_QUESTIONS_Edit', '30%', '70%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'SurveyQuestions.EditView',  0, '.LBL_ASSIGNED_TO'                            , 'ASSIGNED_USER_ID'            , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'SurveyQuestions.EditView',  1, 'Teams.LBL_TEAM'                              , 'TEAM_ID'                     , 0, 1, 'TEAM_NAME'          , 'Teams', null;
--	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.EditView',  2, 'SurveyQuestions.LBL_TARGET_FIELD_NAME'       , 'TARGET_FIELD_NAME'           , 0, 1, 'survey_target_module_dom', null, null;
end -- if;
GO

-- 01/17/2017 Paul.  Add support for Office 365 as an OutboundEmail. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'OutboundEmail.SmtpView' and DELETED = 0) begin -- then
	update EDITVIEWS_FIELDS
	   set DELETED           = 1
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	     , MODIFIED_USER_ID  = null
	 where EDIT_NAME = 'OutboundEmail.EditView';
end -- if;

-- 04/20/2016 Paul.  Add team management to Outbound Emails. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'OutboundEmail.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'OutboundEmail.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS OutboundEmail.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'OutboundEmail.EditView'  , 'OutboundEmail', 'vwOUTBOUND_EMAILS_Edit', '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OutboundEmail.EditView'  ,  0, 'OutboundEmail.LBL_NAME'                      , 'NAME'                        , 1, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'OutboundEmail.EditView'  ,  1, 'Teams.LBL_TEAM'                              , 'TEAM_ID'                     , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OutboundEmail.EditView'  ,  2, 'OutboundEmail.LBL_FROM_NAME'                 , 'FROM_NAME'                   , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OutboundEmail.EditView'  ,  3, 'OutboundEmail.LBL_FROM_ADDR'                 , 'FROM_ADDR'                   , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'OutboundEmail.EditView'  ,  4, 'OutboundEmail.LBL_MAIL_SENDTYPE'             , 'MAIL_SENDTYPE'               , 1, 1, 'outbound_send_type', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'OutboundEmail.EditView'  ,  5, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'OutboundEmail.SmtpView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS OutboundEmail.SmtpView';
	exec dbo.spEDITVIEWS_InsertOnly            'OutboundEmail.SmtpView'  , 'OutboundEmail', 'vwOUTBOUND_EMAILS_Edit', '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OutboundEmail.SmtpView'  ,  1, 'OutboundEmail.LBL_MAIL_SMTPSERVER'           , 'MAIL_SMTPSERVER'             , 1, 1,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OutboundEmail.SmtpView'  ,  2, 'OutboundEmail.LBL_MAIL_SMTPPORT'             , 'MAIL_SMTPPORT'               , 1, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'OutboundEmail.SmtpView'  ,  3, 'OutboundEmail.LBL_MAIL_SMTPAUTH_REQ'         , 'MAIL_SMTPAUTH_REQ'           , 0, 1, 'CheckBox'               , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl     'OutboundEmail.SmtpView'  ,  4, 'OutboundEmail.LBL_MAIL_SMTPSSL'              , 'MAIL_SMTPSSL'                , 0, 1, 'CheckBox'               , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OutboundEmail.SmtpView'  ,  5, 'OutboundEmail.LBL_MAIL_SMTPUSER'             , 'MAIL_SMTPUSER'               , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OutboundEmail.SmtpView'  ,  6, 'OutboundEmail.LBL_MAIL_SMTPPASS'             , 'MAIL_SMTPPASS'               , 1, 1, 100, 25, null;
end -- if;
GO

-- 01/31/2017 Paul.  The ExchangeView is used for validation, not rendering. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'OutboundEmail.ExchangeView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS OutboundEmail.ExchangeView';
	exec dbo.spEDITVIEWS_InsertOnly            'OutboundEmail.ExchangeView', 'OutboundEmail', 'vwOUTBOUND_EMAILS_Edit', '20%', '30%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OutboundEmail.ExchangeView',  1, 'OutboundEmail.LBL_MAIL_SMTPUSER'             , 'MAIL_SMTPUSER'               , 1, 1, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'OutboundEmail.ExchangeView',  2, 'OutboundEmail.LBL_MAIL_SMTPPASS'             , 'MAIL_SMTPPASS'               , 1, 1, 100, 25, null;
end -- if;
GO

-- 10/26/2013 Paul.  Add TwitterTracks module.
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS TwitterTracks.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'TwitterTracks.EditView', 'TwitterTracks', 'vwTWITTER_TRACKS_Edit', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TwitterTracks.EditView'  ,  0, 'TwitterTracks.LBL_NAME'                      , 'NAME'                       , 1, 1,  60, 60, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsValidator   'TwitterTracks.EditView'  ,  0, 'Twitter Track'                               , 'NAME'                       , 'TwitterTracks.ERR_INVALID_TRACK';
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'TwitterTracks.EditView'  ,  1, 'TwitterTracks.LBL_TYPE'                      , 'TYPE'                       , 1, 1, 'twitter_track_type_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'TwitterTracks.EditView'  ,  2, 'TwitterTracks.LBL_STATUS'                    , 'STATUS'                     , 1, 1, 'twitter_track_status_dom', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'TwitterTracks.EditView'  ,  3, '.LBL_ASSIGNED_TO'                            , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'TwitterTracks.EditView'  ,  4, 'Teams.LBL_TEAM'                              , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
--	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TwitterTracks.EditView'  ,  5, 'TwitterTracks.LBL_LOCATION'                  , 'LOCATION'                   , 0, 1,  60, 25, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsBound       'TwitterTracks.EditView'  ,  6, 'TwitterTracks.LBL_TWITTER_SCREEN_NAME'       , 'TWITTER_SCREEN_NAME'        , 0, 1,  15, 25, null;
end -- if;
GO

-- 02/15/2015 Paul.  Change from terminology payment_type_dom to PaymentTypes list for QuickBooks Online. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentTypes.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentTypes.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS PaymentTypes.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'PaymentTypes.EditView', 'PaymentTypes', 'vwPAYMENT_TYPES', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PaymentTypes.EditView'      ,  0, 'PaymentTypes.LBL_NAME'                 , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'PaymentTypes.EditView'      ,  1, 'PaymentTypes.LBL_STATUS'               , 'STATUS'                     , 1, 1, 'payment_type_status_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PaymentTypes.EditView'      ,  2, 'PaymentTypes.LBL_ORDER'                , 'LIST_ORDER'                 , 1, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'PaymentTypes.EditView'      ,  3, null;
end -- if;
GO

-- 02/27/2015 Paul.  Change from terminology payment_terms_dom to PaymentTerms list for QuickBooks Online. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentTerms.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'PaymentTerms.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS PaymentTerms.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'PaymentTerms.EditView', 'PaymentTerms', 'vwPAYMENT_TERMS', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PaymentTerms.EditView'      ,  0, 'PaymentTerms.LBL_NAME'                 , 'NAME'                       , 1, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'PaymentTerms.EditView'      ,  1, 'PaymentTerms.LBL_STATUS'               , 'STATUS'                     , 1, 1, 'payment_term_status_dom'    , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'PaymentTerms.EditView'      ,  2, 'PaymentTerms.LBL_ORDER'                , 'LIST_ORDER'                 , 1, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'PaymentTerms.EditView'      ,  3, null;
end -- if;
GO

-- 01/02/2016 Paul.  Provide a way to import survey questions. 
-- select '	exec dbo.spEDITVIEWS_FIELDS_InsBound       ''SurveyQuestions.ImportView''      ,  0, ''SurveyQuestions.LBL_' + replace(ColumnName, '@', '') + '''' + Space(24 - len(replace(ColumnName, '@', ''))) + ', ''' + replace(ColumnName, '@', '') + '''' + Space(24 - len(replace(ColumnName, '@', ''))) + ', 0, 1,  50, 35, null;' from vwSqlColumns where ObjectName = 'spSURVEY_QUESTIONS_Update' and ColumnName not in ('@ID', '@MODIFIED_USER_ID', '@ASSIGNED_USER_ID', '@TEAM_ID', '@TEAM_SET_LIST')
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.ImportView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.ImportView' and DATA_FIELD = 'DESCRIPTION' and DELETED = 0) begin -- then
	exec dbo.spEDITVIEWS_InsertOnly            'SurveyQuestions.ImportView', 'SurveyQuestions', 'vwSURVEY_QUESTIONS', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView',  0, 'SurveyQuestions.LBL_DESCRIPTION'             , 'DESCRIPTION'             , 1, 1,   4, 90, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'SurveyQuestions.ImportView',  1, 'Teams.LBL_TEAM'                              , 'TEAM_ID'                 , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView',  2, 'SurveyQuestions.LBL_NAME'                    , 'NAME'                    , 0, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'SurveyQuestions.ImportView',  3, '.LBL_ASSIGNED_TO'                            , 'ASSIGNED_USER_ID'        , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView',  4, 'SurveyQuestions.LBL_QUESTION_TYPE'           , 'QUESTION_TYPE'           , 1, 1, 'survey_question_type', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView',  5, 'SurveyQuestions.LBL_DISPLAY_FORMAT'           , 'DISPLAY_FORMAT'         , 0, 1, 'survey_question_format_all', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView',  6, 'SurveyQuestions.LBL_ANSWER_CHOICES'          , 'ANSWER_CHOICES'          , 0, 1,   4, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView',  7, 'SurveyQuestions.LBL_COLUMN_CHOICES'          , 'COLUMN_CHOICES'          , 0, 1,   4, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'SurveyQuestions.ImportView',  8, 'SurveyQuestions.LBL_FORCED_RANKING'          , 'FORCED_RANKING'          , 0, 1,  null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView',  9, 'SurveyQuestions.LBL_INVALID_DATE_MESSAGE'    , 'INVALID_DATE_MESSAGE'    , 0, 1,   1, 90, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView', 10, 'SurveyQuestions.LBL_INVALID_NUMBER_MESSAGE'  , 'INVALID_NUMBER_MESSAGE'  , 0, 1,   1, 90, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'SurveyQuestions.ImportView', 11, 'SurveyQuestions.LBL_NA_ENABLED'              , 'NA_ENABLED'              , 0, 1,  null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView', 12, 'SurveyQuestions.LBL_NA_LABEL'                , 'NA_LABEL'                , 0, 1,   1, 90, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'SurveyQuestions.ImportView', 13, 'SurveyQuestions.LBL_OTHER_ENABLED'           , 'OTHER_ENABLED'           , 0, 1,  null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 14, 'SurveyQuestions.LBL_OTHER_LABEL'             , 'OTHER_LABEL'             , 0, 1, 200, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 15, 'SurveyQuestions.LBL_OTHER_HEIGHT'            , 'OTHER_HEIGHT'            , 0, 1, 'survey_question_field_lines', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 16, 'SurveyQuestions.LBL_OTHER_WIDTH'             , 'OTHER_WIDTH'             , 0, 1, 'survey_question_field_chars', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'SurveyQuestions.ImportView', 17, 'SurveyQuestions.LBL_OTHER_AS_CHOICE'         , 'OTHER_AS_CHOICE'         , 0, 1,  null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'SurveyQuestions.ImportView', 18, 'SurveyQuestions.LBL_OTHER_ONE_PER_ROW'       , 'OTHER_ONE_PER_ROW'       , 0, 1,  null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView', 19, 'SurveyQuestions.LBL_OTHER_REQUIRED_MESSAGE'  , 'OTHER_REQUIRED_MESSAGE'  , 0, 1,   1, 90, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 20, 'SurveyQuestions.LBL_OTHER_VALIDATION_TYPE'   , 'OTHER_VALIDATION_TYPE'   , 0, 1, 'survey_question_validation', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 21, 'SurveyQuestions.LBL_OTHER_VALIDATION_MIN'    , 'OTHER_VALIDATION_MIN'    , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 22, 'SurveyQuestions.LBL_OTHER_VALIDATION_MAX'    , 'OTHER_VALIDATION_MAX'    , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView', 23, 'SurveyQuestions.LBL_OTHER_VALIDATION_MESSAGE', 'OTHER_VALIDATION_MESSAGE', 0, 1,   1, 90, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'SurveyQuestions.ImportView', 24, 'SurveyQuestions.LBL_REQUIRED'                , 'REQUIRED'                , 0, 1,  null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 25, 'SurveyQuestions.LBL_REQUIRED_TYPE'           , 'REQUIRED_TYPE'           , 0, 1, 'survey_question_required_rows', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 26, 'SurveyQuestions.LBL_REQUIRED_RESPONSES_MIN'  , 'REQUIRED_RESPONSES_MIN'  , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 27, 'SurveyQuestions.LBL_REQUIRED_RESPONSES_MAX'  , 'REQUIRED_RESPONSES_MAX'  , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView', 28, 'SurveyQuestions.LBL_REQUIRED_MESSAGE'        , 'REQUIRED_MESSAGE'        , 0, 1,   1, 90, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 29, 'SurveyQuestions.LBL_VALIDATION_TYPE'         , 'VALIDATION_TYPE'         , 0, 1, 'survey_question_validation', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 30, 'SurveyQuestions.LBL_VALIDATION_MIN'          , 'VALIDATION_MIN'          , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 31, 'SurveyQuestions.LBL_VALIDATION_MAX'          , 'VALIDATION_MAX'          , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 32, 'SurveyQuestions.LBL_VALIDATION_MESSAGE'      , 'VALIDATION_MESSAGE'      , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'SurveyQuestions.ImportView', 33, 'SurveyQuestions.LBL_VALIDATION_SUM_ENABLED'  , 'VALIDATION_SUM_ENABLED'  , 0, 1,  null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 34, 'SurveyQuestions.LBL_VALIDATION_NUMERIC_SUM'  , 'VALIDATION_NUMERIC_SUM'  , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 35, 'SurveyQuestions.LBL_VALIDATION_SUM_MESSAGE'  , 'VALIDATION_SUM_MESSAGE'  , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 36, 'SurveyQuestions.LBL_RANDOMIZE_TYPE'          , 'RANDOMIZE_TYPE'          , 0, 1, 'survey_answer_randomization', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'SurveyQuestions.ImportView', 37, 'SurveyQuestions.LBL_RANDOMIZE_NOT_LAST'      , 'RANDOMIZE_NOT_LAST'      , 0, 1,  null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 38, 'SurveyQuestions.LBL_SIZE_WIDTH'              , 'SIZE_WIDTH'              , 0, 1,  10, 10, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 39, 'SurveyQuestions.LBL_SIZE_HEIGHT'             , 'SIZE_HEIGHT'             , 0, 1, 'survey_question_field_lines', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 40, 'SurveyQuestions.LBL_BOX_WIDTH'               , 'BOX_WIDTH'               , 0, 1, 'survey_question_field_chars', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 40, 'SurveyQuestions.LBL_BOX_HEIGHT'              , 'BOX_HEIGHT'              , 0, 1, 'survey_question_field_lines', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 41, 'SurveyQuestions.LBL_COLUMN_WIDTH'            , 'COLUMN_WIDTH'            , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 41, 'SurveyQuestions.LBL_COLUMN_WIDTH'            , 'COLUMN_WIDTH'            , 0, 1, 'survey_question_columns_width', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 41, 'SurveyQuestions.LBL_PLACEMENT'               , 'PLACEMENT'               , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'SurveyQuestions.ImportView', 42, 'SurveyQuestions.LBL_PLACEMENT'               , 'PLACEMENT'               , 0, 1, 'survey_question_placement', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 43, 'SurveyQuestions.LBL_SPACING_LEFT'            , 'SPACING_LEFT'            , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 44, 'SurveyQuestions.LBL_SPACING_TOP'             , 'SPACING_TOP'             , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 45, 'SurveyQuestions.LBL_SPACING_RIGHT'           , 'SPACING_RIGHT'           , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 46, 'SurveyQuestions.LBL_SPACING_BOTTOM'          , 'SPACING_BOTTOM'          , 0, 1,  50, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'SurveyQuestions.ImportView', 47, 'SurveyQuestions.LBL_IMAGE_URL'               , 'IMAGE_URL'               , 0, 1,1000, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'SurveyQuestions.ImportView', 48, 'SurveyQuestions.LBL_CATEGORIES'              , 'CATEGORIES'              , 0, 1,   2, 90, null;
end -- if;
GO

-- 03/27/2020 Paul.  Convert to dynamic layout to support React Client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Reports.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Reports.EditView'       , 'Reports'      , 'vwREPORTS_Edit'      , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Reports.EditView'       ,  0, 'Reports.LBL_REPORT_NAME'               , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Reports.EditView'       ,  1, '.LBL_ASSIGNED_TO'                      , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Reports.EditView'       ,  2, 'Teams.LBL_TEAM'                        , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsCheckBox    'Reports.EditView'       ,  3, 'Reports.LBL_SHOW_QUERY'                , 'SHOW_QUERY'                 , 0, 1, null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Reports.EditView'       ,  4, 'ReportDesigner.LBL_PAGE_WIDTH'         , 'PAGE_WIDTH'                 , 1, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Reports.EditView'       ,  5, 'ReportDesigner.LBL_PAGE_HEIGHT'        , 'PAGE_HEIGHT'                , 1, 1,  25, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Reports.EditView'       ,  6, 'ReportRules.LBL_TABLE_LOAD_EVENT_NAME' , 'PRE_LOAD_EVENT_ID'          , 0, null, 'PRE_LOAD_EVENT_NAME'  , 'ReportRules', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Reports.EditView'       ,  7, 'ReportRules.LBL_ROW_LOAD_EVENT_NAME'   , 'POST_LOAD_EVENT_ID'         , 0, null, 'POST_LOAD_EVENT_NAME' , 'ReportRules', null;
	-- 05/18/2021 Paul.  Popups are not handled this way in React client. 
	--exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick  null, 'Reports.EventsEditView', 'PRE_LOAD_EVENT_ID'  , 'return PreLoadEventPopup();'   ;
	--exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick  null, 'Reports.EventsEditView', 'POST_LOAD_EVENT_ID' , 'return PostLoadEventPopup();'  ;
end -- if;
GO

-- 12/17/2020 Paul.  Convert to dynamic layout to support React Client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.ImportView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.ImportView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Reports.ImportView';
	exec dbo.spEDITVIEWS_InsertOnly            'Reports.ImportView'     , 'Reports'      , 'vwREPORTS_Edit'      , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Reports.ImportView'     ,  0, 'Reports.LBL_MODULE_NAME'               , 'MODULE'                     , 1, 1, 'ReportingModules'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Reports.ImportView'     ,  1, 'Reports.LBL_REPORT_NAME'               , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Reports.ImportView'     ,  2, '.LBL_ASSIGNED_TO'                      , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Reports.ImportView'     ,  3, 'Teams.LBL_TEAM'                        , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsFile        'Reports.ImportView'     ,  4, 'Import.LBL_SELECT_FILE'                , 'RDL'                        , 0, 1, 255, 300, 3;
end -- if;
GO

-- 05/18/2021 Paul.  Convert to dynamic layout to support React Client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Charts.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Chart.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Charts.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'Charts.EditView'       , 'Charts'      , 'vwCHARTS_Edit'      , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Charts.EditView'       ,  0, 'Charts.LBL_CHART_NAME'                 , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Charts.EditView'       ,  1, '.LBL_ASSIGNED_TO'                      , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Charts.EditView'       ,  2, 'Teams.LBL_TEAM'                        , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'Charts.EditView'       ,  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Charts.EditView'       ,  4, 'ReportRules.LBL_TABLE_LOAD_EVENT_NAME' , 'PRE_LOAD_EVENT_ID'          , 0, null, 'PRE_LOAD_EVENT_NAME'  , 'ReportRules', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Charts.EditView'       ,  5, 'ReportRules.LBL_ROW_LOAD_EVENT_NAME'   , 'POST_LOAD_EVENT_ID'         , 0, null, 'POST_LOAD_EVENT_NAME' , 'ReportRules', null;
end -- if;
GO

-- 05/18/2021 Paul.  Convert to dynamic layout to support React Client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Charts.ImportView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Charts.ImportView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Charts.ImportView';
	exec dbo.spEDITVIEWS_InsertOnly            'Charts.ImportView'     , 'Charts'      , 'vwCHARTS_Edit'      , '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Charts.ImportView'     ,  0, 'Charts.LBL_MODULE_NAME'                , 'MODULE_NAME'                , 1, 1, 'ReportingModules'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Charts.ImportView'     ,  1, 'Charts.LBL_REPORT_NAME'                , 'NAME'                       , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Charts.ImportView'     ,  2, '.LBL_ASSIGNED_TO'                      , 'ASSIGNED_USER_ID'           , 0, 1, 'ASSIGNED_TO_NAME'   , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup 'Charts.ImportView'     ,  3, 'Teams.LBL_TEAM'                        , 'TEAM_ID'                    , 0, 1, 'TEAM_NAME'          , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsFile        'Charts.ImportView'     ,  4, 'Import.LBL_SELECT_FILE'                , 'RDL'                        , 0, 1, 255, 300, 3;
end else begin
	-- 06/05/2021 Paul.  Correct MODULE_NAME field. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Charts.ImportView' and DATA_FIELD = 'MODULE' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FIELD        = 'MODULE_NAME'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where EDIT_NAME         = 'Charts.ImportView'
		   and DATA_FIELD        = 'MODULE'
		   and DELETED           = 0;
	end -- if;	
end -- if;
GO

-- 06/05/2021 Paul.  Convert to dynamic layout to support React Client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ModulesArchiveRules.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ModulesArchiveRules.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ModulesArchiveRules.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'ModulesArchiveRules.EditView', 'ModulesArchiveRules'      , 'vwMODULES_ARCHIVE_RULES', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'ModulesArchiveRules.EditView',  0, 'ModulesArchiveRules.LBL_NAME'       , 'NAME'                    , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ModulesArchiveRules.EditView',  1, 'ModulesArchiveRules.LBL_MODULE_NAME', 'MODULE_NAME'             , 1, 1, 'RulesModules'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'ModulesArchiveRules.EditView',  2, 'ModulesArchiveRules.LBL_DESCRIPTION', 'DESCRIPTION'             , 0, 1,   4, 60, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'ModulesArchiveRules.EditView',  3, 'ModulesArchiveRules.LBL_STATUS'     , 'STATUS'                  , 1, 1, 'archive_rule_status_dom'    , null, null;
end -- if;
GO

-- 06/06/2021 Paul.  Convert to dynamic layout to support React Client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'BusinessRules.EditView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'BusinessRules.EditView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS BusinessRules.EditView';
	exec dbo.spEDITVIEWS_InsertOnly            'BusinessRules.EditView', 'BusinessRules'      , 'vwBUSINESS_RULES', '15%', '35%', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'BusinessRules.EditView'      ,  0, 'Rules.LBL_NAME'                     , 'NAME'                    , 1, 1, 150, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'BusinessRules.EditView'      ,  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'BusinessRules.EditView'      ,  2, 'Rules.LBL_MODULE_NAME'              , 'MODULE_NAME'             , 1, 1, 'RulesModules'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank       'BusinessRules.EditView'      ,  3, null;
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

call dbo.spEDITVIEWS_FIELDS_Professional()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_Professional')
/

-- #endif IBM_DB2 */




print 'EDITVIEWS_FIELDS Search Professional';
-- delete from EDITVIEWS_FIELDS where EDIT_NAME like '%.Search%'
--GO

set nocount on;
GO

-- 12/17/2007 Paul.  Add support for Date Range searches. 
-- 02/10/2008 Paul.  Numeric fields should be smaller than regular text fields. 
-- 08/22/2008 Paul.  Move professional modules to a separate file. 
-- 09/10/2009 Paul.  Add support for AutoComplete. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 
-- 03/31/2012 Paul.  Add support for searching favorites. 

-- 05/15/2016 Paul.  Add tags to advanced search. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchAdvanced';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'Contracts.SearchAdvanced', 'Contracts', 'vwCONTRACTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Contracts.SearchAdvanced',  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 0, null, 255, 25, 'Contracts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Contracts.SearchAdvanced',  1, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Contracts.SearchAdvanced',  2, 'Contracts.LBL_START_DATE'               , 'START_DATE'                 , 0, null, 'DateRange'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Contracts.SearchAdvanced',  3, 'Contracts.LBL_END_DATE'                 , 'END_DATE'                   , 0, null, 'DateRange'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Contracts.SearchAdvanced',  4, 'Contracts.LBL_STATUS'                   , 'STATUS'                     , 0, null, 'contract_status_dom', null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Contracts.SearchAdvanced',  5, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'       , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Contracts.SearchAdvanced',  6, 0, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Contracts.SearchAdvanced',  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 0, null, 255, 25, 'Contracts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup  'Contracts.SearchAdvanced',  1, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	-- 05/15/2016 Paul.  Add tags to advanced search. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchAdvanced' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Contracts.SearchAdvanced',  6, 0, null;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Contracts.SearchBasic'   , 'Contracts', 'vwCONTRACTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Contracts.SearchBasic'   ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Contracts.SearchBasic'   ,  1, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Contracts.SearchBasic'   ,  2, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox'    , 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Contracts.SearchBasic'   ,  3, 'Contracts.LBL_STATUS'                   , 'STATUS'                     , 0, null, 'contract_status_dom', null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Contracts.SearchBasic'   ,  4, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup  'Contracts.SearchBasic'   ,  1, 'Contracts.LBL_ACCOUNT_NAME'             , 'ACCOUNT_ID'                 , 0, null, 'ACCOUNT_NAME'     , 'Accounts', null;
	-- 12/29/2016 Paul.  Need to prevent duplicate fields.  
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchBasic' and DATA_FIELD = 'FAVORITE_RECORD_ID' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'Contracts.SearchBasic'   ,  4, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
	end -- if;
	-- 06/23/2010 Paul.  Fix module name. 
	if exists(select * from EDITVIEWS where NAME = 'Contracts.SearchBasic' and MODULE_NAME = 'Contacts') begin -- then
		update EDITVIEWS
		   set MODULE_NAME       = 'Contracts'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getdate()
		     , MODIFIED_USER_ID  = null
		 where NAME              = 'Contracts.SearchBasic'
		   and MODULE_NAME       = 'Contacts'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Contracts.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Contracts.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Contracts.SearchPopup'   , 'Contracts', 'vwCONTRACTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Contracts.SearchPopup'   ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 0, null, 255, 25, 'Contracts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Contracts.SearchPopup'   ,  1, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts' , null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Contracts.SearchPopup'   ,  0, 'Contracts.LBL_NAME'                     , 'NAME'                       , 0, null, 255, 25, 'Contracts', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Contracts.SearchPopup'   ,  1, 'Contacts.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts' , null;
	-- 06/23/2010 Paul.  Fix module name. 
	if exists(select * from EDITVIEWS where NAME = 'Contracts.SearchPopup' and MODULE_NAME = 'Contacts') begin -- then
		update EDITVIEWS
		   set MODULE_NAME       = 'Contracts'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getdate()
		     , MODIFIED_USER_ID  = null
		 where NAME              = 'Contracts.SearchPopup'
		   and MODULE_NAME       = 'Contacts'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Forums.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Forums.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Forums.SearchBasic'      , 'Forums', 'vwFORUMS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Forums.SearchBasic'      ,  0, 'Forums.LBL_TITLE'                       , 'TITLE'                      , 0, null, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Forums.SearchBasic'      ,  1, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'    , null, 6;
end -- if;
GO

-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
-- 05/15/2016 Paul.  Add tags to advanced search. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'Invoices.SearchAdvanced' , 'Invoices', 'vwINVOICES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Invoices.SearchAdvanced' ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Invoices.SearchAdvanced' ,  1, 'Invoices.LBL_INVOICE_NUM'               , 'INVOICE_NUM'                , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Invoices.SearchAdvanced' ,  2, 'Invoices.LBL_ACCOUNT_NAME'              , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Invoices.SearchAdvanced' ,  3, 'Invoices.LBL_TOTAL'                     , 'TOTAL'                      , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Invoices.SearchAdvanced' ,  4, 'Invoices.LBL_DUE_DATE'                  , 'DUE_DATE'                   , 0, null, 'DateRange'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Invoices.SearchAdvanced' ,  5, 'Invoices.LBL_INVOICE_STAGE'             , 'INVOICE_STAGE'              , 0, null, 'invoice_stage_dom'  , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Invoices.SearchAdvanced' ,  6, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'       , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Invoices.SearchAdvanced' ,  7, 0, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Invoices.SearchAdvanced' ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup  'Invoices.SearchAdvanced' ,  2, 'Invoices.LBL_ACCOUNT_NAME'              , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchAdvanced' and DATA_FIELD = 'ACCOUNT_ID' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FIELD        = 'BILLING_ACCOUNT_ID'
		     , DISPLAY_FIELD     = 'BILLING_ACCOUNT_NAME'
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Invoices.SearchAdvanced'
		   and DATA_FIELD        = 'ACCOUNT_ID'
		   and DELETED           = 0;
	end -- if;
	-- 05/15/2016 Paul.  Add tags to advanced search. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchAdvanced' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Invoices.SearchAdvanced' ,  7, 0, null;
	end -- if;
end -- if;
GO

-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Invoices.SearchBasic'    , 'Invoices', 'vwINVOICES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Invoices.SearchBasic'    ,  0, 'Invoices.LBL_INVOICE_NUM'               , 'INVOICE_NUM'                , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Invoices.SearchBasic'    ,  1, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Invoices.SearchBasic'    ,  2, 'Invoices.LBL_ACCOUNT_NAME'              , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Invoices.SearchBasic'    ,  3, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Invoices.SearchBasic'    ,  4, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Invoices.SearchBasic'    ,  1, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup  'Invoices.SearchBasic'    ,  2, 'Invoices.LBL_ACCOUNT_NAME'              , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	-- 12/29/2016 Paul.  Need to prevent duplicate fields.  
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchBasic' and DATA_FIELD = 'FAVORITE_RECORD_ID' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'Invoices.SearchBasic'    ,  4, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
	end -- if;
	-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchBasic' and DATA_FIELD = 'ACCOUNT_ID' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FIELD        = 'BILLING_ACCOUNT_ID'
		     , DISPLAY_FIELD     = 'BILLING_ACCOUNT_NAME'
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Invoices.SearchBasic'
		   and DATA_FIELD        = 'ACCOUNT_ID'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 08/05/2010 Paul.  Change the Account to be a ModulePopup. 
-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Invoices.SearchPopup'    , 'Invoices', 'vwINVOICES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Invoices.SearchPopup'    ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Invoices.SearchPopup'    ,  1, 'Invoices.LBL_ACCOUNT_NAME'              , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Invoices.SearchPopup'    ,  0, 'Invoices.LBL_NAME'                      , 'NAME'                       , 0, null,  50, 25, 'Invoices', null;
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchPopup' and DATA_FIELD = 'ACCOUNT_NAME' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Invoices.SearchPopup'
		   and DATA_FIELD        = 'ACCOUNT_NAME'
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Invoices.SearchPopup'    ,  1, 'Invoices.LBL_ACCOUNT_NAME'              , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	end -- if;
	-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchPopup' and DATA_FIELD = 'ACCOUNT_ID' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FIELD        = 'BILLING_ACCOUNT_ID'
		     , DISPLAY_FIELD     = 'BILLING_ACCOUNT_NAME'
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Invoices.SearchPopup'
		   and DATA_FIELD        = 'ACCOUNT_ID'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
-- 05/15/2016 Paul.  Add tags to advanced search. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'Orders.SearchAdvanced'   , 'Orders', 'vwORDERS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Orders.SearchAdvanced'   ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Orders.SearchAdvanced'   ,  1, 'Orders.LBL_ORDER_NUM'                   , 'ORDER_NUM'                  , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Orders.SearchAdvanced'   ,  2, 'Orders.LBL_ACCOUNT_NAME'                , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Orders.SearchAdvanced'   ,  3, 'Orders.LBL_TOTAL'                       , 'TOTAL'                      , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Orders.SearchAdvanced'   ,  4, 'Orders.LBL_ORDER_TYPE'                  , 'ORDER_TYPE'                 , 0, null, 'order_type_dom'      , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Orders.SearchAdvanced'   ,  5, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'        , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Orders.SearchAdvanced'   ,  6, 'Orders.LBL_DATE_ORDER_DUE'              , 'DATE_ORDER_DUE'             , 0, null, 'DateRange'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Orders.SearchAdvanced'   ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'          , 'DATE_ORDER_SHIPPED'         , 0, null, 'DateRange'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Orders.SearchAdvanced'   ,  8, 0, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Orders.SearchAdvanced'   ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup  'Orders.SearchAdvanced'   ,  2, 'Orders.LBL_ACCOUNT_NAME'                , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	-- 01/17/2008 Paul. Fix date searching. DATE_ORDER_DUE
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchAdvanced' and DATA_FIELD = 'DATE_ORDER_EXPECTED_CLOSED' and DELETED = 0) begin -- then
		print 'Fixing the date fields in Orders.SearchAdvanced.';
		update EDITVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Orders.SearchAdvanced'
		   and DATA_FIELD        = 'DATE_ORDER_EXPECTED_CLOSED'
		   and DELETED           = 0;
		update EDITVIEWS_FIELDS
		   set FIELD_INDEX       = 5
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Orders.SearchAdvanced'
		   and DATA_FIELD        = 'ASSIGNED_USER_ID'
		   and FIELD_INDEX       = 6
		   and DELETED           = 0;
		update EDITVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Orders.SearchAdvanced'
		   and DATA_FIELD        = 'SALES_STAGE'
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'Orders.SearchAdvanced'   ,  6, 'Orders.LBL_DATE_ORDER_DUE'              , 'DATE_ORDER_DUE'             , 0, null, 'DateRange'           , null, null, null;
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'Orders.SearchAdvanced'   ,  7, 'Orders.LBL_DATE_ORDER_SHIPPED'          , 'DATE_ORDER_SHIPPED'         , 0, null, 'DateRange'           , null, null, null;
	end -- if;
	-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchAdvanced' and DATA_FIELD = 'ACCOUNT_ID' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FIELD        = 'BILLING_ACCOUNT_ID'
		     , DISPLAY_FIELD     = 'BILLING_ACCOUNT_NAME'
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Orders.SearchAdvanced'
		   and DATA_FIELD        = 'ACCOUNT_ID'
		   and DELETED           = 0;
	end -- if;
	-- 05/15/2016 Paul.  Add tags to advanced search. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchAdvanced' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Orders.SearchAdvanced'   ,  8, 0, null;
	end -- if;
end -- if;
GO

-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Orders.SearchBasic'      , 'Orders', 'vwORDERS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Orders.SearchBasic'      ,  0, 'Orders.LBL_ORDER_NUM'                   , 'ORDER_NUM'                  , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Orders.SearchBasic'      ,  1, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Orders.SearchBasic'      ,  2, 'Orders.LBL_ACCOUNT_NAME'                , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Orders.SearchBasic'      ,  3, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Orders.SearchBasic'      ,  4, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Orders.SearchBasic'      ,  1, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup  'Orders.SearchBasic'      ,  2, 'Orders.LBL_ACCOUNT_NAME'                , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	-- 12/29/2016 Paul.  Need to prevent duplicate fields.  
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchBasic' and DATA_FIELD = 'FAVORITE_RECORD_ID' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'Orders.SearchBasic'      ,  4, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
	end -- if;
	-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchBasic' and DATA_FIELD = 'ACCOUNT_ID' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FIELD        = 'BILLING_ACCOUNT_ID'
		     , DISPLAY_FIELD     = 'BILLING_ACCOUNT_NAME'
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Orders.SearchBasic'
		   and DATA_FIELD        = 'ACCOUNT_ID'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Orders.SearchPopup'      , 'Orders', 'vwORDERS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Orders.SearchPopup'      ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders'  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Orders.SearchPopup'      ,  1, 'Orders.LBL_ACCOUNT_NAME'                , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Orders.SearchPopup'      ,  0, 'Orders.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Orders'  , null;
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Orders.SearchPopup'      ,  1, 'Orders.LBL_ACCOUNT_NAME'                , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Payments.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Payments.SearchBasic'    , 'Payments' , 'vwPAYMENTS_Edit' , '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.SearchBasic'    ,  0, 'Payments.LBL_AMOUNT'                    , 'AMOUNT'                     , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Payments.SearchBasic'    ,  1, 'Payments.LBL_PAYMENT_DATE'              , 'PAYMENT_DATE'               , 0, null, 'DateRange' , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Payments.SearchBasic'    ,  2, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox'  , 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Payments.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Payments.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Payments.SearchPopup'    , 'Payments' , 'vwPAYMENTS_Edit' , '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Payments.SearchPopup'    ,  0, 'Payments.LBL_AMOUNT'                    , 'AMOUNT'                     , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Payments.SearchPopup'    ,  1, 'Payments.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Payments.SearchPopup'    ,  1, 'Payments.LBL_ACCOUNT_NAME'              , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Posts.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Posts.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Posts.SearchBasic'       , 'Posts', 'vwPOSTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Posts.SearchBasic'       ,  0, 'Posts.LBL_TITLE'                        , 'TITLE'                      , 0, null, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'Posts.SearchBasic'       ,  1, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Products.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'Products.SearchAdvanced' , 'Products', 'vwPRODUCTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Products.SearchAdvanced' ,  0, 'Products.LBL_NAME'                      , 'NAME'                       , 0, null, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Products.SearchAdvanced' ,  1, 'Products.LBL_TAX_CLASS'                 , 'TAX_CLASS'                  , 0, null, 'tax_class_dom'     , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Products.SearchAdvanced' ,  2, 'ProductTemplates.LBL_TYPE'              , 'TYPE_ID'                    , 0, null, 'ProductTypes'      , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Products.SearchAdvanced' ,  3, 'Products.LBL_MANUFACTURER'              , 'MANUFACTURER'               , 0, null, 'Manufacturers'     , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Products.SearchAdvanced' ,  4, 'Products.LBL_MFT_PART_NUM'              , 'MFT_PART_NUM'               , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Products.SearchAdvanced' ,  5, 'Products.LBL_VENDOR_PART_NUM'           , 'VENDOR_PART_NUM'            , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Products.SearchAdvanced' ,  6, 'Products.LBL_CATEGORY'                  , 'CATEGORY_ID'                , 0, null, 'ProductCategories' , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Products.SearchAdvanced' ,  7, 'Products.LBL_SUPPORT_TERM'              , 'SUPPORT_TERM'               , 0, null, 255, 25, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Products.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Products.SearchBasic'    , 'Products', 'vwPRODUCTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Products.SearchBasic'    ,  0, 'Products.LBL_NAME'                      , 'NAME'                       , 0, null, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Products.SearchBasic'    ,  1, 'Products.LBL_MFT_PART_NUM'              , 'MFT_PART_NUM'               , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Products.SearchBasic'    ,  2, 'Products.LBL_CATEGORY'                  , 'CATEGORY_NAME'              , 0, null,  50, 25, null;
end -- if;
GO

-- 05/06/2009 Paul.  The type and category should be lists. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.SearchPopup';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Products.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Products.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Products.SearchPopup'    , 'Products', 'vwPRODUCTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Products.SearchPopup'    ,  0, 'Products.LBL_NAME'                      , 'NAME'                       , 0, null, 100, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Products.SearchPopup'    ,  1, 'Products.LBL_TYPE'                      , 'TYPE_ID'                    , 0, null, 'ProductTypes'      , null, 4;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Products.SearchPopup'    ,  2, 'Products.LBL_MANUFACTURER'              , 'MANUFACTURER_NAME'          , 0, null,  50, 25, 'Manufacturers', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Products.SearchPopup'    ,  3, 'Products.LBL_CATEGORY'                  , 'CATEGORY_ID'                , 0, null, 'ProductCategories' , null, 4;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Products.SearchPopup'    ,  2, 'Products.LBL_MANUFACTURER'              , 'MANUFACTURER_NAME'          , 0, null,  50, 25, 'Manufacturers', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTemplates.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'ProductTemplates.SearchAdvanced', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'ProductTemplates.SearchAdvanced',  0, 'ProductTemplates.LBL_NAME'             , 'NAME'                       , 0, null, 100, 25, 'ProductTemplates', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchAdvanced',  1, 'ProductTemplates.LBL_CATEGORY'         , 'CATEGORY_NAME'              , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'ProductTemplates.SearchAdvanced',  2, 'ProductTemplates.LBL_TAX_CLASS'        , 'TAX_CLASS'                  , 0, null, 'tax_class_dom'     , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'ProductTemplates.SearchAdvanced',  3, 'ProductTemplates.LBL_STATUS'           , 'STATUS'                     , 0, null, 'product_template_status_dom', null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'ProductTemplates.SearchAdvanced',  4, 'ProductTemplates.LBL_MANUFACTURER'     , 'MANUFACTURER'               , 0, null, 'Manufacturers'     , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchAdvanced',  5, 'ProductTemplates.LBL_MFT_PART_NUM'     , 'MFT_PART_NUM'               , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'ProductTemplates.SearchAdvanced',  6, 'ProductTemplates.LBL_DATE_COST_PRICE'  , 'DATE_COST_PRICE'            , 0, null, 'DateRange'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchAdvanced',  7, 'ProductTemplates.LBL_VENDOR_PART_NUM'  , 'VENDOR_PART_NUM'            , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'ProductTemplates.SearchAdvanced',  8, 'ProductTemplates.LBL_TYPE'             , 'TYPE_ID'                    , 0, null, 'ProductTypes'      , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchAdvanced',  9, 'ProductTemplates.LBL_SUPPORT_CONTACT'  , 'SUPPORT_CONTACT'            , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'ProductTemplates.SearchAdvanced', 10, 'ProductTemplates.LBL_DATE_AVAILABLE'   , 'DATE_AVAILABLE'             , 0, null, 'DateRange'         , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchAdvanced', 11, 'ProductTemplates.LBL_WEBSITE'          , 'WEBSITE'                    , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchAdvanced', 12, 'ProductTemplates.LBL_SUPPORT_TERM'     , 'SUPPORT_TERM'               , 0, null, 255, 25, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'ProductTemplates.SearchAdvanced',  0, 'ProductTemplates.LBL_NAME'             , 'NAME'                       , 0, null, 100, 25, 'ProductTemplates', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTemplates.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'ProductTemplates.SearchBasic'   , 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'ProductTemplates.SearchBasic'   ,  0, 'ProductTemplates.LBL_NAME'             , 'NAME'                       , 0, null, 100, 25, 'ProductTemplates', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchBasic'   ,  1, 'ProductTemplates.LBL_MFT_PART_NUM'     , 'MFT_PART_NUM'               , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchBasic'   ,  2, 'ProductTemplates.LBL_CATEGORY'         , 'CATEGORY_NAME'              , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'ProductTemplates.SearchBasic'   ,  3, '.LBL_FAVORITES_FILTER'                 , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'ProductTemplates.SearchBasic'   ,  0, 'ProductTemplates.LBL_NAME'             , 'NAME'                       , 0, null, 100, 25, 'ProductTemplates', null;
	-- 12/29/2016 Paul.  Need to prevent duplicate fields.  
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.SearchBasic' and DATA_FIELD = 'FAVORITE_RECORD_ID' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'ProductTemplates.SearchBasic'   ,  3, '.LBL_FAVORITES_FILTER'                 , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTemplates.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'ProductTemplates.SearchPopup'   , 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'ProductTemplates.SearchPopup'   ,  0, 'ProductTemplates.LBL_NAME'             , 'NAME'                       , 0, null, 100, 25, 'ProductTemplates', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchPopup'   ,  1, 'ProductTemplates.LBL_TYPE'             , 'TYPE_NAME'                  , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchPopup'   ,  3, 'ProductTemplates.LBL_CATEGORY'         , 'CATEGORY_NAME'              , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'ProductTemplates.SearchPopup'   ,  2, 'ProductTemplates.LBL_MANUFACTURER'     , 'MANUFACTURER_NAME'          , 0, null,  50, 25, 'Manufacturers'   , null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'ProductTemplates.SearchPopup'   ,  0, 'ProductTemplates.LBL_NAME'             , 'NAME'                       , 0, null, 100, 25, 'ProductTemplates', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'ProductTemplates.SearchPopup'   ,  2, 'ProductTemplates.LBL_MANUFACTURER'     , 'MANUFACTURER_NAME'          , 0, null,  50, 25, 'Manufacturers'   , null;
end -- if;
GO

-- 05/21/2012 Paul.  Allow duplicates searching of ProductTemplates. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.SearchDuplicates';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ProductTemplates.SearchDuplicates' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ProductTemplates.SearchDuplicates';
	exec dbo.spEDITVIEWS_InsertOnly             'ProductTemplates.SearchDuplicates', 'ProductTemplates', 'vwPRODUCT_TEMPLATES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'ProductTemplates.SearchDuplicates',  0, 'ProductTemplates.LBL_NAME'             , 'NAME'                       , 0, null, 100, 25, 'ProductTemplates', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ProductTemplates.SearchDuplicates',  1, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchDuplicates',  2, 'ProductTemplates.LBL_MFT_PART_NUM'     , 'MFT_PART_NUM'               , 0, null,  50, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ProductTemplates.SearchDuplicates',  3, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ProductTemplates.SearchDuplicates',  4, 'ProductTemplates.LBL_VENDOR_PART_NUM'  , 'VENDOR_PART_NUM'            , 0, null,  50, 25, null;
end -- if;
GO

-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
-- 05/15/2016 Paul.  Add tags to advanced search. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'Quotes.SearchAdvanced'   , 'Quotes', 'vwQUOTES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Quotes.SearchAdvanced'   ,  0, 'Quotes.LBL_QUOTE_NUM'                   , 'QUOTE_NUM'                  , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Quotes.SearchAdvanced'   ,  1, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Orders.SearchAdvanced'   ,  2, 'Orders.LBL_ACCOUNT_NAME'                , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Quotes.SearchAdvanced'   ,  3, 'Quotes.LBL_TOTAL'                       , 'TOTAL'                      , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Quotes.SearchAdvanced'   ,  4, 'Quotes.LBL_QUOTE_TYPE'                  , 'QUOTE_TYPE'                 , 0, null, 'quote_type_dom'      , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Quotes.SearchAdvanced'   ,  5, 'Quotes.LBL_DATE_VALID_UNTIL'            , 'DATE_QUOTE_EXPECTED_CLOSED' , 0, null, 'DateRange'           , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Quotes.SearchAdvanced'   ,  6, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'        , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Quotes.SearchAdvanced'   ,  7, 'Quotes.LBL_QUOTE_STAGE'                 , 'QUOTE_STAGE'                , 0, null, 'quote_stage_dom'     , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Quotes.SearchAdvanced'   ,  8, 0, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Quotes.SearchAdvanced'   ,  1, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup  'Quotes.SearchAdvanced'   ,  2, 'Orders.LBL_ACCOUNT_NAME'                , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	-- 03/25/2008 Paul.  Fix Quote Stage. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchAdvanced' and DATA_FIELD = 'SALES_STAGE' and UI_REQUIRED = 0 and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_LABEL       = 'Quotes.LBL_QUOTE_STAGE'
		     , DATA_FIELD       = 'QUOTE_STAGE'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'Quotes.SearchAdvanced'
		   and DATA_FIELD       = 'SALES_STAGE'
		   and UI_REQUIRED      = 0
		   and DELETED          = 0;
	end -- if;
	-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchAdvanced' and DATA_FIELD = 'ACCOUNT_ID' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FIELD        = 'BILLING_ACCOUNT_ID'
		     , DISPLAY_FIELD     = 'BILLING_ACCOUNT_NAME'
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Quotes.SearchAdvanced'
		   and DATA_FIELD        = 'ACCOUNT_ID'
		   and DELETED           = 0;
	end -- if;
	-- 05/15/2016 Paul.  Add tags to advanced search. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchAdvanced' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Quotes.SearchAdvanced'   ,  8, 0, null;
	end -- if;
end -- if;
GO

-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Quotes.SearchBasic'      , 'Quotes', 'vwQUOTES_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Quotes.SearchBasic'      ,  0, 'Quotes.LBL_QUOTE_NUM'                   , 'QUOTE_NUM'                  , 0, null,  10, 15, null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Quotes.SearchBasic'      ,  1, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Quotes.SearchBasic'      ,  2, 'Quotes.LBL_ACCOUNT_NAME'                , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Quotes.SearchBasic'      ,  3, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Quotes.SearchBasic'      ,  4, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Quotes.SearchBasic'      ,  1, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvModulePopup  'Quotes.SearchBasic'      ,  2, 'Quotes.LBL_ACCOUNT_NAME'                , 'BILLING_ACCOUNT_ID'         , 0, null, 'BILLING_ACCOUNT_NAME', 'Accounts', null;
	-- 12/29/2016 Paul.  Need to prevent duplicate fields.  
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchBasic' and DATA_FIELD = 'FAVORITE_RECORD_ID' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'Quotes.SearchBasic'      ,  4, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
	end -- if;
	-- 03/20/2016 Paul.  Use billing fields so that the search will work on the html5 layout. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchAdvanced' and DATA_FIELD = 'ACCOUNT_ID' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DATA_FIELD        = 'BILLING_ACCOUNT_ID'
		     , DISPLAY_FIELD     = 'BILLING_ACCOUNT_NAME'
		     , DATE_MODIFIED     = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Quotes.SearchAdvanced'
		   and DATA_FIELD        = 'ACCOUNT_ID'
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Quotes.SearchPopup'      , 'Quotes', 'vwQUOTES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Quotes.SearchPopup'      ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes'  , null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Quotes.SearchPopup'      ,  1, 'Quotes.LBL_ACCOUNT_NAME'                , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Quotes.SearchPopup'      ,  0, 'Quotes.LBL_NAME'                        , 'NAME'                       , 0, null,  50, 25, 'Quotes', null;
	exec dbo.spEDITVIEWS_FIELDS_CnvAutoComplete 'Quotes.SearchPopup'      ,  1, 'Quotes.LBL_ACCOUNT_NAME'                , 'ACCOUNT_NAME'               , 0, null, 150, 25, 'Accounts', null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Threads.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Threads.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Threads.SearchBasic'     , 'Threads', 'vwTHREADS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Threads.SearchBasic'     ,  0, 'Threads.LBL_TITLE'                      , 'TITLE'                      , 0, null, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Threads.SearchBasic'     ,  1, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Threads.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Threads.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Threads.SearchPopup'     , 'Threads', 'vwTHREADS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Threads.SearchPopup'     ,  0, 'Threads.LBL_TITLE'                      , 'TITLE'                      , 0, null, 150, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Threads.SearchPopup'     ,  1, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
end -- if;
GO

-- 05/15/2016 Paul.  Add tags to advanced search. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchAdvanced';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS KBDocuments.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'KBDocuments.SearchAdvanced', 'KBDocuments', 'vwKBDOCUMENTS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'KBDocuments.SearchAdvanced',  0, 'KBDocuments.LBL_DESCRIPTION'            , 'DESCRIPTION'                , 0, null, 150, 80, 3;
--	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'KBDocuments.SearchAdvanced',  1, 'KBDocuments.LBL_SEARCH_WITHIN'          , 'SEARCH_WITHIN'              , 0, null, 'kbdocument_search_dom'   , null, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'KBDocuments.SearchAdvanced',  1, 'KBDocuments.LBL_NAME'                   , 'NAME'                       , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'KBDocuments.SearchAdvanced',  2, 0, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'KBDocuments.SearchAdvanced',  3, 'KBDocuments.LBL_STATUS'                 , 'STATUS'                     , 0, null, 'kbdocument_status_dom'   , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'KBDocuments.SearchAdvanced',  4, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'TEAM_NAME'               , 'Teams', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'KBDocuments.SearchAdvanced',  5, 'KBDocuments.LBL_KBDOC_APPROVER_ID'      , 'KBDOC_APPROVER_ID'          , 0, null, 'KBDOC_APPROVER_NAME'     , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'KBDocuments.SearchAdvanced',  6, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'ASSIGNED_TO_NAME'        , 'Users', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'KBDocuments.SearchAdvanced',  7, 'KBDocuments.LBL_ACTIVE_DATE'            , 'ACTIVE_DATE'                , 0, null, 'DateRange'               , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'KBDocuments.SearchAdvanced',  8, 'KBDocuments.LBL_EXP_DATE'               , 'EXP_DATE'                   , 0, null, 'DateRange'               , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'KBDocuments.SearchAdvanced',  9, 'KBDocuments.LBL_IS_EXTERNAL_ARTICLE'    , 'IS_EXTERNAL_ARTICLE'        , 0, null, 'CheckBox'                , null, null, null;
end else begin
	-- 05/15/2016 Paul.  Add tags to advanced search. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchAdvanced' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		exec dbo.spEDITVIEWS_FIELDS_CnvTagSelect    'KBDocuments.SearchAdvanced',  2, 0, null;
	end -- if;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS KBDocuments.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'KBDocuments.SearchBasic'   , 'KBDocuments', 'vwKBDOCUMENTS_List', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'KBDocuments.SearchBasic'   ,  0, 'KBDocuments.LBL_DESCRIPTION'            , 'DESCRIPTION'                , 0, null, 150, 80, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'KBDocuments.SearchBasic'   ,  1, null;
--	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'KBDocuments.SearchBasic'   ,  1, 'KBDocuments.LBL_SEARCH_WITHIN'          , 'SEARCH_WITHIN'              , 0, null, 'kbdocument_search_dom'   , null, 3;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'KBDocuments.SearchBasic'   ,  2, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end else begin
	-- 12/29/2016 Paul.  Need to prevent duplicate fields.  
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchBasic' and DATA_FIELD = 'FAVORITE_RECORD_ID' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'KBDocuments.SearchBasic'   ,  2, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
	end -- if;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchPopup';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBDocuments.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS KBDocuments.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'KBDocuments.SearchPopup'   , 'KBDocuments', 'vwKBDOCUMENTS_List', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'KBDocuments.SearchPopup'   ,  0, ''                                       , 'DESCRIPTION'                , 0, null, 150, 80, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'KBDocuments.SearchPopup'   ,  1, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'KBTags.SearchPopup';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'KBTags.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS KBTags.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'KBTags.SearchPopup'        , 'KBTags', 'vwKBTAGS_List', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'KBTags.SearchPopup'        ,  0, 'KBTags.LBL_FULL_TAG_NAME'               , 'FULL_TAG_NAME'              , 0, null, 100, 80, null;
end -- if;
GO

-- 02/22/2017 Paul.  Convert to ctlSearchView. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Teams.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Teams.SearchBasic'         , 'Teams', 'vwTEAMS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Teams.SearchBasic'         ,  0, 'Teams.LBL_NAME'                         , 'NAME'                       , 0, null, 100, 80, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Teams.SearchBasic'         ,  1, 'Teams.LBL_PRIVATE'                      , 'PRIVATE'                    , 0, null, 'team_private_dom', null, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Teams.SearchBasic'         ,  2, 'Teams.LBL_PARENT_NAME'                  , 'PARENT_ID'                  , 0, null, 'PARENT_NAME', 'Teams', null;
		update EDITVIEWS
		   set DATA_COLUMNS      = 3
		     , LABEL_WIDTH       = '11%'
		     , FIELD_WIDTH       = '22%'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where NAME              = 'Teams.SearchBasic'
		   and DATA_COLUMNS      = 1
		   and DELETED           = 0;
end -- if;
GO

-- 12/01/2009 Paul.  Add Teams search field. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.SearchPopup';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Teams.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Teams.SearchPopup'         , 'Teams', 'vwTEAMS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Teams.SearchPopup'         ,  0, 'Teams.LBL_NAME'                         , 'NAME'                       , 0, null, 100, 80, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Teams.SearchPopup'         ,  1, 'Teams.LBL_PRIVATE'                      , 'PRIVATE'                    , 0, null, 'team_private_dom', null, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Teams.SearchPopup'         ,  2, 'Teams.LBL_PARENT_NAME'                  , 'PARENT_ID'                  , 0, null, 'PARENT_NAME', 'Teams', null;
end else begin
	if exists(select * from EDITVIEWS where NAME = 'Teams.SearchPopup' and DATA_COLUMNS = 1 and DELETED = 0) begin -- then
		update EDITVIEWS
		   set DATA_COLUMNS      = 3
		     , LABEL_WIDTH       = '11%'
		     , FIELD_WIDTH       = '22%'
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where NAME              = 'Teams.SearchPopup'
		   and DATA_COLUMNS      = 1
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Teams.SearchPopup'         ,  1, 'Teams.LBL_PRIVATE'                      , 'PRIVATE'                    , 0, null, 'team_private_dom', null, 2;
		exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Teams.SearchPopup'         ,  2, 'Teams.LBL_PARENT_NAME'                  , 'PARENT_ID'                  , 0, null, 'PARENT_NAME', 'Teams', null;
	end -- if;
end -- if;
GO

-- 04/12/2016 Paul.  Add ZipCode search. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.SearchPopupZipCode';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Teams.SearchPopupZipCode' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Teams.SearchPopupZipCode';
	exec dbo.spEDITVIEWS_InsertOnly             'Teams.SearchPopupZipCode'  , 'Teams', 'vwTEAMS_ZIPCODES_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Teams.SearchPopupZipCode'  ,  0, 'Teams.LBL_NAME'                         , 'NAME'                       , 0, null, 100, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Teams.SearchPopupZipCode'  ,  1, 'ZipCodes.LBL_LIST_ZIPCODE'              , 'ZIPCODE'                    , 0, null, 100, 35, null;
end -- if;
GO

-- 01/20/2010 Paul.  Add ability to search the new Audit Events table. 
-- 03/28/2019 Paul.  Move AuditEvents.SearchBasic to default file for Community edition. 


-- 04/09/2011 Paul.  Change the field to a hidden field so that we can add Report Parameters. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.SearchDashlet';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.SearchDashlet' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Reports.SearchDashlet';
	exec dbo.spEDITVIEWS_InsertOnly             'Reports.SearchDashlet'     , 'Reports', 'vwREPORTS_List', '15%', '85%', 1;
--	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Reports.SearchDashlet'     ,  0, 'Reports.LBL_REPORT_NAME'                , 'ID'                         , 1, null, 'Reports'            , null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Reports.SearchDashlet'     ,  0, null                                     , 'ID'                         , 0, null, 'Hidden'             , null, null, null;
end else begin
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.SearchDashlet' and FIELD_TYPE = 'ListBox' and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = 'Reports.SearchDashlet'
		   and FIELD_TYPE        = 'ListBox'
		   and DELETED           = 0;
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'Reports.SearchDashlet'     ,  0, null                                     , 'ID'                         , 0, null, 'Hidden'             , null, null, null;
	end -- if;
end -- if;
GO

-- 06/23/2010 Paul.  Add support for report searching. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Reports.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Reports.SearchBasic'     , 'Reports', 'vwREPORTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Reports.SearchBasic'     ,  0, 'Reports.LBL_REPORT_NAME'                  , 'NAME'                       , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Reports.SearchBasic'     ,  1, '.LBL_CURRENT_USER_FILTER'                 , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox'    , 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'Reports.SearchBasic'     ,  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Reports.SearchBasic'     ,  3, 'Reports.LBL_MODULE_NAME'                  , 'MODULE_NAME'                , 0, null, 'Modules'     , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Reports.SearchBasic'     ,  4, '.LBL_ASSIGNED_TO'                         , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser', null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Reports.SearchBasic'     ,  5, 'Teams.LBL_TEAM'                           , 'TEAM_ID'                    , 0, null, 'Teams'       , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Reports.SearchBasic'     ,  6, '.LBL_FAVORITES_FILTER'                    , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end else begin
	-- 12/29/2016 Paul.  Need to prevent duplicate fields.  
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.SearchBasic' and DATA_FIELD = 'FAVORITE_RECORD_ID' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'Reports.SearchBasic'     ,  6, '.LBL_FAVORITES_FILTER'                    , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
	end -- if;
end -- if;
GO

-- 08/18/2019 Paul.  React Client needs separate panel. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportDesigner.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ReportDesigner.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ReportDesigner.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'ReportDesigner.SearchBasic', 'ReportDesigner', 'vwREPORTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ReportDesigner.SearchBasic',  0, 'Reports.LBL_REPORT_NAME'                  , 'NAME'                       , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'ReportDesigner.SearchBasic',  1, '.LBL_CURRENT_USER_FILTER'                 , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox'    , 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'ReportDesigner.SearchBasic',  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'ReportDesigner.SearchBasic',  3, 'Reports.LBL_MODULE_NAME'                  , 'MODULE_NAME'                , 0, null, 'Modules'     , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'ReportDesigner.SearchBasic',  4, '.LBL_ASSIGNED_TO'                         , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser', null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'ReportDesigner.SearchBasic',  5, 'Teams.LBL_TEAM'                           , 'TEAM_ID'                    , 0, null, 'Teams'       , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'ReportDesigner.SearchBasic',  6, '.LBL_FAVORITES_FILTER'                    , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end -- if;
GO

-- 07/12/2010 Paul.  Add support for report searching. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.SearchPopup';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Reports.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Reports.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Reports.SearchPopup'     , 'Reports', 'vwREPORTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Reports.SearchPopup'     ,  0, 'Reports.LBL_REPORT_NAME'                  , 'NAME'                       , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Reports.SearchPopup'     ,  1, '.LBL_ASSIGNED_TO'                         , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser', null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Reports.SearchPopup'     ,  2, 'Teams.LBL_TEAM'                           , 'TEAM_ID'                    , 0, null, 'Teams'       , null, 6;
end -- if;
GO

-- 11/04/2010 Paul.  Add dashlets for Quotes, Orders and Invoices. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchHome';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Invoices.SearchHome' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Invoices.SearchHome';
	exec dbo.spEDITVIEWS_InsertOnly             'Invoices.SearchHome'     , 'Invoices', 'vwINVOICES_MyList', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Invoices.SearchHome'     ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'        , null, 4;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Invoices.SearchHome'     ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'Teams'               , null, 4;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchHome';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Orders.SearchHome' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Orders.SearchHome';
	exec dbo.spEDITVIEWS_InsertOnly             'Orders.SearchHome'       , 'Orders', 'vwORDERS_MyList', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Orders.SearchHome'       ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'        , null, 4;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Orders.SearchHome'       ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'Teams'               , null, 4;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchHome';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Quotes.SearchHome' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Quotes.SearchHome';
	exec dbo.spEDITVIEWS_InsertOnly             'Quotes.SearchHome'       , 'Quotes', 'vwQUOTES_MyList', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Quotes.SearchHome'       ,  0, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'        , null, 4;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Quotes.SearchHome'       ,  1, 'Teams.LBL_TEAM'                         , 'TEAM_ID'                    , 0, null, 'Teams'               , null, 4;
end -- if;
GO

-- 10/29/2011 Paul.  Add charts. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Charts.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Charts.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Charts.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Charts.SearchBasic'      , 'Charts', 'vwCHARTS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Charts.SearchBasic'      ,  0, 'Charts.LBL_CHART_NAME'                    , 'NAME'                       , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Charts.SearchBasic'      ,  1, '.LBL_CURRENT_USER_FILTER'                 , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox'    , 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'Charts.SearchBasic'      ,  2, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Charts.SearchBasic'      ,  3, 'Reports.LBL_MODULE_NAME'                  , 'MODULE_NAME'                , 0, null, 'Modules'     , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Charts.SearchBasic'      ,  4, '.LBL_ASSIGNED_TO'                         , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser', null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Charts.SearchBasic'      ,  5, 'Teams.LBL_TEAM'                           , 'TEAM_ID'                    , 0, null, 'Teams'       , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Charts.SearchBasic'      ,  6, '.LBL_FAVORITES_FILTER'                    , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end else begin
	-- 12/29/2016 Paul.  Need to prevent duplicate fields.  
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Charts.SearchBasic' and DATA_FIELD = 'FAVORITE_RECORD_ID' and DELETED = 0) begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsControl      'Charts.SearchBasic'      ,  6, '.LBL_FAVORITES_FILTER'                    , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
	end -- if;
end -- if;
GO

-- 05/22/2013 Paul.  Add Surveys module. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Surveys.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'Surveys.SearchAdvanced'  , 'Surveys', 'vwSURVEYS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Surveys.SearchAdvanced'  ,  0, 'Surveys.LBL_NAME'                       , 'NAME'                       , 0, null,  50, 25, 'Surveys' , null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Surveys.SearchAdvanced'  ,  1, 'Surveys.LBL_STATUS'                     , 'STATUS'                     , 0, null, 'survey_status_dom', null, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Surveys.SearchAdvanced'  ,  2, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'     , null, 6;
	exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Surveys.SearchAdvanced'  ,  3, 0, null;
end else begin
	-- 05/15/2016 Paul.  Add tags to advanced search. 
	if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.SearchAdvanced' and DATA_FIELD = 'TAG_SET_NAME') begin -- then
		exec dbo.spEDITVIEWS_FIELDS_InsTagSelect    'Surveys.SearchAdvanced'  ,  3, 0, null;
	end -- if;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Surveys.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Surveys.SearchBasic'     , 'Surveys', 'vwSURVEYS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Surveys.SearchBasic'     ,  0, 'Surveys.LBL_NAME'                       , 'NAME'                       , 0, null,  150, 25, 'Surveys', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Surveys.SearchBasic'     ,  1, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Surveys.SearchBasic'     ,  2, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.SearchPopup';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Surveys.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Surveys.SearchPopup'     , 'Surveys', 'vwSURVEYS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'Surveys.SearchPopup'     ,  0, 'Surveys.LBL_NAME'                       , 'NAME'                       , 0, null,  150, 25, 'Surveys', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Surveys.SearchPopup'     ,  1, 'Surveys.LBL_STATUS'                     , 'STATUS'                     , 0, null, 'survey_status_dom', null, 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'Surveys.SearchPopup'     ,  2, '.LBL_ASSIGNED_TO'                       , 'ASSIGNED_USER_ID'           , 0, null, 'AssignedUser'     , null, 4;
end -- if;
GO

-- 12/29/2015 Paul.  Allow searching of Survey ResultsView. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.SearchResultsView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.SearchResultsView' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Surveys.SearchResultsView';
	exec dbo.spEDITVIEWS_InsertOnly             'Surveys.SearchResultsView'    , 'Surveys', 'vwSURVEY_RESULTS', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Surveys.SearchResultsView'    ,  0, 'SurveyResults.LBL_SUBMIT_DATE'      , 'SUBMIT_DATE'                , 0, null, 'DateRange'  , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Surveys.SearchResultsView'    ,  1, 'SurveyResults.LBL_PARENT_NAME'      , 'PARENT_ID'                  , 0, null, 'PARENT_NAME', 'SurveyRespondants', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Surveys.SearchResultsView'    ,  2, 'SurveyResults.LBL_IS_COMPLETE'      , 'IS_COMPLETE'                , 0, null, 'CheckBox'   , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_UpdateOnClick    null, 'Surveys.SearchResultsView', 'PARENT_ID' , 'return RespondantPopup();';
end -- if;
GO

-- 12/29/2015 Paul.  Allow searching of Survey ResultsView. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Surveys.ResultsView';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyResults.RespondantsPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyResults.RespondantsPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'SurveyResults.RespondantsPopup', 'SurveyResults', 'vwSURVEY_RESULTS_Edit', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'SurveyResults.RespondantsPopup',  0, 'SurveyResults.LBL_SUBMIT_DATE'    , 'SUBMIT_DATE'                , 0, null, 'DateRange'  , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyResults.RespondantsPopup',  1, 'SurveyResults.LBL_PARENT_NAME'    , 'PARENT_NAME'                , 0, null, 1000, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'SurveyResults.RespondantsPopup',  2, 'SurveyResults.LBL_IS_COMPLETE'    , 'IS_COMPLETE'                , 0, null, 'CheckBox'   , null, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.SearchAdvanced';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyQuestions.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'SurveyQuestions.SearchAdvanced', 'SurveyQuestions', 'vwSURVEY_QUESTIONS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'SurveyQuestions.SearchAdvanced',  0, 'SurveyQuestions.LBL_DESCRIPTION'        , 'DESCRIPTION'                , 0, null, 1000, 25, 'SurveyQuestions', null;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'SurveyQuestions.SearchAdvanced',  1, 'SurveyQuestions.LBL_NAME'               , 'NAME'                       , 0, null,  150, 25, 'SurveyQuestions', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'SurveyQuestions.SearchAdvanced',  2, 'SurveyQuestions.LBL_QUESTION_TYPE'      , 'QUESTION_TYPE'              , 0, null, 'survey_question_type', null, 4;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyQuestions.SearchAdvanced',  3, 'SurveyQuestions.LBL_ANSWER_CHOICES'     , 'ANSWER_CHOICES'             , 0, null, 1000, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'SurveyQuestions.SearchAdvanced',  4, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'SurveyQuestions.SearchAdvanced',  5, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyQuestions.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'SurveyQuestions.SearchBasic', 'SurveyQuestions', 'vwSURVEY_QUESTIONS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'SurveyQuestions.SearchBasic'   ,  0, 'SurveyQuestions.LBL_DESCRIPTION'        , 'DESCRIPTION'                , 0, null, 1000, 25, 'SurveyQuestions', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'SurveyQuestions.SearchBasic'   ,  1, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox', 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'SurveyQuestions.SearchBasic'   ,  2, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox'    , null, null, null;
end -- if;
GO

-- 01/01/2016 Paul.  Add categories. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyQuestions.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyQuestions.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'SurveyQuestions.SearchPopup', 'SurveyResults', 'vwSURVEY_QUESTIONS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'SurveyQuestions.SearchPopup'   ,  0, 'SurveyQuestions.LBL_DESCRIPTION'        , 'DESCRIPTION'                , 0, null, 1000, 25, 'SurveyQuestions', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBoundList    'SurveyQuestions.SearchPopup'   ,  2, 'SurveyQuestions.LBL_QUESTION_TYPE'      , 'QUESTION_TYPE'              , 0, null, 'survey_question_type', null, 4;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyQuestions.SearchPopup'   ,  3, 'SurveyQuestions.LBL_CATEGORIES'         , 'CATEGORIES'                 , 0, null, 1000, 25, null;
end else begin
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyQuestions.SearchPopup'   ,  3, 'SurveyQuestions.LBL_CATEGORIES'         , 'CATEGORIES'                 , 0, null, 1000, 25, null;
	if exists(select * from EDITVIEWS where NAME = 'SurveyQuestions.SearchPopup' and DATA_COLUMNS = 2 and DELETED = 0) begin -- then
		update EDITVIEWS
		   set DATA_COLUMNS      = 3
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = null
		 where NAME              = 'SurveyQuestions.SearchPopup'
		   and DATA_COLUMNS      = 2
		   and DELETED           = 0;
	end -- if;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyResults.SearchAdvanced';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyResults.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyResults.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'SurveyResults.SearchAdvanced', 'SurveyQuestions', 'vwSURVEY_QUESTIONS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'SurveyResults.SearchAdvanced'  ,  0, 'SurveyResults.LBL_SURVEY_NAME'          , 'SURVEY_ID'                  , 0, null, 'SURVEY_NAME', 'Surveys', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'SurveyResults.SearchAdvanced'  ,  1, 'SurveyResults.LBL_SURVEY_QUESTION_NAME' , 'SURVEY_QUESTION_ID'         , 0, null, 'SURVEY_QUESTION_NAME', 'SurveyQuestions', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'SurveyResults.SearchAdvanced'  ,  2, '.LBL_DATE_MODIFIED'                     , 'DATE_MODIFIED'              , 0, null, 'DateRange'  , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyResults.SearchAdvanced'  ,  3, 'SurveyResults.LBL_ANSWER_TEXT'          , 'ANSWER_TEXT'                , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyResults.SearchAdvanced'  ,  4, 'SurveyResults.LBL_COLUMN_TEXT'          , 'COLUMN_TEXT'                , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyResults.SearchAdvanced'  ,  5, 'SurveyResults.LBL_MENU_TEXT'            , 'MENU_TEXT'                  , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyResults.SearchAdvanced'  ,  6, 'SurveyResults.LBL_OTHER_TEXT'           , 'OTHER_TEXT'                 , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'SurveyResults.SearchAdvanced'  ,  7, 'SurveyResults.LBL_IS_COMPLETE'          , 'IS_COMPLETE'                , 0, null, 'CheckBox'   , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'SurveyResults.SearchAdvanced'  ,  8, 'SurveyResults.LBL_IS_ANSWERED'          , 'IS_ANSWERED'                , 0, null, 'CheckBox'   , null, null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyResults.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SurveyResults.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SurveyResults.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'SurveyResults.SearchBasic', 'SurveyQuestions', 'vwSURVEY_QUESTIONS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'SurveyResults.SearchBasic'     ,  0, 'SurveyResults.LBL_SURVEY_NAME'          , 'SURVEY_ID'                  , 0, null, 'SURVEY_NAME', 'Surveys', null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'SurveyResults.SearchBasic'     ,  1, 'SurveyResults.LBL_SURVEY_QUESTION_NAME' , 'SURVEY_QUESTION_ID'         , 0, null, 'SURVEY_QUESTION_NAME', 'SurveyQuestions', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyResults.SearchBasic'     ,  2, 'SurveyResults.LBL_OTHER_TEXT'           , 'OTHER_TEXT'                 , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyResults.SearchBasic'     ,  3, 'SurveyResults.LBL_ANSWER_TEXT'          , 'ANSWER_TEXT'                , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyResults.SearchBasic'     ,  4, 'SurveyResults.LBL_COLUMN_TEXT'          , 'COLUMN_TEXT'                , 0, null, 255, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'SurveyResults.SearchBasic'     ,  5, 'SurveyResults.LBL_MENU_TEXT'            , 'MENU_TEXT'                  , 0, null, 255, 25, null;
end -- if;
GO

-- 09/10/2013 Paul.  Add layout for Asterisk. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Asterisk.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Asterisk.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Asterisk.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Asterisk.SearchBasic', 'Asterisk', 'vwCALL_DETAIL_RECORDS', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Asterisk.SearchBasic'          ,  0, 'Asterisk.LBL_CALLERID'                  , 'CALLERID'                   , 0, null, 80, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsModulePopup  'Asterisk.SearchBasic'          ,  1, 'Asterisk.LBL_PARENT_NAME'               , 'PARENT_ID'                  , 0, null, 'PARENT_NAME', 'Calls', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'Asterisk.SearchBasic'          ,  2, 'Asterisk.LBL_START_TIME'                , 'START_TIME'                 , 0, null, 'DateRange'          , null, null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Asterisk.SearchBasic'          ,  3, 'Asterisk.LBL_SOURCE'                    , 'SOURCE'                     , 0, null, 80, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Asterisk.SearchBasic'          ,  4, 'Asterisk.LBL_DESTINATION'               , 'DESTINATION'                , 0, null, 80, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Asterisk.SearchBasic'          ,  5, 'Asterisk.LBL_DISPOSITION'               , 'DISPOSITION'                , 0, null, 80, 25, null;
end -- if;
GO

-- 10/26/2013 Paul.  Add TwitterTracks module. 
-- 01/06/2018 Paul.  The module type was missing from auto complete. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS TwitterTracks.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'TwitterTracks.SearchBasic', 'TwitterTracks', 'vwTWITTER_TRACKS_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'TwitterTracks.SearchBasic'     ,  0, 'TwitterTracks.LBL_NAME'                 , 'NAME'                       , 0, null, 60, 25, 'TwitterTracks', null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank        'TwitterTracks.SearchBasic'     ,  1, null;
end else begin
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.SearchBasic' and DATA_FIELD = 'NAME' and FIELD_TYPE = 'ModuleAutoComplete' and MODULE_TYPE is null and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set MODULE_TYPE      = 'TwitterTracks'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'TwitterTracks.SearchBasic'
		   and DATA_FIELD       = 'NAME'
		   and FIELD_TYPE       = 'ModuleAutoComplete'
		   and MODULE_TYPE      is null
		   and DELETED          = 0;
	end -- if;
end -- if;
GO

-- 01/06/2018 Paul.  The module type was missing from auto complete. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.SearchAdvanced';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.SearchAdvanced' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS TwitterTracks.SearchAdvanced';
	exec dbo.spEDITVIEWS_InsertOnly             'TwitterTracks.SearchAdvanced', 'TwitterTracks', 'vwTWITTER_TRACKS_List', '11%', '22%', 3;
	exec dbo.spEDITVIEWS_FIELDS_InsAutoComplete 'TwitterTracks.SearchAdvanced'  ,  0, 'TwitterMessages.LBL_NAME'               , 'NAME'                       , 0, null, 60, 25, 'TwitterTracks', null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'TwitterTracks.SearchAdvanced'  ,  1, '.LBL_CURRENT_USER_FILTER'               , 'CURRENT_USER_ONLY'          , 0, null, 'CheckBox' , 'return ToggleUnassignedOnly();', null, null;
	exec dbo.spEDITVIEWS_FIELDS_InsControl      'TwitterTracks.SearchAdvanced'  ,  2, '.LBL_FAVORITES_FILTER'                  , 'FAVORITE_RECORD_ID'         , 0, null, 'CheckBox' , null, null, null;
end else begin
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'TwitterTracks.SearchAdvanced' and DATA_FIELD = 'NAME' and FIELD_TYPE = 'ModuleAutoComplete' and MODULE_TYPE is null and DELETED = 0) begin -- then
		update EDITVIEWS_FIELDS
		   set MODULE_TYPE      = 'TwitterTracks'
		     , DATE_MODIFIED    = getdate()
		     , MODIFIED_USER_ID = null
		 where EDIT_NAME        = 'TwitterTracks.SearchAdvanced'
		   and DATA_FIELD       = 'NAME'
		   and FIELD_TYPE       = 'ModuleAutoComplete'
		   and MODULE_TYPE      is null
		   and DELETED          = 0;
	end -- if;
end -- if;
GO

-- 02/22/2017 Paul.  Need searching of Regions. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Regions.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Regions.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'Regions.SearchBasic'         , 'Regions', 'vwREGIONS', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Regions.SearchBasic'         ,  0, 'Regions.LBL_NAME'                     , 'NAME'                        , 0, null, 100, 25, null;
end -- if;
GO

if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Regions.SearchPopup' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Regions.SearchPopup';
	exec dbo.spEDITVIEWS_InsertOnly             'Regions.SearchPopup'         , 'Regions', 'vwREGIONS', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'Regions.SearchPopup'         ,  0, 'Regions.LBL_NAME'                     , 'NAME'                        , 0, null, 100, 25, null;
end -- if;
GO

-- 02/17/2018 Paul.  ModulesArchiveRules module to Professional. 
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'ModulesArchiveRules.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS ModulesArchiveRules.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly             'ModulesArchiveRules.SearchBasic', 'ModulesArchiveRules', 'vwMODULES_ARCHIVE_RULES', '15%', '85%', 1;
	exec dbo.spEDITVIEWS_FIELDS_InsBound        'ModulesArchiveRules.SearchBasic',  0, 'ModulesArchiveRules.LBL_NAME'      , 'NAME'                        , 0, null, 150, 25, null;
end -- if;
GO

-- 03/31/2021 Paul.  Add Exchange support to React Client. 
-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Exchange.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Exchange.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS Exchange.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly            'Exchange.SearchBasic', 'Exchange', 'vwUSERS_EXCHANGE', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Exchange.SearchBasic'       ,  0, 'Users.LBL_USER_NAME'                        , 'USER_NAME'            , null, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Exchange.SearchBasic'       ,  1, 'Users.LBL_NAME'                             , 'NAME'                 , null, 1, 255, 35, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBound       'Exchange.SearchBasic'       ,  2, 'Users.LBL_EMAIL1'                           , 'EMAIL1'               , null, 1, 255, 35, null;
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

call dbo.spEDITVIEWS_FIELDS_SearchProfessional()
/

call dbo.spSqlDropProcedure('spEDITVIEWS_FIELDS_SearchProfessional')
/

-- #endif IBM_DB2 */




-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:42 AM.
print 'TERMINOLOGY Shippers en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Shippers', null, null, N'Shipper List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LIST_ORDER'                           , N'en-US', N'Shippers', null, null, N'List Order';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'Shippers', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ORDER'                                , N'en-US', N'Shippers', null, null, N'List Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'Shippers', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'Shippers', null, null, N'Shippers';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Shippers', null, null, N'Shi';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'Shippers', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER'                                     , N'en-US', N'Shippers', null, null, N'Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER_DESC'                                , N'en-US', N'Shippers', null, null, N'Set the order within the list.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'Shippers', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS_DESC'                               , N'en-US', N'Shippers', null, null, N'Set to inactive to hide this item.';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_SHIPPER_LIST'                              , N'en-US', N'Shippers', null, null, N'Shippers';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_SHIPPER'                               , N'en-US', N'Shippers', null, null, N'Create Shipper';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'Shippers'                                      , N'en-US', null, N'moduleList'                        ,  73, N'Shippers';

exec dbo.spTERMINOLOGY_InsertOnly N'Active'                                        , N'en-US', null, N'shipper_status_dom'                ,   1, N'Active';
exec dbo.spTERMINOLOGY_InsertOnly N'Inactive'                                      , N'en-US', null, N'shipper_status_dom'                ,   2, N'Inactive';
GO


set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spTERMINOLOGY_Shippers_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Shippers_en_us')
/
-- #endif IBM_DB2 */

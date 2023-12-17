

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:38 AM.
print 'TERMINOLOGY Manufacturers en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'ERR_MANUFACTURER_NOT_FOUND'                    , N'en-US', N'Manufacturers', null, null, N'Manufacturer Not Found.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Manufacturers', null, null, N'Manufacturer List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LIST_ORDER'                           , N'en-US', N'Manufacturers', null, null, N'List Order';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'Manufacturers', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ORDER'                                , N'en-US', N'Manufacturers', null, null, N'List Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'Manufacturers', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'Manufacturers', null, null, N'Manufacturers';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Manufacturers', null, null, N'Man';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'Manufacturers', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER'                                     , N'en-US', N'Manufacturers', null, null, N'Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER_DESC'                                , N'en-US', N'Manufacturers', null, null, N'Set the order within the list.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'Manufacturers', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS_DESC'                               , N'en-US', N'Manufacturers', null, null, N'Set to inactive to hide this item.';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_MANUFACTURER_LIST'                         , N'en-US', N'Manufacturers', null, null, N'Manufacturers';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_MANUFACTURER'                          , N'en-US', N'Manufacturers', null, null, N'Create Manufacturer';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'Manufacturers'                                 , N'en-US', null, N'moduleList'                        ,  77, N'Manufacturers';

exec dbo.spTERMINOLOGY_InsertOnly N'Active'                                        , N'en-US', null, N'manufacturer_status_dom'           ,   1, N'Active';
exec dbo.spTERMINOLOGY_InsertOnly N'Inactive'                                      , N'en-US', null, N'manufacturer_status_dom'           ,   2, N'Inactive';
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

call dbo.spTERMINOLOGY_Manufacturers_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Manufacturers_en_us')
/
-- #endif IBM_DB2 */

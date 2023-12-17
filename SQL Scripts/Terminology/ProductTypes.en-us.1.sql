

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:41 AM.
print 'TERMINOLOGY ProductTypes en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'ERR_PRODUCT_TYPE_NOT_FOUND'                    , N'en-US', N'ProductTypes', null, null, N'Product Type Not Found.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'ProductTypes', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'ProductTypes', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'ProductTypes', null, null, N'Product Type List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LIST_ORDER'                           , N'en-US', N'ProductTypes', null, null, N'List Order';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'ProductTypes', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ORDER'                                , N'en-US', N'ProductTypes', null, null, N'List Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'ProductTypes', null, null, N'Product Types';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'ProductTypes', null, null, N'Pry';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'ProductTypes', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER'                                     , N'en-US', N'ProductTypes', null, null, N'Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER_DESC'                                , N'en-US', N'ProductTypes', null, null, N'Set the order within the list.';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_PRODUCT_TYPE'                          , N'en-US', N'ProductTypes', null, null, N'Create Product Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_PRODUCT_TYPE_LIST'                         , N'en-US', N'ProductTypes', null, null, N'Product Types';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'ProductTypes'                                  , N'en-US', null, N'moduleList'                        ,  74, N'Product Types';
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

call dbo.spTERMINOLOGY_ProductTypes_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_ProductTypes_en_us')
/
-- #endif IBM_DB2 */

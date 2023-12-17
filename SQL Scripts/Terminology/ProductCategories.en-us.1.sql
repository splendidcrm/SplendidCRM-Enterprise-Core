

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:41 AM.
print 'TERMINOLOGY ProductCategories en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'ERR_PRODUCT_CATEGORY_NOT_FOUND'                , N'en-US', N'ProductCategories', null, null, N'Product Category Not Found.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'ProductCategories', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'ProductCategories', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'ProductCategories', null, null, N'Product Category List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LIST_ORDER'                           , N'en-US', N'ProductCategories', null, null, N'List Order';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'ProductCategories', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ORDER'                                , N'en-US', N'ProductCategories', null, null, N'List Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PARENT_ID'                            , N'en-US', N'ProductCategories', null, null, N'Parent ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PARENT_NAME'                          , N'en-US', N'ProductCategories', null, null, N'Parent Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'ProductCategories', null, null, N'Product Categories';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'ProductCategories', null, null, N'PCa';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'ProductCategories', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_FORM_TITLE'                            , N'en-US', N'ProductCategories', null, null, N'Create Product Category';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER'                                     , N'en-US', N'ProductCategories', null, null, N'Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER_DESC'                                , N'en-US', N'ProductCategories', null, null, N'Set the order within the list.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT'                                    , N'en-US', N'ProductCategories', null, null, N'Parent:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_ID'                                 , N'en-US', N'ProductCategories', null, null, N'Parent ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_NAME'                               , N'en-US', N'ProductCategories', null, null, N'Parent Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'ProductCategories', null, null, N'Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_PRODUCT_CATEGORY'                      , N'en-US', N'ProductCategories', null, null, N'Create Product Category';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_PRODUCT_CATEGORIES_LIST'                   , N'en-US', N'ProductCategories', null, null, N'Product Categories List';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'ProductCategories'                             , N'en-US', null, N'moduleList'                        ,  75, N'Product Categories';
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

call dbo.spTERMINOLOGY_ProductCategories_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_ProductCategories_en_us')
/
-- #endif IBM_DB2 */

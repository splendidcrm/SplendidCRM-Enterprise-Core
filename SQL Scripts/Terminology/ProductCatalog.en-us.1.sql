

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:41 AM.
print 'TERMINOLOGY ProductCatalog en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'ERR_MAXIMUM_OPTIONS'                           , N'en-US', N'ProductCatalog', null, null, N'Too many options have been selected.';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_MINIMUM_OPTIONS'                           , N'en-US', N'ProductCatalog', null, null, N'Not enough options have been selected.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'ProductCatalog', null, null, N'Product Catalog';
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

call dbo.spTERMINOLOGY_ProductCatalog_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_ProductCatalog_en_us')
/
-- #endif IBM_DB2 */

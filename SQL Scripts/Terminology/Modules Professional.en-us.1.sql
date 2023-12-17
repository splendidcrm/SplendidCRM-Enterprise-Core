

-- Terminology generated from database [SplendidCRM5_50] on 11/18/2010 1:19:38 AM.
print 'TERMINOLOGY Modules Professional en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'Contracts'                                     , N'en-US', null, N'record_type_display'               ,  13, N'Contract';
exec dbo.spTERMINOLOGY_InsertOnly N'Products'                                      , N'en-US', null, N'record_type_display'               ,  14, N'Product';
exec dbo.spTERMINOLOGY_InsertOnly N'Quotes'                                        , N'en-US', null, N'record_type_display'               ,  15, N'Quote';
exec dbo.spTERMINOLOGY_InsertOnly N'Orders'                                        , N'en-US', null, N'record_type_display'               ,  16, N'Order';
exec dbo.spTERMINOLOGY_InsertOnly N'Invoices'                                      , N'en-US', null, N'record_type_display'               ,  17, N'Invoice';
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

call dbo.spTERMINOLOGY_Modules_Professional_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Modules_Professional_en_us')
/
-- #endif IBM_DB2 */

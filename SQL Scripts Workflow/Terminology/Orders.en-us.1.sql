

print 'TERMINOLOGY Orders en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'Monthly'        , N'en-US', null, N'billing_frequency_dom', 1, N'Monthly'   ;
exec dbo.spTERMINOLOGY_InsertOnly N'Yearly'         , N'en-US', null, N'billing_frequency_dom', 2, N'Yearly'    ;
exec dbo.spTERMINOLOGY_InsertOnly N'Quarterly'      , N'en-US', null, N'billing_frequency_dom', 3, N'Quarterly' ;
exec dbo.spTERMINOLOGY_InsertOnly N'Bi-Monthly'     , N'en-US', null, N'billing_frequency_dom', 4, N'Bi-Monthly';
exec dbo.spTERMINOLOGY_InsertOnly N'Bi-Yearly'      , N'en-US', null, N'billing_frequency_dom', 5, N'Bi-Yearly' ;
exec dbo.spTERMINOLOGY_InsertOnly N'Weekly'         , N'en-US', null, N'billing_frequency_dom', 6, N'Weekly'    ;

exec dbo.spTERMINOLOGY_InsertOnly N'One Time Charge', N'en-US', null, N'billing_type_dom'     , 1, N'One Time Charge';
exec dbo.spTERMINOLOGY_InsertOnly N'Repeat'         , N'en-US', null, N'billing_type_dom'     , 2, N'Repeat'         ;

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

call dbo.spTERMINOLOGY_Orders_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Orders_en_us')
/
-- #endif IBM_DB2 */



print 'TERMINOLOGY PaymentTypes en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'PaymentTypes', null, null, N'Payment Type List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LIST_ORDER'                           , N'en-US', N'PaymentTypes', null, null, N'List Order';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'PaymentTypes', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ORDER'                                , N'en-US', N'PaymentTypes', null, null, N'List Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'PaymentTypes', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'PaymentTypes', null, null, N'Payment Types';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'PaymentTypes', null, null, N'PTy';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'PaymentTypes', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER'                                     , N'en-US', N'PaymentTypes', null, null, N'Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER_DESC'                                , N'en-US', N'PaymentTypes', null, null, N'Set the order within the list.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'PaymentTypes', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS_DESC'                               , N'en-US', N'PaymentTypes', null, null, N'Set to inactive to hide this item.';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_PAYMENT_TYPE_LIST'                         , N'en-US', N'PaymentTypes', null, null, N'Payment Types';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_PAYMENT_TYPE'                          , N'en-US', N'PaymentTypes', null, null, N'Create Payment Type';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER
exec dbo.spTERMINOLOGY_InsertOnly N'PaymentTypes'                                  , N'en-US', null, N'moduleList'             , 135, N'Payment Types';
exec dbo.spTERMINOLOGY_InsertOnly N'Active'                                        , N'en-US', null, N'payment_type_status_dom',   1, N'Active';
exec dbo.spTERMINOLOGY_InsertOnly N'Inactive'                                      , N'en-US', null, N'payment_type_status_dom',   2, N'Inactive';
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

call dbo.spTERMINOLOGY_PaymentTypes_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_PaymentTypes_en_us')
/
-- #endif IBM_DB2 */

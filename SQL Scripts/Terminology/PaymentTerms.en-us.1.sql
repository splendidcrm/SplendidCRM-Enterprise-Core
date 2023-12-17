

print 'TERMINOLOGY PaymentTerms en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'PaymentTerms', null, null, N'Payment Term List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LIST_ORDER'                           , N'en-US', N'PaymentTerms', null, null, N'List Order';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'PaymentTerms', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ORDER'                                , N'en-US', N'PaymentTerms', null, null, N'List Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'PaymentTerms', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'PaymentTerms', null, null, N'Payment Terms';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'PaymentTerms', null, null, N'PTe';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'PaymentTerms', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER'                                     , N'en-US', N'PaymentTerms', null, null, N'Order:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORDER_DESC'                                , N'en-US', N'PaymentTerms', null, null, N'Set the order within the list.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'PaymentTerms', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS_DESC'                               , N'en-US', N'PaymentTerms', null, null, N'Set to inactive to hide this item.';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_PAYMENT_TERM_LIST'                         , N'en-US', N'PaymentTerms', null, null, N'Payment Terms';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_PAYMENT_TERM'                          , N'en-US', N'PaymentTerms', null, null, N'Create Payment Term';

-- select * from vwTERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER
exec dbo.spTERMINOLOGY_InsertOnly N'PaymentTerms'                                  , N'en-US', null, N'moduleList'             , 136, N'Payment Terms';

-- 04/06/2019 Paul.  REACT client is case significant, so make list name lowercase.
if exists(select * from TERMINOLOGY where (LIST_NAME collate SQL_Latin1_General_CP1_CS_AS) = 'payment_Term_status_dom' and DELETED = 0) begin -- then
	update TERMINOLOGY
	   set LIST_NAME         = 'payment_term_status_dom'
	     , DATE_MODIFIED     = getdate()
	     , DATE_MODIFIED_UTC = getutcdate()
	 where (LIST_NAME collate SQL_Latin1_General_CP1_CS_AS) = 'payment_Term_status_dom'
	   and DELETED           = 0;
end -- if;

exec dbo.spTERMINOLOGY_InsertOnly N'Active'                                        , N'en-US', null, N'payment_term_status_dom',   1, N'Active';
exec dbo.spTERMINOLOGY_InsertOnly N'Inactive'                                      , N'en-US', null, N'payment_term_status_dom',   2, N'Inactive';
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

call dbo.spTERMINOLOGY_PaymentTerms_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_PaymentTerms_en_us')
/
-- #endif IBM_DB2 */
